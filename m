Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C29223DD4;
	Mon, 28 Jul 2025 07:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753686867; cv=none; b=uPwfNkqC9ll5kvLi9H+92tHQyWofNrXYmCSxhdflIR2TsN/AsdIFSCsOLhQV1kIyxbMEOnotjYIS8WR3VWECF8xK6FQDby0viIDxO7Ddt6Rm6KpVvAzFhdzEklpNYkUVQ6/wNiDP/rApCXrn8IiiBuahbscRzsaz9odDJzwbEhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753686867; c=relaxed/simple;
	bh=Jgr6BeNzopkONn/wcfjOgVwKiPV80KlkAgx/Ix6+O2E=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ih9fZ1K/i2bh40jPVMjE0PtxddPgWBxy+ZXswzUl2RZGIi3tJPb9GuTQzZimcDND7uBUDzm/qxdYTCtn0eOkZIASnnQV8x0I5I+uCnW19b2tx2jMnJxY33h3/xo4t0EO/DuPbfNHJov1fZ+cnIWTyaBeKuhNCcQ+EHEgENGuwWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4br8qM43P5zYQv53;
	Mon, 28 Jul 2025 15:14:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3F4C51A10E5;
	Mon, 28 Jul 2025 15:14:22 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnIxRMI4doT73+Bg--.43571S3;
	Mon, 28 Jul 2025 15:14:22 +0800 (CST)
Subject: Re: Improper io_opt setting for md raid5
To: Damien Le Moal <dlemoal@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 =?UTF-8?Q?Csord=c3=a1s_Hunor?= <csordas.hunor@gmail.com>,
 Coly Li <colyli@kernel.org>, hch@lst.de
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
 <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
Date: Mon, 28 Jul 2025 15:14:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnIxRMI4doT73+Bg--.43571S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WF4xuFy7AFWxAF4fKF4Uurg_yoW3tF1kpa
	y3GFyDKrn5XF10ywn2y3y7Za1FvFsxGFW8Wr98trW09rn8Kry0vrWxKFyF939rKr4kGw10
	vr90gr98CF1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/28 11:49, Damien Le Moal 写道:
> On 7/28/25 12:08 PM, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/07/28 10:41, Damien Le Moal 写道:
>>> On 7/28/25 9:55 AM, Yu Kuai wrote:
>>>> Hi,
>>>>
>>>> 在 2025/07/28 8:39, Damien Le Moal 写道:
>>>>> md setting its io_opt to 64K*number of drives in the array is strange... It
>>>>> does not have to be that large since io_opt is an upper bound and not a "issue
>>>>> that IO size for optimal performance". io_opt is simply a limit saying: if you
>>>>> exceed that IO size, performance may suffer.
>>>>>
>>>>
>>>> At least from Documentation, for raid arrays, multiple of io_opt is the
>>>> prefereed io size to the optimal io performance, and for raid5, this is
>>>> chunksize * data disks.
>>>>
>>>>> So a default of stride size x number of drives for the io_opt may be OK, but
>>>>> that should be bound to some reasonable value. Furthermore, this is likely
>>>>> suboptimal. I woulld think that setting the md array io_opt initially to
>>>>> min(all drives io_opt) x number of drives would be a better default.
>>>>
>>>> For raid5, this is not ok, the value have to be chunksize * data disks,
>>>> regardless of io_opt from member disks, otherwise raid5 have to issue
>>>> additional IO from other disks to build xor data.
>>>>
>>>> For example:
>>>>
>>>>    - write aligned chunksize to one disk, actually means read chunksize
>>>> old xor data,then write chunksize data and chunksize new xor data.
>>>>    - write aligned chunksize * data disks, new xor data can be build
>>>> directly without reading old xor data.
>>>
>>> I understand all of that. But you missed my point: io_opt simply indicates an
>>> upper bound for an IO size. If exceeded, performance may be degraded. This has
>>> *nothing* to do with the io granularity, which for a RAID array should ideally
>>> be equal to stride size x number of data disks.
>>>
>>> This is the confusion here. md setting io_opt to stride x number of disks in
>>> the array is simply not what io_opt is supposed to indicate.
>>
>> ok, can I ask where is this upper bound for IO size from?
> 
> SCSI SBC specifications, Block Limits VPD page (B0h):
> 
> 3 values are important in there:
> 
> * OPTIMAL TRANSFER LENGTH GRANULARITY:
> 
> An OPTIMAL TRANSFER LENGTH GRANULARITY field set to a non-zero value indicates
> the optimal transfer length granularity size in logical blocks for a single
> command shown in the command column of table 33. If a device server receives
> one of these commands with a transfer size that is not equal to a multiple of
> this value, then the device server may incur delays in processing the command.
> An OPTIMAL TRANSFER LENGTH GRANULARITY field set to 0000h indicates that the
> device server does not report optimal transfer length granularity.
> 
> For a SCSI disk, sd.c uses this value for sdkp->min_xfer_blocks. Note that the
> naming here is dubious since this is not a minimum. The minimum is the logical
> block size. This is a "hint" for better performance. For a RAID area, this
> should be the stripe size of the RAID volume (stride x number of data disks).
> This value is used for queue->limits.io_min.
> 
> * MAXIMUM TRANSFER LENGTH:
> 
> A MAXIMUM TRANSFER LENGTH field set to a non-zero value indicates the maximum
> transfer length in logical blocks that the device server accepts for a single
> command shown in table 33. If a device server receives one of these commands
> with a transfer size greater than this value, then the device server shall
> terminate the command with CHECK CONDITION status with the sense key set to
> ILLEGAL REQUEST and the additional sense code set to the value shown in table
> 33. A MAXIMUM TRANSFER LENGTH field set to 0000_0000h indicates that the device
> server does not report a limit on the transfer length.
> 
> For a SCSI disk, sd.c uses this value for sdkp->max_xfer_blocks. This is a hard
> limit which will be reflected in queue->limits.max_dev_sectors
> (max_hw_sectors_kb in sysfs).
> 
> * OPTIMAL TRANSFER LENGTH:
> 
> An OPTIMAL TRANSFER LENGTH field set to a non-zero value indicates the optimal
> transfer size in logical blocks for a single command shown in table 33. If a
> device server receives one of these commands with a transfer size greater than
> this value, then the device server may incur delays in processing the command.
> An OPTIMAL TRANSFER LENGTH field set to 0000_0000h indicates that the device
> server does not report an optimal transfer size.
> 
> For a SCSI disk, sd.c uses this value for sdkp->opt_xfer_blocks. This value is
> used for queue->limit.io_opt.

Thanks for the explanation.
> 
>> With git log, start from commit 7e5f5fb09e6f ("block: Update topology
>> documentation"), the documentation start contain specail explanation for
>> raid array, and the optimal_io_size says:
>>
>> For RAID arrays it is usually the
>> stripe width or the internal track size.  A properly aligned
>> multiple of optimal_io_size is the preferred request size for
>> workloads where sustained throughput is desired.
>>
>> And this explanation is exactly what raid5 did, it's important that
>> io size is aligned multiple of io_opt.
> 
> Looking at the sysfs doc for the above fields, they are described as follows:
> 
> * /sys/block/<disk>/queue/minimum_io_size
> 
> [RO] Storage devices may report a granularity or preferred
> minimum I/O size which is the smallest request the device can
> perform without incurring a performance penalty.  For disk
> drives this is often the physical block size.  For RAID arrays
> it is often the stripe chunk size.  A properly aligned multiple
> of minimum_io_size is the preferred request size for workloads
> where a high number of I/O operations is desired.
> 
> So this matches the SCSI limit OPTIMAL TRANSFER LENGTH GRANULARITY and for a
> RAID array, this indeed should be the stride x number of data disks.

Do you mean stripe here? io_min for raid array is always just one
chunksize.
> 
> * /sys/block/<disk>/queue/max_hw_sectors_kb
> 
> [RO] This is the maximum number of kilobytes supported in a
> single data transfer.
> 
> No problem here.
> 
> * /sys/block/<disk>/queue/optimal_io_size
> 
> Storage devices may report an optimal I/O size, which is
> the device's preferred unit for sustained I/O.  This is rarely
> reported for disk drives.  For RAID arrays it is usually the
> stripe width or the internal track size.  A properly aligned
> multiple of optimal_io_size is the preferred request size for
> workloads where sustained throughput is desired.  If no optimal
> I/O size is reported this file contains 0.
> 
> Well, I find this definition not correct *at all*. This is repeating the
> definition of minimum_io_size (limits->io_min) and completely disregard the
> eventual optimal_io_size limit of the drives in the array. For a raid array,
> this value should obviously be a multiple of minimum_io_size (the array stripe
> size), but it can be much larger, since this should be an upper bound for IO
> size. read_ahead_kb being set using this value is thus not correct I think.
> read_ahead_kb should use max_sectors_kb, with alignment to minimum_io_size.

I think this is actually different than io_min, and io_opt for different
levels are not the same, for raid0, raid10, raid456(raid1 doesn't have
chunksize):
  - lim.io_min = mddev->chunk_sectors << 9;
  - lim.io_opt = lim.io_min * (number of data copies);

And I think they do match the definition above, specifically:
  - properly multiple aligned io_min to *prevent performance penalty*;
  - properly multiple aligned io_opt to *get optimal performance*, the
    number of data copies times the performance of a single disk;

The orginal problem is that scsi disks report unusual io_opt 32767,
and raid5 set io_opt to 64k * 7(8 disks with 64k chunksise). The
lcm_not_zero() from blk_stack_limits() end up with a huge value:

blk_stack_limits()
  t->io_min = max(t->io_min, b->io_min);
  t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);

 > read_ahead_kb should use max_sectors_kb, with alignment to 
minimum_io_size.

The io_opt is used in raid array as minimal aligned size to get optimal
IO performance, not the upper bound. With the respect of this, use this
value for ra_pages make sense. However, if scsi is using this value as
IO upper bound, it's right this doesn't make sense.

Thanks,
Kuai

> 
> 

