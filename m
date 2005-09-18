From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 10:17:41 -0500
Message-ID: <432D8515.9010809@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu> <1126974325.10413.5.camel@max> <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local> <432D81BD.9080803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:26834 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932123AbVIRRRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 13:17:46 -0400
In-Reply-To: <432D81BD.9080803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
>> I tested this but it does not quite work: there are now two retries in 
>> the same test that previously gave six retries. Unfortunately I don't 
>> just now have time to study the problem further.
>>
> 
> ok I will try to look into it.
> 

Oh I bet it is from the change that James B noticed. With scsi_do_req() 
we passed in the sr_done function, but with scsi_execute* we pass in the 
requests end_io function. So with scsi_do_req, when we complete a 
command in scsi_finish_command()  (where it calls cmd->done) we would 
call the done function passed into scsi_do_req(), but with scsi_execute* 
we call scsi_io_completion.

Maybe it could be solved by having st implement a cmd->done function 
like sd.c that gets set in the init_command callout. Since all the 
commands will be coming down as REQ_BLOCK_PC commands, st can set the 
scsi_cmnd->done function and decide what to do there. Or maybe some of 
the scsi_io_completion logic needs to be fixed. What was the command 
that is causing the problems?
