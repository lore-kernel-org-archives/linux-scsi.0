Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF0EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 12:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD31060FC2
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 12:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhIJMq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 08:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233424AbhIJMq1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 08:46:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68D6160E94;
        Fri, 10 Sep 2021 12:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631277916;
        bh=u82foOMSBD2SO3pdy2Df3/FLyJdVMTCjSxcxbQ2H6Ss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ec5mXp8myPUPpCCPqmnP/jTIcA49WxLNi2F+BEGPfUeGlOKRBx+v2ub/x7AEpb2Ry
         hQdc3DNWqyTbTZz6C0rmrKvvJvqgy9sBu6uXh3nbfSKjyMtWcMoAZrfdziym0kQ0b/
         EyNFbDxzt+6dggmkyNoNmm8Na428uLchP6GMDdnSP0/i0DuG+EKGGL8IjuTyCVeNdf
         NJu1cuUdj5X9rLbRq/MaQJGdIv7xNp8dJbsPV8Ee/0GY28Oe8qBmKVXtCI6BwITS35
         1pKmPd9qYi8+jqRnEBU7mW+yVF/fA5IOZwlzrkfP/4slw5gmCq2zkZWQar2GOk33J2
         59Kin0IHNAriw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mOftz-0004zV-Bh; Fri, 10 Sep 2021 14:45:07 +0200
Date:   Fri, 10 Sep 2021 14:45:07 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        axboe@kernel.dk, martin.petersen@oracle.com, hch@lst.de,
        gregkh@linuxfoundation.org, wanghaibin.wang@huawei.com
Subject: Re: [PATCH] scsi: bsg: Fix device unregistration
Message-ID: <YTtTU4+DZEb4WRkR@hovoldconsulting.com>
References: <20210909034608.1435-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909034608.1435-1-yuzenghui@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 09, 2021 at 11:46:08AM +0800, Zenghui Yu wrote:
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
>  block/bsg.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
 
> +static void bsg_device_release(struct device *dev)
> +{
> +	struct bsg_device *bd = container_of(dev, struct bsg_device, device);
> +
> +	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
> +	kfree(bd);
> +}

> @@ -198,6 +205,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
>  	bd->device.devt = MKDEV(bsg_major, ret);
>  	bd->device.class = bsg_class;
>  	bd->device.parent = parent;
> +	bd->device.release = bsg_device_release;
>  	dev_set_name(&bd->device, "%s", name);
>  	device_initialize(&bd->device);
>  
> @@ -218,6 +226,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
>  out_device_del:
>  	cdev_device_del(&bd->cdev, &bd->device);
>  out_ida_remove:
> +	put_device(&bd->device);
>  	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
>  out_kfree:
>  	kfree(bd);

Ehh, what about the blatant use-after-free and double-free you just
added here?

Martin, can this still be dropped from the scsi tree or does it need to
be fixed incrementally?

Johan
