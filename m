From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 10:03:25 -0500
Message-ID: <432D81BD.9080803@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu> <1126974325.10413.5.camel@max> <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:23762 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751272AbVIRRDd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 13:03:33 -0400
In-Reply-To: <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Sat, 17 Sep 2005, Mike Christie wrote:
> 
> 
>>On Sat, 2005-09-17 at 10:55 -0500, Mike Christie wrote:
>>
>>>Mike Christie wrote:
>>>
>>>>Kai Makisara wrote:
>>>>
>>>>
>>>>>I think I may have found the problem: scsi_execute_async does not use 
>>>>>the parameter retries (the same applies to scsi_execute btw). This 
>>>>>leads to retrying the reads at filemark and this is not correct. I 
>>>>>added the hack below to scsi_execute_async and after this the simple 
>>>>>tests succeed.
>>>>
>>>>
>>>>ah ok. I think when we prep the command we need to copy the retries from 
>>>>the command. So in st.c st_init_command callout we need to copy that 
>>>>value (we are just copying the timeout today).
>>>
>>>oh I guess there is not retries count on the request like there is for 
>>>timeout :)
>>>
>>>But it looks like retried is always 0. I guess st's init_command could 
>>>just do
>>>
>>>SCpnt->allowed = 0;
> 
> 
> This does not work because st_init_command() is not called (called only 
> with SG_IO ioctls).

The scsi_execute* functions actually send all commands down as 
REQ_BLOCK_PC commands like SG_IO so we are always going through the 
st_init_commad().


> 
> 
>>
>>Or how about this patch it was made against my updated patches here:
>>http://www.cs.wisc.edu/~michaelc/block/use-sg/v6/
>>
>>It is the 06-add-retry-field.patch patch. All it does it add a retries
>>count onto the request so it can be passed around like the timeout
>>value.
>>
> 
> [patch cut]
> 
> This looks like a clean approach because it allows passing the retries 
> parameter of scsi_execute_* to the request processing.
> 
> I tested this but it does not quite work: there are now two retries in the 
> same test that previously gave six retries. Unfortunately I don't just now 
> have time to study the problem further.
> 

ok I will try to look into it.

