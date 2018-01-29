From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/19] lpfc: Indicate CONF support in NVMe PRLI
Date: Mon, 29 Jan 2018 09:28:18 +0100
Message-ID: <87d3690f-70d1-8d77-4219-68cc30dffff4@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-13-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43363 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751809AbeA2LXv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 06:23:51 -0500
In-Reply-To: <20180124224548.9530-13-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> Revise the NVME PRLI to indicate CONF support.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c       | 3 ++-
>  drivers/scsi/lpfc/lpfc_hw4.h       | 6 +++---
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 3 ---
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 234c7c015982..404e1af5e2ab 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -2293,10 +2293,11 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>  		if (phba->nvmet_support) {
>  			bf_set(prli_tgt, npr_nvme, 1);
>  			bf_set(prli_disc, npr_nvme, 1);
> -
>  		} else {
>  			bf_set(prli_init, npr_nvme, 1);
> +			bf_set(prli_conf, npr_nvme, 1);
>  		}
> +
>  		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
>  		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
>  		elsiocb->iocb_flag |= LPFC_PRLI_NVME_REQ;
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index ef469129fb71..7c3afc3d3121 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -4346,9 +4346,9 @@ struct lpfc_nvme_prli {
>  #define prli_init_SHIFT                 5
>  #define prli_init_MASK                  0x00000001
>  #define prli_init_WORD                  word4
> -#define prli_recov_SHIFT                8
> -#define prli_recov_MASK                 0x00000001
> -#define prli_recov_WORD                 word4
> +#define prli_conf_SHIFT                 7
> +#define prli_conf_MASK                  0x00000001
> +#define prli_conf_WORD                  word4
>  	uint32_t word5;
>  #define prli_fb_sz_SHIFT                0
>  #define prli_fb_sz_MASK                 0x0000ffff
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
> index d841aa42f607..bbf1e1342b09 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -2011,9 +2011,6 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>  			}
>  		}
>  
> -		if (bf_get_be32(prli_recov, nvpr))
> -			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
> -
>  		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
>  				 "6029 NVME PRLI Cmpl w1 x%08x "
>  				 "w4 x%08x w5 x%08x flag x%x, "
> 
If you say so :-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
