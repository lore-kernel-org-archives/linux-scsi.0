Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C26CC388F9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 17:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 424FA21D91
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 17:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgKBRgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:36:01 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:3018 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727395AbgKBRgB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Nov 2020 12:36:01 -0500
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 6EE6C5105EEFC14C7BD3;
        Mon,  2 Nov 2020 17:35:59 +0000 (GMT)
Received: from [10.210.168.82] (10.210.168.82) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 2 Nov 2020 17:35:58 +0000
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
To:     Thomas Gleixner <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <rafael@kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <maz@kernel.org>
References: <1603888387-52499-1-git-send-email-john.garry@huawei.com>
 <1603888387-52499-2-git-send-email-john.garry@huawei.com>
 <87eelifbx6.fsf@nanos.tec.linutronix.de>
Message-ID: <ce13a36e-967c-c7ec-fd34-d53262313a5d@huawei.com>
Date:   Mon, 2 Nov 2020 17:32:32 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <87eelifbx6.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.82]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/10/2020 18:22, Thomas Gleixner wrote:
> On Wed, Oct 28 2020 at 20:33, John Garry wrote:

Hi Thomas,

>>   
>> +int irq_update_affinity_desc(unsigned int irq,
>> +			     struct irq_affinity_desc *affinity)
>> +{
>> +	unsigned long flags;
>> +	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
>> +
>> +	if (!desc)
>> +		return -EINVAL;
> Just looking at it some more. This needs a check whether the interrupt
> is actually shut down. Otherwise the update will corrupt
> state. Something like this:
> 
>          if (irqd_is_started(&desc->irq_data))
>          	return -EBUSY;
> 
> But all of this can't work on x86 due to the way how vector allocation
> works. Let me think about that.
> 

Is the problem that we reserve per-cpu managed interrupt space when 
allocated irq vectors on x86, and so later changing managed vs 
non-managed setting for irqs messes up this accounting somehow?

Cheers,
John
