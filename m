From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH RFC] qla2xxx: fix ignored size and offset parameters in
 qla2x00_sysfs_read_[nvram vpd]
Date: Tue, 24 Jul 2007 13:33:26 -0700
Message-ID: <46A66216.3040506@qlogic.com>
References: <1185283210.28503.15.camel@anacortes.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:36550 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbXGXUeU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 16:34:20 -0400
In-Reply-To: <1185283210.28503.15.camel@anacortes.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rlary@austin.ibm.com
Cc: linux-scsi@vger.kernel.org

Richard A Lary wrote:
> From: Richard Lary <rlary@us.ibm.com>
> 
> This patch fixes Segmemtation fault which occurs when executing:
> #udevinfo -a -p /sys/class/scsi_host/{qla2xxx_host}
> 
> The qla2xxx driver ignores the size and offset parameters when
> reading nvram and vpd attributes.
Thank you for finding the problem.
Please find comments below.
Updated patch will be followed, soon.

Thank you,
Seokmann

> Signed-off-by: Richard Lary <rlary@us.ibm.com>
> ---
> 
> Example: 
> 
>   looking at device '/class/scsi_host/host5':
>     KERNEL=="host5"
>     SUBSYSTEM=="scsi_host"
>     SYSFS{proc_name}=="_NULL_"
>     SYSFS{unchecked_isa_dma}=="0"
>     SYSFS{sg_tablesize}=="255"
>     SYSFS{cmd_per_lun}=="3"
>     SYSFS{host_busy}=="0"
>     SYSFS{unique_id}=="0"
>     SYSFS{beacon}=="Disabled"
>     SYSFS{zio_timer}=="200 us"
>     SYSFS{zio}=="Disabled"
>     SYSFS{state}=="Link Up - F_Port"
>     SYSFS{pci_info}=="PCI-X Mode 1 _100 MHz_"
>     SYSFS{model_desc}=="IBM eServer BC 4Gb FC Expansion Card SFF"
>     SYSFS{model_name}=="QMC2462S"
>     SYSFS{isp_id}=="0000 0000 0000 0000"
>     SYSFS{isp_name}=="ISP2422"
>     SYSFS{serial_num}=="N83786"
>     SYSFS{fw_version}=="4.00.26 _IP_ "
>     SYSFS{driver_version}=="8.01.07-k3-rl"
> 
>   looking at device '/devices/pci0000:00/0000:00:01.0/0000:01:02.0/host5':
>     ID=="host5"
>     BUS==""
>     DRIVER==""
>     SYSFS{sfp}==""
> Segmentation fault
> 
> Applies to: scsi-misc-2.6.git
> 
> Index: b/drivers/scsi/qla2xxx/qla_attr.c
> ===================================================================
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -87,17 +87,35 @@ qla2x00_sysfs_read_nvram(struct kobject 
>  	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
>  	    struct device, kobj)));
>  	unsigned long	flags;
> +	int size = ha->nvram_size;
> +	char *nvram_buf;
>  
> -	if (!capable(CAP_SYS_ADMIN) || off != 0)
> +	if (!capable(CAP_SYS_ADMIN) || off > size)
>  		return 0;
>  
> +	nvram_buf = (char *)vmalloc(size);
> +	if (nvram_buf == NULL) {
> +		qla_printk(KERN_WARNING, ha,
> +		    "Unable to allocate memory for nvram retrieval "
> +		    "(%x).\n", size);
> +
> +		return 0;
> +	}
IMO, as given buf is valid address which can be accessed by the driver, extra vmalloc() is not necessary.
> +
> +	if (off + count > size) {
> +		size -= off;
> +		count = size;
> +	}
Before this check, it would be good to check 'if count == 0' and return 0.
> +
>  	/* Read NVRAM. */
>  	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	ha->isp_ops.read_nvram(ha, (uint8_t *)buf, ha->nvram_base,
> -	    ha->nvram_size);
> +	ha->isp_ops.read_nvram(ha, (uint8_t *)nvram_buf, ha->nvram_base, size);
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
> -	return ha->nvram_size;
> +	memcpy(buf, &nvram_buf[off], count);
> +
> +	vfree(nvram_buf);
As vmalloc(), memcpy() and vfree() also are not necessary.
> +	return count;
>  }
>  
>  static ssize_t
> @@ -292,16 +310,35 @@ qla2x00_sysfs_read_vpd(struct kobject *k
>  	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
>  	    struct device, kobj)));
>  	unsigned long flags;
> +	int size = ha->vpd_size;
> +	char *vpd_buf;
>  
> -	if (!capable(CAP_SYS_ADMIN) || off != 0)
> +	if (!capable(CAP_SYS_ADMIN) || off > size)
>  		return 0;
Also, check if count == 0 and return 0 if so.

> +	vpd_buf = (char *)vmalloc(size);
> +	if (vpd_buf == NULL) {
> +		qla_printk(KERN_WARNING, ha,
> +		    "Unable to allocate memory for vpd retrieval "
> +		    "(%x).\n", size);
> +
> +		return 0;
> +	}
Same here, extra memory allocation is not required.
> +	if (off + count > size) {
> +		size -= off;
> +		count = size;
> +	}
>  
>  	/* Read NVRAM. */
>  	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	ha->isp_ops.read_nvram(ha, (uint8_t *)buf, ha->vpd_base, ha->vpd_size);
> +	ha->isp_ops.read_nvram(ha, (uint8_t *)vpd_buf, ha->vpd_base, size);
>  	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  
> -	return ha->vpd_size;
> +	memcpy(buf, &vpd_buf[off], count);
> +
> +	vfree(vpd_buf);
Same here, as vmalloc(), memcpy() and vfree() are not necessary.
> +	return count;
>  }
>  
>  static ssize_t
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

