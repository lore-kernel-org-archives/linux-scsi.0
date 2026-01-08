Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AC83ED13A
	for <linux-scsi@vger.kernel.org>; Thu,  8 Jan 2026 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882754; cv=none; b=rhmL6lqhDjocZ2Q44Q5RT7y9v32bktC0e0DxauAVM319v+iJuLsUAysra/SFZ/1WjvCNegBLiN1yJRtPXzgX9Uplg17kDyXHCCQoQf4FQOtf9NZZh3fUx0OGxguFVHk5bF9ed6WLTmWEGWl5Bi54n5LH+LoUUc8FjiadqmtxPhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882754; c=relaxed/simple;
	bh=/ul1MI70WNuWUatNq9QXmWY0n1CnY3rQPVMj9RML37Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4VBnNRpT5hG5czFXblFIQ7oVuw+vou9H0KsfVCtOcRO03C79SVhF+UVNUIsgMmQ3hSAJZ7CyeEMRiXxxmR00CH9BDo08/Epm1MLpH+SKfxesDaTlyeh8PiZ+ewaxGHjKwzGW0sjG60M1rWz9asepBDO5Srk0GiT99icnKuozwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bIcUG7v2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cd9QxvTO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bIcUG7v2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cd9QxvTO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767882751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQ5KldlPLZnW3hZQd/TnLSW7zs03bZTdFv6fpQxf5uk=;
	b=bIcUG7v2nKz9oYVi2iLvIZtWoX845PSheZ69CviFgrx/Ct6iQ8mcdjoyvXTVP/EGFy2uW3
	36CrIHPsFXWZqLoPcbDPuVEBiYstHoHPnfoYDh0GbqN50utWDMdahp/Va3mocrfsg1j4yw
	Kpo5hLdDQpMA1PWCYDcowCMl2HWXmoY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-Y_cxzlOPPkm8_Ej4kOrgqA-1; Thu, 08 Jan 2026 09:32:29 -0500
X-MC-Unique: Y_cxzlOPPkm8_Ej4kOrgqA-1
X-Mimecast-MFC-AGG-ID: Y_cxzlOPPkm8_Ej4kOrgqA_1767882749
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso12848255e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jan 2026 06:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767882748; x=1768487548; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ5KldlPLZnW3hZQd/TnLSW7zs03bZTdFv6fpQxf5uk=;
        b=Cd9QxvTODks0ztP34MROOObzNjZqza1DL13X5LGU+3bNbMe87u28a89qx/1sOIvjYy
         lUY1Au62thKnhe7XYtKCPPAyiA+sni2y4891yo7JgRnPevqxTI0Pn2gwsMQvD99XbQ8n
         sHAbNveFEsuAhBqbexb+4PTfxwHsvy3NOybDfREefotwwMlCXPhYp+AAH3NTZke4ma5H
         2qYPvZMOLCOPavurx+oUabhyDPxP8V8zS/wqUioNCXA0u1lT6m7NHNNspQeUPH1u1AZK
         2+MGynggXCyX+Thomy/E9eRien5KDz7Ytver2AgZymWypzRO+XwQIWJI3ANfVtFCKkjl
         tQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767882748; x=1768487548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ5KldlPLZnW3hZQd/TnLSW7zs03bZTdFv6fpQxf5uk=;
        b=UEqjyvDgc+h7lYMzalSq33WZvaV4s1n4KkmKLmyHhjWWGfM0jyjwCZoRSyMPJ+qZcT
         ZgiqU5sQ0qEva0NE5taZoNTHqz60bLtlHXN/JKTh26gitTJEr5Ql1LUKOcTNBz7D9kBh
         6jXcqanw0ycj7rM8q6TmqWyRHgeBGvDub+eIIFfAzjf08CDefSQeaNyRmi/1cV7vYGWs
         5onefeNBI42OYFN40tIYCWGlS8aSTigvpM9+GWUSH2X9AJ4BhCNyQB913a3BL3c1hMCt
         JxtyNjADEbxWXAaGfaHOJAFCRNpjDJV7732UJqBM0vERq28ztGQIAHvRoNXcVUQKyaCu
         c/5g==
X-Forwarded-Encrypted: i=1; AJvYcCVc5m02EeId8kQUZli/WD3o8iKKd/gVyKG97Oldd3Eypwaymodz2VqVov/TfA4w/7Bgz05+nkRnzbXY@vger.kernel.org
X-Gm-Message-State: AOJu0YwDrWc0fhfB9xWAvMBz048Aq+IftT1HeTDHEi7hBhzzkw7tfuCA
	mc68sAg7JZvlnnOYuA1foxTY0PJSAg/G/AfZQ94ZyJ+PtyGEz2mVXD9MuHQ/qwPjBBUIRVEyHpY
	DOPrP9/7l1PZrNQ17TiTrqh+i+0XZFgkxhBPI3x8d9vg/bwH4FaAlMdgNhVqOxU0=
X-Gm-Gg: AY/fxX5xOvBUT7L9vMT9WQQjEyt6/IaHRRUwJcrEyCXTGSRvBzYDQQ6Uk2KRuWkCchb
	pRyINBUaBz7OIeBzE66huzssxLxRoiuKTNcDmHIsM5NCpLWQ0uyyNShRmNWhZoEOp/9sVAnuLCm
	9/flKxXzUgPT7MS1mlRgnx+hOLcid4J041cUA/zR2DnG+R8CzEK79ZvXnCzvGyLaFxWG7B34bu5
	fDfoppx6+j7T9mnbmFAVeIonEOtwDUly6YhpovAyG+2TCljZOo0fgPisiUDWNqG2u1zZVlLFQOC
	CLMCzl1ZdUKpqC23VcfDvsVfE2lDguJjISokbyL13h6uyD5jgBBb/5J9rBBxJFIV6Cr0dLrfGsL
	Ytw1HEyuiFblcdhETl/sWsr2yDG4uMZJGTg==
X-Received: by 2002:a05:600c:6c95:b0:47a:8383:f2b2 with SMTP id 5b1f17b1804b1-47d7f63722dmr100357955e9.17.1767882748601;
        Thu, 08 Jan 2026 06:32:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7Gl8OtqeQkvPJx1M3QhvEhlvzebP4MIt/f4g31duD4E6Ii6eayAMa8grqHGKZjLNtnJFSpw==
X-Received: by 2002:a05:600c:6c95:b0:47a:8383:f2b2 with SMTP id 5b1f17b1804b1-47d7f63722dmr100357545e9.17.1767882748121;
        Thu, 08 Jan 2026 06:32:28 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8717d78fsm38131185e9.9.2026.01.08.06.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:32:27 -0800 (PST)
Date: Thu, 8 Jan 2026 09:32:23 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
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
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 13/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <20260108092931-mutt-send-email-mst@kernel.org>
References: <cover.1767601130.git.mst@redhat.com>
 <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
 <aV-6gniRnZlNvkwc@sgarzare-redhat>
 <20260108091514-mutt-send-email-mst@kernel.org>
 <aV-9F42fMfKGP4Rg@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV-9F42fMfKGP4Rg@sgarzare-redhat>

On Thu, Jan 08, 2026 at 03:27:04PM +0100, Stefano Garzarella wrote:
> On Thu, Jan 08, 2026 at 09:17:49AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Jan 08, 2026 at 03:11:36PM +0100, Stefano Garzarella wrote:
> > > On Mon, Jan 05, 2026 at 03:23:41AM -0500, Michael S. Tsirkin wrote:
> > > > Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
> > > > last. This eliminates the padding from aligning the struct size on
> > > > ARCH_DMA_MINALIGN.
> > > >
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > > net/vmw_vsock/virtio_transport.c | 8 +++++---
> > > > 1 file changed, 5 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > > index ef983c36cb66..964d25e11858 100644
> > > > --- a/net/vmw_vsock/virtio_transport.c
> > > > +++ b/net/vmw_vsock/virtio_transport.c
> > > > @@ -60,9 +60,7 @@ struct virtio_vsock {
> > > > 	 */
> > > > 	struct mutex event_lock;
> > > > 	bool event_run;
> > > > -	__dma_from_device_group_begin();
> > > > -	struct virtio_vsock_event event_list[8];
> > > > -	__dma_from_device_group_end();
> > > > +
> > > > 	u32 guest_cid;
> > > > 	bool seqpacket_allow;
> > > >
> > > > @@ -76,6 +74,10 @@ struct virtio_vsock {
> > > > 	 */
> > > > 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> > > > 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
> > > > +
> > > 
> > > IIUC we would like to have these fields always on the bottom of this struct,
> > > so would be better to add a comment here to make sure we will not add other
> > > fields in the future after this?
> > 
> > not necessarily - you can add fields after, too - it's just that
> > __dma_from_device_group_begin already adds a bunch of padding, so adding
> > fields in this padding is cheaper.
> > 
> 
> Okay, I see.
> 
> > 
> > do we really need to add comments to teach people about the art of
> > struct packing?
> 
> I can do it later if you prefer, I don't want to block this work, but yes,
> I'd prefer to have a comment because otherwise I'll have to ask every time
> to avoid, especially for new contributors xD

On the one hand you are right on the other I don't want it
duplicated each time __dma_from_device_group_begin is invoked.
Pls come up with something you like, and we'll discuss.

> > 
> > > Maybe we should also add a comment about the `ev`nt_lock`
> > > requirement we
> > > have in the section above.
> > > 
> > > Thanks,
> > > Stefano
> > 
> > hmm which requirement do you mean?
> 
> That `event_list` must be accessed with `event_lock`.
> 
> So maybe we can move also `event_lock` and `event_run`, so we can just move
> that comment. I mean something like this:
> 
> 
> @@ -74,6 +67,15 @@ struct virtio_vsock {
>          */
>         struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
>         struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
> +
> +       /* The following fields are protected by event_lock.
> +        * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
> +        */
> +       struct mutex event_lock;
> +       bool event_run;
> +       __dma_from_device_group_begin();
> +       struct virtio_vsock_event event_list[8];
> +       __dma_from_device_group_end();
>  };
> 
>  static u32 virtio_transport_get_local_cid(void)

Yea this makes sense.

> 
> Thanks,
> Stefano

