Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5516713C693;
	Tue, 16 Jul 2024 23:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721171240; cv=none; b=BuRW5uY7J5EDPWabaO/mGeVzGP6yD/zUbUxi0IAigdJOVoiVLsL8CV7nuiypXRSOYS61wmbL/psJT2MWCqPhlIIzAAN+AS0kdUZaX+bCTX0aIwq0df2Xh+sgN1X3M7LpRjjESS8UXmGn52+7pzmzkegZLkmUmmE8QYTmZl5XIPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721171240; c=relaxed/simple;
	bh=kZuZ0X0RPT/O4DsNTfXIg6bB6btR6kfVX63MOeO57YQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fjqDoVmCeybtWMvOrffpc1/Zf5cThZKQt/Bwv7XmdGnAfo+UA14ei94LzsT+HUX/Yqo/weZjW9LaClJxUiWSve4Dr8MOYkABhLCJdYJ7eGP47KhHj1QxKRwfQ3V603gBCi0EXhFyDHfbWsOchUp4uI3moESmdbUQ0EPig+tPHmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qx1sskeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qx1sskeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF62C116B1;
	Tue, 16 Jul 2024 23:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721171239;
	bh=kZuZ0X0RPT/O4DsNTfXIg6bB6btR6kfVX63MOeO57YQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qx1sskeIOvDqIJtZBHF32At0++OfaTeGlW3ut/AWOyiRfE/8odxFnYKKx4W37cYIT
	 MeN7MMx2rD+XPsAInafDPXhDjaJTi2QTU/5+SA0GqpYbzUnRWP1Usp5SxXDfOJ1uNx
	 1GScStNSgYePQjgEd10YO9mVYMuPmo+it8QhIKBSCrR1TravNiLrOH4guCHTWlYZfc
	 CMxW8ze6zXW0ur52m1lQA6OwCvRpBaQi583lRSGQ8FFQb+UhY+ktlemt6u3W+zY2h+
	 qOiHr2kYEmUaM8OOqh/AWqhN1bVjCSCp5pBU2Y/RWruluTRBoF/k/1xdPpxPiaozm2
	 ZaADh6BdsG2ug==
Message-ID: <b69d54af-2ac2-406a-ab32-9bad9d8a3000@kernel.org>
Date: Wed, 17 Jul 2024 08:07:18 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SCSI error indicating misalignment on part of Linux scsi or block
 layer?
To: David Howells <dhowells@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <483247.1721159741@warthog.procyon.org.uk>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <483247.1721159741@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/17/24 04:55, David Howells wrote:
> Hi James,
> 
> I'm wondering if I'm seeing a problem with DIO writes through Ext4 or XFS
> manifesting as SCSI misalignment errors.  This has occurred with two different
> drives.  I saw it first with v6.10-rc6, I think, but I haven't tried
> cachefiles for a while.  It does happen with v6.10.
> 
> ata1.00: exception Emask 0x60 SAct 0x1 SErr 0x800 action 0x6 frozen
> ata1.00: irq_stat 0x20000000, host bus error

Bus error is a serious error...

> ata1: SError: { HostInt }
> ata1.00: failed command: WRITE FPDMA QUEUED
> ata1.00: cmd 61/68:00:b0:93:34/00:00:02:00:00/40 tag 0 ncq dma 53248 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x60 (host bus error)
> ata1.00: status: { DRDY }
> ata1: hard resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

That is very low... Old hardware ?

> ata1.00: configured for UDMA/133
> sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=3s
> sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current] 
> sd 0:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command

That is likely the result of the automatice generation of sense data for failed
commands based on ata status and error fields for a failed command, which
defaults to this when nothing else matches (yeah, I know, that is not pretty.
But the SAT specs in that area are a nightmare and following them actually ends
up with this asc/ascq. Will try to do something about it).

The host bus error is the issue. Not sure what triggers it though.
What is the adapter model you are using ?

> sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 02 34 93 b0 00 00 68 00
> I/O error, dev sda, sector 37000112 op 0x1:(WRITE) flags 0x8800 phys_seg 1 prio class 0
> ata1: EH complete
> 
> For reference, I made it dump the result of the READ CAPACITY 16 command:
> 
> sd 0:0:0:0: [sda] RC16 000000003a38602f000002000000000000000000000000000000000000000000
> 
> The drive says it has 512-byte logical and physical block sizes.
> 
> The DIO writes are being generated by cachefiles and are all
> PAGE_SIZED-aligned in terms of file offset and request length.
> 
> I also saw this:
> 
> 	CacheFiles: I/O Error: Trunc-to-dio-size failed -95 [o=000001cb]
> 
> which indicates that ext4/xfs returned EOPNOTSUPP to vfs_truncate() and thence
> to cachefiles.  I'm not sure why it would do that.
> 
> Any idea what might cause this or how to investigate it further?  Is it
> possible it's some sort of hardware error in the I/O bridge or IOMMU?
> 
> Thanks,
> David
> 
> 

-- 
Damien Le Moal
Western Digital Research

