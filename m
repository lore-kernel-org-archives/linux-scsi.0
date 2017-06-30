From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/15] megaraid_sas: Check valid aen class range to avoid
 kernel panic
Date: Fri, 30 Jun 2017 15:35:22 +0200
Message-ID: <19be35ab-0b9d-46d7-f840-41376ebad07b@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37983 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751668AbdF3NfZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:35:25 -0400
In-Reply-To: <1498811409-11157-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, stable@vger.kernel.org

On 06/30/2017 10:30 AM, Shivasharan S wrote:
> An application sending out of range AEN class code for 
> registration, will result in kernel panic in MR driver.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 3c50a7b..e490272 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5650,6 +5650,14 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
>  		prev_aen.word =
>  			le32_to_cpu(instance->aen_cmd->frame->dcmd.mbox.w[1]);
>  
> +		if ((curr_aen.members.class < MFI_EVT_CLASS_DEBUG) ||
> +		    (curr_aen.members.class > MFI_EVT_CLASS_DEAD)) {
> +			dev_info(&instance->pdev->dev,
> +				 "%s %d out of range class %d send by application\n",
> +				 __func__, __LINE__, curr_aen.members.class);
> +			return 0;
> +		}
> +
>  		/*
>  		 * A class whose enum value is smaller is inclusive of all
>  		 * higher values. If a PROGRESS (= -1) was previously
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
