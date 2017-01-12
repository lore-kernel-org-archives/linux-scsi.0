From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 12 Jan 2017 10:41:43 +0200
Message-ID: <ccb6cf4d-4810-47b2-015a-0202d784280a@grimberg.me>
References: <20170111134312.GH6286@linux-x5ow.site>
 <1484150893.2619.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1484150893.2619.1.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "Linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


>> I'd like to attend LSF/MM and would like to discuss polling for block
>> drivers.
>>
>> Currently there is blk-iopoll but it is neither as widely used as NAPI in
>> the networking field and accoring to Sagi's findings in [1] performance
>> with polling is not on par with IRQ usage.
>>
>> On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
>> more block drivers and how to overcome the currently seen performance
>> issues.
>>
>> [1] http://lists.infradead.org/pipermail/linux-nvme/2016-October/006975.ht
>> ml
>
> A typical Ethernet network adapter delays the generation of an interrupt
> after it has received a packet. A typical block device or HBA does not delay
> the generation of an interrupt that reports an I/O completion. I think that
> is why polling is more effective for network adapters than for block
> devices. I'm not sure whether it is possible to achieve benefits similar to
> NAPI for block devices without implementing interrupt coalescing in the
> block device firmware. Note: for block device implementations that use the
> RDMA API, the RDMA API supports interrupt coalescing (see also
> ib_modify_cq()).

Hey Bart,

I don't agree that interrupt coalescing is the reason why irq-poll is
not suitable for nvme or storage devices.

First, when the nvme device fires an interrupt, the driver consumes
the completion(s) from the interrupt (usually there will be some more
completions waiting in the cq by the time the host start processing it).
With irq-poll, we disable further interrupts and schedule soft-irq for
processing, which if at all, improve the completions per interrupt
utilization (because it takes slightly longer before processing the cq).

Moreover, irq-poll is budgeting the completion queue processing which is
important for a couple of reasons.

1. it prevents hard-irq context abuse like we do today. if other cpu
    cores are pounding with more submissions on the same queue, we might
    get into a hard-lockup (which I've seen happening).

2. irq-poll maintains fairness between devices by correctly budgeting
    the processing of different completions queues that share the same
    affinity. This can become crucial when working with multiple nvme
    devices, each has multiple io queues that share the same IRQ
    assignment.

3. It reduces (or at least should reduce) the overall number of
    interrupts in the system because we only enable interrupts again
    when the completion queue is completely processed.

So overall, I think it's very useful for nvme and other modern HBAs,
but unfortunately, other than solving (1), I wasn't able to see
performance improvement but rather a slight regression, but I can't
explain where its coming from...
