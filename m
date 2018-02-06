From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
 force_blk_mq
Date: Tue, 6 Feb 2018 20:31:54 +0800
Message-ID: <20180206123148.GA29378@ming.t460p>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <07c1f41e-de7c-5e3d-1a2d-0cd7af7b46df@suse.de>
 <528c93de0aac9010e274847ab1ae0328@mail.gmail.com>
 <20180205101734.GA32558@ming.t460p>
 <4c8162129f2a09dca2d1e7eefd61e272@mail.gmail.com>
 <20180206080452.GA14651@ming.t460p>
 <b0b6dae90e4525f91459d450c01c4204@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752246AbeBFMcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Feb 2018 07:32:19 -0500
Content-Disposition: inline
In-Reply-To: <b0b6dae90e4525f91459d450c01c4204@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

Hi Kashyap,

On Tue, Feb 06, 2018 at 04:59:51PM +0530, Kashyap Desai wrote:
> > -----Original Message-----
> > From: Ming Lei [mailto:ming.lei@redhat.com]
> > Sent: Tuesday, February 6, 2018 1:35 PM
> > To: Kashyap Desai
> > Cc: Hannes Reinecke; Jens Axboe; linux-block@vger.kernel.org; Christoph
> > Hellwig; Mike Snitzer; linux-scsi@vger.kernel.org; Arun Easi; Omar
> Sandoval;
> > Martin K . Petersen; James Bottomley; Christoph Hellwig; Don Brace;
> Peter
> > Rivera; Paolo Bonzini; Laurence Oberman
> > Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
> > force_blk_mq
> >
> > Hi Kashyap,
> >
> > On Tue, Feb 06, 2018 at 11:33:50AM +0530, Kashyap Desai wrote:
> > > > > We still have more than one reply queue ending up completion one
> CPU.
> > > >
> > > > pci_alloc_irq_vectors(PCI_IRQ_AFFINITY) has to be used, that means
> > > > smp_affinity_enable has to be set as 1, but seems it is the default
> > > setting.
> > > >
> > > > Please see kernel/irq/affinity.c, especially
> > > > irq_calc_affinity_vectors()
> > > which
> > > > figures out an optimal number of vectors, and the computation is
> > > > based
> > > on
> > > > cpumask_weight(cpu_possible_mask) now. If all offline CPUs are
> > > > mapped to some of reply queues, these queues won't be active(no
> > > > request submitted
> > > to
> > > > these queues). The mechanism of PCI_IRQ_AFFINITY basically makes
> > > > sure
> > > that
> > > > more than one irq vector won't be handled by one same CPU, and the
> > > > irq vector spread is done in irq_create_affinity_masks().
> > > >
> > > > > Try to reduce MSI-x vector of megaraid_sas or mpt3sas driver via
> > > > > module parameter to simulate the issue. We need more number of
> > > > > Online CPU than reply-queue.
> > > >
> > > > IMO, you don't need to simulate the issue, pci_alloc_irq_vectors(
> > > > PCI_IRQ_AFFINITY) will handle that for you. You can dump the
> > > > returned
> > > irq
> > > > vector number, num_possible_cpus()/num_online_cpus() and each irq
> > > > vector's affinity assignment.
> > > >
> > > > > We may see completion redirected to original CPU because of
> > > > > "QUEUE_FLAG_SAME_FORCE", but ISR of low level driver can keep one
> > > > > CPU busy in local ISR routine.
> > > >
> > > > Could you dump each irq vector's affinity assignment of your
> > > > megaraid in
> > > your
> > > > test?
> > >
> > > To quickly reproduce, I restricted to single MSI-x vector on
> > > megaraid_sas driver.  System has total 16 online CPUs.
> >
> > I suggest you don't do the restriction of single MSI-x vector, and just
> use the
> > device supported number of msi-x vector.
> 
> Hi Ming,  CPU lock up is seen even though it is not single msi-x vector.
> Actual scenario need some specific topology and server for overnight test.
> Issue can be seen on servers which has more than 16 logical CPUs and
> Thunderbolt series MR controller which supports at max 16 MSIx vectors.
> >
> > >
> > > Output of affinity hints.
> > > kernel version:
> > > Linux rhel7.3 4.15.0-rc1+ #2 SMP Mon Feb 5 12:13:34 EST 2018 x86_64
> > > x86_64
> > > x86_64 GNU/Linux
> > > PCI name is 83:00.0, dump its irq affinity:
> > > irq 105, cpu list 0-3,8-11
> >
> > In this case, which CPU is selected for handling the interrupt is
> decided by
> > interrupt controller, and it is easy to cause CPU overload if interrupt
> controller
> > always selects one same CPU to handle the irq.
> >
> > >
> > > Affinity mask is created properly, but only CPU-0 is overloaded with
> > > interrupt processing.
> > >
> > > # numactl --hardware
> > > available: 2 nodes (0-1)
> > > node 0 cpus: 0 1 2 3 8 9 10 11
> > > node 0 size: 47861 MB
> > > node 0 free: 46516 MB
> > > node 1 cpus: 4 5 6 7 12 13 14 15
> > > node 1 size: 64491 MB
> > > node 1 free: 62805 MB
> > > node distances:
> > > node   0   1
> > >   0:  10  21
> > >   1:  21  10
> > >
> > > Output of  system activities (sar).  (gnice is 100% and it is consumed
> > > in megaraid_sas ISR routine.)
> > >
> > >
> > > 12:44:40 PM     CPU      %usr     %nice      %sys   %iowait    %steal
> > > %irq     %soft    %guest    %gnice     %idle
> > > 12:44:41 PM     all         6.03      0.00        29.98      0.00
> > > 0.00         0.00        0.00        0.00        0.00         63.99
> > > 12:44:41 PM       0         0.00      0.00         0.00        0.00
> > > 0.00         0.00        0.00        0.00       100.00         0
> > >
> > >
> > > In my test, I used rq_affinity is set to 2. (QUEUE_FLAG_SAME_FORCE). I
> > > also used " host_tagset" V2 patch set for megaraid_sas.
> > >
> > > Using RFC requested in -
> > > "https://marc.info/?l=linux-scsi&m=151601833418346&w=2 " lockup is
> > > avoided (you can noticed that gnice is shifted to softirq. Even though
> > > it is 100% consumed, There is always exit for existing completion loop
> > > due to irqpoll_weight  @irq_poll_init().
> > >
> > > Average:        CPU      %usr     %nice      %sys   %iowait    %steal
> > > %irq     %soft    %guest    %gnice     %idle
> > > Average:        all          4.25      0.00        21.61      0.00
> > > 0.00      0.00         6.61           0.00      0.00     67.54
> > > Average:          0           0.00      0.00         0.00      0.00
> > > 0.00      0.00       100.00        0.00      0.00      0.00
> > >
> > >
> > > Hope this clarifies. We need different fix to avoid lockups. Can we
> > > consider using irq poll interface if #CPU is more than Reply
> queue/MSI-x.
> > > ?
> >
> > Please use the device's supported msi-x vectors number, and see if there
> is this
> > issue. If there is, you can use irq poll too, which isn't contradictory
> with the
> > blk-mq approach taken by this patchset.
> 
> Device supported scenario need more time to reproduce, but it is more
> quick method is to just use single MSI-x vector and try to create worst
> case IO completion loop.
> Using irq poll, my test run without any CPU lockup. I tried your latest V2
> series as well and that is also behaving the same.

Again, you can use irq poll, which isn't contradictory with blk-mq.

> 
> BTW - I am seeing drastically performance drop using V2 series of patch on
> megaraid_sas. Those who is testing HPSA, can also verify if that is a
> generic behavior.

OK, I will see if I can find a megaraid_sas to see the performance drop
issue. If I can't, I will try to run performance test on HPSA.

Could you share us your patch for enabling global_tags/MQ on megaraid_sas so
that I can reproduce your test?

> See below perf top data. "bt_iter" is consuming 4 times more CPU.

Could you share us what the IOPS/CPU utilization effect is after
applying the patch V2? And your test script?

In theory, it shouldn't, because the HBA only supports HBA wide tags,
that means the allocation has to share a HBA wide sbitmap no matter
if global tags is used or not.

Anyway, I will take a look at the performance test and data.


Thanks,
Ming
