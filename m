From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 6 Dec 2017 10:43:47 +0800
Message-ID: <5A275963.4010000@huawei.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
 <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
 <1511977145.2671.13.camel@wdc.com> <5A1F5C77.5050405@huawei.com>
 <1512058117.2774.1.camel@wdc.com>
 <1512086178.3020.35.camel@linux.vnet.ibm.com> <5A211596.2010707@huawei.com>
 <1512142556.3053.4.camel@linux.vnet.ibm.com> <5A2692F6.9000306@huawei.com>
 <1512488235.3019.5.camel@linux.vnet.ibm.com> <5A273CAF.2070406@huawei.com>
 <1512526028.29950.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11515 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754315AbdLFCq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 21:46:57 -0500
In-Reply-To: <1512526028.29950.4.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "miaoxie@huawei.com" <miaoxie@huawei.com>


> execute_in_process_context() is supposed to produce us a context
> whenever the local context isn't available, and that's supposed to
> include when interrupts are disabled as in spin_lock_irqsave().
>
> So let me ask this another way: have you seen this deadlock (which
> would mean we have a bug in execute_process_context())?
>
> James
>
>

I havn't seen this dead lock but in_interrupt() do not check whether
the interrupts are disabled. Please refer to the definition of
in_interrupt().

#define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK\
				 | NMI_MASK))
#define in_interrupt()		(irq_count())


Jason

> .
>
