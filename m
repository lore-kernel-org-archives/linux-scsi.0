Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1913595D;
	Tue,  1 Apr 2025 01:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743469958; cv=none; b=ko3S/7l0n6H6Ytc+PSkftHvh/ncgrTh8NnD5PCR/gCoSnRbRajCWfLEDKMEXTHP1c1r/o5aAGIPdGDlFCJMKByC1yaPcHwjFQQQ42WvE8p8rylsJNLxdQ4rnXWArCGKFCc9YSEN5DemD4kyW1hwVhGn7lSQSyqz7DUJwoOf1/fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743469958; c=relaxed/simple;
	bh=QtIuonNZCyJriEnhzrJtYOm/gXlIyDoxYmcdYo2eO+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jIFFRyMsu7GXc4OeF2FTOKEvX1FZ6nqjiqysgqG6Ei+Io9hMVHpr1CmehUqGYmB01zeU8ktfxbQhqPzql/O/EjG8dEHxYh/mHqWS1/BXqNJ12+tXm0SEOZ7TD69nPy1M/zgoVMpb397eE3uZ0y8doxsx94MzLSe6l5k/Lb3dFZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZRVJS1pH9z2CdS4;
	Tue,  1 Apr 2025 09:09:12 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id B678A1400F4;
	Tue,  1 Apr 2025 09:12:31 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 1 Apr 2025 09:12:31 +0800
Message-ID: <34a6208e-2802-8e3f-1a4d-92919407e7a8@huawei.com>
Date: Tue, 1 Apr 2025 09:12:30 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 1/5] scsi: hisi_sas: Add host_tagset_enable module param
 for v3 hw
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, Yihang Li <liyihang9@huawei.com>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>,
	<linux-ide@vger.kernel.org>
References: <20250329073236.2300582-1-liyihang9@huawei.com>
 <20250329073236.2300582-2-liyihang9@huawei.com>
 <f53505e6-9bfa-4553-91cc-497512a6977f@oracle.com>
 <e5ab4e5a-33d0-6102-1c5c-f1f83a752346@huawei.com>
 <c60bb344-5ac1-4e6a-b68c-217c403f7017@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <c60bb344-5ac1-4e6a-b68c-217c403f7017@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500017.china.huawei.com (7.202.181.151) To
 kwepemg100017.china.huawei.com (7.202.181.58)

On 2025/3/31 15:43, John Garry wrote:
> On 29/03/2025 09:49, yangxingui wrote:
>> Hi，John
>>
>> On 2025/3/29 16:50, John Garry wrote:
>>> On 29/03/2025 07:32, Yihang Li wrote:
>>>
>>> +
>>>
>>>> From: Xingui Yang<yangxingui@huawei.com>
>>>>
>>>> After driver exposes all HW queues and application submits IO to 
>>>> multiple
>>>> queues in parallel, if NCQ and non-NCQ commands are mixed to sata disk,
>>>> ata_qc_defer() causes non-NCQ commands to be requeued and possibly 
>>>> repeated
>>>> forever.
>>>
>>> I don't think that it is a good idea to mask out bugs with module 
>>> parameters.
>>>
>>> Was this the same libata/libsas issue reported some time ago?
>>
>> Yeah，related to this issue: https://lore.kernel.org/linux-block/ 
>> eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/
>>
>> And, Niklas tried to help fix this problem: https://lore.kernel.org/ 
>> linux-scsi/ZynmfyDA9R-lrW71@ryzen/
>>
>> Considering that there is no formal solution yet. And our users rarely 
>> use SATA disks and SAS disks together on a single machine. For this 
>> reason, they can flexibly turn off the exposure of multiple queues in 
>> the scenario of using only SATA disks. In addition, it is also 
>> convenient to conduct performance comparison tests to expose multiple 
>> hardware queues and single queues.
>>
> 
> The change in this series does not even solve the issues, as:
> - you do not guarantee no SAS/SATA mix without that module param enabled
> - the driver still uses managed interrupts in both cases, so with 
> disabling host_tagset you are now exposed to CPU hotplug issue of IO 
> being in-flight when HW queue interrupt is shutdown

Yes, there will be such problems.

> 
> And pm8001 driver will have the same issue, so we need to find a proper 
> fix.
> 
> Let me consider this issue more.

OK.

Thanks,
Xingui


