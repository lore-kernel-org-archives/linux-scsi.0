From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/15] megaraid_sas: Call megasas_complete_cmd_dpc_fusion
 every 1 second while there are pending commands
Date: Fri, 30 Jun 2017 15:25:23 +0200
Message-ID: <3db566c3-6641-90a5-4b41-18c8c78ac953@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35289 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752013AbdF3NZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:25:26 -0400
In-Reply-To: <1498811409-11157-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 06/30/2017 10:29 AM, Shivasharan S wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 5018a3f..0f13c58 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3552,6 +3552,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
>  			}
>  		}
>  
> +		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
>  		outstanding = atomic_read(&instance->fw_outstanding);
>  		if (!outstanding)
>  			goto out;
> @@ -3560,8 +3561,6 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
>  			dev_notice(&instance->pdev->dev, "[%2d]waiting for %d "
>  			       "commands to complete for scsi%d\n", i,
>  			       outstanding, instance->host->host_no);
> -			megasas_complete_cmd_dpc_fusion(
> -				(unsigned long)instance);
>  		}
>  		msleep(1000);
>  	}
> 
Please add a changelog why this is necessary.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
