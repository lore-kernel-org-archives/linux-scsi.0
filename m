Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC18B329E66
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601429; cv=none; b=r5YRa7Jf59sFizodSWAk5Zf4ZnpqdDRsMBwp+9ATnOh+AmtKg22Ssw49vXnEHkkdLDHuYiCO1NrL6kNVynfZblfgqQ/VCGugKFH1biYORtUvyHROHHVACXkT8llKpwOygf8PL8IcGn3suYTxwNLHJViO9WAbBGIpn6zH91+u8qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601429; c=relaxed/simple;
	bh=HzYnyY7SZLB21Zw4R22hNRsG3Q5nx5zt5Jv7qf1jNBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NR6CTIrXA0o1xieSoS1D6rujNWv9w4xWssH2pmTt/gVhSswHRMABOPINxueYRODlbg714B+yCSEMwo575XIO09NxdJfv5lKB/7EwURCPuU4/Sg5xQCqF3P1N4cM1a+mhmrN7r8sHfZz51SUAfd8kpI60I8PeFWs68NjkMpYwmUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MgC04sXg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5yswi6H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MgC04sXg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5yswi6H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8txVkwqMRJjWWbc/atl6vQI7/U+u3Ckdz87v1ZTBF4=;
	b=MgC04sXgf8rO8jgoBcTf5yOx5jIhDb8GlRitaZ/HquEy+iKOs64UIdMxdqvdhpOmTj9yBF
	6eHfYOSIzrSABG40Ek7+ncR/kLkToMiUkzW0r0hQe+jGiBO1+n2Jc6oi3cLJT+CznXbyJR
	cy+XSYVYVMPvbVGf89ZsBHzj4b6E5q4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-cYs9bgL3MMiN8_tfsKfv8w-1; Mon, 05 Jan 2026 03:23:38 -0500
X-MC-Unique: cYs9bgL3MMiN8_tfsKfv8w-1
X-Mimecast-MFC-AGG-ID: cYs9bgL3MMiN8_tfsKfv8w_1767601418
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4775d8428e8so117043655e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601417; x=1768206217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/8txVkwqMRJjWWbc/atl6vQI7/U+u3Ckdz87v1ZTBF4=;
        b=I5yswi6HKFYmnvSvPTgX5I5GufkEjc88XVQp3JUswvb1KOQoqFcAzdQNWr4rLb2KtD
         w6kIV8i8HddwgY5dtR/atqlL0npCMlNrnonS9ZdFWUmUsJNnipDt3dUq/RehUuzNtFKZ
         x5OW/C5dHDyI9O+FOhKrbHes3aKeeS7QkT69Z91lgPSyaHBGhFQGkpBw1W8/eSTGQ1Mg
         EDojgVrRxwjobAMfRWdQbWUyMx2jYCWo61MzPIA7KgyJT6RQuzNJiNMJln+XK11k36rs
         Qq9gn0iPDciYwO3esIO4tkuPZUbpAQyEqyFijEJ8x3C885jkQqOn0Q6CcbSXPpAJ9nhT
         X19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601417; x=1768206217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8txVkwqMRJjWWbc/atl6vQI7/U+u3Ckdz87v1ZTBF4=;
        b=RIY7P407LhVtA33c1o7UdPpUdwoP2PUSuzFa9HbpFGfnR7o5egHhE2fr/Mr57OVVGc
         rZcXzRecu0cgz9S5DNP3bhG6FBilkfHC72XA6HkhqLoGIWgv6PKxqpw3EQv/g4oeQoXT
         V25xng8iB33759pYNSBPs+sBxnXsc5lh8fGMKdj/k48+uPS6dciwmDXG+vYAiPZO4a/H
         0re+VxN61F9I+JVOYWw0VKqHZ9nioYmfy215b+iXwtKOPfmVUcBlp/Zws+CuyWGRgz+i
         reKZE6cHdBL8KpM/HUOFCmDKfRCmDdYhHtz3ayWeVqZbBKRPndoSRTdKJSeAXLQTNOml
         b1bw==
X-Forwarded-Encrypted: i=1; AJvYcCWZT0eJckJ36edJj8WnKNkT/tXzgrX442s6C3XNXcV34Oel4sEd/LDnALHzubKbbUSIP/WlcxbvLyll@vger.kernel.org
X-Gm-Message-State: AOJu0YylzWjSlssSdCjPe6RhcrJKYj7AHbn3WViHYmHGWu9t1gNSc7CY
	KlAAQMmzXOpeIn3LALQ4reYrcJT+7cfUx0gEDctQCT8Diok1jQ9D61G9ThOPw8EUT5mR+URVY8j
	lGhGcvIk6gvVr7Duk5IvCVeioH5g+mCmHTBRrQ5gzvqQ8uG2MCq4Jgz9vbQ582dM=
X-Gm-Gg: AY/fxX72+W9TkhTZBHSAlEyV3rUg09/PFIkNlRywLcr/HE2q7g2wbnJRWx3uoyByUbl
	KBuiyFuME17wKrRTOSoRda+uViI7JvE7qnFY6ICucMgQ7WxUcXgvdztcbKgdinsrf4+NywZxebd
	o6tEGnOsXgtarm/rgHkq607DzoB0rIKYkWQbc4N8hUlmR/nGNzV58QQwoaLbVY8biBxDSZay/3a
	wnb15EJ7z3U1z5ROs4LiRxfJek1h36c0KLNRURtyPJD9UBm66Z79t7klcQ2GoxfpFxo/6UxjFI+
	y5y+IzdHCfyppj6Q8f0dXBtCcbcY6sHt4eL3571GoTNLQukgtUnMyIo4pCVKhSaCim7690Hc0AL
	4CFwzBxtSBaSCX7t2m8n8/AC/wIhZvvsj1w==
X-Received: by 2002:a05:600c:858e:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-47d1c629902mr472043295e9.4.1767601417342;
        Mon, 05 Jan 2026 00:23:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVSX2iBXTT4S7tXy0ZYHsUHRdZMVGE7PsYbGyf8OKqSDfiJqG7TGaTn+6DDGk03BIi3LI2pg==
X-Received: by 2002:a05:600c:858e:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-47d1c629902mr472043065e9.4.1767601416846;
        Mon, 05 Jan 2026 00:23:36 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6be6b202sm54210025e9.6.2026.01.05.00.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:36 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:33 -0500
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
Subject: [PATCH v2 11/15] virtio-rng: fix DMA alignment for data buffer
Message-ID: <157a63b6324d1f1307ddd4faa3b62a8b90a79423.1767601130.git.mst@redhat.com>
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

The data buffer in struct virtrng_info is used for DMA_FROM_DEVICE via
virtqueue_add_inbuf() and shares cachelines with the adjacent
CPU-written fields (data_avail, data_idx).

The device writing to the DMA buffer and the CPU writing to adjacent
fields could corrupt each other's data on non-cache-coherent platforms.

Add __dma_from_device_group_begin()/end() annotations to place these
in distinct cache lines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index dd998f4fe4f2..eb80a031c7be 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -11,6 +11,7 @@
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/virtio_rng.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
@@ -28,11 +29,13 @@ struct virtrng_info {
 	unsigned int data_avail;
 	unsigned int data_idx;
 	/* minimal size returned by rng_buffer_size() */
+	__dma_from_device_group_begin();
 #if SMP_CACHE_BYTES < 32
 	u8 data[32];
 #else
 	u8 data[SMP_CACHE_BYTES];
 #endif
+	__dma_from_device_group_end();
 };
 
 static void random_recv_done(struct virtqueue *vq)
-- 
MST

