From: Douglas Miller <dougmill@linux.vnet.ibm.com>
Subject: Re: enclosure: fix sysfs symlinks creation when using multipath
Date: Fri, 16 Jun 2017 10:41:22 -0500
Message-ID: <1998341d-7f47-f73a-c5c5-4095b7fa9ef1@linux.vnet.ibm.com>
References: <1489690155.11068.10.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60313 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752672AbdFPPla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 11:41:30 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5GFdKmR035302
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2017 11:41:30 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b4j2v8877-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2017 11:41:29 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <dougmill@linux.vnet.ibm.com>;
        Fri, 16 Jun 2017 09:41:28 -0600
In-Reply-To: <1489690155.11068.10.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 03/16/2017 01:49 PM, James Bottomley wrote:
> On Wed, 2017-03-15 at 19:39 -0400, Martin K. Petersen wrote:
>> Maurizio Lombardi <mlombard@redhat.com> writes:
>>
>>> With multipath, it may happen that the same device is passed to
>>> enclosure_add_device() multiple times and that the
>>> enclosure_add_links() function fails to create the symlinks because
>>> the device's sysfs directory entry is still NULL.  In this case,
>>> the
>>> links will never be created because all the subsequent calls to
>>> enclosure_add_device() will immediately fail with EEXIST.
>> James?
> Well I don't think the patch is the correct way to do this.  The
> problem is that if we encounter an error creating the links, we
> shouldn't add the device to the enclosure.  There's no need of a
> links_created variable (see below).
>
> However, more interesting is why the link creation failed in the first
> place.  The device clearly seems to exist because it was added to sysfs
> at time index 19.2 and the enclosure didn't try to use it until 60.0.
>   Can you debug this a bit more, please?  I can't see anything specific
> to multipath in the trace, so whatever this is looks like it could
> happen in the single path case as well.
>
> James
>
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 65fed71..ae89082 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -375,6 +375,7 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
>   			 struct device *dev)
>   {
>   	struct enclosure_component *cdev;
> +	int err;
>   
>   	if (!edev || component >= edev->components)
>   		return -EINVAL;
> @@ -384,12 +385,15 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
>   	if (cdev->dev == dev)
>   		return -EEXIST;
>   
> -	if (cdev->dev)
> +	if (cdev->dev) {
>   		enclosure_remove_links(cdev);
> -
> -	put_device(cdev->dev);
> -	cdev->dev = get_device(dev);
> -	return enclosure_add_links(cdev);
> +		put_device(cdev->dev);
> +		cdev->dev = NULL;
> +	}
> +	err = enclosure_add_links(cdev);
> +	if (!err)
> +		cdev->dev = get_device(dev);
> +	return err;
>   }
>   EXPORT_SYMBOL_GPL(enclosure_add_device);
>   
After stumbling across the NULL pointer panic, I was able to use 
Maurizio's second patch below:

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 65fed71..6ac07ea 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -375,6 +375,7 @@ int enclosure_add_device(struct enclosure_device 
*edev, int component,
                          struct device *dev)
  {
         struct enclosure_component *cdev;
+       int err;

         if (!edev || component >= edev->components)
                 return -EINVAL;
@@ -384,12 +385,17 @@ int enclosure_add_device(struct enclosure_device 
*edev, int component,
         if (cdev->dev == dev)
                 return -EEXIST;

-       if (cdev->dev)
+       if (cdev->dev) {
                 enclosure_remove_links(cdev);
-
-       put_device(cdev->dev);
+               put_device(cdev->dev);
+       }
         cdev->dev = get_device(dev);
-       return enclosure_add_links(cdev);
+       err = enclosure_add_links(cdev);
+       if (err) {
+               cdev->dev = NULL;
+               put_device(cdev->dev);
+       }
+       return err;
  }
  EXPORT_SYMBOL_GPL(enclosure_add_device);


I am able to pass my testing with this patch. I don't see an official 
submit of this patch, but will respond to it when I see one. Again, I am 
seeing the problem even without multipath.
