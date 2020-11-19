Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7EDC388F9
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 09:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505C32468D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 09:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgKSJcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 04:32:16 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2130 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgKSJcP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 04:32:15 -0500
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CcDtj28bWz67FXS;
        Thu, 19 Nov 2020 17:30:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 19 Nov 2020 10:32:13 +0100
Received: from [10.200.65.70] (10.200.65.70) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Thu, 19 Nov
 2020 09:32:11 +0000
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
To:     Thomas Gleixner <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <rafael@kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <maz@kernel.org>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de>
 <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com>
 <874klmqu2r.fsf@nanos.tec.linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b86af904-2288-8b53-7e99-e763b73987d0@huawei.com>
Date:   Thu, 19 Nov 2020 09:31:56 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <874klmqu2r.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.200.65.70]
X-ClientProxiedBy: lhreml707-chm.china.huawei.com (10.201.108.56) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thomas,

>>> +int irq_update_affinity_desc(unsigned int irq,
>>> +			     struct irq_affinity_desc *affinity)
>> Just a note on the return value, in the only current callsite -
>> platform_get_irqs_affinity() - we don't check the return value and
>> propagate the error. This is because we don't want to fail the interrupt
>> init just because of problems updating the affinity mask. So I could
>> print a message to inform the user of error (at the callsite).
> Well, not sure about that. During init on a platform which does not have
> the issues with reservation mode there failure cases are:
> 
>   1) Interrupt does not exist. Definitely a full fail
> 
>   2) Interrupt is already started up. Not a good idea on init() and
>      a clear fail.
> 
>   3) Interrupt has already been switched to managed. Double init is not
>      really a good sign either.

I just tested that and case 3) would be a problem. I don't see us 
clearing the managed flag when free'ing the interrupt. So with 
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y, we attempt this affinity update 
twice, and error from the irqd_affinity_is_managed() check.

> 
>>> +	/* Requires the interrupt to be shut down */
>>> +	if (irqd_is_started(&desc->irq_data))
>> We're missing the unlock here, right?
> Duh yes.
> 
>>> +		return -EBUSY;
>>> +
>>> +	/* Interrupts which are already managed cannot be modified */
>>> +	if (irqd_is_managed(&desc->irq_data))
>> And here, and I figure that this should be irqd_affinity_is_managed()
> More duh:)
> 
> I assume you send a fixed variant of this.

Can do.

Thanks,
John
