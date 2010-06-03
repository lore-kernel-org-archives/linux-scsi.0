From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Thu, 03 Jun 2010 17:23:32 +0400
Message-ID: <4C07ACD4.2060504@vlnb.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>	 <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com>	 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com> <1275398876.21962.6.camel@mulgrave.site> <4C078FE2.9000804@vlnb.net> <4C079B07.5020303@panasas.com> <4C07A2EB.4080006@vlnb.net> <4C07A8E9.30608@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C07A8E9.30608@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Christof Schmitt <christof.schmitt@de.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, Gennadiy Nerubayev <parakie@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh, on 06/03/2010 05:06 PM wrote:
> On 06/03/2010 03:41 PM, Vladislav Bolkhovitin wrote:
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
> 
> OK I take your word for it. But that sounds stupid to me. I would think
> that sectors can be ordered. not commands per se. What happen with reads
> then? do they get to be ordered? I mean a read in between the two writes which
> value is read? It gets so complicated that only a sector model makes sense
> to me.

Look wider. For a single HDD your way of thinking makes sense. But how 
about big clusters consisting from many nodes with many clients? In them 
maintaining internal commands order is generally bad and often a way too 
expensive for performance.

It's the same as with modern CPUs, where for performance reasons 
programmers also must live with the commands reorder possibilities and 
use barriers, when necessary.

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
> 
> I'm not hard on the specifics here. But I think the initiator has set
> the same SN on the two paths, or has incremented them between paths.
> You said:
> 
>> The initiator uses them as a single multipath device in an active-active
>> round-robin load-balancing configuration, i.e. sends requests to both nodes
>> in paralle.
> 
> So what was the SN sent to each side. Is there a relationship between them
> or they each advance independently?
> 
> If there is a relationship then the targets on two sides should store
> the SN for later comparison. (Life is hard)

None of SCSI transports carry any SN to other paths (I_T nexuses) 
related information in internal packets, including iSCSI. It's simply 
out of SAM. If you need order information between paths, you must use 
"extensions", like iSCSI MC/S, but they are bad for many other reasons. 
I summarized it in http://scst.sourceforge.net/mc_s.html.

Vlad
