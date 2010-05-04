From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] Retry commands with UNIT_ATTENTION sense codes
Date: Tue, 04 May 2010 12:26:43 -0400
Message-ID: <1272990403.5255.27.camel@mulgrave.site>
References: <20100504144853.D94C72A205@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759743Ab0EDQ0r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 12:26:47 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id B4B6189B67
	for <linux-scsi@vger.kernel.org>; Tue,  4 May 2010 18:26:46 +0200 (CEST)
In-Reply-To: <20100504144853.D94C72A205@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-05-04 at 16:48 +0200, Hannes Reinecke wrote:
> We have to enable retries for UNIT_ATTENTION sense codes, as a
> command might've been injected from the block layer (eg barrier
> requests). And for those no error recovers takes place, so we
> need to make sure that the SCSI midlayer corrects any transient
> errors.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index d45c69c..663a1ad 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -290,19 +290,13 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  			return NEEDS_RETRY;
>  		}
>  		/*
> -		 * if the device is in the process of becoming ready, we 
> -		 * should retry.
> -		 */
> -		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
> -			return NEEDS_RETRY;
> -		/*
>  		 * if the device is not started, we need to wake
>  		 * the error handler to start the motor
>  		 */
>  		if (scmd->device->allow_restart &&
>  		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
>  			return FAILED;
> -		return SUCCESS;
> +		return NEEDS_RETRY;
>  
>  		/* these three are not supported */
>  	case COPY_ABORTED:

The other patch is fine, but I don't think this is necessary.  The
reason is that even returning SUCCESS here, we go straight into
scsi_finish_command() (which passes it up to the driver handler) and
then scsi_io_completion().  There's a catch for UNIT_ATTENTION in
scsi_io_completion which will still cause a retry provided the driver
handler hasn't done any alterations, so I think we'd still get the retry
with only your other patch.

James


