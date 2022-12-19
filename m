Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF8DC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 08:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiLSIAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 03:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLSIA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 03:00:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD73BC2E
        for <linux-scsi@vger.kernel.org>; Sun, 18 Dec 2022 23:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671436783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YS3+j8ysmQFXuAF/WWlDo+Y2S/ZCz/u0RFV1hier8ug=;
        b=MFGldvTq8NLpKjoNDnfQhAGpImtFmNJmWGoYPQGTUoA06LRdWxU7HvxxN8ptJlI0snfGP8
        1oaAegWydghf/bUl2XfFAB+fDN+0r4bXQZ2hDSkjz1gk7GGCA08mSImFd2hMIlTNNj0fmL
        YPHySizGDVJCiSinqW/8F9tFH8OjQNI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-319-_bivs4drP0CpUUNvrvc4kg-1; Mon, 19 Dec 2022 02:59:41 -0500
X-MC-Unique: _bivs4drP0CpUUNvrvc4kg-1
Received: by mail-qv1-f69.google.com with SMTP id a15-20020ad441cf000000b004c79ef7689aso5255301qvq.14
        for <linux-scsi@vger.kernel.org>; Sun, 18 Dec 2022 23:59:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YS3+j8ysmQFXuAF/WWlDo+Y2S/ZCz/u0RFV1hier8ug=;
        b=3I6y8MrS/xK7p2MbqU/7HrcXklJ0p8iLSOdiU5kiPU7pZyal2AecYEHveWnZIVYi6B
         ndczLjHKtRNxNqqEe0Qgh22sWKOwpzMXOIdNzdiF0Klx7pgOz0xS0Ibh752Hv2EVC4Rx
         yKxgJOyjsixveY3cIwGIu/fP4auVW4aZx5RbXlpzwRyyrgXUqsZa9TxJ0YmDTe08jRm9
         SFD85QdadhDP19qJ4SoTcXjXtzmBMmi4ZHIi7D0JvekzWwgqCdkFbPYi48LVzI/aTzQq
         UvQkPb7LHgReJaaoEXok+Do9AxtQTUHrB/LNNC9DDLLX3A5IDw1eoemgLV8nLEn2PN7y
         wuow==
X-Gm-Message-State: ANoB5pmaBp8RY+AM7qVyyzgSUW661FqnLgsNA/IxdHYbxyqMrnuIyM5I
        ejms1t5z8nDadNuEp7Uw+vVbYN3poLo7z9QZ0U3oFsLzDeLof8V8vFi3pHT0J6EAZWwMMe2RiUg
        oRf3zZuQPwFAVb03vpp5t1A==
X-Received: by 2002:ac8:73d0:0:b0:3a6:a750:7295 with SMTP id v16-20020ac873d0000000b003a6a7507295mr52184077qtp.4.1671436781370;
        Sun, 18 Dec 2022 23:59:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Wq6cMYNlB+7Xwf8W/aB4sv+SmT+LvfYGgWrr7DqxucS6GjT8jJVdHwqlCwXwk+RfFMFIuhg==
X-Received: by 2002:ac8:73d0:0:b0:3a6:a750:7295 with SMTP id v16-20020ac873d0000000b003a6a7507295mr52184064qtp.4.1671436781018;
        Sun, 18 Dec 2022 23:59:41 -0800 (PST)
Received: from redhat.com ([45.144.113.29])
        by smtp.gmail.com with ESMTPSA id r17-20020ae9d611000000b006fcc437c2e8sm6591250qkk.44.2022.12.18.23.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Dec 2022 23:59:40 -0800 (PST)
Date:   Mon, 19 Dec 2022 02:59:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Message-ID: <20221219025404-mutt-send-email-mst@kernel.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 05, 2022 at 06:20:34PM +0200, Alvaro Karsz wrote:
> Implement the VIRTIO_BLK_F_LIFETIME feature for VirtIO block devices.
> 
> This commit introduces a new ioctl command, VBLK_LIFETIME.
> 
> VBLK_LIFETIME ioctl asks for the block device to provide lifetime
> information by sending a VIRTIO_BLK_T_GET_LIFETIME command to the device.
> 
> lifetime information fields:
> 
> - pre_eol_info: specifies the percentage of reserved blocks that are
> 		consumed.
> 		optional values following virtio spec:
> 		*) 0 - undefined.
> 		*) 1 - normal, < 80% of reserved blocks are consumed.
> 		*) 2 - warning, 80% of reserved blocks are consumed.
> 		*) 3 - urgent, 90% of reserved blocks are consumed.
> 
> - device_lifetime_est_typ_a: this field refers to wear of SLC cells and
> 			     is provided in increments of 10used, and so
> 			     on, thru to 11 meaning estimated lifetime
> 			     exceeded. All values above 11 are reserved.
> 
> - device_lifetime_est_typ_b: this field refers to wear of MLC cells and is
> 			     provided with the same semantics as
> 			     device_lifetime_est_typ_a.
> 
> The data received from the device will be sent as is to the user.
> No data check/decode is done by virtblk.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> --
> v2:
> 	- Remove (void *) casting.
> 	- Fix comments format in virtio_blk.h.
> 	- Set ioprio value for legacy devices for REQ_OP_DRV_IN
> 	  operations.
> 
> v3:
> 	- Initialize struct virtio_blk_lifetime to 0 instead of memset.
> 	- Rename ioctl from VBLK_LIFETIME to VBLK_GET_LIFETIME.
> 	- Return EOPNOTSUPP insted of ENOTTY if ioctl is not supported.
> 	- Check if process is CAP_SYS_ADMIN capable in lifetime ioctl.
> 	- Check if vdev is not NULL before accessing it in lifetime ioctl.
> --
> ---
>  drivers/block/virtio_blk.c      | 106 ++++++++++++++++++++++++++++++--
>  include/uapi/linux/virtio_blk.h |  32 ++++++++++
>  2 files changed, 133 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 19da5defd73..392d57fd6b7 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -101,6 +101,18 @@ static inline blk_status_t virtblk_result(struct virtblk_req *vbr)
>  	}
>  }
>  
> +static inline int virtblk_ioctl_result(struct virtblk_req *vbr)
> +{
> +	switch (vbr->status) {
> +	case VIRTIO_BLK_S_OK:
> +		return 0;
> +	case VIRTIO_BLK_S_UNSUPP:
> +		return -EOPNOTSUPP;
> +	default:
> +		return -EIO;
> +	}
> +}
> +
>  static inline struct virtio_blk_vq *get_virtio_blk_vq(struct blk_mq_hw_ctx *hctx)
>  {
>  	struct virtio_blk *vblk = hctx->queue->queuedata;
> @@ -218,6 +230,7 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
>  	u32 type;
>  
>  	vbr->out_hdr.sector = 0;
> +	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
>  
>  	switch (req_op(req)) {
>  	case REQ_OP_READ:
> @@ -244,15 +257,14 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
>  		type = VIRTIO_BLK_T_SECURE_ERASE;
>  		break;
>  	case REQ_OP_DRV_IN:
> -		type = VIRTIO_BLK_T_GET_ID;
> -		break;
> +		/* type is set in virtblk_get_id/virtblk_ioctl_lifetime */
> +		return 0;
>  	default:
>  		WARN_ON_ONCE(1);
>  		return BLK_STS_IOERR;
>  	}
>  
>  	vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
> -	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
>  
>  	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES ||
>  	    type == VIRTIO_BLK_T_SECURE_ERASE) {
> @@ -459,12 +471,16 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
>  	struct virtio_blk *vblk = disk->private_data;
>  	struct request_queue *q = vblk->disk->queue;
>  	struct request *req;
> +	struct virtblk_req *vbr;
>  	int err;
>  
>  	req = blk_mq_alloc_request(q, REQ_OP_DRV_IN, 0);
>  	if (IS_ERR(req))
>  		return PTR_ERR(req);
>  
> +	vbr = blk_mq_rq_to_pdu(req);
> +	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_GET_ID);
> +
>  	err = blk_rq_map_kern(q, req, id_str, VIRTIO_BLK_ID_BYTES, GFP_KERNEL);
>  	if (err)
>  		goto out;
> @@ -508,6 +524,85 @@ static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
>  	return ret;
>  }
>  
> +/* Get lifetime information from device */
> +static int virtblk_ioctl_lifetime(struct virtio_blk *vblk, unsigned long arg)
> +{
> +	struct request_queue *q = vblk->disk->queue;
> +	struct request *req = NULL;
> +	struct virtblk_req *vbr;
> +	struct virtio_blk_lifetime lifetime = {};
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* The virtio_blk_lifetime struct fields follow virtio spec.
> +	 * There is no check/decode on values received from the device.
> +	 * The data is sent as is to the user.
> +	 */
> +
> +	/* This ioctl is allowed only if VIRTIO_BLK_F_LIFETIME
> +	 * feature is negotiated.
> +	 */
> +	if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_LIFETIME))
> +		return -EOPNOTSUPP;
> +
> +	req = blk_mq_alloc_request(q, REQ_OP_DRV_IN, 0);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +
> +	/* Write the correct type */
> +	vbr = blk_mq_rq_to_pdu(req);
> +	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_GET_LIFETIME);
> +
> +	ret = blk_rq_map_kern(q, req, &lifetime, sizeof(lifetime), GFP_KERNEL);
> +	if (ret)
> +		goto out;
> +
> +	blk_execute_rq(req, false);
> +
> +	ret = virtblk_ioctl_result(blk_mq_rq_to_pdu(req));
> +	if (ret)
> +		goto out;
> +
> +	/* Pass the data to the user */
> +	if (copy_to_user((void __user *)arg, &lifetime, sizeof(lifetime))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +out:
> +	blk_mq_free_request(req);
> +	return ret;
> +}
> +
> +static int virtblk_ioctl(struct block_device *bd, fmode_t mode,
> +			 unsigned int cmd, unsigned long arg)
> +{
> +	struct virtio_blk *vblk = bd->bd_disk->private_data;
> +	int ret;
> +
> +	mutex_lock(&vblk->vdev_mutex);
> +
> +	if (!vblk->vdev) {
> +		ret = -ENXIO;
> +		goto exit;
> +	}
> +
> +	switch (cmd) {
> +	case VBLK_GET_LIFETIME:
> +		ret = virtblk_ioctl_lifetime(vblk, arg);
> +		break;
> +	default:
> +		ret = -EOPNOTSUPP;
> +		break;
> +	}
> +
> +exit:
> +	mutex_unlock(&vblk->vdev_mutex);
> +	return ret;
> +}
> +
>  static void virtblk_free_disk(struct gendisk *disk)
>  {
>  	struct virtio_blk *vblk = disk->private_data;
> @@ -520,6 +615,7 @@ static void virtblk_free_disk(struct gendisk *disk)
>  static const struct block_device_operations virtblk_fops = {
>  	.owner  	= THIS_MODULE,
>  	.getgeo		= virtblk_getgeo,
> +	.ioctl		= virtblk_ioctl,
>  	.free_disk	= virtblk_free_disk,
>  };
>  
> @@ -1239,7 +1335,7 @@ static unsigned int features_legacy[] = {
>  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
>  	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
>  	VIRTIO_BLK_F_MQ, VIRTIO_BLK_F_DISCARD, VIRTIO_BLK_F_WRITE_ZEROES,
> -	VIRTIO_BLK_F_SECURE_ERASE,
> +	VIRTIO_BLK_F_SECURE_ERASE, VIRTIO_BLK_F_LIFETIME,
>  }
>  ;
>  static unsigned int features[] = {
> @@ -1247,7 +1343,7 @@ static unsigned int features[] = {
>  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
>  	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
>  	VIRTIO_BLK_F_MQ, VIRTIO_BLK_F_DISCARD, VIRTIO_BLK_F_WRITE_ZEROES,
> -	VIRTIO_BLK_F_SECURE_ERASE,
> +	VIRTIO_BLK_F_SECURE_ERASE, VIRTIO_BLK_F_LIFETIME,
>  };
>  
>  static struct virtio_driver virtio_blk = {
> diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
> index 58e70b24b50..e755d62d2ea 100644
> --- a/include/uapi/linux/virtio_blk.h
> +++ b/include/uapi/linux/virtio_blk.h
> @@ -40,6 +40,7 @@
>  #define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
>  #define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
>  #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
> +#define VIRTIO_BLK_F_LIFETIME	15 /* Storage lifetime information is supported */
>  #define VIRTIO_BLK_F_SECURE_ERASE	16 /* Secure Erase is supported */
>  
>  /* Legacy feature bits */
> @@ -165,6 +166,9 @@ struct virtio_blk_config {
>  /* Get device ID command */
>  #define VIRTIO_BLK_T_GET_ID    8
>  
> +/* Get lifetime information command */
> +#define VIRTIO_BLK_T_GET_LIFETIME 10
> +
>  /* Discard command */
>  #define VIRTIO_BLK_T_DISCARD	11
>  
> @@ -206,6 +210,30 @@ struct virtio_blk_discard_write_zeroes {
>  	__le32 flags;
>  };
>  
> +/* Get lifetime information struct for each request */
> +struct virtio_blk_lifetime {
> +	/*
> +	 * specifies the percentage of reserved blocks that are consumed.
> +	 * optional values following virtio spec:
> +	 * 0 - undefined
> +	 * 1 - normal, < 80% of reserved blocks are consumed
> +	 * 2 - warning, 80% of reserved blocks are consumed
> +	 * 3 - urgent, 90% of reserved blocks are consumed
> +	 */
> +	__le16 pre_eol_info;
> +	/*
> +	 * this field refers to wear of SLC cells and is provided in increments of 10used,
> +	 * and so on, thru to 11 meaning estimated lifetime exceeded. All values above 11
> +	 * are reserved
> +	 */
> +	__le16 device_lifetime_est_typ_a;
> +	/*
> +	 * this field refers to wear of MLC cells and is provided with the same semantics as
> +	 * device_lifetime_est_typ_a
> +	 */
> +	__le16 device_lifetime_est_typ_b;
> +};
> +
>  #ifndef VIRTIO_BLK_NO_LEGACY
>  struct virtio_scsi_inhdr {
>  	__virtio32 errors;
> @@ -219,4 +247,8 @@ struct virtio_scsi_inhdr {
>  #define VIRTIO_BLK_S_OK		0
>  #define VIRTIO_BLK_S_IOERR	1
>  #define VIRTIO_BLK_S_UNSUPP	2
> +
> +/* Virtblk ioctl commands */
> +#define VBLK_GET_LIFETIME	_IOR('r', 0, struct virtio_blk_lifetime)
> +
>  #endif /* _LINUX_VIRTIO_BLK_H */


So this makes the header not self-contained: you need to
pull in ioctl.h. And that's a bit annoying to people
who are used to just have spec defines in this header.
Maybe add a new one virtio_blk_ioctl.h ?

And I'd still like to change VBLK_ prefix here to something like
VIRTIO_BLK_IOCTL_ 

And maybe document that this is just for specific type of backend
device, and mention the types which benefit, in code comment
if not in the ioctl name.

Thanks!


> -- 
> 2.32.0

