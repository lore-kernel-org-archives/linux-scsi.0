From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/15] megaraid_sas: Set device queue_depth same as HBA
 can_queue value in scsi-mq mode
Date: Fri, 30 Jun 2017 15:39:46 +0200
Message-ID: <40da55a6-77c5-340d-17cd-fae3c6f4c097@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38305 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751690AbdF3Njt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:39:49 -0400
In-Reply-To: <1498811409-11157-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 06/30/2017 10:30 AM, Shivasharan S wrote:
> Currently driver sets default queue_depth for VDs at 256 and JBODs based on interface type,
> ie., for SAS JBOD QD will be 64, for SATA JBOD QD will be 32.
> During performance runs with scsi-mq enabled, we are seeing better results by
> setting QD same as HBA queue_depth.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 0230929..c200f1a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1891,7 +1891,8 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev,
>  	if (instance->nvme_page_size && max_io_size_kb)
>  		megasas_set_nvme_device_properties(sdev, (max_io_size_kb << 10));
>  
> -	scsi_change_queue_depth(sdev, device_qd);
> +	if (!shost_use_blk_mq(sdev->host))
> +		scsi_change_queue_depth(sdev, device_qd);
>  
>  }
>  
> @@ -5914,6 +5915,9 @@ static int megasas_io_attach(struct megasas_instance *instance)
>  	host->max_lun = MEGASAS_MAX_LUN;
>  	host->max_cmd_len = 16;
>  
> +	if (shost_use_blk_mq(host))
> +		host->cmd_per_lun = host->can_queue;
> +
>  	/*
>  	 * Notify the mid-layer about the new controller
>  	 */
> 
Is this bit really necessary? It will be adjusted by the above hunk,
would it not?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
