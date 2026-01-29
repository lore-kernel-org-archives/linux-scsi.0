Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1413783C9
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769676140; cv=none; b=HIn1I5jNVeMul+/Puj5dkUVMWzXVh2zlCCBkHaOjZzMVHr05ts0CxMOW6kWZfsMqbhtSj8EG+Ky0mJABX+kVBzmCvIXto19yx0GRAeoP5YdYBYaEjJyq4G1yF0ULASGEvouKOu7XYxONn6LY+SdpPJTmu2k2231CiETxl08Z7hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769676140; c=relaxed/simple;
	bh=Bs6mTjUeA5qkWiBJBxqsJFMQQCY3VsRZlZa2vBfNivk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFlNaTVG7ztpOWJerkrHDTkfAiW47V7xvm7EcE6IEG+AZZw5UwggPYNZNQ8rItLePJLKONQt3/qGLtgwu941CJlc89ZreNbsUGdY2daWhMcP9Xp4/2gmjqnO4N9Ff2MnicTZFTV4FTSVRHvoI0ldV9GZ8C4PStGQsjSa7XW6GfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VWMB9joG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mq5aWqvy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWMB9joG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mq5aWqvy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769676137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=THtu/B0OMAesHMQ0Tb4jSeVco+ToRrfio4hfGUipZDw=;
	b=VWMB9joGXYC7p4SXDrqZ3kZ3eOqnv+1+GtytduFRo7jVG9Ybe1PWzU0Bt8QeKVgfkfWdz6
	zmGDLVMkEvnLW0E9bRuhO3BQN7RGMB8HvHXXW10KrTRrtR3xoELejQ01NarfC09UEGnnFN
	zyLUAx/s2WOiULXH4ByRf/0obMLKfDs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-L9cjfEpkNBeOMQHOmqWiFw-1; Thu, 29 Jan 2026 03:42:15 -0500
X-MC-Unique: L9cjfEpkNBeOMQHOmqWiFw-1
X-Mimecast-MFC-AGG-ID: L9cjfEpkNBeOMQHOmqWiFw_1769676134
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-431054c09e3so498421f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 00:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769676134; x=1770280934; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=THtu/B0OMAesHMQ0Tb4jSeVco+ToRrfio4hfGUipZDw=;
        b=mq5aWqvyQmv8XKxcpsL05xFNhP61yPx8mUM6PcbPlav9+2J+a2Asd7Xk5Xzvo/A/D8
         YADLhS4VMYeN+3paz47G30CRdVTA6Ogaltn2PsoOPaJ+d55xEIJ/OqgOUBd6pxZBmcl1
         yQ3/6bJ7YzwirFNvFH4c7GsCYJoB0QtVW3p8TUQLSoBk3NbBGlcxi7WINp0jDJG76yXv
         ilLWC8irwCt8KlWWqe8LuhFPQYPHtZUZDIYYcIjDNB1r6KNgfP7VRlZUWuiyx8Cis1Vj
         +L6SWkm3ku2hbUf67agmgdb+aUldVPeyCA5ksesY7AGlPwv2nqiduFy+F0BylQenQr1P
         +doA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769676134; x=1770280934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THtu/B0OMAesHMQ0Tb4jSeVco+ToRrfio4hfGUipZDw=;
        b=QMcuFemjCJD0XhnegPOb4qjnTMbXWTPNW6S4425gOVGSTs3+puiT6thZkpTNUeME/p
         DRbzj3TtjMPvO+Qzq6RWVQIbq147ruxD9ZuzZtIxwtuULGWnyGANXgB5VFqSvrvxv1xD
         x/UwcVF9PRASeSaM0nbgrKLByqv56BlWy3uLSNzDU6ShklFj7ZGdoge0hjlk7Usr71K6
         dPWnzHW79g2+DJMHbPhuwEmwqFAys4XgXsagakT6usyzPulsMlTypMDrQj2VizvXl35m
         aaPs+DUifb4Z2fbhA39z3RCtDweAvwfQxLaQaiiQZwst42TPeRGTYuOrFF4ieQfcs4Dr
         HZ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUglhvpIbqxS4fE0Fv+/K2YmtzXA6vUaAwx9e3l8uuHf2mF/HNRoebUVKwyV0e0EeeJjV1yVwN/bx2t@vger.kernel.org
X-Gm-Message-State: AOJu0YwBluOcUM7qwphXC51nH1sm0+lUvk3hwzRtupIstnseRo+PZOxe
	zGEbMCa4CBmV4owFPBB8EKEkLEJumBxVh2xWzd6yO7wuVx7Wk4rADXauKD+pN9gcDvAaRpoKE8m
	ny6baJOspNte1Cel2THNT3d64/1WiU/8/edeaBQRoVWDQxNXG5luOim+9CC3rof4=
X-Gm-Gg: AZuq6aLCQwqes+SV2NITB07m6yNYXG/ApZ2MleaVjh8+llJXPffbbQiXdSFfIZFEU1u
	xLXRq1nDgyV3tox1gUn6f0DM7KOzYXhNaeykNqXYHTho6s0pXcIg/OLL5Yu/+8HCxEK4G5Jd13y
	XI77fiE+m/ffdR5hcqLj7CZqDv1KwlJ/gHHPr8IvNPNlofyvIEEkWufcZs615XWZtJyDGFuFqjJ
	Su/PcGqCyGPcXsSn6SOiqkF6qOiWlyb+lwHDr9IFVx0nj6aHJSZddrTDGdkHrPESxBq/0NWl3No
	v3qAJacuZknuNHi3UzDoAhtI0S8KUn79m9iu3PHudJ+ioBiGogoX2kat2GUOEKvSvBMpoObza8D
	dE/iwbOS7CRNPEZFF3Ye4U8nfhv2HPA9zvd93+dxOHYkayEnx0TAN
X-Received: by 2002:a05:6000:178b:b0:435:9116:c713 with SMTP id ffacd0b85a97d-435dd02db27mr12237803f8f.5.1769676133929;
        Thu, 29 Jan 2026 00:42:13 -0800 (PST)
X-Received: by 2002:a05:6000:178b:b0:435:9116:c713 with SMTP id ffacd0b85a97d-435dd02db27mr12237753f8f.5.1769676133482;
        Thu, 29 Jan 2026 00:42:13 -0800 (PST)
Received: from sgarzare-redhat (ip110-139-192-82.pool-bba.aruba.it. [82.192.139.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10ee040sm12807318f8f.11.2026.01.29.00.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 00:42:12 -0800 (PST)
Date: Thu, 29 Jan 2026 09:42:06 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 15/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <aXsclvInQFIuFe5i@sgarzare-redhat>
References: <f1221bbc120df6adaba9006710a517f1e84a10b2.1767601130.git.mst@redhat.com>
 <ce44f61af415521e00ab7492aa16d3d19f00bd5e.1769632071.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ce44f61af415521e00ab7492aa16d3d19f00bd5e.1769632071.git.mst@redhat.com>

On Wed, Jan 28, 2026 at 03:31:21PM -0500, Michael S. Tsirkin wrote:
>Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
>last. This eliminates the padding from aligning the struct size on
>ARCH_DMA_MINALIGN.
>
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
>
>changes from v2:
>	move event_lock and event_run too, to keep
>	event things logically together, as suggested by
>	Stefano Garzarella.

Thanks for that!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Note: this is the only change in v3 and it's cosmetic, so I am
>not reposting the whole patchset.
>
>
> net/vmw_vsock/virtio_transport.c | 18 +++++++++---------
> 1 file changed, 9 insertions(+), 9 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 999a0839726a..b333a7591b26 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -55,15 +55,6 @@ struct virtio_vsock {
> 	int rx_buf_nr;
> 	int rx_buf_max_nr;
>
>-	/* The following fields are protected by event_lock.
>-	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
>-	 */
>-	struct mutex event_lock;
>-	bool event_run;
>-	__dma_from_device_group_begin();
>-	struct virtio_vsock_event event_list[8];
>-	__dma_from_device_group_end();
>-
> 	u32 guest_cid;
> 	bool seqpacket_allow;
>
>@@ -77,6 +68,15 @@ struct virtio_vsock {
> 	 */
> 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
>+
>+	/* The following fields are protected by event_lock.
>+	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
>+	 */
>+	struct mutex event_lock;
>+	bool event_run;
>+	__dma_from_device_group_begin();
>+	struct virtio_vsock_event event_list[8];
>+	__dma_from_device_group_end();
> };
>
> static u32 virtio_transport_get_local_cid(void)
>-- 
>MST
>

