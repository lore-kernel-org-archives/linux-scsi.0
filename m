From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH RFC] enclosure: fix sysfs symlinks creation when using
 multipath
Date: Thu, 16 Feb 2017 14:13:23 +0100
Message-ID: <d57f3221-ce38-7c12-d70c-28c1bd6db973@redhat.com>
References: <1486476528-27580-1-git-send-email-mlombard@redhat.com>
 <1486476528-27580-2-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753526AbdBPNN0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 08:13:26 -0500
In-Reply-To: <1486476528-27580-2-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi James,

have you noticed this patch?


Dne 7.2.2017 v 15:08 Maurizio Lombardi napsal(a):
> With multipath, it may happen that the same device is passed
> to enclosure_add_device() multiple times and that the enclosure_add_links()
> function fails to create the symlinks because the device's sysfs
> directory entry is still NULL.
> In this case, the links will never be created because all the subsequent
> calls to enclosure_add_device() will immediately fail with EEXIST.
> 
> This patch modifies the code so the driver will detect this condition
> and will retry to create the symlinks when enclosure_add_device() is called.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/misc/enclosure.c  | 16 ++++++++++++++--
>  include/linux/enclosure.h |  1 +
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 65fed71..a856c98 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -375,21 +375,33 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
>  			 struct device *dev)
>  {
>  	struct enclosure_component *cdev;
> +	int error;
>  
>  	if (!edev || component >= edev->components)
>  		return -EINVAL;
>  
>  	cdev = &edev->component[component];
>  
> -	if (cdev->dev == dev)
> +	if (cdev->dev == dev) {
> +		if (!cdev->links_created) {
> +			error = enclosure_add_links(cdev);
> +			if (!error)
> +				cdev->links_created = 1;
> +		}
>  		return -EEXIST;
> +	}
>  
>  	if (cdev->dev)
>  		enclosure_remove_links(cdev);
>  
>  	put_device(cdev->dev);
>  	cdev->dev = get_device(dev);
> -	return enclosure_add_links(cdev);
> +	error = enclosure_add_links(cdev);
> +	if (!error)
> +		cdev->links_created = 1;
> +	else
> +		cdev->links_created = 0;
> +	return error;
>  }
>  EXPORT_SYMBOL_GPL(enclosure_add_device);
>  
> diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
> index a4cf57c..c3bdc4c 100644
> --- a/include/linux/enclosure.h
> +++ b/include/linux/enclosure.h
> @@ -97,6 +97,7 @@ struct enclosure_component {
>  	struct device cdev;
>  	struct device *dev;
>  	enum enclosure_component_type type;
> +	int links_created;
>  	int number;
>  	int fault;
>  	int active;
> 
