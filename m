From: Steve Byan <smb@egenera.com>
Subject: Re: SCSI target and IO-throttling
Date: Wed, 8 Mar 2006 10:56:38 -0500
Message-ID: <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com> <440EF9AC.7070903@vlnb.net>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:10424 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1751292AbWCHP4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 10:56:44 -0500
In-Reply-To: <440EF9AC.7070903@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org


On Mar 8, 2006, at 10:35 AM, Vladislav Bolkhovitin wrote:

> Bryan Henderson wrote:
>> Why would the queue have a greater capacity than what is needed  
>> when you care about performance?  Is there some non-performance  
>> reason to have a giant queue?
>> I still think having a giant queue is not a solution to any flow  
>> control (or, in the words of the original problem, I/O throttling)  
>> problem.  I'm even skeptical that there's any size you can make  
>> one that would avoid queue full conditions.  It would be like  
>> avoiding difficult memory allocation algorithms by just having a  
>> whole lot of memory.
>
> Yes, you're correct. But can you formulate a practical common rule  
> working on any SCSI transport, including FC, on which a SCSI  
> target, which knows some limit, can tell it to an initiator, so it  
> will not try to queue too many commands, please? It looks like I  
> have no choice, except doing "giant" queue on target hoping that  
> initiators are smart enough to not queue so many commands that it  
> starts seeing timeouts.

I still don't understand why you are reluctant to return  
TASK_SET_FULL or BUSY in this case; it's what the SCSI standard  
supplies as the way to say "don't queue too many commands, please".

If you don't want to return TASK_SET_FULL, then yes, an effectively  
unbounded command queue is your only alternative.

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


