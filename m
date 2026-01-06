Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC18A334374
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711117; cv=none; b=Wp8DVAqVjk9MCw7+c4oeFqz+7Xvnwgup4nU71blhI/K9S3BFO/XyqijMl6ugXXdM5S2Q+GU/sjuxQD9lI4AhzqY66g+J+i4/TK/0JdwDFDg42LjCUmmkpMCI/XEhxpRt1Yw/VrqlI1B2rX8mpGmBCFmLRnpHOYi+UCPxi1NO5+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711117; c=relaxed/simple;
	bh=OtGN4S8+ZWGuAfn6+2YZp7eQlkz7c6TNLgozVUvUCR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKAR4LwwBUKLGYKV6kmc7yf4B7Y8RhV+4se5th9vZKbffzuEpoyz4DiBkIYlutZwhZVfKb6+U+UW0hz6spmjShdn+9zb1MbfyhlYOBK6pkDDGWEH7YXtwrjc+e59uxahlWwrBk3BSzxJyqyXd29V3kkFDXLRelDj3Ah+2oYn2qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y84Qqx31; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FM0Ydb5f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y84Qqx31";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FM0Ydb5f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767711115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v8xGpc9e0AHSzqXJdY4dTy2UmvNhNHIufeUOIUm/LzQ=;
	b=Y84Qqx31I5wMPYwVs5CMOtq8M+c9qrucIU9n78Lo2w7B1rM14bdeV9HFLtzww6UMT+cZAQ
	Xa+pSSgZVYvA9JqOmVb0NO3ye1HGgHrgVnPVBbjaKLw4jsswsfgAoh++WDRZYDf/XJrx5E
	0KBNtav4ZrPKrqi8dPU21J4JDgFZdZY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-PtSZJOMQNICHdn7B88s0zw-1; Tue, 06 Jan 2026 09:51:53 -0500
X-MC-Unique: PtSZJOMQNICHdn7B88s0zw-1
X-Mimecast-MFC-AGG-ID: PtSZJOMQNICHdn7B88s0zw_1767711112
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f5dcd4cdso530513f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 06:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767711112; x=1768315912; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v8xGpc9e0AHSzqXJdY4dTy2UmvNhNHIufeUOIUm/LzQ=;
        b=FM0Ydb5fdan6x+pkR1pJDikE+5rPe3WwNvtNRo0JY14Evid+8FAayK9PXBBE19NE0V
         6zmoqhY0DFOh8fYaTQ2w8a69KO0ECm6f9yz6/NSy6/VZS/jtDSpgR87LSsEQVtgtQI6C
         Bm4swC4PpZaaXSSi+1Oswc7hFfYQjX22ZoqFwC51cURGKJrO06ZoOhjZ5eZZRNVMGH/R
         j7RZUi/wX1uXswo38RIPdWsCg4iwKcSnQ4YDfJ6vEwh4pq+EaWgBUP7DDSaV301bGKCp
         3WN9O3bTncPfs2vWtO7odr14bTSpvCTRf7UV8cA+BVh7m6Bzvi2UTfoEFMptn9FMl/Kb
         oPKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711112; x=1768315912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v8xGpc9e0AHSzqXJdY4dTy2UmvNhNHIufeUOIUm/LzQ=;
        b=vCeuVuvpb/QPPW1X34Md/3wZeQTwJ+ALtXKEv4VEQmfZgu2CGvax9QxOzdYAo7zrwt
         oK/9NcT5MmWGinTclhJ+WVlsiKl7xn1EHzcVZ0yuz0JEG4/vhrsscPYfqUgdfud8wuN/
         rsYQ5J6bbDDMsLoK1NOAC/GOLs0eZfX9yVmHHyBD9iNYVKONqn7T5C3oQLrx88JKQz9P
         SjAa4zotQzAniMuTy0oqvA69wboOH7juLJVL3nptc/V9VH98Rc4FqEsSODnSDN0pv9cM
         yTJVQwxElA3bMsqWK3IyHM47tNOr3LOViutLygML9I9m7ji313Sdpv/KlK9ewE+7eomc
         P6BA==
X-Forwarded-Encrypted: i=1; AJvYcCV609g+KJmrLF+Z8+d3cHT2obL9agm2tjSYAn6pU1Um/jI0wQ+FJG1jyA5BEbAlVXY3WtC05HP9CW8s@vger.kernel.org
X-Gm-Message-State: AOJu0YzSENav+WHwJEeys/JPO+byvDaYHXsNxmPUVxPztRwv7eaRh5UO
	kLBtS+TAsPbzbbRd3Zxo/CNxNQr9/AO/iDwcITNGsIlvkBmqTxznNNAP6BXiq2CL1FSqanwgdy+
	kRQlh/wEvTF5VrGwHWTMN22T5RcSG7yIwTrv4Ie1ClemKoe77CIywig5f8uQiEnQ=
X-Gm-Gg: AY/fxX7Hx+aeR6D36gz8VukLiQF4tAcvI4kggnLNDmn1Py9sfHGZgenA+BPOiKxMpDW
	9FyXqzozbzdWDQlX5snci6Y5FxOI+0qSJ/fUPspJF8WvtcoJVVPD0j0NtOrD9FZTTxBxvanb0+m
	h9EnJOCTVHfwtCekZ2jW52+j3LXcnPUbyMLmHJ2uyi+z8aRzoGzlYEKqmHcJ2iw00imvyFMXsof
	wVeIBIcMRcOHBiRWYznJrj230s9HcV7K/Wk5nZr96GN1YkW1Vq7qH78dX/vDqmlwFGbxaQaUSPj
	rK6JKpistEwNW6QUZBrGXVLkKyMAjaYot0h4cx6lycfHc/TIwEzCdNDoFosabDC5sIYuibqrP9V
	5bzCTR8ithEYX53oqhBeHJ3+mmX1zS04RpQ==
X-Received: by 2002:a05:6000:200f:b0:431:b6e:8be3 with SMTP id ffacd0b85a97d-432bc9f6dccmr4753198f8f.38.1767711112117;
        Tue, 06 Jan 2026 06:51:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGOynDA9QP29UwN/sUhG6OCzOdNXrD0Y6rHdaimQHcJZW2G3EKin+vfxrhBk6BDORYTgSmwkg==
X-Received: by 2002:a05:6000:200f:b0:431:b6e:8be3 with SMTP id ffacd0b85a97d-432bc9f6dccmr4753140f8f.38.1767711111656;
        Tue, 06 Jan 2026 06:51:51 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ede7esm4752453f8f.32.2026.01.06.06.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:51:51 -0800 (PST)
Date: Tue, 6 Jan 2026 09:51:46 -0500
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
Message-ID: <20260106095044-mutt-send-email-mst@kernel.org>
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
> 
> In other words, it's not obvious to me that the DMA warnings are indeed
> spurious and should be silenced here.
> 
> It seems safer and simpler to align and pad the struct virtio_scsi_event
> field in struct virtio_scsi_event_node rather than packing these structs
> into a single array here they might share cache lines.
> 
> Stefan



To add to what I wrote, that's a lot of overhead: 8 * 128 - about 1K on
some platforms, and these happen to be low end ones.

-- 
MST

