From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/2] genirq/affinity: try to make sure online CPU is
 assgined to irq vector
Date: Thu, 1 Feb 2018 23:04:48 +0800
Message-ID: <20180201150441.GA32269@ming.t460p>
References: <20180115160345.2611-1-ming.lei@redhat.com>
 <20180115174036.GA20191@infradead.org>
 <20180116013043.GA3213@ming.t460p>
 <alpine.DEB.2.20.1801161223500.1823@nanos>
 <1516109317.9574.1.camel@redhat.com>
 <a6086631efd54749a298add3d6b9a134@microsemi.com>
 <20180201103651.GA29263@ming.t460p>
 <35e74f9ae47b4b5db8ee4bf3a8989e82@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbeBAPFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Feb 2018 10:05:39 -0500
Content-Disposition: inline
In-Reply-To: <35e74f9ae47b4b5db8ee4bf3a8989e82@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: Laurence Oberman <loberman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

On Thu, Feb 01, 2018 at 02:53:35PM +0000, Don Brace wrote:
> > -----Original Message-----
> > From: Ming Lei [mailto:ming.lei@redhat.com]
> > Sent: Thursday, February 01, 2018 4:37 AM
> > To: Don Brace <don.brace@microsemi.com>
> > Cc: Laurence Oberman <loberman@redhat.com>; Thomas Gleixner
> > <tglx@linutronix.de>; Christoph Hellwig <hch@infradead.org>; Jens Axboe
> > <axboe@fb.com>; linux-block@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Mike Snitzer <snitzer@redhat.com>
> > Subject: Re: [PATCH 0/2] genirq/affinity: try to make sure online CPU is assgined
> > to irq vector
> > 
> > EXTERNAL EMAIL
> > 
> > 
> > On Tue, Jan 16, 2018 at 03:22:18PM +0000, Don Brace wrote:
> > > > -----Original Message-----
> > > > From: Laurence Oberman [mailto:loberman@redhat.com]
> > > > Sent: Tuesday, January 16, 2018 7:29 AM
> > > > To: Thomas Gleixner <tglx@linutronix.de>; Ming Lei <ming.lei@redhat.com>
> > > > Cc: Christoph Hellwig <hch@infradead.org>; Jens Axboe <axboe@fb.com>;
> > > > linux-block@vger.kernel.org; linux-kernel@vger.kernel.org; Mike Snitzer
> > > > <snitzer@redhat.com>; Don Brace <don.brace@microsemi.com>
> > > > Subject: Re: [PATCH 0/2] genirq/affinity: try to make sure online CPU is
> > assgined
> > > > to irq vector
> > > >
> > > > > > It is because of irq_create_affinity_masks().
> > > > >
> > > > > That still does not answer the question. If the interrupt for a queue
> > > > > is
> > > > > assigned to an offline CPU, then the queue should not be used and
> > > > > never
> > > > > raise an interrupt. That's how managed interrupts have been designed.
> > > > >
> > > > > Thanks,
> > > > >
> > > > >       tglx
> > > > >
> > > > >
> > > > >
> > > > >
> > > >
> > > > I captured a full boot log for this issue for Microsemi, I will send it
> > > > to Don Brace.
> > > > I enabled all the HPSA debug and here is snippet
> > > >
> > > >
> > > > ..
> > > > ..
> > > > ..
> > > >   246.751135] INFO: task systemd-udevd:413 blocked for more than 120
> > > > seconds.
> > > > [  246.788008]       Tainted: G          I      4.15.0-rc4.noming+ #1
> > > > [  246.822380] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > > disables this message.
> > > > [  246.865594] systemd-udevd   D    0   413    411 0x80000004
> > > > [  246.895519] Call Trace:
> > > > [  246.909713]  ? __schedule+0x340/0xc20
> > > > [  246.930236]  schedule+0x32/0x80
> > > > [  246.947905]  schedule_timeout+0x23d/0x450
> > > > [  246.970047]  ? find_held_lock+0x2d/0x90
> > > > [  246.991774]  ? wait_for_completion_io+0x108/0x170
> > > > [  247.018172]  io_schedule_timeout+0x19/0x40
> > > > [  247.041208]  wait_for_completion_io+0x110/0x170
> > > > [  247.067326]  ? wake_up_q+0x70/0x70
> > > > [  247.086801]  hpsa_scsi_do_simple_cmd+0xc6/0x100 [hpsa]
> > > > [  247.114315]  hpsa_scsi_do_simple_cmd_with_retry+0xb7/0x1c0 [hpsa]
> > > > [  247.146629]  hpsa_scsi_do_inquiry+0x73/0xd0 [hpsa]
> > > > [  247.174118]  hpsa_init_one+0x12cb/0x1a59 [hpsa]
> > >
> > > This trace comes from internally generated discovery commands. No SCSI
> > devices have
> > > been presented to the SML yet.
> > >
> > > At this point we should be running on only one CPU. These commands are
> > meant to use
> > > reply queue 0 which are tied to CPU 0. It's interesting that the patch helps.
> > >
> > > However, I was wondering if you could inspect the iLo IML logs and send the
> > > AHS logs for inspection.
> > 
> > Hello Don,
> > 
> > Now the patch has been merged to linus tree as:
> > 
> > 84676c1f21e8ff54b ("genirq/affinity: assign vectors to all possible CPUs")
> > 
> > and it breaks Laurence's machine completely, :-(
> > 
> > I just take a look at HPSA's code, and found that reply queue is chosen
> > in the following way in most of code path:
> > 
> >         if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
> >                 cp->ReplyQueue = smp_processor_id() % h->nreply_queues;
> > 
> > h->nreply_queues is the msix vector number which is returned from
> > pci_alloc_irq_vectors(), and now some of vectors may be mapped to all
> > offline CPUs, for example, one processor isn't plugged to socket.
> > 
> > If I understand correctly, 'cp->ReplyQueue' is aligned to one irq
> > vector, and the command is expected by handled via that irq vector,
> > is it right?
> > 
> > If yes, now I guess this way can't work any more if number of online
> > CPUs is >= h->nreply_queues, and you may need to check the cpu affinity
> > of one vector before choosing the reply queue, and block/blk-mq-pci.c
> > may be helpful for you.
> > 
> > Thanks,
> > Ming
> 
> Thanks Ming,
> I start working up a patch.

Also the reply queue may be mapped to blk-mq's hw queue directly, then the
conversion may be done by blk-mq's MQ framework, but legacy path still need
the fix.

thanks
Ming
