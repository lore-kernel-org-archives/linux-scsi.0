From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Round II on sysfs attributes
Date: Fri, 23 May 2003 11:30:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030523113003.A15369@beaverton.ibm.com>
References: <1053707904.1810.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:64407 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264124AbTEWSUx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 14:20:53 -0400
Content-Disposition: inline
In-Reply-To: <1053707904.1810.4.camel@mulgrave>; from James.Bottomley@steeleye.com on Fri, May 23, 2003 at 12:38:24PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

On Fri, May 23, 2003 at 12:38:24PM -0400, James Bottomley wrote:
> 
> The attached patch makes the sysfs attributes a property of the host
> template (I can't really see a reason why the actual attributes need to
> change per host, so I think the template is the better place for them).
> 
> I've also provided helper functions to modify the attributes in the LLD
> init routines.
> 
> An illustration of how this works for the 53c700 will follow.
> 
> James

Any examples of potential LLDD specific host attributes?

Looks good for modifying attributes.

For additional attributes, why not an LLDD specific function to add and
remove them?

> diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> --- a/drivers/scsi/hosts.c	Fri May 23 12:35:11 2003
> +++ b/drivers/scsi/hosts.c	Fri May 23 12:35:11 2003
> @@ -321,7 +321,12 @@
>             shost_tp->eh_host_reset_handler == NULL) {
>  		printk(KERN_ERR "ERROR: SCSI host `%s' has no error handling\nERROR: This is not a safe way to run your SCSI host\nERROR: The error handling must be added to this driver\n", shost_tp->proc_name);
>  		dump_stack();
> -        } 
> +        }
> +	if(shost_tp->shost_attrs == NULL)
> +		/* if its not set in the template, use the default */
> +		 shost_tp->shost_attrs = scsi_sysfs_shost_attrs;
> +	if(shost_tp->sdev_attrs == NULL)
> +		 shost_tp->sdev_attrs = scsi_sysfs_sdev_attrs;
>  	gfp_mask = GFP_KERNEL;
>  	if (shost_tp->unchecked_isa_dma && xtr_bytes)
>  		gfp_mask |= __GFP_DMA;

Code style nit: in the above and elsewhere use "if (", "for (" instead of
"if(" or  "for(".

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
> +		if(tmp_attrs == NULL)
> +			return -ENOMEM;
> +		memcpy(tmp_attrs, *class_attrs, sizeof(struct class_device_attribute)*num_attrs);
> +		if(*class_attrs != scsi_sysfs_shost_attrs)
> +			kfree(*class_attrs);
> +		*class_attrs = tmp_attrs;

For completeness, an allocated *class_attrs should be freed on LLDD module
exit. Same for the sdev attrs.

-- Patrick Mansfield
