Return-Path: <SRS0=/6u/=WU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373CEC3A59E
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 12:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1533B2146E
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 12:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfHXM4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Aug 2019 08:56:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727590AbfHXM4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Aug 2019 08:56:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5BB741089042;
        Sat, 24 Aug 2019 12:56:08 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 606615D6D0;
        Sat, 24 Aug 2019 12:55:58 +0000 (UTC)
Date:   Sat, 24 Aug 2019 20:55:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Long Li <longli@microsoft.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/3] nvme: complete request in work queue on CPU with
 flooded interrupts
Message-ID: <20190824125553.GA8474@ming.t460p>
References: <1566281669-48212-1-git-send-email-longli@linuxonhyperv.com>
 <1566281669-48212-4-git-send-email-longli@linuxonhyperv.com>
 <2a30a07f-982c-c291-e263-0cf72ec61235@grimberg.me>
 <20190823032129.GA18680@ming.t460p>
 <CY4PR21MB074173E79C7FC3AC13C69CB3CEA70@CY4PR21MB0741.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR21MB074173E79C7FC3AC13C69CB3CEA70@CY4PR21MB0741.namprd21.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Sat, 24 Aug 2019 12:56:08 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 24, 2019 at 12:27:18AM +0000, Long Li wrote:
> >>>Subject: Re: [PATCH 3/3] nvme: complete request in work queue on CPU
> >>>with flooded interrupts
> >>>
> >>>On Tue, Aug 20, 2019 at 10:33:38AM -0700, Sagi Grimberg wrote:
> >>>>
> >>>> > From: Long Li <longli@microsoft.com>
> >>>> >
> >>>> > When a NVMe hardware queue is mapped to several CPU queues, it is
> >>>> > possible that the CPU this hardware queue is bound to is flooded by
> >>>> > returning I/O for other CPUs.
> >>>> >
> >>>> > For example, consider the following scenario:
> >>>> > 1. CPU 0, 1, 2 and 3 share the same hardware queue 2. the hardware
> >>>> > queue interrupts CPU 0 for I/O response 3. processes from CPU 1, 2
> >>>> > and 3 keep sending I/Os
> >>>> >
> >>>> > CPU 0 may be flooded with interrupts from NVMe device that are I/O
> >>>> > responses for CPU 1, 2 and 3. Under heavy I/O load, it is possible
> >>>> > that CPU 0 spends all the time serving NVMe and other system
> >>>> > interrupts, but doesn't have a chance to run in process context.
> >>>> >
> >>>> > To fix this, CPU 0 can schedule a work to complete the I/O request
> >>>> > when it detects the scheduler is not making progress. This serves
> >>>multiple purposes:
> >>>> >
> >>>> > 1. This CPU has to be scheduled to complete the request. The other
> >>>> > CPUs can't issue more I/Os until some previous I/Os are completed.
> >>>> > This helps this CPU get out of NVMe interrupts.
> >>>> >
> >>>> > 2. This acts a throttling mechanisum for NVMe devices, in that it
> >>>> > can not starve a CPU while servicing I/Os from other CPUs.
> >>>> >
> >>>> > 3. This CPU can make progress on RCU and other work items on its
> >>>queue.
> >>>>
> >>>> The problem is indeed real, but this is the wrong approach in my mind.
> >>>>
> >>>> We already have irqpoll which takes care proper budgeting polling
> >>>> cycles and not hogging the cpu.
> >>>
> >>>The issue isn't unique to NVMe, and can be any fast devices which
> >>>interrupts CPU too frequently, meantime the interrupt/softirq handler may
> >>>take a bit much time, then CPU is easy to be lockup by the interrupt/sofirq
> >>>handler, especially in case that multiple submission CPUs vs. single
> >>>completion CPU.
> >>>
> >>>Some SCSI devices has the same problem too.
> >>>
> >>>Could we consider to add one generic mechanism to cover this kind of
> >>>problem?
> >>>
> >>>One approach I thought of is to allocate one backup thread for handling such
> >>>interrupt, which can be marked as IRQF_BACKUP_THREAD by drivers.
> >>>
> >>>Inside do_IRQ(), irqtime is accounted, before calling action->handler(),
> >>>check if this CPU has taken too long time for handling IRQ(interrupt or
> >>>softirq) and see if this CPU could be lock up. If yes, wakeup the backup
> 
> How do you know if this CPU is spending all the time in do_IRQ()?
> 
> Is it something like:
> If (IRQ_time /elapsed_time > a threshold value)
> 	wake up the backup thread

Yeah, the above could work in theory.

Another approach I thought of is to monitor average irq gap time on each
CPU.

We could use EWMA(Exponential Weighted Moving Average) to do it simply,
such as:

	curr_irq_gap(cpu) = current start time of do_IRQ() on 'cpu' -
			end time of last do_IRQ() on 'cpu'
	avg_irq_gap(cpu) = weight_prev * avg_irq_gap(cpu) + weight_curr * curr_irq_gap(cpu) 

	note:
		weight_prev + weight_curr = 1

When avg_irq_gap(cpu) is close to one small enough threshold, we think irq flood is
detected.

'weight_prev' could be chosen as one big enough value for avoiding short-time flood.


Thanks,
Ming
