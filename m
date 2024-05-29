Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA4F1A0B0A;
	Wed, 29 May 2024 08:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716969915; cv=none; b=HC23GG7m8eM/bfieact5N2WG6ridm87bx+MagttUP9Y5xiqYNcYdkpAzfwiXHMT9jBtF4LxjOlWkIV1qVEhdy4W/1sVGrzpyOvS+Ot5tB1RHfEVvIqpknvs4kLxJiplrg5u4BbBFRG+QUoccFhzmb5D1976BkBorSOYBw/rw5xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716969915; c=relaxed/simple;
	bh=blmbzNIoOv7Q3qES0R0/fx18waY7Hk11DTOByTzWHdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RUUuuO8u4t45KotInKcM5w442SurpQMkBiYb/9APh0RelpRh+2ZInNAQ/QgXQid8wLpojrtsB1IpsLaBQZmHxMEmC8qlsIsw5AIh/YLUEtpiKzgEoo4WLQcxYg5adBp2lIEzo8Vw6ON9HKpGd+rXUgyOOCd6jC1b0hgAMoh1nsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFYbjMJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFYbjMJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3FAC2BD10;
	Wed, 29 May 2024 08:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716969914;
	bh=blmbzNIoOv7Q3qES0R0/fx18waY7Hk11DTOByTzWHdc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SFYbjMJRJ6TIxFXkpgxG4GyzyI/tGBapJQlaGBsNH35uF5q0J/+ufhABOEt5aku5A
	 OGZ/sMeIOSXH403CaXaX972OKhKJYoQKJJDBM5BKOy6U8Nl6vudfsO6HMEQn0f+nwQ
	 EEJNnQcb59MH+bO1MBxpMjGfNAxOzKZEQYEFEGgG3tXhnEMyC0CEKrwsbiSwmPGa0h
	 XlxMBzvwrj6cpKyibCWOGaP3KUxu2jy3ox/5rATAy/QYehwu9ehrekMkeR3fcUmmMZ
	 Z5STO7HCskML/36YIjpBFP0Bm0HiT4KQ6nulMQvLBqHtZ3L7qdm7OgC52ERnL5CdaG
	 wz7IMJehNc1hg==
Message-ID: <f39216c0-f11d-4d4a-ae40-b4cf82e4760e@kernel.org>
Date: Wed, 29 May 2024 17:05:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] block: take io_opt and io_min into account for
 max_sectors
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> The soft max_sectors limit is normally capped by the hardware limits and
> an arbitrary upper limit enforced by the kernel, but can be modified by
> the user.  A few drivers want to increase this limit (nbd, rbd) or
> adjust it up or down based on hardware capabilities (sd).
> 
> Change blk_validate_limits to default max_sectors to the optimal I/O
> size, or upgrade it to the preferred minimal I/O size if that is
> larger than the kernel default if no optimal I/O size is provided based
> on the logic in the SD driver.
> 
> This keeps the existing kernel default for drivers that do not provide
> an io_opt or very big io_min value, but picks a much more useful
> default for those who provide these hints, and allows to remove the
> hacks to set the user max_sectors limit in nbd, rbd and sd.
> 
> Note that rd picks a different value for the optimal I/O size vs the
> user max_sectors value, so this is a bit of a behavior change that
> could use careful review from people familiar with rbd.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

