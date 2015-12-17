From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/17] lpfc: Make write check error processing more
 resilient
Date: Thu, 17 Dec 2015 09:26:53 +0100
Message-ID: <567271CD.6020501@suse.de>
References: <5671efc1.gThEwyunCl95KJV4%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbbLQI0z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:26:55 -0500
In-Reply-To: <5671efc1.gThEwyunCl95KJV4%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:12 AM, James Smart wrote:
>
> Make write check error processing more resilient.
>
> Checks to catch writes that fw reports weren't fully complete yet SCS=
I
> status indicated fine needed correction.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 27 +++++++++++++++++++++------
>   1 file changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_s=
csi.c
> index 3162469..b2414da 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3676,6 +3676,7 @@ static void
>   lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf =
*lpfc_cmd,
>   		    struct lpfc_iocbq *rsp_iocb)
>   {
> +	struct lpfc_hba *phba =3D vport->phba;
>   	struct scsi_cmnd *cmnd =3D lpfc_cmd->pCmd;
>   	struct fcp_cmnd *fcpcmd =3D lpfc_cmd->fcp_cmnd;
>   	struct fcp_rsp *fcprsp =3D lpfc_cmd->fcp_rsp;
> @@ -3685,6 +3686,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, s=
truct lpfc_scsi_buf *lpfc_cmd,
>   	uint32_t *lp;
>   	uint32_t host_status =3D DID_OK;
>   	uint32_t rsplen =3D 0;
> +	uint32_t fcpDl;
>   	uint32_t logit =3D LOG_FCP | LOG_FCP_ERROR;
>
>
> @@ -3755,13 +3757,14 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport,=
 struct lpfc_scsi_buf *lpfc_cmd,
>   			 fcprsp->rspInfo3);
>
>   	scsi_set_resid(cmnd, 0);
> +	fcpDl =3D be32_to_cpu(fcpcmd->fcpDl);
>   	if (resp_info & RESID_UNDER) {
>   		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
>
>   		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP_UNDER,
>   				 "9025 FCP Read Underrun, expected %d, "
>   				 "residual %d Data: x%x x%x x%x\n",
> -				 be32_to_cpu(fcpcmd->fcpDl),
> +				 fcpDl,
>   				 scsi_get_resid(cmnd), fcpi_parm, cmnd->cmnd[0],
>   				 cmnd->underflow);
>
> @@ -3777,7 +3780,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, s=
truct lpfc_scsi_buf *lpfc_cmd,
>   					 LOG_FCP | LOG_FCP_ERROR,
>   					 "9026 FCP Read Check Error "
>   					 "and Underrun Data: x%x x%x x%x x%x\n",
> -					 be32_to_cpu(fcpcmd->fcpDl),
> +					 fcpDl,
>   					 scsi_get_resid(cmnd), fcpi_parm,
>   					 cmnd->cmnd[0]);
>   			scsi_set_resid(cmnd, scsi_bufflen(cmnd));
> @@ -3812,13 +3815,25 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport,=
 struct lpfc_scsi_buf *lpfc_cmd,
>   	 * Check SLI validation that all the transfer was actually done
>   	 * (fcpi_parm should be zero). Apply check only to reads.
>   	 */
> -	} else if (fcpi_parm && (cmnd->sc_data_direction =3D=3D DMA_FROM_DE=
VICE)) {
> +	} else if (fcpi_parm) {
>   		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
> -				 "9029 FCP Read Check Error Data: "
> +				 "9029 FCP %s Check Error xri x%x  Data: "
>   				 "x%x x%x x%x x%x x%x\n",
> -				 be32_to_cpu(fcpcmd->fcpDl),
> -				 be32_to_cpu(fcprsp->rspResId),
> +				 ((cmnd->sc_data_direction =3D=3D DMA_FROM_DEVICE) ?
> +				 "Read" : "Write"),
> +				 ((phba->sli_rev =3D=3D LPFC_SLI_REV4) ?
> +				 lpfc_cmd->cur_iocbq.sli4_xritag :
> +				 rsp_iocb->iocb.ulpContext),
> +				 fcpDl, be32_to_cpu(fcprsp->rspResId),
>   				 fcpi_parm, cmnd->cmnd[0], scsi_status);
> +
> +		/* There is some issue with the LPe12000 that causes it
> +		 * to miscalculate the fcpi_parm and falsely trip this
> +		 * recovery logic.  Detect this case and don't error when true.
> +		 */
> +		if (fcpi_parm > fcpDl)
> +			goto out;
> +
>   		switch (scsi_status) {
>   		case SAM_STAT_GOOD:
>   		case SAM_STAT_CHECK_CONDITION:
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
