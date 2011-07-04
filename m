From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ses: Handle non-unique element descriptors
Date: Mon, 04 Jul 2011 10:35:24 -0500
Message-ID: <1309793724.2606.19.camel@mulgrave>
References: <4E11D946.4050307@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54257 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419Ab1GDPf2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2011 11:35:28 -0400
In-Reply-To: <4E11D946.4050307@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ankit Jain <jankit@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

On Mon, 2011-07-04 at 20:46 +0530, Ankit Jain wrote:
> Some SES devices give non-unique Element Descriptors as part of the
> Element Descriptor diag page. Since we use these for creating sysfs
> entries, they need to be unique.
> 
> Eg:
> $ sg_ses -p 7 /dev/sg0
>   FTS CORP  TXS6_SAS20BPX12   0500
>     enclosure services device
> Element descriptor In diagnostic page:
>   generation code: 0x0
>   element descriptor by type list
>     Element type: Array device, subenclosure id: 0
>       Overall descriptor: ArrayDevicesInSubEnclsr0
>       Element 1 descriptor: ArrayDevice00
>       Element 2 descriptor: ArrayDevice01
>       Element 3 descriptor: ArrayDevice02
>       Element 4 descriptor: ArrayDevice03
>       Element 5 descriptor: ArrayDevice03
>       Element 6 descriptor: ArrayDevice03
>       Element 7 descriptor: ArrayDevice03
>       Element 8 descriptor: ArrayDevice03
>       Element 9 descriptor: ArrayDevice03
>       Element 10 descriptor: ArrayDevice03
>       Element 11 descriptor: ArrayDevice03
>       Element 12 descriptor: ArrayDevice03

What is the external visible labelling of this topology?  It's
completely weird that the enclosure would burn in non-unique names
unless there's some reason for it.

> Signed-off-by: Ankit Jain <jankit@suse.de>
> 
> ---
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 00e5fca..8087055 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -239,6 +239,24 @@ static void enclosure_component_release(struct device *dev)
>  	put_device(dev->parent);
>  }
>  
> +struct enclosure_component *
> +enclosure_component_find_by_name(struct enclosure_device *edev,
> +				const char *name)
> +{
> +	int i;
> +	if (!edev || !name || !name[0])
> +		return NULL;
> +
> +	for (i=0; i<edev->components; i++) {
> +		struct enclosure_component *ecomp = &edev->component[i];
> +		if (ecomp->number != -1 && !strcmp(dev_name(&ecomp->cdev), name))
> +			return ecomp;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(enclosure_component_find_by_name);
> +
>  static const struct attribute_group *enclosure_groups[];
>  
>  /**
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index eba183c..abfd962 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -421,12 +421,17 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
>  			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
>  			    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE) {
>  
> -				if (create)
> +				if (create) {
> +					if (enclosure_component_find_by_name(edev, name))
> +						/* name is not unique, already used
> +						 * set to NULL, so that enclosure_component_register
> +						 * will assign us a new one */
> +						name = NULL;

This just assigns a random name ... if we actually have one, we should
probably just make it unique.

James


>  					ecomp =	enclosure_component_register(edev,
>  									     components++,
>  									     type_ptr[0],
>  									     name);
> -				else
> +				} else
>  					ecomp = &edev->component[components++];
>  
>  				if (!IS_ERR(ecomp) && addl_desc_ptr)
> diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
> index 9a33c5f..7e48ba9 100644
> --- a/include/linux/enclosure.h
> +++ b/include/linux/enclosure.h
> @@ -122,6 +122,8 @@ void enclosure_unregister(struct enclosure_device *);
>  struct enclosure_component *
>  enclosure_component_register(struct enclosure_device *, unsigned int,
>  				 enum enclosure_component_type, const char *);
> +struct enclosure_component *
> +enclosure_component_find_by_name(struct enclosure_device *, const char *);
>  int enclosure_add_device(struct enclosure_device *enclosure, int component,
>  			 struct device *dev);
>  int enclosure_remove_device(struct enclosure_device *, struct device *);


