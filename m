Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602C22E3384;
	Tue,  1 Apr 2025 01:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743470330; cv=none; b=Jh55gP7PC/IurP07wz2ZOyjXU7XIkP8vK//OmbQtQ1KhQZo+39huDrkKxOA7uIHp1B2qUzLOxRSkriw8zWF7nCY7DJ05o0kbXu2ggjgfiotxvnLKVLBPijQ+nG6LY/g4jwczQC+ZEg9ss9A+73oOpYAWNoDmjBUcIyA3StyMBro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743470330; c=relaxed/simple;
	bh=mbNr9YD8iEA76ncaVf/NyHRgt9tSCOM7MMjGEKN6/QY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GZMZDeh7RMhsbqHGX1+kxeN+C/AqAmEz22GAR4+h5aQ0xzl1aAKA7UOjN0DA3dui9Z1DmORGVoLuv8qQ1U6EvW1SdxFjDkQyE9C8AeE7tEcet1wrsteuL+bwoNLGMnMpxN9RBCRubBFSmxOlGH7QBkqS7YYxczwt1XPHkeptSMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZRVTr0X5bztRK9;
	Tue,  1 Apr 2025 09:17:20 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B1C61800B1;
	Tue,  1 Apr 2025 09:18:45 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 1 Apr 2025 09:18:44 +0800
Message-ID: <11061634-c35f-02fc-ec2d-04f55e9d1e33@huawei.com>
Date: Tue, 1 Apr 2025 09:18:44 +0800
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
To: Niklas Cassel <cassel@kernel.org>
CC: John Garry <john.g.garry@oracle.com>, Yihang Li <liyihang9@huawei.com>,
	<martin.petersen@oracle.com>, <James.Bottomley@hansenpartnership.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>,
	<dlemoal@kernel.org>
References: <20250329073236.2300582-1-liyihang9@huawei.com>
 <20250329073236.2300582-2-liyihang9@huawei.com>
 <f53505e6-9bfa-4553-91cc-497512a6977f@oracle.com>
 <e5ab4e5a-33d0-6102-1c5c-f1f83a752346@huawei.com> <Z-pVGyZ1vMBhUfYH@ryzen>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <Z-pVGyZ1vMBhUfYH@ryzen>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500017.china.huawei.com (7.202.181.151) To
 kwepemg100017.china.huawei.com (7.202.181.58)



On 2025/3/31 16:40, Niklas Cassel wrote:
> Hello Xingui,
> 
> On Sat, Mar 29, 2025 at 05:49:47PM +0800, yangxingui wrote:
>> Hi，John
>>
>> On 2025/3/29 16:50, John Garry wrote:
>>> On 29/03/2025 07:32, Yihang Li wrote:
>>>
>>> +
>>>
>>>> From: Xingui Yang<yangxingui@huawei.com>
>>>>
>>>> After driver exposes all HW queues and application submits IO to multiple
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
>> Yeah，related to this issue: https://lore.kernel.org/linux-block/eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/
>>
>> And, Niklas tried to help fix this problem:
>> https://lore.kernel.org/linux-scsi/ZynmfyDA9R-lrW71@ryzen/
>>
>> Considering that there is no formal solution yet. And our users rarely use
>> SATA disks and SAS disks together on a single machine. For this reason, they
>> can flexibly turn off the exposure of multiple queues in the scenario of
>> using only SATA disks. In addition, it is also convenient to conduct
>> performance comparison tests to expose multiple hardware queues and single
>> queues.
> 
> The solution I sent is not good since it relies on EH.
> 
> One would need to come up with a better solution to fix libsas drivers,
> possibly a workqueue.
> 
> I think Damien is planning to add a workqueue submit path to libata,
> if so, perhaps we could base a better solution on top of that.

Thank you for your solution. As you said, we may need a better solution.

Thanks,
Xingui
.

