From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 1/9] lpfc: Check for active portpeerbeacon.
Date: Sun, 24 May 2015 21:50:01 +0200
Message-ID: <20150524215001.00003bac@localhost>
References: <555f405b.edV1AAZPf7ciBGhe%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60149 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbbEXTuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 15:50:05 -0400
In-Reply-To: <555f405b.edV1AAZPf7ciBGhe%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Check for active portpeerbeacon.
> 
> LCB requests to set Beacon would fail if the beacon was already enabled

beacon

> internally as the mailbox command used to query the state failes with

fails

> an already-set status.
> 
> Correct by enhancing the check so we don't fail if if the already set

if twice

> status comes back.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 19 +++++++++++++++----
>  drivers/scsi/lpfc/lpfc_hw4.h |  6 ++++++
>  2 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 011c8d8..3aad09f 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -5044,25 +5044,36 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
>  	struct lpfc_iocbq *elsiocb;
>  	struct lpfc_nodelist *ndlp;
>  	struct ls_rjt *stat;
> +	union lpfc_sli4_cfg_shdr *shdr;
>  	struct lpfc_lcb_context *lcb_context;
>  	struct fc_lcb_res_frame *lcb_res;
> -	uint32_t cmdsize;
> +	uint32_t cmdsize, shdr_status, shdr_add_status;
>  	int rc;
>  
>  	mb = &pmb->u.mb;
> -
>  	lcb_context = (struct lpfc_lcb_context *)pmb->context1;
>  	ndlp = lcb_context->ndlp;
>  	pmb->context1 = NULL;
>  	pmb->context2 = NULL;
>  
> -	if (mb->mbxStatus) {
> +	shdr = (union lpfc_sli4_cfg_shdr *)
> +			&pmb->u.mqe.un.beacon_config.header.cfg_shdr;
> +	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
> +	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
> +
> +	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX,
> +				"0194 SET_BEACON_CONFIG mailbox "
> +				"completed with status x%x add_status x%x,"
> +				" mbx status x%x\n",
> +				shdr_status, shdr_add_status, mb->mbxStatus);

checkpatch suggests to not split this user-visible string.

Sebastian
