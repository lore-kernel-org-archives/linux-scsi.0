Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A732E54CC
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 10:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089782; cv=none; b=Mz7ofli5lI8N18jjPdP6cFS0IYP9zIXNMm/PKi4FJyynyJuKVdS1zgcudtXYm/cuK+0zu5gKxKIo4TBYwSIUqBMBHva5M7BSr/LKj6LW0hpGDTXjOM/bao2xoNg3ZWcFzziyT3bAO+SqSZPRiHjf0zqm7tVRJs31B29W6L6ApoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089782; c=relaxed/simple;
	bh=d79M2iBKtK7/e3UWQBP6Z7XMZcGHJdPNMKAqQ6Eyk7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7CN1sqdDjtnpUK80VJeMwNwHz0aGHVIK86wQfldn3vs2WQeamVHAgoYiLjSWomOQSmegbVo9w4J8tQQbDp/WwS2QZVCUYaRhreyIV8OxtAwJ/+azsgW97ppNsk8Gto58dR4r4xOXY08Jz0HTpLL+apmUNit1Nffc+U0AFq/LVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ejYUk1rL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LlNCUSCT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ejYUk1rL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LlNCUSCT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
	b=ejYUk1rL/4/xC/SeuvqlSizjOTFA16yIVrcVxZFu2jjrtRJtE/sU+Js1D00Ai01Hhygr70
	4QPxn/TMjQrZI3y9UcAsSU5ff9c/hrWLkpmNcUpGTlDXEuWTPKv5VU095aXTHBmfKJxEAu
	fepOBPhd3gKyhusFZ2g8jJenmeWmj+M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-gefo95nFPtCZOQ4IZWkjmw-1; Tue, 30 Dec 2025 05:16:16 -0500
X-MC-Unique: gefo95nFPtCZOQ4IZWkjmw-1
X-Mimecast-MFC-AGG-ID: gefo95nFPtCZOQ4IZWkjmw_1767089775
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477771366cbso73693295e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089775; x=1767694575; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
        b=LlNCUSCTByjGB0z6MsJ1GKRqOrCxKlKxKzGbqSTZscLcZoTmQ33rpW4PooijX2SKVN
         GdkPVv4kz1LwJMCcxDEH2rdpeJZYlU2q2NV15nRJomG3W4VdIg1TwNBnMdL6duDLsEj6
         SITH5U1beqZ3WfDoinZ5ccYNG8KVhPM25lpkP+r6vRtu77abiGOAOUNe1a4fZcHjaOow
         QyauQS7ID7RPNlGTYYk4/rDckAGeF6YvUt6WatWjvM/7XW0IxNcVX2ZRhqBuR/wR0Vo/
         DXHHdKifRDH6ve+UEv2h217bxnJzEdsyVFp7qYUm82SPivQVvNpJTZT/GD/aKchdj5cO
         BPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089775; x=1767694575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
        b=dDDyHEjFTD2N1b3p8muQ0YaXJzV7WMB8rw1RFroeIk2Ddk3xqVQbI6Bjt4uMshxriQ
         ZExS1q+2oKhizRLqlgneel/Nb41Ct424LNBgToGHvQXlosVMhGMMwOW+1OXWYofjM3So
         feWVJnU0wlvH+GkwV8WWnOWu6ti5oh4QAm0CVL0vPVizAROH7zfRrCSYWMlJpSOyuceY
         6q3U6rzZB//kV1TFu3HFB8qXfw5iPZiYyWZa0uv54qvTGssVXEZqo6w1vhpHqg9o8K4m
         3fLNn9G/9FtjwHkoQ8dZ0/joY6XM99AGsELMS2ynhWF4pk7B91DFHk+fkW0ph6QWO+EV
         vJTw==
X-Forwarded-Encrypted: i=1; AJvYcCUuYUuDKvVg2Y9u1Wb6WdoSMPgVw72gkrP/7qYiWfy+bn0JYDBf9a6Spvk4HOVlMQejSTwtdHRTfn5K@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe4Vhty8XRlcDzPtC+th079aHZDtYCLWK3tKDcP8EjV6Te0Xrc
	OrqkhemaYFln0fYOPfD+GuJMqWCkb8KGN9ZoV6kRv7R6nlTnmNrYKRvji735o+ZDQWfaqWWPRvn
	5oSeJykHqRIqO+/A6qHlY36WSt6g/3Zv757Ric7ORz9p16E3KB6GWgXOcZmMAYdY=
X-Gm-Gg: AY/fxX43ZCsFcXeUZS2J7zuoQRSdbWYOF14bWvKKmzDewaf9IOSJPU6EiCTAojFE0qQ
	4S2yCsj8kVik+zRKNe9/mbefelYmbew0+WMYW7CsQzKMwfw4147kk130uad5q6T9C63v0rDjarS
	EtPoEwYJ8vk4nf4gqQdyzSIoI2clGL3Zy51xg5G1vG1powf0dMma8rGuf/DfCnW1P5gm6oz0Nq8
	8O80I9Y/VpXhvRrpD3pas5RjZAWxTNj3pSMhmJCIBairAYe5Dz0Kg8oO5WymoXqhNO2BwLZRz3M
	dfdWcRRpWh7L29BJ5hvzZpGeZ3e5mMe6Yms9qDveg21DIEoA7B3L7gyEfL2Ye9/2xHKzxVQHJbl
	M4GHTbFNL/lgXOV9zHYQ9/E2PmDqUnIVHMw==
X-Received: by 2002:a05:600c:500d:b0:47d:576d:8140 with SMTP id 5b1f17b1804b1-47d5b261006mr54433915e9.24.1767089774867;
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhdLHPqUgLnPyVKN6hwhRQFuXWAPZjO+w56XwRJ3KNAI+UkHXfY0sXelHGWgys0dAYrWVbAg==
X-Received: by 2002:a05:600c:500d:b0:47d:576d:8140 with SMTP id 5b1f17b1804b1-47d5b261006mr54433635e9.24.1767089774436;
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be272eaf8sm630015255e9.5.2025.12.30.02.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:11 -0500
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
Subject: [PATCH RFC 08/13] vsock/virtio: use virtqueue_add_inbuf_cache_clean
 for events
Message-ID: <34e5e1af186fc92ab4ea6cf6c9f5550a40c9567d.1767089672.git.mst@redhat.com>
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

The event_list array contains 8 small (4-byte) events that share
cachelines with each other. When CONFIG_DMA_API_DEBUG is enabled,
this can trigger warnings about overlapping DMA mappings within
the same cacheline.

The previous patch isolated event_list in its own cache lines
so the warnings are spurious.

Use virtqueue_add_inbuf_cache_clean() to indicate that the CPU does not
write into these fields, suppressing the warnings.

Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 76099f7dc040..f1589db5d190 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -393,7 +393,7 @@ static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 
 	sg_init_one(&sg, event, sizeof(*event));
 
-	return virtqueue_add_inbuf(vq, &sg, 1, event, GFP_KERNEL);
+	return virtqueue_add_inbuf_cache_clean(vq, &sg, 1, event, GFP_KERNEL);
 }
 
 /* event_lock must be held */
-- 
MST

