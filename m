From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Round II on sysfs attributes
Date: Fri, 23 May 2003 11:51:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030523185150.GB1160@beaverton.ibm.com>
References: <1053707904.1810.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:23769 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264130AbTEWSgI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 14:36:08 -0400
Content-Disposition: inline
In-Reply-To: <1053707904.1810.4.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
>  static void scsi_device_release(struct device *dev)
> @@ -287,9 +290,9 @@
>  	if (error)
>  		return error;
>  
> -	for (i = 0; !error && i < ARRAY_SIZE(sdev_attrs); i++)
> +	for (i = 0; !error && sdev->host->hostt->sdev_attrs[i] != NULL; i++)
>  		error = device_create_file(&sdev->sdev_driverfs_dev,
> -					   sdev_attrs[i]);
> +					   sdev->host->hostt->sdev_attrs[i]);
>  
>  	if (error)
>  		scsi_device_unregister(sdev);

What about this style of bounds check.
for (i = 0; !error && sdev->host->hostt->sdev_attrs[i]; i++)

> +/** scsi_sysfs_modify_shost_attribute - modify or add a host class attribute
> + *
> + * @class_attrs:host class attribute list to be added to or modified
> + * @attr:	individual attribute to change or added
> + *
> + * returns zero if successful or error if not
> + **/
> +int scsi_sysfs_modify_shost_attribute(struct class_device_attribute ***class_attrs,
> +				      struct class_device_attribute *attr)
> +{
> +	int modify = 0;
> +	int num_attrs;
> +
> +	if(*class_attrs == NULL)
> +		*class_attrs = scsi_sysfs_shost_attrs;
> +
> +	for(num_attrs=0; (*class_attrs)[num_attrs] != NULL; num_attrs++)
> +		if(strcmp((*class_attrs)[num_attrs]->attr.name, attr->attr.name) == 0)
> +			modify = num_attrs;
> +
> +	if(*class_attrs == scsi_sysfs_shost_attrs || !modify) {
> +		struct class_device_attribute **tmp_attrs = kmalloc(sizeof(struct class_device_attribute)*(num_attrs + (modify ? 0 : 1)), GFP_KERNEL);

kfree of this memory in driver?

> +		if(tmp_attrs == NULL)
> +			return -ENOMEM;
> +		memcpy(tmp_attrs, *class_attrs, sizeof(struct class_device_attribute)*num_attrs);
> +		if(*class_attrs != scsi_sysfs_shost_attrs)
> +			kfree(*class_attrs);
> +		*class_attrs = tmp_attrs;
> +	}
> +	if(modify) {
> +		/* spare the caller from having to copy things it's
> +		 * not interested in */
> +		struct class_device_attribute *old_attr =
> +			(*class_attrs)[modify];
> +		/* extend permissions */
> +		attr->attr.mode |= old_attr->attr.mode;
> +
> +		/* override null show/store with default */
> +		if(attr->show == NULL)
> +			attr->show = old_attr->show;
> +		if(attr->store == NULL)
> +			attr->store = old_attr->store;
> +		(*class_attrs)[modify] = attr;
> +	} else {
> +		(*class_attrs)[num_attrs] = attr;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(scsi_sysfs_modify_shost_attribute);
> +

-andmike
--
Michael Anderson
andmike@us.ibm.com

