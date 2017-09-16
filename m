From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: system hung up when offlining CPUs
Date: Sat, 16 Sep 2017 17:02:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709161630580.2105@nanos>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com> <20170809124213.0d9518bb@why.wild-wind.fr.eu.org> <cd524af7-1f20-1956-1e44-92a451053387@gmail.com> <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com> <20170821131809.GA17564@lst.de>
 <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com> <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com> <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com> <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de> <8cb26204cb5402824496bbb6b636e0af@mail.gmail.com>
 <alpine.DEB.2.20.1709131529400.1874@nanos> <3ce6837a-9aba-0ff4-64b9-7ebca5afca13@gmail.com> <alpine.DEB.2.20.1709161212160.2105@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1709161212160.2105@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 16 Sep 2017, Thomas Gleixner wrote:
> On Thu, 14 Sep 2017, YASUAKI ISHIMATSU wrote:
> > Here are one irq's info of megasas:
> > 
> > - Before offline CPU
> > /proc/irq/70/smp_affinity_list
> > 24-29
> > 
> > /proc/irq/70/effective_affinity
> > 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,3f000000
> > 
> > /sys/kernel/debug/irq/irqs/70
> > handler:  handle_edge_irq
> > status:   0x00004000
> > istate:   0x00000000
> > ddepth:   0
> > wdepth:   0
> > dstate:   0x00609200
> >             IRQD_ACTIVATED
> >             IRQD_IRQ_STARTED
> >             IRQD_MOVE_PCNTXT
> >             IRQD_AFFINITY_SET
> >             IRQD_AFFINITY_MANAGED
> 
> So this uses managed affinity, which means that once the last CPU in the
> affinity mask goes offline, the interrupt is shut down by the irq core
> code, which is the case:
> 
> > dstate:   0x00a39000
> >             IRQD_IRQ_DISABLED
> >             IRQD_IRQ_MASKED
> >             IRQD_MOVE_PCNTXT
> >             IRQD_AFFINITY_SET
> >             IRQD_AFFINITY_MANAGED
> >             IRQD_MANAGED_SHUTDOWN  <---------------
> 
> So the irq core code works as expected, but something in the
> driver/scsi/block stack seems to fiddle with that shut down queue.
> 
> I only can tell about the inner workings of the irq code, but I have no
> clue about the rest.

Though there is something wrong here:

> affinity: 24-29
> effectiv: 24-29

and after offlining:

> affinity: 29
> effectiv: 29

But that should be:

affinity: 24-29
effectiv: 29

because the irq core code preserves 'affinity'. It merily updates
'effective', which is where your interrupts are routed to.

Is the driver issuing any set_affinity() calls? If so, that's wrong.

Which driver are we talking about?

Thanks,

	tglx
