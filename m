From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/19] lpfc: Treat SCSI Write operation Underruns as an
 error
Date: Mon, 29 Jan 2018 09:33:39 +0100
Message-ID: <92618c20-90a8-b2e8-d753-6de06f5b4a48@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-17-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751344AbeA2Kdz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:33:55 -0500
In-Reply-To: <20180124224548.9530-17-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> Currently, write underruns (mismatch of amount transferred vs scsi
> status and its residual) detected by the adapter are not being
> flagged as an error. Its expected the target controls the data
> transfer and would appropriately set the RSP values.  Only read
> underruns are treated as errors.
> 
> Revise the SCSI error handling to treat write underruns as an
> error as well.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index dcc86936e6fc..10c2dc0cf1fa 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3772,20 +3772,18 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
>  		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
>  
>  		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP_UNDER,
> -				 "9025 FCP Read Underrun, expected %d, "
> +				 "9025 FCP Underrun, expected %d, "
>  				 "residual %d Data: x%x x%x x%x\n",
>  				 fcpDl,
>  				 scsi_get_resid(cmnd), fcpi_parm, cmnd->cmnd[0],
>  				 cmnd->underflow);
>  
>  		/*
> -		 * If there is an under run check if under run reported by
> +		 * If there is an under run, check if under run reported by
>  		 * storage array is same as the under run reported by HBA.
>  		 * If this is not same, there is a dropped frame.
>  		 */
> -		if ((cmnd->sc_data_direction == DMA_FROM_DEVICE) &&
> -			fcpi_parm &&
> -			(scsi_get_resid(cmnd) != fcpi_parm)) {
> +		if (fcpi_parm && (scsi_get_resid(cmnd) != fcpi_parm)) {
>  			lpfc_printf_vlog(vport, KERN_WARNING,
>  					 LOG_FCP | LOG_FCP_ERROR,
>  					 "9026 FCP Read Check Error "
> 
I so hope you have this tested ...

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
