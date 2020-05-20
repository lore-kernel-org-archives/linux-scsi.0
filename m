Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AE5C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 08:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1169D207ED
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 08:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgETIfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 04:35:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4872 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbgETIfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 May 2020 04:35:10 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E2D215C98B339DF0585D;
        Wed, 20 May 2020 16:35:06 +0800 (CST)
Received: from [127.0.0.1] (10.74.219.194) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 20 May 2020
 16:35:00 +0800
Subject: Re: [PATCH] ata: libata: Remove unused parameter in function
 ata_sas_port_alloc()
To:     John Garry <john.garry@huawei.com>, <tj@kernel.org>,
        <martin.petersen@oracle.com>, <brking@us.ibm.com>
References: <1589958442-70575-1-git-send-email-chenxiang66@hisilicon.com>
 <8815c2e4-6e6e-8ce8-f7d8-b2c8eef788bf@huawei.com>
CC:     <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, c00284940 <c00284940@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <609642a4-26d4-02af-dec7-fee64bd25299@hisilicon.com>
Date:   Wed, 20 May 2020 16:35:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <8815c2e4-6e6e-8ce8-f7d8-b2c8eef788bf@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.219.194]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,

在 2020/5/20 15:51, John Garry 写道:
> On 20/05/2020 08:07, chenxiang wrote:
>> From: c00284940 <c00284940@huawei.com>
>
> Hi Xiang Chen,
>
> Please ensure author is same as signed-off person.

OK, thanks.
I will update it in next version.

>
> Thanks
>
>>
>> Input Parameter shost in function ata_sas_port_alloc() is not used, so
>> remove it.
>>
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> ---
>>   drivers/ata/libata-sata.c     | 4 +---
>>   drivers/scsi/ipr.c            | 2 +-
>>   drivers/scsi/libsas/sas_ata.c | 2 +-
>>   include/linux/libata.h        | 2 +-
>>   4 files changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
>> index c16423e..a3c83fe 100644
>> --- a/drivers/ata/libata-sata.c
>> +++ b/drivers/ata/libata-sata.c
>> @@ -1070,7 +1070,6 @@ EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
>>    *    port_alloc - Allocate port for a SAS attached SATA device
>>    *    @host: ATA host container for all SAS ports
>>    *    @port_info: Information from low-level host driver
>> - *    @shost: SCSI host that the scsi device is attached to
>>    *
>>    *    LOCKING:
>>    *    PCI/etc. bus probe sem.
>> @@ -1080,8 +1079,7 @@ EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
>>    */
>>     struct ata_port *ata_sas_port_alloc(struct ata_host *host,
>> -                    struct ata_port_info *port_info,
>> -                    struct Scsi_Host *shost)
>> +                    struct ata_port_info *port_info)
>>   {
>>       struct ata_port *ap;
>>   diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>> index 7d77997..331c41c 100644
>> --- a/drivers/scsi/ipr.c
>> +++ b/drivers/scsi/ipr.c
>> @@ -4816,7 +4816,7 @@ static int ipr_target_alloc(struct scsi_target 
>> *starget)
>>           if (!sata_port)
>>               return -ENOMEM;
>>   -        ap = ata_sas_port_alloc(&ioa_cfg->ata_host, 
>> &sata_port_info, shost);
>> +        ap = ata_sas_port_alloc(&ioa_cfg->ata_host, &sata_port_info);
>>           if (ap) {
>>               spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
>>               sata_port->ioa_cfg = ioa_cfg;
>> diff --git a/drivers/scsi/libsas/sas_ata.c 
>> b/drivers/scsi/libsas/sas_ata.c
>> index 5d716d3..0cdfae9 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -549,7 +549,7 @@ int sas_ata_init(struct domain_device *found_dev)
>>         ata_host_init(ata_host, ha->dev, &sas_sata_ops);
>>   -    ap = ata_sas_port_alloc(ata_host, &sata_port_info, shost);
>> +    ap = ata_sas_port_alloc(ata_host, &sata_port_info);
>>       if (!ap) {
>>           pr_err("ata_sas_port_alloc failed.\n");
>>           rc = -ENODEV;
>> diff --git a/include/linux/libata.h b/include/linux/libata.h
>> index 8bf5e59..5a6fb80 100644
>> --- a/include/linux/libata.h
>> +++ b/include/linux/libata.h
>> @@ -1228,7 +1228,7 @@ extern int sata_link_scr_lpm(struct ata_link 
>> *link, enum ata_lpm_policy policy,
>>   extern int ata_slave_link_init(struct ata_port *ap);
>>   extern void ata_sas_port_destroy(struct ata_port *);
>>   extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
>> -                       struct ata_port_info *, struct Scsi_Host *);
>> +                       struct ata_port_info *);
>>   extern void ata_sas_async_probe(struct ata_port *ap);
>>   extern int ata_sas_sync_probe(struct ata_port *ap);
>>   extern int ata_sas_port_init(struct ata_port *);
>>
>
>
> .
>


