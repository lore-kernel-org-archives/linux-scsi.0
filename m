From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: fix resource address formatting and add attribute
 for device ID
Date: Wed, 11 Aug 2010 09:32:02 -0500
Message-ID: <4C62B462.8030906@linux.vnet.ibm.com>
References: <20100810160721.438853503@linux.vnet.ibm.com> <4C617A7A.5070906@linux.vnet.ibm.com> <4C61B76F.3050100@linux.vnet.ibm.com> <4C62B075.4000309@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54894 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab0HKOcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2010 10:32:10 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7BEI0ts023121
	for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2010 10:18:00 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o7BEVxf0251596
	for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2010 10:31:59 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o7BEVx82004484
	for <linux-scsi@vger.kernel.org>; Wed, 11 Aug 2010 11:31:59 -0300
In-Reply-To: <4C62B075.4000309@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 08/11/2010 09:15 AM, Wayne Boyer wrote:
> On 8/10/10 1:32 PM, Brian King wrote:
>> On 08/10/2010 11:12 AM, Wayne Boyer wrote:
>>> Index: b/drivers/scsi/ipr.h
>>> ===================================================================
>>> --- a/drivers/scsi/ipr.h	2010-08-05 11:23:35.000000000 -0700
>>> +++ b/drivers/scsi/ipr.h	2010-08-09 10:09:04.000000000 -0700
>>> @@ -372,7 +372,7 @@ struct ipr_config_table_entry {
>>>
>>>  	struct ipr_res_addr res_addr;
>>>  	__be32 res_handle;
>>> -	__be32 reserved4[2];
>>> +	__be64 lun_wwn;
> 
>>
>> This should be two __be32's or just an array of u8's instead,
>> since this field is not aligned on an 8 byte boundary. You can
>> use the unaligned accessors to make it easier to deal with.
>>
> 
> Here's the updated patch.  The field in question was lun_wwn in the
> ipr_res_addr structure.
> 
> ---
> 
> This patch fixes a resource address formatting problem where the first byte
> was being zeroed out.
> 
> Also, the device ID is now made available as a sysfs attribute.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ipr.h |    4 +++-
>  2 files changed, 45 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2010-08-02 17:28:18.000000000 -0700
> +++ b/drivers/scsi/ipr.c	2010-08-10 17:04:51.000000000 -0700
> @@ -1096,6 +1096,7 @@ static void ipr_init_res_entry(struct ip
>  		res->bus = cfgtew->u.cfgte->res_addr.bus;
>  		res->target = cfgtew->u.cfgte->res_addr.target;
>  		res->lun = cfgtew->u.cfgte->res_addr.lun;
> +		res->lun_wwn = get_unaligned_be64(cfgtew->u.cfgte->lun_wwn);
>  	}
> 
>  	ipr_update_ata_class(res, proto);
> @@ -1142,7 +1143,7 @@ static char *ipr_format_res_path(u8 *res
>  	int i;
>  	char *p = buffer;
> 
> -	res_path[0] = '\0';
> +	*p = '\0';
>  	p += snprintf(p, buffer + len - p, "%02X", res_path[0]);
>  	for (i = 1; res_path[i] != 0xff && ((i * 3) < len); i++)
>  		p += snprintf(p, buffer + len - p, "-%02X", res_path[i]);
> @@ -4086,6 +4087,7 @@ static int ipr_change_queue_type(struct 
>  /**
>   * ipr_show_adapter_handle - Show the adapter's resource handle for this device
>   * @dev:	device struct
> + * @attr:	device attribute structure
>   * @buf:	buffer
>   *
>   * Return value:
> @@ -4119,6 +4121,7 @@ static struct device_attribute ipr_adapt
>   * ipr_show_resource_path - Show the resource path or the resource address for
>   *			    this device.
>   * @dev:	device struct
> + * @attr:	device attribute structure
>   * @buf:	buffer
>   *
>   * Return value:
> @@ -4156,8 +4159,45 @@ static struct device_attribute ipr_resou
>  };
> 
>  /**
> + * ipr_show_device_id - Show the device_id for this device.
> + * @dev:	device struct
> + * @attr:	device attribute structure
> + * @buf:	buffer
> + *
> + * Return value:
> + *	number of bytes printed to buffer
> + **/
> +static ssize_t ipr_show_device_id(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
> +	struct ipr_resource_entry *res;
> +	unsigned long lock_flags = 0;
> +	ssize_t len = -ENXIO;
> +
> +	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> +	res = (struct ipr_resource_entry *)sdev->hostdata;
> +	if (res && ioa_cfg->sis64)
> +		len = snprintf(buf, PAGE_SIZE, "0x%llx\n", res->dev_id);
> +	else if (res)
> +		len = snprintf(buf, PAGE_SIZE, "0x%llx\n", res->lun_wwn);
> +
> +	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> +	return len;
> +}
> +
> +static struct device_attribute ipr_device_id_attr = {
> +	.attr = {
> +		.name =		"device_id",
> +		.mode =		S_IRUGO,
> +	},
> +	.show = ipr_show_device_id
> +};
> +
> +/**
>   * ipr_show_resource_type - Show the resource type for this device.
>   * @dev:	device struct
> + * @attr:	device attribute structure
>   * @buf:	buffer
>   *
>   * Return value:
> @@ -4192,6 +4232,7 @@ static struct device_attribute ipr_resou
>  static struct device_attribute *ipr_dev_attrs[] = {
>  	&ipr_adapter_handle_attr,
>  	&ipr_resource_path_attr,
> +	&ipr_device_id_attr,
>  	&ipr_resource_type_attr,
>  	NULL,
>  };
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2010-08-05 11:23:35.000000000 -0700
> +++ b/drivers/scsi/ipr.h	2010-08-10 22:03:14.000000000 -0700
> @@ -26,6 +26,7 @@
>  #ifndef _IPR_H
>  #define _IPR_H
> 
> +#include <asm/unaligned.h>
>  #include <linux/types.h>
>  #include <linux/completion.h>
>  #include <linux/libata.h>
> @@ -372,7 +373,7 @@ struct ipr_config_table_entry {
> 
>  	struct ipr_res_addr res_addr;
>  	__be32 res_handle;
> -	__be32 reserved4[2];
> +	__be32 lun_wwn[2];
>  	struct ipr_std_inq_data std_inq_data;
>  }__attribute__ ((packed, aligned (4)));
> 
> @@ -1210,6 +1211,7 @@ struct ipr_resource_entry {
> 
>  	__be32 res_handle;
>  	__be64 dev_id;
> +	__be64 lun_wwn;
>  	struct scsi_lun dev_lun;
>  	u8 res_path[8];
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


