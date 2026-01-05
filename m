Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2123370EC
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 09:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606489; cv=none; b=WxsD4Q0UhpbnMwTzpbcjmq+9nuI1bXrfbslRAYjKW5zWzEcsn73sB3hPEcsFm4cMuR05asX9ZAjXnYt32ozc4gGI9q6ZHpjhLwMfbJnmNIF4i8q9QlD1lwL2AqDsQ1zTJ7Ne78qg3fwazTfNKhDk1jk8HS84GCEZKKOBNDsUjy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606489; c=relaxed/simple;
	bh=GqAwY0OHbZKQzzJb3VatReAfBA97RCbOF3bWO0/Z1Js=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iBvV56VZtQjrasHm4tBa/Gmw79JMdfUjRUZt+n/Z35g3z+HxfDqMVDwnf8pQCFqWTiM5ok9Pv5nriFNZQjYBjTBJSGNtRb+7lhTwer3htOaY2QWT2d9TUqGa/VBEPqr7TXk0kgfyMiOVU7dR7dsJAEoplZaummCKvczloQNGD4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AtICXBre; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AtICXBre"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-47d17998350so9762155e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 01:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606485; x=1768211285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3YNJPmUNbnGNTCEfFfuOCZFqj9o9elJ+A8mEb2IK5hU=;
        b=AtICXBreWgR5zWZkx70j07qlSmmhIC3ZqGCmXxKIMHXOTLOy6nxn/qnWTCcX39gjFk
         3C08xn4HmXvUYMcS+jm212kQBf9YRafJTOsRdrtWvU36SA7FdNxr8XNcVBgfGBzTAkuK
         Aoa1U3rC9OJpawzXJNlg1hERi0SRUuLISUXKnXuQmxC+z5zY5iCJ/NwZlwTh/huv1ech
         c7swds+qtkU3pFgdt4NUYI4ZRIDQ2zF4e4Wk1Ltncgakxx9VL0Yr5ihmTvmeoyiX72lj
         x25excA6kO47QS8slAvbH3zgN3UoSoQBCQx6iEM6UfvFUWWgb58FaR7EieXDWAS01dYW
         sxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606485; x=1768211285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3YNJPmUNbnGNTCEfFfuOCZFqj9o9elJ+A8mEb2IK5hU=;
        b=jDSB/HRe4H8NP9eBKOmSEPRQL+LTEP2K6/TkjAzqFc3KaarXx+llWpJTrRXs27eHcJ
         ajJSfCVWbKC2pN6YwdK7W6ggLO+12Kk+2S6qQaoi1CrEUKjczNFWbdrDtfMbO14u1w/L
         ISBk0vsvNkI6hfnmXiPXIcOEk7EanFYbGGEEhnOe41oejRcM0a6DZOeJLf/8YT/JP+Mm
         hdCZxHQMcWBEmJ+xB/nRXSuP9vrLGOY4xeVmC9MBVwmCSdkGd2hS0m2a0sHWwWybVFf9
         G4xkXWg2jX/p2UcD9G7CFsBduf30HG4x8pcEhvoHrheoSnLDJ4efxLMipcPgMfmTNDtA
         AIPg==
X-Forwarded-Encrypted: i=1; AJvYcCXbGyLtwXE8WznXxggGcA5Vr09K3XqSD8Yz4TlMi/Q5C3bBlXV6nf9CoAWJ8RQrNgyWeXuiCYFgdnUB@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7yB/ZjnlfdYkRDZ4pD0FkVAWA1f5CrJUB+A2UnlBY/yqGUHGr
	LT+4msy/JOPrfldzmSENjbciJra0dWcJhUZbtsZnBB5gtTR02QdM9IeKUzen/By1QdU=
X-Gm-Gg: AY/fxX4G1FM+0h3B+v3pN/1zOAEtPcf2PXEzadztNBJm69dwo0l3AEadDouxioNfoMM
	sQz2QS6XedlC4UUuMIXu5RmUM/06OKxLCFyKakwG/ExExzaqx8ahNzwrcVWXjiBG7mfNQK7h7UU
	q2mlyITKKQMV862YGAuFgMJFqlMJdBF47cZY6MwomaXWvCD9XSiWzTMFrV2DOZDyIK8ee4VIHwJ
	a7QcQsB9cp+4OydYJxQ/bM1xsVrjWAo3mfMsQcKQbMKwCBBwlV6ThIajOEsUz7meR0FjgUFGVF3
	6OAzqC/NatMkDAtf1BE3J7A8bSOi/0nuQkPwHkOsSXuCqwJpl5Tg3PuYhsF4j2PoHMQyx2si2PQ
	RYQ3TurhfduYScloaXuKTRaeD7Vu5R0VmXaawZp9oxCuM4VjiEW5lz1jIgMSTC+0MRxxmMKh1eD
	c6FGH5QBQOE4hr1o28GPdOo2tWfkHEtYug5j4FYE709eY+04vNtYBclY6SWhQU7CXRRL3ziBUEx
	GTy
X-Google-Smtp-Source: AGHT+IHPziOrpKV7Kr9yyjS7tcuC3KfVS3vu6/0u8YX5ecS7isO2cmN7o1CvFXRGO2JgzmojB4/s8Q==
X-Received: by 2002:a5d:548c:0:b0:432:5b81:493 with SMTP id ffacd0b85a97d-4325b810aa7mr24854531f8f.5.1767606485367;
        Mon, 05 Jan 2026 01:48:05 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1af2bsm99699009f8f.1.2026.01.05.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:48:04 -0800 (PST)
Date: Mon, 5 Jan 2026 10:48:02 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski
 <brgl@kernel.org>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 02/15] docs: dma-api: document
 __dma_from_device_group_begin()/end()
Message-ID: <20260105104802.42bd8fe5@mordecai>
In-Reply-To: <01ea88055ded4d70cac70ba557680fd5fa7d9ff5.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<01ea88055ded4d70cac70ba557680fd5fa7d9ff5.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:22:57 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Document the __dma_from_device_group_begin()/end() annotations.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I really like your wording ("CPU does not write"), which rightly refers
to what happens on the bus rather then what may or may not make a
specific CPU architecture initiate a bus write.

I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

> ---
>  Documentation/core-api/dma-api-howto.rst | 52 ++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/Documentation/core-api/dma-api-howto.rst b/Documentation/core-api/dma-api-howto.rst
> index 96fce2a9aa90..e97743ab0f26 100644
> --- a/Documentation/core-api/dma-api-howto.rst
> +++ b/Documentation/core-api/dma-api-howto.rst
> @@ -146,6 +146,58 @@ What about block I/O and networking buffers?  The block I/O and
>  networking subsystems make sure that the buffers they use are valid
>  for you to DMA from/to.
>  
> +__dma_from_device_group_begin/end annotations
> +=============================================
> +
> +As explained previously, when a structure contains a DMA_FROM_DEVICE /
> +DMA_BIDIRECTIONAL buffer (device writes to memory) alongside fields that the
> +CPU writes to, cache line sharing between the DMA buffer and CPU-written fields
> +can cause data corruption on CPUs with DMA-incoherent caches.
> +
> +The ``__dma_from_device_group_begin(GROUP)/__dma_from_device_group_end(GROUP)``
> +macros ensure proper alignment to prevent this::
> +
> +	struct my_device {
> +		spinlock_t lock1;
> +		__dma_from_device_group_begin();
> +		char dma_buffer1[16];
> +		char dma_buffer2[16];
> +		__dma_from_device_group_end();
> +		spinlock_t lock2;
> +	};
> +
> +To isolate a DMA buffer from adjacent fields, use
> +``__dma_from_device_group_begin(GROUP)`` before the first DMA buffer
> +field and ``__dma_from_device_group_end(GROUP)`` after the last DMA
> +buffer field (with the same GROUP name). This protects both the head
> +and tail of the buffer from cache line sharing.
> +
> +The GROUP parameter is an optional identifier that names the DMA buffer group
> +(in case you have several in the same structure)::
> +
> +	struct my_device {
> +		spinlock_t lock1;
> +		__dma_from_device_group_begin(buffer1);
> +		char dma_buffer1[16];
> +		__dma_from_device_group_end(buffer1);
> +		spinlock_t lock2;
> +		__dma_from_device_group_begin(buffer2);
> +		char dma_buffer2[16];
> +		__dma_from_device_group_end(buffer2);
> +	};
> +
> +On cache-coherent platforms these macros expand to zero-length array markers.
> +On non-coherent platforms, they also ensure the minimal DMA alignment, which
> +can be as large as 128 bytes.
> +
> +.. note::
> +
> +        It is allowed (though somewhat fragile) to include extra fields, not
> +        intended for DMA from the device, within the group (in order to pack the
> +        structure tightly) - but only as long as the CPU does not write these
> +        fields while any fields in the group are mapped for DMA_FROM_DEVICE or
> +        DMA_BIDIRECTIONAL.
> +
>  DMA addressing capabilities
>  ===========================
>  

