From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 5/6] osst: call scsi_set_medium_removal directly
Date: Fri, 7 Nov 2014 00:01:09 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959378572@G4W3202.americas.hpqcorp.net>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
 <1414661229-15199-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:21997 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKGACZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 19:02:25 -0500
In-Reply-To: <1414661229-15199-6-git-send-email-hch@lst.de>
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
> Subject: [PATCH 5/6] osst: call scsi_set_medium_removal directly
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/osst.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
> index b6d63d6..8c38464 100644
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -3327,19 +3327,18 @@ static int osst_write_frame(struct osst_tape
> * STp, struct osst_request ** aSRpn
>  /* Lock or unlock the drive door. Don't use when struct osst_request
> allocated. */
>  static int do_door_lock(struct osst_tape * STp, int do_lock)
>  {
> -	int retval, cmd;
> +	int retval;
> 
> -	cmd = do_lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK;
>  #if DEBUG
>  	printk(OSST_DEB_MSG "%s:D: %socking drive door.\n",
> tape_name(STp), do_lock ? "L" : "Unl");
>  #endif
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
> 

Reviewed-by: Robert Elliott <elliott@hp.com>

One additional nit (not necessary):
The do_lock argument could be bool rather than int both 
here and in st.c.


---
Rob Elliott    HP Server Storage



