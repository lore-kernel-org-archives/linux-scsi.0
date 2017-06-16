From: Douglas Miller <dougmill@linux.vnet.ibm.com>
Subject: Re: [RFC] enclosure: fix sysfs symlinks creation when using multipath
Date: Fri, 16 Jun 2017 07:40:39 -0500
Message-ID: <12b5fa7f-3799-1223-db06-c233da3e7c33@linux.vnet.ibm.com>
References: <1486476528-27580-2-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34656 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752647AbdFPMkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 08:40:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5GCclH1113978
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2017 08:40:45 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b46mpy3uj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2017 08:40:44 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <dougmill@linux.vnet.ibm.com>;
        Fri, 16 Jun 2017 06:40:44 -0600
In-Reply-To: <1486476528-27580-2-git-send-email-mlombard@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

On 02/07/2017 08:08 AM, Maurizio Lombardi wrote:
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
>   drivers/misc/enclosure.c  | 16 ++++++++++++++--
>   include/linux/enclosure.h |  1 +
>   2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 65fed71..a856c98 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -375,21 +375,33 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
>   			 struct device *dev)
>   {
>   	struct enclosure_component *cdev;
> +	int error;
>   
>   	if (!edev || component >= edev->components)
>   		return -EINVAL;
>   
>   	cdev = &edev->component[component];
>   
> -	if (cdev->dev == dev)
> +	if (cdev->dev == dev) {
> +		if (!cdev->links_created) {
> +			error = enclosure_add_links(cdev);
> +			if (!error)
> +				cdev->links_created = 1;
> +		}
>   		return -EEXIST;
> +	}
>   
>   	if (cdev->dev)
>   		enclosure_remove_links(cdev);
>   
>   	put_device(cdev->dev);
>   	cdev->dev = get_device(dev);
> -	return enclosure_add_links(cdev);
> +	error = enclosure_add_links(cdev);
> +	if (!error)
> +		cdev->links_created = 1;
> +	else
> +		cdev->links_created = 0;
> +	return error;
>   }
>   EXPORT_SYMBOL_GPL(enclosure_add_device);
>   
> diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
> index a4cf57c..c3bdc4c 100644
> --- a/include/linux/enclosure.h
> +++ b/include/linux/enclosure.h
> @@ -97,6 +97,7 @@ struct enclosure_component {
>   	struct device cdev;
>   	struct device *dev;
>   	enum enclosure_component_type type;
> +	int links_created;
>   	int number;
>   	int fault;
>   	int active;

Tested-by: Douglas Miller <dougmill@linux.vnet.ibm.com>

I'd like to add that we are seeing this problem with singlepath 
installations and need to get this fixed upstream as soon as possible. 
RHEL new product contains this fix and is working for us, but we need to 
be able to offer other distros as well. I am currently running this 
patch on a custom-built Ubuntu 16.04.2 kernel and it is fixing the 
problem there.

What needs to be done to get this patch accepted?

Thanks,
Doug
