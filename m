Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E8D2737F8
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767192044; cv=none; b=tz5ltp09FRW0uo+EYV/vVgKNQEViIjhMNlZxx0uj8qJiR6vpMa+OusWgA/N6tYol0FdZF950c1f9Rg7FLT7nZuc5e3wueiamlK2fqixehRoeur4RBlmYGOLb5IjyrFjy3R1/GFzo3WvIgyS3suUufbDdRkJc2qgBXvUSVUxDtO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767192044; c=relaxed/simple;
	bh=uCJpKbQgK1JDZeWrhG0sD4sWy8cW8kDi8pCaSJxqzWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQQPkhiW96wswGIAQ/UYm/5HAasQwUoVSTOe6bd8zag5bwUfsY2oM8H/j8B3aDvzE/xbFzReFUsdtV8oUZ2kdym2sVHFojHIEKoRfsKJD2gdexWjQtpJWUtxRcQj9z3PdrU5BOgT3GmLErgzXcPIZzJdV7ByEx1RpESQBM0j2cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HDERpxxv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OUPcxx4T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HDERpxxv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OUPcxx4T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767192041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n0eNh1PwPkp66fDhwYL8c44iVldZ6MxzxhBv6XJLUek=;
	b=HDERpxxvpZ16olNTd6QLpq73Awqnw5dRWTOR76RV1UuLBRgsws7CIsIblbN4ZEpQaRgAkW
	MefHiem0jiigZlMiGVM8zhbdO6Mxt7Ov+lsmR4cdkv7MEJB7ZX6RC+ZW2yZ4CQuEsSnjRF
	SOX+ElHtx1Hc5HAnT4gOSpMlO/YCH3I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-4SQFQW4gNruZatCUYmcETg-1; Wed, 31 Dec 2025 09:40:40 -0500
X-MC-Unique: 4SQFQW4gNruZatCUYmcETg-1
X-Mimecast-MFC-AGG-ID: 4SQFQW4gNruZatCUYmcETg_1767192039
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47d5c7a2f5dso15473315e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 06:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767192039; x=1767796839; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n0eNh1PwPkp66fDhwYL8c44iVldZ6MxzxhBv6XJLUek=;
        b=OUPcxx4TcY8oIazW0j05RQ+fBwXK6dVnvRKGVVtsfOea04Jdvd7GJs4iaLtSJ27Yfy
         SMhJHXnaZyuB38co1vH7ROc+20AWAIKUV3FLm0wqz89/a4OoH0rejlT0OatejEoZye+r
         +S0PJZgV5f8riwSnNknTY1CeMcu0Y/KSglDf/Z8U+XGy2byq8cK/+zmIcpOIKYuKlSQ3
         8alwrl9vDI+MpaonjOc/8FuYyyjoJMGNMImUFcUG7ExRe3p6KMTgYLbmpsjUmItGvwpb
         JrlzLRpaxJe09bL7vC5PaXdLyK470z4j3bo8x3RQAwqjeSWPIwqDGquJ4ghBMjhXXWJI
         /lGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767192039; x=1767796839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0eNh1PwPkp66fDhwYL8c44iVldZ6MxzxhBv6XJLUek=;
        b=CEveppgmVJCsCc0pVJaH/uhYCFSl/r8kHBhFw0dcbInqe27RGOrP5tOywUjxjKVrfi
         VJXyVyYQUPWegz7QpKJ5oZM4vYRNLv9tagHF5q0M32OKTvQ/5vwoiku4XA+In+uLRlah
         IuZdxpiBGemH74wmLqUU89MbRAZlzF9NYzelV/8f5/jstozvb+lGHfH8gnCoUOKQWQdM
         NRl3KL0VE7fch4K5wmbWF2UGsSP+liNZVNz+9vfWFaEYlHLDKajwxcuAjDng41ld2hq9
         aR63E/HMywPQMcoY0goXnG6AC3A0+AYCskjm+ddmN8SSnee3KPxtDh+JbvOFnn8aff+v
         HcRg==
X-Forwarded-Encrypted: i=1; AJvYcCVJyqPVKBzAvdi1qIWQGrio6MICInHoH14QHDUiwD5GW1r+5LtJbg3Isf/Fu9tAB8xeAVosGG7QYlLC@vger.kernel.org
X-Gm-Message-State: AOJu0YyjAo+TZPVGiRiq6t6jVbgPcwcfOr5LwLG0PQ5Ho96wlgsuRH3A
	eok/3fsLr5rACYhOUBRSnxDYRWLMx/1XX7or0hopxsGp60u340TeyhlRMW+0fyBBObmXUJVC+TX
	im5MbyKnYXn1aFHpibrjVmr3hgiehlnCZApg9wLHs3uNbWQhZHR6tPGRBw0exdkQ=
X-Gm-Gg: AY/fxX5g4URGnyQk6oamXuy+FycKWXxb+Qy02IgQYElsiMCf/m1SagxA9qjf5g/p5jT
	zElM4hEc0OR4nf9By7bJgCKlhtkC2hy6OpTsCUi7QdlHiOSGyh2GfPxnZrKiXoHhFjKgoYpyfnm
	sU8myc43B/wzq3c0KB5Jc7I7ffw4y4+fhHa/Inb+iKNKCGju/g/xRVtJKWMn+7uPYCQQRAN6+0a
	vvIjpN2qtHjY4GsizOWkaPdTUc7jLLDvcEVQ6mPBT2A7QTmKcO2JHmzPZy3JT2queWU3+6v7bsX
	mbLzCYHTX8fTAvtJeTc4PgGaPGwBogyyGTxxfcFM9nreXTQRqHZR9K0dmbuKFluCW9c35Z2VXfW
	63gOAFoct8i+At6WQefHsk0Slba4PMnqmrg==
X-Received: by 2002:a05:600c:1d29:b0:477:1af2:f40a with SMTP id 5b1f17b1804b1-47d1957f946mr504015445e9.17.1767192039247;
        Wed, 31 Dec 2025 06:40:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFftjQcUwvXMCaEXUnp/nGSfuL085M1yJ9YObPox1uDg3/ci/kM4qMkiO89pT6mz04eQEDKgA==
X-Received: by 2002:a05:600c:1d29:b0:477:1af2:f40a with SMTP id 5b1f17b1804b1-47d1957f946mr504014855e9.17.1767192038655;
        Wed, 31 Dec 2025 06:40:38 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be2724fe8sm835831745e9.1.2025.12.31.06.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 06:40:38 -0800 (PST)
Date: Wed, 31 Dec 2025 09:40:34 -0500
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
Subject: Re: [PATCH RFC 01/13] dma-mapping: add
 __dma_from_device_align_begin/end
Message-ID: <20251231092346-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
 <ca12c790f6dee2ca0e24f16c0ebf3591867ddc4a.1767089672.git.mst@redhat.com>
 <20251231150159.1779b585@mordecai>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231150159.1779b585@mordecai>

On Wed, Dec 31, 2025 at 03:01:59PM +0100, Petr Tesarik wrote:
> On Tue, 30 Dec 2025 05:15:46 -0500
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > When a structure contains a buffer that DMA writes to alongside fields
> > that the CPU writes to, cache line sharing between the DMA buffer and
> > CPU-written fields can cause data corruption on non-cache-coherent
> > platforms.
> > 
> > Add __dma_from_device_aligned_begin/__dma_from_device_aligned_end
> > annotations to ensure proper alignment to prevent this:
> > 
> > struct my_device {
> > 	spinlock_t lock1;
> > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > 	char dma_buffer2[16];
> > 	__dma_from_device_aligned_end spinlock_t lock2;
> > };
> > 
> > When the DMA buffer is the last field in the structure, just
> > __dma_from_device_aligned_begin is enough - the compiler's struct
> > padding protects the tail:
> > 
> > struct my_device {
> > 	spinlock_t lock;
> > 	struct mutex mlock;
> > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > 	char dma_buffer2[16];
> > };
> 
> This works, but it's a bit hard to read. Can we reuse the
> __cacheline_group_{begin, end}() macros from <linux/cache.h>?
> Something like this:
> 
> #define __dma_from_device_group_begin(GROUP)			\
> 	__cacheline_group_begin(GROUP)				\
> 	____dma_from_device_aligned
> #define __dma_from_device_group_end(GROUP)			\
> 	__cacheline_group_end(GROUP)				\
> 	____dma_from_device_aligned
> 
> And used like this (the "rxbuf" group id was chosen arbitrarily):
> 
> struct my_device {
> 	spinlock_t lock1;
> 	__dma_from_device_group_begin(rxbuf);
> 	char dma_buffer1[16];
> 	char dma_buffer2[16];
> 	__dma_from_device_group_end(rxbuf);
> 	spinlock_t lock2;
> };
> 
> Petr T

Oh, that's a clever idea!

Will do! And GROUP is optional if there's only one group in a structure.


> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/dma-mapping.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index aa36a0d1d9df..47b7de3786a1 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -703,6 +703,16 @@ static inline int dma_get_cache_alignment(void)
> >  }
> >  #endif
> >  
> > +#ifdef ARCH_HAS_DMA_MINALIGN
> > +#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
> > +#else
> > +#define ____dma_from_device_aligned
> > +#endif
> > +/* Apply to the 1st field of the DMA buffer */
> > +#define __dma_from_device_aligned_begin ____dma_from_device_aligned
> > +/* Apply to the 1st field beyond the DMA buffer */
> > +#define __dma_from_device_aligned_end ____dma_from_device_aligned
> > +
> >  static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
> >  		dma_addr_t *dma_handle, gfp_t gfp)
> >  {

