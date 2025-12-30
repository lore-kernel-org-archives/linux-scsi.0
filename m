Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8FF2EA468
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 10:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089778; cv=none; b=rKOCP9dORY9ZPFihjwlavwp35MAsoapJO4N9YypGE0Yqm8vENTi7ZlmG0trofMJqpjZyQCJZegh6i9MqSGccI81wxw0jMMUD+QYleFJsqSPlu/6qiKgKSjUJrgbRYR/9On3y7knn7m4hP6VlawLkVIj8yNIMeiIYleyVs8Gq3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089778; c=relaxed/simple;
	bh=1nvGVVfYMss4t3CEcUrrF8Nk2cSppyMGKm3YyiTIiKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KiBGKZqHs85RnrwN/hYWLTfUW9VBYRwZ/g1feY8deNa3DO5wRB1e9LR2CubeZs4yOe29eyCHtjdoeb4z7jajIwwjBHXCFPLclDIJaNwcKK6oZZ7vHUcey2q6LG6/ULoSYT2dQZXLnpHp6Zz+Lg5U6fkFmmovvGzpQGWzeqcYSdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JUV93+Gv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8kiRJdc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JUV93+Gv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8kiRJdc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
	b=JUV93+GvNWX3nxpTw8cau2vP30RBijuoxCYWrIDxyYcvX4p3XvCk95xccbON6+L/U3eb9t
	si8hWuSvT4Mt3QErEjU5PTb0AlztpEMPM3HXaJlVfXud/33UjYfqDajJuESmoRTs+TkhT4
	8bBFTetu85d5QnbDKsQ6WrE2G/IJ4h8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-twvgMO1iOfe26Kz8VKbgNQ-1; Tue, 30 Dec 2025 05:16:12 -0500
X-MC-Unique: twvgMO1iOfe26Kz8VKbgNQ-1
X-Mimecast-MFC-AGG-ID: twvgMO1iOfe26Kz8VKbgNQ_1767089771
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47918084ac1so83216245e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089771; x=1767694571; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
        b=D8kiRJdccnjA7UBfQdPD1dIdRkpZkqA8vResLYU9t9f20l4nQJx5GuLg0IRRo4HmkA
         Ez9QUd8ztax/ZM6qlWpStt6ig9rAwGG18m9odbjAYC7V/8aib3iWrs8f6Glxnfo92e6M
         kbzp51OUt/jpLMIaQ9dSi354rrPCe5h6M+dOEHdwzUrk1FtyKjQU3A+QpWIY5VrGfgPZ
         GasDPxSRI4RFXD/RE1XwOWs4ZpqcTdTHkb9bC/VEyiOzSm70/GLjGNOKak5FNDBdiJa7
         ZMR2k8LgePJspuqK6/IhpTuKlpvOtJWOoqS7UikPR07hhtZjj/ERppykuPbLuGVi1fLU
         yJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089771; x=1767694571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
        b=TBT+7fH2CisLszWgVaoc8UDaPN+hNRj7LS1MfTJ4YYmNxajnQICNo/oNFK1ioDUuJv
         gharZPFCezK3mDN4dBzFx+5VviFDCa/ClGhmY4ObxKLD2wjTLdiar/SHPiqZH2npnMnY
         pDv3ropnRYCHFo+QkECaQGas+E2F/lPXY3baa6EHal//BtexqryCrGs8b30nSKjQXJ5A
         cAXRVwR/i5GEdUIJ1mdMkBLRrXtUX4iy6GI5f7HG+x4jfC0RsIE/rTUktOSUOJhaMF9Y
         38ZH0h3XKsVr94HE8PfwD9NB1uOs49HfbNewjsqVybEovxU3aPNPL6QBlLJlG0NCpeYX
         YmVg==
X-Forwarded-Encrypted: i=1; AJvYcCXWYArrPbJC5++UcOLfHITjd7zigt/TIfUznMda2urQPSLXNljuA9XPy38Wx9bsU1SHSy/VyzxRD5BA@vger.kernel.org
X-Gm-Message-State: AOJu0YzFNfrroyisS04Sge+BivcgOJcfJ6CftUJAEsY57c7wrXFItmgn
	QSdcGgOn/ybrFCYnMv6qSwZ1hsKWhgLqD+oqfLv+uNjW/ADJh3Bdm0mzM9rVqEUi0zEN1ydollR
	z5xX1ut9xsEIGCI2p9RjtdG/CuY1x992K8A0ON+xKNhS81Czoq9kYjMEGMV/ddQw=
X-Gm-Gg: AY/fxX53zocBIw8CDAdJdceRiTQkdj6jy9873SWnIFDIhhrXOWYlkt3LpNUpex+rcQq
	6lx0Dr79mXP+q3nBSV+/8EPAjosd6HF7/4bztay6Mhsh8yBCGgRBE5Ls1sLnW8/3F7BE8/wWTeR
	+PUJSBBrMAVmjwuyFAFA8bK6Qh7uwjN6U82JfjgaJ9SqDbuJl8idXOsIZ3GMNO490WIOaZT2Oep
	YGiJjRNDihmWkucKE3jzdJVmyi/+EEBJ6IpBv0LSqK82s79+8C1ozmxKJZ6SmH8LnlPO/1Ja89r
	1ZXJw6Uq5MXsRrDR9Jfd32XEMq6Hjlc+lpXypngaF3SiqaIevfpK5WyOv/8KrJ8qUbEBGvBC3D6
	d1IcwjDx88bR/R08sgYyanUv+Ik/DrPnHow==
X-Received: by 2002:a05:600c:45c8:b0:477:8a2a:1244 with SMTP id 5b1f17b1804b1-47d195558bemr375729625e9.11.1767089771382;
        Tue, 30 Dec 2025 02:16:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjzVX0GYuttaIVhsj3PIAp1ZJ2Zp++QasW4yFBwV4WaDkrZ/icz8/Y8CMg+xDJDk6ilEld2g==
X-Received: by 2002:a05:600c:45c8:b0:477:8a2a:1244 with SMTP id 5b1f17b1804b1-47d195558bemr375729355e9.11.1767089770967;
        Tue, 30 Dec 2025 02:16:10 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193d4e91sm569777955e9.13.2025.12.30.02.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:09 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:07 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 07/13] vsock/virtio: fix DMA alignment for event_list
Message-ID: <c195bc45032be85c3f0bad7362f0ba0a4e8a7726.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

On non-cache-coherent platforms, when a structure contains a buffer
used for DMA alongside fields that the CPU writes to, cacheline sharing
can cause data corruption.

The event_list array is used for DMA_FROM_DEVICE operations via
virtqueue_add_inbuf(). The adjacent event_run and guest_cid fields are
written by the CPU while the buffer is available, so mapped for the
device. If these share cachelines with event_list, CPU writes can
corrupt DMA data.

Add __dma_from_device_aligned_begin/end annotations to ensure event_list
is isolated in its own cachelines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 8c867023a2e5..76099f7dc040 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -17,6 +17,7 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_vsock.h>
+#include <linux/dma-mapping.h>
 #include <net/sock.h>
 #include <linux/mutex.h>
 #include <net/af_vsock.h>
@@ -59,8 +60,10 @@ struct virtio_vsock {
 	 */
 	struct mutex event_lock;
 	bool event_run;
+	__dma_from_device_aligned_begin
 	struct virtio_vsock_event event_list[8];
 
+	__dma_from_device_aligned_end
 	u32 guest_cid;
 	bool seqpacket_allow;
 
-- 
MST

