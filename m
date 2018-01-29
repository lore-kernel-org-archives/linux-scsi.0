From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/19] lpfc: correct debug counters for abort
Date: Mon, 29 Jan 2018 08:55:08 +0100
Message-ID: <a140ec11-1b81-fb4a-eed3-6c1d180db085@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-5-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751197AbeA2IN1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 03:13:27 -0500
In-Reply-To: <20180124224548.9530-5-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> Existing code was using the wrong field for the completion status
> when comparing whether to increment abort statistics
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index 8dbf5c9d51aa..7927ac46d345 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -130,7 +130,7 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
>  	if (tgtp) {
>  		if (status) {
>  			atomic_inc(&tgtp->xmt_ls_rsp_error);
> -			if (status == IOERR_ABORT_REQUESTED)
> +			if (result == IOERR_ABORT_REQUESTED)
>  				atomic_inc(&tgtp->xmt_ls_rsp_aborted);
>  			if (bf_get(lpfc_wcqe_c_xb, wcqe))
>  				atomic_inc(&tgtp->xmt_ls_rsp_xb_set);
> @@ -541,7 +541,7 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
>  		rsp->transferred_length = 0;
>  		if (tgtp) {
>  			atomic_inc(&tgtp->xmt_fcp_rsp_error);
> -			if (status == IOERR_ABORT_REQUESTED)
> +			if (result == IOERR_ABORT_REQUESTED)
>  				atomic_inc(&tgtp->xmt_fcp_rsp_aborted);
>  		}
>  
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
