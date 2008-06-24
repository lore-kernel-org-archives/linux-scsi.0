From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] Separating out libata out of SCSI (finally)
Date: Tue, 24 Jun 2008 11:30:17 +0300
Message-ID: <4860B099.2030305@panasas.com>
References: <485B2CC6.6070201@kernel.org>	 <1213993737.3443.35.camel@localhost.localdomain>	 <485C31FE.8050408@garzik.org>	 <87f94c370806231404t13586777x7f7bee24ebe25ffc@mail.gmail.com> <1214255460.3310.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1214255460.3310.27.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, brking@linux.vnet.ibm.com, Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-06-23 at 17:04 -0400, Greg Freemyer wrote:
>> On Fri, Jun 20, 2008 at 6:41 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>> James Bottomley wrote:
>>>> On Fri, 2008-06-20 at 13:06 +0900, Tejun Heo wrote:
>>>>> The biggest problem is how to keep userland happy.  hdX -> sdX
>>>>> transition was painful enough and I have a strong feeling that
>>>>> everyone will come after and hunt down us if we try something like sdX
>>>>> -> bdX now.  :-)
>>>> In theory mounting by label or ID should have fixed a lot of this.
>>>> However, if we need to head off a revolt, the sdX allocation algorithm
>>>> can be placed into it's own module so both sd and a ULD ata driver could
>>>> use it ...
>>>> Actually, surely we can mostly dump the SAT layer?
>>>
>>> I don't see that we can do that for a long time...  And it's not just the
>>> sdX allocation algorithm in question -- SCSI block devices come with their
>>> own partition limits and set of supported ioctls.
>>>
>>> Therefore, my recommended path has always been
>>>
>>> * create ata_disk block device driver (ULD, in your terminology)
>>>
>>> * make SAT an optional piece, which maintains compatibility with existing
>>> SCSI blkdevs, ioctls, command sets
>>>
>>>
>>> I just don't see a valid path moving forward that breaks userland /again/...
>>>  we (ATA hackers) would be drummed out of a job I think :)
>>>
>>> Another option that's been discussed is
>>>
>>> 1) Make SCSI block devices themselves an allocate-able resource (I think
>>> that's what you meant by "placed into it's own module so both sd and a ULD
>>> ata driver could use it"?)
>>>
>>> 2) Ensure that any ata_disk ULD would support the same partition limits and
>>> ioctl set, enough to ensure binary compatibility.
>>>
>>> Because that's the real need -- maintaining binary compatibility with SCSI
>>> block devices, so major/minor, ioctl supported set, partition limits, and
>>> other relevant details need to remain unchanged.
>>>
>> I've seen a lot of end user complaints about libata only supporting
>> 15(14?) partitions.  Will that limit be moved back to the traditional
>> drivers/ide limit as part of this?
> 
> Number of partitions is directly related to number of minors, so it
> can't be changed without a change in the allocation of major/minor space
> in sd ... that could only be done compatibly by permuting the space.
> The only other way to do it is incompatibly by changing major (again).
> 
> James
> 
Could we do both? I mean use the legacy, up to 15, with the old major,
then use the new major for bigger then 15. Since user mode that knows
about more then 15 partitions is new, it'll know it needs to jump a major.

Boaz
