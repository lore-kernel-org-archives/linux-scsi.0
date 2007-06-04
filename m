From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] m68k: Atari SCSI driver update_timeout removal
Date: Mon, 4 Jun 2007 08:28:39 +0100
Message-ID: <20070604072839.GA15390@infradead.org>
References: <Pine.LNX.4.64.0706031250190.9351@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35057 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbXFDH2q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jun 2007 03:28:46 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706031250190.9351@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Sun, Jun 03, 2007 at 12:55:04PM +0200, Geert Uytterhoeven wrote:
> From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
> 
> Atari SCSI driver fixes: remove update_timeout kludge

Looks good. James, can you send this on for 2.6.22 so the accidentally
added cludge doesn't end up in any release version?

> Signed-off-by: Michael Schmitz <schmitz@debian.org>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
> This removes the timeout kludge in commit
> fb810d121bceb945c5e576356bccba11cbfad7e3 that was NAK'ed by Christoph.
> 
>  drivers/scsi/atari_NCR5380.c |   44 +------------------------------------------
>  1 file changed, 2 insertions(+), 42 deletions(-)
> 
> --- a/drivers/scsi/atari_NCR5380.c
> +++ b/drivers/scsi/atari_NCR5380.c
> @@ -894,45 +894,6 @@ static int NCR5380_init(struct Scsi_Host
>  }
>  
>  /*
> - * our own old-style timeout update
> - */
> -/*
> - * The strategy is to cause the timer code to call scsi_times_out()
> - * when the soonest timeout is pending.
> - * The arguments are used when we are queueing a new command, because
> - * we do not want to subtract the time used from this time, but when we
> - * set the timer, we want to take this value into account.
> - */
> -
> -int atari_scsi_update_timeout(Scsi_Cmnd * SCset, int timeout)
> -{
> -	int rtn;
> -
> -	/*
> -	 * We are using the new error handling code to actually register/deregister
> -	 * timers for timeout.
> -	 */
> -
> -	if (!timer_pending(&SCset->eh_timeout))
> -		rtn = 0;
> -	else
> -		rtn = SCset->eh_timeout.expires - jiffies;
> -
> -	if (timeout == 0) {
> -		del_timer(&SCset->eh_timeout);
> -		SCset->eh_timeout.data = (unsigned long)NULL;
> -		SCset->eh_timeout.expires = 0;
> -	} else {
> -		if (SCset->eh_timeout.data != (unsigned long)NULL)
> -			del_timer(&SCset->eh_timeout);
> -		SCset->eh_timeout.data = (unsigned long)SCset;
> -		SCset->eh_timeout.expires = jiffies + timeout;
> -		add_timer(&SCset->eh_timeout);
> -	}
> -	return rtn;
> -}
> -
> -/*
>   * Function : int NCR5380_queue_command (Scsi_Cmnd *cmd,
>   *	void (*done)(Scsi_Cmnd *))
>   *
> @@ -956,7 +917,6 @@ static int NCR5380_queue_command(Scsi_Cm
>  	Scsi_Cmnd *tmp;
>  	int oldto;
>  	unsigned long flags;
> -	// extern int update_timeout(Scsi_Cmnd * SCset, int timeout);
>  
>  #if (NDEBUG & NDEBUG_NO_WRITE)
>  	switch (cmd->cmnd[0]) {
> @@ -1029,9 +989,9 @@ static int NCR5380_queue_command(Scsi_Cm
>  	 * alter queues and touch the lock.
>  	 */
>  	if (!IS_A_TT()) {
> -		oldto = atari_scsi_update_timeout(cmd, 0);
> +		/* perhaps stop command timer here */
>  		falcon_get_lock();
> -		atari_scsi_update_timeout(cmd, oldto);
> +		/* perhaps restart command timer here */
>  	}
>  	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
>  		LIST(cmd, hostdata->issue_queue);
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
