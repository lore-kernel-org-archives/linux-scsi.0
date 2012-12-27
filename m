From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] a100u2w: Added sanitization for pointer dereference
 using a value from hardware. Detected using Carburizer
 (http://lwn.net/Articles/479653/)
Date: Thu, 27 Dec 2012 11:25:03 +0000
Message-ID: <1356607503.2306.20.camel@dabdike>
References: <159925B4-EEAA-441E-8A8E-666DCA702D5B@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45990 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046Ab2L0LZK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Dec 2012 06:25:10 -0500
In-Reply-To: <159925B4-EEAA-441E-8A8E-666DCA702D5B@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Asim Kadav <kadav@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, 2012-12-27 at 02:59 -0600, Asim Kadav wrote:
> Signed-off-by: Asim Kadav <kadav@cs.wisc.edu>
> ---
>  drivers/scsi/a100u2w.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
> index 0163457..c2ca15c 100644
> --- a/drivers/scsi/a100u2w.c
> +++ b/drivers/scsi/a100u2w.c
> @@ -821,6 +821,9 @@ static irqreturn_t orc_interrupt(struct orc_host * host)
>  		/* Get the SCB index of the SCB to service */
>  		scb_index = inb(host->base + ORC_RQUEUE);
>  
> +		/* Sanitize incoming index */
> +		scb_index &= 31;
> +

If your theory is that the hardware just returned a bogus value, this
isn't the right way to sanitise it because the chances are you'll
complete the wrong command and cause corruption: you'd have to halt the
entire system at that point.  Also, I don't understand why you think the
value should only be 0-31?  The size of variable allocated there is for
SCBs up to 243, no idea why, since some of the allocation routines will
search up to 256.  However, safety from overrun should be guaranteed at
least at the system level by the can_queue value.

Double checking hardware values isn't something we habitually do unless
there's a known reason for it (like the state machine does throw bogus
values with a defined recovery procedure).  We definitely don't run in
the mode where you can't trust your hardware.

James


