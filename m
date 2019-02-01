From: Hannes Reinecke <hare@suse.de>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Fri, 1 Feb 2019 16:56:12 +0100
Message-ID: <745609be-b215-dd2d-c31f-0bd84572f49f@suse.de>
References: <f6f6e031-8b79-439d-c2af-8d3e76f30710@huawei.com>
 <20190129154433.GF15302@localhost.localdomain>
 <757902fc-a9ea-090b-7853-89944a0ce1b5@huawei.com>
 <20190129172059.GC17132@localhost.localdomain>
 <3fe63dab-0791-f476-69c4-9866b70e8520@huawei.com>
 <alpine.DEB.2.21.1901301338170.5537@nanos.tec.linutronix.de>
 <86d5028d-44ab-3696-f7fe-828d7655faa9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86d5028d-44ab-3696-f7fe-828d7655faa9@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1/31/19 6:48 PM, John Garry wrote:
> On 30/01/2019 12:43, Thomas Gleixner wrote:
>> On Wed, 30 Jan 2019, John Garry wrote:
>>> On 29/01/2019 17:20, Keith Busch wrote:
>>>> On Tue, Jan 29, 2019 at 05:12:40PM +0000, John Garry wrote:
>>>>> On 29/01/2019 15:44, Keith Busch wrote:
>>>>>>
>>>>>> Hm, we used to freeze the queues with CPUHP_BLK_MQ_PREPARE callback,
>>>>>> which would reap all outstanding commands before the CPU and IRQ are
>>>>>> taken offline. That was removed with commit 4b855ad37194f ("blk-mq:
>>>>>> Create hctx for each present CPU"). It sounds like we should bring
>>>>>> something like that back, but make more fine grain to the per-cpu
>>>>>> context.
>>>>>>
>>>>>
>>>>> Seems reasonable. But we would need it to deal with drivers where they
>>>>> only
>>>>> expose a single queue to BLK MQ, but use many queues internally. I 
>>>>> think
>>>>> megaraid sas does this, for example.
>>>>>
>>>>> I would also be slightly concerned with commands being issued from the
>>>>> driver unknown to blk mq, like SCSI TMF.
>>>>
>>>> I don't think either of those descriptions sound like good candidates
>>>> for using managed IRQ affinities.
>>>
>>> I wouldn't say that this behaviour is obvious to the developer. I 
>>> can't see
>>> anything in Documentation/PCI/MSI-HOWTO.txt
>>>
>>> It also seems that this policy to rely on upper layer to flush+freeze 
>>> queues
>>> would cause issues if managed IRQs are used by drivers in other 
>>> subsystems.
>>> Networks controllers may have multiple queues and unsoliciated 
>>> interrupts.
>>
>> It's doesn't matter which part is managing flush/freeze of queues as long
>> as something (either common subsystem code, upper layers or the driver
>> itself) does it.
>>
>> So for the megaraid SAS example the BLK MQ layer obviously can't do
>> anything because it only sees a single request queue. But the driver 
>> could,
>> if the the hardware supports it. tell the device to stop queueing
>> completions on the completion queue which is associated with a particular
>> CPU (or set of CPUs) during offline and then wait for the on flight stuff
>> to be finished. If the hardware does not allow that, then managed
>> interrupts can't work for it.
>>
> 
> A rough audit of current SCSI drivers tells that these set 
> PCI_IRQ_AFFINITY in some path but don't set Scsi_host.nr_hw_queues at all:
> aacraid, be2iscsi, csiostor, megaraid, mpt3sas
> 
Megaraid and mpt3sas don't have that functionality (or, at least, not 
that I'm aware).
And in general I'm not sure if the above approach is feasible.

Thing is, if we have _managed_ CPU hotplug (ie if the hardware provides 
some means of quiescing the CPU before hotplug) then the whole thing is 
trivial; disable SQ and wait for all outstanding commands to complete.
Then trivially all requests are completed and the issue is resolved.
Even with todays infrastructure.

And I'm not sure if we can handle surprise CPU hotplug at all, given all 
the possible race conditions.
But then I might be wrong.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
