From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: aic94xx: fix sequencer hang on error recovery
Date: Sat, 23 Feb 2008 17:01:28 -0800 (PST)
Message-ID: <772867.72279.qm@web31815.mail.mud.yahoo.com>
References: <1203721319.6206.77.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31815.mail.mud.yahoo.com ([68.142.206.168]:23290 "HELO
	web31815.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752862AbYBXBB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2008 20:01:29 -0500
In-Reply-To: <1203721319.6206.77.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

--- On Fri, 2/22/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> The clear nexus I_T and clear nexus I_T_L functions in the
> aic94xx
> specify the SUSPEND_TX flag which causes the sequencer to
> be suspended
> until it receives a RESUME_TX.  Unfortunately, nothing ever
> sends the
> resume, so the sequencer on the link is stopped forever,
> leading to
> eventual timeouts and I/O errors.
> 
> Since clear nexus commands are only executed as part of
> error recovery,
> it's perfectly fine to keep the sequencer running on
> the link ... as
> soon as the recovery function is completed, we'll send
> it the commands
> to retry.

No, this doesn't seem right.

   Luben

> Signed-off-by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> 
> ---
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c
> b/drivers/scsi/aic94xx/aic94xx_tmf.c
> index b52124f..144f5ad 100644
> --- a/drivers/scsi/aic94xx/aic94xx_tmf.c
> +++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
> @@ -151,8 +151,6 @@ static int asd_clear_nexus_I_T(struct
> domain_device *dev)
>  	CLEAR_NEXUS_PRE;
>  	scb->clear_nexus.nexus = NEXUS_I_T;
>  	scb->clear_nexus.flags = SEND_Q | EXEC_Q | NOTINQ;
> -	if (dev->tproto)
> -		scb->clear_nexus.flags |= SUSPEND_TX;
>  	scb->clear_nexus.conn_handle =
> cpu_to_le16((u16)(unsigned long)
>  						   dev->lldd_dev);
>  	CLEAR_NEXUS_POST;
> @@ -169,8 +167,6 @@ static int asd_clear_nexus_I_T_L(struct
> domain_device *dev, u8 *lun)
>  	CLEAR_NEXUS_PRE;
>  	scb->clear_nexus.nexus = NEXUS_I_T_L;
>  	scb->clear_nexus.flags = SEND_Q | EXEC_Q | NOTINQ;
> -	if (dev->tproto)
> -		scb->clear_nexus.flags |= SUSPEND_TX;
>  	memcpy(scb->clear_nexus.ssp_task.lun, lun, 8);
>  	scb->clear_nexus.conn_handle =
> cpu_to_le16((u16)(unsigned long)
>  						   dev->lldd_dev);
> 
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
