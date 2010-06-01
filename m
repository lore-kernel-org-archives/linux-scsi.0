From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] scsi_error: blank out reservation conflict printk
Date: Tue, 01 Jun 2010 02:24:57 -0700
Message-ID: <1275384297.22825.13.camel@haakon2.linux-iscsi.org>
References: <20100601091918.890EB2A3AD@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:43592 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752096Ab0FAJY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 05:24:58 -0400
In-Reply-To: <20100601091918.890EB2A3AD@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Tue, 2010-06-01 at 11:19 +0200, Hannes Reinecke wrote:
> When using SCSI reservations a 'reservation conflict' error
> is actually expected. So we should better use the normal
> SCSI_LOG_XXX functions to make it configurable for those
> cases where we're actually interested in the error.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a5d630f..def540d 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1509,8 +1509,8 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>  		return SUCCESS;
>  
>  	case RESERVATION_CONFLICT:
> -		sdev_printk(KERN_INFO, scmd->device,
> -			    "reservation conflict\n");
> +		SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, scmd->device,
> +						"reservation conflict\n"));
>  		return SUCCESS; /* causes immediate i/o error */
>  	default:
>  		return FAILED;

Makes perfect sense to me.

:-)

Acked-by: Nicholas A. Bellinger <nab@linux-iscsi.org>


