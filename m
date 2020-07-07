Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0AAC433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 07:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C76AA206F6
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 07:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGGH7u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 03:59:50 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2432 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbgGGH7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 03:59:49 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 011B2FDC1BA9E9419402;
        Tue,  7 Jul 2020 08:59:48 +0100 (IST)
Received: from [127.0.0.1] (10.47.9.47) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 7 Jul 2020
 08:59:46 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com>
 <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
Date:   Tue, 7 Jul 2020 08:58:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.9.47]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>
>>>    #include <scsi/scsi.h>
>>>    #include <scsi/scsi_cmnd.h>
>>> @@ -113,6 +114,10 @@ unsigned int enable_sdev_max_qd;
>>>    module_param(enable_sdev_max_qd, int, 0444);
>>>    MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as
>> can_queue.
>>> Default: 0");
>>>
>>> +int host_tagset_disabled = 0;
>>> +module_param(host_tagset_disabled, int, 0444);
>>> +MODULE_PARM_DESC(host_tagset_disabled, "Shared host tagset
>> enable/disable
>>> Default: enable(1)");
>> The logic seems inverted here: for passing 1, I would expect Shared host
>> tagset enabled, while it actually means to disable, right?
> No. passing 1 means shared_hosttag support will be turned off.

Just reading "Shared host tagset enable/disable Default: enable(1)" 
looked inconsistent to me.

>>> +
>>>    MODULE_LICENSE("GPL");
>>>    MODULE_VERSION(MEGASAS_VERSION);
>>>    MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
>>> @@ -3115,6 +3120,18 @@ megasas_bios_param(struct scsi_device *sdev,
>> struct
>>> block_device *bdev,
>>>           return 0;
>>>    }
>>>
>>> +static int megasas_map_queues(struct Scsi_Host *shost)
>>> +{
>>> +       struct megasas_instance *instance;
>>> +       instance = (struct megasas_instance *)shost->hostdata;
>>> +
>>> +       if (instance->host->nr_hw_queues == 1)
>>> +               return 0;
>>> +
>>> +       return
>>> blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
>>> +                       instance->pdev,
>>> instance->low_latency_index_start);
>>> +}
>>> +
>>>    static void megasas_aen_polling(struct work_struct *work);
>>>
>>>    /**
>>> @@ -3423,8 +3440,10 @@ static struct scsi_host_template
>> megasas_template =
>>> {
>>>           .eh_timed_out = megasas_reset_timer,
>>>           .shost_attrs = megaraid_host_attrs,
>>>           .bios_param = megasas_bios_param,
>>> +       .map_queues = megasas_map_queues,
>>>           .change_queue_depth = scsi_change_queue_depth,
>>>           .max_segment_size = 0xffffffff,
>>> +       .host_tagset = 1,
>> Is your intention to always have this set for Scsi_Host, and just change
>> nr_hw_queues?
> Actually I wanted to turn off  this feature using host_tagset and not
> through nr_hw_queue. I will address this.
> 
> Additional request -
> In MR we have old controllers (called MFI_SERIES). We prefer not to change
> behavior for those controller.
> Having host_tagset in template does not allow to cherry pick different
> values for different type of controller.

Ok, so it seems sensible to add host_tagset to Scsi_Host structure also, 
to allow overwriting during probe time.

If you want to share an updated megaraid sas driver patch based on that, 
then that's fine. I can incorporate that change in the patch where we 
add host_tagset to the scsi host template.

> If host_tagset is part of Scsi_Host OR we add check in scsi_lib.c that
> host_tagset = 1 only make sense if nr_hw_queues > 1, we can cherry pick in
> driver.
> 
> 



