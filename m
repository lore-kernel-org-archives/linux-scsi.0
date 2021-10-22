Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CB0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 10:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 985CA60560
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 10:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhJVKth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 06:49:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232573AbhJVKtg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 06:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634899638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xq7E3x1WswTfW3y4sCmSmeLNvprDEf0e/MXu/YBxCUM=;
        b=NpZkcWdWaWYXEC0V+srNUPCSxkHQfPpz7bpPTpIDZl6JGTaOuh0KnAxBZeCLyjMPjxyXw0
        cuC8hzUgLC7pSGiaxe6oIJjWqKzkbFGzd/VclBHyY3zgwZC2MUHFWhU+8pPOnXO/5mSNcs
        TUjt8TAjifRGbWEOlNlxtxkW6cU1aG8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-CEDqtZymOpWGFmwkXLoS5g-1; Fri, 22 Oct 2021 06:47:17 -0400
X-MC-Unique: CEDqtZymOpWGFmwkXLoS5g-1
Received: by mail-wm1-f70.google.com with SMTP id k9-20020a7bc409000000b0030d978403e9so839196wmi.7
        for <linux-scsi@vger.kernel.org>; Fri, 22 Oct 2021 03:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xq7E3x1WswTfW3y4sCmSmeLNvprDEf0e/MXu/YBxCUM=;
        b=t6krj2oE0BtlXTtt7rboyxDIb6CDyLvwf1B8bZY/bwDUjO/6/ExaD/wT5G3lqSZv6q
         AJdSKaanpEB7lWLU7s2Em2LGyqufHgUzA3ksvdlmedHdX+yMIQVcooL3phknAJCYUWiP
         djLL3wvA2osloMrEzwYr2vqeTfmWdLtEsGameA5cSNn0FFoCiHb4gs+MXMmZOvzV3siY
         8KotqfEmTQLKZzdYfjHYS7SLUYe4iEsAtHfnZtRLK5qFwRUwiXAUjokVo1ZaoMJE4RRL
         A35rhozVoDxdQ3M/sHmltjmwctaJ/PDORKP3mjSo1lizSCTw0Xq/0IEx/tSu1K96jVfm
         hrfQ==
X-Gm-Message-State: AOAM533Nygsoze9t9UovYDjzXTROpL9rIdJbFBcenTmr32ftoORyScfs
        ke9ZmT8ubMWOri2lcvpcEkah7AGpnFQV5EDvkLAR+3h4urAqeiWIcw9L4RH55bTlEF5OeCQWuhM
        z7F8+eRGcXsfffGaFvBQEgg==
X-Received: by 2002:a7b:cb55:: with SMTP id v21mr5953332wmj.83.1634899636096;
        Fri, 22 Oct 2021 03:47:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6Ad0W5TcbRqVIhlFIc9Dz1lU0GjU3dNzpRKDEZ1Oio4goJyBEDJpIaIV/QuHE8rEekJ7ZnQ==
X-Received: by 2002:a7b:cb55:: with SMTP id v21mr5953303wmj.83.1634899635842;
        Fri, 22 Oct 2021 03:47:15 -0700 (PDT)
Received: from redhat.com ([2.55.24.172])
        by smtp.gmail.com with ESMTPSA id l2sm3857169wrx.68.2021.10.22.03.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 03:47:14 -0700 (PDT)
Date:   Fri, 22 Oct 2021 06:47:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Message-ID: <20211022064359-mutt-send-email-mst@kernel.org>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022051911.108383-13-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2021 at 12:19:11AM -0500, Mike Christie wrote:
> This patch allows userspace to create workers and bind them to vqs. You
> can have N workers per dev and also share N workers with M vqs.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/vhost.c            | 99 ++++++++++++++++++++++++++++----
>  drivers/vhost/vhost.h            |  2 +-
>  include/uapi/linux/vhost.h       | 11 ++++
>  include/uapi/linux/vhost_types.h | 12 ++++
>  4 files changed, 112 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 04f43a6445e1..c86e88d7f35c 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -493,7 +493,6 @@ void vhost_dev_init(struct vhost_dev *dev,
>  	dev->umem = NULL;
>  	dev->iotlb = NULL;
>  	dev->mm = NULL;
> -	dev->worker = NULL;
>  	dev->iov_limit = iov_limit;
>  	dev->weight = weight;
>  	dev->byte_weight = byte_weight;
> @@ -576,20 +575,40 @@ static void vhost_worker_stop(struct vhost_worker *worker)
>  	wait_for_completion(worker->exit_done);
>  }
>  
> -static void vhost_worker_free(struct vhost_dev *dev)
> -{
> -	struct vhost_worker *worker = dev->worker;
>  
> +static void vhost_worker_put(struct vhost_worker *worker)
> +{
>  	if (!worker)
>  		return;
>  
> -	dev->worker = NULL;
> +	if (!refcount_dec_and_test(&worker->refcount))
> +		return;
> +
>  	WARN_ON(!llist_empty(&worker->work_list));
>  	vhost_worker_stop(worker);
>  	kfree(worker);
>  }
>  
> -static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
> +static void vhost_vq_clear_worker(struct vhost_virtqueue *vq)
> +{
> +	if (vq->worker)
> +		vhost_worker_put(vq->worker);
> +	vq->worker = NULL;
> +}
> +
> +static void vhost_workers_free(struct vhost_dev *dev)
> +{
> +	int i;
> +
> +	if (!dev->use_worker)
> +		return;
> +
> +	for (i = 0; i < dev->nvqs; i++)
> +		vhost_vq_clear_worker(dev->vqs[i]);
> +}
> +
> +static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev,
> +						int init_vq_map_count)
>  {
>  	struct vhost_worker *worker;
>  	struct task_struct *task;
> @@ -598,9 +617,9 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
>  	if (!worker)
>  		return NULL;
>  
> -	dev->worker = worker;
>  	worker->kcov_handle = kcov_common_handle();
>  	init_llist_head(&worker->work_list);
> +	refcount_set(&worker->refcount, init_vq_map_count);
>  
>  	/*
>  	 * vhost used to use the kthread API which ignores all signals by
> @@ -617,10 +636,58 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
>  
>  free_worker:
>  	kfree(worker);
> -	dev->worker = NULL;
>  	return NULL;
>  }
>  
> +static struct vhost_worker *vhost_worker_find(struct vhost_dev *dev, pid_t pid)
> +{
> +	struct vhost_worker *worker = NULL;
> +	int i;
> +
> +	for (i = 0; i < dev->nvqs; i++) {
> +		if (dev->vqs[i]->worker->task->pid != pid)
> +			continue;
> +
> +		worker = dev->vqs[i]->worker;
> +		break;
> +	}
> +
> +	return worker;
> +}
> +
> +/* Caller must have device mutex */
> +static int vhost_vq_setup_worker(struct vhost_virtqueue *vq,
> +				 struct vhost_vring_worker *info)
> +{
> +	struct vhost_dev *dev = vq->dev;
> +	struct vhost_worker *worker;
> +
> +	if (!dev->use_worker)
> +		return -EINVAL;
> +
> +	/* We don't support setting a worker on an active vq */
> +	if (vq->private_data)
> +		return -EBUSY;
> +
> +	if (info->pid == VHOST_VRING_NEW_WORKER) {
> +		worker = vhost_worker_create(dev, 1);
> +		if (!worker)
> +			return -ENOMEM;
> +
> +		info->pid = worker->task->pid;
> +	} else {
> +		worker = vhost_worker_find(dev, info->pid);
> +		if (!worker)
> +			return -ENODEV;
> +
> +		refcount_inc(&worker->refcount);
> +	}
> +
> +	vhost_vq_clear_worker(vq);
> +	vq->worker = worker;
> +	return 0;
> +}
> +
>  /* Caller should have device mutex */
>  long vhost_dev_set_owner(struct vhost_dev *dev)
>  {
> @@ -636,7 +703,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  	vhost_attach_mm(dev);
>  
>  	if (dev->use_worker) {
> -		worker = vhost_worker_create(dev);
> +		worker = vhost_worker_create(dev, dev->nvqs);
>  		if (!worker)
>  			goto err_worker;
>  
> @@ -650,7 +717,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  
>  	return 0;
>  err_iovecs:
> -	vhost_worker_free(dev);
> +	vhost_workers_free(dev);
>  err_worker:
>  	vhost_detach_mm(dev);
>  err_mm:
> @@ -742,7 +809,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  	dev->iotlb = NULL;
>  	vhost_clear_msg(dev);
>  	wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
> -	vhost_worker_free(dev);
> +	vhost_workers_free(dev);
>  	vhost_detach_mm(dev);
>  }
>  EXPORT_SYMBOL_GPL(vhost_dev_cleanup);
> @@ -1612,6 +1679,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>  	struct eventfd_ctx *ctx = NULL;
>  	u32 __user *idxp = argp;
>  	struct vhost_virtqueue *vq;
> +	struct vhost_vring_worker w;
>  	struct vhost_vring_state s;
>  	struct vhost_vring_file f;
>  	u32 idx;
> @@ -1719,6 +1787,15 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>  		if (copy_to_user(argp, &s, sizeof(s)))
>  			r = -EFAULT;
>  		break;
> +	case VHOST_SET_VRING_WORKER:
> +		if (copy_from_user(&w, argp, sizeof(w))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +		r = vhost_vq_setup_worker(vq, &w);
> +		if (!r && copy_to_user(argp, &w, sizeof(w)))
> +			r = -EFAULT;
> +		break;
>  	default:
>  		r = -ENOIOCTLCMD;
>  	}
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 33c63b24187a..0911d1a9bd3b 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -35,6 +35,7 @@ struct vhost_worker {
>  	struct llist_head	work_list;
>  	u64			kcov_handle;
>  	unsigned long		flags;
> +	refcount_t		refcount;
>  };
>  
>  /* Poll a file (eventfd or socket) */
> @@ -160,7 +161,6 @@ struct vhost_dev {
>  	struct vhost_virtqueue **vqs;
>  	int nvqs;
>  	struct eventfd_ctx *log_ctx;
> -	struct vhost_worker *worker;
>  	struct vhost_iotlb *umem;
>  	struct vhost_iotlb *iotlb;
>  	spinlock_t iotlb_lock;
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c998860d7bbc..e5c0669430e5 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -70,6 +70,17 @@
>  #define VHOST_VRING_BIG_ENDIAN 1
>  #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
>  #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
> +/* By default, a device gets one vhost_worker created during VHOST_SET_OWNER
> + * that its virtqueues share. This allows userspace to create a vhost_worker
> + * and map a virtqueue to it or map a virtqueue to an existing worker.
> + *
> + * If pid > 0 and it matches an existing vhost_worker thread it will be bound
> + * to the vq. If pid is VHOST_VRING_NEW_WORKER, then a new worker will be
> + * created and bound to the vq.
> + *
> + * This must be called after VHOST_SET_OWNER and before the vq is active.
> + */

A couple of things here:
it's probably a good idea not to make it match pid exactly,
if for no other reason than I'm not sure we want to
commit this being a pid. Let's just call it an id?
And maybe byteswap it or xor with some value
just to make sure userspace does not begin abusing it anyway.

Also, interaction with pid namespace is unclear to me.
Can you document what happens here?
No need to fix funky things like moving the fd between
pid namespaces while also creating/destroying workers, but let's
document it's not supported.


> +#define VHOST_SET_VRING_WORKER _IOWR(VHOST_VIRTIO, 0x15, struct vhost_vring_worker)
>  
>  /* The following ioctls use eventfd file descriptors to signal and poll
>   * for events. */
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
> index f7f6a3a28977..af654e3cef0e 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -47,6 +47,18 @@ struct vhost_vring_addr {
>  	__u64 log_guest_addr;
>  };
>  
> +#define VHOST_VRING_NEW_WORKER -1
> +
> +struct vhost_vring_worker {
> +	unsigned int index;
> +	/*
> +	 * The pid of the vhost worker that the vq will be bound to. If
> +	 * pid is VHOST_VRING_NEW_WORKER a new worker will be created and its
> +	 * pid will be returned in pid.
> +	 */
> +	__kernel_pid_t pid;
> +};
> +
>  /* no alignment requirement */
>  struct vhost_iotlb_msg {
>  	__u64 iova;
> -- 
> 2.25.1

