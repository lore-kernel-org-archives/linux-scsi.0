Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501CE70807;
	Fri, 21 Feb 2025 01:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740103178; cv=none; b=uiSRieuLFVasLsNtmLy5MZfGaUi+AOGwm8c4fO0e95euzIV+rpfXqNJ0KqZRCGBWUy7m9o4CbST3VgSWtSEHlKsWdDByGZvJhx2WTnO4Ikb+ZWRiJ53tN6NHoPrLGuA6H3JREijaYswmS4zHoeIBcFpdQOrNLAB7G2ryuo3fE2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740103178; c=relaxed/simple;
	bh=dFajwVWivDjvHsLqhntYusRXxIFFRKr1iWNeckgkFks=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=l7j4sG/p7gfduLCEEZmSlp1J74ZfzayPB70yGXaZIJyWI8CbMkeD/kioBUCJH0aqEe5qBNVvOPXtjB+0B8A0/DFmSzWZkDbnduKNYUenj15ALVVhYwYNehj5nw6gl/KjrL8g8evzxGIGU36ur1FlciZ9c9uBCYSvMVlGNIMQ81I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YzY960HQTz1GC0f;
	Fri, 21 Feb 2025 09:54:50 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B053140158;
	Fri, 21 Feb 2025 09:59:28 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Feb 2025 09:59:27 +0800
Message-ID: <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
Date: Fri, 21 Feb 2025 09:59:27 +0800
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
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh200017.china.huawei.com (7.202.181.126) To
 kwepemg100017.china.huawei.com (7.202.181.58)

Hi, John

On 2025/2/21 1:35, John Garry wrote:
> On 20/02/2025 13:05, Xingui Yang wrote:
> 
> -john.garry@huawei.com (this has not worked in over 2 years ...)
Sorry, I used the wrong one.
> 
>> the SAS controller determines the disk to which I/Os are delivered based
>> on the port id in the DQ entry when SATA disk directly connected.
>>
>> When many phys were disconnected immediately and connected again during
>> I/O sending and port id of phys were changed and used by other link, I/O
>> may be sent to incorrect disk and data inconsistency on the SATA disk may
> 
> 
> So is the disk reported gone (from libsas point-of-view) after you 
> unplug? If not, why not?

The problem may occur in a scenario where multiple SATA disks are 
inserted almost at the same time. When phy reset is executed in error 
processing, other phys are also up, which may cause the hw port id 
corresponding to the phy to change. The log is as follows:

[ 4588.608924] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy2 link_rate=10(sata)
[ 4588.609039] sas: phy-8:2 added to port-8:4, phy_mask:0x4 
(5000000000000802)
[ 4588.609267] sas: DOING DISCOVERY on port 4, pid:69294
[ 4588.609276] hisi_sas_v3_hw 0000:b4:02.0: dev[13:5] found
[ 4588.671362] sas: ata40: end_device-8:4: dev error handler
[ 4588.846387] hisi_sas_v3_hw 0000:b4:02.0: phydown: phy2 phy_state=0xc3 
// phy2's hw port id assign by chip is released
[ 4588.846393] hisi_sas_v3_hw 0000:b4:02.0: ignore flutter phy2 down
[ 4588.919837] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy3 
link_rate=10(sata) // phy3 is assigned the hw port id previously used by 
phy2
[ 4589.029656] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy2 
link_rate=10(sata) // phy2's hw port id is assigned a new one
[ 4589.220662] ata40.00: ATA-9: HUH721010ALE600, T3C0, max UDMA/133
[ 4589.220666] ata40.00: 19532873728 sectors, multi 0: LBA48 NCQ (depth 
32), AA
[ 4589.233022] ata40.00: configured for UDMA/133

In view of the situation corresponding to the above log, the 
hisi_sas_port.id corresponding to phy2 has not been updated, and the old 
port id is still used, which will cause the IO delivered to phy2 to be 
abnormally delivered to the disk of phy3.

After force phy, the chip will check whether the phy information matches 
the port id and intercept this abnormal IO.

Thanks.
Xingui



