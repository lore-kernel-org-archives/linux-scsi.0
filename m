Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8137C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 07:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A813E6101A
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 07:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhIMHl0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 03:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237626AbhIMHlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 03:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0397060F6D;
        Mon, 13 Sep 2021 07:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631518810;
        bh=6oO17ePJ66tf1qaogSIGXkG0PK94ZVE5plfXUvejXFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P/bTzWA9lNX+zvL8XRMjlTXue2aGxwiwQFASjcc9FtHrF/p0B7SqxzpJ8YSTcnkyZ
         og9b3mVFydqRp76P7H3bQ767tGD4gf27RIuxMlvRLvFtCJAq84lu3XFwakNCsiOIFt
         S3yVPqofCIll/rMtdsNe3qBYnyQLb3FY5QWsuZP9emB9EnDzeD8cpXF7r6Z62zCvQB
         T9JRMNLLh5OH7E/XEX7O432np+gGylPFXb5ORmbFd4uW6iVPsTFkbp/GekpY59NkcO
         132PyugDZotD4hxCbQlUyG+6O9YDARtqAsdx6jZfLa2xnvgp+9yx6avwekoGkLtVBp
         S1K3RALQk3/jA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mPgZI-0001Zh-8u; Mon, 13 Sep 2021 09:39:57 +0200
Date:   Mon, 13 Sep 2021 09:39:56 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        axboe@kernel.dk, martin.petersen@oracle.com, hch@lst.de,
        gregkh@linuxfoundation.org, wanghaibin.wang@huawei.com
Subject: Re: [PATCH v2] scsi: bsg: Fix device unregistration
Message-ID: <YT8ATD51tBc7Ohmt@hovoldconsulting.com>
References: <20210911105306.1511-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210911105306.1511-1-yuzenghui@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 11, 2021 at 06:53:06PM +0800, Zenghui Yu wrote:
> We use device_initialize() to take refcount for the device but forget to
> put_device() on device teardown, which ends up leaking private data of the
> driver core, dev_name(), etc. This is reported by kmemleak at boot time if
> we compile kernel with DEBUG_TEST_DRIVER_REMOVE.
> 
> Note that adding the missing put_device() is _not_ sufficient to fix device
> unregistration. As we don't provide the .release() method for device, which
> turned out to be typically wrong and will be complained loudly by the
> driver core.
> 
> Fix both of them.
> 
> Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
> * From v1 [1]:
>   - As pointed out by Johan, fix UAF and double-free on error path ...

Looks good now:

Reviewed-by: Johan Hovold <johan@kernel.org>

>   - ... so I didn't collect Christoph and Greg's R-b tags (but thanks
>     for reviewing)
> 
> [1] https://lore.kernel.org/r/20210909034608.1435-1-yuzenghui@huawei.com
> 
>  block/bsg.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 351095193788..882f56bff14f 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -165,13 +165,20 @@ static const struct file_operations bsg_fops = {
>  	.llseek		=	default_llseek,
>  };
>  
> +static void bsg_device_release(struct device *dev)
> +{
> +	struct bsg_device *bd = container_of(dev, struct bsg_device, device);
> +
> +	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
> +	kfree(bd);
> +}
> +
>  void bsg_unregister_queue(struct bsg_device *bd)
>  {
>  	if (bd->queue->kobj.sd)
>  		sysfs_remove_link(&bd->queue->kobj, "bsg");
>  	cdev_device_del(&bd->cdev, &bd->device);
> -	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
> -	kfree(bd);
> +	put_device(&bd->device);
>  }
>  EXPORT_SYMBOL_GPL(bsg_unregister_queue);
>  
> @@ -193,11 +200,13 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
>  	if (ret < 0) {
>  		if (ret == -ENOSPC)
>  			dev_err(parent, "bsg: too many bsg devices\n");
> -		goto out_kfree;
> +		kfree(bd);
> +		return ERR_PTR(ret);
>  	}
>  	bd->device.devt = MKDEV(bsg_major, ret);
>  	bd->device.class = bsg_class;
>  	bd->device.parent = parent;
> +	bd->device.release = bsg_device_release;
>  	dev_set_name(&bd->device, "%s", name);
>  	device_initialize(&bd->device);
>  
> @@ -205,7 +214,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
>  	bd->cdev.owner = THIS_MODULE;
>  	ret = cdev_device_add(&bd->cdev, &bd->device);
>  	if (ret)
> -		goto out_ida_remove;
> +		goto out_put_device;
>  
>  	if (q->kobj.sd) {
>  		ret = sysfs_create_link(&q->kobj, &bd->device.kobj, "bsg");
> @@ -217,10 +226,8 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
>  
>  out_device_del:
>  	cdev_device_del(&bd->cdev, &bd->device);
> -out_ida_remove:
> -	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
> -out_kfree:
> -	kfree(bd);
> +out_put_device:
> +	put_device(&bd->device);
>  	return ERR_PTR(ret);
>  }
>  EXPORT_SYMBOL_GPL(bsg_register_queue);
