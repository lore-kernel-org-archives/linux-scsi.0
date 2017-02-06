From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 22/39] megaraid_sas: latest controller OCR capability from
 FW before sending shutdown DCMD
Date: Mon, 6 Feb 2017 12:23:03 +0100
Message-ID: <d960cd25-3226-7a0c-b9ab-1fbbd09f439c@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:48388 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbdBFLXG (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:23:06 -0500
In-Reply-To: <1486375212-17329-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> Fetch the latest controller OCR capability from FW before
> sending MR_DCMD_CTRL_SHUTDOWN
> When application sends a shutdown DCMD (MR_DCMD_CTRL_SHUTDOWN),
> driver will fetch latest controller information from firmware.
> This is to ensure that driver always has latest OCR capability
> of controller before sending the DCMD.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 907b2bf..ac88ad6 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6895,6 +6895,13 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>  					       MFI_FRAME_SGL64 |
>  					       MFI_FRAME_SENSE64));
>  
> +	if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_SHUTDOWN) {
> +		if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS) {
> +			megasas_return_cmd(instance, cmd);
> +			return -1;
> +		}
> +	}
> +
>  	if (cmd->frame->dcmd.opcode == MR_DRIVER_SET_APP_CRASHDUMP_MODE) {
>  		error = megasas_set_crash_dump_params_ioctl(cmd);
>  		megasas_return_cmd(instance, cmd);
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
