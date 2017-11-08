From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/17] lpfc: Fix NVME LS abort_xri
Date: Wed, 8 Nov 2017 10:24:34 +0100
Message-ID: <3a975bc9-bcdd-dbc8-40f8-a8fea1215ae6@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-6-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57461 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbdKHJYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 04:24:35 -0500
In-Reply-To: <20171103225628.24716-6-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/03/2017 11:56 PM, James Smart wrote:
> performing an LS abort results in the following message being seen:
>   0603 Invalid CQ subtype 6: 00000300 22000002 ffff0016 d0050000
> and the associated exchange is not properly freed.
> 
> The code did not recognize the exchange type that was aborted, thus
> it was not properly handled.
> 
> Correct by adding the NVME LS ELS type to the exchange types that
> are recognized.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index ba6f0619433c..1229f58bdd09 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -12807,6 +12807,7 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
>  		spin_unlock_irqrestore(&phba->hbalock, iflags);
>  		workposted = true;
>  		break;
> +	case LPFC_NVME_LS: /* NVME LS uses ELS resources */
>  	case LPFC_ELS:
>  		cq_event = lpfc_cq_event_setup(
>  			phba, wcqe, sizeof(struct sli4_wcqe_xri_aborted));
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
