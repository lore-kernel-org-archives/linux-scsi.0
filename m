Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD0D3B7A8;
	Tue, 25 Jun 2024 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350494; cv=none; b=iwDxm5u40aP8vnNzLl73PTw5Mb7kpol+RnFlrtWpAPWzN+V+O2sOQhZXrFvMkxKZrief3VEhOp/Ay+vsJm2n8oFqaJ8xj3gf99f8OCXo6VPbH5m2hGKtHtAC3o2BptniFEgZsBZQv68WvjLD3iKGPN0BhAlDnt+fzbexft2Yb2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350494; c=relaxed/simple;
	bh=73NJSHUL6lXPCtxi8rByeT4umL7oixSsSplTdicKoro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QgvbA0xDgFf/zkBqiHWu5nFjwDLc1knpZtpdrD1ZAQ8f4jgugPezMPA+9+tus3geiK//0a5hyrYjJeasmwqAx+aQH99QbpPDyn1OnXTQ+VemGMwLsbXrvFApfZgJreluzDbY7dDOklM3sFnhBPwVZToyMa76e8cFOT/klo0qwcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCrJOyD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCrJOyD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697CDC32781;
	Tue, 25 Jun 2024 21:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719350494;
	bh=73NJSHUL6lXPCtxi8rByeT4umL7oixSsSplTdicKoro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lCrJOyD9/G3GDqzVQ0E1GwsF1htspicltsQTLKumQpQhlq3C7TjOTTmViM80YX88u
	 gV7VEtKuexSW+0FPkOKJ4iZVL/MPL/OPUJVUnut/Skx1Cnu2sKA8sxRNou2qDrWS/O
	 zEUs1dfu0Wcabdjnf1KaK/mze7G0gDArjExFK64jSPcFiayl3/gVLsrATI3uRgfH4t
	 rrD4M59sWO+lH/LDsRkao13c57KF9IvJw6WauEC/hQJXjXW/HiSz59m6S07Iq58Ac2
	 1TiNS5DmAIZbYcy+eM+y7HfX5g15yYsQiBudFZk9Fw+QXkhy5Qd267BRrKR6j3MvTI
	 cntqYFj5F1MdQ==
Message-ID: <2ee02eff-b996-4f8e-b836-cd5f07ec7136@kernel.org>
Date: Wed, 26 Jun 2024 06:21:31 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] md: set md-specific flags for all queue limits
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240625145955.115252-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 23:59, Christoph Hellwig wrote:
> The md driver wants to enforce a number of flags to an all devices, even

s/to an/for

> when not inheriting them from the underlying devices.  To make sure these
> flags survive the queue_limits_set calls that md uses to update the
> queue limits without deriving them form the previous limits add a new
> md_init_stacking_limits helper that calls blk_set_stacking_limits and sets
> these flags.
> 
> Fixes: 1122c0c1cc71 ("block: move cache control settings out of queue->flags")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Other than the above nit, looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

