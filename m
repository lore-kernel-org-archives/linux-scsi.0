Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB64C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9673206F7
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 17:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403899AbgKXRie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:38:34 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2148 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403894AbgKXRie (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 12:38:34 -0500
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CgWQQ33H6z67H3h;
        Wed, 25 Nov 2020 01:35:58 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 24 Nov 2020 18:38:32 +0100
Received: from [10.210.169.36] (10.210.169.36) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 24 Nov 2020 17:38:31 +0000
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
To:     Marc Zyngier <maz@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <rafael@kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>, <linuxarm@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de>
 <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com>
 <874klmqu2r.fsf@nanos.tec.linutronix.de>
 <b86af904-2288-8b53-7e99-e763b73987d0@huawei.com>
 <87lfexp6am.fsf@nanos.tec.linutronix.de>
 <3acb7fde-eae2-a223-9cfd-f409cc2abba6@huawei.com>
 <873615oy8a.fsf@nanos.tec.linutronix.de>
 <4aab9d3b-6ca6-01c5-f840-459f945c7577@huawei.com>
 <87sg91ik9e.wl-maz@kernel.org>
 <0edc9a11-0b92-537f-1790-6b4b6de4900d@huawei.com>
 <afd97dd4b1e102ac9ad49800821231a4@kernel.org>
 <5a314713-c1ee-2d34-bee1-60beae274742@huawei.com>
 <0525a4bcf17a355cd141632d4f3714be@kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <702e1729-9a4b-b16f-6a58-33172b1a3220@huawei.com>
Date:   Tue, 24 Nov 2020 17:38:10 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0525a4bcf17a355cd141632d4f3714be@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.169.36]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Marc,

>> So initially in the msi_prepare method we setup the its dev - this is
>> from the mbigen probe. Then when all the irqs are unmapped later for
>> end device driver removal, we release this its device in
>> its_irq_domain_free(). But I don't see anything to set it up again. Is
>> it improper to have released the its device in this scenario?
>> Commenting out the release makes things "good" again.
> 
> Huh, that's ugly. The issue is that the device that deals with the
> interrupts isn't the device that the ITS knows about (there isn't a
> 1:1 mapping between mbigen and the endpoint).
> 
> The mbigen is responsible for the creation of the corresponding
> irqdomain, and and crucially for the "prepare" phase, which results
> in storing the its_dev pointer in info->scratchpad[0].
> 
> As we free all the interrupts associated with the endpoint, we
> free the its_dev (nothing else needs it at this point). On the
> next allocation, we reuse the damn its_dev pointer, and we're SOL.
> This is wrong, because we haven't removed the mbigen, only the
> device *connected* to the mbigen. And since the mbigen can be shared
> across endpoints, we can't reliably tear it down at all. Boo.
> 
> The only thing to do is to convey that by marking the its_dev as
> shared so that it isn't deleted when no LPIs are being used. After
> all, it isn't like the mbigen is going anywhere.

Right, I did consider this.

> 
> It is just that passing that information down isn't a simple affair,
> as msi_alloc_info_t isn't a generic type... Let me have a think.

I think that there is a way to circumvent the problem, which you might 
call hacky, but OTOH, not sure if there's much point changing mbigen or 
related infrastructure at this stage.

Anyway, so we have 128 irqs in total for the mbigen domain, but the 
driver only is interesting in something like irq indexes 1,2,72-81, and 
96-112. So we can just dispose the mappings for irq index 0-112 at 
removal stage, thereby keeping the its device around. We do still call 
platform_irq_count(), which sets up all 128 mappings, so maybe we should 
be unmapping all of these - this would be the contentious part. But 
maybe not, as the device driver is only interested in that subset, and 
has no business unmapping the rest.

With that change, the platform.c API would work a bit more like the pci 
msi code equivalent, where we request a min and max number of vectors. 
In fact, that platform.c change needs to be made anyway as 
platform_get_irqs_affinity() is broken currently for when nr_cpus < #hw 
queues.

Thoughts?

Thanks,
John

