Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43756C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 03:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiCFDcw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 22:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiCFDcv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 22:32:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4009344F3
        for <linux-scsi@vger.kernel.org>; Sat,  5 Mar 2022 19:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646537519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sezWhZSC9iekxxctKkgFw69XTIQw+N5hCy9qS8tGkZA=;
        b=E/u1Tc1VHcQNFB7+PWnzuyZ86pFf1eUI88G3Dw+ONr8Kd66+ShxoJO6zrV2pdhykcrVl65
        LDFPAcXW9Ad6ahHa9htCdHxrLXFvoIFgYXIV1N/Ch6GZfNU3seJ4ckeecKtVscft/EfwZX
        og5XIeDJqm93szuMCh5RDtD1gSI74uQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-VE76_7uQOk6ehqAB8bK7HQ-1; Sat, 05 Mar 2022 22:31:55 -0500
X-MC-Unique: VE76_7uQOk6ehqAB8bK7HQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C500801DDC;
        Sun,  6 Mar 2022 03:31:54 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 424334D736;
        Sun,  6 Mar 2022 03:31:38 +0000 (UTC)
Date:   Sun, 6 Mar 2022 11:31:33 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 04/14] sd: rename the scsi_disk.dev field
Message-ID: <YiQq6+ow5EEXpSCC@T590>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304160331.399757-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 04, 2022 at 05:03:21PM +0100, Christoph Hellwig wrote:
> dev is very hard to grab for.  Give the field a more descriptive name and
> documents it's purpose.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 22 +++++++++++-----------
>  drivers/scsi/sd.h | 10 ++++++++--
>  2 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 2a1e19e871d30..7479e7cb36b43 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -672,7 +672,7 @@ static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
>  	if (disk->private_data) {
>  		sdkp = scsi_disk(disk);
>  		if (scsi_device_get(sdkp->device) == 0)
> -			get_device(&sdkp->dev);
> +			get_device(&sdkp->disk_dev);
>  		else
>  			sdkp = NULL;
>  	}
> @@ -685,7 +685,7 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
>  	struct scsi_device *sdev = sdkp->device;
>  
>  	mutex_lock(&sd_ref_mutex);
> -	put_device(&sdkp->dev);
> +	put_device(&sdkp->disk_dev);
>  	scsi_device_put(sdev);
>  	mutex_unlock(&sd_ref_mutex);
>  }
> @@ -3529,14 +3529,14 @@ static int sd_probe(struct device *dev)
>  					     SD_MOD_TIMEOUT);
>  	}
>  
> -	device_initialize(&sdkp->dev);
> -	sdkp->dev.parent = get_device(dev);
> -	sdkp->dev.class = &sd_disk_class;
> -	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
> +	device_initialize(&sdkp->disk_dev);
> +	sdkp->disk_dev.parent = get_device(dev);
> +	sdkp->disk_dev.class = &sd_disk_class;
> +	dev_set_name(&sdkp->disk_dev, "%s", dev_name(dev));
>  
> -	error = device_add(&sdkp->dev);
> +	error = device_add(&sdkp->disk_dev);
>  	if (error) {
> -		put_device(&sdkp->dev);
> +		put_device(&sdkp->disk_dev);
>  		goto out;
>  	}
>  
> @@ -3577,7 +3577,7 @@ static int sd_probe(struct device *dev)
>  
>  	error = device_add_disk(dev, gd, NULL);
>  	if (error) {
> -		put_device(&sdkp->dev);
> +		put_device(&sdkp->disk_dev);
>  		goto out;
>  	}
>  
> @@ -3628,7 +3628,7 @@ static int sd_remove(struct device *dev)
>  	sdkp = dev_get_drvdata(dev);
>  	scsi_autopm_get_device(sdkp->device);
>  
> -	device_del(&sdkp->dev);
> +	device_del(&sdkp->disk_dev);
>  	del_gendisk(sdkp->disk);
>  	sd_shutdown(dev);
>  
> @@ -3636,7 +3636,7 @@ static int sd_remove(struct device *dev)
>  
>  	mutex_lock(&sd_ref_mutex);
>  	dev_set_drvdata(dev, NULL);
> -	put_device(&sdkp->dev);
> +	put_device(&sdkp->disk_dev);
>  	mutex_unlock(&sd_ref_mutex);
>  
>  	return 0;
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 303aa1c23aefb..7625a90b0fa69 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -69,7 +69,13 @@ enum {
>  
>  struct scsi_disk {
>  	struct scsi_device *device;
> -	struct device	dev;
> +
> +	/*
> +	 * This device is mostly just used to show a bunch of attributes in a
> +	 * weird place.  In doubt don't add any new users, and most importantly
> +	 * don't use if for any actual refcounting.
> +	 */

The device looks partner of gendisk, I think it could just be a
private data of gendisk, and the attributes can be added to gendisk.

But scsi has the tradition of adding class device of scsi_host,
scsi_device, scsi_disk and scsi_generic.

Adding such device makes things complicated, such as refcounting
in open/close disk. But looks scsi_disk isn't part of sysfs ABI, maybe it
can be removed, anyway:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

