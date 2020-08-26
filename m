Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E45AC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 08:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54147206FA
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 08:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598429939;
	bh=+vJV+mRF0Lzjjr3fr3A1d25Ht5edbPCfJqUZ9mJTuZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xnkUtjWm2mGMGvvlneyGGbfdkrI4vZ/kEXdNuhbFdiXm+K3/2rzfr3CyLYfo+FV8f
	 LYj274e2Tn+c1TaTtqvl2cEBPqoSih7dtLgOuP4ta9+q58nDKRpDQp76AOojROaLHk
	 SWa6RusorEYmlPy++4T41bp8XT/CXfgx95Hk5FLY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgHZISw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 04:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgHZISu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Aug 2020 04:18:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DE520678;
        Wed, 26 Aug 2020 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598429929;
        bh=+vJV+mRF0Lzjjr3fr3A1d25Ht5edbPCfJqUZ9mJTuZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GEU0Xm/bx8cP15xViHXthdwpTyen+TUGLxiTYu1aQr59txHczphF0iSJ6zUYeHWWX
         KeG6A4r//Wu1oZzMeekzFUdHP4041f9NyizugHYCE97ojW+tbEj5IjPyO+fOYOD9T4
         Wjw7xvPDwkn7MCG9zkXnTpGNV75HhW6BJRy8Z9QE=
Date:   Wed, 26 Aug 2020 10:19:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 01/19] char_dev: replace cdev_map with an xarray
Message-ID: <20200826081905.GB1796103@kroah.com>
References: <20200826062446.31860-1-hch@lst.de>
 <20200826062446.31860-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826062446.31860-2-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 26, 2020 at 08:24:28AM +0200, Christoph Hellwig wrote:
> None of the complicated overlapping regions bits of the kobj_map are
> required for the character device lookup, so just a trivial xarray
> instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Really?  This is ok to use and just as fast?  If so, wonderful, it would
be great to clean up kobj_map users.

But I don't think you got all of the needed bits here:

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

Can't you drop this kobject_get() too?

And also the "struct kobj" in struct cdev can be gone as well, as the
kobj_map was the only "real" user of this structure.  I know some
drivers liked to touch that field as well, but it never actually did
anything for them, so it was pointless, but it will take some 'make
allmodconfig' builds to flush them out.

thanks,

greg k-h
