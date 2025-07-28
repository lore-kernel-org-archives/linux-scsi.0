Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DC818F2FC;
	Mon, 28 Jul 2025 03:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753674736; cv=none; b=oSG5MPoN9eyZLWwJOIP95oboXELKQTrU1Iigw3PyzPxTtmi8iEBYkqrLzlxah+qxELjF5SuiTkM2+AgtOKK14ahpnpu0axyB+A9QPihaWW0rAX7jmCPtM1ExBJQqKRZL9q3Ggea5qQINzmhn2qicYb5iHX+/W+qZn1VkeuAp2HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753674736; c=relaxed/simple;
	bh=OuCGFSdRxRKbMwIPHOKcIM2v1XhrXML04mYuaDdof1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFeP9pwG4DEtsWnu26UTCcoQGgldhcY/tx5JuFxA1wmyYMmiGz752Fp89lbtlAcLZVz6mm++4/2ZVtMXjDiQmV8Bc0MelDp+gCAgiuFRnWQsfmKDRcY2PLOV1L0FaxssO9NcDUyQFbkx5wm7HKHawaWLdNSl5ficOap9tjj83P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfkuEjHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfkuEjHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D474C4CEE7;
	Mon, 28 Jul 2025 03:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753674736;
	bh=OuCGFSdRxRKbMwIPHOKcIM2v1XhrXML04mYuaDdof1M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WfkuEjHBKPoK0eQ+6CdtFSJ71AJFn7HH41zyr6C4Ew4eSkXjT7uGSYN2U6hIy+H6A
	 dhsaKsbJ50fbrmuwNOcdzbzVgpGMSjCwyVFUlZoYoRo3LoqM1R82dBlmuwycwgjkHs
	 7FQcp+Tp4q0hyUhba9focvnDQ9wq/RMBUQJCHfswm9z4FKZe8Zzg9ABz/tjEWdxyM2
	 mnTuJ7ZfX/v8f53+RFdhiv5dYt4QSznH1NFWfLmk0J8YvrdjFsHQSrDvF+xDK7C8HJ
	 J3jQ/hyovetn3uuNzaWWq+vr/nbJ8cd9oj/BqssLAk5Ol3qvicmkOhE4na/HDdJdMW
	 IFQfgueTQH6kQ==
Message-ID: <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
Date: Mon, 28 Jul 2025 12:49:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improper io_opt setting for md raid5
To: Yu Kuai <yukuai1@huaweicloud.com>, =?UTF-8?Q?Csord=C3=A1s_Hunor?=
 <csordas.hunor@gmail.com>, Coly Li <colyli@kernel.org>, hch@lst.de
Cc: linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
 <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
 <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
 <655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
 <4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/28/25 12:08 PM, Yu Kuai wrote:
> Hi,
> 
> 在 2025/07/28 10:41, Damien Le Moal 写道:
>> On 7/28/25 9:55 AM, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2025/07/28 8:39, Damien Le Moal 写道:
>>>> md setting its io_opt to 64K*number of drives in the array is strange... It
>>>> does not have to be that large since io_opt is an upper bound and not a "issue
>>>> that IO size for optimal performance". io_opt is simply a limit saying: if you
>>>> exceed that IO size, performance may suffer.
>>>>
>>>
>>> At least from Documentation, for raid arrays, multiple of io_opt is the
>>> prefereed io size to the optimal io performance, and for raid5, this is
>>> chunksize * data disks.
>>>
>>>> So a default of stride size x number of drives for the io_opt may be OK, but
>>>> that should be bound to some reasonable value. Furthermore, this is likely
>>>> suboptimal. I woulld think that setting the md array io_opt initially to
>>>> min(all drives io_opt) x number of drives would be a better default.
>>>
>>> For raid5, this is not ok, the value have to be chunksize * data disks,
>>> regardless of io_opt from member disks, otherwise raid5 have to issue
>>> additional IO from other disks to build xor data.
>>>
>>> For example:
>>>
>>>   - write aligned chunksize to one disk, actually means read chunksize
>>> old xor data,then write chunksize data and chunksize new xor data.
>>>   - write aligned chunksize * data disks, new xor data can be build
>>> directly without reading old xor data.
>>
>> I understand all of that. But you missed my point: io_opt simply indicates an
>> upper bound for an IO size. If exceeded, performance may be degraded. This has
>> *nothing* to do with the io granularity, which for a RAID array should ideally
>> be equal to stride size x number of data disks.
>>
>> This is the confusion here. md setting io_opt to stride x number of disks in
>> the array is simply not what io_opt is supposed to indicate.
> 
> ok, can I ask where is this upper bound for IO size from?

SCSI SBC specifications, Block Limits VPD page (B0h):

3 values are important in there:

* OPTIMAL TRANSFER LENGTH GRANULARITY:

An OPTIMAL TRANSFER LENGTH GRANULARITY field set to a non-zero value indicates
the optimal transfer length granularity size in logical blocks for a single
command shown in the command column of table 33. If a device server receives
one of these commands with a transfer size that is not equal to a multiple of
this value, then the device server may incur delays in processing the command.
An OPTIMAL TRANSFER LENGTH GRANULARITY field set to 0000h indicates that the
device server does not report optimal transfer length granularity.

For a SCSI disk, sd.c uses this value for sdkp->min_xfer_blocks. Note that the
naming here is dubious since this is not a minimum. The minimum is the logical
block size. This is a "hint" for better performance. For a RAID area, this
should be the stripe size of the RAID volume (stride x number of data disks).
This value is used for queue->limits.io_min.

* MAXIMUM TRANSFER LENGTH:

A MAXIMUM TRANSFER LENGTH field set to a non-zero value indicates the maximum
transfer length in logical blocks that the device server accepts for a single
command shown in table 33. If a device server receives one of these commands
with a transfer size greater than this value, then the device server shall
terminate the command with CHECK CONDITION status with the sense key set to
ILLEGAL REQUEST and the additional sense code set to the value shown in table
33. A MAXIMUM TRANSFER LENGTH field set to 0000_0000h indicates that the device
server does not report a limit on the transfer length.

For a SCSI disk, sd.c uses this value for sdkp->max_xfer_blocks. This is a hard
limit which will be reflected in queue->limits.max_dev_sectors
(max_hw_sectors_kb in sysfs).

* OPTIMAL TRANSFER LENGTH:

An OPTIMAL TRANSFER LENGTH field set to a non-zero value indicates the optimal
transfer size in logical blocks for a single command shown in table 33. If a
device server receives one of these commands with a transfer size greater than
this value, then the device server may incur delays in processing the command.
An OPTIMAL TRANSFER LENGTH field set to 0000_0000h indicates that the device
server does not report an optimal transfer size.

For a SCSI disk, sd.c uses this value for sdkp->opt_xfer_blocks. This value is
used for queue->limit.io_opt.

> With git log, start from commit 7e5f5fb09e6f ("block: Update topology
> documentation"), the documentation start contain specail explanation for
> raid array, and the optimal_io_size says:
> 
> For RAID arrays it is usually the
> stripe width or the internal track size.  A properly aligned
> multiple of optimal_io_size is the preferred request size for
> workloads where sustained throughput is desired.
> 
> And this explanation is exactly what raid5 did, it's important that
> io size is aligned multiple of io_opt.

Looking at the sysfs doc for the above fields, they are described as follows:

* /sys/block/<disk>/queue/minimum_io_size

[RO] Storage devices may report a granularity or preferred
minimum I/O size which is the smallest request the device can
perform without incurring a performance penalty.  For disk
drives this is often the physical block size.  For RAID arrays
it is often the stripe chunk size.  A properly aligned multiple
of minimum_io_size is the preferred request size for workloads
where a high number of I/O operations is desired.

So this matches the SCSI limit OPTIMAL TRANSFER LENGTH GRANULARITY and for a
RAID array, this indeed should be the stride x number of data disks.

* /sys/block/<disk>/queue/max_hw_sectors_kb

[RO] This is the maximum number of kilobytes supported in a
single data transfer.

No problem here.

* /sys/block/<disk>/queue/optimal_io_size

Storage devices may report an optimal I/O size, which is
the device's preferred unit for sustained I/O.  This is rarely
reported for disk drives.  For RAID arrays it is usually the
stripe width or the internal track size.  A properly aligned
multiple of optimal_io_size is the preferred request size for
workloads where sustained throughput is desired.  If no optimal
I/O size is reported this file contains 0.

Well, I find this definition not correct *at all*. This is repeating the
definition of minimum_io_size (limits->io_min) and completely disregard the
eventual optimal_io_size limit of the drives in the array. For a raid array,
this value should obviously be a multiple of minimum_io_size (the array stripe
size), but it can be much larger, since this should be an upper bound for IO
size. read_ahead_kb being set using this value is thus not correct I think.
read_ahead_kb should use max_sectors_kb, with alignment to minimum_io_size.


-- 
Damien Le Moal
Western Digital Research
