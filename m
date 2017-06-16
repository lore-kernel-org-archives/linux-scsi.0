From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/11] Reduce time spent in IRQ for received NVME commands
Date: Fri, 16 Jun 2017 09:52:03 +0200
Message-ID: <66e64743-01da-5ef1-7e38-51e9266a4c42@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-5-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53463 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752375AbdFPHwG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 03:52:06 -0400
In-Reply-To: <20170616055651.9674-5-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> Removed unnecessary bzero of context area. Due to size of sg list,
> added a substantial delay and played havoc on cpu caches.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvmet.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index dba1bd216be3..431faa0a4f3e 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -205,7 +205,6 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
>  		sid = sli4_sid_from_fc_hdr(fc_hdr);
>  
>  		ctxp = (struct lpfc_nvmet_rcv_ctx *)ctx_buf->context;
> -		memset(ctxp, 0, sizeof(ctxp->ctx));
>  		ctxp->wqeq = NULL;
>  		ctxp->txrdy = NULL;
>  		ctxp->offset = 0;
> @@ -1422,7 +1421,6 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
>  				"6414 NVMET Context corrupt %d %d oxid x%x\n",
>  				ctxp->state, ctxp->entry_cnt, ctxp->oxid);
>  	}
> -	memset(ctxp, 0, sizeof(ctxp->ctx));
>  	ctxp->wqeq = NULL;
>  	ctxp->txrdy = NULL;
>  	ctxp->offset = 0;
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
