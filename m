From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 38/39] megaraid_sas: Change RAID_1_10_RMW_CMDS to
 RAID_1_PEER_CMDS and set value to 2
Date: Mon, 6 Feb 2017 12:31:04 +0100
Message-ID: <d83e842d-b938-96ea-f7b4-ec07de147590@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-39-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:41008 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdBFLbH (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:31:07 -0500
In-Reply-To: <1486375212-17329-39-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 11:00 AM, Shivasharan S wrote:
> For RAID1 FastPath writes, driver needs to allocate extra commands
> internally to accommodate for the extra peer command being sent.
> Currently driver is allocating 2 extra commands for each but only
> one extra command is necessary.
> Set RAID_1_10_RMW_CMDS to 2 and also change macro name to
> RAID_1_PEER_CMDS.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index b5bb33e..6dffb17 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -293,7 +293,7 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
>  
>  	if (instance->is_ventura)
>  		instance->max_mpt_cmds =
> -		instance->max_fw_cmds * RAID_1_10_RMW_CMDS;
> +		instance->max_fw_cmds * RAID_1_PEER_CMDS;
>  	else
>  		instance->max_mpt_cmds = instance->max_fw_cmds;
>  }
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> index 60566e4..c36f9f7 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> @@ -101,7 +101,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
>  #define MEGASAS_FP_CMD_LEN	16
>  #define MEGASAS_FUSION_IN_RESET 0
>  #define THRESHOLD_REPLY_COUNT 50
> -#define RAID_1_10_RMW_CMDS 3
> +#define RAID_1_PEER_CMDS 2
>  #define JBOD_MAPS_COUNT	2
>  
>  enum MR_FUSION_ADAPTER_TYPE {
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
