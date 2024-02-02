Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B367117BA8;
	Fri,  2 Feb 2024 07:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859424; cv=none; b=Mzy1+dbnJnTTi4ViCheTQkLliMoksCUpPK6qJwvKlxGtGLOQ4XaDvE/cG1wCgZGZ45/mdk2gOGmiW3VT1znYbYksIhm9NB4fv5CD3rtac9182NDmJzvbkHAHYChN44GQO6fytuH1rZ+kxkWUo/eFOa7YjDz+OWtXuDS51MXXd44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859424; c=relaxed/simple;
	bh=83WGbh1aToa6xi3fv5tKlsygqJtHRUyxX2N/eR8Pm00=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GOsr22dYu7LnVmHVbDg1TZiJAPl/R6qdcTsNpBGYximGiT0+THVB2a3XUamNlFDDEwpsFicEax5//gg0h8wCjavOzFb2MZtPsHnwMvCIuJLiAD0+7CTTL3zNB5VYS8njkaeB9fvqyqrM/730GYwf90GKFMZPK+zlxrF5gK9A9/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBofjTGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBofjTGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61B4C433F1;
	Fri,  2 Feb 2024 07:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859424;
	bh=83WGbh1aToa6xi3fv5tKlsygqJtHRUyxX2N/eR8Pm00=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=hBofjTGvqJqMfDFMCUncIls9Rf45LctEb+HRwieN9UfdYIQCKL23EdENkpPpjuciQ
	 DVA3lQVZMfZXihQ2gzu3VYnZZMmJVm9yCR/K+zPQc/gZ0fHnIt99l4Wnk2gw/hAph2
	 mxyvGhhgjbmF1MvIaMXVRo+X++fxxjV1UfguyiaM8vtSGh+PwJK+r5xeLKxWKzqbxe
	 wQ+W4/NE38zCGK+QQhOBUW04W+A/whbEzT+lMwNRZn9+ZZybUHPVjG0Z4Yh8pzhxgO
	 NYo736ACYzrS7Ai84UF5YaoFS1vH2ZreZUglze5ss/mBnXYhZL9/ymxuABRxwt3QQc
	 qBvOAwKkgJ19Q==
Message-ID: <147de7c4-7050-4b1d-a48c-c0316a81baee@kernel.org>
Date: Fri, 2 Feb 2024 16:37:01 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/24 16:30, Damien Le Moal wrote:
> The patch series introduces zone write plugging (ZWP) as the new
> mechanism to control the ordering of writes to zoned block devices.
> ZWP replaces zone write locking (ZWL) which is implemented only by
> mq-deadline today. ZWP also allows emulating zone append operations
> using regular writes for zoned devices that do not natively support this
> operation (e.g. SMR HDDs). This patch series removes the scsi disk
> driver and device mapper zone append emulation to use ZWP emulation.
> 
> Unlike ZWL which operates on requests, ZWP operates on BIOs. A zone
> write plug is simply a BIO list that is atomically manipulated using a
> spinlock and a kblockd submission work. A write BIO to a zone is
> "plugged" to delay its execution if a write BIO for the same zone was
> already issued, that is, if a write request for the same zone is being
> executed. The next plugged BIO is unplugged and issued once the write
> request completes.
> 
> This mechanism allows to:
>  - Untangle zone write ordering from the block IO schedulers. This
>    allows removing the restriction on using only mq-deadline for zoned
>    block devices. Any block IO scheduler, including "none" can be used.
>  - Zone write plugging operates on BIOs instead of requests. Plugged
>    BIOs waiting for execution thus do not hold scheduling tags and thus
>    do not prevent other BIOs from being submitted to the device (reads
>    or writes to other zones). Depending on the workload, this can
>    significantly improve the device use and the performance.
>  - Both blk-mq (request) based zoned devices and BIO-based devices (e.g.
>    device mapper) can use ZWP. It is mandatory for the
>    former but optional for the latter: BIO-based driver can use zone
>    write plugging to implement write ordering guarantees, or the drivers
>    can implement their own if needed.
>  - The code is less invasive in the block layer and in device drivers.
>    ZWP implementation is mostly limited to blk-zoned.c, with some small
>    changes in blk-mq.c, blk-merge.c and bio.c.
> 
> Performance evaluation results are shown below.
> 
> The series is organized as follows:

I forgot to mention that the patches are against Jens block/for-next branch with
the addition of Christoph's "clean up blk_mq_submit_bio" patches [1] and my
patch "null_blk: Always split BIOs to respect queue limits" [2].

[1] https://lore.kernel.org/linux-block/20240124092658.2258309-1-hch@lst.de/
[2] https://lore.kernel.org/linux-block/20240126005032.1985245-1-dlemoal@kernel.org/


-- 
Damien Le Moal
Western Digital Research

