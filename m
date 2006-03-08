From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI target and IO-throttling
Date: Wed, 08 Mar 2006 20:49:20 +0300
Message-ID: <440F1920.1050608@vlnb.net>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com> <440EF9AC.7070903@vlnb.net> <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([195.208.234.171]:19419 "EHLO
	out-relay-02.infobox.ru") by vger.kernel.org with ESMTP
	id S1751109AbWCHRuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 12:50:12 -0500
In-Reply-To: <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org

Steve Byan wrote:
> 
> On Mar 8, 2006, at 10:35 AM, Vladislav Bolkhovitin wrote:
> 
>> Bryan Henderson wrote:
>>
>>> Why would the queue have a greater capacity than what is needed  when 
>>> you care about performance?  Is there some non-performance  reason to 
>>> have a giant queue?
>>> I still think having a giant queue is not a solution to any flow  
>>> control (or, in the words of the original problem, I/O throttling)  
>>> problem.  I'm even skeptical that there's any size you can make  one 
>>> that would avoid queue full conditions.  It would be like  avoiding 
>>> difficult memory allocation algorithms by just having a  whole lot of 
>>> memory.
>>
>>
>> Yes, you're correct. But can you formulate a practical common rule  
>> working on any SCSI transport, including FC, on which a SCSI  target, 
>> which knows some limit, can tell it to an initiator, so it  will not 
>> try to queue too many commands, please? It looks like I  have no 
>> choice, except doing "giant" queue on target hoping that  initiators 
>> are smart enough to not queue so many commands that it  starts seeing 
>> timeouts.
> 
> 
> I still don't understand why you are reluctant to return  TASK_SET_FULL 
> or BUSY in this case; it's what the SCSI standard  supplies as the way 
> to say "don't queue too many commands, please".

I don't like out of order execution, which happens practically on all 
such "rejected" commands, because subsequent already queued commands are 
not "rejected" with it and some of them could be accepted later. And the 
initiator (Linux with FC driver) is dumb enough to hit this 
TASK_SET_FULL again and again until the queue is large enough. So, I can 
see only one solution, which almost eliminate breaking the order, - 
unbounded command queue.

But, maybe I should think/experiment more and ease the ordering 
restriction...

Thanks,
Vlad

> If you don't want to return TASK_SET_FULL, then yes, an effectively  
> unbounded command queue is your only alternative.
> 
> Regards,
> -Steve

