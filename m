Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B748039FD0
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706737617; cv=none; b=FrpiEs50hDiLL/AHxd84Cd4b+NBl/Dn/lqNrqCpPEMlMzqmFSCsf0LO2BkPdedIgBjyut4ubsd5GucArIRMMbQbRAVYqLSYyY2Y5hZsAa6rrkuUVPb0JXKNweIDk1YCx4DFLIzyNaFgB+G6gLLk7bY6Avot6zDl/5mPN1aHSHnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706737617; c=relaxed/simple;
	bh=eFnmC1lbVYN4j4VfW6XU+vAA3X/Ct0usmb10imNRazA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BUdc62Y9zswyTKx6dtrjyzJ4j4wpw75th6+r1WRHySyfWZDwEarkaLFFwY5O0AaJZ7omRxm04J8ivxhHjhtZ/A22eAgofZhutwUQdo+a4kW7nsd3UFIZ+dmORY/aBG1IQ3/KFyYQzzc0cuVmKDzZAAmtLMkyaqTOm5MLySa0q90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S416ex4f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S416ex4f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706737614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xA0WL8OAWu59QlhnSKj+NZw09nFzDmIW6P1Gg1TTP9c=;
	b=S416ex4fb5qw5rce7Vae9b4cR7ULIzCkubFYFxwOmLTrtMJ0emEJanIxQBFGGDMFVF4gTs
	0DA9od0s2sTR12nWo/AzQ6GItqjJ5WsDBlC4D7G9V61IwlRt57DsdXoxmX73m/Lan5rPpl
	fT9lf16U0JTxDl6Z+pbxmuVheteSyA0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-XkTuepEUNEad6UhEzWI4zg-1; Wed, 31 Jan 2024 16:46:53 -0500
X-MC-Unique: XkTuepEUNEad6UhEzWI4zg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d06d8cf7fcso2747101fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 13:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706737612; x=1707342412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xA0WL8OAWu59QlhnSKj+NZw09nFzDmIW6P1Gg1TTP9c=;
        b=vIMiF2uCtl7tNlxESW3ip59jcnDP7C3V6lxv0mHto/wBK2aHZY96K55IFQirXss1uj
         O9T8PMQLw8tH21YLpNm18QVAMGBhLHVdI8KtbUtoRoJLAL4u/O30sYh2Vl8N8AIjuGoH
         x4QrodaRiSkt7cCLHdsGN/vBZagg6+iKWAzUzOHMHO4bIShKp3JWsmZ6TqHKeADr0Bpx
         9yGW9wOsLR+1xBnYP4TX8GaYGnJUw3b8VLcjYqgxOK6NeCMvj6nHpFZx7BoogVwF/H68
         w9doBf8zBv0x1Reesu0L2G5eJ3dTq1VafJlAXIZHFjNavxH9XixuIc51aKt1aXQ9YOMi
         E5ig==
X-Gm-Message-State: AOJu0YzF4tQ+p2fWqAKcEuyC+dtuPNg6f4JfVze5eubfrfGaBsXxRamt
	OhqJ8KVm08r5foLGsCko+Fy+AzmHaGP05+kPYim195VNd6ABI3cIUO04KG/8r7rH4pY9Jzsd7Sj
	m8SkEo/2V1Zro7yFGs803wnRjTcJ5OURrHiAvq1cm2fwkimZfBGqmcPzG4mG7I3YYSfZXhNYTw4
	O1YWhqN0GRtEvZd349sdTjNjv36MJxj8BTJA==
X-Received: by 2002:a2e:9ec3:0:b0:2cf:1288:910 with SMTP id h3-20020a2e9ec3000000b002cf12880910mr1956864ljk.14.1706737611874;
        Wed, 31 Jan 2024 13:46:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE23fLdVgxCbf16DcIFLnyMiHBcJtbPkDANivp0IhWFO/5OXRw56/KeQCVp5xbX9m/eGo6azpw0AIqz+PJ+MPs=
X-Received: by 2002:a2e:9ec3:0:b0:2cf:1288:910 with SMTP id
 h3-20020a2e9ec3000000b002cf12880910mr1956854ljk.14.1706737611595; Wed, 31 Jan
 2024 13:46:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131191732.3247996-1-cleech@redhat.com> <20240131191732.3247996-3-cleech@redhat.com>
 <2024013125-unraveled-definite-7fc6@gregkh>
In-Reply-To: <2024013125-unraveled-definite-7fc6@gregkh>
From: Chris Leech <cleech@redhat.com>
Date: Wed, 31 Jan 2024 13:46:40 -0800
Message-ID: <CAPnfmX+ZXraFC1+2Lu+WdgdUud4ALEcFAcsRQotVjfsGFsqUvw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cnic,bnx2,bnx2x: use UIO_MEM_DMA_COHERENT
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nilesh Javali <njavali@marvell.com>, Christoph Hellwig <hch@lst.de>, 
	John Meneghini <jmeneghi@redhat.com>, Lee Duncan <lduncan@suse.com>, 
	Mike Christie <michael.christie@oracle.com>, Hannes Reinecke <hare@kernel.org>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	GR-QLogic-Storage-Upstream@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 1:30=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jan 31, 2024 at 11:17:32AM -0800, Chris Leech wrote:
> > Use the UIO_MEM_DMA_COHERENT type to properly handle mmap for
> > dma_alloc_coherent buffers.
> >
> > The cnic l2_ring and l2_buf mmaps have caused page refcount issues as
> > the dma_alloc_coherent no longer provide __GFP_COMP allocation as per
> > commit "dma-mapping: reject __GFP_COMP in dma_alloc_attrs".
> >
> > Fix this by having the uio device use dma_mmap_coherent.
> >
> > The bnx2 and bnx2x status block allocations are also dma_alloc_coherent=
,
> > and should use dma_mmap_coherent. They don't allocate multiple pages,
> > but this interface does not work correctly with an iommu enabled unless
> > dma_mmap_coherent is used.
> >
> > Fixes: bb73955c0b1d ("cnic: don't pass bogus GFP_ flags to dma_alloc_co=
herent")
>
> This is really the commit that broke things?  By adding this, are you
> expecting anyone to backport this change to older kernels?

That's certainly where things stopped working altogether, iommu issues
go back further.

- Chris

