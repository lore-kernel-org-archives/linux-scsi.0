From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 09/39] megaraid_sas: NVME Interface detection and prop
 settings
Date: Mon, 6 Feb 2017 11:47:22 +0100
Message-ID: <996c107a-9a15-3e9e-c510-eb94913d21c7@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:53695 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbdBFKrZ (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 05:47:25 -0500
In-Reply-To: <1486375212-17329-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> New functionality
> Adding detection logic for NVME device attached behind Ventura controller.
> Driver set HostPageSize in IOC_INIT frame to inform about page size for NVME devices.
> Firmware reports NVME page size to the driver.
> PD INFO DCMD provide new interface type NVME_PD. Driver set property of NVME device.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  23 ++--
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 170 ++++++++++++++++++++--------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   6 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +-
>  4 files changed, 142 insertions(+), 59 deletions(-)
> 
[ .. ]
> @@ -3983,18 +4037,22 @@ dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
>  		return INITIATE_OCR;
>  }
>  
> -static int
> -megasas_get_pd_info(struct megasas_instance *instance, u16 device_id)
> +static void
> +megasas_get_pd_info(struct megasas_instance *instance, struct scsi_device *sdev)
>  {
>  	int ret;
>  	struct megasas_cmd *cmd;
>  	struct megasas_dcmd_frame *dcmd;
>  
> +	struct MR_PRIV_DEVICE *mr_device_priv_data;
> +	u16 device_id = 0;
> +
> +	device_id = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
>  	cmd = megasas_get_cmd(instance);
>  
>  	if (!cmd) {
>  		dev_err(&instance->pdev->dev, "Failed to get cmd %s\n", __func__);
> -		return -ENOMEM;
> +		return;
>  	}
>  
>  	dcmd = &cmd->frame->dcmd;
> @@ -4021,7 +4079,9 @@ megasas_get_pd_info(struct megasas_instance *instance, u16 device_id)
>  
>  	switch (ret) {
>  	case DCMD_SUCCESS:
> -		instance->pd_list[device_id].interface =
> +		mr_device_priv_data = sdev->hostdata;
> +		le16_to_cpus((u16 *)&instance->pd_info->state.ddf.pdType);
> +		mr_device_priv_data->interface_type =
>  				instance->pd_info->state.ddf.pdType.intf;
>  		break;
>  
> @@ -4048,7 +4108,7 @@ megasas_get_pd_info(struct megasas_instance *instance, u16 device_id)
>  	if (ret != DCMD_TIMEOUT)
>  		megasas_return_cmd(instance, cmd);
>  
> -	return ret;
> +	return;
>  }
>  /*
>   * megasas_get_pd_list_info -	Returns FW's pd_list structure
Please don't do this.
There's a valid reason why there is return value in the first place (hot
removal of devices IIRC), and it's always good manners to provide for an
error path instead of assuming that everything will be fine.

And, incidentally, this has nothing to do with the NVMe backend changes,
right?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
