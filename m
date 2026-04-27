Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F1B70836;
	Mon, 27 Apr 2026 01:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777254677; cv=none; b=bg8UpkVk7kD19LP3y5hEChhpXj/jNv7ly6JFpTXoTtgkBnuf/XsT4Jt2itJNXqjjMUO4NVk5A7MppcXfNYFw26B+UsT0FpnUOl12xQchWCSbpecUzDO09pGmttV4UNLWmWldNbWEFGedfOhbcr25E90tdrUV3gLbNukYPYSEa14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777254677; c=relaxed/simple;
	bh=Ev2z0U0tPZ1HhvRhCPYUtHjAhYc7tz54Ciq1xifLD3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SdAO9zwax1mCwJZ7xIzRRxY//85XHD+OOvM1VLr29QGT5bHGfw2ZRbHOPhHjuv5GSEV313atD/ZGRpu+SNAxKiJ0S/MrH/HCwDkNDTYmNkc26rf220s3L2vDYvKf67Ibs90oABXXIZZz9105J6XPomjOe8gGPfIrZ/H1yh70Jjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=mX9BB3NT; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="mX9BB3NT"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4XYqV1LCdUN1Pwd80ww6M3nTTS8cSsbcuBAqlxmTrvI=;
	b=mX9BB3NTnrXV0M3/m153Hcz7Te0CqJ373snCC8szR53c0gWPzM0G/DSQF/qY4OTNcZfvg0w92
	Jx++bFlHOM6a97uuHFQX0HF7XZyQbcoKPpeeTdzx/VYXQFws5osEg27hSCTpHYD2/KVrgn/lhlW
	Iwe5l8trChds1RmOtqgxmuI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4g3mb33707z1T4Hv;
	Mon, 27 Apr 2026 09:44:47 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 8580D4056E;
	Mon, 27 Apr 2026 09:51:04 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 27 Apr 2026 09:51:03 +0800
Message-ID: <a118114e-9828-06d6-d38b-2b426c92bb14@huawei.com>
Date: Mon, 27 Apr 2026 09:51:03 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] ata: libata-sata: retry hardreset when device detected
 but PHY not established
Content-Language: en-CA
To: Damien Le Moal <dlemoal@kernel.org>, <cassel@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<linux-ide@vger.kernel.org>
References: <20260425060447.1312763-1-yangxingui@huawei.com>
 <e8d237bc-7191-4881-924b-86a34ff0f3b9@kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <e8d237bc-7191-4881-924b-86a34ff0f3b9@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh500018.china.huawei.com (7.202.181.152) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/4/26 6:53, Damien Le Moal wrote:
> On 4/25/26 15:04, Xingui Yang wrote:
>> When sata_link_hardreset() detects that the link is offline, it currently
>> returns immediately without distinguishing the reason. According to SATA
>> specification, the SStatus register's det filed (bits 0-3) indicates:
>>    - 0x0: No device detected, PHY not communicating
>>    - 0x1: Device detected but PHY communication not established
>>    - 0x3: Device detected and PHY communication established
>>
>> This patch helps improve device detection reliability and adds a check
>> when the link is offline but det filed shows 0x1, return -EAGAIN to
>> trigger retry, rather than giving up immediately.
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> 
> This is a pure ATA patch so please CC the linux-ide list, not the linux-scsi list.

Ok.
> 
> Also, please check your mail setup: your email was in my Junk folder.

Well, patche was sent using the git send command.

> 
>> ---
>>   drivers/ata/libata-sata.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
>> index b9d635088f5f..e5bb92c38e38 100644
>> --- a/drivers/ata/libata-sata.c
>> +++ b/drivers/ata/libata-sata.c
>> @@ -667,8 +667,18 @@ int sata_link_hardreset(struct ata_link *link, const unsigned int *timing,
>>   	if (rc)
>>   		goto out;
>>   	/* if link is offline nothing more to do */
>> -	if (ata_phys_link_offline(link))
>> +	if (ata_phys_link_offline(link)) {
> 
> This is preceeded by a call to sata_link_resume(), which calls
> sata_link_debounce() and that function makes sure that DET is stable. So if
> after that DET still shows that their is no PHY, there is likely a big problem
> with it and it is super slow to be established.
> 
> In this case, I do not think that doing another hardreset is the right thing to
> do. Have you tried increasing the deadline for hardreset ? That deadline is used
> as the limit for the link debounce too.
> 
> Do you have a specific controller/device where you see this issue ? What exactly
> is the hardware setup where you see this issue ?

Our customer imports and verifies a new disk, there is an occasional 
failure in performing a hard reset on the disk and no exception log is 
generated for resume and debounce.

[   22.864418][ T1285] ahci 0000:76:03.0: Adding to iommu group 23
[   22.870403][ T1285] ahci 0000:76:03.0: controller does not support 
SXS, disabling CAP_SXS
[   22.878655][ T1285] ahci 0000:76:03.0: SSS flag set, parallel bus 
scan disabled
[   22.885966][ T1285] ahci 0000:76:03.0: AHCI 0001.0300 32 slots 2 
ports 6 Gbps 0x3 impl SATA mode
[   22.894743][ T1285] ahci 0000:76:03.0: flags: 64bit ncq sntf stag pm 
led clo only pmp fbs slum part ccc ems boh
[   22.905277][ T1285] scsi host0: ahci
[   22.909061][ T1285] scsi host1: ahci
[   22.966463][ T1285] ata1: SATA max UDMA/133 abar m4096@0xa3010000 
port 0xa3010100 irq 108
[   22.974629][ T1285] ata2: SATA max UDMA/133 abar m4096@0xa3010000 
port 0xa3010180 irq 109
[   25.242373][ T1286] ata1: SATA link down (SStatus 1 SControl 300) 
<==============
[   25.659901][ T1288] ata2: SATA link down (SStatus 0 SControl 300)
> 
> 
> 
>> +		u32 sstatus;
>> +
>> +		if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
>> +		    (sstatus & 0xf) == 0x1) {
>> +			ata_link_warn(link, "device detected but PHY not ready (SStatus %X), retrying\n",
>> +				      sstatus);
>> +			rc = -EAGAIN;
>> +		}
>> +
>>   		goto out;
>> +	}
>>   
>>   	/* Link is online.  From this point, -ENODEV too is an error. */
>>   	if (online)
> 
> 

Thanks,
Xingui
