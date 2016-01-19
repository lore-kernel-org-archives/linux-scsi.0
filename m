From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 10/15] megaraid_sas: IO throttling support
Date: Tue, 19 Jan 2016 14:38:04 +0100
Message-ID: <569E3C3C.6040507@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-11-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbcASNiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 08:38:07 -0500
In-Reply-To: <1450445228-26571-11-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 18.12.2015 14:27, Sumit Saxena wrote:
> This patch will add capability in driver to tell firmware that it can throttle IOs in case Controller's Queue depth is downgraded post OFU
> (Online firmware upgrade). This feature will ensure firmware can be downgraded from higher queue depth to lower queue depth without needing system reboot.
> Added throttling code in IO path of driver, in case OS tries to send more IOs than post OFU firmware's queue depth.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |    6 ++++--
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    7 +++++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 4595ef4..9d2b3da 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1537,7 +1537,8 @@ union megasas_sgl_frame {
>  typedef union _MFI_CAPABILITIES {
>  	struct {
>  #if   defined(__BIG_ENDIAN_BITFIELD)
> -		u32     reserved:21;
> +		u32     reserved:20;
> +		u32     support_qd_throttling:1;
>  		u32     support_fp_rlbypass:1;
>  		u32     support_vfid_in_ioframe:1;
>  		u32     support_ext_io_size:1;
> @@ -1561,7 +1562,8 @@ typedef union _MFI_CAPABILITIES {
>  		u32     support_ext_io_size:1;
>  		u32     support_vfid_in_ioframe:1;
>  		u32     support_fp_rlbypass:1;
> -		u32     reserved:21;
> +		u32     support_qd_throttling:1;
> +		u32     reserved:20;
>  #endif
>  	} mfi_capabilities;
>  	__le32		reg;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 7cc7806..1248c7a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -801,6 +801,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
>  	if (!dual_qdepth_disable)
>  		drv_ops->mfi_capabilities.support_ext_queue_depth = 1;
>  
> +	drv_ops->mfi_capabilities.support_qd_throttling = 1;
>  	/* Convert capability to LE32 */
>  	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
>  
> @@ -2182,6 +2183,12 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
>  			atomic_inc(&instance->ldio_outstanding);
>  	}
>  
> +	if (atomic_read(&instance->fw_outstanding) >=
> +			instance->host->can_queue) {
> +		dev_err(&instance->pdev->dev, "Throttle IOs beyond Controller queue depth\n");
> +		return SCSI_MLQUEUE_HOST_BUSY;
> +	}

Same as in the previous patch, this this test above won't you protect when several
processes read the same value in parallel. In addition to that, when the scsi layer
knows the new smaller can_queue value it will not queue new commands above the limit.

> +
>  	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
>  
>  	index = cmd->index;

