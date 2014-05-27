From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 13:52:02 +0200
Message-ID: <53847C62.9070704@redhat.com>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>					 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>				 <5384439C.1040604@acm.org> <1401179019.14454.18.camel@dabdike>			 <5384541B.1010400@acm.org> <1401186086.14454.43.camel@dabdike>		 <53846D3E.6050901@redhat.com> <1401188364.14454.51.camel@dabdike>	 <53847364.7060900@redhat.com> <1401189970.14454.60.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbaE0Lwh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 07:52:37 -0400
In-Reply-To: <1401189970.14454.60.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

Il 27/05/2014 13:26, James Bottomley ha scritto:
>> You could use a different mechanism than a softirq to tell the abort
>> were successful, for example by overriding scsi_done.  But with respect
>> to the block layer, the mechanics of avoiding the race and double-free
>> would probably be the same.
>
> I think there's some confusion about what the race and double free is:
> It only occurs with timeouts.  In a timeout situation, the host had
> decided it's not waiting any longer for the target to respond and
> proceeds to error recovery.  At any time between the host making this
> decision up to the point it kicks the target hard enough to clear all
> in-flight commands, the target may return the command.  If we didn't
> have some ignore function on command completions while we're handling
> errors, this would lead to double completion.
>
> If we decided to allow arbitrary aborts of running commands, we would
> send a TMF in during the normal (i.e. un timed out) command period.
> Because there's no timeout involved, there's no double free problem.
> The race in this case is whether the abort catches the command or not
> and to mediate that race we need the normal status return.

I'm not sure why "no timeout" implies "no double free".  There would 
still be a race between the interrupt handler and softirq on one side, 
and the abort handler on the other.  The interrupt handler's call to 
cmd->scsi_done ends up triggering the softirq and thus freeing the 
command with scsi_put_command.  The abort handler, as you mentioned, 
wants the status return so it needs the interrupt handler to run---but 
not the softirq.

A simple way to avoid this could be to skip the softirq processing, by 
marking the request block-layer-complete, and do everything in the abort 
handler.  The interrupt handler would still run and fill in the status.

Paolo
