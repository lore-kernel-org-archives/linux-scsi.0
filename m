From: Hannes Reinecke <hare@suse.de>
Subject: Re: system hung up when offlining CPUs
Date: Wed, 1 Nov 2017 12:01:10 +0100
Message-ID: <705231c2-4680-b226-3854-e0df61439d68@suse.de>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com>
 <cd524af7-1f20-1956-1e44-92a451053387@gmail.com>
 <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com>
 <20170821131809.GA17564@lst.de>
 <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com>
 <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com>
 <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com>
 <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de>
 <8cb26204cb5402824496bbb6b636e0af@mail.gmail.com>
 <alpine.DEB.2.20.1709131529400.1874@nanos>
 <3ce6837a-9aba-0ff4-64b9-7ebca5afca13@gmail.com>
 <alpine.DEB.2.20.1709161212160.2105@nanos>
 <alpine.DEB.2.20.1709161630580.2105@nanos>
 <78ce7246-c567-3f5f-b168-9bcfc659d4bd@gmail.com>
 <alpine.DEB.2.20.1710032328280.2278@nanos>
 <alpine.DEB.2.20.1710042208400.2406@nanos>
 <3d93387d-30eb-0434-2216-0e6435c633f8@gmail.com>
 <857c813c-29cd-6e9f-5cde-52421d4d8429@gmail.com>
 <alpine.DEB.2.20.1710162106400.2037@nanos>
 <817f0d359fca6830ece5b1fcf207ce65@mail.gmail.com>
 <alpine.DEB.2.20.1711010105260.1942@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1711010105260.1942@nanos>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 11/01/2017 01:47 AM, Thomas Gleixner wrote:
> On Mon, 30 Oct 2017, Shivasharan Srikanteshwara wrote:
> 
>> In managed-interrupts case, interrupts which were affine to the offlined
>> CPU is not getting migrated to another available CPU. But the
>> documentation at below link says that "all interrupts" are migrated to a
>> new CPU. So not all interrupts are getting migrated to a new CPU then.
> 
> Correct.
> 
>> https://www.kernel.org/doc/html/v4.11/core-api/cpu_hotplug.html#the-offlin
>> e-case
>> "- All interrupts targeted to this CPU are migrated to a new CPU"
> 
> Well, documentation is not always up to date :)
>  
>> Once the last CPU in the affinity mask is offlined and a particular IRQ
>> is shutdown, is there a way currently for the device driver to get
>> callback to complete all outstanding requests on that queue?
> 
> No and I have no idea how the other drivers deal with that.
> 
> The way you can do that is to have your own hotplug callback which is
> invoked when the cpu goes down, but way before the interrupt is shut down,
> which is one of the last steps. Ideally this would be a callback in the
> generic block code which then calls out to all instances like its done for
> the cpu dead state.
> 
In principle, yes, that would be (and, in fact, might already) moved to
the block layer for blk-mq, as this has full control over the individual
queues and hence can ensure that the queues with dead/removed CPUs are
properly handled.

Here, OTOH, we are dealing with the legacy sq implementation (or, to be
precised, a blk-mq implementation utilizing only a single queue), so
that any of this handling need to be implemented in the driver.

So what would need to be done here is to implement a hotplug callback in
the driver, which would disable the CPU from the list/bitmap of valid
cpus. Then the driver could validate the CPU number with this bitmap
upon I/O submission (instead of just using raw_smp_cpu_number()), and
could set the queue ID to '0' if an invalid CPU was found.
With that the driver should be able to ensure that no new I/O will be
submitted which will hit the dead CPU, so with a bit of luck this might
already solve the problem.

Alternatively I could resurrect my patchset converting the driver to
blk-mq, which got vetoed the last time ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
