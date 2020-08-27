Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BB5C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 07:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199F822BED
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 07:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgH0HZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:25:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:41702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbgH0HZK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 03:25:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 03E1EAC2B;
        Thu, 27 Aug 2020 07:25:40 +0000 (UTC)
Subject: Re: [PATCH 01/19] char_dev: replace cdev_map with an xarray
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
References: <20200826062446.31860-1-hch@lst.de>
 <20200826062446.31860-2-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <b2126993-b861-1899-bb42-cb7f461094d4@suse.de>
Date:   Thu, 27 Aug 2020 09:25:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200826062446.31860-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/26/20 8:24 AM, Christoph Hellwig wrote:
> None of the complicated overlapping regions bits of the kobj_map are
> required for the character device lookup, so just a trivial xarray
> instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/char_dev.c | 94 +++++++++++++++++++++++++--------------------------
>  fs/dcache.c   |  1 -
>  fs/internal.h |  5 ---
>  3 files changed, 46 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/char_dev.c b/fs/char_dev.c
> index ba0ded7842a779..6c4d6c4938f14b 100644
> --- a/fs/char_dev.c
> +++ b/fs/char_dev.c
> @@ -17,7 +17,6 @@
>  #include <linux/seq_file.h>
>  
>  #include <linux/kobject.h>
> -#include <linux/kobj_map.h>
>  #include <linux/cdev.h>
>  #include <linux/mutex.h>
>  #include <linux/backing-dev.h>
> @@ -25,8 +24,7 @@
>  
>  #include "internal.h"
>  
> -static struct kobj_map *cdev_map;
> -
> +static DEFINE_XARRAY(cdev_map);
>  static DEFINE_MUTEX(chrdevs_lock);
>  
>  #define CHRDEV_MAJOR_HASH_SIZE 255
> @@ -367,6 +365,29 @@ void cdev_put(struct cdev *p)
>  	}
>  }
>  
> +static struct cdev *cdev_lookup(dev_t dev)
> +{
> +	struct cdev *cdev;
> +
> +retry:
> +	mutex_lock(&chrdevs_lock);
> +	cdev = xa_load(&cdev_map, dev);
> +	if (!cdev) {
> +		mutex_unlock(&chrdevs_lock);
> +
> +		if (request_module("char-major-%d-%d",
> +				   MAJOR(dev), MINOR(dev)) > 0)
> +			/* Make old-style 2.4 aliases work */
> +			request_module("char-major-%d", MAJOR(dev));
> +		goto retry;
> +	}
> +
> +	if (!cdev_get(cdev))
> +		cdev = NULL;
> +	mutex_unlock(&chrdevs_lock);
> +	return cdev;
> +}
> +
>  /*
>   * Called every time a character special file is opened
>   */
> @@ -380,13 +401,10 @@ static int chrdev_open(struct inode *inode, struct file *filp)
>  	spin_lock(&cdev_lock);
>  	p = inode->i_cdev;
>  	if (!p) {
> -		struct kobject *kobj;
> -		int idx;
>  		spin_unlock(&cdev_lock);
> -		kobj = kobj_lookup(cdev_map, inode->i_rdev, &idx);
> -		if (!kobj)
> +		new = cdev_lookup(inode->i_rdev);
> +		if (!new)
>  			return -ENXIO;
> -		new = container_of(kobj, struct cdev, kobj);
>  		spin_lock(&cdev_lock);
>  		/* Check i_cdev again in case somebody beat us to it while
>  		   we dropped the lock. */
> @@ -454,18 +472,6 @@ const struct file_operations def_chr_fops = {
>  	.llseek = noop_llseek,
>  };
>  
> -static struct kobject *exact_match(dev_t dev, int *part, void *data)
> -{
> -	struct cdev *p = data;
> -	return &p->kobj;
> -}
> -
> -static int exact_lock(dev_t dev, void *data)
> -{
> -	struct cdev *p = data;
> -	return cdev_get(p) ? 0 : -1;
> -}
> -
>  /**
>   * cdev_add() - add a char device to the system
>   * @p: the cdev structure for the device
> @@ -478,7 +484,7 @@ static int exact_lock(dev_t dev, void *data)
>   */
>  int cdev_add(struct cdev *p, dev_t dev, unsigned count)
>  {
> -	int error;
> +	int error, i;
>  
>  	p->dev = dev;
>  	p->count = count;
> @@ -486,14 +492,22 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
>  	if (WARN_ON(dev == WHITEOUT_DEV))
>  		return -EBUSY;
>  
> -	error = kobj_map(cdev_map, dev, count, NULL,
> -			 exact_match, exact_lock, p);
> -	if (error)
> -		return error;
> +	mutex_lock(&chrdevs_lock);
> +	for (i = 0; i < count; i++) {
> +		error = xa_insert(&cdev_map, dev + i, p, GFP_KERNEL);
> +		if (error)
> +			goto out_unwind;
> +	}
> +	mutex_unlock(&chrdevs_lock);
>  
>  	kobject_get(p->kobj.parent);
> -
>  	return 0;
> +
> +out_unwind:
> +	while (--i >= 0)
> +		xa_erase(&cdev_map, dev + i);
> +	mutex_unlock(&chrdevs_lock);
> +	return error;
>  }
>  
>  /**
Do you really need the mutex?
Wouldn't xa_store_range() be better and avoid the mutex?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
