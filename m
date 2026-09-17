Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A293A16B2;
	Thu, 17 Sep 2026 02:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789613473; cv=none; b=o5bxYM2IdD/5iw99YEW7rovXdjeeC2iskfitVehfmnvogQwWCLCBvESFU73O4Ko39HA+2ygQq7Jq62iPPtFo+4gj5Uw9pPtaqjvGxj4jIrpkbRCyYn5ouSRopd9rrNZbc/2Ac5KUCJjO0r5OOzOMK3r6jNrv/qW6Brz8EN/XwHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789613473; c=relaxed/simple;
	bh=7wVpAScjPk63iJDORhrgJ+rE5/1piz6D0cXLWudh+VE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mpZHPBii1/dL3RBi6i0S2C2jnOKRkxiHaejYXk+8RcoVEZXdswQMpqInVD5Z88KMxn0VUOVjUQczmRCCiPWMspNHz3RSmyfuljQB0iy2902R6B7ymZ1T4U4cGze4GnUq1qZt+jtQZZKWUKaN7R4GSRfCX6OU5DNPX9m6XGoG748=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OT+NAyNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OT+NAyNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC20B1F00893;
	Thu, 17 Sep 2026 02:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789613459;
	bh=8LSPWm5v0B9vr6+p044Lo5YejiMBQuvMAw5pYP47Dzc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OT+NAyNGIM0FvEMXZQ761SovGtQNdikTzGOyJlF2jYyGfwhbOVnqdYwdW19KoKnDJ
	 dzDqIJ6yE8rCb4N2nvAWIQrmaNut/Sgw3RAG0DaCy/vSrbtzu3Fchb97STHD10evwS
	 RwKEXuOURoMJfz5DbZxBg36rwTfbcHVnbaUM+RKb2WE+PDuK1s/k6bV+5yOHVpml2d
	 Spjsy4J1N0QPgJYKp/AEOmMpLVsukwI4PVQ0PzAynaS5d3BfSXOju48d9vFXvD63t5
	 W2k8xe/cL4hwGf0O2y1pWW//BrcWjhdDpVMyYEnLHhPIKo0FMSQRHNnJjCMRJ4GYbY
	 f4RoBnXjmxCGw==
Message-ID: <126ddf3d-a27f-4c46-a4db-a93c3145363d@kernel.org>
Date: Thu, 17 Sep 2026 09:50:55 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] block: fix zones_cond out-of-bounds write on zone
 report
To: "Martin K. Petersen (Oracle)" <mkp@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, ZHOU Jiaxiang <me@fxti.xyz>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <7815D1B293A8F55E+20260916135822.32584-2-me@fxti.xyz>
 <178961190604.3672510.18119102289310587808.b4-ty@b4>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <178961190604.3672510.18119102289310587808.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 9:28, Martin K. Petersen (Oracle) wrote:
> On Wed, 16 Sep 2026 21:58:21 +0800, ZHOU Jiaxiang wrote:
> 
>> blk_revalidate_disk_zones() sizes the zones_cond array from the disk
>> capacity and zone size, but the index used by blk_revalidate_zone_cond()
>> comes from the device-driven report_zones() walk and is never checked
>> against the array size. A device reporting more zones than fit the
>> array makes blk_zone_set_cond() write out of bounds.
>>
>> One way to reach this is a zone count exceeding 32 bits: both
>> blk_revalidate_zone_args.nr_zones and struct zoned_disk_info.nr_zones
>> are unsigned int, so a disk advertising more than UINT_MAX zones (e.g.
>> 2^32 + 1024 zones of one 512-byte logical block) gets its zone count
>> truncated to a small value, undersizing the array while the report
>> walk keeps counting upward.
>>
>> [...]
> 
> Applied to 7.3/scsi-fixes, thanks!
> 
> [1/2] block: fix zones_cond out-of-bounds write on zone report
>       https://git.kernel.org/mkp/scsi/c/7c431d61b69a
> [2/2] scsi: sd_zbc: reject disks with too many zones
>       https://git.kernel.org/mkp/scsi/c/b6ec0f797459
> 

I just asked about this :)
We will have a conflict in Linux-next with this unless Jens does a rebase of
block/for-next.

-- 
Damien Le Moal
Western Digital Research
