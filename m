Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479F42FD7D3
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 10:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089804; cv=none; b=PiZu4V1eK8DxTeQR2qAYHTc6i96R7AA0NdmxRtBIjl+1fQNULvLJONjnyo6UzfLJQwS6kariMFU9bK4IegtNcb22SUYR5aeUp6fZsGqFM9XuZRE/RGC0Yqyxwje7GUwN1Xx0nzkxqvAuP9T044Gd00TV1CZA0OHI1JCOBsaq9X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089804; c=relaxed/simple;
	bh=RzxSFhz+bpkLtGdr/5qvrDQOf7DHug0oDxHEj4NfN04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9G4PUM1ua5W2oA72IrqHBSyzMcioXlX57GWqBkuZjojhRTUGN0zhkrSO1aZ/AxZjYAcWDeha2bHS8buSddvPUwrWn/PYnYL4z8wywmqAjxcVpoh3IoztgRCevEsmsu03jCfUg8i45gmzk0U5ajPePdO6ZhddVPrqYadPbG1ugU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gp+/QrIb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A/hkwEx4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gp+/QrIb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A/hkwEx4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
	b=gp+/QrIbF1nc+WyvdgEXty3YI5FINourt6mIKYBAsBIlirZqD3Wv6GDJqWKr+sOkvIVh5s
	dxF4qPLzJl4rAKwYN2oF5C8IJzaUmBXxK7ZXJ8WfrH56+Q52ofgILo/Kz+PUAPW0lNSNS6
	ZdoLeuRp1ebeR+fGPTrAvbpiSTvmlhk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-1dDtp_NLMk-PgnYUPFRoFw-1; Tue, 30 Dec 2025 05:16:39 -0500
X-MC-Unique: 1dDtp_NLMk-PgnYUPFRoFw-1
X-Mimecast-MFC-AGG-ID: 1dDtp_NLMk-PgnYUPFRoFw_1767089798
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477c49f273fso125585535e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089798; x=1767694598; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
        b=A/hkwEx4WZZqbWGO/MKIo5PbfxAPOdcLiTbBHSaSP0SHg8S8cwWpKHuScFjvBz5LtZ
         dgnv05gLf1QD3b8feoewuk+ryDTDw8j6yHJeDklMZHC8r6zeYdjm81Ir1h7upjeGquqv
         QUrQerqcKtaD7jdpCwenPlnJLZ4Ca0/zGIsfxbs2cqoul+hR+lmjc8jXK/XKVsd5MdH1
         WX2jOAqrnFOZ2EK/DkhSM9CCYzK8dDDTjUha8Re4VFbih2TgwK4j5ZPARaR8idthYOiq
         YnmhyvNLtrrSxftR6dY5fGO3J/oV9LVG1+NYTKI+FwQtiZn88YIoywesqIICOHIBV1xb
         ZGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089798; x=1767694598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
        b=wvrZqzwi+UTQybk6LTlYh77bbY0WJiY7BJFWGa6Wh10JAHhXQFLZNrUYzjWNPtM+8r
         AUIvhNrh4KrRvDx//CI3ZmlQRstxzO7rVXf99KJHpBneD0C7LVgyv4W7ZNFTiuju1/ZH
         dLSiAOTBB19Mhd2w2dpj8AwNH7+djxGeiSwtTUIn16ecvU5zMNBNdn6a94521kjMAIc9
         ll7n36xLCTVco46rFHQchcWsVxSHP6S0/WskcejUA697hq+xWqSw23Q0IDaaZPHPPF+P
         qc1WHLPQ9zf2kvn0NO1J9+dz8HwcXTKTXXWiZhQsZNxXAdAZWmZD7oCgmSFWsExGdqrb
         KJlg==
X-Forwarded-Encrypted: i=1; AJvYcCWHGShfTZt7JmzvVmUTejCO7pdyVOw0yVW2nHFwLXYoKREn+v302piGkErUxzwG/Hxv73cmi7rQMWGN@vger.kernel.org
X-Gm-Message-State: AOJu0YyAPBS7GOzt42wkZhqq5glQyuPLNbv2PkaO3fwpfyIi3zN5Kegv
	pXdqvQecGnr2i4ZzOmgsuai2s/7uKgmY71tXj0Q35YE/wm6eJfDLv7gY+VTxknMbBRkjff6jBjP
	pgap2/FFwGkOn/C17+7KNcG6oUX8JzMFXcds9DLck84lb2MXbp/8qENZ/khXt3Cg=
X-Gm-Gg: AY/fxX7YKffulpuql1XzY9JOxEy5yJVYAcIy1NFqhoLFI2oUsmmSuHwlKr8HZ1dK4H7
	FCI/znfnmgkJdfVv5+yBX6SdBmkT1rJu4sFZbDgFrIUjnUCjXlkle0DGj3lSG49i/6Ca/UwfS0E
	ksaxeCk/QbuSbCXyySmujt+lxm0ffa1e6ZqTopf5VWDEGlEiIX5j9MyWU3vNtofLbxmveVyIYtq
	SwGrLzJD+dClhcwcLgn2ScP8XD+zSIjFHi5NoYbjZQCrW0FwJmM3j6N34de1mcflYD5gQpvpyl7
	6eWDKn9C629l5xBSJ+oi1dCn7ZeXX2ZhyPmcTtr8ZhMAX4PthLtKIw3tJ2fhBh7QtgLc3fNFjIC
	HxWMfYoQ6Z7Vwz18MzOJYphR1Mm50xcTY0w==
X-Received: by 2002:a05:600c:620d:b0:47b:da85:b9ef with SMTP id 5b1f17b1804b1-47d19569c23mr469752755e9.16.1767089797982;
        Tue, 30 Dec 2025 02:16:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHj3WKIKEzUGPKu3zdwQlyOBMeOTgJhitK/YOLHPeOIUg2zxiErnT0jngxXmWGMEmg7Rb+0jg==
X-Received: by 2002:a05:600c:620d:b0:47b:da85:b9ef with SMTP id 5b1f17b1804b1-47d19569c23mr469752175e9.16.1767089797499;
        Tue, 30 Dec 2025 02:16:37 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be279c5f8sm610551235e9.9.2025.12.30.02.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:37 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:33 -0500
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
Subject: [PATCH RFC 09/13] virtio_input: fix DMA cacheline alignment for evts
Message-ID: <ba80d103c159a9dc36b89705e00f91bcff8857c3.1767089257.git.mst@redhat.com>
References: <cover.1767089257.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089257.git.mst@redhat.com>
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

