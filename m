From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 10/17] lpfc: Fix ndlp ref count for pt2pt mode issue
 RSCN
Date: Mon, 20 Nov 2017 14:18:04 +0100
Message-ID: <042a94b2-a375-51ba-6d9f-513a63ed2613@suse.de>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
 <20171110010834.4542-11-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56381 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdKTNSG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 08:18:06 -0500
In-Reply-To: <20171110010834.4542-11-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/10/2017 02:08 AM, James Smart wrote:
> pt2pt ndlp ref count prematurely goes to 0. There was reference
> removed that should only be removed if connected to a switch,
> not if in point-to-point mode.
> 
> Add a mode check before the reference remove.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 532cd4b49c5d..911066c9612d 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -2956,8 +2956,8 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
>  	/* This will cause the callback-function lpfc_cmpl_els_cmd to
>  	 * trigger the release of node.
>  	 */
> -
> -	lpfc_nlp_put(ndlp);
> +	if (!(vport->fc_flag & FC_PT2PT))
> +		lpfc_nlp_put(ndlp);
>  	return 0;
>  }
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
