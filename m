From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 4/6] st: call scsi_set_medium_removal directly
Date: Thu, 6 Nov 2014 23:54:41 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959378554@G4W3202.americas.hpqcorp.net>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
 <1414661229-15199-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:52057 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaKFX4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 18:56:00 -0500
In-Reply-To: <1414661229-15199-5-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Thursday, 30 October, 2014 4:27 AM
> To: linux-scsi@vger.kernel.org
> Cc: Douglas Gilbert; Elliott, Robert (Server Storage)
> Subject: [PATCH 4/6] st: call scsi_set_medium_removal directly
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/st.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 7d2e036..e46e02b2 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -861,17 +861,16 @@ static int set_mode_densblk(struct scsi_tape *
> STp, struct st_modedef * STm)
>  /* Lock or unlock the drive door. Don't use when st_request
> allocated. */
>  static int do_door_lock(struct scsi_tape * STp, int do_lock)
>  {
> -	int retval, cmd;
> +	int retval;
> 
> -	cmd = do_lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK;
>  	DEBC_printk(STp, "%socking drive door.\n", do_lock ? "L" :
> "Unl");
> -	retval = scsi_ioctl(STp->device, cmd, NULL);
> -	if (!retval) {
> +
> +	retval = scsi_set_medium_removal(STp->device,
> +			do_lock ? SCSI_REMOVAL_PREVENT :
> SCSI_REMOVAL_ALLOW);
> +	if (!retval)
>  		STp->door_locked = do_lock ? ST_LOCKED_EXPLICIT :
> ST_UNLOCKED;
> -	}
> -	else {
> +	else
>  		STp->door_locked = ST_LOCK_FAILS;
> -	}
>  	return retval;
>  }

Reviewed-by: Robert Elliott <elliott@hp.com>

A few comments spawned by this (and patch 5/6):

1. Although PREVENT ALLOW MEDIUM REMOVAL was a generic
command defined in SPC-2, In 2006 T10 proposal
06-248r1 changed it to be a command-set specific 
command for SPC-3.  MMC, SSC, SBC, and SMC had slight
differences and the groups wouldn't agree on a converged
definition.

For example:
* SSC and SBC only define two of the bit combinations 
  in byte 4 bits 1:0 - allowed and prevented
* MMC defines all four combinations of byte 4 bits 1:0 -
  unlocked, locked, persistent allow, and persistent prevent
* SMC follows SSC/SBC but adds a PREEMPT bit in 
  byte 4 bit 7

So, relying on one SCSI-wide scsi_set_medium_removal
call could theoretically be a problem (though not yet,
since none of those extra features are used).


2. Reviewing the callers for scsi_set_medium_removal,
I noticed sd.c sd_release ignores the return value 
from scsi_set_medium_removal (like many others).

Its comment says:
*      Returns 0.
but it is a void function so doesn't really return anything:
static void sd_release(struct gendisk *disk, fmode_t mode)


3. Reviewing the callers, st_release has an initialized
result variable but does nothing else with it but return it:
	int result = 0;
	...
	return result;

It ignores the do_door_lock -> scsi_set_medium_removal
result (like many others).

---
Rob Elliott    HP Server Storage







