Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEE521CFF7;
	Thu, 10 Jul 2025 04:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752123028; cv=none; b=W/7WcPkBpnWcU4oGbnt1ZCyA27BnntnZ5KLIGuwGGgtz/Uj8ziw0fz5UFXKhcNQUTW8AGmnehjzzsAxRolkEdUh95J2AHWYdMZtf16gQ9q6MQbjQUCqd2h9WjjJpi7SXPgyfvnxf0hG/ZfHU57DspvXc0p/qg+0Dio58o8aCSBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752123028; c=relaxed/simple;
	bh=pJejgL9mXZy+1/mI/tBlWGuHI1KSKfgak/PYw9yVlr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=heXBKFPAtY8uyemzlcB60xsRtjLs8Rzk1hOYbf0XblIZo/1m/lVZ9iaaymzXAQlmcqXx30qV0Ce7V46dMiDoqJl+YXFBjUO7wkagPpfH6281CrqabmE4v/B3ZEytv6nNI9hVN8DZG5n/oG7GZsft3Nq283Y1isT2mGCwiOpQ+9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2uUmxbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2uUmxbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1070BC4CEE3;
	Thu, 10 Jul 2025 04:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752123027;
	bh=pJejgL9mXZy+1/mI/tBlWGuHI1KSKfgak/PYw9yVlr0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q2uUmxbV1kfYKkmxTahdytNZvDNQixCaBtoNrWweTt7CPMeu+g4ztmQI6EQz45hhI
	 yinParwvjrw9xsuPoXX3vhDCfreocxWaUS4YJrf+TDjMTkAsYdJG4TQEfx0yzn5KGj
	 liqnt4R6RL3nshy6ZqNsA8umJKqjpR7AqdtyDxhxcPxPW8XuRyMRxXdTbjTrKizXd5
	 ryqkYZ54ECj/dV904eFXME9elUNbQP3jTZ5XHv8wphrrbcIz45zeJuDGBAwrX7dgTR
	 Q9AtuV5n3TqyO7Q2RgJ0/5gCs9lBb7KNRci7FTl8bnf5NY3tk3XNKwPuWBs+2/iZXD
	 2fK9pK2xZT3vg==
Message-ID: <9323ce84-781c-4ff5-aeaf-10afffea5a12@kernel.org>
Date: Thu, 10 Jul 2025 13:48:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 06/13] blk-zoned: Split blk_zone_wplug_bio_work()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-7-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250708220710.3897958-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 7:07 AM, Bart Van Assche wrote:
> Prepare for submitting multiple bios from inside a single
> blk_zone_wplug_bio_work() call. No functionality has been changed.

The patch title says "Split blk_zone_wplug_bio_work()" but you do not explain
what you split into what.

Other than this, looks OK to me.

-- 
Damien Le Moal
Western Digital Research
