Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101192;
	b=z+mcotPnLfrfik8V5Ytq5KP5kWMNfW76gifI4oU85rHMTwWOiMoMUxgcuhggKGD9QnOS
	 bdkwzjq2joVSe4EhwtFRPP+kVfcpBZLnjBEltkBqMeRg7MeWpX2BqHkkWe8zVOi55RUdI
	 odgtvTTnj34yxsimo7urVhEsAfENjj2bsE4sX7OVrRqHSjvv7O4cjJEetCvfO2c1IAU1K
	 kUDbDtmvmwk2MQd0jTVBROBOR2eOlhj7dK3BMYhfnCAXOcmiVb22016KntQV63/FQhlv6
	 SuGNLhVnu5CAIGJN07kOJPXsn3wEfh0RCI7WVX150TvjX522jWHkpMuL6zAyzQQ2LGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101192;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aUaUnGVOD0AnB0qQi2tHlDtmvMhT+a6tdGKKo0EDxDI=;
	b=aG/tu62EvWRkc6mOK0/xkUbNK4rf6998lzPWuhzAMU1BZiULwEw8HaEdk4ocVPP0bEZV
	 +8nv/QlkaFNzahAgBcpJDSRL4XjsdQUiNDJI2txstVDkTeh9f/68YFqVCgrqWNJmYj9jc
	 BSPi1elclQk2h/JqF41vt/ik/ZvPeBKWMifVq08unoMFm6M6Hpqp4ub2aeUT8tu3j/Jhi
	 9WUwrhrVpQiZxTS82bnZNxKqeWaAp/ElOeFSl7Sv6ggpdK3ffziVLzrCKpcrzno+UB0d9
	 qr5FOl76PFylzO6IqQcHuGsS8HnLFsspoAED9m/rIpDAqvYkpgZ3ZBfxQsC+c0rt4tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cBBWWVap;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=uIMFT2Q8;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC8160A2600
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 15:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DC8160A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cBBWWVap;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=uIMFT2Q8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795101190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aUaUnGVOD0AnB0qQi2tHlDtmvMhT+a6tdGKKo0EDxDI=;
	b=cBBWWVapW56sdmwQY5UMddI0JZ00u44zAESJw/cYaa/YKag+oEGwM+Y94SS/4m80b36Kgu
	jVzZlwz4hIox9aSwqY0g3Dz72dcTMHA/XmrVtIsinizMVXyKEOJldOUFWaorW+m2SJcBu1
	L8cH9GoeyXINmgQjiv3wDumYUXgu0FI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-AAkxnjnFMPWKCXnpIynKgA-1; Thu, 19 Nov 2026 10:13:07 -0500
X-MC-Unique: AAkxnjnFMPWKCXnpIynKgA-1
X-Mimecast-MFC-AGG-ID: AAkxnjnFMPWKCXnpIynKgA_1795101186
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a35db2d6b3so17129595e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795101186; x=1795705986; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aUaUnGVOD0AnB0qQi2tHlDtmvMhT+a6tdGKKo0EDxDI=;
        b=uIMFT2Q8PmwavS9NEqE0h+UAUF0TVPPrepbqUcVYtImSmrBGEpC/IpWDBJ7mtY6zmZ
         sbQ1uIr2CnqNvfjn1DlAq6AtwD9dPCNLnMyGzQZgSFvqMbuC2DAP99pBymaYMf/xx20o
         MWpEpEK77N6KDJ7HYgKlPRvaT5Vh+DrnsqbQGV/jf8N3qI+dtm52bKMcItGA8tnsm9bi
         8hCR9ok+WZR2vRkBQvA7jIbMBoCw/f51ruQWTRjG2j+wEHH2yKf7N+i3kTeh7lEevBdM
         TS5ZR73v3NH8ivc0PEGN3k8BOrxCae2Jol/+r4LzeRpe0hV8im4QOJb7GaN20LQHP8Wc
         eBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795101186; x=1795705986;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aUaUnGVOD0AnB0qQi2tHlDtmvMhT+a6tdGKKo0EDxDI=;
        b=C/qXS7qrWmJgKPnZPHq1z5sBdeqrghvxxHiMXdnpAbIS5JW8UqskPT++nOoRGTKXqI
         AhEUDGpxykjhZdIyrO9wspkFR6gddfjTDLy5xPjUs6ATOBGWGzuSizvie6ZY0DXU+mNU
         uX+xVoXeQwdaInZgugF6I2OOhif8b16tJtE3MUMuiSVBq3/VYtEE8DobYvIUaxe4XfRt
         OXY4bNsvhb6rvcgfmZm4pwZfuoKlRN/MYeh0NkmxtCl1ZXz7v7ibD7T5dSW6WH03zOrQ
         mu6zOHnj/zwKjiQVxSl+jB51tqfE6eyNZJPiecYm/GvbZs1IcUn9GdhhXTOWJBg37PAU
         DEOA==
X-Forwarded-Encrypted: i=1; AL+hErFukZlcHd6k3o+/NAYVFrmI3q1O5UwI/ImBgQRFRDtE7dQk8CHuiGJD/N8XC8u06Vdz+uip1LwVXH4g@vger.kernel.org
X-Gm-Message-State: APuU4Z8EoLxDPLP0ApCkfk10Oj8d/dQLlmwc9R80e+z8CvSFjD7RzOtP
	Mmj/V6po2h5XSlUDLxs4sZGFtfMXznG1Xs2cd+TZGS/r3hAqjPwb7UtFFMK3Rn1htm5FXZsx/d5
	OGA+W5bhh1orxeZ+1gLHSh/itUUhAnH0GkEYrrCVMRcnlcVVpkArMd7582Td+zZg=
X-Gm-Gg: AYBFou3MZfK1mgZWD4eU59FzfS9EnvnoSxU6TR7EkNUg1I02Bajq2OiR+8ntkqkgn59
	a+NNi7pUDXzdnA2MhvvHXBix+reYbYCkVDhpAAcmnfAQFwpVkWQk2sS+XR0aa4+2okXjoepsyOu
	0fXVzyht+7RoZzbU6/6KqbwIr5id9Fth3EqY3IaTo32o+GP10KY3hAlprQCVKZ4v4VEU9JJO97c
	B3sm4Pd8wseMeynq8cHCqmVwKIO8xzDSC7MYhyfmW42LtuPBb/70D2A2gGTkT4uQhsdlQw+LHQ7
	myDAT5xzmU3w1n5FXitABfYPC0bxDj9CGArfl6GYAMAq6cIkPp+HZG43okT65dmKY4/+GED+G5E
	r7xj+6n/Zp2h5LIPiCmDJ3IKQ2LddVYmfHpOyAVtD4g==
X-Received: by 2002:a05:600c:3107:b0:4ba:eb:eb9b with SMTP id 5b1f17b1804b1-4bb7da1272cmr124142295e9.8.1795101185845;
        Thu, 19 Nov 2026 07:13:05 -0800 (PST)
X-Received: by 2002:a05:600c:3107:b0:4ba:eb:eb9b with SMTP id 5b1f17b1804b1-4bb7da1272cmr124141275e9.8.1795101185168;
        Thu, 19 Nov 2026 07:13:05 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1522:6500:ac93:c62:f076:48c6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884a3a3dsm3221365e9.10.2026.11.19.07.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:13:04 -0800 (PST)
Date: Thu, 19 Nov 2026 10:12:58 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org,
	loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
	vivek.kasireddy@intel.com, jasowangio@gmail.com,
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
	rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org,
	jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk,
	linux-mm@kvack.org, James.Bottomley@hansenpartnership.com,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	phasta@kernel.org, joro@8bytes.org, will@kernel.org,
	linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
	tjmercier@google.com, harry@kernel.org, vbabka@suse.cz,
	cuitao@kylinos.cn
Subject: Re: [PATCH 3/7] vhost: account the per-device kernel allocations to
 memcg
Message-ID: <20261119101239-mutt-send-email-mst@kernel.org>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-4-cui.tao@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106131829.3228926-4-cui.tao@linux.dev>

On Fri, Nov 06, 2026 at 09:18:25PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Everything except the worker struct is allocated with plain GFP_KERNEL:
> the per-vq iovec and log arrays at VHOST_SET_OWNER, the memory table at
> VHOST_SET_MEM_TABLE whose size follows the user supplied region count,
> the pending message nodes, and the vhost_net/vhost_vsock device structs
> with their fallback to vmalloc.  The worker has been accounted since the
> vhost_task conversion.
> 
> A container that can open /dev/vhost-net or /dev/vhost-vsock, which
> device plugins hand out with passthrough, holds roughly 150KB of
> resident kernel memory per device after SET_OWNER.  Charge the rest the
> same way the worker already is.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

should each patch be merged individually?


> ---
>  drivers/vhost/net.c   | 14 ++++++++------
>  drivers/vhost/vhost.c | 16 ++++++++++------
>  drivers/vhost/vsock.c |  5 +++--
>  3 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 4570a4ffbab2..bab6597c696d 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -249,7 +249,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  	/* No zero copy backend? Nothing to count. */
>  	if (!zcopy)
>  		return NULL;
> -	ubufs = kmalloc_obj(*ubufs);
> +	ubufs = kmalloc_obj(*ubufs, GFP_KERNEL_ACCOUNT);
>  	if (!ubufs)
>  		return ERR_PTR(-ENOMEM);
>  	atomic_set(&ubufs->refcount, 1);
> @@ -302,7 +302,8 @@ static int vhost_net_set_ubuf_info(struct vhost_net *n)
>  		if (!zcopy)
>  			continue;
>  		n->vqs[i].ubuf_info =
> -			kmalloc_objs(*n->vqs[i].ubuf_info, UIO_MAXIOV);
> +			kmalloc_objs(*n->vqs[i].ubuf_info, UIO_MAXIOV,
> +				     GFP_KERNEL_ACCOUNT);
>  		if  (!n->vqs[i].ubuf_info)
>  			goto err;
>  	}
> @@ -1344,17 +1345,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>  	struct xdp_buff *xdp;
>  	int i;
>  
> -	n = kvmalloc_obj(*n, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	n = kvmalloc_obj(*n, GFP_KERNEL | __GFP_RETRY_MAYFAIL |
> +			 __GFP_ACCOUNT);
>  	if (!n)
>  		return -ENOMEM;
> -	vqs = kmalloc_objs(*vqs, VHOST_NET_VQ_MAX);
> +	vqs = kmalloc_objs(*vqs, VHOST_NET_VQ_MAX, GFP_KERNEL_ACCOUNT);
>  	if (!vqs) {
>  		kvfree(n);
>  		return -ENOMEM;
>  	}
>  
>  	queue = kmalloc_array(VHOST_NET_BATCH, sizeof(void *),
> -			      GFP_KERNEL);
> +			      GFP_KERNEL_ACCOUNT);
>  	if (!queue) {
>  		kfree(vqs);
>  		kvfree(n);
> @@ -1362,7 +1364,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>  	}
>  	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
>  
> -	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH);
> +	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH, GFP_KERNEL_ACCOUNT);
>  	if (!xdp) {
>  		kfree(vqs);
>  		kvfree(n);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index ea127af58ada..d1274106ad5d 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -526,11 +526,14 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
> -		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV);
> -		vq->log = kmalloc_objs(*vq->log, dev->iov_limit);
> -		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit);
> +		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV,
> +					    GFP_KERNEL_ACCOUNT);
> +		vq->log = kmalloc_objs(*vq->log, dev->iov_limit,
> +				       GFP_KERNEL_ACCOUNT);
> +		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit,
> +					 GFP_KERNEL_ACCOUNT);
>  		vq->nheads = kmalloc_array(dev->iov_limit, sizeof(*vq->nheads),
> -					   GFP_KERNEL);
> +					   GFP_KERNEL_ACCOUNT);
>  		if (!vq->indirect || !vq->log || !vq->heads || !vq->nheads)
>  			goto err_nomem;
>  	}
> @@ -2053,7 +2056,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
>  		return -E2BIG;
>  	if (max_iotlb_entries <= 0)
>  		return -EINVAL;
> -	newmem = kvzalloc_flex(*newmem, regions, mem.nregions);
> +	newmem = kvzalloc_flex(*newmem, regions, mem.nregions,
> +			       GFP_KERNEL_ACCOUNT);
>  	if (!newmem)
>  		return -ENOMEM;
>  
> @@ -3405,7 +3409,7 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
>  struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
>  {
>  	/* Make sure all padding within the structure is initialized. */
> -	struct vhost_msg_node *node = kzalloc_obj(*node);
> +	struct vhost_msg_node *node = kzalloc_obj(*node, GFP_KERNEL_ACCOUNT);
>  	if (!node)
>  		return NULL;
>  
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 0cb87971d749..600daeb05e7b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -721,11 +721,12 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>  	/* This struct is large and allocation could fail, fall back to vmalloc
>  	 * if there is no other way.
>  	 */
> -	vsock = kvmalloc_obj(*vsock, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	vsock = kvmalloc_obj(*vsock, GFP_KERNEL | __GFP_RETRY_MAYFAIL |
> +			     __GFP_ACCOUNT);
>  	if (!vsock)
>  		return -ENOMEM;
>  
> -	vqs = kmalloc_objs(*vqs, ARRAY_SIZE(vsock->vqs));
> +	vqs = kmalloc_objs(*vqs, ARRAY_SIZE(vsock->vqs), GFP_KERNEL_ACCOUNT);
>  	if (!vqs) {
>  		ret = -ENOMEM;
>  		goto out;
> -- 
> 2.43.0

