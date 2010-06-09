From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Wed, 09 Jun 2010 19:58:00 +0400
Message-ID: <4C0FBA08.2090502@vlnb.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>	 <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com>	 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com> <1275398876.21962.6.camel@mulgrave.site> <4C078FE2.9000804@vlnb.net> <4C079B07.5020303@panasas.com> <4C07A2EB.4080006@vlnb.net> <4C07A442.1030502@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C07A442.1030502@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Christof Schmitt <christof.schmitt@de.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Vladislav Bolkhovitin, on 06/03/2010 04:46 PM wrote:
> 
> Vladislav Bolkhovitin, on 06/03/2010 04:41 PM wrote:
>> Boaz Harrosh, on 06/03/2010 04:07 PM wrote:
>>> On 06/03/2010 02:20 PM, Vladislav Bolkhovitin wrote:
>>>> There's one interesting problem here, at least theoretically, with SCSI 
>>>> or similar transports which allow to have commands queue depth >1 and 
>>>> allowed to internally reorder queued requests. I don't know the FS/block 
>>>> layers sufficiently well to tell if sending several requests for the 
>>>> same page really possible or not, but we can see a real life problem, 
>>>> which can be well explained if it's possible.
>>>>
>>>> The problem could be if the second (rewrite) request (SCSI command) for 
>>>> the same page queued to the corresponding device before the original 
>>>> request finished. Since the device allowed to freely reorder requests, 
>>>> there's a probability that the original write request would hit the 
>>>> permanent storage *AFTER* the retry request, hence the data changes it's 
>>>> carrying would be lost, hence welcome data corruption.
>>>>
>>> I might be totally wrong here but I think NCQ can reorder sectors but
>>> not writes. That is if the sector is cached in device memory and a later
>>> write comes to modify the same sector then the original should be
>>> replaced not two values of the same sector be kept in device cache at the
>>> same time.
>>>
>>> Failing to do so is a scsi device problem.
>> SCSI devices supporting Full task management model (almost all) and 
>> having QUEUE ALGORITHM MODIFIER bits in Control mode page set to 1 
>> allowed to freely reorder any commands with SIMPLE task attribute. If an 
>> application wants to maintain order of some commands for such devices, 
>> it must issue them with ORDERED task attribute and over a _single_ MPIO 
>> path to the device.
>>
>> Linux neither uses ORDERED attribute, nor honors or enforces anyhow 
>> QUEUE ALGORITHM MODIFIER bits, nor takes care to send commands with 
>> order dependencies (overlapping writes in our case) over a single MPIO path.
>>
>>> Please note that page-to-sector is not necessary constant. And the same page
>>> might get written at a different sector, next time. But FSs will have to
>>> barrier in this case.
>>>
>>>> For single parallel SCSI or SAS devices such race may look practically 
>>>> impossible, but for sophisticated clusters when many nodes pretending to 
>>>> be a single SCSI device in a load balancing configuration, it becomes 
>>>> very real.
>>>>
>>>> The real life problem we can see in an active-active DRBD-setup. In this 
>>>> configuration 2 nodes act as a single SCST-powered SCSI device and they 
>>>> both run DRBD to keep their backstorage in-sync. The initiator uses them 
>>>> as a single multipath device in an active-active round-robin 
>>>> load-balancing configuration, i.e. sends requests to both nodes in 
>>>> parallel, then DRBD takes care to replicate the requests to the other node.
>>>>
>>>> The problem is that sometimes DRBD complies about concurrent local 
>>>> writes, like:
>>>>
>>>> kernel: drbd0: scsi_tgt0[12503] Concurrent local write detected! 
>>>> [DISCARD L] new: 144072784s +8192; pending: 144072784s +8192
>>>>
>>>> This message means that DRBD detected that both nodes received 
>>>> overlapping writes on the same block(s) and DRBD can't figure out which 
>>>> one to store. This is possible only if the initiator sent the second 
>>>> write request before the first one completed.
>>> It is totally possible in today's code.
>>>
>>> DRBD should store the original command_sn of the write and discard
>>> the sector with the lower SN. It should appear as a single device
>>> to the initiator.
>> How can it find the SN? The commands were sent over _different_ MPIO 
>> paths to the device, so at the moment of the sending all the order 
>> information was lost.
>>
>> Until SCSI generally allowed to preserve ordering information between 
>> MPIO paths in such configurations the only way to maintain commands 
>> order would be queue draining. Hence, for safety all initiators working 
>> with such devices must do it.
>>
>> But looks like Linux doesn't do it, so unsafe with MPIO clusters?
> 
> I meant load balancing MPIO clusters.

Actually, if consider processing of exception conditions like Task Set 
Full status or Unit Attentions, queuing of several write commands for 
the same page(s) is not safe also for all other MPIO clusters as well as 
for single path SCSI-transport devices, like regular HDDs or other 
SAS/FC/iSCSI/... storage.

This is because in case of exception conditions the first write command 
could be preliminary finished to deliver the exception condition status 
to the initiator, but all the queued after it commands would be neither 
aborted, nor suspended. So, after retrying the command can be queued 
_after_ the second write command, hence they would be executed in the 
reverse order with related data corruption.

To prevent such things, SCSI standard provides ACA and UA interlock 
facilities, but Linux doesn't use them.

Thus, to be safe Linux should:

1. Either don't write on pages under IO, hence don't queue retries,

2. Or queue retries only after the original write finished.

Vlad
