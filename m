From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/10] qla4xxx: Fix memory leak in func qla4_84xx_config_acb()
Date: Mon, 31 Mar 2014 00:39:02 -0500
Message-ID: <5338FF76.9050103@cs.wisc.edu>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com> <1393297625-928-10-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56290 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaCaFjN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 01:39:13 -0400
In-Reply-To: <1393297625-928-10-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com

On 02/24/2014 09:07 PM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> Use correct goto statement to free dma memory in case of
> failure in function qla4_84xx_config_acb()
> 
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  drivers/scsi/qla4xxx/ql4_mbx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index 0a6b782..1345c0e 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -2381,7 +2381,7 @@ int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config)
>  			ql4_printk(KERN_ERR, ha, "%s: Unable to alloc acb\n",
>  				   __func__);
>  			rval = QLA_ERROR;
> -			goto exit_config_acb;
> +			goto exit_free_acb;
>  		}
>  		memcpy(ha->saved_acb, acb, acb_len);
>  		break;
> 

This patch looks ok, but is it possible to still leak the ha->saved_acb
still? If you were going to do ACB_CONFIG_SET but the dma_alloc_coherent
failed then it would not be freed.
