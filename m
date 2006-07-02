From: Erez Zilber <erezz@voltaire.com>
Subject: Re: Receiving a SCSI response after abort task was sent
Date: Sun, 02 Jul 2006 16:47:58 +0300
Message-ID: <44A7CE8E.1010106@voltaire.com>
References: <44A7A547.6080709@voltaire.com> <20060702132231.GA10030@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from taurus.voltaire.com ([193.47.165.240]:59281 "EHLO
	taurus.voltaire.com") by vger.kernel.org with ESMTP
	id S1751230AbWGBNr7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 09:47:59 -0400
In-Reply-To: <20060702132231.GA10030@mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ishai Rabinovitz <ishai@mellanox.co.il>
Cc: linux-scsi@vger.kernel.org

Ishai Rabinovitz wrote:
> On Sun, Jul 02, 2006 at 01:51:51PM +0300, Erez Zilber wrote:
>   
>> Hi,
>>
>> I have a question about aborting tasks: when an initiator sends "abort 
>> task" to the target, it is possible that the target will send a SCSI 
>> response for the same task before receiving the abort task (I guess that 
>> the target won't send a task management response for the abort task). 
>> What should the initiator do with the SCSI response? Is the host that 
>> issued the abort task willing to receive a SCSI response for that task? 
>> Is it willing to receive only a task management response for the abort task?
>>
>> This message was also sent to ips mailing list.
>>
>> Thanks
>> -- 
>>
>>     
>
> In my opinion the initiator should work with the response and call the
> done callback of this SCSI command.
> This is the way we implement it in SRP: When we get a response for the task 
> we set a bit indicting that this command was done. 
> In the code that sends the task management and waits for response, we check 
> after getting the response if this flag is set. If the flag is set we call 
> the done callback. If it is not set, we set the result of the command to 
> DID_ABORT.
>
>
>   
Did you find any ref for this in SAM3? The only thing that I was able to 
find there is that a target that receives an "abort task" has to send a 
task management response even if it has already sent a SCSI response for 
that task.

Thanks
Erez
