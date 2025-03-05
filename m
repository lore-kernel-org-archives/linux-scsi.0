Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4C01DE8A5;
	Wed,  5 Mar 2025 08:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741162618; cv=none; b=G0zOkThtTOgcLBMdGx9s9aJnIpi70ViUbWISOgr0LKD0zxjAwas0gTffHiHJd90l1MlOdYLHFn7KtgELlXJcp4cvDuDdZRdvw97IrWsk/3BewfbALfXW6tg+MHImDOtuKlFgAUgLDqraxXU1lVzzoAtW/sze8h0lHkxmnWhwGuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741162618; c=relaxed/simple;
	bh=xdn/xOcMB2uTAeUPhEKphSYdsDKdfMF0A5NgKFP2jwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tepFSlQAJzY/sYwk2PhemZzVJSsaxGHsSqfCzEgLJbOJ0GB746jjAl0s9anx6OCuP9Dok1nI0CHr7ppcUxYuE0lj9D/U7WPsJA5RIqg/tVILRiEoIsV6XgKzzNCMKJdJCcvAJFdr6rUxa7HI98HLa1d6MUcTtcyVlb0raoO0M1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Z75006FBvzvWrb;
	Wed,  5 Mar 2025 16:13:04 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 55AA31800C9;
	Wed,  5 Mar 2025 16:16:52 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Mar 2025 16:16:51 +0800
Message-ID: <2a59bb5c-797c-3745-384e-791a74858930@huawei.com>
Date: Wed, 5 Mar 2025 16:16:51 +0800
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
 <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
 <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
 <d4b7ae14-5b60-883a-c4f8-be11fc51a4f7@huawei.com>
 <4f287a32-d24f-47dc-bec5-a4b94895e135@oracle.com>
 <9765d9c7-959f-3611-4093-89f7e941e2ba@huawei.com>
 <4279fe21-6db8-4deb-b5f7-663720637cf0@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <4279fe21-6db8-4deb-b5f7-663720637cf0@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh100007.china.huawei.com (7.202.181.92) To
 kwepemg100017.china.huawei.com (7.202.181.58)

Hi, John

On 2025/3/4 17:48, John Garry wrote:
> On 27/02/2025 08:33, yangxingui wrote:
>> Hi, John
>>
>> On 2025/2/26 16:57, John Garry wrote:
>>
>>>
>>> The lldd_dev_found CB is where you should set the itct, and it is 
>>> only possible to do that if you report the device gone first. So that 
>>> seems like a simpler solution.
> 
> Sure, something like that - you just need to get libsas to trigger the 
> proper hw port id assignment for the device. As for specific 
> implementation in the LLDD, that up to you guys.

Thank you for your suggestions. The disk was finally restored to normal, 
but the error handling took a long time. Since the error handling would 
set the host to the recovery state, other disks on the same host would 
be blocked for a long time. Log as follow:

[ 1351.602899] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=10(sata)
[ 1351.610892] sas: phy-1:3 added to port-1:0, phy_mask:0x8 
(5000000000000103)
[ 1351.611057] sas: DOING DISCOVERY on port 0, pid:7
[ 1351.611068] hisi_sas_v3_hw 0000:74:02.0: dev[1:5] found
[ 1351.617396] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 1351.618272] hisi_sas_v3_hw 0000:74:02.0: phyup: phy2 link_rate=10(sata)
[ 1351.624300] sas: ata10: end_device-1:0: dev error handler
[ 1351.670954] hisi_sas_v3_hw 0000:74:02.0: phydown: phy3 phy_state=0xf7
[ 1351.678388] hisi_sas_v3_hw 0000:74:02.0: ignore flutter phy3 down
[ 1351.685465] hisi_sas_v3_hw 0000:74:02.0: phyup: phy4 link_rate=11
[ 1351.841167] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=10(sata)
[ 1351.849054] hisi_sas_v3_hw 0000:74:02.0: phy3's hw port id changed 
from 0 to 1
[ 1351.857967] hisi_sas_v3_hw 0000:74:02.0: phydown: phy3 phy_state=0xf7
[ 1352.006552] hisi_sas_v3_hw 0000:74:02.0: task prep: SATA/STP port0 
not attach device
[ 1352.015679] hisi_sas_v3_hw 0000:74:02.0: task exec: failed[-70]!
[ 1352.022734] sas: lldd_execute_task returned: -70
[ 1352.022754] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[ 1352.041168] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=10(sata)
[ 1357.218587] hisi_sas_v3_hw 0000:74:02.0: erroneous completion 
iptt=4019 task=0000000055585b33 dev id=1 addr=5000000000000103 CQ hdr: 
0x8000007 0x10fb3 0x0 0x0 Error info: 0x0 0x0 0x0 0x0
[ 1357.237298] hisi_sas_v3_hw 0000:74:02.0: task prep: SATA/STP port0 
not attach device
[ 1357.246666] hisi_sas_v3_hw 0000:74:02.0: task exec: failed[-70]!
[ 1357.253850] hisi_sas_v3_hw 0000:74:02.0: abort tmf: executing 
internal task failed: -70
[ 1357.263487] hisi_sas_v3_hw 0000:74:02.0: ata disk 5000000000000103 
reset failed
[ 1357.272487] hisi_sas_v3_hw 0000:74:02.0: phydown: phy3 phy_state=0xf7
[ 1357.280131] hisi_sas_v3_hw 0000:74:02.0: ignore flutter phy3 down
[ 1357.453175] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=10(sata)
[ 1357.618532] hisi_sas_v3_hw 0000:74:02.0: task prep: SATA/STP port0 
not attach device
[ 1357.627915] hisi_sas_v3_hw 0000:74:02.0: task exec: failed[-70]!
[ 1357.635086] sas: lldd_execute_task returned: -70
[ 1357.635108] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[ 1362.850591] hisi_sas_v3_hw 0000:74:02.0: erroneous completion 
iptt=4020 task=0000000055585b33 dev id=1 addr=5000000000000103 CQ hdr: 
0x8000007 0x10fb4 0x0 0x0 Error info: 0x0 0x0 0x0 0x0
[ 1362.869450] hisi_sas_v3_hw 0000:74:02.0: task prep: SATA/STP port0 
not attach device
[ 1362.878890] hisi_sas_v3_hw 0000:74:02.0: task exec: failed[-70]!
[ 1362.886100] hisi_sas_v3_hw 0000:74:02.0: abort tmf: executing 
internal task failed: -70
[ 1362.895779] hisi_sas_v3_hw 0000:74:02.0: ata disk 5000000000000103 
reset failed
[ 1362.904789] hisi_sas_v3_hw 0000:74:02.0: phydown: phy3 phy_state=0xf7
[ 1362.912447] hisi_sas_v3_hw 0000:74:02.0: ignore flutter phy3 down
[ 1363.089166] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=10(sata)
[ 1363.254527] hisi_sas_v3_hw 0000:74:02.0: task prep: SATA/STP port0 
not attach device
[ 1363.263891] hisi_sas_v3_hw 0000:74:02.0: task exec: failed[-70]!
[ 1363.271052] sas: lldd_execute_task returned: -70
[ 1363.271077] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[ 1368.482569] hisi_sas_v3_hw 0000:74:02.0: erroneous completion 
iptt=4021 task=0000000055585b33 dev id=1 addr=5000000000000103 CQ hdr: 
0x8000007 0x10fb5 0x0 0x0 Error info: 0x0 0x0 0x0 0x0
[ 1368.501395] hisi_sas_v3_hw 0000:74:02.0: task prep: SATA/STP port0 
not attach device
[ 1368.510834] hisi_sas_v3_hw 0000:74:02.0: task exec: failed[-70]!
[ 1368.518058] hisi_sas_v3_hw 0000:74:02.0: abort tmf: executing 
internal task failed: -70
[ 1368.527745] hisi_sas_v3_hw 0000:74:02.0: ata disk 5000000000000103 
reset failed
[ 1368.536750] hisi_sas_v3_hw 0000:74:02.0: phydown: phy3 phy_state=0xf7
[ 1368.544401] hisi_sas_v3_hw 0000:74:02.0: ignore flutter phy3 down
[ 1368.721173] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=10(sata)
[ 1368.886544] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[ 1368.896602] sas: sas_probe_sata: for direct-attached device 
5000000000000103 returned -19
[ 1368.906510] hisi_sas_v3_hw 0000:74:02.0: dev[1:5] is gone
[ 1368.913148] hisi_sas_v3_hw 0000:74:02.0: erroneous completion 
iptt=4022 task=00000000ee9f5e36 dev id=1 addr=5000000000000103 CQ hdr: 
0x8000007 0x10fb6 0x0 0x0 Error info: 0x0 0x0 0x0 0x0
[ 1368.932057] sas: DONE DISCOVERY on port 0, pid:7, result:0
[ 1369.571030] sas: phy-1:3 added to port-1:0, phy_mask:0x8 
(5000000000000103)
[ 1369.571201] sas: DOING DISCOVERY on port 0, pid:7
[ 1369.571205] hisi_sas_v3_hw 0000:74:02.0: dev[9:5] found
[ 1369.577546] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 1369.584543] sas: ata12: end_device-1:0: dev error handler
[ 1369.584653] sas: ata11: end_device-1:1: dev error handler
[ 1369.611048] hisi_sas_v3_hw 0000:74:02.0: phydown: phy3 phy_state=0xf7
[ 1369.618639] hisi_sas_v3_hw 0000:74:02.0: ignore flutter phy3 down
[ 1369.793175] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=10(sata)
[ 1374.447031] ata12.00: ATA-10: ST2000NM0055-1V4104, TN05, max UDMA/133
[ 1374.454648] ata12.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 32)
[ 1374.463850] ata12.00: configured for UDMA/133
[ 1374.469363] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[ 1374.506234] scsi 1:0:6:0: Direct-Access     ATA      ST2000NM0055-1V4 
TN05 PQ: 0 ANSI: 5
[ 1374.515932] sas: DONE DISCOVERY on port 0, pid:7, result:0
[ 1374.515986] sas: sas_form_port: phy3 belongs to port0 already(1)!
[ 1374.523240] sas: sas_form_port: phy3 belongs to port0 already(1)!
[ 1374.538915] sas: sas_form_port: phy3 belongs to port0 already(1)!

Thanks,
Xingui
