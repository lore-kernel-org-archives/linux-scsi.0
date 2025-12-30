Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A229227563
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 10:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089752; cv=none; b=FbTsEtg9toYsxltqR1h3NSQrSPaewIDww/mvwMajXlIbmkKn+lRGekHCB3GGCdZqLf9K3msz9oDrvR7bZxbr0pp0e79v+WdHOV80OLW2GEDEYT3VeJzFafrvMFbSfFp94t6baFIk+nrgKYojunLm2WUJpSoNKEoaKmwa4zYAZ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089752; c=relaxed/simple;
	bh=LCt+6pV3SVXX+jVlhPofZ+B+PV2iA9I/7Ha5xrB3hCU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=St36WZMtz/9pEpuo79Y2iDmEGsM7VnOB6T//K9X5fbLNq4xnCPdqXEbefTbMHin/jg2ssrNKcvdWHVvJZpC1wt+ITr19ip1t0PYFmBbUDaMqw1KzUbMvmICGZHalFeKvUWzyJ4Aqft78Sbd+fi+P/xo4Ws5Kg5J83PY1OCjg4V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P0yYMVW3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bQ/HbEYj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P0yYMVW3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQ/HbEYj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=QPeHJm+twCiufdOXqLeCn+SgUmZXimx3Kj8OMbSgWcg=;
	b=P0yYMVW35jxYgBF3YWX+d5Ks1WvgEpHVbY7hSsHdHk78Zw0WyrCeBBSmS2yyK5oTbRjjF3
	I2ThzC+UAqPDYagw+qh9Y0x6x56cCzUJauXeqWrqndmgRCxf/08HSGzrcABR2iQB8QGVxM
	4lSXGaXGdADw9gUk4PbTfeYlI1of3DM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-yXXcXUCsOp-nWF3j4Qf95A-1; Tue, 30 Dec 2025 05:15:48 -0500
X-MC-Unique: yXXcXUCsOp-nWF3j4Qf95A-1
X-Mimecast-MFC-AGG-ID: yXXcXUCsOp-nWF3j4Qf95A_1767089747
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43101a351c7so7845798f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089747; x=1767694547; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QPeHJm+twCiufdOXqLeCn+SgUmZXimx3Kj8OMbSgWcg=;
        b=bQ/HbEYjNkNw4GOqt29NjfpwNJkMUoztoEvr64Ppr8lbJ3224HO5X8wrOAe+mil+Pz
         Tz1I0PKlgmqhMtQFmBGBSCLC/Omr1qWBkrAkVME27WwwXQ/vtgA7j1IqAHRWqRWFRl2G
         /ns5g2z/FMVxRZEozM550fAkUewyL5nAUJj1T5/Z70GbdMjHTHLhG7+DiZfqEvKPctjV
         KVM6uHGAP0ULWx1FjNINl3cd7Gcx7vwi7I/xJ84jnZygb5VPe50x62PvVKLT60UjIM3v
         mGBb0I2g9F9gw0qbl+/IdaOhP4baFcH3/2DCOkfKmwfkVjObQk103KmD6GGz0GXvuTFS
         a/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089747; x=1767694547;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QPeHJm+twCiufdOXqLeCn+SgUmZXimx3Kj8OMbSgWcg=;
        b=IJ/wY2omW/pNoNoBxiBMb1hpqh3KgPy0iQFpY9omlCa154o7aaz9vZMqw5Bf5X4UE4
         6t8lql3NpMcOKvSFKOUjqboEI1CXL0zWD2Js3qYX5zsk1qizwpQth7q/ll/T9Pxhjf5/
         /4WFNUowgEBBgD7lxZz90jGtWfYzxZa+tU8ef7A84fFMFi10arH0JQgJSjgFvduMvLF0
         HdzqAGBfrVs2y5HCfkkC4pP6FBOKtWXd58KubE80UblKid/0zik+Bf3Wr+KKwSfDBGdX
         ho55bNgcjGcPI+0trc4LX1YTQZSl6RwQuZ0y9eC2VKJ/fS8bSz2CsXzcyHSfkBMZAVi6
         SORw==
X-Forwarded-Encrypted: i=1; AJvYcCWcnR1DUtujijVGSrgtPImB6s9UVxKPndp0Sb18gIy+JmC5fAO2IWBB5zyFmB8AsnwfcEYMvSx+x5Vj@vger.kernel.org
X-Gm-Message-State: AOJu0YxpoMKR1VKAxYDwSv7lCvzS1drxL1FG1xx3oJwfs9pLB7+H7Ifn
	qKh4OoV+hgeFDNNfmZ9YKudVQmo9UWKFK/JTQz/y9qBzlkq9BNZeDPb3RoEYttVLuv61cUVd2ta
	rXxn6kwGhZboz1K4Cd1H682ZBtL6cwJrZ88gpE02EqYuAAzG87mZTXusXwUNToNE=
X-Gm-Gg: AY/fxX7txVmyIdEbkUWaF3e0eY2LYG2InYQA4H806gEZ4sivZsk9zhF26zXgQioQCYK
	ghLrzqVV4a1SwU8Ke0JgDL4DzmEVOKQGCYV9p4ls5JevIioNDDNGqZGGJ4PAqZ4NWVm+BTVY9GX
	xkcePPV/SMIQpo6POSp1KzashUpn+hvD9LyJcLcN+PbUsglHrRBqjz6Henjq0ySTkwQxzpQFV0S
	J2F/i8r9x/hKPY6dZCl2mAJ5Fn5GuU7Sr6LoYxIo/t20OzbHABIVW0U70MRGA05oHh+3idCegNi
	Vlz+/SfFIkPMnd0a4mWi58vtB4TgPdeACIgOVnWa4ISLXTzo2yWdI+j4zEN260aFqyNY7Nz1Rcg
	AhDIC+O8JjrmHALnRwghgzdmhPb63dqkY9w==
X-Received: by 2002:a05:6000:2503:b0:431:a33:d872 with SMTP id ffacd0b85a97d-4324e4c1219mr30005606f8f.8.1767089746605;
        Tue, 30 Dec 2025 02:15:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbvOFHJ91a0TKLxq+k7tMABBS8U1GQCYZPCELRU5Zsc1Gaj+GYCwYcD6RmChYOtX8+5x3fqQ==
X-Received: by 2002:a05:6000:2503:b0:431:a33:d872 with SMTP id ffacd0b85a97d-4324e4c1219mr30005566f8f.8.1767089746108;
        Tue, 30 Dec 2025 02:15:46 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324e9ba877sm67681523f8f.0.2025.12.30.02.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:15:45 -0800 (PST)
Date: Tue, 30 Dec 2025 05:15:42 -0500
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
Subject: [PATCH RFC 00/13] fix DMA aligment issues around virtio
Message-ID: <cover.1767089672.git.mst@redhat.com>
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

Early RFC, compile tested only. Sending for early feedback/flames.
Cursor/claude used liberally mostly for refactoring, and english.

DMA maintainers, could you please confirm the DMA core changes
are ok with you?

Thanks!


Michael S. Tsirkin (13):
  dma-mapping: add __dma_from_device_align_begin/end
  docs: dma-api: document __dma_align_begin/end
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
  vsock/virtio: reorder fields to reduce struct padding

 Documentation/core-api/dma-api-howto.rst  | 42 +++++++++++++
 Documentation/core-api/dma-attributes.rst |  9 +++
 drivers/char/hw_random/virtio-rng.c       |  2 +
 drivers/scsi/virtio_scsi.c                | 18 ++++--
 drivers/virtio/virtio_input.c             |  5 +-
 drivers/virtio/virtio_ring.c              | 72 +++++++++++++++++------
 include/linux/dma-mapping.h               | 17 ++++++
 include/linux/virtio.h                    |  5 ++
 kernel/dma/debug.c                        | 26 ++++++--
 net/vmw_vsock/virtio_transport.c          |  8 ++-
 10 files changed, 172 insertions(+), 32 deletions(-)

-- 
MST

