Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B5DC2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 12:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA2EA20657
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 12:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387918AbgKWMze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 07:55:34 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2138 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387524AbgKWMzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 07:55:13 -0500
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CfnBR6d03z67Gn6;
        Mon, 23 Nov 2020 20:53:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 23 Nov 2020 13:55:05 +0100
Received: from [10.47.7.144] (10.47.7.144) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 23 Nov
 2020 12:55:04 +0000
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
From:   John Garry <john.garry@huawei.com>
Message-ID: <0edc9a11-0b92-537f-1790-6b4b6de4900d@huawei.com>
Date:   Mon, 23 Nov 2020 12:54:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <87sg91ik9e.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.7.144]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Marc,

>>> Right, but if the driver is removed then the interrupts should be
>>> deallocated, right?
>>>
>>
>> When removing the driver we just call free_irq(), which removes the
>> handler and disables the interrupt.
>>
>> But about the irq_desc, this is created when the mapping is created in
>> irq_create_fwspec_mapping(), and I don't see this being torn down in
>> the driver removal, so persistent in that regard.
> 
> If the irq_descs are created via the platform_get_irq() calls in
> platform_get_irqs_affinity(), I'd expect some equivalent helper to
> tear things down as a result, calling irq_dispose_mapping() behind the
> scenes.
> 

So this looks lacking in the kernel AFAICS...

So is there a reason for which irq dispose mapping is not a requirement 
for drivers when finished with the irq? because of shared interrupts?

>> So for pci msi I can see that we free the irq_desc in
>> pci_disable_msi() -> free_msi_irqs() -> msi_domain_free_irqs() ...
>>
>> So what I am missing here?
> 
> I'm not sure the paths are strictly equivalent. On the PCI side, we
> can have something that completely driver agnostic, as it is all
> architectural. In your case, only the endpoint driver knows about what
> happens, and needs to free things accordingly.
> 
> Finally, there is the issue in your driver that everything is
> requested using devm_request_irq, which cannot play nicely with an
> explicit irq_desc teardown. You'll probably need to provide the
> equivalent devm helpers for your driver to safely be taken down.
> 

Yeah, so since we use the devm irq request method, we also need a devm 
dispose release method as we can't dispose the irq mapping in the 
remove() method, prior to the irq_free() in the later devm release method.

But it looks like there is more to it than that, which I'm worried is 
far from non-trivial. For example, just calling irq_dispose_mapping() 
for removal and then plaform_get_irq()->acpi_get_irq() second time fails 
as it looks like more tidy-up is needed for removal...

Cheers,
John
