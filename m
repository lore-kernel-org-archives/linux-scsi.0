From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi: qedf: Fix a potential NULL pointer dereference
Date: Wed, 23 Aug 2017 11:49:34 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1708231148580.1209@n6024mn55p0yw1.qlogic.org>
References: <20170820170935.14767-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0083.outbound.protection.outlook.com ([104.47.34.83]:43648
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754150AbdHWPt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 11:49:58 -0400
In-Reply-To: <20170820170935.14767-1-christophe.jaillet@wanadoo.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


On Sun, 20 Aug 2017, 1:09pm, Christophe JAILLET wrote:

> At the beginning of 'qedf_srr_compl()' and of 'qedf_rec_compl()', we check
> if 'orig_io_req' is NULL. If this happens, a NULL pointer dereference will
> occur in the error handling path.
> 
> Fix it by adding an additionnal label in the error handling path in order
> to avoid this NULL pointer dereference.
> 
> Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/qedf/qedf_els.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
> index eb07f1de8afa..59c18ca4cda9 100644
> --- a/drivers/scsi/qedf/qedf_els.c
> +++ b/drivers/scsi/qedf/qedf_els.c
> @@ -489,7 +489,7 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
>  
>  	/* If a SRR times out, simply free resources */
>  	if (srr_req->event == QEDF_IOREQ_EV_ELS_TMO)
> -		goto out_free;
> +		goto out_put;
>  
>  	/* Normalize response data into struct fc_frame */
>  	mp_req = &(srr_req->mp_req);
> @@ -501,7 +501,7 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
>  	if (!fp) {
>  		QEDF_ERR(&(qedf->dbg_ctx),
>  		    "fc_frame_alloc failure.\n");
> -		goto out_free;
> +		goto out_put;
>  	}
>  
>  	/* Copy frame header from firmware into fp */
> @@ -526,9 +526,10 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
>  	}
>  
>  	fc_frame_free(fp);
> -out_free:
> +out_put:
>  	/* Put reference for original command since SRR completed */
>  	kref_put(&orig_io_req->refcount, qedf_release_cmd);
> +out_free:
>  	kfree(cb_arg);
>  }
>  
> @@ -780,7 +781,7 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
>  
>  	/* If a REC times out, free resources */
>  	if (rec_req->event == QEDF_IOREQ_EV_ELS_TMO)
> -		goto out_free;
> +		goto out_put;
>  
>  	/* Normalize response data into struct fc_frame */
>  	mp_req = &(rec_req->mp_req);
> @@ -792,7 +793,7 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
>  	if (!fp) {
>  		QEDF_ERR(&(qedf->dbg_ctx),
>  		    "fc_frame_alloc failure.\n");
> -		goto out_free;
> +		goto out_put;
>  	}
>  
>  	/* Copy frame header from firmware into fp */
> @@ -884,9 +885,10 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
>  
>  out_free_frame:
>  	fc_frame_free(fp);
> -out_free:
> +out_put:
>  	/* Put reference for original command since REC completed */
>  	kref_put(&orig_io_req->refcount, qedf_release_cmd);
> +out_free:
>  	kfree(cb_arg);
>  }
>  
> 

Thanks for the catch.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
