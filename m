From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v1 1/1] [SCSI] enclosure: Handle non-unique element
 descriptors
Date: Wed, 01 Oct 2014 11:31:38 -0400
Message-ID: <1412177498.5299.33.camel@jarvis>
References: <be2f680f-81da-4f33-9454-4555de3c179d@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46086 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbaJAPbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 11:31:45 -0400
In-Reply-To: <be2f680f-81da-4f33-9454-4555de3c179d@EXCHANGE.collogia.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2014-10-01 at 15:10 +0000, Markus Stockhausen wrote:
> [SCSI] enclosure: Handle non-unique element descriptors
> 
> Some SES devices give non-unique Element Descriptors as part of the
> Element Descriptor diag page. Since we use these for creating sysfs
> entries, they need to be unique. The specification doesn't require
> these to be unique.
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
> 
> Based on http://thread.gmane.org/gmane.linux.scsi/69289. This
> version implements James' ideas about the naming convention
> 
> Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>
> 
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 2cf2bbc..824a8d7 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -187,6 +187,7 @@ void enclosure_unregister(struct enclosure_device *edev)
>  EXPORT_SYMBOL_GPL(enclosure_unregister);
>  
>  #define ENCLOSURE_NAME_SIZE	64
> +#define COMPONENT_NAME_SIZE	64
>  
>  static void enclosure_link_name(struct enclosure_component *cdev, char *name)
>  {
> @@ -246,6 +247,29 @@ static void enclosure_component_release(struct device *dev)
>  	put_device(dev->parent);
>  }
>  
> +struct enclosure_component *
> +enclosure_component_find_by_name(struct enclosure_device *edev,
> +				const char *name)
> +{
> +	int i;
> +	const char *cname;
> +	struct enclosure_component *ecomp;
> +
> +	if (!edev || !name || !name[0])
> +		return NULL;
> +
> +	for (i=0; i<edev->components; i++) {
> +		ecomp = &edev->component[i];
> +		cname = dev_name(&ecomp->cdev);
> +		if (ecomp->number != -1 &&
> +		    cname && cname[0] &&
> +		    !strcmp(cname, name))
> +			return ecomp;
> +	}
> +
> +	return NULL;
> +}
> +
>  static const struct attribute_group *enclosure_component_groups[];
>  
>  /**
> @@ -269,7 +293,8 @@ enclosure_component_register(struct enclosure_device *edev,
>  {
>  	struct enclosure_component *ecomp;
>  	struct device *cdev;
> -	int err;
> +	int err, i;
> +	char newname[COMPONENT_NAME_SIZE];
>  
>  	if (number >= edev->components)
>  		return ERR_PTR(-EINVAL);
> @@ -283,9 +308,21 @@ enclosure_component_register(struct enclosure_device *edev,
>  	ecomp->number = number;
>  	cdev = &ecomp->cdev;
>  	cdev->parent = get_device(&edev->edev);
> -	if (name && name[0])
> -		dev_set_name(cdev, "%s", name);
> -	else
> +
> +	if (name && name[0]) {
> +		/* Some hardware (e.g. enclosure in RX300 S6) has components
> +		 * with non unique names. Registering duplicates in sysfs
> +		 * will lead to warnings during bootup. So make the names
> +		 * unique by appending consecutive numbers -1, -2, ... */
> +		i = 1;
> +		snprintf(newname, COMPONENT_NAME_SIZE,
> +			 "%s", name);
> +		while (i < 255 &&
> +		       enclosure_component_find_by_name (edev, newname))
> +			snprintf(newname, COMPONENT_NAME_SIZE,
> +				 "%s-%i", name, i++);

We need error handling here (what happens when i becomes 255).  Since
it's iterating through a unique name space, I think you can just let the
loop be unbounded because if it's not, the system will run out of memory
before we get into an apparently endless loop.

After fixing this, you can add my acked-by.

James

> +		dev_set_name(cdev, "%s", newname);
> +	} else
>  		dev_set_name(cdev, "%u", number);
>  
>  	cdev->release = enclosure_component_release;


