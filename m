From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/17] lpfc: Fix RegLogin failed error seen on Lancer FC
 during port bounce
Date: Thu, 17 Dec 2015 09:16:42 +0100
Message-ID: <56726F6A.1000800@suse.de>
References: <5671efbb.hZSIh/wq1cqxxyH9%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbbLQIQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:16:44 -0500
In-Reply-To: <5671efbb.hZSIh/wq1cqxxyH9%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:11 AM, James Smart wrote:
>
> Fix RegLogin failed error seen on Lancer FC during port bounce
>
> Fix the statemachine and ref counting.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c       | 14 +++++++++-----
>   drivers/scsi/lpfc/lpfc_hbadisc.c   |  8 ++++----
>   drivers/scsi/lpfc/lpfc_nportdisc.c |  3 +++
>   3 files changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_el=
s.c
> index f6dd15b..d508378 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -3779,14 +3779,17 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, stru=
ct lpfc_iocbq *cmdiocb,
>   				lpfc_nlp_set_state(vport, ndlp,
>   					   NLP_STE_REG_LOGIN_ISSUE);
>   			}
> +
> +			ndlp->nlp_flag |=3D NLP_REG_LOGIN_SEND;
>   			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
>   			    !=3D MBX_NOT_FINISHED)
>   				goto out;
> -			else
> -				/* Decrement the ndlp reference count we
> -				 * set for this failed mailbox command.
> -				 */
> -				lpfc_nlp_put(ndlp);
> +
> +			/* Decrement the ndlp reference count we
> +			 * set for this failed mailbox command.
> +			 */
> +			lpfc_nlp_put(ndlp);
> +			ndlp->nlp_flag &=3D ~NLP_REG_LOGIN_SEND;
>
>   			/* ELS rsp: Cannot issue reg_login for <NPortid> */
>   			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
> @@ -3843,6 +3846,7 @@ out:
>   				 * the routine lpfc_els_free_iocb.
>   				 */
>   				cmdiocb->context1 =3D NULL;
> +
>   	}
>
>   	lpfc_els_free_iocb(phba, cmdiocb);
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpf=
c_hbadisc.c
> index f0777f2..b19237b 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -3452,10 +3452,10 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba=
, LPFC_MBOXQ_t *pmb)
>   		spin_lock_irq(shost->host_lock);
>   		ndlp->nlp_flag &=3D ~NLP_IGNR_REG_CMPL;
>   		spin_unlock_irq(shost->host_lock);
> -	} else
> -		/* Good status, call state machine */
> -		lpfc_disc_state_machine(vport, ndlp, pmb,
> -				NLP_EVT_CMPL_REG_LOGIN);
> +	}
> +
> +	/* Call state machine */
> +	lpfc_disc_state_machine(vport, ndlp, pmb, NLP_EVT_CMPL_REG_LOGIN);
>
>   	lpfc_mbuf_free(phba, mp->virt, mp->phys);
>   	kfree(mp);
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/l=
pfc_nportdisc.c
> index daeda6d..9e571dd 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -2325,6 +2325,9 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_vport *=
vport,
>   		if (vport->phba->sli_rev < LPFC_SLI_REV4)
>   			ndlp->nlp_rpi =3D mb->un.varWords[0];
>   		ndlp->nlp_flag |=3D NLP_RPI_REGISTERED;
> +		if (ndlp->nlp_flag & NLP_LOGO_ACC) {
> +			lpfc_unreg_rpi(vport, ndlp);
> +		}
>   	} else {
>   		if (ndlp->nlp_flag & NLP_NODEV_REMOVE) {
>   			lpfc_drop_node(vport, ndlp);
>
Not sure if that belong into this patch, but let's not be picky here.

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
