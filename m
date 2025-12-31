Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9642130E0E0
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767214118; cv=none; b=FfB47AHjftnKhCX+vKNp0ntdt3St58RAzVdkEcctS01Z/xDWPTgobKyhTk3sqfL/RwZRrC93KcXbspVqm5a6pxuJ597YBrN3Xd9X/7JoG70vobVSZhgV0dPu0c9MdesMlpDrq1wuLI4Xda2hRGtNAc0mNxMzkZWfdk0K56fGSwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767214118; c=relaxed/simple;
	bh=BpH6W25VRu697Yn7DFwf7krulZ0ceVuuDV1JpnQSClg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SMQK9ROXTd75IT5xOYfukAU8d/zqYjdk/9hHbkOmFLN24ZKM3z8AQ5uHEFVOLJW1Ek9SAq9LyL+xo/t+Ef01ZzgqbRkg6VJ7z0mNzZex3na5yqaViVzd83DIZiQQXzdUHQYUdRNvFtCp95vap+R2Jb7OpeOLWzDe/a6ZLAmWyqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KO2pst7a; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pvP0z3pG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KO2pst7a";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pvP0z3pG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767214114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t2sN+P6W4rMfz5k+VlkZX24a7rMpvbJroFZ4fnRS1gs=;
	b=KO2pst7a6knSWN6rwQQ5+yUFBz7s4wLh4IGyTsMIGnvbkyIE/0qxnBMpRegE4yi2MmXl2s
	vff0dvjNVp0zDxOfz/B46oqVHAM7wvR2Azxy9iXq3hp3M6oed6ampl9o9l0xauspk84wAk
	cjzW7jrv5VoxMU+rxuxsP+aLjHY/wmc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-MK1VsonYN16OR41mqL2DpQ-1; Wed, 31 Dec 2025 15:48:33 -0500
X-MC-Unique: MK1VsonYN16OR41mqL2DpQ-1
X-Mimecast-MFC-AGG-ID: MK1VsonYN16OR41mqL2DpQ_1767214112
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so111894725e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 12:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767214112; x=1767818912; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2sN+P6W4rMfz5k+VlkZX24a7rMpvbJroFZ4fnRS1gs=;
        b=pvP0z3pG4NqUkDHEluND0t26A7txfqzDiv+38R+RThoSWb5dEsO1hy7Cc4yqorCchh
         gik/JRZenBBZc51cql+BtTqJJ63YhG+FLqOw9wpzLarl/BMIS0RnUe/QPBsvoap2cNeP
         FPw9Um2+unbT1MD29TdHNIN5x6W6gv1CorNe9QPA67D0EGBlz4F2Pg+xnhbBbVQOPknf
         JfYCugGl1w2hambIeB0Hr1bPNMdkSO822uk37H8IbRyOPNuPt4eIr1xt94kQ5rA6TcXZ
         m2ERDOWtf+wCEVR++av9x3FewQECEcUv6ApsMPpFpR6DmoQcUZXLYWIoCdEXXmjyyXhP
         SN3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767214112; x=1767818912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2sN+P6W4rMfz5k+VlkZX24a7rMpvbJroFZ4fnRS1gs=;
        b=QGZW4h29oqFH1ehzzNf3wwu5bn0DExNzhNqKGhnfOAb2BQDHPav6UKgZ5JP7iA88Jn
         LeKuewpsRQ9m7L6+8Xb12/CrKZdvdWQIFaMVOHcU4J2aO8xxU0lKx0CPlIDoGWT0Ea6I
         AHaCZLba1fjfURPMckDWofJR2wa6DU+8YQRENW7fA1P+DQuuCYS57WYbYr5QBqb9dHtD
         Ste4af0HPwwNO6pxCYWHCQAsPoj13ivJB7zF7UpFwxviHuF/DbFOn0mYzkVyAX3ELbO+
         XW2geiXIAq/s5dJNvkgk4mOoZ0byTbPljlhFNW+07SQ/bnz9cOkPQAUOGClOud/6nOqT
         HPcA==
X-Forwarded-Encrypted: i=1; AJvYcCVGqwUNogz2NGLF8MEMzDMDhBtvTknIjoxOLYKykRWIcQ8J61iMCeeo2rXrl/jNbfy58CzHl4D6LMGO@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9s+bolmv8vr8sTJgOxDH4VdtsAHMhHYc1dVdgvoha1n7Au/Sd
	6rghRmXjb+9tHL9k/4gDwEH016JKRKwymDES6EOAFMnr1tY4zaVmsU9WAouR/hST43rvZfFkVR/
	TTPCYCb4E7oMcyvimNCbq+ByKBEJgvd96oEvlNIWCoPxfSrhyGzyzrVDB1AAFWLI=
X-Gm-Gg: AY/fxX42ZEweL5jAw6Ayuu4zvw3tDelb4cqrc+n2lFufC5XWE4jcT0H22xiRxTc1e8L
	tjTPUmP6ynr+IbrPr9rbFJwVhkot0K5AQmv2l7fIjnUoRPtfxusTGAort1ESs2gUGNXo4i9EEis
	r7ve+krMBuOQyTS3zZEx/ppy/6MUjEleXRSxmCmmrlVJQk8Fig4ie+Hcu3elLS9+kqJ7A7vXZ45
	HcCDuDg/cFEjIxnePoeQY/gTEPOclwRzcnJph4wK8Alv3QEAdkDyqYMB0uFhChw971XHnlEXu3J
	rfqeSSGlnDzs2KDXDjj5Eh6jER8o/M8/V8BCzXC1YoJXqvTM8IZy1XypL0vS41g8NsKZIkYdKgw
	bfdtxCVgkastEvTEpiA7thVS2FGFq9lEpkQ==
X-Received: by 2002:a05:600c:444b:b0:477:9814:6882 with SMTP id 5b1f17b1804b1-47d1953b77fmr390890935e9.5.1767214111822;
        Wed, 31 Dec 2025 12:48:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUX2S3Ts6MrXbJAEZ1+1hODDbGMnh81w30kfQclg714E6BWRq3zDXGinSJodthec3i9GHMDw==
X-Received: by 2002:a05:600c:444b:b0:477:9814:6882 with SMTP id 5b1f17b1804b1-47d1953b77fmr390890515e9.5.1767214111286;
        Wed, 31 Dec 2025 12:48:31 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d19362345sm662070775e9.6.2025.12.31.12.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 12:48:30 -0800 (PST)
Date: Wed, 31 Dec 2025 15:48:26 -0500
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
Message-ID: <20251231154722-mutt-send-email-mst@kernel.org>
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

Made this change, and pushed out to my tree.

I'll post the new version in a couple of days, if no other issues
surface.




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

