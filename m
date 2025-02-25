Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F46213D897;
	Tue, 25 Feb 2025 01:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740448110; cv=none; b=cNNBX/4kiYV4LN4Y5TCrPgQtOmXtBey6Ij2WsLg8JUmesbYxW1LvFoGSW/Te7YVy50m9ZnyNYfgKC7kJ9EYxrgf3QhKIuOlusU2B3jH1R6+3LNsKT7Nxg4ZSb8UP+h9TqDSCBUuMcgD0ION3ahy4EOUTx97JwaY7xBi/uCg6fe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740448110; c=relaxed/simple;
	bh=nymM0ct3LcKrBqldgPir/y62KHjxez7MAYPfwaiGtoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Yh3pEfo3motVo5hYay8IoZ1otwzCvslbrrOTm/JORwj6IF14x9fczG5IhpnobaW01/RqsFarJt3sqodJVy3reyUtdZnLQ1MAAoYc6NEAjKy9pFsf2wspPbpYoTbmjw7tFE6ZY0yylOKVhG+uRCvYKsg2N8jSoUMOFEkGvMGnrL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Z20l46r9LzHxf3;
	Tue, 25 Feb 2025 09:44:16 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C4E61A0188;
	Tue, 25 Feb 2025 09:48:19 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 25 Feb 2025 09:48:18 +0800
Message-ID: <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
Date: Tue, 25 Feb 2025 09:48:18 +0800
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
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
 <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500016.china.huawei.com (7.202.181.150) To
 kwepemg100017.china.huawei.com (7.202.181.58)



On 2025/2/25 1:34, John Garry wrote:
> On 24/02/2025 13:12, yangxingui wrote:
>> Hi, John
>>
>> On 2025/2/24 20:21, John Garry wrote:
>>> On 24/02/2025 09:36, yangxingui wrote:
>>>>>
>>>>>
>>>>> So do you mean that all IO to this disk will error? If yes, then 
>>>>> this is good.
>>>> Yes, IO error or IO result does not meet expectations. As shown in 
>>>> the log below, due to an abnormal port ID, the SNs of the two disks 
>>>> read are the same.
>>>
>>> Do you mean that this is mainline kernel behaviour, below:
>> Yes
>>>
>>>>
>>>> [448000.504979] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy1 
>>>> link_rate=10(sata)
>>>> [448000.505070] sas: phy-10:1 added to port-10:1, phy_mask:0x2 
>>>> (5000000000000a01)
>>>> [448000.505247] sas: DOING DISCOVERY on port 1, pid:2239187
>>>> [448000.505255] hisi_sas_v3_hw 0000:d4:02.0: dev[2:5] found
>>>> [448000.505274] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>>> [448000.505295] sas: ata31: end_device-10:0: dev error handler
>>>> [448000.505299] sas: ata32: end_device-10:1: dev error handler
>>>> [448001.300517] hisi_sas_v3_hw 0000:d4:02.0: phydown: phy1 
>>>> phy_state=0x1   // phy1's hw port id released
>>>> [448001.300522] hisi_sas_v3_hw 0000:d4:02.0: ignore flutter phy1 down
>>>> [448001.436187] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy2 
>>>> link_rate=10(sata) // phy2 occupies the hardware port ID of phy1
>>>> [448001.608766] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy1 
>>>> link_rate=10(sata) // phy1 was assigned a new hardware port ID
>>>> [448001.775605] ata32.00: ATA-11: WUH721816ALE6L4, PCGAW660, max 
>>>> UDMA/133
>>>> [448002.159364] sas: phy-10:2 added to port-10:2, phy_mask:0x4 
>>>> (5000000000000a02)
>>>> [448002.159575] sas: DOING DISCOVERY on port 2, pid:2239187
>>>> [448002.159581] hisi_sas_v3_hw 0000:d4:02.0: dev[3:5] found
>>>> [448002.159602] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>>> [448002.159623] sas: ata31: end_device-10:0: dev error handler
>>>> [448002.159633] sas: ata32: end_device-10:1: dev error handler
>>>> [448002.159636] sas: ata33: end_device-10:2: dev error handler
>>>> [448002.393349] hisi_sas_v3_hw 0000:d4:02.0: phydown: phy2 
>>>> phy_state=0x3
>>>> [448002.393354] hisi_sas_v3_hw 0000:d4:02.0: ignore flutter phy2 down
>>>> [448002.684937] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy2 
>>>> link_rate=10(sata)
>>>> [448002.851639] ata33.00: ATA-11: WUH721816ALE6L4, PCGAW660, max 
>>>> UDMA/133
>>>> [448002.851644] ata33.00: 31251759104 sectors, multi 0: LBA48 NCQ 
>>>> (depth 32)
>>>>
>>>>>
>>>>> But I still don't like the handling in this patch. If we get a phy 
>>>>> up, then the directly-attached disk ideally should be gone already, 
>>>>> so should not have to do this handling.
>>>> There is no problem when the disk is removed. The current problem is 
>>>> that multiple phy up at the same time. When one of the phys up and 
>>>> enters error handler to execute hardreset, the phy will down and 
>>>> then up. other phy up will probably occupy the hw port id of the 
>>>> previous phy which do hardreset in EH.
>>>
>>> Could you do this work (itct update) in lldd_ata_check_ready CB?
>>
>> It's a good idea only for sata disks, but the current problem is not 
>> only the scenario of connecting the sata disk. This phenomenon 
>> occasionally occurs when the SAS disk is connected after the 
>> controller is reset. The following is the log of the stress test 
>> recurrence after incorporating the current repair patch. Although we 
>> called hisi_sas_refresh_port_id() on controller reset.
>>
>> [ 5387.235015] hisi_sas_v3_hw 0000:74:02.0: I_T nexus reset: internal 
>> abort (-5)
>> [ 5387.242126] sas: clear nexus ha
>> [ 5387.245283] hisi_sas_v3_hw 0000:74:02.0: controller resetting...
>> [ 5388.908489] hisi_sas_v3_hw 0000:74:02.0: phyup: phy5 
>> link_rate=10(sata)
>> [ 5388.915090] hisi_sas_v3_hw 0000:74:02.0: phyup: phy6 
>> link_rate=10(sata)
>> [ 5388.934505] hisi_sas_v3_hw 0000:74:02.0: phyup: phy0 link_rate=9(sata)
>> [ 5388.941009] hisi_sas_v3_hw 0000:74:02.0: phyup: phy1 link_rate=9(sata)
>> [ 5388.950976] hisi_sas_v3_hw 0000:74:02.0: phyup: phy4 link_rate=11
>> [ 5388.957048] hisi_sas_v3_hw 0000:74:02.0: phyup: phy7 link_rate=11
>> [ 5388.980097] hisi_sas_v3_hw 0000:74:02.0: phyup: phy2 link_rate=11
>> [ 5388.986169] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=11 
>> // phy3 attached a sas disk.
>> [ 5389.065103] hisi_sas_v3_hw 0000:74:02.0: task prep: SAS port1 not 
>> attach device
>> [ 5389.072409] sas: executing TMF task failed 5000c500ae49c8f1 (-70)
>> [ 5389.078492] hisi_sas_v3_hw 0000:74:02.0: task prep: SAS port1 not 
>> attach device
>> [ 5389.085780] sas: executing TMF task failed 5000c500ae49c8f1 (-70)
>> [ 5389.091861] hisi_sas_v3_hw 0000:74:02.0: task prep: SAS port1 not 
>> attach device
>> [ 5389.099146] sas: executing TMF task failed 5000c500ae49c8f1 (-70)
>> [ 5389.107419] hisi_sas_v3_hw 0000:74:02.0: controller reset complete 
>> // controller reset finished
>> [ 5389.113686] hisi_sas_v3_hw 0000:74:02.0: phydown: phy0 phy_state=0xfe
>> [ 5389.120099] hisi_sas_v3_hw 0000:74:02.0: ignore flutter phy0 down
>> [ 5389.136399] hisi_sas_v3_hw 0000:74:02.0: phy3's hw port id changed 
>> from 1 to 7
>> [ 5389.308114] hisi_sas_v3_hw 0000:74:02.0: phyup: phy0 link_rate=9(sata)
>>
> 
> 
> pm8001 sends sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,) link 
> reset errors - can you consider doing that in hisi_sas_update_port_id() 
> when you find an inconstant port id?
Currently during phyup, the hw port id may change, and the corresponding 
hisi_sas_port.id and the port id in itct are not updated synchronously. 
The problem caused is not a link error, so we don't need deform port, 
just update the port id when phyup.

Thanks.
Xingui

