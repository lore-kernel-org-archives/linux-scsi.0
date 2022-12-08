Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73ECC3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 08:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLHIHU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 03:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHIHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 03:07:19 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482B7554D4
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 00:07:18 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NSRVm508xzJpCN;
        Thu,  8 Dec 2022 16:03:44 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 16:07:16 +0800
Subject: Re: [PATCH 6/6] scsi: libsas: factor out sas_ex_add_dev()
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-7-yanaijie@huawei.com>
 <22aca8ae-56df-4589-dc4e-82fbb00d0b1d@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <e762cb18-0da2-9fbe-d1c1-8ddc6b9daf55@huawei.com>
Date:   Thu, 8 Dec 2022 16:07:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <22aca8ae-56df-4589-dc4e-82fbb00d0b1d@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/5 17:31, John Garry wrote:
> On 04/12/2022 08:16, Jason Yan wrote:
>> Factor out sas_ex_add_dev() to be consistent with sas_ata_add_dev() and
>> unify the error handling.
>>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 68 +++++++++++++++++-------------
>>   1 file changed, 39 insertions(+), 29 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>> b/drivers/scsi/libsas/sas_expander.c
>> index 747f4fc795f4..3c72b167d43a 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -751,13 +751,46 @@ static void sas_ex_get_linkrate(struct 
>> domain_device *parent,
>>       child->pathways = min(child->pathways, parent->pathways);
>>   }
>> +static int sas_ex_add_dev(struct domain_device *parent, struct ex_phy 
>> *phy,
>> +              struct domain_device *child, int phy_id)
>> +{
>> +    struct sas_rphy *rphy;
>> +    int res;
>> +
>> +    child->dev_type = SAS_END_DEVICE;
>> +    rphy = sas_end_device_alloc(phy->port);
>> +    if (unlikely(!rphy))
> 
> nit: this is not fastpath so unlikely can be avoided
> 

ok. It is only a hint for the compiler so not a big deal. I can delete it.

>> +        return -ENOMEM;
>> +
>> +    child->tproto = phy->attached_tproto;
>> +    sas_init_dev(child);
>> +
>> +    child->rphy = rphy;
>> +    get_device(&rphy->dev);
>> +    rphy->identify.phy_identifier = phy_id;
>> +    sas_fill_in_rphy(child, rphy);
>> +
>> +    list_add_tail(&child->disco_list_node, &parent->port->disco_list);
>> +
>> +    res = sas_notify_lldd_dev_found(child);
>> +    if (res) {
>> +        pr_notice("notify lldd for device %016llx at %016llx:%02d 
>> returned 0x%x\n",
>> +                SAS_ADDR(child->sas_addr),
>> +                SAS_ADDR(parent->sas_addr), phy_id, res);
> 
> nit: these lines could be aligned with (, as it was before

Nice catch. Will fix.

> 
>> +        sas_rphy_free(child->rphy);
>> +        list_del(&child->disco_list_node);
>> +        return res;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static struct domain_device *sas_ex_discover_end_dev(
>>       struct domain_device *parent, int phy_id)
>>   {
>>       struct expander_device *parent_ex = &parent->ex_dev;
>>       struct ex_phy *phy = &parent_ex->ex_phy[phy_id];
>>       struct domain_device *child = NULL;
>> -    struct sas_rphy *rphy;
>>       int res;
>>       if (phy->attached_sata_host || phy->attached_sata_ps)
>> @@ -787,44 +820,21 @@ static struct domain_device 
>> *sas_ex_discover_end_dev(
>>       if ((phy->attached_tproto & SAS_PROTOCOL_STP) || 
>> phy->attached_sata_dev) {
>>           res = sas_ata_add_dev(parent, phy, child, phy_id);
>> -        if (res)
>> -            goto out_free;
>>       } else if (phy->attached_tproto & SAS_PROTOCOL_SSP) {
>> -        child->dev_type = SAS_END_DEVICE;
>> -        rphy = sas_end_device_alloc(phy->port);
>> -        /* FIXME: error handling */
> 
> so has the error handling been fixed now?

IIUC, the error handling is ok so this comment can be deleted.

Thanks,
Jason
