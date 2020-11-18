Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8AFC5519F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 11:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6CD720B80
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 11:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgKRLep (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 06:34:45 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2127 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgKRLeo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 06:34:44 -0500
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CbgfX2Y30z67FV0;
        Wed, 18 Nov 2020 19:33:08 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 18 Nov 2020 12:34:42 +0100
Received: from [10.200.66.130] (10.200.66.130) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 18 Nov 2020 11:34:41 +0000
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
To:     Thomas Gleixner <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <rafael@kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <maz@kernel.org>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com>
Date:   Wed, 18 Nov 2020 11:34:27 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <87ft57r7v3.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.200.66.130]
X-ClientProxiedBy: lhreml711-chm.china.huawei.com (10.201.108.62) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thomas,

> 
> Sorry for the delay. 

No worries, Thanks for the effort.

> Supporting this truly on x86 needs some more
> thought and surgery, but for ARM it should not matter. 

ok, as long as you are content not to support x86 atm.

> I made a few
> tweaks to your original code. See below.

I think maybe a few more tweaks, below. Apart from that, it looks to 
work ok.

> 
> Thanks,
> 
>          tglx
> ---
> From: John Garry <john.garry@huawei.com>
> Subject: genirq/affinity: Add irq_update_affinity_desc()
> Date: Wed, 28 Oct 2020 20:33:05 +0800
> 
> From: John Garry <john.garry@huawei.com>
> 
> Add a function to allow the affinity of an interrupt be switched to
> managed, such that interrupts allocated for platform devices may be
> managed.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   include/linux/interrupt.h |    8 ++++++
>   kernel/irq/manage.c       |   56 ++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 64 insertions(+)
> 

...

> +/**
> + * irq_update_affinity_desc - Update affinity management for an interrupt
> + * @irq:	The interrupt number to update
> + * @affinity:	Pointer to the affinity descriptor
> + *
> + * This interface can be used to configure the affinity management of
> + * interrupts which have been allocated already.
> + */
> +int irq_update_affinity_desc(unsigned int irq,
> +			     struct irq_affinity_desc *affinity)

Just a note on the return value, in the only current callsite - 
platform_get_irqs_affinity() - we don't check the return value and 
propagate the error. This is because we don't want to fail the interrupt 
init just because of problems updating the affinity mask. So I could 
print a message to inform the user of error (at the callsite).

> +{
> +	struct irq_desc *desc;
> +	unsigned long flags;
> +	bool activated;
> +
> +	/*
> +	 * Supporting this with the reservation scheme used by x86 needs
> +	 * some more thought. Fail it for now.
> +	 */
> +	if (IS_ENABLED(CONFIG_GENERIC_IRQ_RESERVATION_MODE))
> +		return -EOPNOTSUPP;
> +
> +	desc = irq_get_desc_buslock(irq, &flags, 0);
> +	if (!desc)
> +		return -EINVAL;
> +
> +	/* Requires the interrupt to be shut down */
> +	if (irqd_is_started(&desc->irq_data))

We're missing the unlock here, right?

> +		return -EBUSY;
> +
> +	/* Interrupts which are already managed cannot be modified */
> +	if (irqd_is_managed(&desc->irq_data))

And here, and I figure that this should be irqd_affinity_is_managed()

> +		return -EBUSY;
> +
> +	/*
> +	 * Deactivate the interrupt. That's required to undo
> +	 * anything an earlier activation has established.
> +	 */
> +	activated = irqd_is_activated(&desc->irq_data);
> +	if (activated)
> +		irq_domain_deactivate_irq(&desc->irq_data);
> +
> +	if (affinity->is_managed) {
> +		irqd_set(&desc->irq_data, IRQD_AFFINITY_MANAGED);
> +		irqd_set(&desc->irq_data, IRQD_MANAGED_SHUTDOWN);
> +	}
> +
> +	cpumask_copy(desc->irq_common_data.affinity, &affinity->mask);
> +
> +	/* Restore the activation state */
> +	if (activated)
> +		irq_domain_deactivate_irq(&desc->irq_data);
> +	irq_put_desc_busunlock(desc, flags);
> +	return 0;
> +}
> +
>   int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
>   {
>   	struct irq_desc *desc = irq_to_desc(irq);
> .
> 

Thanks,
John

