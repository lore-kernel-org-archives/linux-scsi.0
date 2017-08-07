From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 01/20] lpfc: Fix plogi collision that causes illegal
 state transition
Date: Mon, 7 Aug 2017 09:49:20 +0200
Message-ID: <20170807074920.GE3978@linux-x5ow.site>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
 <20170805004731.1335-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37410 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752097AbdHGHtZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Aug 2017 03:49:25 -0400
Content-Disposition: inline
In-Reply-To: <20170805004731.1335-2-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Fri, Aug 04, 2017 at 05:47:12PM -0700, James Smart wrote:
> From: Dick Kennedy <dick.kennedy@broadcom.com>
> 
> Message "0271 Illegal State Transition: node" seen in logs, all
> luns are unuseable for that target.
> 
> A window exists in the rcv_plogi path where if the state is plogi
> issue but the driver has not issued a plogi, then two reglogins will
> be sent for the same RPI. The first one to complete will advance
> the state to prli issue the second one will be detected as an
> illegal state, and leave the node in an unusable state.
> 
> Correct the completion routine for the PLOGI ACC that detects the
> state change when the driver starts discovery on the node again
> and drop the REGLOGIN mailbox command.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 6d1d6f691df4..9e9aa8bb7001 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -3930,7 +3930,31 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>  	if (mbox) {
>  		if ((rspiocb->iocb.ulpStatus == 0)
>  		    && (ndlp->nlp_flag & NLP_ACC_REGLOGIN)) {
> -			lpfc_unreg_rpi(vport, ndlp);
> +			if (!lpfc_unreg_rpi(vport, ndlp)) {
> +				if (ndlp->nlp_state ==  NLP_STE_PLOGI_ISSUE ||
> +				    ndlp->nlp_state ==
> +				     NLP_STE_REG_LOGIN_ISSUE) {


			if (!lpfc_unreg_rpi(vport, ndlp) &&
			    (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
			     ndlp->nlp_state == NLP_STE_REG_LOGIN_ISSUE)) {

This saves you one level of indention and given that we already have two
before we reach the 'if' it's highly desirable.

> +					lpfc_printf_vlog(vport, KERN_INFO,
> +							 LOG_DISCOVERY,
> +							 "0314 PLOGI recov "
> +							 "DID x%x "
> +							 "Data: x%x x%x x%x\n",
> +							 ndlp->nlp_DID,
> +							 ndlp->nlp_state,
> +							 ndlp->nlp_rpi,
> +							 ndlp->nlp_flag);
> +					mp = (struct lpfc_dmabuf *)
> +					      mbox->context1;

No need for a cast.

Otherwise,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
