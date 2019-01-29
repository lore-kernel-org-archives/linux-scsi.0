From: Hannes Reinecke <hare@suse.com>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Tue, 29 Jan 2019 12:54:44 +0100
Message-ID: <5bff8227-16fd-6bca-c16e-3992ef6bec5a@suse.com>
References: <f6f6e031-8b79-439d-c2af-8d3e76f30710@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f6f6e031-8b79-439d-c2af-8d3e76f30710@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, tglx@linutronix.de, Christoph Hellwig <hch@lst.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1/29/19 12:25 PM, John Garry wrote:
> Hi,
> 
> I have a question on $subject which I hope you can shed some light on.
> 
> According to commit c5cb83bb337c25 ("genirq/cpuhotplug: Handle managed 
> IRQs on CPU hotplug"), if we offline the last CPU in a managed IRQ 
> affinity mask, the IRQ is shutdown.
> 
> The reasoning is that this IRQ is thought to be associated with a 
> specific queue on a MQ device, and the CPUs in the IRQ affinity mask are 
> the same CPUs associated with the queue. So, if no CPU is using the 
> queue, then no need for the IRQ.
> 
> However how does this handle scenario of last CPU in IRQ affinity mask 
> being offlined while IO associated with queue is still in flight?
> 
> Or if we make the decision to use queue associated with the current CPU, 
> and then that CPU (being the last CPU online in the queue's IRQ 
> afffinity mask) goes offline and we finish the delivery with another CPU?
> 
> In these cases, when the IO completes, it would not be serviced and 
> timeout.
> 
> I have actually tried this on my arm64 system and I see IO timeouts.
> 
That actually is a very good question, and I have been wondering about 
this for quite some time.

I find it a bit hard to envision a scenario where the IRQ affinity is 
automatically (and, more importantly, atomically!) re-routed to one of 
the other CPUs.
And even it it were, chances are that there are checks in the driver 
_preventing_ them from handling those requests, seeing that they should 
have been handled by another CPU ...

I guess the safest bet is to implement a 'cleanup' worker queue which is 
responsible of looking through all the outstanding commands (on all 
hardware queues), and then complete those for which no corresponding CPU 
/ irqhandler can be found.

But I defer to the higher authorities here; maybe I'm totally wrong and 
it's already been taken care of.

But if there is no generic mechanism this really is a fit topic for 
LSF/MM, as most other drivers would be affected, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
