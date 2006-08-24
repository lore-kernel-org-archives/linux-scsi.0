From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Need help with another aic94xx sequencer problem
Date: Thu, 24 Aug 2006 01:58:41 -0700 (PDT)
Message-ID: <20060824085841.27630.qmail@web31810.mail.mud.yahoo.com>
References: <1156278519.19615.31.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:48982 "HELO
	web31810.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750860AbWHXI6l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Aug 2006 04:58:41 -0400
In-Reply-To: <1156278519.19615.31.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> While abusing my sas topology (to try to get it to give me errors) I
> came across this one with STP tasks:
> 
> When the aic94xx loses a task in sas_execute_tasks(), the timeout fires
> and wakes the waiter (this leaves the task set pending and aborted).  In
> response, sas_execute_task() tries to call lldd_abort_task()
> (asd_abort_task()) on it.  Here we panic failing the BUG_ON(!list_empty)
> check in aic94xx_hwi.h:asd_ascb_free().
> 
> What happens is that the abort comes back with TF_TMF_NO_CTX + 0xFF00
> from the sequencer, which asd_abort_task() treats as success and then
> panics because the original task is still active.

The sequencer response is correct but incomplete.  The interpretation
is a bad compromize between SSP and STP.

TF_TMF_NO_CTX should be interpreted as TMF_RESP_FUNC_ESUPP to get
"best of both worlds", and then upper layers would do the proper
thing depending on the protocol.

Of course your version of my code and my version of my code differ
somewhat.

The fix in the sequencer is messy as is the fix in software.

    Luben


> 
> Either the abort function or the sequencer code is clearly wrong, but
> not having access to the sequencer to look, I can't tell.  What should 
> this return mean from the sequencer?  My suspicion is that it means the
> STP task abort isn't actually formulated properly.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

