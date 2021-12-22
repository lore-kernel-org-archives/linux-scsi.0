Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C703C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 16:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344015AbhLVQyi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 11:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbhLVQyi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 11:54:38 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21224C061574
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 08:54:38 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id bk14so4826106oib.7
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 08:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9waGNOF9b9MfX69tWMxFziVtFTXb6uTb2kgFEro+iDg=;
        b=eQIneav2otMK5jHoGSl0z/oYvNDoKwg2kVe0lxZSH+IK+jSajDSWui7PKg+YFeYlJB
         Bqyn8xKfjVt0oO/AJc9InK1R5TBgFZXiPurmD/TvYeSeRN8jMDZ4dDlV45+6LyB8uq4z
         IhFiiUMBzvrEUvo/4livWpBPg6Bs7O3s9lfiAyO/sxTHheXcFjXtM+7jATp/AEm5ijFL
         A5gz22tk/SF1jcABj5zBMFcuTX00H72VbbvQNNuvDLSm2Vg9t/zmGuVY0lcpyOkscJgI
         u8gVP1cSJQGaZH3mY2Lz85GwXgjrjLyBhRahJmADTO9DXxrMVW6ARl38euRVOgnoHNS9
         a2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9waGNOF9b9MfX69tWMxFziVtFTXb6uTb2kgFEro+iDg=;
        b=1qC0r+uCo7urkufBRZ7Y0NRr01lVwaqfxoNxDTOkXizl/vtRRLDa49GJRcEt7NXPYw
         C4yVB10FJ6poocVx9YGwKvuX7LD8dx9KfI7fEDoN9tYLNifBW24h4fYK+WmBql8zZj49
         /Y+0Q+B/8GhkVllqWWNHg88bUl4j2pK8OAEJoCqekdS1wGyOX1mefdXYCntyZ+imxD7N
         dcaWCX3Hboq4JtaIbTahnQSOQJYsNp2+zTVELoAsAZujRelQmm8DbfEdOCoMuDi9FHUQ
         V3h3BxfsXGPoD+uIzcoxrbBTstQmsoJ/7VuCMD5UX7BFyE/YNjCESSD4ffFD4ooAnHXu
         ucpg==
X-Gm-Message-State: AOAM533EiCIhGRlTMX1eS1gLXAHzmy8+B9VsQADKV2o/PZ7eipKdOstE
        PnX8nA7548Jaz5pC356GNV8=
X-Google-Smtp-Source: ABdhPJyVX0OBkASSl8F4MJOsm1kX4uBjZrFNUxF1ncAGGJA/HqLL7Excql4Ur5uuN1r+MNdBNmFH2w==
X-Received: by 2002:aca:c6cb:: with SMTP id w194mr1309157oif.2.1640192077312;
        Wed, 22 Dec 2021 08:54:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm485287oik.11.2021.12.22.08.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 08:54:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 22 Dec 2021 08:54:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org, hch@lst.de,
        axboe@kernel.dk
Subject: Re: [PATCH v2] scsi: bsg: fix errno when scsi_bsg_register_queue
 fails
Message-ID: <20211222165435.GA283263@roeck-us.net>
References: <20211022010201.426746-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022010201.426746-1-liu.yun@linux.dev>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2021 at 09:02:01AM +0800, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> When the value of error is printed, it will always be 0. Here, we should be
> print the correct error code when scsi_bsg_register_queue fails.
> 

The comment above the changed code says:

"
We're treating error on bsg register as non-fatal, so pretend nothing went wrong.
"

With this patch in place, "error" is returned to the caller, and the code
no longer pretends that nothing is wrong. Also, the message is a dev_info
message, not dev_err, suggesting that ignoring the error was indeed on
purpose. Assuming the comment is correct, this patch is plain wrong;
the message should have printed PTR_ERR(sdev->bsg_dev) instead and not set
the 'error' variable.

Guenter

> Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
>  v1->v2:
>  resend to linux-scsi mail list.
> 
>  drivers/scsi/scsi_sysfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 86793259e541..d8789f6cda62 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1379,6 +1379,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  			 * We're treating error on bsg register as non-fatal, so
>  			 * pretend nothing went wrong.
>  			 */
> +			error = PTR_ERR(sdev->bsg_dev);
>  			sdev_printk(KERN_INFO, sdev,
>  				    "Failed to register bsg queue, errno=%d\n",
>  				    error);
> -- 
> 2.25.1
> 
