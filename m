Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117351898ED;
	Mon, 24 Feb 2025 09:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740389780; cv=none; b=rDefUWjcpjz7P8+0bRUrHO+TIwH6R3IbDjCfKycjzQUR3ANTPHveKMFCJhXFhIJPw2eAZqzo8986HwV6aM1dWPvaukHJEHfsdzUgqmgPdyFRFAEgKdB4AQKi8tBOPS5p/AbY+goMB9MLqVXRGJTJfdDr2b3DKdL0CzxweurghcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740389780; c=relaxed/simple;
	bh=pR4xtu7lvxep+GCFaglWEbG+d31fXeEcuVIUZfNfe8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=o2UHcJgvZqgCBEBbmk7J5GVOtKToEAOq3tVg2947g3UZZ/D6CHr4BjNJJlVku2rpSqZc4IZAArPQfR1evCeI61gq3EiCcTAWKeIuj7ZOlPlasXk5CnErgyOoR46Rjji6F3DowWbzmA5mRsvsnwlaxSDDgTZY1Y/zGbRvz8bY2ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Z1b9j4MPbzvWqv;
	Mon, 24 Feb 2025 17:32:25 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 214CD140257;
	Mon, 24 Feb 2025 17:36:09 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 24 Feb 2025 17:36:08 +0800
Message-ID: <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
Date: Mon, 24 Feb 2025 17:36:07 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <liyihang9@huawei.com>,
	<yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>, <liyangyang20@huawei.com>,
	<f.fangjian@huawei.com>, <xiabing14@h-partners.com>
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh100012.china.huawei.com (7.202.181.97) To
 kwepemg100017.china.huawei.com (7.202.181.58)

Hi Jonh,

On 2025/2/24 16:29, John Garry wrote:
> On 21/02/2025 01:59, yangxingui wrote:
>> Hi, John
>>
>> On 2025/2/21 1:35, John Garry wrote:
>>> On 20/02/2025 13:05, Xingui Yang wrote:
>>>
>>> -john.garry@huawei.com (this has not worked in over 2 years ...)
>> Sorry, I used the wrong one.
>>>
>>>> the SAS controller determines the disk to which I/Os are delivered 
>>>> based
>>>> on the port id in the DQ entry when SATA disk directly connected.
>>>>
>>>> When many phys were disconnected immediately and connected again during
>>>> I/O sending and port id of phys were changed and used by other link, 
>>>> I/O
>>>> may be sent to incorrect disk and data inconsistency on the SATA 
>>>> disk may
>>>
>>>
>>> So is the disk reported gone (from libsas point-of-view) after you 
>>> unplug? If not, why not?
>>
>> The problem may occur in a scenario where multiple SATA disks are 
>> inserted almost at the same time. When phy reset is executed in error 
>> processing, other phys are also up, which may cause the hw port id 
>> corresponding to the phy to change. The log is as follows:
>>
>> [ 4588.608924] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy2 
>> link_rate=10(sata)
>> [ 4588.609039] sas: phy-8:2 added to port-8:4, phy_mask:0x4 
>> (5000000000000802)
>> [ 4588.609267] sas: DOING DISCOVERY on port 4, pid:69294
>> [ 4588.609276] hisi_sas_v3_hw 0000:b4:02.0: dev[13:5] found
>> [ 4588.671362] sas: ata40: end_device-8:4: dev error handler
>> [ 4588.846387] hisi_sas_v3_hw 0000:b4:02.0: phydown: phy2 
>> phy_state=0xc3 // phy2's hw port id assign by chip is released
>> [ 4588.846393] hisi_sas_v3_hw 0000:b4:02.0: ignore flutter phy2 down
>> [ 4588.919837] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy3 
>> link_rate=10(sata) // phy3 is assigned the hw port id previously used 
>> by phy2
>> [ 4589.029656] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy2 
>> link_rate=10(sata) // phy2's hw port id is assigned a new one
>> [ 4589.220662] ata40.00: ATA-9: HUH721010ALE600, T3C0, max UDMA/133
>> [ 4589.220666] ata40.00: 19532873728 sectors, multi 0: LBA48 NCQ 
>> (depth 32), AA
>> [ 4589.233022] ata40.00: configured for UDMA/133
>>
>> In view of the situation corresponding to the above log, the 
>> hisi_sas_port.id corresponding to phy2 has not been updated, and the 
>> old port id is still used, which will cause the IO delivered to phy2 
>> to be abnormally delivered to the disk of phy3.
>>
>> After force phy, the chip will check whether the phy information 
>> matches the port id and intercept this abnormal IO.
>>
> 
> 
> So do you mean that all IO to this disk will error? If yes, then this is 
> good.
Yes, IO error or IO result does not meet expectations. As shown in the 
log below, due to an abnormal port ID, the SNs of the two disks read are 
the same.

[448000.504979] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy1 link_rate=10(sata)
[448000.505070] sas: phy-10:1 added to port-10:1, phy_mask:0x2 
(5000000000000a01)
[448000.505247] sas: DOING DISCOVERY on port 1, pid:2239187
[448000.505255] hisi_sas_v3_hw 0000:d4:02.0: dev[2:5] found
[448000.505274] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[448000.505295] sas: ata31: end_device-10:0: dev error handler
[448000.505299] sas: ata32: end_device-10:1: dev error handler
[448001.300517] hisi_sas_v3_hw 0000:d4:02.0: phydown: phy1 phy_state=0x1 
  // phy1's hw port id released
[448001.300522] hisi_sas_v3_hw 0000:d4:02.0: ignore flutter phy1 down
[448001.436187] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy2 
link_rate=10(sata) // phy2 occupies the hardware port ID of phy1
[448001.608766] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy1 
link_rate=10(sata) // phy1 was assigned a new hardware port ID
[448001.775605] ata32.00: ATA-11: WUH721816ALE6L4, PCGAW660, max UDMA/133
[448002.159364] sas: phy-10:2 added to port-10:2, phy_mask:0x4 
(5000000000000a02)
[448002.159575] sas: DOING DISCOVERY on port 2, pid:2239187
[448002.159581] hisi_sas_v3_hw 0000:d4:02.0: dev[3:5] found
[448002.159602] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[448002.159623] sas: ata31: end_device-10:0: dev error handler
[448002.159633] sas: ata32: end_device-10:1: dev error handler
[448002.159636] sas: ata33: end_device-10:2: dev error handler
[448002.393349] hisi_sas_v3_hw 0000:d4:02.0: phydown: phy2 phy_state=0x3
[448002.393354] hisi_sas_v3_hw 0000:d4:02.0: ignore flutter phy2 down
[448002.684937] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy2 link_rate=10(sata)
[448002.851639] ata33.00: ATA-11: WUH721816ALE6L4, PCGAW660, max UDMA/133
[448002.851644] ata33.00: 31251759104 sectors, multi 0: LBA48 NCQ (depth 32)

> 
> But I still don't like the handling in this patch. If we get a phy up, 
> then the directly-attached disk ideally should be gone already, so 
> should not have to do this handling.
There is no problem when the disk is removed. The current problem is 
that multiple phy up at the same time. When one of the phys up and 
enters error handler to execute hardreset, the phy will down and then 
up. other phy up will probably occupy the hw port id of the previous phy 
which do hardreset in EH.

Thanks,
Xingui
