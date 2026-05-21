Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A3033B6C4;
	Thu, 21 May 2026 09:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354305; cv=none; b=YHsuuNX9wZn5c2bPbTk6RVsRh5QcYA5p1Z/GqpjX5LjoKfnO9xK3rf6F1YLrDee+ClEH8MFK962Q9S2xHf32VjIgB68OPR6KY24X2I8T912rZehOEOpAW7/Yyrj9t815q+0hzbkfkrVVm+Tl28tcXFwzPurTi/yIX2AoQxJPHVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354305; c=relaxed/simple;
	bh=qPFszIGsGP8lg8WyKcwTRNwFDB2RJ5ADPWR2AHBWVC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Zn2q3S07mUCEbCHudgynwXNJHtyXftLj5LnftZ2i5bHh0QBf1EbAg9KbznMDsPJo6bjGgHvSbAxmB4lzc9IgUUD+I5VwzJC6+HWOrflLs+PzBgTLa/IH893gxxZXsNPlLSgyAOxAQCGLq22BCQJ4Lf7AzxkPBNtWTpTAlTxpWVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=D2YCLsZJ; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="D2YCLsZJ"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rIyzUnXWRbM50cxkKZx/Sdy2mBzDAoy8Jpq3SV6jbNY=;
	b=D2YCLsZJx/BHNsue6OIOqfg9XkXuAYYkHFzkbERS1ieuhZD40+9lsvUUq9bfczeZsuurBZbQB
	CZu+ppGOkbR9rM65F3Wn80x97uNxRZ5Nn5ZYPtyZwNh0wiNfJuB5uKO7rTxaBcalREFM81prNCl
	V2Ydcn3egiq4/n/SRcX+DeU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gLj2s4sk8zmV66;
	Thu, 21 May 2026 16:57:09 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id D543040538;
	Thu, 21 May 2026 17:04:52 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 21 May 2026 17:04:52 +0800
Message-ID: <5600f8fa-489a-9b81-9966-dc5d436c462e@huawei.com>
Date: Thu, 21 May 2026 17:04:51 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260515084531.866259-1-yangxingui@huawei.com>
 <20260515084531.866259-3-yangxingui@huawei.com>
 <b18e1085-1d77-4b54-ae4d-8ae5a50a79b9@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <b18e1085-1d77-4b54-ae4d-8ae5a50a79b9@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh200005.china.huawei.com (7.202.181.112) To
 kwepemj100018.china.huawei.com (7.202.194.12)

On 2026/5/21 16:13, John Garry wrote:
> On 15/05/2026 09:45, Xingui Yang wrote:
>> In sas_rediscover_dev(), when detecting a "flutter" condition (same SAS
>> address and compatible device type), the code assumes the device remains
>> unchanged and only handles SATA pending state recovery. However, this
>> approach misses two important scenarios:
>>
>> First, the flutter detection only compares SAS address and device type,
>> ignoring potential linkrate changes that may have already occurred.
>>
>> Second, after sas_ex_phy_discover() re-queries the expander phy, both
>> linkrate and attached SAS address may be updated. The current code does
>> not validate these changes against the existing child device.
>>
>> Add validation checks after sas_ex_phy_discover() to detect linkrate and
>> sas_addr changes. When changes are detected, mark the device as gone and
>> schedule rediscovery via libsas's async discovery pattern:
>> - Set phy_change_count and ex_change_count to -1 to force revalidation
>> - Unregister the device and schedule DISCE_REVALIDATE_DOMAIN event
>> - The old device is destroyed by sas_destruct_devices()
>> - New event triggers discovery via sas_discover_new() since
>>    attached_sas_addr is cleared
>>
>> Suggested-by: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 32 ++++++++++++++++++++++++++----
>>   1 file changed, 28 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>> b/drivers/scsi/libsas/sas_expander.c
>> index f55ae9a979cd..720db4128727 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -2017,15 +2017,39 @@ static int sas_rediscover_dev(struct 
>> domain_device *dev, int phy_id,
>>           goto out_free_resp;
>>       } else if (SAS_ADDR(sas_addr) == 
>> SAS_ADDR(phy->attached_sas_addr) &&
>>              dev_type_flutter(type, phy->attached_dev_type)) {
>> -        struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
>> +        struct domain_device *child_dev = sas_ex_to_dev(dev, phy_id);
>> +        bool need_rediscover = false;
>>           char *action = "";
>>           sas_ex_phy_discover(dev, phy_id);
>> -        if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
>> +        if (child_dev && dev_is_sata(child_dev) &&
>> +            phy->attached_dev_type == SAS_SATA_PENDING) {
>>               action = ", needs recovery";
>> -        pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
>> -             SAS_ADDR(dev->sas_addr), phy_id, action);
>> +        } else if (child_dev && phy->linkrate != child_dev->linkrate) {
>> +            pr_info("ex %016llx phy%02d linkrate changed from %d to 
>> %d\n",
>> +                SAS_ADDR(dev->sas_addr), phy_id,
>> +                child_dev->linkrate, phy->linkrate);
>> +            need_rediscover = true;
>> +        } else if (child_dev &&
>> +               SAS_ADDR(child_dev->sas_addr) != 
>> SAS_ADDR(phy->attached_sas_addr)) {
>> +            pr_info("ex %016llx phy%02d sas_addr changed from %016llx 
>> to %016llx\n",
>> +                SAS_ADDR(dev->sas_addr), phy_id,
>> +                SAS_ADDR(child_dev->sas_addr),
>> +                SAS_ADDR(phy->attached_sas_addr));
>> +            need_rediscover = true;
>> +        }
>> +
>> +        if (need_rediscover) {
>> +            set_bit(SAS_DEV_GONE, &child_dev->state);
>> +            phy->phy_change_count = -1;
>> +            ex->ex_change_count = -1;
> 
> the current code has following:
> 
> 
>      /* we always have to delete the old device when we went here */
>      pr_info("ex %016llx phy%02d replace %016llx\n",
>          SAS_ADDR(dev->sas_addr), phy_id,
>          SAS_ADDR(phy->attached_sas_addr));
>      sas_unregister_devs_sas_addr(dev, phy_id, last);
> 
>      res = sas_discover_new(dev, phy_id);
> 
> Can this be reused (to lose and find the device with updated info)? Or 
> why not good enough?
> 
> I don't know why you need full revalidation.

Hi, John
As the commit log. The existing pattern (unregister + sas_discover_new) 
handles the "replace" case where the SAS address changes completely, 
implying a different device.
For the flutter case where we detect linkrate/sas_addr changes, we 
cannot reuse this synchronous pattern because:
sas_unregister_devs_sas_addr() only marks the device as gone (sets 
SAS_DEV_GONE) and adds it to port->destroy_list. The actual sysfs 
cleanup (sas_rphy_delete) happens later in sas_destruct_devices() called 
at the end of sas_revalidate_domain() in sas_discover.c.
I did try the approach you suggested (unregister + sas_discover_new), 
but it produces sysfs duplicate directory errors:
Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain
Call trace:
  dump_backtrace+0x0/0x18c
  show_stack+0x14/0x1c
  dump_stack+0x88/0xac
  sysfs_warn_dup+0x64/0x7c
  sysfs_create_dir_ns+0x90/0xa0
  kobject_add_internal+0xa0/0x284
  kobject_add+0xb8/0x11c
  device_add+0xe8/0x598
  sas_port_add+0x24/0x50
  sas_ex_discover_devices+0xb10/0xc30

The async pattern with DISCE_REVALIDATE_DOMAIN ensures proper ordering:
1. Old device added to destroy_list
2. Current revalidate work completes → sas_destruct_devices() truly 
deletes old device's sysfs
3. New DISCE_REVALIDATE_DOMAIN event triggers → discovery starts with 
clean sysfs state
This follows libsas's async design pattern similar to sas_resume_devices 
in sas_port.c.

Thanks,
Xingui


