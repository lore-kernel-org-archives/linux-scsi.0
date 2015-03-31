From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH RESUBMIT] Enclosure: fix WARN ON when doing dlpar
 removing an adapter in dual patch devices
Date: Mon, 30 Mar 2015 20:28:47 -0400
Message-ID: <20150330202847.Horde.PYpAb4tX-yK6l4jH6FbvSg1@ltc.linux.ibm.com>
References: <1426717101-26910-1-git-send-email-wenxiong@linux.vnet.ibm.com>
 <1426719376.2307.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39243 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbbCaA2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2015 20:28:51 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Mon, 30 Mar 2015 20:28:50 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id D75C9C90041
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2015 20:19:57 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2V0Sm1x26870006
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 00:28:48 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2V0SlL2010166
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2015 20:28:48 -0400
In-Reply-To: <1426719376.2307.36.camel@HansenPartnership.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, wenxiong@us.ibm.com

Hi James,

Thanks for your patch! I got a chance to test your patch today and it works.

Thanks,
Wendy

Quoting James Bottomley <James.Bottomley@hansenpartnership.com>:

> On Wed, 2015-03-18 at 17:18 -0500, wenxiong@linux.vnet.ibm.com wrote:
>> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>>
>> Hi James,
>>
>> Our test teams still see lots of these errors in error log when  
>> dlpar removing
>> the adapter in dual configuration. So I re-submit the patch.
>
> OK so in this case you have two struct devices for one bay (one for each
> path).  The links are screwed up because a bay only points at one device
> (although each device points to an enclosure).
>
> We have a check, so the enclosure backlink points to the first device it
> encountered.
>
> The scope for cockups in this situation is huge (like if the device the
> enclosure points to gets removed
>
>> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
>> index 38552a3..0d20e19 100644
>> --- a/drivers/misc/enclosure.c
>> +++ b/drivers/misc/enclosure.c
>> @@ -209,6 +209,9 @@ static void enclosure_remove_links(struct  
>> enclosure_component *cdev)
>>  	if (!cdev->dev->kobj.sd)
>>  		return;
>>
>> +	if (!cdev->cdev.kobj.sd)
>> +		return;
>> +
>>  	enclosure_link_name(cdev, name);
>>  	sysfs_remove_link(&cdev->dev->kobj, name);
>>  	sysfs_remove_link(&cdev->cdev.kobj, "device");
>
> This doesn't look right: for this to work it means you have to have a
> dev with a kernfs link but a cdev without one.  We probably still need
> to remove the dangling dev link.
>
> Does this work?  It should remove either link if they exist.
>
> James
>
> ---
>
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 38552a3..65fed71 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -202,16 +202,17 @@ static void enclosure_remove_links(struct  
> enclosure_component *cdev)
>  {
>  	char name[ENCLOSURE_NAME_SIZE];
>
> +	enclosure_link_name(cdev, name);
> +
>  	/*
>  	 * In odd circumstances, like multipath devices, something else may
>  	 * already have removed the links, so check for this condition first.
>  	 */
> -	if (!cdev->dev->kobj.sd)
> -		return;
> +	if (cdev->dev->kobj.sd)
> +		sysfs_remove_link(&cdev->dev->kobj, name);
>
> -	enclosure_link_name(cdev, name);
> -	sysfs_remove_link(&cdev->dev->kobj, name);
> -	sysfs_remove_link(&cdev->cdev.kobj, "device");
> +	if (cdev->cdev.kobj.sd)
> +		sysfs_remove_link(&cdev->cdev.kobj, "device");
>  }
>
>  static int enclosure_add_links(struct enclosure_component *cdev)


