From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI target and IO-throttling
Date: Fri, 10 Mar 2006 21:46:52 +0300
Message-ID: <4411C99C.9040200@vlnb.net>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com> <440EF9AC.7070903@vlnb.net> <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com> <440F1920.1050608@vlnb.net> <43998989-7BD3-4F3F-A10A-17385D63411E@egenera.com> <441075D4.6010109@vlnb.net> <80454C34-75B9-409B-A454-B8AB0DB1AF4D@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([195.208.234.171]:52697 "EHLO
	out-relay-02.infobox.ru") by vger.kernel.org with ESMTP
	id S1751424AbWCJSrs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 13:47:48 -0500
In-Reply-To: <80454C34-75B9-409B-A454-B8AB0DB1AF4D@egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org

Steve Byan wrote:
> On Mar 9, 2006, at 1:37 PM, Vladislav Bolkhovitin wrote:
> 
>> Steve Byan wrote:
>>
>>> On Mar 8, 2006, at 12:49 PM, Vladislav Bolkhovitin wrote:
>>>
>>>> Steve Byan wrote:
>>>>
>>>>>
>>>>> I still don't understand why you are reluctant to return    
>>>>> TASK_SET_FULL or BUSY in this case; it's what the SCSI  standard   
>>>>> supplies as the way to say "don't queue too many  commands, please".
>>>>
>>>>
>>>>
>>>> I don't like out of order execution, which happens practically  on  
>>>> all such "rejected" commands, because subsequent already  queued  
>>>> commands are not "rejected" with it and some of them  could be  
>>>> accepted later.
>>>
>>> I see, you care about order. So do tapes. The historical answer  has  
>>> been to not support tagged command queuing when you care  about  
>>> ordering. To dodge the performance problem due to lack of  queuing,  
>>> the targets usually implement a read-ahead and write- behind cache,  
>>> and then perform queuing behind the scenes, after  telling the  
>>> initiator that the command has completed. Of course,  this has 
>>> obvious  data integrity issues for disk-type logical units.
>>
>>
>> Yes, tapes just can't work without strict ordering. SCST was  
>> originally done for tapes, so I still keep some kind of tape- oriented 
>> thinking :)
>>
>> Actually, with current journaling file systems ordering also became  
>> more important for disks as well.
> 
> 
> Usually the workload from a journaling filesystem consists of a lot  of 
> unordered writes (user data) and some partially-ordered writes  
> (metadata). The partially-ordered writes do not have a defined  ordering 
> with respect to the unordered writes; they are ordered only  with 
> respect to each other. Most systems today solve the  TASK_SET_FULL 
> problem by only having one ordered write outstanding at  any point in 
> time. You want to do it this way anyway, so that you can  build up a 
> queue of commits and do a group commit with the next write  to the journal.
> 
> If you need write barriers between the metadata writes and the data  
> writes, the initiator should use the ORDERED task tag on that write,  
> and have only one ORDERED write outstanding at any point in time (I  
> mean to the same logical unit, of course).

I mean the barrier between journal writes and metadata writes, because 
they order is essential for a FS health. User data almost always not 
journaled and not protected.

Obviously, having only one ORDERED, i.e. journal, write and having to 
wait for it completition before submitting subsequent commands creates 
some performance bottleneck. I mean mostly latency, which often quite 
big in many SCSI transports. It would be much better to queue as many 
such ORDERED commands as necessary and then, without waiting for their 
completition, metadata updates (SIMPLE) commands and being sure, that no 
metadata commands will be executed if any of ORDERED ones fail. As far 
as I can see, nothing prevents to work that way right now, except that 
somebody should implement it in both hardware and software.

>> Data integrity problem in "behind the scenes" queuing could be on  
>> practice easily solved by battery-based backup power on the disks.  In 
>> case of TASK_SET_FULL things are much worse, because the  reordering 
>> happens _between_ target and _initiator_, since the  initiator must 
>> retry "rejected" command explicitly, then in case of  the initiator 
>> crash before the command will be retried and if FS on  it uses 
>> ordering barriers to protect the integrity (Linux seems  does so, but 
>> I could be wrong), the FS data could be written out of  order with its 
>> journal and the FS could be corrupted. Even worse,  TASK_SET_FULL 
>> "rejects" basically happen every the queue length'th  command, ie very 
>> often. This is why I prefer the "dumb" and "safe"  way. But, I could 
>> overestimate the problem, because it looks like  nobody cares about it..
> 
> 
> See above, Since only one ordered write is ever pending, no file  system 
> corruption occurs. Since you want to do group commits anyway,  you never 
> need to have more than one ordered write pending.
> 
>>
>>> The solution introduced for tapes concurrent with iSCSI (which   
>>> motivated the need for command-queuing for tapes, since some   
>>> envisioned backing up to a tape drive located on 3000 miles away  is  
>>> something called "unit-attention interlock", or "UA  interlock". 
>>> Check  out page 287 of the draft revision 23 of the  SCSI Primary 
>>> Commands -  3 (SPC-3) standard from T10.org. The  UA_INTLCK_CTRL 
>>> field can be set  to cause a persistent unit  attention condition if 
>>> a command was  rejected with TASK_SET_FULL  or BUSY.
>>
>>
>> Thanks, I'll take a look.
>>
>>> This requires the cooperation of the initiator.
>>
>>
>> Which practically means that it will not work for at least several  
>> years.
> 
> 
> Well, the feature was added back in 2001 or 2002; the initiators have  
> already had years to incorporate it. This might say something about  the 
> state of the Linux SCSI subsystem (running and ducking for  cover :-). 
> Seriously, I think this has more to do with either the  lack of need for 
> command-queuing for tapes or the lack of modern tape  support in Linux.
> 
>> I think, I won't be wrong, if say that no Linux initiators use this  
>> feature and going to use...
> 
> 
> If you have an initiator that is sending queued SCSI commands with  the 
> SIMPLE task attribute but which expects the target to maintain  ordering 
> of those commands, the SCSI standard can't help you. The  initiator is 
> broken.

Sure

> If the initiator needs to send _queued_ SCSI commands with a task  
> attribute of ORDERED, then to preserve ordering it must set the  
> UA_INTLCK_CTL appropriately. The SCSI standard has no other mechanism  
> to offer such an initiator.
> 
> To the best of my knowledge no current Linux initiator sends SCSI  
> commands with a task attribute other than SIMPLE., and you seem to be  
> concerned only about Linux initiators. Therefor your target does not  
> need to preserve order. QUED.

I prefer to be overinsured in such cases.

>> BTW, it is also impossible to correctly process commands errors  
>> (CHECK CONDITIONs) in async environment
> 
> 
> When you say "async environment" I assume you are referring to  queuing 
> SCSI commands using SCSI command queuing, as opposed to  sending a 
> single SCSI command and synchronously awaiting its completion.

Yes

>> without using ACA (Auto Contingent Allegiance). Again, I see no  sign 
>> that it's used by Linux or somebody interested to use it in  Linux. 
>> Have I missed anything and it is not important? (rather  rhetorical 
>> question)
> 
> 
> ACA is not important if the command that got the error is idempotent  
> and independent of all other commands in flight. In the case of disks  
> (SBC command set) and CD-ROMs and DVD-ROMs (MMC command-set) this  
> condition is true (given the restriction on the number of outstanding  
> ordered writes which I discussed above), and so ACA is not needed.

Yes, when working as you described, ACA is not needed. But when working 
as I described, ACA is essential.

> Tapes would need ACA if they did command queuing (which is why ACA  was 
> invented), but the practice in tape-land seems to be to avoid  SCSI 
> command queuing and instead asynchronously stage the operations  behind 
> the target. This does lead to complications in error recovery,  which is 
> why tape error handling is so problematic.

Could you please explain "synchronously stage the operations behind the 
target" more? I don't understand what you mean.

> My advice to you is to either
> a) follow the industry trend, which is to use command queuing only  for 
> SBC (disk) targets and not for MMC (CD-ROM) and SSC (tape)  targets, or
> b) fix the initiator to handle ordered queuing (i.e. add support for  
> the ORDERED and ACA task tags, ACA, and UA_INTLCK_CTL).

OK, thanks. Looks like (a) is easier :).

BTW, do you have any statistic how many modern SCSI disks support those 
features (ORDERED, ACA, UA_INTLCK_CTL, etc)? Few years ago none of 
available for us SCSI hardware, including tape libraries, supported ACA. 
It was not very modern for that time, though

Regards,
Vlad
