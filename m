From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 09/15] megaraid_sas: Dual Queue depth support
Date: Tue, 19 Jan 2016 14:34:09 +0100
Message-ID: <569E3B51.9070103@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-10-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbcASNeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 08:34:11 -0500
In-Reply-To: <1450445228-26571-10-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 18.12.2015 14:27, Sumit Saxena wrote:
> This patch will add support for Dual Queue depth reported by firmware.
>
> Below are key points-
>
> 1. For iMR controllers, firmware will report two queue depths- 1. Controller wide Queue depth 2. LDIO Queue depth(240).
> Ofcourse, Controller wide Queue depth will be greater among two. Using this new method, iMR can provide larger Queue depth(QD)
> for JBOD and limited QD for Virtual Disk(VD). This feature gives benefit for iMR product which will be used for deployment
> with large number of JBOD and limited number of VD on setup. 
> 2. megaraid_sas driver will throttle Read write LDIOs based when RW LDIOs reaches "LDIO Queue Depth".
> 3. This feature of dual queue depth can enabled/disabled via module parameter. Default behavior is: Dual Queue depth is enabled.
> 4. Added sysfs parameter "ldio_outstanding" for user to read LDIO outstanding at run time.
>
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |    9 +++
>  drivers/scsi/megaraid/megaraid_sas_base.c   |   20 ++++++-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   89 ++++++++++++++++++++++++---
>  3 files changed, 108 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index c539516..4595ef4 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1353,6 +1353,12 @@ enum DCMD_TIMEOUT_ACTION {
>  	KILL_ADAPTER = 1,
>  	IGNORE_TIMEOUT = 2,
>  };
> +
> +enum FW_BOOT_CONTEXT {
> +	PROBE_CONTEXT = 0,
> +	OCR_CONTEXT = 1,
> +};
> +
>  /* Frame Type */
>  #define IO_FRAME				0
>  #define PTHRU_FRAME				1
> @@ -2038,6 +2044,8 @@ struct megasas_instance {
>  	u16 max_fw_cmds;
>  	u16 max_mfi_cmds;
>  	u16 max_scsi_cmds;
> +	u16 ldio_threshold;
> +	u16 cur_can_queue;
>  	u32 max_sectors_per_req;
>  	struct megasas_aen_event *ev;
>  
> @@ -2068,6 +2076,7 @@ struct megasas_instance {
>  	u32 fw_support_ieee;
>  
>  	atomic_t fw_outstanding;
> +	atomic_t ldio_outstanding;
>  	atomic_t fw_reset_no_pci_access;
>  
>  	struct megasas_instance_template *instancet;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 3454c5e..edc26fb 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -96,6 +96,10 @@ int rdpq_enable = 1;
>  module_param(rdpq_enable, int, S_IRUGO);
>  MODULE_PARM_DESC(rdpq_enable, " Allocate reply queue in chunks for large queue depth enable/disbale Default: disable(0)");
>  
> +unsigned int dual_qdepth_disable;
> +module_param(dual_qdepth_disable, int, S_IRUGO);
> +MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual queue depth feature. Default: 0");
> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux.pdl@avagotech.com");
> @@ -1977,7 +1981,7 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
>  		spin_lock_irqsave(instance->host->host_lock, flags);
>  		instance->flag &= ~MEGASAS_FW_BUSY;
>  
> -		instance->host->can_queue = instance->max_scsi_cmds;
> +		instance->host->can_queue = instance->cur_can_queue;
>  		spin_unlock_irqrestore(instance->host->host_lock, flags);
>  	}
>  }
> @@ -2942,6 +2946,16 @@ megasas_page_size_show(struct device *cdev,
>  	return snprintf(buf, PAGE_SIZE, "%ld\n", (unsigned long)PAGE_SIZE - 1);
>  }
>  
> +static ssize_t
> +megasas_ldio_outstanding_show(struct device *cdev, struct device_attribute *attr,
> +	char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(cdev);
> +	struct megasas_instance *instance = (struct megasas_instance *)shost->hostdata;
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&instance->ldio_outstanding));
> +}
> +
>  static DEVICE_ATTR(fw_crash_buffer, S_IRUGO | S_IWUSR,
>  	megasas_fw_crash_buffer_show, megasas_fw_crash_buffer_store);
>  static DEVICE_ATTR(fw_crash_buffer_size, S_IRUGO,
> @@ -2950,12 +2964,15 @@ static DEVICE_ATTR(fw_crash_state, S_IRUGO | S_IWUSR,
>  	megasas_fw_crash_state_show, megasas_fw_crash_state_store);
>  static DEVICE_ATTR(page_size, S_IRUGO,
>  	megasas_page_size_show, NULL);
> +static DEVICE_ATTR(ldio_outstanding, S_IRUGO,
> +	megasas_ldio_outstanding_show, NULL);
>  
>  struct device_attribute *megaraid_host_attrs[] = {
>  	&dev_attr_fw_crash_buffer_size,
>  	&dev_attr_fw_crash_buffer,
>  	&dev_attr_fw_crash_state,
>  	&dev_attr_page_size,
> +	&dev_attr_ldio_outstanding,
>  	NULL,
>  };
>  
> @@ -4750,6 +4767,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
>  		sema_init(&instance->ioctl_sem, (MEGASAS_MFI_IOCTL_CMDS));
>  	}
>  
> +	instance->cur_can_queue = instance->max_scsi_cmds;
>  	/*
>  	 * Create a pool of commands
>  	 */
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 9ad779d..7cc7806 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -92,6 +92,7 @@ void megasas_start_timer(struct megasas_instance *instance,
>  			 void *fn, unsigned long interval);
>  extern struct megasas_mgmt_info megasas_mgmt_info;
>  extern int resetwaittime;
> +extern unsigned int dual_qdepth_disable;
>  static void megasas_free_rdpq_fusion(struct megasas_instance *instance);
>  static void megasas_free_reply_fusion(struct megasas_instance *instance);
>  
> @@ -208,6 +209,67 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
>  }
>  
>  /**
> + * megasas_fusion_update_can_queue -	Do all Adapter Queue depth related calculations here
> + * @instance:							Adapter soft state
> + * fw_boot_context:						Whether this function called during probe or after OCR
> + *
> + * This function is only for fusion controllers.
> + * Update host can queue, if firmware downgrade max supported firmware commands.
> + * Firmware upgrade case will be skiped because underlying firmware has
> + * more resource than exposed to the OS.
> + *
> + */
> +static void
> +megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_context)
> +{
> +	u16 cur_max_fw_cmds = 0;
> +	u16 ldio_threshold = 0;
> +	struct megasas_register_set __iomem *reg_set;
> +
> +	reg_set = instance->reg_set;
> +
> +	cur_max_fw_cmds = readl(&instance->reg_set->outbound_scratch_pad_3) & 0x00FFFF;
> +
> +	if (dual_qdepth_disable || !cur_max_fw_cmds)
> +		cur_max_fw_cmds = instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF;
> +	else
> +		ldio_threshold =
> +			(instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF) - MEGASAS_FUSION_IOCTL_CMDS;
> +
> +	dev_info(&instance->pdev->dev,
> +			"Current firmware maximum commands: %d\t LDIO thershold: %d\n",

a typo in "thershold"

> +			cur_max_fw_cmds, ldio_threshold);
> +
> +	if (fw_boot_context == OCR_CONTEXT) {
> +		cur_max_fw_cmds = cur_max_fw_cmds - 1;
> +		if (cur_max_fw_cmds <= instance->max_fw_cmds) {

probably '<' instead of '<=" could be here ?

> +			instance->cur_can_queue =
> +				cur_max_fw_cmds - (MEGASAS_FUSION_INTERNAL_CMDS +
> +						MEGASAS_FUSION_IOCTL_CMDS);
> +			instance->host->can_queue = instance->cur_can_queue;
> +			instance->ldio_threshold = ldio_threshold;
> +		}
> +	} else {
> +		instance->max_fw_cmds = cur_max_fw_cmds;
> +		instance->ldio_threshold = ldio_threshold;
> +
> +		if (!instance->is_rdpq)
> +			instance->max_fw_cmds = min_t(u16, instance->max_fw_cmds, 1024);
> +
> +		/*
> +		* Reduce the max supported cmds by 1. This is to ensure that the
> +		* reply_q_sz (1 more than the max cmd that driver may send)
> +		* does not exceed max cmds that the FW can support
> +		*/
> +		instance->max_fw_cmds = instance->max_fw_cmds-1;
> +
> +		instance->max_scsi_cmds = instance->max_fw_cmds -
> +				(MEGASAS_FUSION_INTERNAL_CMDS +
> +				MEGASAS_FUSION_IOCTL_CMDS);
> +		instance->cur_can_queue = instance->max_scsi_cmds;
> +	}
> +}
> +/**
>   * megasas_free_cmds_fusion -	Free all the cmds in the free cmd pool
>   * @instance:		Adapter soft state
>   */
> @@ -736,6 +798,8 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
>  		drv_ops->mfi_capabilities.support_ext_io_size = 1;
>  
>  	drv_ops->mfi_capabilities.support_fp_rlbypass = 1;
> +	if (!dual_qdepth_disable)
> +		drv_ops->mfi_capabilities.support_ext_queue_depth = 1;
>  
>  	/* Convert capability to LE32 */
>  	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
> @@ -1151,15 +1215,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
>  
>  	reg_set = instance->reg_set;
>  
> -	/*
> -	 * Get various operational parameters from status register
> -	 */
> -	instance->max_fw_cmds =
> -		instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF;
> -	dev_info(&instance->pdev->dev,
> -		"firmware support max fw cmd\t: (%d)\n", instance->max_fw_cmds);
> -	if (!instance->is_rdpq)
> -		instance->max_fw_cmds = min_t(u16, instance->max_fw_cmds, 1024);
> +	megasas_fusion_update_can_queue(instance, PROBE_CONTEXT);
>  
>  	/*
>  	 * Reduce the max supported cmds by 1. This is to ensure that the
> @@ -2117,6 +2173,15 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
>  
>  	fusion = instance->ctrl_context;
>  
> +	if (megasas_cmd_type(scmd) == READ_WRITE_LDIO) {
> +		if (instance->ldio_threshold &&
> +			(atomic_read(&instance->ldio_outstanding) >=
> +			instance->ldio_threshold))

This test above won't you protect when several processes read the same value in parallel,
so it may happen that you get over the limit set for ldio_threshold.
(You might use instead a construction with atomic_dec_and_test for example) 

tomash

