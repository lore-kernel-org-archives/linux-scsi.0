Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F72AD518
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 01:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022705; cv=none; b=nMF3YzzjpQ58icBcG+t/vrQ4HrebD5by6F6blFrypXpuz5egdb04XIl1muirTkK6U8pOE3skE++hMLC9Kk3gbjG+KqF9bl39G1MtZmi2bl9ThDzn9kDhh3dKKaTmAMZBObfLc+YrmDvAKwMqu792xtPFclxFWaVTW4szlzggKEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022705; c=relaxed/simple;
	bh=QDAOQGO2uk7UjH/aEPnaMzE8ddV9MOA2N4MXZt1cJlM=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=llG8NE4QJxKWT53PIbNsyJueu2SAVcxmCH5Dg1W6M4r3YzuEIB8f0K284JhdrTor/GcaYIvEQwjNwUFz8h8yeGarm2ojlt+I4rypFpyxoyuSEIAk56rWL7IUHD7UPrvStH9TNpMbEEzhQufGjj4XYY26JdfS6JbA4gtqi1lBjcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4V7rQG5tbhz29lmC;
	Tue,  2 Apr 2024 09:48:54 +0800 (CST)
Received: from kwepemd200015.china.huawei.com (unknown [7.221.188.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 58584140124;
	Tue,  2 Apr 2024 09:51:39 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemd200015.china.huawei.com (7.221.188.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Tue, 2 Apr 2024 09:51:38 +0800
Subject: Re: [PATCH 2/2] scsi: hisi_sas: Modify the deadline for
 ata_wait_after_reset()
To: Damien Le Moal <dlemoal@kernel.org>, <jejb@linux.vnet.ibm.com>,
	<martin.petersen@oracle.com>
References: <20240401054914.721093-1-chenxiang66@hisilicon.com>
 <20240401054914.721093-3-chenxiang66@hisilicon.com>
 <98d9748f-a723-4b35-9ff6-1e425fe5d5b2@kernel.org>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <ceb11b1b-9da6-530e-c3c4-d7b8a39650b3@hisilicon.com>
Date: Tue, 2 Apr 2024 09:51:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <98d9748f-a723-4b35-9ff6-1e425fe5d5b2@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200015.china.huawei.com (7.221.188.21)

Hi Damien,


在 2024/4/1 星期一 15:08, Damien Le Moal 写道:
> On 4/1/24 14:49, chenxiang wrote:
>> From: Yihang Li <liyihang9@huawei.com>
>>
>> We found that the second parameter of function ata_wait_after_reset() is
>> incorrectly used. We call smp_ata_check_ready_type() to poll the device
>> type until the 30s timeout, so the correct deadline should be (jiffies +
>> 30000).
>>
>> Fixes: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
>> Signed-off-by: xiabing <xiabing12@h-partners.com>
>> Signed-off-by: Yihang Li <liyihang9@huawei.com>
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_main.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
>> index 097dfe4b620d..7245600aedb2 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
>> @@ -1796,8 +1796,10 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
>>   
>>   	if (dev_is_sata(device)) {
>>   		struct ata_link *link = &device->sata_dev.ap->link;
>> +		unsigned long deadline = ata_deadline(jiffies,
>> +				HISI_SAS_WAIT_PHYUP_TIMEOUT / HZ * 1000);
> At the very least, you should use jiffies_to_msecs() here. But I do not see the
> point though given that ata_deadline will do "jiffies + msecs_to_jiffies()".

We found the issue when reading the code of  libata-eh which uses 
ata_deadline() and ata_wait_after_reset().
So we modify it as above.

>
> So may be calling:
>
> 	rc = ata_wait_after_reset(link, jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT,
> 				  smp_ata_check_ready_type);
>
> May be simpler and more readable.

OK, it is more simpler and readable. Will change it in next version.

>
>>   
>> -		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
>> +		rc = ata_wait_after_reset(link, deadline,
>>   					  smp_ata_check_ready_type);
>>   	} else {
>>   		msleep(2000);

