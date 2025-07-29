Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A06262BE;
	Tue, 29 Jul 2025 06:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753770316; cv=none; b=I8R2llF8GKAgVc0glyXbx1KfxH+2C+oX/+fvKHAUT+3PGv2sbMjuROxdCEY0d4kona50tU3d96SUV/8cA7R23YXdTfx91jD79MwKsas4229RwdhSKZvKuzmA3l4KB5pqEyY2oyqJvGlUithmvkokveMu5rLocP+aHoVtJ02B35E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753770316; c=relaxed/simple;
	bh=A0F3+vXcBFEr9aTuAeflnKb4l3r3h80UXkHDV392pDk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UAPZhyfmfcDHnGhQpS0HUca90eIlFQwqz90v++cqIX6G0yQq5RzszBZM3eDtZIBk38an8vJn7XemRZgx2Mbj8PmahN4z20eVdc99P6wEpKwVrVM08tZYbRmTz8Kj88gNkNywJoiMdzhtB2TmSJFRJV3Bc9s5asKTb9Zg/pHGOH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4brlh70jLZzYQvLf;
	Tue, 29 Jul 2025 14:25:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C49C21A1B88;
	Tue, 29 Jul 2025 14:25:09 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXIBFDaYhoV5RrBw--.21629S3;
	Tue, 29 Jul 2025 14:25:09 +0800 (CST)
Subject: Re: Improper io_opt setting for md raid5
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
 =?UTF-8?Q?Csord=c3=a1s_Hunor?= <csordas.hunor@gmail.com>,
 Coly Li <colyli@kernel.org>, hch@lst.de, linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
 <c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com>
 <yq1zfcnljtw.fsf@ca-mkp.ca.oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <43515af4-2b4c-7ca0-ef85-44c8906a2f90@huaweicloud.com>
Date: Tue, 29 Jul 2025 14:25:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1zfcnljtw.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXIBFDaYhoV5RrBw--.21629S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW3CryUAF4UXw47tFW3GFg_yoW5GryxpF
	ZIkFyDtrn5Zr1jyw4qya47Xan0v395JF1rCFZ5CrWUWr1rJrW2qryxJryY9rZ3urs7Ww12
	vw4xZ34DWF1vv3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Hi, Martin

ÔÚ 2025/07/29 12:23, Martin K. Petersen Ð´µÀ:
> 
>> Ok, looks like there are two problems now:
>>
>> a) io_min, size to prevent performance penalty;
>>
>>   1) For raid5, to avoid read-modify-write, this value should be 448k,
>>      but now it's 64k;
> 
> You have two penalties for RAID5: Writes smaller than the stripe chunk
> size and writes smaller than the full stripe width.

Yes, the internal IO size for raid5 is 4k, however, only full stripe
write can prevent read-modify-write, which is 448k.
> 
>>   2) For raid0/raid10, this value is set to 64k now, however, this value
>>      should not set. If the value in member disks is 4k, issue 4k is just
>>      fine, there won't be any performance penalty;
> 
> Correct.
> 
>>   3) For raid1, this value is not set, and will use member disks, this is
>>      correct.
> 
> Correct.
> 
>> b) io_opt, size to ???
>>   4) For raid0/raid10/rai5, this value is set to mininal IO size to get
>>      best performance.
> 
> For RAID 0 you want to set io_opt to the stripe width. io_opt is for
> sequential, throughput-optimized I/O. Presumably the MD stripe chunk
> size has been chosen based on knowledge about the underlying disks and
> their performance. And thus maximum throughput will be achieved when
> doing full stripe writes across all drives.

Yes, raid0/raid10/raid5 are all the same logic, multiple aligned
sequential IO can get the number of data disks times sigle disk
performance.
> 
> For software RAID I am not sure how much this really matters in a modern
> context. It certainly did 25 years ago when we benchmarked things for
> XFS. Full stripe writes were a big improvement with both software and
> hardware RAID. But how much this matters today, I am not sure.

For raid1, write will be less than single disk performance. However, for
read, the io_opt should be the sum of io_opt of member disks, see
should_choose_next(), for sequential read, raid1 will switch to next
rdev to read after reading io_opf of this rdev.
> 
>>   5) For raid1, this value is not set, and will use member disks.
> 
> Correct.
> 
>>
>> If io_opt should be *upper bound*, problem 4) should be fixed like case
>> 5), and other places like blk_apply_bdi_limits() setting ra_pages by
>> io_opt should be fixed as well.
> 
> I understand Damien's "upper bound" interpretation but it does not take
> alignment and granularity into account. And both are imperative for
> io_opt.
> 
>> If io_opt should be *mininal IO size to get best performance*,
> 
> What is "best performance"? IOPS or throughput?
> 
> io_min is about IOPS. io_opt is about throughput.

I mean throughput here.
> 

Thanks,
Kuai

