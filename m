From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/15] megaraid_sas: set minimum value of resetwaittime to
 be 1 secs
Date: Fri, 30 Jun 2017 15:23:49 +0200
Message-ID: <4b0a0a2d-9d49-8b6a-df99-784119bb92ea@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34471 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752276AbdF3NXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:23:53 -0400
In-Reply-To: <1498811409-11157-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, stable@vger.kernel.org

On 06/30/2017 10:29 AM, Shivasharan S wrote:
> Setting resetwaittime to 0 will result in driver not calling the OCR
> during a FW fault state.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 316c3df..395c3aa 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5478,7 +5478,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
>  		instance->throttlequeuedepth =
>  				MEGASAS_THROTTLE_QUEUE_DEPTH;
>  
> -	if (resetwaittime > MEGASAS_RESET_WAIT_TIME)
> +	if ((resetwaittime < 1) ||
> +	    (resetwaittime > MEGASAS_RESET_WAIT_TIME))
>  		resetwaittime = MEGASAS_RESET_WAIT_TIME;
>  
>  	if ((scmd_timeout < 10) || (scmd_timeout > MEGASAS_DEFAULT_CMD_TIMEOUT))
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
