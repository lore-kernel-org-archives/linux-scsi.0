Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE382750FB
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767192172; cv=none; b=spjrMhc7PTuGxzz3D/DChTHJ9cBwgj0nZgC+Cn6Wg29VYEhm5P7uLY3xpm/vfvuSArtwJVecHuJneJ/WYeceLkZ6uIXJXQth3um0fvWeJKNHTt6w7rrell5FAD6rNdu9eNFXLZ839OAxoJbN8VgvaaDk2/zqbZQoAopY6asieyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767192172; c=relaxed/simple;
	bh=7yEDDnq5O6nyMipRBT3oeW2l7NFO4JF7mnRHmsBSRLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YEP7Zic/HKhbn1OHwKpe11Ec+9OGU3rU/nVinQq096E9dICKamvTh9KdU0Fbmjvxvq7DE/+CfRFPBJRhfxve/aD2IS2hNvrsJ6SYs0fp76pK6Mh3J0PuPmrLRUWS0HDtl23XajkVhu++zTBtjHRf6Lb77Q6P5dBJMOL+gzeWg/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hiy1nehM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NhOq0hUA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hiy1nehM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NhOq0hUA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767192169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g4mmJIWspy2eeK4ehzqbWNIMKVXq0BnPvs75MDLcYu0=;
	b=Hiy1nehMQyFAupyVX6y6SeHjDgF2jPBYOR+Mr5lsqPmuTygZsNEOaLVb67PxafU/5pEH22
	VIK/8ZI38TZv6QGSPunjQgXZo4eZUl3nuUxHdHxsGOtXiUgrblz2WCo20Rux1COLLn5Ql7
	985ieuaI+3DyFaQAfyTaaK3lszml+Nc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-dfqCIlUdPICw79as2TWnOQ-1; Wed, 31 Dec 2025 09:42:48 -0500
X-MC-Unique: dfqCIlUdPICw79as2TWnOQ-1
X-Mimecast-MFC-AGG-ID: dfqCIlUdPICw79as2TWnOQ_1767192166
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-432586f2c82so5596277f8f.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 06:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767192166; x=1767796966; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g4mmJIWspy2eeK4ehzqbWNIMKVXq0BnPvs75MDLcYu0=;
        b=NhOq0hUAZmQSTLFVcSJwCjoeM/cV7ikzBF1n4eKFKunBwlAuDDh7nQkdS98fW1jyn/
         YUty9qdkQGqSzzIfsB4lgUlvbm62k3hHJ9h5Kq038uone/fp0iEl9RJp/qNZGC/2ymir
         QQL/vNADxP9eZ4GPx5bcRNoz65GtihR4xUPfM3Y55hcX6siLx0r2IQGnlsKaZ1rS7/G0
         PEG2pBMhe1rynbAA6pXsPB/ggvvj+8xaEzQ/mUyfNPvBDmDzE4zRfphhC3p5rM3R+soI
         miVqSE76vU302nEwNJFJVREoUFe2hmcM+30wB2jXvKj1BnWEKozkKLJeL356no2bLUIx
         J2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767192166; x=1767796966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g4mmJIWspy2eeK4ehzqbWNIMKVXq0BnPvs75MDLcYu0=;
        b=urfT/TZqmktglkwr12a3ZxyOlUTXEp2pW7CNIaY4ZbYjfhV9OpaM34Gso9EBXEijKJ
         4HrmaIDCrcB8a49T9t7+/EzPVVoGIvpH+sS8y3QeFpSQoxPLFD+QTVWBTaAQflb9Wr+G
         5dBOumN572IiDvtPQVrvQy4hk4fThW8G4wk9tWKY3Ac8JIFrJ4Td94RuGiiw4OELNqXU
         CwZhSQT6kJe7dBru6QDhGfcLMi3IyP9KPY+zvul/wXO3wtMeURgjstlvJaZIuyf/pZpR
         DMbOy4IWsh6tsNbW767rWk2KuZ22LwAhA86gAnJJexqKFvQoL0kCZXQvzGrfj587ZQ9Q
         3vAw==
X-Forwarded-Encrypted: i=1; AJvYcCXFKc7FTkORKnmSKMjoyil68uGGUE9vgHSLW5iSeA1A11gmnsgR90szVv0QGJUEkadNlaTg88gyTTgR@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4+czH9kUefdrmPKq1CaDJMGrPKYi/Z6bST1ByxJAfLxzgKl8o
	05zG7BOYKDcF8NK41tRdWkF4I8YczhItDbYcWspJE9U9ng3TSOjdGlZ57Ffn2A1Gv9gxkUJoFy7
	2rpk6dJzHzxQCqUC/uivOEeXvA3Yh4ePDLvE07GSJTHZGw6kb9KYB7ndugL1ABfk=
X-Gm-Gg: AY/fxX4DkIFb/OXxm9y3VqJSjyjUEj2paqqFGivQygStgX7AYgZWKeXi/hrNfxaQjAQ
	mK9cDJZhaCIzLTarU107A8aAp5a82YMhnffM1yHA/87zcwNpKZVmgZ+j5YA/EGFp90bZJA3/UY/
	Ylbk6TsDitj9GZ139t4AP6Z/OjhqY+gYefJS6BhiGZ8sJjQ+AWcT07MI2LFv3dtbUYELqKuymcU
	zRek3ktKXVql276vpH1tNT+dSH9jWMCxoBbiI4W6+b29a73N3oz8yeLOOTSRGLH4cCvHRf1JqKt
	ii22v0cbattK9/Vawp1DtJk/l6RGtOlRGXptc2njwmy84aZqMd900L2MW4JVh+B3BD+8692xdhN
	H3v9wyYxDh6Uwlp0mQMJ9p9DbW/T6LN5a2A==
X-Received: by 2002:a05:6000:2005:b0:430:2773:84d6 with SMTP id ffacd0b85a97d-4324e42eb06mr50147681f8f.24.1767192166340;
        Wed, 31 Dec 2025 06:42:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGF5p3yqPt+kPdPb7TGA5JeM+zegz4+9TsD6bOekShro6ixOnDhxT1ci9gV1aizVZntyxUQBg==
X-Received: by 2002:a05:6000:2005:b0:430:2773:84d6 with SMTP id ffacd0b85a97d-4324e42eb06mr50147651f8f.24.1767192165832;
        Wed, 31 Dec 2025 06:42:45 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa64cesm74610221f8f.35.2025.12.31.06.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 06:42:45 -0800 (PST)
Date: Wed, 31 Dec 2025 09:42:41 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Petr Tesarik <ptesarik@suse.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
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
	Simon Horman <horms@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 00/13] fix DMA aligment issues around virtio
Message-ID: <20251231094052-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
 <20251231141224.56d4ce56@mordecai>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231141224.56d4ce56@mordecai>

On Wed, Dec 31, 2025 at 02:12:24PM +0100, Petr Tesarik wrote:
> On Tue, 30 Dec 2025 05:15:42 -0500
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Cong Wang reported dma debug warnings with virtio-vsock
> > and proposed a patch, see:
> > 
> > https://lore.kernel.org/all/20251228015451.1253271-1-xiyou.wangcong@gmail.com/
> > 
> > however, the issue is more widespread.
> > This is an attempt to fix it systematically.
> > Note: i2c and gio might also be affected, I am still looking
> > into it. Help from maintainers welcome.
> > 
> > Early RFC, compile tested only. Sending for early feedback/flames.
> > Cursor/claude used liberally mostly for refactoring, and english.
> > 
> > DMA maintainers, could you please confirm the DMA core changes
> > are ok with you?
> 
> Before anyone else runs into the same issue as I did: This patch series
> does not apply cleanly unless you first apply commit b148e85c918a
> ("virtio_ring: switch to use vring_virtqueue for virtqueue_add
> variants") from the mst/vhost/vhost branch.

Oh right sorry I forgot to mention it.  It's this one:

https://lore.kernel.org/all/20251230064649.55597-8-jasowang@redhat.com/

one can just do

b4 shazam 20251230064649.55597-8-jasowang@redhat.com


> But if you go to the trouble of adding the mst/vhost remote, then the
> above-mentioned branch also contains this patch series, and it's
> probably the best place to find the patched code...
> 
> Now, let me set out for review.
> 
> Petr T
> 
> > Thanks!
> > 
> > 
> > Michael S. Tsirkin (13):
> >   dma-mapping: add __dma_from_device_align_begin/end
> >   docs: dma-api: document __dma_align_begin/end
> >   dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
> >   docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
> >   dma-debug: track cache clean flag in entries
> >   virtio: add virtqueue_add_inbuf_cache_clean API
> >   vsock/virtio: fix DMA alignment for event_list
> >   vsock/virtio: use virtqueue_add_inbuf_cache_clean for events
> >   virtio_input: fix DMA alignment for evts
> >   virtio_scsi: fix DMA cacheline issues for events
> >   virtio-rng: fix DMA alignment for data buffer
> >   virtio_input: use virtqueue_add_inbuf_cache_clean for events
> >   vsock/virtio: reorder fields to reduce struct padding
> > 
> >  Documentation/core-api/dma-api-howto.rst  | 42 +++++++++++++
> >  Documentation/core-api/dma-attributes.rst |  9 +++
> >  drivers/char/hw_random/virtio-rng.c       |  2 +
> >  drivers/scsi/virtio_scsi.c                | 18 ++++--
> >  drivers/virtio/virtio_input.c             |  5 +-
> >  drivers/virtio/virtio_ring.c              | 72 +++++++++++++++++------
> >  include/linux/dma-mapping.h               | 17 ++++++
> >  include/linux/virtio.h                    |  5 ++
> >  kernel/dma/debug.c                        | 26 ++++++--
> >  net/vmw_vsock/virtio_transport.c          |  8 ++-
> >  10 files changed, 172 insertions(+), 32 deletions(-)
> > 

