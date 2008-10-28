From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 04/22] libata-sff: clear IRQ from ata_sff_error_handler()
 only when necessary
Date: Tue, 28 Oct 2008 00:10:52 -0400
Message-ID: <490690CC.50500@garzik.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <1224580680-13698-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40088 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYJ1EK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2008 00:10:56 -0400
In-Reply-To: <1224580680-13698-5-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Clearing IRQ from ata_sff_error_handler() is necessary only when the
> port is gonna be thawed before performing EH actions and some
> controllers don't like being accessed after certain fail modes until
> they're reset.  Clear IRQ iff the port is being thawed.  Also, remove
> unnecessary ata_sff_sync() while at it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/ata/libata-sff.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 4b47394..b9fb068 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -2119,11 +2119,13 @@ void ata_sff_error_handler(struct ata_port *ap)
>  		}
>  
>  		ap->ops->bmdma_stop(qc);
> -	}
>  
> -	ata_sff_sync(ap);		/* FIXME: We don't need this */
> -	ap->ops->sff_check_status(ap);
> -	ap->ops->sff_irq_clear(ap);
> +		/* if we're gonna thaw, make sure IRQ is clear */
> +		if (thaw) {
> +			ap->ops->sff_check_status(ap);
> +			ap->ops->sff_irq_clear(ap);
> +		}
> +	}

I'll allow it, but, this description is not strictly true.  This 
clearing was done in the error handler unconditionally in an attempt to 
catch outstanding conditions.  The logic being that it is safer (FSVO 
safe) to clear on error just in case interrupts were screaming.

	Jeff




