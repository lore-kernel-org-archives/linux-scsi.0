From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] lpfc: fix memory leak and NULL dereference
Date: Thu, 8 Oct 2015 19:50:05 +0530
Message-ID: <20151008142005.GB10587@sudip-pc>
References: <1443015152-12301-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443015152-12301-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 23, 2015 at 07:02:32PM +0530, Sudip Mukherjee wrote:
> kmalloc() can return NULL and without checking we were dereferencing it.
> Moreover if kmalloc succeeds but the function fails in other parts then
> we were returning the error code but we missed freeing lcb_context.
> While at it fixed one related checkpatch warning.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---

A gentle ping.

regards
sudip

> 
> I am not exactly sure if LSRJT_UNABLE_TPC is the right error code here.
> But that was my best guess.
> 
>  drivers/scsi/lpfc/lpfc_els.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 36bf58b..a27efd9 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -5209,7 +5209,6 @@ lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>  		rjt_err = LSRJT_CMD_UNSUPPORTED;
>  		goto rjt;
>  	}
> -	lcb_context = kmalloc(sizeof(struct lpfc_lcb_context), GFP_KERNEL);
>  
>  	if (phba->hba_flag & HBA_FCOE_MODE) {
>  		rjt_err = LSRJT_CMD_UNSUPPORTED;
> @@ -5240,6 +5239,12 @@ lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>  		goto rjt;
>  	}
>  
> +	lcb_context = kmalloc(sizeof(*lcb_context), GFP_KERNEL);
> +	if (!lcb_context) {
> +		rjt_err = LSRJT_UNABLE_TPC;
> +		goto rjt;
> +	}
> +
>  	state = (beacon->lcb_sub_command == LPFC_LCB_ON) ? 1 : 0;
>  	lcb_context->sub_command = beacon->lcb_sub_command;
>  	lcb_context->type = beacon->lcb_type;
> @@ -5250,6 +5255,7 @@ lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>  	if (lpfc_sli4_set_beacon(vport, lcb_context, state)) {
>  		lpfc_printf_vlog(ndlp->vport, KERN_ERR,
>  				 LOG_ELS, "0193 failed to send mail box");
> +		kfree(lcb_context);
>  		lpfc_nlp_put(ndlp);
>  		rjt_err = LSRJT_UNABLE_TPC;
>  		goto rjt;
> -- 
> 1.9.1
> 
