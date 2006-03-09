From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI target and IO-throttling
Date: Thu, 09 Mar 2006 21:37:08 +0300
Message-ID: <441075D4.6010109@vlnb.net>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com> <440EF9AC.7070903@vlnb.net> <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com> <440F1920.1050608@vlnb.net> <43998989-7BD3-4F3F-A10A-17385D63411E@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([195.208.234.171]:52673 "EHLO
	out-relay-02.infobox.ru") by vger.kernel.org with ESMTP
	id S1751282AbWCISiD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 13:38:03 -0500
In-Reply-To: <43998989-7BD3-4F3F-A10A-17385D63411E@egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org

Steve Byan wrote:
> 
> On Mar 8, 2006, at 12:49 PM, Vladislav Bolkhovitin wrote:
> 
>> Steve Byan wrote:
>>
>>>
> 
>>> I still don't understand why you are reluctant to return   
>>> TASK_SET_FULL or BUSY in this case; it's what the SCSI standard   
>>> supplies as the way to say "don't queue too many commands, please".
>>
>>
>> I don't like out of order execution, which happens practically on  all 
>> such "rejected" commands, because subsequent already queued  commands 
>> are not "rejected" with it and some of them could be  accepted later.
> 
> 
> I see, you care about order. So do tapes. The historical answer has  
> been to not support tagged command queuing when you care about  
> ordering. To dodge the performance problem due to lack of queuing,  the 
> targets usually implement a read-ahead and write-behind cache,  and then 
> perform queuing behind the scenes, after telling the  initiator that the 
> command has completed. Of course, this has obvious  data integrity 
> issues for disk-type logical units.

Yes, tapes just can't work without strict ordering. SCST was originally 
done for tapes, so I still keep some kind of tape-oriented thinking :)

Actually, with current journaling file systems ordering also became more 
important for disks as well. Data integrity problem in "behind the 
scenes" queuing could be on practice easily solved by battery-based 
backup power on the disks. In case of TASK_SET_FULL things are much 
worse, because the reordering happens _between_ target and _initiator_, 
since the initiator must retry "rejected" command explicitly, then in 
case of the initiator crash before the command will be retried and if FS 
on it uses ordering barriers to protect the integrity (Linux seems does 
so, but I could be wrong), the FS data could be written out of order 
with its journal and the FS could be corrupted. Even worse, 
TASK_SET_FULL "rejects" basically happen every the queue length'th 
command, ie very often. This is why I prefer the "dumb" and "safe" way. 
But, I could overestimate the problem, because it looks like nobody 
cares about it..

> The solution introduced for tapes concurrent with iSCSI (which  
> motivated the need for command-queuing for tapes, since some  envisioned 
> backing up to a tape drive located on 3000 miles away is  something 
> called "unit-attention interlock", or "UA interlock". Check  out page 
> 287 of the draft revision 23 of the SCSI Primary Commands -  3 (SPC-3) 
> standard from T10.org. The UA_INTLCK_CTRL field can be set  to cause a 
> persistent unit attention condition if a command was  rejected with 
> TASK_SET_FULL or BUSY.

Thanks, I'll take a look.

> This requires the cooperation of the initiator.

Which practically means that it will not work for at least several 
years. I think, I won't be wrong, if say that no Linux initiators use 
this feature and going to use...

BTW, it is also impossible to correctly process commands errors (CHECK 
CONDITIONs) in async environment without using ACA (Auto Contingent 
Allegiance). Again, I see no sign that it's used by Linux or somebody 
interested to use it in Linux. Have I missed anything and it is not 
important? (rather rhetorical question)

Thanks,
Vlad
