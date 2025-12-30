Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CFA2EACF9
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 10:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089784; cv=none; b=nDtWQ09W4RxrnqQXE6U5ar293G+Ng4d3rVCRBZHf91G9xvVuEWZUJJFX98586WyavEsHTEaK27JN+DHXSk7pOtU5ihLQmWry/SvHvVRr44cJHhwVRdCBxLePHpHNjw/uF6UCWF1V6a0iFJsGFmqYKKEkRtZv6MFuq90SaWL/A1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089784; c=relaxed/simple;
	bh=RzxSFhz+bpkLtGdr/5qvrDQOf7DHug0oDxHEj4NfN04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQAW/G0DHo7l0dopvoP4P+BJ9CexxB7amhkB/Ny/H3PPYlYJGOxrYYVf+aiNeOypIwlieLhI1sUUNcJEyLtsR+ZoT6qtOimE+LYDfuQR0uvC6PjUOyn84NXZN7w4No3yiW9aYZbfl6pSefVitgm12DOAJw6DO064wODnaoHl0Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GG1e92xf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7MYoLT1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GG1e92xf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7MYoLT1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
	b=GG1e92xfXwhdCfXUvWy8J123z+Vg7kCtHuNr/m3hKaNvn9RGC4OKv0ohda0Zxj4wQREy1p
	xe3xJ6sid7rHsX0+C6Pm/J5LoNli5rVoinLSSXriVcYFI7GrbodDENgbELVi+Zy+NJcMRI
	0sNj8PIu0WwXd5jsawV79NcWpsa05Kg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-MzHMRTsDObuoSDtsspvCRw-1; Tue, 30 Dec 2025 05:16:19 -0500
X-MC-Unique: MzHMRTsDObuoSDtsspvCRw-1
X-Mimecast-MFC-AGG-ID: MzHMRTsDObuoSDtsspvCRw_1767089779
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso49771945e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089778; x=1767694578; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
        b=H7MYoLT1sC1fMePwilZgor41MO9FHeM/T674J1He9y7yu/Oth+y+DDgJTogkMUfR6L
         B9EllHYcBINQWnKOqFrEHfEzyGsdZ6fiGqoqBRmqpOpdHx6N63Vptzo/xm01Xsdd99cF
         nWbY64Uhv9rFM1H+3huYPRG38ibmuVbHMTnPkRpz+xRek3kiyBDygowHHN+AA/YPDEkJ
         voCQp45TPJoRhbBMv7DnJ4mSxbIfZSZSDgPa8ibGQO5rjyyWml895af9RF7ERBg/7sj3
         7Q2aHYpd5j6qCTqPMVWry/C7GZvj1s622DsNALSu/1fQOIDv+geQ6j2vccjZxm2dPn1d
         MIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089778; x=1767694578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
        b=Mo5YrdrD6APlh49Zgj+qaKATko5WWwL0tKaDtAYxJgJkfZa9Z6sboz4dvcp+cSW0uW
         KNgzhd++JxoboI7iGs4YDba7HSKF7VxDZpdF0SkIAXNDN9EgkCuaCU4LLyqSNevtFOpZ
         AIly7tc56rb9CmGqB7yiDa6vozjfnyh0lDdk1nKqYtp/hwrh+oa14nUwqF0YNQ6lvDDS
         UvqqXSDG+msB/gN07FTKXnak0g34sK++YvW7o+UC1sAJ+uSHg3qeNka5VcTEtwh9Ae81
         wqDcLXTX4fLMMVblaxAxYPKof2JQ2Aed5fk38ij5ltxurxdL70D+LiObfq2dsvBmMhnj
         JDAg==
X-Forwarded-Encrypted: i=1; AJvYcCXln50souiyZ/CV7KHaCInt+ph+NeC2u5HLQSG6hw9ObOgzFzMbHNrs3ZkFj3GfzlhJgXO8YIPtM+9s@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8hF5H9ZWZkKELnIyC4K/XA/zwK4kVK1NfjpibImvzPYDLYC/0
	rhwhnCVETQDcyl6AsgPl8CrR1wc3R8JTBWtXSG/7LwuWYkcFACfujabQu/6NDhPmZctJ/RZ7TEN
	/wmAvdzbGPQe1NMEK5wlGmLRKrg40gOISIjSqjmPt+EouQ5dTSgA19UnFYUhb6uA=
X-Gm-Gg: AY/fxX6cJL4cHI6NAbhM/6aQeCWJ9SCfVbQ3pbr1mycYvouE4zmP09t5NtOKl9oFhee
	haGp4gj5Izo3ryplWknsonii8NZGm/t8Ek8oHWFNknTzLDq7JS6NBKyysHuenRFGAWQ9rR/4lXc
	tnkxOoyPfBe4LFKZBL1OELsGOm7wjmCyzU2g8MeDHD/MsVUWJZyQgjfXue/FGDSo1AaIKW+eLPS
	/IfX9ROWZc6kilfIa2tnJaNKEtMUuNdKu/Be1vPPN6gt6Q1PsMZHv3ur9EwhqP9OhqHQA4xm5CJ
	belDsUDZyi4onfVcCVpz6166icn1jjy6ky/eRXZNDfOUMN6MC90NG2HBj2fNSAzl1IMKTTQtOI4
	2f7Fk70e4zvnv+nDeEOhVMnnoJ9l3bha1aw==
X-Received: by 2002:a05:600c:c04b:10b0:47d:333d:99c with SMTP id 5b1f17b1804b1-47d333d09b9mr218755295e9.18.1767089778574;
        Tue, 30 Dec 2025 02:16:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFT+g6nqLgyQkQdYiav+FpD+RF51wbupLPftlD1j+tQDbY3ul4LGHX6uIhkOPdx1xlKUXo8aA==
X-Received: by 2002:a05:600c:c04b:10b0:47d:333d:99c with SMTP id 5b1f17b1804b1-47d333d09b9mr218754935e9.18.1767089778175;
        Tue, 30 Dec 2025 02:16:18 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3aea77bsm247750305e9.17.2025.12.30.02.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:17 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:14 -0500
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
Subject: [PATCH RFC 09/13] virtio_input: fix DMA alignment for evts
Message-ID: <5f57d7dc13920517b3ed3e56d815ad1ba4cf36ce.1767089672.git.mst@redhat.com>
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

The evts array is used for DMA_FROM_DEVICE operations via
virtqueue_add_inbuf(). The adjacent lock and ready fields are written
by the CPU during normal operation. If these share cachelines with evts,
CPU writes can corrupt DMA data.

Add __dma_from_device_aligned_begin/end annotations to ensure evts is
isolated in its own cachelines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index d0728285b6ce..774494754a99 100644
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
+	__dma_from_device_aligned_begin
 	struct virtio_input_event  evts[64];
+	__dma_from_device_aligned_end
 	spinlock_t                 lock;
 	bool                       ready;
 };
-- 
MST

