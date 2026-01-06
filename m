Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1748033122A
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711018; cv=none; b=P9Eg38asax4JVHk1wYlM6qePyfcHmh1MY6yrC6yBhJtj9hzghfuXk3Xdt+q9R2ejsBU0QNL0ofXnHAONA9JhZmIYOhK71domXrL5+zCFMpYtN4x68Jd7m8yHhyVQwQwmfsA4LqboxRI+BGFV/CfqfaEghQIXWsKw7uWDMR5pFVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711018; c=relaxed/simple;
	bh=RqfJjI32FdZ7MpeaFMqvXp4bO7LyOB4RofYVb7BWxmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQUkG/xpxpGGTbEMz7xwHu8YNZUKigBkQiW7VPJvR8NkPoLQczqxhi6BiZ1CP7UluKYOoje7zoTMPBRI2SGlN5FMwNhXjBIR5BbPh1QrTPYime0oajDBYFZpYg9IB6wTq9uZFPTUtCz/IvxRRa3VuSxugxK02w1xQYZDZ89CwJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q6N9B7rq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aoAHoHrm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6N9B7rq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aoAHoHrm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767711008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
	b=Q6N9B7rqBOy0edULfnPlNXw7pyLqnuaZ2kNeNi/0yvEpuUlPAM74/ALShcP0D8LK8pl7aE
	RyAIL7DkJq/N2Ik4ubtpFZ3y3dt9u5EJyLMNZ0u8EGrDZmXZAP3Y4N4X5EElvXoGhAjASm
	9e+El8SlpopjnrZbBE0ZpFD7PJKDNUA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-ld6WgdhqOCybNysVANoIQA-1; Tue, 06 Jan 2026 09:50:06 -0500
X-MC-Unique: ld6WgdhqOCybNysVANoIQA-1
X-Mimecast-MFC-AGG-ID: ld6WgdhqOCybNysVANoIQA_1767711006
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477c49f273fso10752855e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 06:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767711005; x=1768315805; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
        b=aoAHoHrmwMZxBs2Qp69OPcSFyaa1ig8teHOPJlTckRJ36lo6MAUEbtcC31JPG6FdXt
         r8wn0YoUmXby44f4lHbgR1uSQGC250mufP2o8GPX7n8jjsh3a/4d0o7zyVeYiY7or4wP
         5fNAD2ypUG6iOfyMx50WuECY+vE25qV7VYCmDh2JcvSmkuCmk0jV6tgIRzf+JgvRWkZV
         /tyDnQ8+btDHVPo2V53lrmTUi6h1X5KXIFtPigLUhEhrf0OZfRoIPXQSNa8Sq6KPyslf
         ekrDkyLn4FoULpuMDI1pdSm/qjS0v7F1JRtZwgfRIfIsynaHmQ0FNYWqHLh8MavZgcjF
         OJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711005; x=1768315805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
        b=oUN2G6PUlShlItWFGGiOaL2ie4fXwQrmR2iOD0kye+Kn0yNczrvEYgmJv44jBPY3eE
         DCpW8f4aKUBB8zNAZjlWwl33hcc9ngJlaiajO49+TMuSpwzICWShBm5FJ3qdxdiu7ts7
         0WS/Uxzkh9V2aqcaJumtc1vGvICc7T66WatESgC199QGMcjxJA6+m3BF/bw9WlEVudsR
         YOfMFucDn+Ex4wuZ145wNohb9lOFYPJrWSkcw20CwN5/sdtD4fJZcX8SP3vTxxlewlSi
         Syc/hk3vYQHIMBBK98yXoAAJro0l8+/nN0FKYc+sbnAYRjJHBhKoBcJSzp4dYeRJgadr
         A+CQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGaud/DZYd4ogNbCZ9E26EGIgQGBHcuqlPBEWUbmhu78HqAQTnrNZLikPezapqDV3LMBD7gOhW+asr@vger.kernel.org
X-Gm-Message-State: AOJu0YxKysQcWzC3vi4uCJ2Scazkk88XklIFGgMV6dfi7ODFDUdENDk1
	vIz4Nk/Ak7G5MlYzsxSx2Xti7IQlbzsP/IM1Oim7fn4YwsxI0AY0kf2zlj6ZhZXztGN72r0rC7p
	9XR8F1jHVXImOj9OWk3YX88gabRCDMfMGuHMQUuD3qByYr6hlVP3wJUMMK4ZoNlM=
X-Gm-Gg: AY/fxX4icIjwqFsDFUhb2FnAktQKnUpu0dCHO2s4Ks3SkE2Yxs7rOHQu7oqybasO/yO
	rM1QQ9qGUHKcWYzU+4a7obgGzBNBKtzN0QoWcWuN7DEsJcsbAUlSVsek2QfNgkgXYCCwItGlgzd
	xngsyz6Sk8Tp5lO21Ydjshk9Aw1wO+rc1utOmR7lCKsCnhKDDF5VMIfy99bjLiT/UZHhD2VdEGc
	g/szB5t30zf7g+kCGsMPQ6pE57SI91wEWYkzHRW3nSeZ/mJEZQNz+/FAzssD7PXMkfoLwsVht+4
	RS+MQNEJpuzOgAWOblDnTsVae+62pNKSEDfX1I9Cq7GJgkzfz2S0HWx4C8MOYqQQJWhbcYFBBqm
	VzuAhl4Kplf0g++3CtJZsieqo85Out0w66Q==
X-Received: by 2002:a05:600c:c0c5:b0:47d:6856:9bd9 with SMTP id 5b1f17b1804b1-47d8383d75cmr7820855e9.23.1767711005518;
        Tue, 06 Jan 2026 06:50:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXHeGoEH1PxicAu3pvp2IKmLzneQBM5bSFfOKMFfLat4mQRdOWLJ6nIuVR4bStC0oG3LJdHw==
X-Received: by 2002:a05:600c:c0c5:b0:47d:6856:9bd9 with SMTP id 5b1f17b1804b1-47d8383d75cmr7820345e9.23.1767711004990;
        Tue, 06 Jan 2026 06:50:04 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f695956sm48129575e9.6.2026.01.06.06.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:50:04 -0800 (PST)
Date: Tue, 6 Jan 2026 09:50:00 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
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
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 10/15] virtio_scsi: fix DMA cacheline issues for events
Message-ID: <20260106094824-mutt-send-email-mst@kernel.org>
References: <cover.1767601130.git.mst@redhat.com>
 <8801aeef7576a155299f19b6887682dd3a272aba.1767601130.git.mst@redhat.com>
 <20260105181939.GA59391@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105181939.GA59391@fedora>

On Mon, Jan 05, 2026 at 01:19:39PM -0500, Stefan Hajnoczi wrote:
> On Mon, Jan 05, 2026 at 03:23:29AM -0500, Michael S. Tsirkin wrote:
> > @@ -61,7 +62,7 @@ struct virtio_scsi_cmd {
> >  
> >  struct virtio_scsi_event_node {
> >  	struct virtio_scsi *vscsi;
> > -	struct virtio_scsi_event event;
> > +	struct virtio_scsi_event *event;
> >  	struct work_struct work;
> >  };
> >  
> > @@ -89,6 +90,11 @@ struct virtio_scsi {
> >  
> >  	struct virtio_scsi_vq ctrl_vq;
> >  	struct virtio_scsi_vq event_vq;
> > +
> > +	__dma_from_device_group_begin();
> > +	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
> > +	__dma_from_device_group_end();
> 
> If the device emits two events in rapid succession, could the CPU see
> stale data for the second event because it already holds the cache line
> for reading the first event?

No because virtio does unmap and syncs the cache line.

In other words, CPU reads cause no issues.

The issues are exclusively around CPU writes dirtying the
cache and writeback overwriting DMA data.

> In other words, it's not obvious to me that the DMA warnings are indeed
> spurious and should be silenced here.
> 
> It seems safer and simpler to align and pad the struct virtio_scsi_event
> field in struct virtio_scsi_event_node rather than packing these structs
> into a single array here they might share cache lines.
> 
> Stefan


