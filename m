Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FAC2586E0;
	Tue, 29 Jul 2025 06:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753770586; cv=none; b=hqaedcv7psOd+oPbGLm6ubD72nmkRnsnczEQTbyXcK902zM3havLzTkpzsdyBljqZf0aFsLAWU1L6wDw5MTmei4tmCWbVqrCy6OuFbd6RoYS8yb3qnX/cwS6SPBU7JSuGTx0i0Bx6iM07KnAgtt7OpOgWMTQNczhbfblfiDRuj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753770586; c=relaxed/simple;
	bh=2imzZmV8rzTy3gvtooFNTJ+W74LMXmPA8IANAHdO8ts=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GX1MR2WynTxuyyfxFyGWF2nKFVgwSce5dEgADd+ZNiJ8SKyXyBAYnoir8NpmWAkCa12MGNvzCFiSIfslc5yVMQD5CWB8khKrh5s44G0UeKw7846Z7VKHn9ZxJ84S9zzhiqBqC9ey6/c5NpvGzOmzFCOSv5gEE62s19PHCkUuxIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4brlnK2h1RzKHMr0;
	Tue, 29 Jul 2025 14:29:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3A9F41A0CC1;
	Tue, 29 Jul 2025 14:29:40 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxNTaohooO9rBw--.62188S3;
	Tue, 29 Jul 2025 14:29:40 +0800 (CST)
Subject: Re: Improper io_opt setting for md raid5
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 Damien Le Moal <dlemoal@kernel.org>, =?UTF-8?Q?Csord=c3=a1s_Hunor?=
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
 <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
 <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
 <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
 <c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com>
 <9e85c424-6722-4315-b125-d0d26fc4574b@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8e7eeff1-fe15-9978-0612-1e2b47b265a9@huaweicloud.com>
Date: Tue, 29 Jul 2025 14:29:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <9e85c424-6722-4315-b125-d0d26fc4574b@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHgxNTaohooO9rBw--.62188S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCF4fJrW3CFW3Cw4kZr1DWrg_yoW5XF1xpr
	W5Ja4UKFs8Wr15tw1Ivw10gw4YqF47Gr1fXryDJryjvr909w1xJrWxKr4ruFyqqr4rJw10
	vr1DG34fXF1kZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/29 14:13, Hannes Reinecke 写道:
> On 7/28/25 11:02, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/07/28 15:44, Damien Le Moal 写道:
>>> On 7/28/25 4:14 PM, Yu Kuai wrote:
>>>>>> With git log, start from commit 7e5f5fb09e6f ("block: Update topology
>>>>>> documentation"), the documentation start contain specail 
>>>>>> explanation for
>>>>>> raid array, and the optimal_io_size says:
>>>>>>
>>>>>> For RAID arrays it is usually the
>>>>>> stripe width or the internal track size.  A properly aligned
>>>>>> multiple of optimal_io_size is the preferred request size for
>>>>>> workloads where sustained throughput is desired.
>>>>>>
>>>>>> And this explanation is exactly what raid5 did, it's important that
>>>>>> io size is aligned multiple of io_opt.
>>>>>
>>>>> Looking at the sysfs doc for the above fields, they are described 
>>>>> as follows:
>>>>>
>>>>> * /sys/block/<disk>/queue/minimum_io_size
>>>>>
>>>>> [RO] Storage devices may report a granularity or preferred
>>>>> minimum I/O size which is the smallest request the device can
>>>>> perform without incurring a performance penalty.  For disk
>>>>> drives this is often the physical block size.  For RAID arrays
>>>>> it is often the stripe chunk size.  A properly aligned multiple
>>>>> of minimum_io_size is the preferred request size for workloads
>>>>> where a high number of I/O operations is desired.
>>>>>
>>>>> So this matches the SCSI limit OPTIMAL TRANSFER LENGTH GRANULARITY 
>>>>> and for a
>>>>> RAID array, this indeed should be the stride x number of data disks.
>>>>
>>>> Do you mean stripe here? io_min for raid array is always just one
>>>> chunksize.
>>>
>>> My bad, yes, that is the definition in sysfs. So io_min is the stride 
>>> size, where:
>>>
>>> stride size x number of data disks == stripe_size.
>>>
>> Yes.
>>
>>> Note that chunk_sectors limit is the *stripe* size, not per drive 
>>> stride.
>>> Beware of the wording here to avoid confusion (this is all already super
>>> confusing !).
>>
>> This is something we're not in the same page :( For example, 8 disks
>> raid5, with default chunk size. Then the above calculation is:
>>
>> 64k * 7 = 448k
>>
>> The chunksize I said is 64k...
> 
> Hmm. I always thought that the 'chunksize' is the limit which I/O must
> not cross to avoid being split.
> So for RAID 4/5/6 I would have thought this to be the stride size,
> as MD must split larger I/O onto two disks.
> Sure, one could argue that the stripe size is the chunk size, but then
> MD will have to split that I/O...

BTW, I always thought chunksize to be stride size simply because there
is a metadata field in mddev superblock named 'chunk_size', which is the
stride size.

Thanks,
Kuai

> 
> Cheers,
> 
> Hannes

