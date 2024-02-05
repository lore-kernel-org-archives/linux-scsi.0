Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697381AB814;
	Mon,  5 Feb 2024 23:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707176900; cv=none; b=VQREeBqtZJTXMWub3pVBvz8ovb9BisjsdLk6ElasLztIXjiju6GhH6sco7nRNQsDHoIbHpYq9pl7lM+WDHyMhUCtxTLIDgY1OZMjTjRLFe1to3lCU2dnl7CGrQ/Zks1LmdITcuxj1Zk4uaZT176AZ6DSFkrqn4J5bFX4kVxqZkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707176900; c=relaxed/simple;
	bh=iG/MO+mzWTlidaCcDAu7q8QWqwIh1iuJeSg6HY/gc6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fV7TUMtVJAPqsTu1pTRQk9yxjywcCdjNU5yiGQ6TD07zio6OMP2IdwQJbMzva8cQBCDDqxKIn5lwovxE2QncWDtH345Bv22MOsoasItGZbOv1SVvbXSW42zmrdfNV4mwEgip/eNb8yB+7apB18nu83YLgPZnGlUNQE2htu9iU3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2HR0W7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2HR0W7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8446C433F1;
	Mon,  5 Feb 2024 23:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707176899;
	bh=iG/MO+mzWTlidaCcDAu7q8QWqwIh1iuJeSg6HY/gc6Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d2HR0W7OXRu7T3PSLqDoAquNrY7pgN8E9sGK/Va0OA3hAPSlau1K8giPSBYLTv440
	 HC3LGSB6ZxE+/3sNAjkfG3ARG35PMkVIb8g5eVo0ALbxadQcZfB50eO0G0XD0xoOy8
	 9sDu8XV31pbzmMU8OyMDW+T2CCWASLLC3cEsgaqFev9LajrWkOIM8ifv63q5NeeQK3
	 9ffQIVenzRceYocGYtUe5BbMI4JrXM3z1rt8Ej9uysOhpb+9v8vMKyijn7WKYv05Tx
	 u03Z1cHw02BajUqzex3FfaTTG6J1IBOtPkwSfVp+hfzhqulzfALnaQB+zHFBDh9YaT
	 rj+cs2SIM5otQ==
Message-ID: <d909a331-75c7-49e1-91fb-374e48b47543@kernel.org>
Date: Tue, 6 Feb 2024 08:48:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org>
 <12bbbfe9-6304-495b-a60b-821becd1f326@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <12bbbfe9-6304-495b-a60b-821becd1f326@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 02:48, Bart Van Assche wrote:
> On 2/1/24 23:30, Damien Le Moal wrote:
>> The next plugged BIO is unplugged and issued once the write request completes.
> 
> So this patch series is orthogonal to my patch series that implements zoned
> write pipelining?

I don't know.

>> simultaneously without lock contention.
> 
> This is not correct. Device usage is not maximized since zone write bios
> are serialized. Pipelining zoned writes results in higher device
> utilization.

I meant to say that the locking scheme does not get in the way of maximizing
device utilization/parallelism. If you are only writing to a single zone, then
sure, it does not matter since the drive will be used at qd=1 for that case.

>> +#define blk_zone_wplug_lock(zwplug, flags) \
>> +	spin_lock_irqsave(&zwplug->lock, flags)
>> +
>> +#define blk_zone_wplug_unlock(zwplug, flags) \
>> +	spin_unlock_irqrestore(&zwplug->lock, flags)
> 
> Hmm ... these macros may make code harder to read rather than improve
> readability of the code.

I do not see how they make the code less readable. The macro names are not clear
enough ?

-- 
Damien Le Moal
Western Digital Research

