From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Tue, 29 Jan 2019 13:01:45 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1901291257590.1513@nanos.tec.linutronix.de>
References: <f6f6e031-8b79-439d-c2af-8d3e76f30710@huawei.com> <5bff8227-16fd-6bca-c16e-3992ef6bec5a@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bff8227-16fd-6bca-c16e-3992ef6bec5a@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>, Christoph Hellwig <hch@lst.de>, Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 29 Jan 2019, Hannes Reinecke wrote:
> That actually is a very good question, and I have been wondering about this
> for quite some time.
> 
> I find it a bit hard to envision a scenario where the IRQ affinity is
> automatically (and, more importantly, atomically!) re-routed to one of the
> other CPUs.
> And even it it were, chances are that there are checks in the driver
> _preventing_ them from handling those requests, seeing that they should have
> been handled by another CPU ...
> 
> I guess the safest bet is to implement a 'cleanup' worker queue which is
> responsible of looking through all the outstanding commands (on all hardware
> queues), and then complete those for which no corresponding CPU / irqhandler
> can be found.
> 
> But I defer to the higher authorities here; maybe I'm totally wrong and it's
> already been taken care of.

TBH, I don't know. I merily was involved in the genirq side of this. But
yes, in order to make this work correctly the basic contract for CPU
hotplug case must be:

If the last CPU which is associated to a queue (and the corresponding
interrupt) goes offline, then the subsytem/driver code has to make sure
that:

   1) No more requests can be queued on that queue

   2) All outstanding of that queue have been completed or redirected
      (don't know if that's possible at all) to some other queue.

That has to be done in that order obviously. Whether any of the
subsystems/drivers actually implements this, I can't tell.

Thanks,

	tglx
