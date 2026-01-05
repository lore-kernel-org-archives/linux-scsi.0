Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF1232A3DE
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601436; cv=none; b=ba1n6vIhSCrZ+2VczLapPy+JPf0chHT2c9+9oT+t7Zg2q84fjcw58XI2eq+XPphC2pALf+B+5iPnGyLTtmpAiaMBkIhSxr4wbnPlPd8IMgY2znEIPGO5T5B6VK81q7XKukeVCK4nsaUW0BdZ6x19ZW3zvIe98GI72e+JBVAyNh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601436; c=relaxed/simple;
	bh=5+AqmnW4PA/6edyK6U8dTvigNJLqhC7cXNvV8IIXjTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6bl7Myl+D3j6C0v97Dmz7Bh346uff43v8fwizYGuFNJoIsHyI69fD1eQ58SPXvqcg9UIEa1yUGuTwlgjaUd2HGhxZIagit5Rd/EbAi0oQsMni5I2/J/zSnX44XmGsnVaT/GFzme7iChhQK9u8xKjvSV5ZJABZFyYTJFBWNGjOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJQonVME; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uMRMouiJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJQonVME";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uMRMouiJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F5gbCeCGdOPWPA7+HFhpRVcPZoxhZ6OosT4+6pGbwi0=;
	b=JJQonVMEcOItokzsUwiqnP3io1Vx/zxDy2HJhR7fArK7F+T3OQNYmTlxXz4tM7G93/kDfq
	n+05vl+jskjAaa+CurAeXka56F8nUW++06U8r1BCBQ0yiI2k1lsNwiEdpuwvYnqwA2HmdF
	VioRLxFYzzBETrM61V0Wrw1DRHt4XA4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-0csDs8HWMXyaMCmvA7LRyQ-1; Mon, 05 Jan 2026 03:23:51 -0500
X-MC-Unique: 0csDs8HWMXyaMCmvA7LRyQ-1
X-Mimecast-MFC-AGG-ID: 0csDs8HWMXyaMCmvA7LRyQ_1767601430
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so88358265e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601430; x=1768206230; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F5gbCeCGdOPWPA7+HFhpRVcPZoxhZ6OosT4+6pGbwi0=;
        b=uMRMouiJplEJw0f5B11uiIHSrH3LOhXawBmO9iJbtMCtXnX76GJLVIoCkShGK39nz3
         yp/NJ7wiFbxpJw2CqA2z5GllV5j3v4RQodT9PE3uofpmD/LQL4+/+ePrrpw1yinD3uu8
         XIxgLJ0DWDIUKFBxq5afHUXbvrWFgjVsEY80bWFw3F61Un3Tpu0pJG5jVHbyKeznPoC1
         kivOJYvUuXJZkuX8nyKEn4HczMNlKVdhiVmQXmTptPA1XNeK/R3VbMXt8ZnWptwL4v2a
         tfGAc6lMpotFue6H+9pQit71eSYmLEbJa+KluiO5wx5Ofeip7XGSq9shXAFsF7BCYI6S
         7Wsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601430; x=1768206230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F5gbCeCGdOPWPA7+HFhpRVcPZoxhZ6OosT4+6pGbwi0=;
        b=lWlGODQskfg2auknKx7sf3WvrNMySvO8kd1ZpwsOb3yPQp88po+HIJcopRGhJcrIFL
         /jMqSxYepOl79MH8gpvYArRHnByzdFGyzhhYilgeos18t8RlQMkVVBKb1Al06Xso9Cv4
         1pOUWZe4U8LR/e8MWST8AdL7PDfgSDEmTgRW2tW+/uDgen7Ip5AElrvhELnaMua7ui+x
         VT/cy3IilkWQbEuAjTlD0kdoSHx16KmqSLDokZ8a3pEW6I4Du1iCmn5JQt0/w3DbARV2
         5YrVY71LDnE5znC3Pnl3s0J+RuOAh36zH6VlaHQc6mthF+ye7mC3mDaHEtO+BH94SjKg
         7zwA==
X-Forwarded-Encrypted: i=1; AJvYcCV8KFpDsB5VY2xVcSdmp6V/LbxL1Rz791DHPnE0IBlzvLCxPqwRK/sRrDiz2H/aT+qV98ftccCsFGNH@vger.kernel.org
X-Gm-Message-State: AOJu0YwRUIrxKQQ7awwtPWbIy30hESp0TWD0gByvAGzVx2spRK9c4mtT
	QXWKccufUhv1DxSfpD1JjpgFFsHKRu3rVhjsErfiC3F5g46ZNwmBAUd+kssk0Vq5SuMs307OPe+
	C/GMV8XDtJtllMCNO/LNRXkHEhAvZ/JoEioU2mSaNTaiWiKlydGtkcelxG5Ig/LM=
X-Gm-Gg: AY/fxX7kLpMaDuw6c4CVYo3VvbemwMijpS8fqMsWzXMZ3bTQdf/bmDJCmyxiEaNYTVY
	+B2nzKF9mMx1hfowfgtbZvECNwYLp5Pgc/F0H4Mf7WeP40gEdGmjAoywTpj1q2zJ88yAmAnD+eK
	AxA5WYX8pdFxdwp7f0jzaCIqdZ0jjZXTInSQb1Nu7fgXu5/TcF1c6HZBTIKB117q95z0+B5L94+
	VBY9Dx6H4+LU6IuhRClRD6lV6QDtj+yi/0T9SPu8XrIDFoccBT/b6b928zfbB0Qb09kzfVXONlw
	//6jsvG5gA/fRZkL22efZ7ufCY/7NbsBx9UShJI6I8sGm/nGdT2PidJ5/2Avcq2joy5WSItwVOy
	7qbSl1237jORH6b4aDx6KByHn0y9e9Svs3g==
X-Received: by 2002:a05:600c:45d3:b0:47d:4044:4ada with SMTP id 5b1f17b1804b1-47d40444b44mr461187925e9.13.1767601429685;
        Mon, 05 Jan 2026 00:23:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMwRI3MA2DTNX2WICs7qzlXbxMYmhW2AMGnc8lzpwkl8AC0h1+xs4bbHr0vh3wAjjaNt43Dw==
X-Received: by 2002:a05:600c:45d3:b0:47d:4044:4ada with SMTP id 5b1f17b1804b1-47d40444b44mr461187535e9.13.1767601429208;
        Mon, 05 Jan 2026 00:23:49 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6ce21fcdsm154121375e9.0.2026.01.05.00.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:48 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:45 -0500
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
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linusw@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH v2 14/15] gpio: virtio: fix DMA alignment
Message-ID: <ba7e025a6c84aed012421468d83639e5dae982b0.1767601130.git.mst@redhat.com>
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

The res and ires buffers in struct virtio_gpio_line and struct
vgpio_irq_line respectively are used for DMA_FROM_DEVICE via
virtqueue_add_sgs().  However, within these structs, even though these
elements are tagged as ____cacheline_aligned, adjacent struct elements
can share DMA cachelines on platforms where ARCH_DMA_MINALIGN >
L1_CACHE_BYTES (e.g., arm64 with 128-byte DMA alignment but 64-byte
cache lines).

The existing ____cacheline_aligned annotation aligns to L1_CACHE_BYTES
which is not always sufficient for DMA alignment. For example, with
L1_CACHE_BYTES = 32 and ARCH_DMA_MINALIGN = 128
  - irq_lines[0].ires at offset 128
  - irq_lines[1].type at offset 192
both in same 128-byte DMA cacheline [128-256)

When the device writes to irq_lines[0].ires and the CPU concurrently
modifies one of irq_lines[1].type/disabled/masked/queued flags,
corruption can occur on non-cache-coherent platforms.

Fix by using __dma_from_device_group_begin()/end() annotations on the
DMA buffers. Drop ____cacheline_aligned - it's not required to isolate
request and response, and keeping them would increase the memory cost.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/gpio/gpio-virtio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
index 17e040991e46..b70294626770 100644
--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/completion.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/gpio/driver.h>
 #include <linux/io.h>
@@ -24,8 +25,11 @@
 struct virtio_gpio_line {
 	struct mutex lock; /* Protects line operation */
 	struct completion completion;
-	struct virtio_gpio_request req ____cacheline_aligned;
-	struct virtio_gpio_response res ____cacheline_aligned;
+
+	__dma_from_device_group_begin();
+	struct virtio_gpio_request req;
+	struct virtio_gpio_response res;
+	__dma_from_device_group_end();
 	unsigned int rxlen;
 };
 
@@ -37,8 +41,10 @@ struct vgpio_irq_line {
 	bool update_pending;
 	bool queue_pending;
 
-	struct virtio_gpio_irq_request ireq ____cacheline_aligned;
-	struct virtio_gpio_irq_response ires ____cacheline_aligned;
+	__dma_from_device_group_begin();
+	struct virtio_gpio_irq_request ireq;
+	struct virtio_gpio_irq_response ires;
+	__dma_from_device_group_end();
 };
 
 struct virtio_gpio {
-- 
MST

