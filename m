From: "Loke, Chetan" <Chetan.Loke@netscout.com>
Subject: RE: [PATCH 1/1] qla2xxx: Micro optimization in queuecommand handler
Date: Wed, 22 Feb 2012 11:51:06 -0500
Message-ID: <D3F292ADF945FB49B35E96C94C2061B915FD62A2@nsmail.netscout.com>
References: <1329230866-905-1-git-send-email-loke.chetan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod6og117.obsmtp.com ([64.18.1.39]:39526 "HELO
	exprod6og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754157Ab2BVQvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 11:51:09 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1329230866-905-1-git-send-email-loke.chetan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com
Cc: linux-driver@qlogic.com, lokechetan@gmail.com

> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Chetan Loke
> Sent: February 14, 2012 9:48 AM
> To: JBottomley@parallels.com; linux-scsi@vger.kernel.org;
> andrew.vasquez@qlogic.com
> Cc: linux-driver@qlogic.com; loke.chetan@gmail.com
> Subject: [PATCH 1/1] qla2xxx: Micro optimization in queuecommand
> handler
> 
> Optimized queuecommand handler's to eliminate double head-room checks.
> The checks are moved inside the 1st if-loop otherwise you would end up
> checking twice when there is enough head room.
> 
> Signed-off-by: Chetan Loke <loke.chetan@gmail.com>
> ---

Ping...





>  drivers/scsi/qla2xxx/qla_iocb.c |   19 +++++++++----------
>  1 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
> b/drivers/scsi/qla2xxx/qla_iocb.c
> index 55a9676..825a046 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -383,9 +383,10 @@ qla2x00_start_scsi(srb_t *sp)
>  		else
>  			req->cnt = req->length -
>  			    (req->ring_index - cnt);
> +		/* If still no head room then bail out */
> +		if (req->cnt < (req_cnt + 2))
> +			goto queuing_error;
>  	}
> -	if (req->cnt < (req_cnt + 2))
> -		goto queuing_error;
> 
>  	/* Build command packet */
>  	req->current_outstanding_cmd = handle;
> @@ -1502,9 +1503,9 @@ qla24xx_start_scsi(srb_t *sp)
>  		else
>  			req->cnt = req->length -
>  				(req->ring_index - cnt);
> +		if (req->cnt < (req_cnt + 2))
> +			goto queuing_error;
>  	}
> -	if (req->cnt < (req_cnt + 2))
> -		goto queuing_error;
> 
>  	/* Build command packet. */
>  	req->current_outstanding_cmd = handle;
> @@ -1717,11 +1718,10 @@ qla24xx_dif_start_scsi(srb_t *sp)
>  		else
>  			req->cnt = req->length -
>  				(req->ring_index - cnt);
> +		if (req->cnt < (req_cnt + 2))
> +			goto queuing_error;
>  	}
> 
> -	if (req->cnt < (req_cnt + 2))
> -		goto queuing_error;
> -
>  	status |= QDSS_GOT_Q_SPACE;
> 
>  	/* Build header part of command packet (excluding the OPCODE).
*/
> @@ -2349,11 +2349,10 @@ sufficient_dsds:
>  			else
>  				req->cnt = req->length -
>  					(req->ring_index - cnt);
> +			if (req->cnt < (req_cnt + 2))
> +				goto queuing_error;
>  		}
> 
> -		if (req->cnt < (req_cnt + 2))
> -			goto queuing_error;
> -
>  		ctx = sp->ctx = mempool_alloc(ha->ctx_mempool,
GFP_ATOMIC);
>  		if (!sp->ctx) {
>  			ql_log(ql_log_fatal, vha, 0x3010,
> --
> 1.7.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
