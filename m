From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Mon, 31 Mar 2014 18:41:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403311816040.5031-100000@netrider.rowland.org>
References: <1396278224.3152.26.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:56238 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750987AbaCaWlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 18:41:45 -0400
In-Reply-To: <1396278224.3152.26.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Mon, 31 Mar 2014, James Bottomley wrote:

> > The actual question is whether it's worth aborting the same command
> > a second time.
> > In principle any reset (like LUN reset etc) should clear the
> > command, too.
> > And the EH abort functionality is geared around this.
> > If, for some reason, the transport layer / device driver
> > requires a command abort to be send then sure, we need
> > to accommodate for that.
> 
> We already discussed this (that was my first response too).  USB needs
> all outstanding commands aborted before proceeding to reset.  I'm
> starting to think the actual way to fix this is to reset the abort
> scheduled only if we send something else, so this might be a better fix.
> 
> It doesn't matter if we finish a command with abort scheduled because
> the command then gets freed and the flags cleaned.
> 
> We can take our time with this because the other two patches, which I
> can send separately fix the current deadlock (we no longer send an
> unaborted request sense before the reset), and it can go via rc fixes.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 771c16b..3cfd2bf 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1007,6 +1007,12 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  	const unsigned long stall_for = msecs_to_jiffies(100);
>  	int rtn;
>  
> +	/*
> +	 * We're sending another command we'll need to abort, so reset the
> +	 * abort scheduled flag on the real command before we save its state
> +	 */
> +	scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> +
>  retry:
>  	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
>  	shost->eh_action = &done;

I don't know if Hannes will like this, but I don't think it is right.  
This is not the retry pathway that's causing problems; that pathway 
begins where scmd_eh_abort_handler() calls scsi_queue_insert().

Now, that call is already guarded by this test:

		if (... && (++scmd->retries <= scmd->allowed)) {

which would seem to prevent the infinite loop that Hannes was concerned 
about.  So maybe the 1/3 patch posted a couple of days ago is the best 
solution after all.

Alan Stern

