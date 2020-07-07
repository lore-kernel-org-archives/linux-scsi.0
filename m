Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03167C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 16:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E236B20674
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 16:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgGGQS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 12:18:58 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2435 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729122AbgGGQS5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 12:18:57 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id A36CEE2F4E952071E6B1;
        Tue,  7 Jul 2020 17:18:55 +0100 (IST)
Received: from [127.0.0.1] (10.47.9.47) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 7 Jul 2020
 17:18:54 +0100
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
 <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
Date:   Tue, 7 Jul 2020 17:17:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com>
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

On 07/07/2020 15:45, Kashyap Desai wrote:
>>>>>            .eh_timed_out = megasas_reset_timer,
>>>>>            .shost_attrs = megaraid_host_attrs,
>>>>>            .bios_param = megasas_bios_param,
>>>>> +       .map_queues = megasas_map_queues,
>>>>>            .change_queue_depth = scsi_change_queue_depth,
>>>>>            .max_segment_size = 0xffffffff,
>>>>> +       .host_tagset = 1,
>>>> Is your intention to always have this set for Scsi_Host, and just
>>>> change nr_hw_queues?
>>> Actually I wanted to turn off  this feature using host_tagset and not
>>> through nr_hw_queue. I will address this.
>>>
>>> Additional request -
>>> In MR we have old controllers (called MFI_SERIES). We prefer not to
>>> change behavior for those controller.
>>> Having host_tagset in template does not allow to cherry pick different
>>> values for different type of controller.
>> Ok, so it seems sensible to add host_tagset to Scsi_Host structure also,
>> to
>> allow overwriting during probe time.
>>
>> If you want to share an updated megaraid sas driver patch based on that,
>> then
>> that's fine. I can incorporate that change in the patch where we add
>> host_tagset to the scsi host template.
> If you share git repo link of next submission, I can send you megaraid_sas
> driver patch which you can include in series.

So this is my work-en-progress branch:

https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-shared-tags-rfc-v8

I just updated to include the change to have Scsi_Host.host_tagset in 
4291f617a02b commit ("scsi: Add host and host template flag 'host_tagset'")

megaraid sas support is not on the branch yet, but I think everything 
else required is. And it is mutable, so I'd clone it now if I were you - 
or just replace the required patch onto your v7 branch.

Thanks,
John
