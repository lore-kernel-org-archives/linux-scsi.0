From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Fri, 10 Mar 2006 14:47:11 -0500
Message-ID: <2320D705-5F93-4F52-8802-A96B63756750@egenera.com>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com> <440EF9AC.7070903@vlnb.net> <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com> <440F1920.1050608@vlnb.net> <43998989-7BD3-4F3F-A10A-17385D63411E@egenera.com> <441075D4.6010109@vlnb.net> <80454C34-75B9-409B-A454-B8AB0DB1AF4D@egenera.com> <4411C99C.9040200@vlnb.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:23186 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1750725AbWCJTrQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 14:47:16 -0500
In-Reply-To: <4411C99C.9040200@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org


On Mar 10, 2006, at 1:46 PM, Vladislav Bolkhovitin wrote:

> Steve Byan wrote:
>> On Mar 9, 2006, at 1:37 PM, Vladislav Bolkhovitin wrote:

> I mean the barrier between journal writes and metadata writes,  
> because they order is essential for a FS health.

I counted journal writes as metadata writes. If you want to make a  
distinction, OK, we now have a common language.

> Obviously, having only one ORDERED, i.e. journal, write and having  
> to wait for it completition before submitting subsequent commands  
> creates some performance bottleneck.

It might be obvious but it's not true.

You missed my point about group commits to the journal. That's why  
there's no performance hit for only having one outstanding journal  
write at a time; each journal write commits many transactions. Stated  
another way, you don't want to eagerly initiate journal writes; you  
want to execute one at a time, and group all transactions that arrive  
while the one write is active into the next write.

See the seminal paper from Xerox PARC on "Group Commits in the CEDAR  
Filesystem". I'm working from memory so I can't give you a better  
citation than that. It's an old paper, probably circa 1987 or 1988,  
published I think in an ACM journal.

I've benchmarked metadata-intensive workloads on a journaling  
filesystem with a storage controller with NV-RAM arranged so that all  
metadata and journal writes complete without any disk activity  
against a vanilla controller. The lights on the disks on the NV-RAM  
controller never came on; i.e. there was _no_ disk activity. The  
lights on the disks attached to the vanilla controller were on solid.  
The performance of the two systems was essentially the same with  
respect to average response time and throughput.

> I mean mostly latency, which often quite big in many SCSI  
> transports. It would be much better to queue as many such ORDERED  
> commands as necessary and then, without waiting for their  
> completition, metadata updates (SIMPLE) commands and being sure,  
> that no metadata commands will be executed if any of ORDERED ones  
> fail. As far as I can see, nothing prevents to work that way right  
> now, except that somebody should implement it in both hardware and  
> software.

If you use group commits, there's little value in implementing this.

>> To the best of my knowledge no current Linux initiator sends SCSI   
>> commands with a task attribute other than SIMPLE., and you seem to  
>> be  concerned only about Linux initiators. Therefor your target  
>> does not  need to preserve order. QUED.
>
> I prefer to be overinsured in such cases.

Suit yourself. Just don't expect help from the SCSI standard, it's  
not designed to do that.



>> ACA is not important if the command that got the error is  
>> idempotent  and independent of all other commands in flight. In  
>> the case of disks  (SBC command set) and CD-ROMs and DVD-ROMs (MMC  
>> command-set) this  condition is true (given the restriction on the  
>> number of outstanding  ordered writes which I discussed above),  
>> and so ACA is not needed.
>
> Yes, when working as you described, ACA is not needed. But when  
> working as I described, ACA is essential.

As is unit attention interlock.

>> Tapes would need ACA if they did command queuing (which is why  
>> ACA  was invented), but the practice in tape-land seems to be to  
>> avoid  SCSI command queuing and instead asynchronously stage the  
>> operations  behind the target. This does lead to complications in  
>> error recovery,  which is why tape error handling is so problematic.
>
> Could you please explain "synchronously stage the operations behind  
> the target" more? I don't understand what you mean.

I mean they buffer the operations in memory after completing the SCSI  
command and then (asynchronous to the execution of the SCSI command,  
i,e, after it has been completed) queue them ("stage" them) and send  
them on to the physical device.

I'm a bit hazy on the terminology, because I was never a tape guy and  
it's been years since I thought about tapes, but I think the term the  
industry used when streaming tapes first came out was "buffered  
operation". The tape controller accepts the write command and  
completes it with good status but doesn't write it to the media; it  
waits until it has accumulated a sufficient number of records to keep  
the tape streaming before starting to dump the buffer to the tape  
media. This avoids the need for SCSI command-queuing while still  
keeping the tape streaming.

>> My advice to you is to either
>> a) follow the industry trend, which is to use command queuing  
>> only  for SBC (disk) targets and not for MMC (CD-ROM) and SSC  
>> (tape)  targets, or
>> b) fix the initiator to handle ordered queuing (i.e. add support  
>> for  the ORDERED and ACA task tags, ACA, and UA_INTLCK_CTL).
>
> OK, thanks. Looks like (a) is easier :).
>
> BTW, do you have any statistic how many modern SCSI disks support  
> those features (ORDERED, ACA, UA_INTLCK_CTL, etc)? Few years ago  
> none of available for us SCSI hardware, including tape libraries,  
> supported ACA. It was not very modern for that time, though

I can't say with certainty, but I believe no SCSI disk supports ACA  
or UA_INTLCK_CTL. Some may support the ORDERED task tag but I guess  
it would be implemented in a low-performance path.

Storage controllers might be a different story; I have no data on  
what they support in the way of task attributes, ACA, and unit  
attention interlock.

As far as tapes go, I've got no data on modern SCSI tape controllers,  
but judging by the squirming going on in T10 around command-ordering  
for Fibre Channel tapes, I'd guess very few if any have gotten  
command-queuing to work for tapes.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


