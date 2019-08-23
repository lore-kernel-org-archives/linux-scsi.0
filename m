Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA37C3A5A1
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 03:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD1C62341A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 03:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391443AbfHWDVp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 23:21:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391211AbfHWDVp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 23:21:45 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6174D18C4264;
        Fri, 23 Aug 2019 03:21:44 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E51360605;
        Fri, 23 Aug 2019 03:21:35 +0000 (UTC)
Date:   Fri, 23 Aug 2019 11:21:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     longli@linuxonhyperv.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] nvme: complete request in work queue on CPU with
 flooded interrupts
Message-ID: <20190823032129.GA18680@ming.t460p>
References: <1566281669-48212-1-git-send-email-longli@linuxonhyperv.com>
 <1566281669-48212-4-git-send-email-longli@linuxonhyperv.com>
 <2a30a07f-982c-c291-e263-0cf72ec61235@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a30a07f-982c-c291-e263-0cf72ec61235@grimberg.me>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 23 Aug 2019 03:21:44 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 20, 2019 at 10:33:38AM -0700, Sagi Grimberg wrote:
> 
> > From: Long Li <longli@microsoft.com>
> > 
> > When a NVMe hardware queue is mapped to several CPU queues, it is possible
> > that the CPU this hardware queue is bound to is flooded by returning I/O for
> > other CPUs.
> > 
> > For example, consider the following scenario:
> > 1. CPU 0, 1, 2 and 3 share the same hardware queue
> > 2. the hardware queue interrupts CPU 0 for I/O response
> > 3. processes from CPU 1, 2 and 3 keep sending I/Os
> > 
> > CPU 0 may be flooded with interrupts from NVMe device that are I/O responses
> > for CPU 1, 2 and 3. Under heavy I/O load, it is possible that CPU 0 spends
> > all the time serving NVMe and other system interrupts, but doesn't have a
> > chance to run in process context.
> > 
> > To fix this, CPU 0 can schedule a work to complete the I/O request when it
> > detects the scheduler is not making progress. This serves multiple purposes:
> > 
> > 1. This CPU has to be scheduled to complete the request. The other CPUs can't
> > issue more I/Os until some previous I/Os are completed. This helps this CPU
> > get out of NVMe interrupts.
> > 
> > 2. This acts a throttling mechanisum for NVMe devices, in that it can not
> > starve a CPU while servicing I/Os from other CPUs.
> > 
> > 3. This CPU can make progress on RCU and other work items on its queue.
> 
> The problem is indeed real, but this is the wrong approach in my mind.
> 
> We already have irqpoll which takes care proper budgeting polling
> cycles and not hogging the cpu.

The issue isn't unique to NVMe, and can be any fast devices which
interrupts CPU too frequently, meantime the interrupt/softirq handler may
take a bit much time, then CPU is easy to be lockup by the interrupt/sofirq
handler, especially in case that multiple submission CPUs vs. single
completion CPU.

Some SCSI devices has the same problem too.

Could we consider to add one generic mechanism to cover this kind of
problem?

One approach I thought of is to allocate one backup thread for handling
such interrupt, which can be marked as IRQF_BACKUP_THREAD by drivers. 

Inside do_IRQ(), irqtime is accounted, before calling action->handler(),
check if this CPU has taken too long time for handling IRQ(interrupt or
softirq) and see if this CPU could be lock up. If yes, wakeup the backup
thread to handle the interrupt for avoiding lockup this CPU.

The threaded interrupt framework is there, and this way could be easier
to implement. Meantime most time the handler is run in interrupt context
and we may avoid the performance loss when CPU isn't busy enough.

Any comment on this approach?

Thanks,
Ming
