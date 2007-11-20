From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Unify sysfs filenames for firmware version
Date: Tue, 20 Nov 2007 11:35:26 -0500
Message-ID: <47430CCE.50701@emulex.com>
References: <20071120133824.GD31112@earth.li>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62217 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbXKTQfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 11:35:36 -0500
In-Reply-To: <20071120133824.GD31112@earth.li>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Matt_Domsch@dell.com

The hearburn I have with these patches is that you are changing driver-specific
attributes, not common ones as enforced/requested by a subsystem. As such, you
are breaking a management interface for existing tools/scripts.

There's been a long-standing request to create common device attributes, such as
fw_version, but I don't think they ever made it into the kernel. Not only would
the names be consistent, but the location would be consistent as well.

I'd rather you took on that work, than proceed with these patches.

-- james s


Jonathan McDowell wrote:
> Looking around sysfs in an attempt to pull out SCSI card firmware
> versions I found 5 different filenames used to store the information.
> Only one, fw_version, was used more than once. The patch below changes
> the other drivers to use this filename too.
> 
> I suspect the same applies to other subsystem drivers as well. I'll look
> at them assuming this patch is well received.
> 
> Signed-Off-By: Jonathan McDowell <noodles@earth.li>
> 
> -----
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 626bb3c..ae80d04 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -3307,7 +3307,7 @@ mptscsih_version_fw_show(struct class_device *cdev, char *buf)
>  	    (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
>  	    ioc->facts.FWVersion.Word & 0x000000FF);
>  }
> -static CLASS_DEVICE_ATTR(version_fw, S_IRUGO, mptscsih_version_fw_show, NULL);
> +static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, mptscsih_version_fw_show, NULL);
>  
>  static ssize_t
>  mptscsih_version_bios_show(struct class_device *cdev, char *buf)
> diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
> index 7d7b0a5..646f24c 100644
> --- a/drivers/scsi/arcmsr/arcmsr_attr.c
> +++ b/drivers/scsi/arcmsr/arcmsr_attr.c
> @@ -352,7 +352,7 @@ static CLASS_DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO, arcmsr_attr_host_drive
>  static CLASS_DEVICE_ATTR(host_driver_reset, S_IRUGO, arcmsr_attr_host_driver_reset, NULL);
>  static CLASS_DEVICE_ATTR(host_driver_abort, S_IRUGO, arcmsr_attr_host_driver_abort, NULL);
>  static CLASS_DEVICE_ATTR(host_fw_model, S_IRUGO, arcmsr_attr_host_fw_model, NULL);
> -static CLASS_DEVICE_ATTR(host_fw_version, S_IRUGO, arcmsr_attr_host_fw_version, NULL);
> +static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, arcmsr_attr_host_fw_version, NULL);
>  static CLASS_DEVICE_ATTR(host_fw_request_len, S_IRUGO, arcmsr_attr_host_fw_request_len, NULL);
>  static CLASS_DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO, arcmsr_attr_host_fw_numbers_queue, NULL);
>  static CLASS_DEVICE_ATTR(host_fw_sdram_size, S_IRUGO, arcmsr_attr_host_fw_sdram_size, NULL);
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index 0844331..ed130ec 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -634,7 +634,7 @@ static struct class_device_attribute hptiop_attr_version = {
>  
>  static struct class_device_attribute hptiop_attr_fw_version = {
>  	.attr = {
> -		.name = "firmware-version",
> +		.name = "fw_version",
>  		.mode = S_IRUGO,
>  	},
>  	.show = hptiop_show_fw_version,
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 80a1121..32b1d2f 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -888,7 +888,7 @@ static CLASS_DEVICE_ATTR(modeldesc, S_IRUGO, lpfc_modeldesc_show, NULL);
>  static CLASS_DEVICE_ATTR(modelname, S_IRUGO, lpfc_modelname_show, NULL);
>  static CLASS_DEVICE_ATTR(programtype, S_IRUGO, lpfc_programtype_show, NULL);
>  static CLASS_DEVICE_ATTR(portnum, S_IRUGO, lpfc_vportnum_show, NULL);
> -static CLASS_DEVICE_ATTR(fwrev, S_IRUGO, lpfc_fwrev_show, NULL);
> +static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, lpfc_fwrev_show, NULL);
>  static CLASS_DEVICE_ATTR(hdw, S_IRUGO, lpfc_hdw_show, NULL);
>  static CLASS_DEVICE_ATTR(state, S_IRUGO, lpfc_state_show, NULL);
>  static CLASS_DEVICE_ATTR(option_rom_version, S_IRUGO,
> -----
> 
> J.
> 
