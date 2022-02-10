Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7117C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 22:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345120AbiBJWnY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 17:43:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiBJWnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 17:43:23 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4763926D4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 14:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644533002; x=1676069002;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=sOpvZRGVgR9+tWVMJz7mvL1SbbXqKHS1Bm8b5LnMzZA=;
  b=kHVSibXAaaW0U2qdHhTUlR4qS8h+AH74pLhPz59xBpI3d4f6+VLcxybg
   PThJSA131a9wTCAKS/kkHJyN523h09jMBj+0E8msbSb73vAzIIftBh/0Q
   wyEcj2AL4HtIPwaraV6TUagjz9Px66Qzlni27hzDLijI2TMVShGJ+AatG
   KZ5VwHKmBkSFxOSVj+hFj24wmnveDBctSSQfniA6xMGsNGCu9A48Xje8c
   6bsIOeb9CnBVBHyfPEK/nODZCmTY3QAKdkvkItRgoETOXpR+Hu6TDN8vb
   s5eUZb2sHNkRgA7OoP/9jN9U7W+xuSOI4xSQvZK5JM1+L1BBs1Hd7+pO7
   w==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="197466364"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 06:43:21 +0800
IronPort-SDR: DtafHXQWld2/gutRf58bUpk+MQfoaKAajL2puoaek09uKcwejCMl7qNC8sUYbL8e08w5gJaFi3
 CLEF136iaGW2HlhAaUac4tDfbGR7Th34CkOBv98C3LfUAv5EJRhQuCwv1qO0f1k3UeKyKZ1HOU
 xgVC+pTEAzKQ2ksC5q08nfQrPs81OAwNtMj16VttX84/ban7T0X/a7awynOmsKvX6pRA7KjYHf
 ioVJz8iKWxs9WA92lwG0F6iqSL4wVfb76NoEFUUgNtOwV8RPvXJZI+vLidtMQzf84tnrr+N4Dg
 wrN1s8yaczAw1VpEfIS8HI+J
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 14:16:19 -0800
IronPort-SDR: H/7QhFyxzqhRwySLlo746DEnja0tpS4kS1BMUMOAgDkGAi8kq9SJ63Ud16nnLv62XKN8yykEsM
 Ng3CbkTEchqYpi0XMyiUhRnuMeYuRwUIz4VYayUoRP2L8mAjI52sEypyYYddF40piUU1g+Fwf5
 Cr5ot5ZU/ZPGBXVTy12uV8Z5Q69tUl/zyhgPsMi4ri3dfjQpgDhfPiFBJMMupZ+dw72NqQGk3U
 +at26sYfdO/Ao1UaIakclJjtbsMyioGcEvvs4EVsg916f+dLTGLrp7gT/bCu3ZSQ+w1vDLi39h
 h90=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 14:43:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvsGf1ttzz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 14:43:22 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644533001; x=1647125002; bh=sOpvZRGVgR9+tWVMJz7mvL1SbbXqKHS1Bm8
        b5LnMzZA=; b=oRyzZ11wQIkqQNzp30Y3cV2TVqcFvXvxwWKd68MFvvnGd73D0nB
        SQolVNkYAK1QIGxCfacvzWy5ZoC116e+W6zfBNwJUY0+joiwOc1b98yXf6lzw2Iu
        wkx1oVRWN0a7Rz5uJEmwvPqk7lIIWXo+xMdd8VwDrS6XNaW9bsA0AwL7fZoOGytz
        wLfG5JNXIW/H9/oVP7ZoHAXh7Tnzr+Z2lXTIFqDTr8Mmo7Op24HRickx5M8K6MVR
        QBhPra2B1rUGEacY7v/ejAF4Dos3o0oK9R6NRea6nz0DZ7XteEOVIwZVTmKkhPO6
        leTdh2rD8AaZIGq5TfIgxA0mjO9i/flrXIg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nLkwY7LRwjd6 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 14:43:21 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvsGc344mz1SHwl;
        Thu, 10 Feb 2022 14:43:20 -0800 (PST)
Message-ID: <f74f6a64-6055-ba15-84d9-1f38675c887f@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 07:43:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 20/20] scsi: pm8001: fix abort all task initialization
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-21-damien.lemoal@opensource.wdc.com>
 <f3606f3e-43ea-8c98-58f7-3572bbbf816c@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <f3606f3e-43ea-8c98-58f7-3572bbbf816c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/10/22 23:28, John Garry wrote:
> On 10/02/2022 11:42, Damien Le Moal wrote:
>> In pm80xx_send_abort_all(), the n_elem field of the ccb used is not
>> initialized to 0. This missing initialization sometimes lead to the
>> task completion path seeing the ccb with a non-zero n_elem resulting in
>> the execution of invalid dma_unmap_sg() calls in pm8001_ccb_task_free(),
>> causing a crash such as:
>>
>> [  197.676341] RIP: 0010:iommu_dma_unmap_sg+0x6d/0x280
>> [  197.700204] RSP: 0018:ffff889bbcf89c88 EFLAGS: 00010012
>> [  197.705485] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83d0bda0
>> [  197.712687] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88810dffc0d0
>> [  197.719887] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8881c790098b
>> [  197.727089] R10: ffffed1038f20131 R11: 0000000000000001 R12: 0000000000000000
>> [  197.734296] R13: ffff88810dffc0d0 R14: 0000000000000010 R15: 0000000000000000
>> [  197.741493] FS:  0000000000000000(0000) GS:ffff889bbcf80000(0000) knlGS:0000000000000000
>> [  197.749659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  197.755459] CR2: 00007f16c1b42734 CR3: 0000000004814000 CR4: 0000000000350ee0
>> [  197.762656] Call Trace:
>> [  197.765127]  <IRQ>
>> [  197.767162]  pm8001_ccb_task_free+0x5f1/0x820 [pm80xx]
>> [  197.772364]  ? do_raw_spin_unlock+0x54/0x220
>> [  197.776680]  pm8001_mpi_task_abort_resp+0x2ce/0x4f0 [pm80xx]
>> [  197.782406]  process_oq+0xe85/0x7890 [pm80xx]
>> [  197.786817]  ? lock_acquire+0x194/0x490
>> [  197.790697]  ? handle_irq_event+0x10e/0x1b0
>> [  197.794920]  ? mpi_sata_completion+0x2d70/0x2d70 [pm80xx]
>> [  197.800378]  ? __wake_up_bit+0x100/0x100
>> [  197.804340]  ? lock_is_held_type+0x98/0x110
>> [  197.808565]  pm80xx_chip_isr+0x94/0x130 [pm80xx]
>> [  197.813243]  tasklet_action_common.constprop.0+0x24b/0x2f0
>> [  197.818785]  __do_softirq+0x1b5/0x82d
>> [  197.822485]  ? do_raw_spin_unlock+0x54/0x220
>> [  197.826799]  __irq_exit_rcu+0x17e/0x1e0
>> [  197.830678]  irq_exit_rcu+0xa/0x20
>> [  197.834114]  common_interrupt+0x78/0x90
>> [  197.840051]  </IRQ>
>> [  197.844236]  <TASK>
>> [  197.848397]  asm_common_interrupt+0x1e/0x40
>>
> 
> That's nasty.
> 
>> Avoid this issue by always initializing the ccb n_elem field to 0 in
>> pm8001_send_abort_all(), pm8001_send_read_log() and
>> pm80xx_send_abort_all().
>>
>> Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>   drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
>>   drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
>>   2 files changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
>> index 8095eb0b04f7..d853e8d0195a 100644
>> --- a/drivers/scsi/pm8001/pm8001_hwi.c
>> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
>> @@ -1788,6 +1788,7 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>>   	ccb->device = pm8001_ha_dev;
>>   	ccb->ccb_tag = ccb_tag;
>>   	ccb->task = task;
>> +	ccb->n_elem = 0;
> 
> Do you think that it would be better to clear this field when we free 
> the tag/ccb in pm8001_ccb_task_free()? I will note that there are error 
> paths whch only free the tag (not ccb), so need to be careful there.

I am thinking that hunk like this one:

        ccb = &pm8001_ha->ccb_info[ccb_tag];

        ccb->device = pm8001_ha_dev;

        ccb->ccb_tag = ccb_tag;

        ccb->task = task;

To initialize a new ccb should be wrapped into a helper function, which
would also add initialization for the other ccb fields. There are many
places that have code like this, so that will also nicely cleanup the
code. Then the free path can be left alone. Hmm ?

> 
> BTW, I see that this never landed:
> https://lore.kernel.org/lkml/20211214090337.29156-1-niejianglei2021@163.com/

Repost !

> 
> Though alloc'ing a domain_device in pm8001_send_read_log() is questionable.

Yes, and the messages say "device not found" when the task completes so
I think it is 100% useless. But I did not touch that since it did not
seem to cause troubles.

> 
> Thanks,
> John
> 
>>   
>>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>>   
>> @@ -1849,6 +1850,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>>   	ccb->device = pm8001_ha_dev;
>>   	ccb->ccb_tag = ccb_tag;
>>   	ccb->task = task;
>> +	ccb->n_elem = 0;
>>   	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
>>   	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
>>   
>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
>> index 4d88c0dbcefc..902af4eefa26 100644
>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>> @@ -1801,6 +1801,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>>   	ccb->device = pm8001_ha_dev;
>>   	ccb->ccb_tag = ccb_tag;
>>   	ccb->task = task;
>> +	ccb->n_elem = 0;
>>   
>>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>>   
> 


-- 
Damien Le Moal
Western Digital Research
