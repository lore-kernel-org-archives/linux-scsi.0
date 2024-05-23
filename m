Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2220D4685;
	Thu, 23 May 2024 01:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716429015; cv=none; b=HCZrR9DcKHpASZepNWbW7kuVQegfZ+kXSduP9r/ZF82njTUIjP4z8WSy0vMiTdp+hBTLqNHxOHEgU9mGjW77WLwKqC058CQeNreANfJmVs0ln7lObCGxZubQAxNyw9ZcjwSKxAxZLWRWnXDaD8Scuv0vXXBMvOEtV7UJ/HqL/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716429015; c=relaxed/simple;
	bh=7Dn4o0QiVmmMDv2LKj+uI/z8kXliyMJZw5mnMU+G7bQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=I0RmIiL0BAZOWpZ9qOcp1Fc6YLFNkC/7FUCTDDLxLAopLBiutJ3XqDsEPd13ROO4QZHGtCAZRfejosoHA4wsP4OiwQoD4mc/NIMTeM7YQ+VfszU9A/6zAEL2EERB/HWgvIOSIHNTjCKp0HE+edkrOt9M/1t4MXNhzGczy1hQzDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VlB0P2n8yz1HCX9;
	Thu, 23 May 2024 09:48:37 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id 222831A0188;
	Thu, 23 May 2024 09:50:10 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 23 May 2024 09:50:09 +0800
Message-ID: <794b5fa3-0135-80cc-4b55-f48a430a58ca@huawei.com>
Date: Thu, 23 May 2024 09:50:09 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] driver core: Add log when devtmpfs create node failed
Content-Language: en-CA
To: Greg KH <gregkh@linuxfoundation.org>
CC: <rafael@kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<prime.zeng@hisilicon.com>, <liyihang9@huawei.com>, <kangfenglong@huawei.com>
References: <20240522114346.42951-1-yangxingui@huawei.com>
 <2024052221-pulverize-worrisome-37fb@gregkh>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <2024052221-pulverize-worrisome-37fb@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggpemm500017.china.huawei.com (7.185.36.178) To
 dggpemd100001.china.huawei.com (7.185.36.94)

Hi, Greg

On 2024/5/22 20:23, Greg KH wrote:
> On Wed, May 22, 2024 at 11:43:46AM +0000, Xingui Yang wrote:
>> Currently, no exception information is output when devtmpfs create node
>> failed, so add log info for it.
> 
> Why?  Who is going to do something with this?
We execute the lsscsi command after the disk is connected, we 
occasionally find that some disks do not have dev nodes and these disks 
cannot be used.
However, there is no abnormal log output during disk scanning. We 
analyze that it may be caused by the failure of devtmpfs create dev 
node, so the log is added here.
The lscsi command query results and kernel logs as follows:

[root@localhost]# lsscsi
[9:0:4:0]	disk	ATA	ST10000NM0086-2A SN05	-

kernel: [586669.541218] hisi_sas_v3_hw 0000:b4:04.0: phyup: phy0 
link_rate=10(sata)
kernel: [586669.541341] sas: phy-9:0 added to port-9:0, phy_mask:0x1 
(5000000000000900)
kernel: [586669.541511] sas: DOING DISCOVERY on port 0, pid:2330731
kernel: [586669.541518] hisi_sas_v3_hw 0000:b4:04.0: dev[4:5] found
kernel: [586669.630816] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
kernel: [586669.665960] hisi_sas_v3_hw 0000:b4:04.0: phydown: phy0 
phy_state=0xe
kernel: [586669.665964] hisi_sas_v3_hw 0000:b4:04.0: ignore flutter phy0 
down
kernel: [586669.863360] hisi_sas_v3_hw 0000:b4:04.0: phyup: phy0 
link_rate=10(sata)
kernel: [586670.024482] ata19.00: ATA-10: ST10000NM0086-2AA101, SN05, 
max UDMA/133
kernel: [586670.024487] ata19.00: 19532873728 sectors, multi 16: LBA48 
NCQ (depth 32), AA
kernel: [586670.027471] ata19.00: configured for UDMA/133
kernel: [586670.027490] sas: --- Exit sas_scsi_recover_host: busy: 0 
failed: 0 tries: 1
kernel: [586670.037541] sas: ata19: end_device-9:0: 
model:ST10000NM0086-2AA101 serial:            ZA2B3PR2
kernel: [586670.100856] scsi 9:0:4:0: Direct-Access     ATA 
ST10000NM0086-2A SN05 PQ: 0 ANSI: 5
kernel: [586670.101114] sd 9:0:4:0: [sdk] 19532873728 512-byte logical 
blocks: (10.0 TB/9.10 TiB)
kernel: [586670.101116] sd 9:0:4:0: [sdk] 4096-byte physical blocks
kernel: [586670.101125] sd 9:0:4:0: [sdk] Write Protect is off
kernel: [586670.101137] sd 9:0:4:0: [sdk] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
kernel: [586670.101620] sd 9:0:4:0: Attached scsi generic sg10 type 0
kernel: [586670.101714] sas: DONE DISCOVERY on port 0, pid:2330731, result:0
kernel: [586670.101731] sas: sas_form_port: phy0 belongs to port0 
already(1)!
kernel: [586670.152512] sd 9:0:4:0: [sdk] Attached SCSI disk

> 
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>>   drivers/base/core.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 5f4e03336e68..32a41e0472b2 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -3691,7 +3691,10 @@ int device_add(struct device *dev)
>>   		if (error)
>>   			goto SysEntryError;
>>   
>> -		devtmpfs_create_node(dev);
>> +		error = devtmpfs_create_node(dev);
>> +		if (error)
>> +			pr_info("devtmpfs create node for %s failed: %d\n",
>> +				dev_name(dev), error);
> 
> Why is an error message pr_info()?
Do you recommend using pr_err()?
> 
> And again, why is this needed?  If this needs to be checked, why are you
> now checking it but ignoring the error?
> 
> What would this help with?
As above, we want to get the error info when the dev node fails to be 
created. We currently haven't figured out how to handle this exception 
well. But judging from the problems we are currently encountering, some 
may be because the corresponding dev node already exists, causing the 
creation to fail, but the node information is incorrect and the device 
cannot be used. as follows:
[root@localhost]# ll /dev/sdk
-rw-------. 1 root root 5368709120 Jul 8 09:51 /dev/sdk

Do you have any suggestions?

Thanks,
Xingui

