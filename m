From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] make error handling robust in the face of reservations
Date: Fri, 6 Aug 2010 14:56:55 -0600
Message-ID: <20100806205655.GM27935@parisc-linux.org>
References: <1281125844.6245.109.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51106 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961Ab0HFU45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2010 16:56:57 -0400
Content-Disposition: inline
In-Reply-To: <1281125844.6245.109.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Aug 06, 2010 at 03:17:24PM -0500, James Bottomley wrote:
> There's a curious case where devices in clusters are offlining if they
> go into error handling.  The reason is that in this particular cluster,
> Test Unit Ready gets a RESERVATION CONFLICT return when another node
> owns the storage.  This means that all TURs that error handling use are
> marked failed, so we always assume the device is unrecoverable and take
> it offline.
> 
> Fix this by checking in the error handling code processing returns to
> see if the command was a TUR and translate the EH return to SUCCESS
> (after all, if the target managed to return RESERVATION CONFLICT, we've
> successfully made contact with it).

Um, the patch doesn't match the description.  According to the code,
we were unconditionally returning SUCCESS before.  Now we fail everythng
except TUR.  Was there another part to this patch, or is the description
bonkers?

> ---
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 2bf9846..5e2d36f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -473,10 +473,12 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
>  		 */
>  		return SUCCESS;
>  	case RESERVATION_CONFLICT:
> -		/*
> -		 * let issuer deal with this, it could be just fine
> -		 */
> -		return SUCCESS;
> +		if (scmd->cmnd[0] == TEST_UNIT_READY)
> +			/* it is a success, we probed the device and
> +			 * found it */
> +			return SUCCESS;
> +		/* otherwise, we failed to send the command */
> +		return FAILED;
>  	case QUEUE_FULL:
>  		scsi_handle_queue_full(scmd->device);
>  		/* fall through */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
