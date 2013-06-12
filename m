From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Wed, 12 Jun 2013 08:34:45 +0200
Message-ID: <51B81685.7020204@acm.org>
References: <1370850058-27613-1-git-send-email-hare@suse.de>  <1370850058-27613-4-git-send-email-hare@suse.de>  <20130610082001.GB7816@infradead.org> <1370977067.2286.81.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:60441 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3FLGet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 02:34:49 -0400
In-Reply-To: <1370977067.2286.81.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On 06/11/13 20:57, James Bottomley wrote:
> Actually, I think we can dump the workqueue altogether.  The only reason
> we need it is because the current abort handlers wait for the command
> and return the completion state.  However, all LLDs are capable of
> emitting TMFs at interrupt level, so if we separated the emit from the
> wait, we could simply do this sequence:
>
> on timeout, fire the abort from interrupt and mark the command as having
> an abort issued (possibly by adding a pointer to the abort task), return
> BLK_EH_RESET_TIMER.
>
> Now if the timeout fires again, assume the abort was unsuccessful and
> escalate to LUN reset.
>
> This is fully asynchronous, fully tracked and doesn't rely on work
> queues.
>
> The necessary additions for something like this are the from interrupt
> issue abort and LUN reset, which could just be additional callbacks in
> the host template.

Do we really need a new callback in the host template for a command 
abort that does not wait ? Several LLDs already have their own internal 
data structures for keeping track of the request state and can use these 
data structures to set a flag "command has been aborted". If aborting a 
command fails and the command completes that flag can then be used to 
avoid a second invocation of scsi_done(). At least, that's what the SRP 
initiator already does today in srp_abort().

Bart.

