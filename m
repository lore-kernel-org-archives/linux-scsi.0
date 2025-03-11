Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12521DE2DF;
	Tue, 11 Mar 2025 01:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741658003; cv=none; b=PvJWqs8UbXQ/IW7rrDQkl/51Ywscu3L0lDR0U96JawrLni7nuyH+VBKS12l6AHRvQSq1swTpvys0AsFEygYUEC73nK2mIpxfhAKTUP9mY9ea8ST2V+38i8iDEVmr5JVMRrk9wwhFgNm/3ffj4bPeNmvu7J6X+rGTEHvvHSn0g4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741658003; c=relaxed/simple;
	bh=szEY0YYmkbxUjsGeecngthEIAEf8kRWWKy2Mav+yNv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NT27jnfPQ1pPHgDEjC3DW5D43babuCIsHwPiU+3P373Z7sqT1UqDV6habtjfvEuLPQwJ2FtO/qJ3n/W0nexm0c+bYPYPUexfwbE/1FUKVFnStW4BXyhyD0M3gDNdbxzj42bFie0l4hLQv3mI/bnQsvtHuETqQTfRrGj376qiBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZBcBZ72n0zvWpL;
	Tue, 11 Mar 2025 09:49:26 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id EB73E1402CB;
	Tue, 11 Mar 2025 09:53:16 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Mar 2025 09:53:16 +0800
Message-ID: <b6dcc1e5-7f43-ec10-fbd9-48def2f6517f@huawei.com>
Date: Tue, 11 Mar 2025 09:53:15 +0800
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
 <d0a6b502-328b-2f83-3cdf-55c1effd80c1@huawei.com>
 <1fe3bb6b-1f7a-4188-83a3-f4c62e2a963d@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <1fe3bb6b-1f7a-4188-83a3-f4c62e2a963d@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500009.china.huawei.com (7.202.181.140) To
 kwepemg100017.china.huawei.com (7.202.181.58)



On 2025/3/11 1:45, John Garry wrote:
>>> Sure, but I am just trying to keep this simple. If you deform and 
>>> reform the port - and so lose and find the disk (which does the itct 
>>> config) - will that solve the problem?
>>>
>> We found that we need to perform lose and find for all devices on the 
>> port including the local phy and the remote phy. This process still 
>> requires traversing the phy information corresponding to all devices 
>> to reset and it is also necessary to consider that there is a race 
>> between device removal and the current process.  it looks similar to 
>> solution of update port id directly. And there will be the problem 
>> mentioned above. e.g, during error handling, the recovery state will 
>> last for more than 15 seconds, affecting the performance of other 
>> disks on the same host.
> 
> How do you even detect the port id inconsistency for the device attached 
> at the remote phy? For this series, you could detect it at the phy 
> up/down handler for the directly attached device - how would it be 
> triggered for the remote phy?

When the hardware port ID of the EXP is detected to have changed, the 
link reset is performed on the local phy of EXP in sequence, which will 
not trigger the lose and find process of the EXP device, and it will not 
trigger the lose and find process of the disks connected to the remote 
phy. Therefore, it is necessary to lose and found all devices separately 
to update the device's port id in itct.

local phy0 --------------------------- disk0

local phy1 --------------------------- disk1

local phy2 --------------------------- disk2

local phy3 --------------------------- disk3
                     _________
local phy4 --------|         |-------- disk4
                    |         |
local phy5 --------|         |-------- disk5
                    |         |
local phy6 --------|   EXP   |-------- disk6
                    |         |
local phy7 --------|         |-------- disk7
                    |_________|


Thanks,
Xingui
.

