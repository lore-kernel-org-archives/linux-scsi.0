Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5534DFBF0;
	Mon, 28 Jul 2025 09:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753693376; cv=none; b=VtI1lpp9szjGXBqoiofg5R8mLwrPwIgZn8Hq96vdC1kRyQu/k2NTOkXb8pzmFuAqSbvYNzD49JM3f9VDzq/YvWZl6+6OTVr5zIuinqgQNDKeJsUWr8742iUWhTfkHFY8t3bB3CkXNBZHEw8F006YQTJg0nB/RW6unl0a/I0Ga30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753693376; c=relaxed/simple;
	bh=vu6pDg1kEX3NPwy99aOYP31lSZhhDPBx/IkUcyqAcQQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VJ6nQcP5u8vvbgWkmUaA10PctXchBhocYCbHxwcPyanvfRMqq/yq7W/WpkDgNurDj61CYfitIID7fcJu6EckmvLlIjhXN4lJLwWHv3Ss8J9DQ41EFGrOX6xC38zm0xmk2qWuDE/NCz3f1J8ocS1xS1xNfH9a8r4ZVnNFLzLYbwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4brCDV4YgyzKHMt0;
	Mon, 28 Jul 2025 17:02:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 773F01A10EC;
	Mon, 28 Jul 2025 17:02:49 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXkxO3PIdo3VgHBw--.41020S3;
	Mon, 28 Jul 2025 17:02:49 +0800 (CST)
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
 <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
 <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com>
Date: Mon, 28 Jul 2025 17:02:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXkxO3PIdo3VgHBw--.41020S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtF1xCFWDGFW8uFWxKr1ftFb_yoW3AF4rpF
	W3Ka4Dtrn5ZF1xtw1Iya4xZw4Fv395GF48WF9xJrW0vrn0gryIqrWxKryrua9Fgr4kGw12
	vr18t3s8uF1kZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2025/07/28 15:44, Damien Le Moal 写道:
> On 7/28/25 4:14 PM, Yu Kuai wrote:
>>>> With git log, start from commit 7e5f5fb09e6f ("block: Update topology
>>>> documentation"), the documentation start contain specail explanation for
>>>> raid array, and the optimal_io_size says:
>>>>
>>>> For RAID arrays it is usually the
>>>> stripe width or the internal track size.  A properly aligned
>>>> multiple of optimal_io_size is the preferred request size for
>>>> workloads where sustained throughput is desired.
>>>>
>>>> And this explanation is exactly what raid5 did, it's important that
>>>> io size is aligned multiple of io_opt.
>>>
>>> Looking at the sysfs doc for the above fields, they are described as follows:
>>>
>>> * /sys/block/<disk>/queue/minimum_io_size
>>>
>>> [RO] Storage devices may report a granularity or preferred
>>> minimum I/O size which is the smallest request the device can
>>> perform without incurring a performance penalty.  For disk
>>> drives this is often the physical block size.  For RAID arrays
>>> it is often the stripe chunk size.  A properly aligned multiple
>>> of minimum_io_size is the preferred request size for workloads
>>> where a high number of I/O operations is desired.
>>>
>>> So this matches the SCSI limit OPTIMAL TRANSFER LENGTH GRANULARITY and for a
>>> RAID array, this indeed should be the stride x number of data disks.
>>
>> Do you mean stripe here? io_min for raid array is always just one
>> chunksize.
> 
> My bad, yes, that is the definition in sysfs. So io_min is the stride size, where:
> 
> stride size x number of data disks == stripe_size.
> 
Yes.

> Note that chunk_sectors limit is the *stripe* size, not per drive stride.
> Beware of the wording here to avoid confusion (this is all already super
> confusing !).

This is something we're not in the same page :( For example, 8 disks
raid5, with default chunk size. Then the above calculation is:

64k * 7 = 448k

The chunksize I said is 64k...
> 
> Well, at least, that is how I interpret the io_min definition of
> minimum_io_size in Documentation/ABI/stable/sysfs-block. But the wording "For
> RAID arrays it is often the stripe chunk size." is super confusing. Not
> entirely sure if stride or stripe was meant here...
> 

Hope it's clear now.
> 
>>> * /sys/block/<disk>/queue/optimal_io_size
>>>
>>> Storage devices may report an optimal I/O size, which is
>>> the device's preferred unit for sustained I/O.  This is rarely
>>> reported for disk drives.  For RAID arrays it is usually the
>>> stripe width or the internal track size.  A properly aligned
>>> multiple of optimal_io_size is the preferred request size for
>>> workloads where sustained throughput is desired.  If no optimal
>>> I/O size is reported this file contains 0.
>>>
>>> Well, I find this definition not correct *at all*. This is repeating the
>>> definition of minimum_io_size (limits->io_min) and completely disregard the
>>> eventual optimal_io_size limit of the drives in the array. For a raid array,
>>> this value should obviously be a multiple of minimum_io_size (the array stripe
>>> size), but it can be much larger, since this should be an upper bound for IO
>>> size. read_ahead_kb being set using this value is thus not correct I think.
>>> read_ahead_kb should use max_sectors_kb, with alignment to minimum_io_size.
>>
>> I think this is actually different than io_min, and io_opt for different
>> levels are not the same, for raid0, raid10, raid456(raid1 doesn't have
>> chunksize):
>>   - lim.io_min = mddev->chunk_sectors << 9;

By the above example, io_min = 64k, and io_opt = 448k. And make sure
we're on the same page, io_min is the *stride* and io_opt is the
*stripe*.
> 
> See above. Given how confusing the definition of minimum_io_size is, not sure
> that is correct. This code assumes that io_min is the stripe size and not the
> stride size.
> 
>>   - lim.io_opt = lim.io_min * (number of data copies);
> 
> I do not understand what you mean with "number of data copies"... There is no
> data copy in a RAID 5/6 array.

Yes, this is my bad, *data disks* is the better word.
> 
>> And I think they do match the definition above, specifically:
>>   - properly multiple aligned io_min to *prevent performance penalty*;
> 
> Yes.
> 
>>   - properly multiple aligned io_opt to *get optimal performance*, the
>>     number of data copies times the performance of a single disk;
> 
> That is how this field is defined for RAID, but that is far from what it means
> for a single disk. It is unfortunate that it was defined like that.
> 
> For a single disk, io_opt is NOT about getting optimal_performance. It is about
> an upper bound for the IO size to NOT get a performance penalty (e.g. due to a
> DMA mapping that is too large for what the IOMMU can handle).

The name itself is misleading. :( I didn't know this definition until
now.

> 
> And for a RAID array, it means that we should always have io_min == io_opt but
> it seems that the scsi code and limit stacking code try to make this limit an
> upper bound on the IO size, aligned to the stripe size.
> 
>> The orginal problem is that scsi disks report unusual io_opt 32767,
>> and raid5 set io_opt to 64k * 7(8 disks with 64k chunksise). The
>> lcm_not_zero() from blk_stack_limits() end up with a huge value:
>>
>> blk_stack_limits()
>>   t->io_min = max(t->io_min, b->io_min);
>>   t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> 
> I understand the "problem" that was stated. There is an overflow that result in
> a large io_opt and a ridiculously large read_ahead_kb.
> io_opt being large should in my opinion not be an issue in itself, since it
> should be an upper bound on IO size and not the stripe size (io_min indicates
> that).
> 
>>> read_ahead_kb should use max_sectors_kb, with alignment to minimum_io_size.
>>
>> The io_opt is used in raid array as minimal aligned size to get optimal
>> IO performance, not the upper bound. With the respect of this, use this
>> value for ra_pages make sense. However, if scsi is using this value as
>> IO upper bound, it's right this doesn't make sense.
> 
> Here is your issue. People misunderstood optimal_io_size and used that instead
> of using minimal_io_size/io_min limit for the granularity/alignment of IOs.
> Using optimal_io_size as the "granularity" for optimal IOs that do not require
> read-modify-write of RAID stripes is simply wrong in my optinion.
> io_min/minimal_io_size is the attribute indicating that.

Ok, looks like there are two problems now:

a) io_min, size to prevent performance penalty;

  1) For raid5, to avoid read-modify-write, this value should be 448k,
     but now it's 64k;
  2) For raid0/raid10, this value is set to 64k now, however, this value
     should not set. If the value in member disks is 4k, issue 4k is just
     fine, there won't be any performance penalty;
  3) For raid1, this value is not set, and will use member disks, this is
     correct.

b) io_opt, size to ???
  4) For raid0/raid10/rai5, this value is set to mininal IO size to get
     best performance.
  5) For raid1, this value is not set, and will use member disks.

Problem a can be fixed easily, and for problem b, I'm not sure how to
fix it as well, it depends on how we think io_opt is.

If io_opt should be *upper bound*, problem 4) should be fixed like case
5), and other places like blk_apply_bdi_limits() setting ra_pages by
io_opt should be fixed as well.

If io_opt should be *mininal IO size to get best performance*, problem
5) should be fixed like case 4), and I don't know if scsi or other
drivers to set initial io_opt should be changed. :(

Thanks,
Kuai

> 
> As for read_ahead_kb, it should be bounded by io_opt (upper bound) but should
> be initialized to a smaller value aligned to io_min (if io_opt is unreasonably
> large).
> 
> Given all of that and how misused io_opt seems to be, I am not sure how to fix
> this though.
> 

