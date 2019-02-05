From: John Garry <john.garry@huawei.com>
Subject: Re: Question on handling managed IRQs when hotplugging CPUs
Date: Tue, 5 Feb 2019 15:27:40 +0000
Message-ID: <5c9b33c7-ae48-6ae8-b9d9-12ab7c486001@huawei.com>
References: <20190129154433.GF15302@localhost.localdomain>
 <757902fc-a9ea-090b-7853-89944a0ce1b5@huawei.com>
 <20190129172059.GC17132@localhost.localdomain>
 <3fe63dab-0791-f476-69c4-9866b70e8520@huawei.com>
 <alpine.DEB.2.21.1901301338170.5537@nanos.tec.linutronix.de>
 <86d5028d-44ab-3696-f7fe-828d7655faa9@huawei.com>
 <745609be-b215-dd2d-c31f-0bd84572f49f@suse.de>
 <alpine.DEB.2.21.1902012255550.8200@nanos.tec.linutronix.de>
 <d93ff049-e96d-36ce-7e58-ec97cbb27ed0@suse.de>
 <42d149c5-0380-c357-8811-81015159ac04@huawei.com>
 <20190205145244.GB28023@localhost.localdomain>
 <d4a04c13-b7db-84df-b1d3-90022905c084@huawei.com>
 <43b43df0-8c8a-fbf0-69d8-9165a73bffea@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <43b43df0-8c8a-fbf0-69d8-9165a73bffea@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Keith Busch <keith.busch@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Marc Zyngier <marc.zyngier@arm.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Linuxarm <linuxarm@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/02/2019 15:15, Hannes Reinecke wrote:
> On 2/5/19 4:09 PM, John Garry wrote:
>> On 05/02/2019 14:52, Keith Busch wrote:
>>> On Tue, Feb 05, 2019 at 05:24:11AM -0800, John Garry wrote:
>>>> On 04/02/2019 07:12, Hannes Reinecke wrote:
>>>>
>>>> Hi Hannes,
>>>>
>>>>>
>>>>> So, as the user then has to wait for the system to declars 'ready for
>>>>> CPU remove', why can't we just disable the SQ and wait for all I/O to
>>>>> complete?
>>>>> We can make it more fine-grained by just waiting on all outstanding
>>>>> I/O
>>>>> on that SQ to complete, but waiting for all I/O should be good as an
>>>>> initial try.
>>>>> With that we wouldn't need to fiddle with driver internals, and could
>>>>> make it pretty generic.
>>>>
>>>> I don't fully understand this idea - specifically, at which layer would
>>>> we be waiting for all the IO to complete?
>>>
>>> Whichever layer dispatched the IO to a CPU specific context should
>>> be the one to wait for its completion. That should be blk-mq for most
>>> block drivers.
>>
>> For SCSI devices, unfortunately not all IO sent to the HW originates
>> from blk-mq or any other single entity.
>>
> No, not as such.
> But each IO sent to the HW requires a unique identifcation (ie a valid
> tag). And as the tagspace is managed by block-mq (minus management
> commands, but I'm working on that currently) we can easily figure out if
> the device is busy by checking for an empty tag map.

That sounds like a reasonable starting solution.

Thanks,
John

>
> Should be doable for most modern HBAs.
>
> Cheers,
>
> Hannes
