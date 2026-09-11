Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F7B3A0E80;
	Fri, 11 Sep 2026 08:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789114391; cv=none; b=TmzKcDbJZb7F/RffggskuE24J62JE26jP670eeZaSHpq5UOXJiwV/A24pWREfAAjOB9+kQLp9yZYuVXEvUizQXHcdrUJp22FPieeir4kl0AHD1IYT2RtSMBVo0sYjxiiJ0uZr1xc0Df7r0nlmIWlwO76zD7/k0gE7HTPU7Q2MAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789114391; c=relaxed/simple;
	bh=E4arVKGuXaxhIk9CZqbG9rVqr72IWj/p8h5aJVjBcy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a/ieEu+uRGEZrblzCZXsEVH9T983mCGKmU/+XMjufuRudeX9oFkF2pHCIUW0haVPteVYb5HZDvESRhUJPEhAs4sYt995vReI6h0EAG+f/A+/7HhoexBejmWqTP59uoUSJZ1CuizvYvpAMikIw8mlWMpeFjL7EufNg8SgProBFqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmV9Vjl4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmV9Vjl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D402D1F00893;
	Fri, 11 Sep 2026 08:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789114389;
	bh=/QlxM1MrkWpU2A/tDFAdEI0RMi66K4VXE4QuRn1uMq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jmV9Vjl4AAX0W2/fPX4onafHL5pF1270Mu/miTFKP8bkEa5hmWUYJJYm1ni+wRT9L
	 xNxD8VL7/2nC6GMxAnJxpmFzB+oS1+ih9dQIK66HXq19LlCrRWFymZC0ZSYrUXrKLd
	 DoUZ9nO0BwTlmrC9WrnlkZ2Wj5zJqye2o7A4rwYldGRsn/L89PzR5KDGuGFeZfv2sH
	 ciHLBwYnb98dwTjeyWGZ2pksAYEzpO/JYqwwUwIMcHJl1QTk+zpmm6J/fWFDJKqvxG
	 aJUF6sQj0PZpFYwwTlGPV4jAN/fmNvCPTO8bB54lvJyKL2pESArqISLS1MmuWQdH4f
	 moBw/fuv7aPoA==
Message-ID: <afd41898-4f4b-41fd-a852-e97032773eab@kernel.org>
Date: Fri, 11 Sep 2026 17:13:07 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] block: fix zones_cond out-of-bounds write on zone
 report
To: ZHOU Jiaxiang <26066541r@connect.polyu.hk>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org
References: <20260911041129.128280-1-26066541r@connect.polyu.hk>
 <20260911041129.128280-2-26066541r@connect.polyu.hk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260911041129.128280-2-26066541r@connect.polyu.hk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 13:11, ZHOU Jiaxiang wrote:
> blk_revalidate_disk_zones() sizes the zones_cond array from the disk
> capacity and zone size, but the index used by blk_revalidate_zone_cond()
> comes from the device-driven report_zones() walk and is never checked
> against the array size. A device reporting more zones than fit the
> array makes blk_zone_set_cond() write out of bounds.
> 
> One way to reach this is a zone count exceeding 32 bits: both
> blk_revalidate_zone_args.nr_zones and struct zoned_disk_info.nr_zones
> are unsigned int, so a disk advertising more than UINT_MAX zones (e.g.
> 2^32 + 1024 zones of one 512-byte logical block) gets its zone count
> truncated to a small value, undersizing the array while the report
> walk keeps counting upward.
> 
> Check the index against the array size before storing the zone
> condition, and refuse to revalidate when the zone count does not fit
> 32 bits.
> 
> Fixes: 6e945ffb6555 ("block: use zone condition to determine conventional zones")
> Signed-off-by: ZHOU Jiaxiang <26066541r@connect.polyu.hk>

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
