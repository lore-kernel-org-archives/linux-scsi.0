Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44045C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 03:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08E5206CB
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 03:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XtjJHmqa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgKIDle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Nov 2020 22:41:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729192AbgKIDld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2020 22:41:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604893291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HRUOskoa94Uh3kioUg71hmE2ZG0LYjxl0LleZC6OzXQ=;
        b=XtjJHmqa2zJgeN7W5hwje1Sdhl3UB4itNVAialNVGM1ZgOgzyTMxHLmOZ/Mw+kDrhGcbWB
        0zrVxo5Q44oBBWC9/wtxdJ7bVMHvp60zxHq9orQkIeaW9yiI9pZ1ZCwdFkNWNO2U2RxFiX
        Iy5FWTDZvy+TPHqjL/3XEONTpjDBZ7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-s1z3KCySM8eFabxhqcUzmA-1; Sun, 08 Nov 2020 22:41:30 -0500
X-MC-Unique: s1z3KCySM8eFabxhqcUzmA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 298D81009455;
        Mon,  9 Nov 2020 03:41:29 +0000 (UTC)
Received: from [10.72.12.244] (ovpn-12-244.pek2.redhat.com [10.72.12.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B7405B4CD;
        Mon,  9 Nov 2020 03:41:20 +0000 (UTC)
Subject: Re: [PATCH 05/11] vhost: move vq iovec allocation to dev init time
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
 <1604528804-2878-6-git-send-email-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <347657f8-7f2a-0e47-bab7-015ad4290684@redhat.com>
Date:   Mon, 9 Nov 2020 11:41:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604528804-2878-6-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/11/5 上午6:26, Mike Christie wrote:
> The next patches allow us to create vqs on demand after vhost_dev_init
> and vhost_dev_set_owner have been called. For vhost-scsi we don't
> know the number of vqs we really want until the vring/vq setup
> operations have started up. For other devices we know the number of vqs
> at vhost_dev_init time, so for those devs we init the vq and allocate
> the needed iovecs. For vhost-scsi we will do it later when userspace has
> indicated to us that it's going to use a vq.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/vhost/vhost.c | 71 +++++++++++++++++++++++++++------------------------
>   1 file changed, 38 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b35229e..a4a4450 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -383,29 +383,27 @@ static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>   	vq->heads = NULL;
>   }
>   
> -/* Helper to allocate iovec buffers for all vqs. */
> -static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
> +static int vhost_vq_alloc_iovecs(struct vhost_dev *dev,
> +				 struct vhost_virtqueue *vq)
>   {
> -	struct vhost_virtqueue *vq;
> -	int i;
> +	vq->indirect = kmalloc_array(UIO_MAXIOV, sizeof(*vq->indirect),
> +				     GFP_KERNEL);
> +	if (!vq->indirect)
> +		return -ENOMEM;
> +
> +	if (!dev->iov_limit)
> +		return 0;


This looks like an optimization. Let's try to defer this into another patch.


> +
> +	vq->log = kmalloc_array(dev->iov_limit, sizeof(*vq->log), GFP_KERNEL);
> +	vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
> +				  GFP_KERNEL);
> +	if (!vq->log || !vq->heads)
> +		goto err_nomem;
>   
> -	for (i = 0; i < dev->nvqs; ++i) {
> -		vq = dev->vqs[i];
> -		vq->indirect = kmalloc_array(UIO_MAXIOV,
> -					     sizeof(*vq->indirect),
> -					     GFP_KERNEL);
> -		vq->log = kmalloc_array(dev->iov_limit, sizeof(*vq->log),
> -					GFP_KERNEL);
> -		vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
> -					  GFP_KERNEL);
> -		if (!vq->indirect || !vq->log || !vq->heads)
> -			goto err_nomem;
> -	}
>   	return 0;
>   
>   err_nomem:
> -	for (; i >= 0; --i)
> -		vhost_vq_free_iovecs(dev->vqs[i]);
> +	vhost_vq_free_iovecs(vq);
>   	return -ENOMEM;
>   }
>   
> @@ -458,6 +456,21 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
>   	return sizeof(*vq->desc) * num;
>   }
>   
> +static int vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
> +{
> +	vq->log = NULL;
> +	vq->indirect = NULL;
> +	vq->heads = NULL;
> +	vq->dev = dev;
> +	mutex_init(&vq->mutex);
> +	vhost_vq_reset(dev, vq);
> +
> +	if (vq->handle_kick)
> +		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev);
> +
> +	return vhost_vq_alloc_iovecs(dev, vq);
> +}


If it's possible, I would do a patch to introduce vhost_vq_init() and 
then add vhost_vq_alloc_iovecs() on top.

Thanks


> +
>   int vhost_dev_init(struct vhost_dev *dev,
>   		   struct vhost_virtqueue **vqs, int nvqs,
>   		   int iov_limit, int weight, int byte_weight,
> @@ -465,7 +478,6 @@ int vhost_dev_init(struct vhost_dev *dev,
>   		   int (*msg_handler)(struct vhost_dev *dev,
>   				      struct vhost_iotlb_msg *msg))
>   {
> -	struct vhost_virtqueue *vq;
>   	int i;
>   
>   	dev->vqs = vqs;
> @@ -489,19 +501,16 @@ int vhost_dev_init(struct vhost_dev *dev,
>   
>   
>   	for (i = 0; i < dev->nvqs; ++i) {
> -		vq = dev->vqs[i];
> -		vq->log = NULL;
> -		vq->indirect = NULL;
> -		vq->heads = NULL;
> -		vq->dev = dev;
> -		mutex_init(&vq->mutex);
> -		vhost_vq_reset(dev, vq);
> -		if (vq->handle_kick)
> -			vhost_poll_init(&vq->poll, vq->handle_kick,
> -					EPOLLIN, dev);
> +		if (vhost_vq_init(dev, dev->vqs[i]))
> +			goto err_vq_init;
>   	}
>   
>   	return 0;
> +
> +err_vq_init:
> +	for (--i; i >= 0; --i)
> +		vhost_vq_free_iovecs(dev->vqs[i]);
> +	return -ENOMEM;
>   }
>   EXPORT_SYMBOL_GPL(vhost_dev_init);
>   
> @@ -606,10 +615,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>   			goto err_cgroup;
>   	}
>   
> -	err = vhost_dev_alloc_iovecs(dev);
> -	if (err)
> -		goto err_cgroup;
> -
>   	return 0;
>   err_cgroup:
>   	if (dev->worker) {

