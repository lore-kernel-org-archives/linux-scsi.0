Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1D22D3225
	for <linux-scsi@vger.kernel.org>; Fri,  2 Jan 2026 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767358968; cv=none; b=LPhDbDpAQm2MvDBOEycGP5wdS+JjypGN8j6nna4lfM7ClZcyRmdMLvHTMSh7i5+8MgLI8LmpuhdrN9OkP1IsA4Mr9fs4PrQos4U/ObySsdCTFUqA6mr2vJC6PVPtXATDt6someUC2/L3AHYKHlAhJetWgipWkwEP+zKtw/pATQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767358968; c=relaxed/simple;
	bh=MzslOykd8x14UYRASjqMHG8WwlyrJUbVhQ0wOUaMEeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJLJP0PCgJCeY7PWlejVbBNj9u4utGHWaj1Nt4QSK2ss9zmEQNnMN4L1NwY2/CEbiAZFRsAOW8kDhwmfe06zZuT/UshRwW9ZQjB/0cdjeQE6nXcnkfF9hicVSQjXCTxnPrCUoYJamDuuWK8JCcws7OBomZHfhN+h572EIc2juTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y06vawIW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ruf3khPa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y06vawIW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ruf3khPa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767358964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WmDmlKfsEAT3FFZsP/TiPm94jNR+IqB/SohCa4X10es=;
	b=Y06vawIWBnbKDzI2gaRETBnHIbrgy6y5/pCIkANcKyzqiSl+5oyDSeQt/2VIuzE22+AP+e
	WWCfB85rSIy2LBTgIDGJTofUcl8H1Iqa4E9cAFfX3LQjKqMvBljvsZV57l9hvnpzbLgtQP
	SR1/eBMt5382jEX2inMjIOa5NxEbMCQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-tV3x122ONl6QhLS6INMg5A-1; Fri, 02 Jan 2026 08:02:43 -0500
X-MC-Unique: tV3x122ONl6QhLS6INMg5A-1
X-Mimecast-MFC-AGG-ID: tV3x122ONl6QhLS6INMg5A_1767358962
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so85449125e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 02 Jan 2026 05:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767358962; x=1767963762; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WmDmlKfsEAT3FFZsP/TiPm94jNR+IqB/SohCa4X10es=;
        b=Ruf3khPaNH8M9NxijcWmnqF1uGroWh2HoBxkyeczM+hJb4+uD/NOyRdvR+09ZwKHGJ
         burTy8fRY0gU/FLGFYWteU53mqULab/AUNyMBvoFqWMBrfCjdzymDZqlVLYp1lHifqfb
         HIcacXAF2RW6LIv9nwPSChhLRmIrO/gWssbsZlfD33VuDHNaZqwEq6i6fFRR0K9mej/b
         OFXwWJq/Hbo10sp18oOp2rvNyt2Dnqzk6jO7c6vjCRCIM5StfFKx3BecQIvBSjVY85eV
         IzC3xUDPskmvLiYurzGloEs4xsX8mInpc3Sdx8e52cskh8+aFahgk2EDs5E7Kibg354S
         Zfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767358962; x=1767963762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmDmlKfsEAT3FFZsP/TiPm94jNR+IqB/SohCa4X10es=;
        b=FdsFxyAqUqPPkJUJ9Y/MijaI7vmNe7PDqz7L9TFKRxCj+gEJFNhQa2lw6dVsjBtzD/
         0IUtACdMApsJzvkCyTSi31pw8Ov6SfvHclk+we9LGatoqONu9K/q29MUaYAAObSjdiak
         JjT8QZ0IIjRELgDle0fpUlp9d7rmgi1G0gvcIt7Ci9fa0M+xdaF0quMTQBl0rJXPfpJW
         MTOhM1mQkIxYPBnlVcMGqfjMdbSOJJSY0XNhPHwkSebgfF0co7LiYOYvnxsWfJ/nYvb3
         Dn9vQMge14QIKseHU1lgDlMcmyzkclTdAn3iiWQK6FCEwuCwbCtarGayEv22KK+mPojQ
         BVaA==
X-Forwarded-Encrypted: i=1; AJvYcCWNyYPqhkyy9SsIpbPyefbWgQRD0uNTCxvSUkmEty2Hu8tq3xLe09E+eIS8yf1p1m2s6dPcnHZisk73@vger.kernel.org
X-Gm-Message-State: AOJu0Yypy9+Fk8kcdf1z2Hv5XdBltURePg6zRNLFFi3J5WI8QawCmK21
	gUm4zLj+QQ/Zd5qOTRwlhoiAtigprKxn58fhKd8ml3j5j5OGNe00R8sgpeZv7RjEFAvdGi9xaRp
	jA6BpEwGLHS33UOPCVN6iIEBqqbZZzV0/m/kMCGmocw2U3vtvm5t29HyRr/p+5gY=
X-Gm-Gg: AY/fxX53ThaIKUpQdNKZ8sIispbK4VXoFv8R4C0WmYhLs//tffQqjFzCCcmbzo/DSAB
	RBCphHC1fZyISWbG0HyTq5qIn5BpDm6uVyBmB72cK+ltM3efWG0yvpYagoAdPCLaPDH14imrfl7
	20NDAUDaI6UuBotgcm/cXA5D3JfYDGiavrXLBjCw1giSsj/qS1w9VIAc5kUz8nxoOV3XAChHva0
	LfXQbhqd92jmOFPZ/HA8UJ7fDVFWJRO8Aswnd4Dtq9n+M1XBUZyP5No0o1hTBRDWdFEWpv/Prfh
	v14n9kxMwL9MkqSGtiXnnzlX9H+FAzMxJdE+RexoUzoYmy0YBC7Gsxiq6tK3tKnOUhsXHkCRQ9i
	7uYkndWWI0cLXgfVvpuBBWcJL9qWCG49O0w==
X-Received: by 2002:a05:600c:3508:b0:477:1bb6:17de with SMTP id 5b1f17b1804b1-47d19590bbemr512375295e9.30.1767358962197;
        Fri, 02 Jan 2026 05:02:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBPpH0ihQmD8Y4wAGqUXdjbUDmUwQhrGC4bvR7Khhg9b0D8Nv1fILL/X18iGX7aRdaW+Lc0w==
X-Received: by 2002:a05:600c:3508:b0:477:1bb6:17de with SMTP id 5b1f17b1804b1-47d19590bbemr512374585e9.30.1767358961687;
        Fri, 02 Jan 2026 05:02:41 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193d4e91sm720685835e9.13.2026.01.02.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 05:02:40 -0800 (PST)
Date: Fri, 2 Jan 2026 08:02:36 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bartosz Golaszewski <brgl@kernel.org>
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
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linusw@kernel.org>, linux-gpio@vger.kernel.org
Subject: Re: [PATCH RFC 15/13] gpio: virtio: reorder fields to reduce struct
 padding
Message-ID: <20260102080135-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
 <55e9351282f530e2302e11497c6339c4a2e74471.1767112757.git.mst@redhat.com>
 <CAMRc=MfWX5CZ6GL0ph1g-KupBS3gaztk=VxTnfC1QwUvQmuZrg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MfWX5CZ6GL0ph1g-KupBS3gaztk=VxTnfC1QwUvQmuZrg@mail.gmail.com>

On Fri, Jan 02, 2026 at 12:47:04PM +0000, Bartosz Golaszewski wrote:
> On Tue, 30 Dec 2025 17:40:33 +0100, "Michael S. Tsirkin" <mst@redhat.com> said:
> > Reorder struct virtio_gpio_line fields to place the DMA buffers (req/res)
> > last. This eliminates the need for __dma_from_device_aligned_end padding
> > after the DMA buffer, since struct tail padding naturally protects it,
> > making the struct a bit smaller.
> >
> > Size reduction estimation when ARCH_DMA_MINALIGN=128:
> > - request is 8 bytes
> > - response is 2 bytes
> > - removing _end saves up to 128-6=122 bytes padding to align rxlen field
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/gpio/gpio-virtio.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
> > index 32b578b46df8..8b30a94e4625 100644
> > --- a/drivers/gpio/gpio-virtio.c
> > +++ b/drivers/gpio/gpio-virtio.c
> > @@ -26,12 +26,11 @@ struct virtio_gpio_line {
> >  	struct mutex lock; /* Protects line operation */
> >  	struct completion completion;
> >
> > +	unsigned int rxlen;
> > +
> >  	__dma_from_device_aligned_begin
> >  	struct virtio_gpio_request req;
> >  	struct virtio_gpio_response res;
> > -
> > -	__dma_from_device_aligned_end
> > -	unsigned int rxlen;
> >  };
> >
> >  struct vgpio_irq_line {
> > --
> > MST
> >
> >
> 
> Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

Thanks! There's a new API as suggested by Petr so these patches got changed,
but the same idea. Do you want me to carry your ack or you prefer to
re-review?

-- 
MST

