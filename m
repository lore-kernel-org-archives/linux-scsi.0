Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF982F12DF
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 10:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089800; cv=none; b=sJALEykCeiaRi71PSO2sEOlT/AWuycRrB4H9N9JWGS33uad1R56Hx67zLL0OMOIBiwjbsPb4819H11KS3HcE3HNzFS48GTFa8FVgfIXZ43/RBwypyjSmgdutq4DtcO06zhAIon2twAIV1EhFxJk5EUhU9bAGEmPvzgJgqrIziYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089800; c=relaxed/simple;
	bh=ikTC7dMS0j+aOW64LriWXLGZXkKoO1gYmsQNBLOSYxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2UkcUyupM6YiLQNaiOmJ8YwJnYi07XaVaUE3ql5ss1nWr5eWk/rCyyvRCKFEvqQ8/XTZHKLECKh4E3CZ59AUkPNm+8K5ppVmnOlJNQrM5RWHCiiOkikomrxVCvQ3z4NbDvAs6z7cvW4ntkDS5M1dGQgbcIEqpGfMAwRtEGzKPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DcHvO8pL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=i4RoF07j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DcHvO8pL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="i4RoF07j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x4agnfRlmC5GgzX5Rd2z2Ldj0cW20QjlA2/E3WP30vs=;
	b=DcHvO8pL73Hb/UKka3D27ZGSX107+HmtPuukfkQqhblKMpjb1xld6BtagDxJZAZsFn6Kev
	uDVEqgMWcHKcsamuJUjp5rH0jnMQuK3Wm8cGRg8XnJkT6o2DCPDhk4hEOEO2bKBHaVB3xB
	o2Frk/HY4WVnHqkJPRpx3iQtGYqgww8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-p-vNE7vnONeAWRMR7A0oPw-1; Tue, 30 Dec 2025 05:16:35 -0500
X-MC-Unique: p-vNE7vnONeAWRMR7A0oPw-1
X-Mimecast-MFC-AGG-ID: p-vNE7vnONeAWRMR7A0oPw_1767089794
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477a1e2b372so77926235e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089794; x=1767694594; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x4agnfRlmC5GgzX5Rd2z2Ldj0cW20QjlA2/E3WP30vs=;
        b=i4RoF07jbiZ9WBc7wJDhu//73X6pQxHb1DqtRSJZsT2eTKQTQoKTjUekZV7lUlwC86
         SAi7JTMipA6B6VaLfUpwhfekUYYlnJzc3vCPjKlkBZRQ7BohHUQczZm+8Cbekj9X8i0r
         Pc5cZkU4g3uzIKARnxfAC0k6ID9y9ce5RoVd+aQ+dDYIqHAuK6U5tqTMjPnd7T1gQMyB
         rR1ZNAZ7DuuGa4AfQXOggLTDQ5LOTQvHnbCxELTxG7/CiVxsZc3O6qpp4gKsvYgaFE7f
         Q+bweP8e9W3rtBvqg0TTbNy+vjrUyx++7R94BPDv6S4+7dPMgkdUvMlmEuRFvTD2nTaT
         Xfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089794; x=1767694594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4agnfRlmC5GgzX5Rd2z2Ldj0cW20QjlA2/E3WP30vs=;
        b=SvNq7FnThAt+73EZgFPqIp3cRq6QW3h2mWzOOSVgK8LGpKljtGzaH1IB/CeVP6BsGW
         hmi7OBKWUch+6CDURuFJrlTiqQ05eL90UlKqSGcdPbC2x86yfmk/NstH/Km9Zf6Qi9DG
         I/STmVnIzLY9SuZQV20hrd+gJwrv7+MgGzJ7ZwhkxeNEel1SFiaLVi5zTFVDJrED3xaW
         +m6Hr+YqSIvz8yNYZICg5xyGu1GeUH4WqrEArZ5zI/mclXrzBAtaEXJuAxOuDXFY8X/l
         SeJIeq+DFW4dqelrmU9XeYhhZDfZRBXh6mPeT8nciCUY1s2WvcXvGnIgzytXF9NNcsT1
         fF7w==
X-Forwarded-Encrypted: i=1; AJvYcCUqEu8rZPjcsdLRIXrdZzi9SsfzZLsTSzwHFtEhi40x3u7eJgaAZyw7wkhnOrdFfey4odcG0l1jmgTV@vger.kernel.org
X-Gm-Message-State: AOJu0YyOTtbjxRX40QahsTPLXt725thMeChMCKn9rKtZ4Yl6chmF9qLh
	67022OzPOM8wTUY3CtoKtxsCVYvqtbdyJ5R/qGJQkr2N4mW/pBZNEEkRgjJ8Bwkftn70nknOGmW
	pfqCW1faqo1j+vZOWgn20ZsudpPUOmNrr5XZGZAZUIM5Rdc7J5yFulJvSkObeLQI=
X-Gm-Gg: AY/fxX4a8mG2KC0rIdCOUAV8DDcw61/UXuOTJ5QO3ww0O5kqJSr4UVIPDhGhI+QGnTl
	g6u2XA04iK5uoVlG/GW13YNamiWWw6kFQbqsuPXOjhYogVp7q9OvBVD//9jaoWM3IxdOu7bRjdh
	3NHNnZGAFKdDoIqY/xjsIvQx5ig+o1rLhEJkLWkUSOrB72nku0WJ6vz5vD+5kGZD7A5XQ/TsYW+
	J6uge9UD0HtbnmL8frkeXlJlwEyStk8W9rkZF/RFoPFI4eFzCTZ4xwEJU+OHqCJdwzbG02NzISl
	Al/Vivi1PLME+2m2Ko8ARo38Cla6c43ae3et+nO0mIxQiQ2FJMwXUTrARk/CfeJbDdmwoAiat/C
	KhYJozAoLsQeKH7AKqEI+HVf+gPS7XT4e7A==
X-Received: by 2002:a05:600c:8b8c:b0:477:af07:dd1c with SMTP id 5b1f17b1804b1-47d195aaf01mr352317605e9.35.1767089793801;
        Tue, 30 Dec 2025 02:16:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/8/udlvjg5mJuYpI0a3oxpEJUtwKIPq+rFtOrgdem6Ktq8tTHyeQzy9WGlYRf+5N+zum/GQ==
X-Received: by 2002:a05:600c:8b8c:b0:477:af07:dd1c with SMTP id 5b1f17b1804b1-47d195aaf01mr352317095e9.35.1767089793385;
        Tue, 30 Dec 2025 02:16:33 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm638896415e9.12.2025.12.30.02.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:33 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:29 -0500
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
Subject: [PATCH RFC 13/13] vsock/virtio: reorder fields to reduce struct
 padding
Message-ID: <dc7de7774ae19968549cf17336c15503fa7d10ec.1767089672.git.mst@redhat.com>
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

Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
last. This eliminates the need for __dma_from_device_aligned_end padding
after the DMA buffer, since struct tail padding naturally protects it,
making the struct a bit smaller.

Size reduction estimation when ARCH_DMA_MINALIGN=128:
- event_list is 32 bytes
- removing _end saves up to 128-32=96 bytes padding to align next field

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f1589db5d190..2e34581f1143 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -60,10 +60,7 @@ struct virtio_vsock {
 	 */
 	struct mutex event_lock;
 	bool event_run;
-	__dma_from_device_aligned_begin
-	struct virtio_vsock_event event_list[8];
 
-	__dma_from_device_aligned_end
 	u32 guest_cid;
 	bool seqpacket_allow;
 
@@ -77,6 +74,10 @@ struct virtio_vsock {
 	 */
 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
+
+	/* DMA buffer - must be last, aligned for non-cache-coherent DMA */
+	__dma_from_device_aligned_begin
+	struct virtio_vsock_event event_list[8];
 };
 
 static u32 virtio_transport_get_local_cid(void)
-- 
MST

