From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/15] megaraid_sas: Do not re-fire shutdown DCMD after
 OCR
Date: Fri, 30 Jun 2017 15:30:20 +0200
Message-ID: <71419144-2ee6-dfc3-d735-7b31c987c4ad@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35926 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751563AbdF3NaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:30:23 -0400
In-Reply-To: <1498811409-11157-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 06/30/2017 10:29 AM, Shivasharan S wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 0f13c58..a308e14 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3618,6 +3618,15 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
>  
>  		if (!smid)
>  			continue;
> +
> +		/* Do not refire shutdown command */
> +		if (le32_to_cpu(cmd_mfi->frame->dcmd.opcode) ==
> +			MR_DCMD_CTRL_SHUTDOWN) {
> +			cmd_mfi->frame->dcmd.cmd_status = MFI_STAT_OK;
> +			megasas_complete_cmd(instance, cmd_mfi, DID_OK);
> +			continue;
> +		}
> +
>  		req_desc = megasas_get_request_descriptor
>  					(instance, smid - 1);
>  		refire_cmd = req_desc && ((cmd_mfi->frame->dcmd.opcode !=
> 
Please, no.
You already have a selector further down whether to refire the command,
pending on the DRV_DCMD_SKIP_REFIRE flag.
If you always set this flag for the shutdown command you wouldn't need
to touch this at all.
And if you particularly dislike that solution convert the 'refire_cmd ='
statement into a proper switch and blank it out from there.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
