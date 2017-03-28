From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] enclosure: fix sysfs symlinks creation when using
 multipath
Date: Tue, 28 Mar 2017 10:13:49 +0200
Message-ID: <632c31c2-13c0-91da-5ec0-0d66adbc9cf1@redhat.com>
References: <1488454204-21251-1-git-send-email-mlombard@redhat.com>
 <yq1varaf6to.fsf@oracle.com> <1489690155.11068.10.camel@linux.vnet.ibm.com>
 <91d089dc-4809-d9e4-47b5-56eae40a25c8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754568AbdC1IOb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Mar 2017 04:14:31 -0400
In-Reply-To: <91d089dc-4809-d9e4-47b5-56eae40a25c8@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org



Dne 21.3.2017 v 10:58 Maurizio Lombardi napsal(a):

> I will ask our customer to test your patch,
> there is only a small problem: you can't set cdev->dev = NULL
> and then call enclosure_add_links(cdev) because you will end up dereferencing
> a NULL pointer.
> I suggest a slightly different patch:
> 
> @@ -375,6 +379,7 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
>  			 struct device *dev)
>  {
>  	struct enclosure_component *cdev;
> +	int err;
>  
>  	if (!edev || component >= edev->components)
>  		return -EINVAL;
> @@ -384,12 +389,18 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
>  	if (cdev->dev == dev)
>  		return -EEXIST;
>  
> -	if (cdev->dev)
> +	if (cdev->dev) {
>  		enclosure_remove_links(cdev);
> -
> -	put_device(cdev->dev);
> +		put_device(cdev->dev);
> +	}
>  	cdev->dev = get_device(dev);
> -	return enclosure_add_links(cdev);
> +
> +	err = enclosure_add_links(cdev);
> +	if (err) {
> +		put_device(cdev->dev);
> +		cdev->dev = NULL;
> +	}
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(enclosure_add_device);


Our customer confirms that this patch solves his issues with enclosures' symlinks.
