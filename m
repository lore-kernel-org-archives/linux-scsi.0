Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A7F32A3EC
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601429; cv=none; b=JZ+ulDIZLRLHFJ08jAClYsW6+rIIQKFAJPMWNd3BRqL1UUwND5GjoLe9OT47Lge3nj7YUVzWukP2Wu5peOffMGuISZGU8gTF3kYgEQo3/fgahnQSpQRCfcnseqY/BKdgx5bKC3HXu4M23eAL9n/HWPR1UIMhgVTb9xMPiQ4O5wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601429; c=relaxed/simple;
	bh=aG8SdrVHEUE18T+idL+tMCWXHe6vRndhmeQnti1MW2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnetpVd1hhE24P+/RNMRh+E3W5/YE5ro0t71WfWjVBfP+r5Koyeu9GmLXxm5tQg5MNsm+wqk8IQUybEEg9X5qkvhppJ64MwvrE0wRVPODvo6L+3ZWrWinNf62EezVXrZmdg/MJl4NwzmvUnbNIKBcmrt5/s+ScHBnFqUFzGh7Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IJLOHygn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzj8+3r1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IJLOHygn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzj8+3r1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1WdygBrbpusefWmIaX+oAwz9bur1qkKHYd3aQzYNeN8=;
	b=IJLOHygn0jycrG+u+R2SxrrlpafXVcHrKb1JC2w8pPPPiq6z9M882Fus/umMrY5tKWf8A1
	c2c/0v7xocDq4o1d18R8L1W5IfUg5RCtcAsMWVq+xvCOQt5sSKnsHDvb9CJHHDCd0fqQtQ
	BPrSf5x8Yxr5NCkUB6i1nKgtt63QsTw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-AY_gPyadOTeaNss024OPTw-1; Mon, 05 Jan 2026 03:23:42 -0500
X-MC-Unique: AY_gPyadOTeaNss024OPTw-1
X-Mimecast-MFC-AGG-ID: AY_gPyadOTeaNss024OPTw_1767601422
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775d8428e8so117044065e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601422; x=1768206222; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1WdygBrbpusefWmIaX+oAwz9bur1qkKHYd3aQzYNeN8=;
        b=gzj8+3r1o0cFHAQ7sZymVhJnTPnFxaw9A9PWo+1eUB+fITz0zBpkk7Gog1DH+Y5gTx
         C5oBNRPdIZE6l4XYxGBRtlc9ZkpeI1LFo0IuvtxLUbghkGjxP7rh+gg7pcgkbgvdp6h2
         F1omXaiTwUHKELEBL9PrWIMeYMvvswWmgiDBinTJUcViDLn5p8G7pkcphVbcHSjicmpL
         8U6UBQ2N24AVW3VZvP77apOaWZz5K4ARD/MprGTaZBEjiGGAAzXYZxj36rtIdBNj2qvV
         PutMvcbT5WoxEBVZJ8j2GRbCeunwhkr/Ywqk1TQpyBvwJZ9wIqfvJbKxsce0170fP9b7
         XIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601422; x=1768206222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1WdygBrbpusefWmIaX+oAwz9bur1qkKHYd3aQzYNeN8=;
        b=EX6JQ8Q6d5Z13TZmNaiwHaVhOPkpOafGozjlGBoov44N6jwzASDlXwYPPc5mru84/V
         iJUFSWZS+fCGiEVx0HX9HCl31CjbnpkE3TDOd0CHCXvQB4g7khR8NFVsX5BT1CqVjcLU
         D9feYx1tblzEuET/f10GR7OggiZ97mDFeTgPVAt9uzF6qoEvLbOof+1C9tufsZVSTYxG
         qBjA6Vh6yfJ3rZtP9hR8drRi8Ucl3qgRZbCQm8qxVoo3j6+yXBrj/KFsqreuwRGW01PT
         cvoICYWf1/yA2Kfqxw5hDuZKdZlZOGsP4R82kgnWzs/1hFn6CGaKFN17AVsEBAytPl5K
         SWvw==
X-Forwarded-Encrypted: i=1; AJvYcCUYW2tmrOLNBDiaZaqxEsoL4nK9aWz+DrxTPQQr3e2FFh6gm99/CeYbywMxhXdSuq6e34S3Q1cbocd7@vger.kernel.org
X-Gm-Message-State: AOJu0YypD20dR7M/bdQvNsPYkDHS187NEx72elHcHGwI7Xi+RVTc0Be9
	lkrNgl24qrcaaAZtfE+trxh5bz53KTSIHAD8vEr6QeN4XxKl/MkPEtI4m+lq+xrBn2zpgwd4VBU
	QBYAu6y/RiC3j4SEv+u3EN1VN0vi+etDMsugypnG67VkY+Dzm8s612kXQtumAWbg=
X-Gm-Gg: AY/fxX7lRwRrdIy1dVDWfNc1FVgep9prXV+kidui0SWndNkwgoyWYHj1/gwaTAtlVm0
	GVPWuSISnADvg85YwZdw2NRyQ3cGZ6wupfQk1q+5nXQkBsMa/ooPgh1g9/MrCCJIt4HQBeZhq1Z
	Z5Jb8tRKFnvwsrgbwrrJVsIfUbj2+4ZnIJSKIiRdAn23+Fm8Pdv9n+BdFHHGagQ25MK0uxZi5XA
	vPy6OfOw6RYfnbSopAj0fuEPSjdm3etS8dSxEzdFg0GphYQNFMm328s9rHtPL0wKqtXKPou34pF
	4IITYOnWA0/U2cd2kErQ7G/a60eDWQ9mjG+eUqZY3suDCTwJ4BdYu4vgBn+q4TfPCsAB7SDBa75
	kqygiNkFKuE649EGlSt5BQhGGpH6Eqv78Dg==
X-Received: by 2002:a05:600c:1e1c:b0:47d:4047:f377 with SMTP id 5b1f17b1804b1-47d4047f3e5mr400615155e9.36.1767601421772;
        Mon, 05 Jan 2026 00:23:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0AgOv9S8mcPvJ16vNEXPXT2v+oy4k5XMxl4opf9hSfJCRKVIgJxqAgfJFXStW11yISqh4Rw==
X-Received: by 2002:a05:600c:1e1c:b0:47d:4047:f377 with SMTP id 5b1f17b1804b1-47d4047f3e5mr400614705e9.36.1767601421303;
        Mon, 05 Jan 2026 00:23:41 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d33eefesm137323605e9.12.2026.01.05.00.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:40 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:37 -0500
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
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 12/15] virtio_input: use virtqueue_add_inbuf_cache_clean
 for events
Message-ID: <4c885b4046323f68cf5cadc7fbfb00216b11dd20.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767601130.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

The evts array contains 64 small (8-byte) input events that share
cachelines with each other. When CONFIG_DMA_API_DEBUG is enabled,
this can trigger warnings about overlapping DMA mappings within
the same cacheline.

Previous patch isolated the array in its own cachelines,
so the warnings are now spurious.

Use virtqueue_add_inbuf_cache_clean() to indicate that the CPU does not
write into these cache lines, suppressing these warnings.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index 9f13de1f1d77..74df16677da8 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -30,7 +30,7 @@ static void virtinput_queue_evtbuf(struct virtio_input *vi,
 	struct scatterlist sg[1];
 
 	sg_init_one(sg, evtbuf, sizeof(*evtbuf));
-	virtqueue_add_inbuf(vi->evt, sg, 1, evtbuf, GFP_ATOMIC);
+	virtqueue_add_inbuf_cache_clean(vi->evt, sg, 1, evtbuf, GFP_ATOMIC);
 }
 
 static void virtinput_recv_events(struct virtqueue *vq)
-- 
MST

