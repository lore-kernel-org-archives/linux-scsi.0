From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] SCSI EH document
Date: Tue, 30 Aug 2005 10:50:54 -0400
Message-ID: <4314724E.5020400@adaptec.com>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com> <4312D213.9000402@gmail.com> <431313D1.7090107@adaptec.com> <43143943.2050802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54942 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932169AbVH3Ou7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 10:50:59 -0400
In-Reply-To: <43143943.2050802@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Bottomley@steeleye.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org

On 08/30/05 06:47, Tejun Heo wrote:
>   Hi, Luben.
> 
> Luben Tuikov wrote:
> 
>>On 08/29/05 05:14, Tejun Heo wrote:
>>
>>
>>>>Both all the list-heads need to be cleared, otherwise there may be list 
>>>>corruption next time the element is added to the list_head.
>>>>
>>>
>>>
>>> scmd->eh_entry is never used as list head.  It's always used as list 
>>>entry.  So, technically, it needs not be cleared, I think.  No?  The 
>>>problem we had was w/ shost->eh_cmd_q not being cleared.
>>
>>
>>In your "strategy" routine:
>>
>>	...
>>	spin_lock_irqsave(shost->host_lock, flags);
>>	list_splice_init(&shost->eh_cmd_q, &error_q);
>>	spin_unlock_irqrestore(shost->host_lock, flags);
>>	...
>>
>>	loop {
>>		...
>>		list_del_init(&cmd->eh_entry);
>>		...
>>	}
>>
>>A good policy to follow is:
>>	1. Never leave prev/next pointing somewhere where
>>		- you don't belong, or
>>		- where you don't know existance is in place.
>>	2. Someone (memory release?) may do:
>>		if (!list_empty(cmd->eh_entry))
>>			Refuse to free the memory.
>>	Which is often the case to check if the object belongs to
>>	a list. (You shouldn't have to do this but case pointed only for
>>	illustrational purposes.)
>>
>>   Luben
>>
> 
> 
>   The reason why I explicitly stated that clearing scmd->eh_entry was 
> not currently necessary was that libata had infinite loop bug due to 
> eh_cmd_q related memory corruption and I wanted to make sure that not 
> clearing scmd->eh_entry wasn't the cause.
> 
>   Previously, libata didn't clear both shost->eh_cmd_q and 
> scmd->eh_entry.  I posted an one liner which cleared shost->eh_cmd_q and 
> I believe that's the fix for the problem.  However, Mark Lord is still 
> having lockup problems with libata which, I suspect, is because libata 
> doesn't handle PM's properly.  But, as I'm not very sure, I wanted to 
> make sure that libata's not clearing scmd->eh_cmd_q is not causing the 
> lockup.

Ah, ok, thanks for clarifying.

>   I agree that, as a policy, always clearing list_head's are nice if 
> it's not in the *real* hot path where reducing several assignments 
> matter, but as it's not strictly/technically necessary, it might be 
> difficult to enforce as long as functions which don't clear list_head 
> are there.

Unless you're running on anything but a 6502, one or 10 assignments
would make absolutely no difference.  Been there, done that (including
the 6502 ;-) ).

Plus the fact that today's compilers are so much more advanced
than 20 years ago, you'll see no "speedup" difference from the number
of assignments.

Also compare the processor time to assign a value to the processor
time it does anything else, while the disk is doing IO.

What matters is complexity, big-oh notation.

Now, as a matter of practice and experience, programmers
develop certain _patterns_ of programming certain constructs, like
for example linked list manipulation.  Those practices, (patterns),
have proven bugless over many years of programming.  This is
what Jeff is talking about.

While it is true that
	list_del(&cmd->eh_entry);
	release command (cmd)
is equivalent to
	list_del_init(&cmd->eh_entry);
	release command(cmd),
you will find that after time, when this code is augmented
and some block written between the list_del() and release command,
that block may take the wrong assumption causing you to have
mysterious bugs.

	Luben

