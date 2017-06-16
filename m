From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/11] Driver responds LS_RJT to Beacon Off ELS - Linux
Date: Fri, 16 Jun 2017 10:03:06 +0200
Message-ID: <d13fe1d0-d793-c5d2-0aba-918c30a3d2ee@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-11-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752134AbdFPIDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 04:03:08 -0400
In-Reply-To: <20170616055651.9674-11-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> Beacon OFF from switch is rejected by driver.
> 
> Driver fails Beacon OFF if frequency is set to 0. As per fc-ls
> spec, status, capability, frequency and duration fields are only
> applicable for Beacon ON.
> 
> Remove frequency and type checks. Reject Beacon ON if duration
> is non zero.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 54de984d695f..6d1d6f691df4 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -5703,27 +5703,13 @@ lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>  		rjt_err = LSRJT_CMD_UNSUPPORTED;
>  		goto rjt;
>  	}
> -	if (beacon->lcb_frequency == 0) {
> +	if (beacon->lcb_sub_command != LPFC_LCB_ON &&
> +	    beacon->lcb_sub_command != LPFC_LCB_OFF) {
>  		rjt_err = LSRJT_CMD_UNSUPPORTED;
>  		goto rjt;
>  	}
> -	if ((beacon->lcb_type != LPFC_LCB_GREEN) &&
> -	    (beacon->lcb_type != LPFC_LCB_AMBER)) {
> -		rjt_err = LSRJT_CMD_UNSUPPORTED;
> -		goto rjt;
> -	}
> -	if ((beacon->lcb_sub_command != LPFC_LCB_ON) &&
> -	    (beacon->lcb_sub_command != LPFC_LCB_OFF)) {
> -		rjt_err = LSRJT_CMD_UNSUPPORTED;
> -		goto rjt;
> -	}
> -	if ((beacon->lcb_sub_command == LPFC_LCB_ON) &&
> -	    (beacon->lcb_type != LPFC_LCB_GREEN) &&
> -	    (beacon->lcb_type != LPFC_LCB_AMBER)) {
> -		rjt_err = LSRJT_CMD_UNSUPPORTED;
> -		goto rjt;
> -	}
> -	if (be16_to_cpu(beacon->lcb_duration) != 0) {
> +	if (beacon->lcb_sub_command == LPFC_LCB_ON &&
> +	    be16_to_cpu(beacon->lcb_duration) != 0) {
>  		rjt_err = LSRJT_CMD_UNSUPPORTED;
>  		goto rjt;
>  	}
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
