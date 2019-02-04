From: Hannes Reinecke <hare@suse.de>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Mon, 4 Feb 2019 08:12:30 +0100
Message-ID: <d93ff049-e96d-36ce-7e58-ec97cbb27ed0@suse.de>
References: <f6f6e031-8b79-439d-c2af-8d3e76f30710@huawei.com>
 <20190129154433.GF15302@localhost.localdomain>
 <757902fc-a9ea-090b-7853-89944a0ce1b5@huawei.com>
 <20190129172059.GC17132@localhost.localdomain>
 <3fe63dab-0791-f476-69c4-9866b70e8520@huawei.com>
 <alpine.DEB.2.21.1901301338170.5537@nanos.tec.linutronix.de>
 <86d5028d-44ab-3696-f7fe-828d7655faa9@huawei.com>
 <745609be-b215-dd2d-c31f-0bd84572f49f@suse.de>
 <alpine.DEB.2.21.1902012255550.8200@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1902012255550.8200@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Garry <john.garry@huawei.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2/1/19 10:57 PM, Thomas Gleixner wrote:
> On Fri, 1 Feb 2019, Hannes Reinecke wrote:
>> Thing is, if we have _managed_ CPU hotplug (ie if the hardware provides some
>> means of quiescing the CPU before hotplug) then the whole thing is trivial;
>> disable SQ and wait for all outstanding commands to complete.
>> Then trivially all requests are completed and the issue is resolved.
>> Even with todays infrastructure.
>>
>> And I'm not sure if we can handle surprise CPU hotplug at all, given all the
>> possible race conditions.
>> But then I might be wrong.
> 
> The kernel would completely fall apart when a CPU would vanish by surprise,
> i.e. uncontrolled by the kernel. Then the SCSI driver exploding would be
> the least of our problems.
> 
Hehe. As I thought.

So, as the user then has to wait for the system to declars 'ready for 
CPU remove', why can't we just disable the SQ and wait for all I/O to 
complete?
We can make it more fine-grained by just waiting on all outstanding I/O 
on that SQ to complete, but waiting for all I/O should be good as an 
initial try.
With that we wouldn't need to fiddle with driver internals, and could 
make it pretty generic.
And we could always add more detailed logic if the driver has the means 
for doing so.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
