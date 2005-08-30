From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] SCSI EH document
Date: Tue, 30 Aug 2005 19:47:31 +0900
Message-ID: <43143943.2050802@gmail.com>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com> <4312D213.9000402@gmail.com> <431313D1.7090107@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.194]:47815 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750930AbVH3Krh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 06:47:37 -0400
Received: by zproxy.gmail.com with SMTP id r28so776879nza
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 03:47:37 -0700 (PDT)
In-Reply-To: <431313D1.7090107@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Bottomley@steeleye.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org


  Hi, Luben.

Luben Tuikov wrote:
> On 08/29/05 05:14, Tejun Heo wrote:
> 
>>>Both all the list-heads need to be cleared, otherwise there may be list 
>>>corruption next time the element is added to the list_head.
>>>
>>
>>
>>  scmd->eh_entry is never used as list head.  It's always used as list 
>>entry.  So, technically, it needs not be cleared, I think.  No?  The 
>>problem we had was w/ shost->eh_cmd_q not being cleared.
> 
> 
> In your "strategy" routine:
> 
> 	...
> 	spin_lock_irqsave(shost->host_lock, flags);
> 	list_splice_init(&shost->eh_cmd_q, &error_q);
> 	spin_unlock_irqrestore(shost->host_lock, flags);
> 	...
> 
> 	loop {
> 		...
> 		list_del_init(&cmd->eh_entry);
> 		...
> 	}
> 
> A good policy to follow is:
> 	1. Never leave prev/next pointing somewhere where
> 		- you don't belong, or
> 		- where you don't know existance is in place.
> 	2. Someone (memory release?) may do:
> 		if (!list_empty(cmd->eh_entry))
> 			Refuse to free the memory.
> 	Which is often the case to check if the object belongs to
> 	a list. (You shouldn't have to do this but case pointed only for
> 	illustrational purposes.)
> 
>    Luben
> 

  The reason why I explicitly stated that clearing scmd->eh_entry was 
not currently necessary was that libata had infinite loop bug due to 
eh_cmd_q related memory corruption and I wanted to make sure that not 
clearing scmd->eh_entry wasn't the cause.

  Previously, libata didn't clear both shost->eh_cmd_q and 
scmd->eh_entry.  I posted an one liner which cleared shost->eh_cmd_q and 
I believe that's the fix for the problem.  However, Mark Lord is still 
having lockup problems with libata which, I suspect, is because libata 
doesn't handle PM's properly.  But, as I'm not very sure, I wanted to 
make sure that libata's not clearing scmd->eh_cmd_q is not causing the 
lockup.

  I agree that, as a policy, always clearing list_head's are nice if 
it's not in the *real* hot path where reducing several assignments 
matter, but as it's not strictly/technically necessary, it might be 
difficult to enforce as long as functions which don't clear list_head 
are there.

  Thanks for your input.  :-)

-- 
tejun
