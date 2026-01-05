Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2CC328B72
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601414; cv=none; b=UHMOepmlX9QLYzj73YBInabvq0NSRz5gPLvnMR+ZC2GYS8gNnyrzVkYwKgZeWx+G4OxNBdvm8BZstLMgy+GWhD59/3tGyw5F5wZS8GuzszGHKZOM+ZfyL4GtBuAh3fGijdFzM8XnvlgyRSUEn6JWsxR0TzIJRueXouLmugNx9Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601414; c=relaxed/simple;
	bh=yZFREYe+kB50ig8I4QfoDGYH7fn5mVvqsTw8oxG1/Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hy5uzCcOC38jUT2i1ctQMHcUfOZgTVmW+NmVlTWKcBkwgKGGbW7d+BUYdKlN10IKTTY2+rXlUp8U6Xw7k9DDX+FxQKsX7IykFWnvBpwrOmLl3Pq2dGXb3r5zCA1SNYv5d0nuuSqRmiMrLLLSvyPCSIjCpNTmHCwtwiJ5EtC9hkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGXcGOjm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RWZ1fXc2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGXcGOjm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RWZ1fXc2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WFAlf3bglsAJtkYzmv+ft5xqaztKYGlID1/+YOBMr0o=;
	b=ZGXcGOjmLeGWkx/FvHO8OG4Ix2VK+O/U+h6lTSg+bUIDJIqrYivt3bKmKOd78wkGT14jKq
	cJ+MU6jtIuvVOCQJ60me7U3zrveQ8w38odAw7T8//11WcJLnkd+M8QMUN1u2LMug7PmCAL
	2SHcXDsZ+3ve3JPQJLxFe+CgDnoUww4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-lbVFtx3jNcqTSEv_tOuPVg-1; Mon, 05 Jan 2026 03:23:30 -0500
X-MC-Unique: lbVFtx3jNcqTSEv_tOuPVg-1
X-Mimecast-MFC-AGG-ID: lbVFtx3jNcqTSEv_tOuPVg_1767601410
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47a97b785bdso95838565e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601409; x=1768206209; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WFAlf3bglsAJtkYzmv+ft5xqaztKYGlID1/+YOBMr0o=;
        b=RWZ1fXc20ZkPKj+99fWUwuXo/equGaNjQgbzREfCka0FOX2uIqLLuxl+O9HxLpwj2C
         iZG/W34/ARlm0hd3v9K7r6YnDdrsAN8qcmZQF+V951BjWru74fplmVNXqLEAqwpri6/5
         eIEsQP+XV9aMeQokdFniLjl4ugZGFQzJNHtIeVLtOroKt8HACZ3giLnI6AA3V26BdTwc
         0wEuTJ2ZwZvEblT1B0TAQUiq3V+oe+8PlUYmu92jVdhmn2z7nmZZPQ5C0IDA8vXGYP0y
         RPoKUQFVv/MZFhxuivyuaTJWNJ/Y1C2ie6leuq+9E9ZLMOlzC0G+RyGG2WDSJW41Zryt
         ki8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601409; x=1768206209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFAlf3bglsAJtkYzmv+ft5xqaztKYGlID1/+YOBMr0o=;
        b=lOXTkJ9qYr2pCwuz6KngqGrL0uvPii2R7K9yCtBWcqTi7PECbtws/49s7dPWvQ4MB4
         8kkip0jYk+8pSmtOCqN01YobfbmlylfQ+iHJD854ura2RQL+On7Ons+1jvWdIbmH8Vgz
         MBpwmCXtScPETlrWe6uwbn+tSuFZW/wVV7pJxCcLDzfj7Wwt2+56YEtCedDdwQqgmNpc
         QVzNm+sNcKQGrTOXPyr7aivLOcXQqkGDHb1qcnGBZ/Gb9qRdiMTg6Sad/LGNWGEZEp0L
         XPHTzYbV7+vU9EG98pk13IvjYkB2KDgEoyjXcHT9plXxllGla89CTi+4xiQSJ2CYHbzl
         a9nw==
X-Forwarded-Encrypted: i=1; AJvYcCWZcVTC0AJBdBJ+m+3dFk+IQ6l8sC7eZQyB/s3msN1CJRjmHRFnkfYFNSk6sUjYaiJtnQr8usvx3eXe@vger.kernel.org
X-Gm-Message-State: AOJu0Yz32BocN42KQsbjjgPZt1vmXMG10XLWeV/5BSK43+MekcnsX6C/
	4PPLW6WMbhA9kz5LzZH7IqEX7hK+dCk+Fkvlkh//dFuEVQtNQhqzmCv/ATpVQ+acaEwQB1qX9th
	WHn2uAoO2vnFJXIFJLUgaEegwRxPrXaxXKS92FrHCGn1regTzMgyryKJC81bv8GI=
X-Gm-Gg: AY/fxX4fjVDIsobPeHnoTlzLgHIGwg8xHRRCBwlnyIG6ZNWPoeGynALKgskprcGIh2Z
	MWucLngsa1PKhHcfpfxvHsa8gZmeOV5Z1s6SqXKp8Et0mFqhI3Jmw9UsYPgaHA5cANfjrYMtGFl
	tqpjGzoNJlDyjf2dPUKIH04tAZMyydKrm0R1cKsEiROSYi/QHGSW+eRRnPazxfi4LZ6mcOa/n62
	eVft+3SqmsrOb8skcYb2kAPguOVz7rlAZmc3Ma4j/GA6f/xyMeA23OxKyP5S2pFfB3pnQ+B88B1
	fp5+G+6q9JZB6rt3DxqHEGo/i66D2ZxDd1wxKwn7IO7aDbPfqy03BnphlN4e64uHrKu2uBLZbex
	kW6i1iQv7vj44GE8nD9Vark0rCEg11LjzSQ==
X-Received: by 2002:a05:600c:4fd4:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-47d1958a43fmr573308335e9.19.1767601409522;
        Mon, 05 Jan 2026 00:23:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwNUq77RyeyS0obHX/fGtVMqKrfm8Lk7lx8bL3zrRbRdvbJ0vPOnUhK5sFwtMU1HFVUtXhCA==
X-Received: by 2002:a05:600c:4fd4:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-47d1958a43fmr573308005e9.19.1767601409047;
        Mon, 05 Jan 2026 00:23:29 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d145162sm142697615e9.4.2026.01.05.00.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:28 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:25 -0500
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
Subject: [PATCH v2 09/15] virtio_input: fix DMA alignment for evts
Message-ID: <cd328233198a76618809bb5cd9a6ddcaa603a8a1.1767601130.git.mst@redhat.com>
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

On non-cache-coherent platforms, when a structure contains a buffer
used for DMA alongside fields that the CPU writes to, cacheline sharing
can cause data corruption.

The evts array is used for DMA_FROM_DEVICE operations via
virtqueue_add_inbuf(). The adjacent lock and ready fields are written
by the CPU during normal operation. If these share cachelines with evts,
CPU writes can corrupt DMA data.

Add __dma_from_device_group_begin()/end() annotations to ensure evts is
isolated in its own cachelines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index d0728285b6ce..9f13de1f1d77 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -4,6 +4,7 @@
 #include <linux/virtio_config.h>
 #include <linux/input.h>
 #include <linux/slab.h>
+#include <linux/dma-mapping.h>
 
 #include <uapi/linux/virtio_ids.h>
 #include <uapi/linux/virtio_input.h>
@@ -16,7 +17,9 @@ struct virtio_input {
 	char                       serial[64];
 	char                       phys[64];
 	struct virtqueue           *evt, *sts;
+	__dma_from_device_group_begin();
 	struct virtio_input_event  evts[64];
+	__dma_from_device_group_end();
 	spinlock_t                 lock;
 	bool                       ready;
 };
-- 
MST

