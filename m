From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: ABORT_TASK defined in aic94xx_sas.h
Date: Wed, 6 Feb 2008 12:15:43 -0800 (PST)
Message-ID: <842830.85180.qm@web31802.mail.mud.yahoo.com>
References: <47A9B859.6020208@panasas.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:31321 "HELO
	web31802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755580AbYBFUPo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 15:15:44 -0500
In-Reply-To: <47A9B859.6020208@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>, Boaz Harrosh <bharrosh@panasas.com>

--- On Wed, 2/6/08, Boaz Harrosh <bharrosh@panasas.com> wrote:
> include/scsi/scsi.h as a definition:
> #define ABORT_TASK          0x0d
> 
> on the other hand drivers/scsi/aic94xx/aic94xx_sas.h has:
> #define ABORT_TASK              0x03
> 
> am I right in thinking that aic94xx_sas.h is wrong in
> polluting the global name-space?
> 
> If you ask me aic94xx_sas.h is a global name-space
> minefield

LOL, "global name-space minefield" -- that's funny.

Yeah, I didn't think the aic94xx_sas.h would be
used the way it is (or that the SAS Stack would become
a "pimple" as opposed to a layer as originally defined).

In macro name definitions, I tried to stay as close
as possible to the specs of the chip.

Anyway, I ack this patch. See below.

(Maybe scsi.h::ABORT_TASK should go away for the better
defined scsi.h::TMF_ABORT_TASK.)

> 
> (This gives me problems when trying to pull in scsi_eh.h
> into
> aic94xx source files)
> 
> perhaps:
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Wed, 6 Feb 2008 15:35:37 +0200
> Subject: [PATCH] aic94xx_sas: avoid conflict with scsi.h
> 
>   drivers/scsi/aic94xx/aic94xx_sas.h would redefine
> ABORT_TASK
>   as a different value.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Luben Tuikov <ltuikov@yahoo.com>

   Luben


> ---
>  drivers/scsi/aic94xx/aic94xx_sas.h |    2 +-
>  drivers/scsi/aic94xx/aic94xx_tmf.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_sas.h
> b/drivers/scsi/aic94xx/aic94xx_sas.h
> index fa7c529..912e6b7 100644
> --- a/drivers/scsi/aic94xx/aic94xx_sas.h
> +++ b/drivers/scsi/aic94xx/aic94xx_sas.h
> @@ -292,7 +292,7 @@ struct scb_header {
>  #define INITIATE_SSP_TASK       0x00
>  #define INITIATE_LONG_SSP_TASK  0x01
>  #define INITIATE_BIDIR_SSP_TASK 0x02
> -#define ABORT_TASK              0x03
> +#define SCB_ABORT_TASK          0x03
>  #define INITIATE_SSP_TMF        0x04
>  #define SSP_TARG_GET_DATA       0x05
>  #define SSP_TARG_GET_DATA_GOOD  0x06
> diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c
> b/drivers/scsi/aic94xx/aic94xx_tmf.c
> index 87b2f6e..b52124f 100644
> --- a/drivers/scsi/aic94xx/aic94xx_tmf.c
> +++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
> @@ -369,7 +369,7 @@ int asd_abort_task(struct sas_task
> *task)
>  		return -ENOMEM;
>  	scb = ascb->scb;
>  
> -	scb->header.opcode = ABORT_TASK;
> +	scb->header.opcode = SCB_ABORT_TASK;
>  
>  	switch (task->task_proto) {
>  	case SAS_PROTOCOL_SATA:
> -- 
> 1.5.3.3
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
