From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 04/11] lpfc: Correct issue leading to opps during link
 reset
Date: Tue, 20 Dec 2016 14:36:45 +0100
Message-ID: <55ec5858-df94-c904-d4b4-e837961cb8bb@suse.de>
References: <5858682b.xzQowb/v7GznHZ5u%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33045 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756620AbcLTNgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:36:47 -0500
In-Reply-To: <5858682b.xzQowb/v7GznHZ5u%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> Correct issue leading to opps during link reset. Missing vport pointer.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 230f924..47b5520 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -10027,6 +10027,7 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
>  		iabt->ulpCommand = CMD_CLOSE_XRI_CN;
>  
>  	abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
> +	abtsiocbp->vport = vport;
>  
>  	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
>  			 "0339 Abort xri x%x, original iotag x%x, "
> 
I think you'll find it's actually 'oops' :-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
