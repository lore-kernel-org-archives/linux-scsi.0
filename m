From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] [SCSI] ipr: fix resource path display and formatting
Date: Fri, 04 Jun 2010 14:04:39 -0500
Message-ID: <4C094E47.3070902@linux.vnet.ibm.com>
References: <20100602111658.GH28295@kryten> <4C08347D.8010102@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60698 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0FDTE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2010 15:04:57 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o54ItvOK008603
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2010 12:55:57 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o54J4dsq101920
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2010 13:04:40 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o54J4c3F000607
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2010 13:04:39 -0600
In-Reply-To: <4C08347D.8010102@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@samba.org>, brking@us.ibm.com, betabandido@gmail.com, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org

Acked-by: Brian King <brking@linux.vnet.ibm.com>


On 06/03/2010 06:02 PM, Wayne Boyer wrote:
> It was possible to overflow the buffer used to print out the formatted
> version of the resource path.  The fix is to limit the number of
> bytes that get formatted.
> 
> This patch also updates the ipr_show_resource_path function to display the
> resource address for devices that are attached to adapters that don't
> support resource paths.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
> 
> James, this patch needs to go into rc-fixes.  It fixes an oops that is
> currently being seen on Power.
> 
> ---
>  drivers/scsi/ipr.c |   51 +++++++++++++++++++++++++++++++++------------------
>  drivers/scsi/ipr.h |    5 +++--
>  2 files changed, 36 insertions(+), 20 deletions(-)
> 
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2010-05-26 16:01:22.000000000 -0700
> +++ b/drivers/scsi/ipr.c	2010-06-03 15:31:59.000000000 -0700
> @@ -1129,20 +1129,22 @@ static int ipr_is_same_device(struct ipr
>  }
> 
>  /**
> - * ipr_format_resource_path - Format the resource path for printing.
> + * ipr_format_res_path - Format the resource path for printing.
>   * @res_path:	resource path
>   * @buf:	buffer
>   *
>   * Return value:
>   * 	pointer to buffer
>   **/
> -static char *ipr_format_resource_path(u8 *res_path, char *buffer)
> +static char *ipr_format_res_path(u8 *res_path, char *buffer, int len)
>  {
>  	int i;
> +	char *p = buffer;
> 
> -	sprintf(buffer, "%02X", res_path[0]);
> -	for (i=1; res_path[i] != 0xff; i++)
> -		sprintf(buffer, "%s-%02X", buffer, res_path[i]);
> +	res_path[0] = '\0';
> +	p += snprintf(p, buffer + len - p, "%02X", res_path[0]);
> +	for (i = 1; res_path[i] != 0xff && ((i * 3) < len); i++)
> +		p += snprintf(p, buffer + len - p, "-%02X", res_path[i]);
> 
>  	return buffer;
>  }
> @@ -1187,7 +1189,8 @@ static void ipr_update_res_entry(struct 
> 
>  		if (res->sdev && new_path)
>  			sdev_printk(KERN_INFO, res->sdev, "Resource path: %s\n",
> -				    ipr_format_resource_path(&res->res_path[0], &buffer[0]));
> +				    ipr_format_res_path(res->res_path, buffer,
> +							sizeof(buffer)));
>  	} else {
>  		res->flags = cfgtew->u.cfgte->flags;
>  		if (res->flags & IPR_IS_IOA_RESOURCE)
> @@ -1573,7 +1576,8 @@ static void ipr_log_sis64_config_error(s
>  		ipr_err_separator;
> 
>  		ipr_err("Device %d : %s", i + 1,
> -			 ipr_format_resource_path(&dev_entry->res_path[0], &buffer[0]));
> +			 ipr_format_res_path(dev_entry->res_path, buffer,
> +					     sizeof(buffer)));
>  		ipr_log_ext_vpd(&dev_entry->vpd);
> 
>  		ipr_err("-----New Device Information-----\n");
> @@ -1919,13 +1923,14 @@ static void ipr_log64_fabric_path(struct
> 
>  			ipr_hcam_err(hostrcb, "%s %s: Resource Path=%s\n",
>  				     path_active_desc[i].desc, path_state_desc[j].desc,
> -				     ipr_format_resource_path(&fabric->res_path[0], &buffer[0]));
> +				     ipr_format_res_path(fabric->res_path, buffer,
> +							 sizeof(buffer)));
>  			return;
>  		}
>  	}
> 
>  	ipr_err("Path state=%02X Resource Path=%s\n", path_state,
> -		ipr_format_resource_path(&fabric->res_path[0], &buffer[0]));
> +		ipr_format_res_path(fabric->res_path, buffer, sizeof(buffer)));
>  }
> 
>  static const struct {
> @@ -2066,7 +2071,8 @@ static void ipr_log64_path_elem(struct i
> 
>  			ipr_hcam_err(hostrcb, "%s %s: Resource Path=%s, Link rate=%s, WWN=%08X%08X\n",
>  				     path_status_desc[j].desc, path_type_desc[i].desc,
> -				     ipr_format_resource_path(&cfg->res_path[0], &buffer[0]),
> +				     ipr_format_res_path(cfg->res_path, buffer,
> +							 sizeof(buffer)),
>  				     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
>  				     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
>  			return;
> @@ -2074,7 +2080,7 @@ static void ipr_log64_path_elem(struct i
>  	}
>  	ipr_hcam_err(hostrcb, "Path element=%02X: Resource Path=%s, Link rate=%s "
>  		     "WWN=%08X%08X\n", cfg->type_status,
> -		     ipr_format_resource_path(&cfg->res_path[0], &buffer[0]),
> +		     ipr_format_res_path(cfg->res_path, buffer, sizeof(buffer)),
>  		     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
>  		     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
>  }
> @@ -2139,7 +2145,7 @@ static void ipr_log_sis64_array_error(st
> 
>  	ipr_err("RAID %s Array Configuration: %s\n",
>  		error->protection_level,
> -		ipr_format_resource_path(&error->last_res_path[0], &buffer[0]));
> +		ipr_format_res_path(error->last_res_path, buffer, sizeof(buffer)));
> 
>  	ipr_err_separator;
> 
> @@ -2160,9 +2166,11 @@ static void ipr_log_sis64_array_error(st
>  		ipr_err("Array Member %d:\n", i);
>  		ipr_log_ext_vpd(&array_entry->vpd);
>  		ipr_err("Current Location: %s",
> -			 ipr_format_resource_path(&array_entry->res_path[0], &buffer[0]));
> +			 ipr_format_res_path(array_entry->res_path, buffer,
> +					     sizeof(buffer)));
>  		ipr_err("Expected Location: %s",
> -			 ipr_format_resource_path(&array_entry->expected_res_path[0], &buffer[0]));
> +			 ipr_format_res_path(array_entry->expected_res_path,
> +					     buffer, sizeof(buffer)));
> 
>  		ipr_err_separator;
>  	}
> @@ -4076,7 +4084,8 @@ static struct device_attribute ipr_adapt
>  };
> 
>  /**
> - * ipr_show_resource_path - Show the resource path for this device.
> + * ipr_show_resource_path - Show the resource path or the resource address for
> + *			    this device.
>   * @dev:	device struct
>   * @buf:	buffer
>   *
> @@ -4094,9 +4103,14 @@ static ssize_t ipr_show_resource_path(st
> 
>  	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
>  	res = (struct ipr_resource_entry *)sdev->hostdata;
> -	if (res)
> +	if (res && ioa_cfg->sis64)
>  		len = snprintf(buf, PAGE_SIZE, "%s\n",
> -			       ipr_format_resource_path(&res->res_path[0], &buffer[0]));
> +			       ipr_format_res_path(res->res_path, buffer,
> +						   sizeof(buffer)));
> +	else if (res)
> +		len = snprintf(buf, PAGE_SIZE, "%d:%d:%d:%d\n", ioa_cfg->host->host_no,
> +			       res->bus, res->target, res->lun);
> +
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  	return len;
>  }
> @@ -4348,7 +4362,8 @@ static int ipr_slave_configure(struct sc
>  			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
>  		if (ioa_cfg->sis64)
>  			sdev_printk(KERN_INFO, sdev, "Resource path: %s\n",
> -			            ipr_format_resource_path(&res->res_path[0], &buffer[0]));
> +				    ipr_format_res_path(res->res_path, buffer,
> +							sizeof(buffer)));
>  		return 0;
>  	}
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2010-05-26 16:01:22.000000000 -0700
> +++ b/drivers/scsi/ipr.h	2010-06-03 15:41:13.000000000 -0700
> @@ -1684,8 +1684,9 @@ struct ipr_ucode_image_header {
>  	if (ipr_is_device(hostrcb)) {					\
>  		if ((hostrcb)->ioa_cfg->sis64) {			\
>  			printk(KERN_ERR IPR_NAME ": %s: " fmt, 		\
> -				ipr_format_resource_path(&hostrcb->hcam.u.error64.fd_res_path[0], \
> -					&hostrcb->rp_buffer[0]),	\
> +				ipr_format_res_path(hostrcb->hcam.u.error64.fd_res_path, \
> +					hostrcb->rp_buffer,		\
> +					sizeof(hostrcb->rp_buffer)),	\
>  				__VA_ARGS__);				\
>  		} else {						\
>  			ipr_ra_err((hostrcb)->ioa_cfg,			\
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


