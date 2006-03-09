From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Thu, 9 Mar 2006 14:32:41 -0500
Message-ID: <80454C34-75B9-409B-A454-B8AB0DB1AF4D@egenera.com>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com> <440EF9AC.7070903@vlnb.net> <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com> <440F1920.1050608@vlnb.net> <43998989-7BD3-4F3F-A10A-17385D63411E@egenera.com> <441075D4.6010109@vlnb.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:11441 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1751352AbWCITcs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 14:32:48 -0500
In-Reply-To: <441075D4.6010109@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org


On Mar 9, 2006, at 1:37 PM, Vladislav Bolkhovitin wrote:

> Steve Byan wrote:
>> On Mar 8, 2006, at 12:49 PM, Vladislav Bolkhovitin wrote:
>>> Steve Byan wrote:
>>>
>>>>
>>>> I still don't understand why you are reluctant to return    
>>>> TASK_SET_FULL or BUSY in this case; it's what the SCSI  
>>>> standard   supplies as the way to say "don't queue too many  
>>>> commands, please".
>>>
>>>
>>> I don't like out of order execution, which happens practically  
>>> on  all such "rejected" commands, because subsequent already  
>>> queued  commands are not "rejected" with it and some of them  
>>> could be  accepted later.
>> I see, you care about order. So do tapes. The historical answer  
>> has  been to not support tagged command queuing when you care  
>> about  ordering. To dodge the performance problem due to lack of  
>> queuing,  the targets usually implement a read-ahead and write- 
>> behind cache,  and then perform queuing behind the scenes, after  
>> telling the  initiator that the command has completed. Of course,  
>> this has obvious  data integrity issues for disk-type logical units.
>
> Yes, tapes just can't work without strict ordering. SCST was  
> originally done for tapes, so I still keep some kind of tape- 
> oriented thinking :)
>
> Actually, with current journaling file systems ordering also became  
> more important for disks as well.

Usually the workload from a journaling filesystem consists of a lot  
of unordered writes (user data) and some partially-ordered writes  
(metadata). The partially-ordered writes do not have a defined  
ordering with respect to the unordered writes; they are ordered only  
with respect to each other. Most systems today solve the  
TASK_SET_FULL problem by only having one ordered write outstanding at  
any point in time. You want to do it this way anyway, so that you can  
build up a queue of commits and do a group commit with the next write  
to the journal.

If you need write barriers between the metadata writes and the data  
writes, the initiator should use the ORDERED task tag on that write,  
and have only one ORDERED write outstanding at any point in time (I  
mean to the same logical unit, of course).

> Data integrity problem in "behind the scenes" queuing could be on  
> practice easily solved by battery-based backup power on the disks.  
> In case of TASK_SET_FULL things are much worse, because the  
> reordering happens _between_ target and _initiator_, since the  
> initiator must retry "rejected" command explicitly, then in case of  
> the initiator crash before the command will be retried and if FS on  
> it uses ordering barriers to protect the integrity (Linux seems  
> does so, but I could be wrong), the FS data could be written out of  
> order with its journal and the FS could be corrupted. Even worse,  
> TASK_SET_FULL "rejects" basically happen every the queue length'th  
> command, ie very often. This is why I prefer the "dumb" and "safe"  
> way. But, I could overestimate the problem, because it looks like  
> nobody cares about it..

See above, Since only one ordered write is ever pending, no file  
system corruption occurs. Since you want to do group commits anyway,  
you never need to have more than one ordered write pending.
>
>> The solution introduced for tapes concurrent with iSCSI (which   
>> motivated the need for command-queuing for tapes, since some   
>> envisioned backing up to a tape drive located on 3000 miles away  
>> is  something called "unit-attention interlock", or "UA  
>> interlock". Check  out page 287 of the draft revision 23 of the  
>> SCSI Primary Commands -  3 (SPC-3) standard from T10.org. The  
>> UA_INTLCK_CTRL field can be set  to cause a persistent unit  
>> attention condition if a command was  rejected with TASK_SET_FULL  
>> or BUSY.
>
> Thanks, I'll take a look.
>
>> This requires the cooperation of the initiator.
>
> Which practically means that it will not work for at least several  
> years.

Well, the feature was added back in 2001 or 2002; the initiators have  
already had years to incorporate it. This might say something about  
the state of the Linux SCSI subsystem (running and ducking for  
cover :-). Seriously, I think this has more to do with either the  
lack of need for command-queuing for tapes or the lack of modern tape  
support in Linux.

> I think, I won't be wrong, if say that no Linux initiators use this  
> feature and going to use...

If you have an initiator that is sending queued SCSI commands with  
the SIMPLE task attribute but which expects the target to maintain  
ordering of those commands, the SCSI standard can't help you. The  
initiator is broken.

If the initiator needs to send _queued_ SCSI commands with a task  
attribute of ORDERED, then to preserve ordering it must set the  
UA_INTLCK_CTL appropriately. The SCSI standard has no other mechanism  
to offer such an initiator.

To the best of my knowledge no current Linux initiator sends SCSI  
commands with a task attribute other than SIMPLE., and you seem to be  
concerned only about Linux initiators. Therefor your target does not  
need to preserve order. QUED.


> BTW, it is also impossible to correctly process commands errors  
> (CHECK CONDITIONs) in async environment

When you say "async environment" I assume you are referring to  
queuing SCSI commands using SCSI command queuing, as opposed to  
sending a single SCSI command and synchronously awaiting its completion.

> without using ACA (Auto Contingent Allegiance). Again, I see no  
> sign that it's used by Linux or somebody interested to use it in  
> Linux. Have I missed anything and it is not important? (rather  
> rhetorical question)

ACA is not important if the command that got the error is idempotent  
and independent of all other commands in flight. In the case of disks  
(SBC command set) and CD-ROMs and DVD-ROMs (MMC command-set) this  
condition is true (given the restriction on the number of outstanding  
ordered writes which I discussed above), and so ACA is not needed.

Tapes would need ACA if they did command queuing (which is why ACA  
was invented), but the practice in tape-land seems to be to avoid  
SCSI command queuing and instead asynchronously stage the operations  
behind the target. This does lead to complications in error recovery,  
which is why tape error handling is so problematic.

My advice to you is to either
a) follow the industry trend, which is to use command queuing only  
for SBC (disk) targets and not for MMC (CD-ROM) and SSC (tape)  
targets, or
b) fix the initiator to handle ordered queuing (i.e. add support for  
the ORDERED and ACA task tags, ACA, and UA_INTLCK_CTL).

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


