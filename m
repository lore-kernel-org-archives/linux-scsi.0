From: John Garry <john.garry@huawei.com>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Tue, 29 Jan 2019 17:23:52 +0000
Message-ID: <ab22a6bb-a51f-b938-a84c-9cefdb2e92b5@huawei.com>
References: <f6f6e031-8b79-439d-c2af-8d3e76f30710@huawei.com>
 <5bff8227-16fd-6bca-c16e-3992ef6bec5a@suse.com>
 <alpine.DEB.2.21.1901291257590.1513@nanos.tec.linutronix.de>
 <bdd457db-6898-a085-bfaf-99d29d81467d@huawei.com>
 <alpine.DEB.2.21.1901291717370.1513@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1901291717370.1513@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 29/01/2019 16:27, Thomas Gleixner wrote:
> On Tue, 29 Jan 2019, John Garry wrote:
>> On 29/01/2019 12:01, Thomas Gleixner wrote:
>>> If the last CPU which is associated to a queue (and the corresponding
>>> interrupt) goes offline, then the subsytem/driver code has to make sure
>>> that:
>>>
>>>    1) No more requests can be queued on that queue
>>>
>>>    2) All outstanding of that queue have been completed or redirected
>>>       (don't know if that's possible at all) to some other queue.
>>
>> This may not be possible. For the HW I deal with, we have symmetrical delivery
>> and completion queues, and a command delivered on DQx will always complete on
>> CQx. Each completion queue has a dedicated IRQ.
>
> So you can stop queueing on DQx and wait for all outstanding ones to come
> in on CQx, right?

Right, and this sounds like what Keith Busch mentioned in his reply.

>
>>> That has to be done in that order obviously. Whether any of the
>>> subsystems/drivers actually implements this, I can't tell.
>>
>> Going back to c5cb83bb337c25, it seems to me that the change was made with the
>> idea that we can maintain the affinity for the IRQ as we're shutting it down
>> as no interrupts should occur.
>>
>> However I don't see why we can't instead keep the IRQ up and set the affinity
>> to all online CPUs in offline path, and restore the original affinity in
>> online path. The reason we set the queue affinity to specific CPUs is for
>> performance, but I would not say that this matters for handling residual IRQs.
>
> Oh yes it does. The problem is especially on x86, that if you have a large
> number of queues and you take a large number of CPUs offline, then you run
> into vector space exhaustion on the remaining online CPUs.
>
> In the worst case a single CPU on x86 has only 186 vectors available for
> device interrupts. So just take a quad socket machine with 144 CPUs and two
> multiqueue devices with a queue per cpu. ---> FAIL
>
> It probably fails already with one device because there are lots of other
> devices which have regular interrupt which cannot be shut down.

OK, understood.

Thanks,
John

>
> Thanks,
>
> 	tglx
>
>
> .
>
