Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337262D9792
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601380; cv=none; b=Vmu6nYiDY42O1569rqfXIHFXtDqttE9Alo1q9MFyaurgS+JRl/JSdopt8DAPlXzrtDleHBIynTULKktNtP/bK1squ6N4tmVrjzAJ3P97fX3BNnJBK1YMdlLRhEW451LtlOreE2kxVwkOuOuxorqsZRZvHqPFkGSL6G+XqkeCwbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601380; c=relaxed/simple;
	bh=1rF+5o+RxfvaZWaK/37ivP7Ic43xgdCjtd7a083Lyfc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Nas3WRBmyvApbTyNTfcvqwNcjj/s/jNgDQg2Er2IfS4IADgT09IhIBpECK7L2/GUX6mycGZljF77iNwpZ+UMorNnAKE5cA81PQJJEH9ianWB0BoglWHkb8A9dW2BgoVwfqdwh0yCroEdG9Qhis3o3ei87X9SWouXR8GlHwpNdEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OVpQPRID; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aFnAwaAK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OVpQPRID";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aFnAwaAK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=++MSvPbbaixtOH+VkhbpdT2tKuVIlO7zEYO24bBcB2o=;
	b=OVpQPRIDj5fXqBg9A/hP4xVzLw8MYfD0RyVh4Bk3mpjidMcWQVlxb6UWCkDP88f6dbWF3F
	SvhRQ9LrJEXf8a4sePL5O5s/gicfHgSC7GHHwSCZoSo54sbVX2pEdbD1EQjHEf1CDNwLaQ
	fzhYe/ROFifr2sDRbPyDY0j+oMXFN/U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-lGpP8NwQMWabq9pjKMDmUw-1; Mon, 05 Jan 2026 03:22:55 -0500
X-MC-Unique: lGpP8NwQMWabq9pjKMDmUw-1
X-Mimecast-MFC-AGG-ID: lGpP8NwQMWabq9pjKMDmUw_1767601375
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4776079ada3so122516985e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601374; x=1768206174; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=++MSvPbbaixtOH+VkhbpdT2tKuVIlO7zEYO24bBcB2o=;
        b=aFnAwaAKLu7zAhMf+1ZJkNmIT145xhfGYevQ+uwx4Dua/sOWHk6GFH5sAFW7CCCMFZ
         0cya9z65tmnNTyvX8ggutiwfatl5uHID38vuE/UmtJgcJ4jlVipRomZHHhHg4cIFInDR
         6fxzl+4UMlWcfjaV+B80TtPV4bNU/SlsWfmvdpHWeonjuIye9gFLQHa5ezv0cGiFYn1M
         uPIv55VhcCeX+mAns+hZrOKdH37ATwCzhEooCCd6oH/t8AoUlfs90mZBEvbeNgJbXLLq
         GSSl7PCZXbESwGZq0n141aAGd5Eg/NVjFtyyDdOp5ijpOTk8+jF8eE6VPD6Wf6vrFLzF
         aNPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601374; x=1768206174;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=++MSvPbbaixtOH+VkhbpdT2tKuVIlO7zEYO24bBcB2o=;
        b=fFUOjscFQ8pwKHSCfwv8zv9kJ3JlOTHD5ulO0CfYuuYuilsvN3NC93tyxKdbirykGN
         Ml7A39YxMXVORBi5wOaYu6+2/d6IvELEvMYpjpIbabdW/LY1zyEF0DI+PnN3gZ5JUfA0
         DYJVoGaJDCHZeFAaePJ2r5ukCcI+GAsEJInDdXFzXFHrJWDLq/nJhTosiynYw1Y6vgyE
         s8RZrJiJLRyMx1nEQDdhhuI7BxUI5OrNfXEawe/azZPYRKRMzjSo5gbL8U+nY8StYuRy
         BFOwOCXJNZ6unbOJkQR/sXiym2Y7gI9BcI1fEoySKiU6ipRThf8DE0VLbKWuL6N7nYeY
         4dLw==
X-Forwarded-Encrypted: i=1; AJvYcCWUPcPOBU9p9/X8bVCnETqFIEwUUn3LNxvYWu8O8wqYkKCn5yzAuv85uop30nfGtukOZp+S0RNLspWX@vger.kernel.org
X-Gm-Message-State: AOJu0YzM4LbBUluqTTWOcQ4nsGaJft85hPN+Y7rJCrx4uL446VmJLLm6
	aFFsyRS7h8F0LxmGAXbIMx8LVJlFJrwnIaNffcz2+MmxZtCuKy8UeM2L1YLiVkZ6YEskBSKLS3k
	JD2LtMvESMQ2nd/8JqttKAA+V6OXv9n+M4rKpE/gPJ1uM1ntMSmJoDYCE5kZOUTA=
X-Gm-Gg: AY/fxX5nalOdURc7SeN0IZcLSe1tUFuEDR0VD0LU2VS7ePDFWWXI9UUOlu1kdk/f9On
	NrkcXRfSdV/P8Z5wV7LubXw8FMb6Erqu04suXj4ttVXnSs0tumY76EuPgPiUJZUmT1vPDyzZtrS
	TrKm3peLmux1SjHOsyjIYgGs8EbyocQP2js4D4iPhnLG0Me+kj6iIL8DiIoxsI6FfIMRyhCjC1L
	QZqa/Rq1K8bRtsLmiuKuCwFqd8wW3u29DVlhIrdd5lA5jvoXYvgEycsn6C1OZSgG/f0Ai4twcwe
	uPA1OWKAxDBHNvjHoFu14+l5CDf1vRqsozScpm1AZjMx06y/z/jYvhZDvpXabJMVzEPaJYZrMqH
	dkV9V82u2yGOW2M126PMtLI7Y4ehIHHEt8Q==
X-Received: by 2002:a05:600c:4ed2:b0:475:e067:f23d with SMTP id 5b1f17b1804b1-47d1959eaaemr640737485e9.25.1767601374453;
        Mon, 05 Jan 2026 00:22:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXw2Pw2EoWGIJB0fy/EdgimCoNIlh1q5tf6OTMnGxG74FiSYxf17YyIIU15mHj+ck3a5eDtg==
X-Received: by 2002:a05:600c:4ed2:b0:475:e067:f23d with SMTP id 5b1f17b1804b1-47d1959eaaemr640737005e9.25.1767601373905;
        Mon, 05 Jan 2026 00:22:53 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6ba30531sm56554215e9.1.2026.01.05.00.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:22:53 -0800 (PST)
Date: Mon, 5 Jan 2026 03:22:50 -0500
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
Subject: [PATCH v2 00/15] fix DMA aligment issues around virtio
Message-ID: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent


Cong Wang reported dma debug warnings with virtio-vsock
and proposed a patch, see:

https://lore.kernel.org/all/20251228015451.1253271-1-xiyou.wangcong@gmail.com/

however, the issue is more widespread.
This is an attempt to fix it systematically.
Note: i2c and gio might also be affected, I am still looking
into it. Help from maintainers welcome.

Lightly tested.  Cursor/claude used liberally, mostly for
refactoring/API updates/English.

DMA maintainers, could you please confirm the DMA core changes
are ok with you?

Thanks!


Michael S. Tsirkin (15):
  dma-mapping: add __dma_from_device_group_begin()/end()
  docs: dma-api: document __dma_from_device_group_begin()/end()
  dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
  docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
  dma-debug: track cache clean flag in entries
  virtio: add virtqueue_add_inbuf_cache_clean API
  vsock/virtio: fix DMA alignment for event_list
  vsock/virtio: use virtqueue_add_inbuf_cache_clean for events
  virtio_input: fix DMA alignment for evts
  virtio_scsi: fix DMA cacheline issues for events
  virtio-rng: fix DMA alignment for data buffer
  virtio_input: use virtqueue_add_inbuf_cache_clean for events
  vsock/virtio: reorder fields to reduce padding
  gpio: virtio: fix DMA alignment
  gpio: virtio: reorder fields to reduce struct padding

 Documentation/core-api/dma-api-howto.rst  | 52 ++++++++++++++
 Documentation/core-api/dma-attributes.rst |  9 +++
 drivers/char/hw_random/virtio-rng.c       |  3 +
 drivers/gpio/gpio-virtio.c                | 15 ++--
 drivers/scsi/virtio_scsi.c                | 17 +++--
 drivers/virtio/virtio_input.c             |  5 +-
 drivers/virtio/virtio_ring.c              | 83 ++++++++++++++++-------
 include/linux/dma-mapping.h               | 20 ++++++
 include/linux/virtio.h                    |  5 ++
 kernel/dma/debug.c                        | 28 ++++++--
 net/vmw_vsock/virtio_transport.c          |  8 ++-
 11 files changed, 205 insertions(+), 40 deletions(-)

-- 
MST

