From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/19] lpfc: Fix issue_lip if link is disabled
Date: Mon, 29 Jan 2018 09:13:36 +0100
Message-ID: <f97aae9e-68ae-d792-cbc0-b30d427134d4@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-12-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeA2LNu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 06:13:50 -0500
In-Reply-To: <20180124224548.9530-12-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> The driver ignored checks on whether the link should be
> kept administratively down after a link bounce. Correct the
> checks.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index d8064e3ea0ba..b79dad7b8278 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -911,7 +911,12 @@ lpfc_issue_lip(struct Scsi_Host *shost)
>  	LPFC_MBOXQ_t *pmboxq;
>  	int mbxstatus = MBXERR_ERROR;
>  
> +	/*
> +	 * If the link is offline, disabled or BLOCK_MGMT_IO
> +	 * it doesn't make any sense to allow issue_lip
> +	 */
>  	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
> +	    (phba->hba_flag & LINK_DISABLED) ||
>  	    (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO))
>  		return -EPERM;
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
