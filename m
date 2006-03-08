From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Wed, 8 Mar 2006 13:09:35 -0500
Message-ID: <43998989-7BD3-4F3F-A10A-17385D63411E@egenera.com>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com> <440EF9AC.7070903@vlnb.net> <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com> <440F1920.1050608@vlnb.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:7364 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1751206AbWCHSJy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 13:09:54 -0500
In-Reply-To: <440F1920.1050608@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org


On Mar 8, 2006, at 12:49 PM, Vladislav Bolkhovitin wrote:

> Steve Byan wrote:
>>

>> I still don't understand why you are reluctant to return   
>> TASK_SET_FULL or BUSY in this case; it's what the SCSI standard   
>> supplies as the way to say "don't queue too many commands, please".
>
> I don't like out of order execution, which happens practically on  
> all such "rejected" commands, because subsequent already queued  
> commands are not "rejected" with it and some of them could be  
> accepted later.

I see, you care about order. So do tapes. The historical answer has  
been to not support tagged command queuing when you care about  
ordering. To dodge the performance problem due to lack of queuing,  
the targets usually implement a read-ahead and write-behind cache,  
and then perform queuing behind the scenes, after telling the  
initiator that the command has completed. Of course, this has obvious  
data integrity issues for disk-type logical units.

The solution introduced for tapes concurrent with iSCSI (which  
motivated the need for command-queuing for tapes, since some  
envisioned backing up to a tape drive located on 3000 miles away is  
something called "unit-attention interlock", or "UA interlock". Check  
out page 287 of the draft revision 23 of the SCSI Primary Commands -  
3 (SPC-3) standard from T10.org. The UA_INTLCK_CTRL field can be set  
to cause a persistent unit attention condition if a command was  
rejected with TASK_SET_FULL or BUSY.

This requires the cooperation of the initiator.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


