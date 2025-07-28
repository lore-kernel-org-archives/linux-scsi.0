Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99CA72636;
	Mon, 28 Jul 2025 00:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753663327; cv=none; b=A9qjBuG9IXi99j9xBEAlfsbZnB/9+CtR4nyoWOjCCCoQOaFLrRVLqF6hfNRxe8HpyPCRallD8Mhom+bvkT0VfzheiIlsaemXtAztHA3+gIyjT75D8ekGXVmipzFmw+rwhhkSl107ZoHfcIJn6aKid9VbpUvpFOwnKBDS3h4ZtIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753663327; c=relaxed/simple;
	bh=Fw13axCMryPv1IW+V9sRJ4MDPyfj0F4Q4XIuxV5Ykwo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=DXPx4DDSrlUFoH+NTUk2B/c3QISYCgz4hF+/y+8s0P9JdGbJAKNB0Zp5eo/CHFbwIAWte+oB9yuoqTGUOBxchwBsrkMcCsFZVLaZ6gO+VhNOpIbTO2rNVQOmfoIDnvCSzBX3Uk8/2dtPBrJs09PnCtv8UTMrwpav5Yocyu0818w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=skl7eEao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="skl7eEao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC62C4CEEB;
	Mon, 28 Jul 2025 00:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753663327;
	bh=Fw13axCMryPv1IW+V9sRJ4MDPyfj0F4Q4XIuxV5Ykwo=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=skl7eEaoBHftZWLVMR6i6Xc6P2moTfx7MIx2Ks1E0CLRWRsD0k6DRdczl0NuxLZMA
	 8S1jy1GYQTH4r1Spij6xZam6WO6Dwaj4+xHCOm2NcLIq9oWG+VpwNr7D0VHgH6uAAf
	 YAFEN5dLtI27O9VzBVmdyntFAEtuIDCoI/mlihYlRV/qN0cQWasArmKei3307e0IbU
	 dJMfS2vKgqMpYcVUMvjdMuQUJLvMdyDIpfQEPgKWLc+EnW/7dxsI17d8Mlbz3MqIGn
	 MFM5/AezGkrHGedt4XmMls0eoEKPSUcaqrYjiMFiEj5ajXcuWadQB1YQekG47EgSiX
	 +FFv7rPNHxIbg==
Message-ID: <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
Date: Mon, 28 Jul 2025 09:39:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Damien Le Moal <dlemoal@kernel.org>
Subject: Re: Improper io_opt setting for md raid5
To: =?UTF-8?Q?Csord=C3=A1s_Hunor?= <csordas.hunor@gmail.com>,
 Coly Li <colyli@kernel.org>, hch@lst.de
Cc: linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
 <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/27/25 7:50 PM, Csordás Hunor wrote:
> Adding the SCSI maintainers because I believe the culprit is in
> drivers/scsi/sd.c, and Damien Le Moal because because he has a pending
> patch modifying the relevant part and he might be interested in the
> implications.
> 
> On 7/15/2025 5:56 PM, Coly Li wrote:
>> Let me rescript the problem I encountered.
>> 1, There is an 8 disks raid5 with 64K chunk size on my machine, I observe
>> /sys/block/md0/queue/optimal_io_size is very large value, which isn’t
>> reasonable size IMHO.
> 
> I have come across the same problem after moving all 8 disks of a RAID6
> md array from two separate SATA controllers to an mpt3sas device. In my
> case, the readahead on the array became almost 4 GB:
> 
> # grep ^ /sys/block/{sda,md_helium}/queue/{optimal_io_size,read_ahead_kb}
> /sys/block/sda/queue/optimal_io_size:16773120
> /sys/block/sda/queue/read_ahead_kb:32760

For a SATA drive connected to an mpt3sas HBA, I see the same. But note that the
optimal_io_size here is completely made up by the HBA/driver because ATA does
not advertize/define an optimal IO size.

For SATA drive connected to AHCI SATA ports, I see:

/sys/block/sda/queue/optimal_io_size:0
/sys/block/sda/queue/read_ahead_kb:8192

read_ahead_kb in this case is twice max_sectors_kb (which with my patch is now
4MB).

> /sys/block/md_helium/queue/optimal_io_size:4293918720
> /sys/block/md_helium/queue/read_ahead_kb:4192256
> 
> Note: the readahead is supposed to be twice the optimal I/O size (after
> a unit conversion). On the md array it isn't because of an overflow in
> blk_apply_bdi_limits. This overflow is avoidable but basically
> irrelevant; however, it nicely highlights the fact that io_opt should
> really never get this large.

Only if io_opt is non-zero. If io_opt is zero, then read_ahead_kb by default is
twice max_sectors_kb.

> 
>> 2,  It was from drivers/scsi/mpt3sas/mpt3sas_scsih.c, 
>> 11939 static const struct scsi_host_template mpt3sas_driver_template = {
> ...
>> 11960         .max_sectors                    = 32767,
> ...
>> 11969 };
>> at line 11960, max_sectors of mpt3sas driver is defined as 32767.

This is another completely made-up value since SCSI allows commands transfer
length up to 4GB (32-bits value in bytes). Even ATA drives allow up to 65536
logical sectors per command (so 65536 * 4K = 256MB per command for $k logical
sector drives). Not sure why it is set to this completely arbitrary value.

>> Then in drivers/scsi/scsi_transport_sas.c, at line 241 inside sas_host_setup(),
>> shots->opt_sectors is assigned by 32767 from the following code,
>> 240         if (dma_dev->dma_mask) {
>> 241                 shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
>> 242                                 dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
>> 243         }
>>
>> Then in drivers/scsi/sd.c, inside sd_revalidate_disk() from the following coce,
>> 3785         /*
>> 3786          * Limit default to SCSI host optimal sector limit if set. There may be
>> 3787          * an impact on performance for when the size of a request exceeds this
>> 3788          * host limit.
>> 3789          */
>> 3790         lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
>> 3791         if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
>> 3792                 lim.io_opt = min_not_zero(lim.io_opt,
>> 3793                                 logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
>> 3794         }
>>
>> lim.io_opt of all my sata disks attached to mpt3sas HBA are all 32767 sectors,
>> because the above code block.
>>
>> Then when my raid5 array sets its queue limits, because its io_opt is 64KiB*7,
>> and the raid component sata hard drive has io_opt with 32767 sectors, by
>> calculation in block/blk-setting.c:blk_stack_limits() at line 753,
>> 753         t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
>> the calculated opt_io_size of my raid5 array is more than 1GiB. It is too large.

md setting its io_opt to 64K*number of drives in the array is strange... It
does not have to be that large since io_opt is an upper bound and not a "issue
that IO size for optimal performance". io_opt is simply a limit saying: if you
exceed that IO size, performance may suffer.

So a default of stride size x number of drives for the io_opt may be OK, but
that should be bound to some reasonable value. Furthermore, this is likely
suboptimal. I woulld think that setting the md array io_opt initially to
min(all drives io_opt) x number of drives would be a better default.

>> I know the purpose of lcm_not_zero() is to get an optimized io size for both
>> raid device and underlying component devices, but the resulted io_opt is bigger
>> than 1 GiB that's too big.
>>
>> For me, I just feel uncomfortable that using max_sectors as opt_sectors in
>> sas_host_stup(), but I don't know a better way to improve. Currently I just
>> modify the mpt3sas_driver_template's max_sectors from 32767 to 64, and observed
>> 5~10% sequetial write performance improvement (direct io) for my raid5 devices
>> by fio.
> 
> In my case, the impact was more noticable. The system seemed to work
> surprisingly fine under light loads, but an increased number of
> parallel I/O operations completely tanked its performance until I
> set the readaheads to their expected values and gave the system some
> time to recover.
> 
> I came to the same conclusion as Coly Li: io_opt ultimately gets
> populated from shost->max_sectors, which (in the case of mpt3sas and
> several other SCSI controllers) contains a value which is both:
> - unnecessarily large for this purpose and, more importantly,
> - not a nice number without any large odd divisors, as blk_stack_limits
>   clearly expects.

Sounds to me like this is an md driver issue and tweak the limits automatically
calculated by stacking the limits of the array members.

> Populating io_opt from shost->max_sectors happens via
> shost->opt_sectors. This variable was introduced in commits
> 608128d391fa ("scsi: sd: allow max_sectors be capped at DMA optimal
> size limit") and 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost
> opt_sectors according to DMA optimal limit"). Despite the (in hindsight
> perhaps unfortunate) name, it wasn't used to set io_opt. It was optimal
> in a different sense: it was used as a (user-overridable) upper limit
> to max_sectors, constraining the size of requests to play nicely with
> IOMMU which might get slow with large mappings.
> 
> Commit 608128d391fa even mentions io_opt:
> 
>     It could be considered to have request queues io_opt value initially
>     set at Scsi_Host.opt_sectors in __scsi_init_queue(), but that is not
>     really the purpose of io_opt.
> 
> The last part is correct. shost->opt_sectors is an _upper_ bound on the
> size of requests, while io_opt is used both as a sort of _lower_ bound
> (in the form of readahead), and as a sort of indivisible "block size"
> for I/O (by blk_stack_limits). These two existing purposes may or may
> not already be too much for a single variable; adding a third one
> clearly doesn't work well.
> 
> It was commit a23634644afc ("block: take io_opt and io_min into account
> for max_sectors") which started setting io_opt from shost->opt_sectors.
> It did so to stop abusing max_user_sectors to set max_sectors from
> shost->opt_sectors, but it ended up misusing another variable for this
> purpose -- perhaps due to inadvertently conflating the two "optimal"
> transfer sizes, which are optimal in two very different contexts.
> 
> Interestingly, while I've verified that the increased values for io_opt
> and readahead on the actual disks definitely comes from this commit
> (a23634644afc), the io_opt and readahead of the md array are unaffected
> until commit 9c0ba14828d6 ("blk-settings: round down io_opt to
> physical_block_size") due to a weird coincidence. This commit rounds
> io_opt down to the physical block size in blk_validate_limits. Without
> this commit, io_opt for the disks is 16776704, which looks even worse
> at first glance (512 * 32767 instead of 4096 * 4095). However, this
> ends up overflowing in a funny way when combined with the fact that
> blk_stack_limits (and thus lcm_not_zero) is called once per component
> device:
> 
> u32 t = 3145728; // 3 MB, the optimal I/O size for the array
> u32 b = 16776704; // the (incorrect) optimal I/O size of the disks

It is not incorrect. It is a made-up value. For a SATA drive, reporting 0 would
be the correct thing to do.

> u32 x = lcm(t, b); // x == (u32)103076069376 == 4291821568
> u32 y = lcm(x, b); // y == (u32)140630117318656 == t
> 
> Repeat for an even number of component devices to get the right answer
> from the wrong inputs by an incorrect method.
> 
> I'm sure the issue can be reproduced before commit 9c0ba14828d6
> (although I haven't actually tried -- if I had to, I'd start with an
> array with an odd number of component devices), but at the same time,
> the issue may be still present and hidden on some systems even after
> that commit (for example, the rounding does nothing if the physical
> block size is 512). This might help a little bit to explain why the
> problem doesn't seem more widespread.
> 
>> So there should be something to fix. Can you take a look, or give me some hint
>> to fix?
>>
>> Thanks in advance.
>>
>> Coly Li
> 
> I would have loved to finish with a patch here but I'm not sure what
> the correct fix is. shost->opt_sectors was clearly added for a reason
> and it should reach max_sectors in struct queue_limits in some way. It
> probably isn't included in max_hw_sectors because it's meant to be
> overridable. Apparently just setting max_sectors causes problems, and
> so does setting max_sectors and max_user_sectors. I don't know how to
> to fix this correctly without introducing a new variable to struct
> queue_limits but maybe people more familiar with the code can think of
> a less intrusive way.
> 
> Hunor Csordás
> 


-- 
Damien Le Moal
Western Digital Research
