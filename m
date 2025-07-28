Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B12026ADD;
	Mon, 28 Jul 2025 03:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753672138; cv=none; b=tWvGTSzpkLVYnZTDm6MEr478TfvJfi7Oq+Ykrb102VnGplZgOD2zzNm5eCTOJHlEddUJNFJx8wag6zHoiuK+BxCkh+BXaWyGyErhwjNPfj65H+2u3NUuC52t0oqc8ED796BYAm1lk7Gg2ezeEwwkdkyksKR+RNMMuuocRW5tUn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753672138; c=relaxed/simple;
	bh=7qaZXHMsyvClEbKXsb2SzURdHdOZhf36DJto8K1tHOs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=L8WzjesCrbWauUaTpyS7S5brgAwDFvThhdNNOvNhl0VET7fLvKcoyi1hXo+j5JaSBq2haOgPm/eeZk3lMex6wZW1vCFNJtIqtbXFsfpws5WUpR7Z41pnJAhuekk5yZSn+/i1xX2EwquIzyGZqQ1s11GIh5VcKnS+Mr/f9G/HzWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4br3N767kbzYQv4h;
	Mon, 28 Jul 2025 11:08:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8894F1A1097;
	Mon, 28 Jul 2025 11:08:54 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxPE6YZoVkLrBg--.36188S3;
	Mon, 28 Jul 2025 11:08:54 +0800 (CST)
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
Date: Mon, 28 Jul 2025 11:08:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHgxPE6YZoVkLrBg--.36188S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1rtFykGry8Xw15GF15urg_yoW8Kw13pa
	9rWa4DKrs3Xr1Yyw1vvayxWrZYyFsrGF48GF98KrWjvrs8Kr10vayxKrWF9r9FgrWrCw10
	qr45Wr98GF1kZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/28 10:41, Damien Le Moal 写道:
> On 7/28/25 9:55 AM, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/07/28 8:39, Damien Le Moal 写道:
>>> md setting its io_opt to 64K*number of drives in the array is strange... It
>>> does not have to be that large since io_opt is an upper bound and not a "issue
>>> that IO size for optimal performance". io_opt is simply a limit saying: if you
>>> exceed that IO size, performance may suffer.
>>>
>>
>> At least from Documentation, for raid arrays, multiple of io_opt is the
>> prefereed io size to the optimal io performance, and for raid5, this is
>> chunksize * data disks.
>>
>>> So a default of stride size x number of drives for the io_opt may be OK, but
>>> that should be bound to some reasonable value. Furthermore, this is likely
>>> suboptimal. I woulld think that setting the md array io_opt initially to
>>> min(all drives io_opt) x number of drives would be a better default.
>>
>> For raid5, this is not ok, the value have to be chunksize * data disks,
>> regardless of io_opt from member disks, otherwise raid5 have to issue
>> additional IO from other disks to build xor data.
>>
>> For example:
>>
>>   - write aligned chunksize to one disk, actually means read chunksize
>> old xor data,then write chunksize data and chunksize new xor data.
>>   - write aligned chunksize * data disks, new xor data can be build
>> directly without reading old xor data.
> 
> I understand all of that. But you missed my point: io_opt simply indicates an
> upper bound for an IO size. If exceeded, performance may be degraded. This has
> *nothing* to do with the io granularity, which for a RAID array should ideally
> be equal to stride size x number of data disks.
> 
> This is the confusion here. md setting io_opt to stride x number of disks in
> the array is simply not what io_opt is supposed to indicate.

ok, can I ask where is this upper bound for IO size from?

With git log, start from commit 7e5f5fb09e6f ("block: Update topology
documentation"), the documentation start contain specail explanation for
raid array, and the optimal_io_size says:

For RAID arrays it is usually the
stripe width or the internal track size.  A properly aligned
multiple of optimal_io_size is the preferred request size for
workloads where sustained throughput is desired.

And this explanation is exactly what raid5 did, it's important that
io size is aligned multiple of io_opt.

Thanks,
Kuai

> 

