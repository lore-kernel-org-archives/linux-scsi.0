Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD813214813
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767189726; cv=none; b=SVTizqnrA6rDrx3JpfD9TVPEhxIP59Hd8Ygidt6hXCed9pjMi/MgKV6R2xMHDnfKsfahhWKByN1Y8U6xNePxYUfxeEiDn52ReW2UgkECFKiaz4rpi8FfEwfPRzHdx4uQlKjjz4lPmqd/gtVbd7diEdnAIpiWRcZFcXYdzJaRZnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767189726; c=relaxed/simple;
	bh=4Hf8qGAfIDnMbElA9BV7uSYKEWjXXxN6zt+BgVtPhAs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U0zBUtq0TfMSltIlcqCZTDDgCHXpERwD+/pNSMYcRM19CFKYMzPzOQcJc0QulXJGV0y8SO4rG1t8/YDQ0JtBiY7HJrwygQCv7+rMHEM5wq87QmaPnNmiSODXCgUXcNF18tz6DqW4vzCeTjeSXJC/iwTib6V954TQKJ48yfo6y0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f+D1ouYW; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f+D1ouYW"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47797676c62so10078025e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 06:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767189722; x=1767794522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kF3B5IdjLDGAw+kMK0g4LlwArvDLn5Kmbe4r9Q45hmQ=;
        b=f+D1ouYWMJ1UqzYlbVRrds9ZuhaEIzCognWhf5Hu9rZQP8kr2ApNEsiqTRT3GYMeoV
         sTa9PyUVAVWltZHod9NBZo07NQd+5X9JlqWSrj09UZkyQRmOcSZz7FHyCxDN1cHTuFnp
         yIsTYnwTIVGyyvBw7kvXeM4S9Nyho1/0zeDYA+gEBae7mjBOy/Dh1XEYjZoCh83ekN0m
         1WgXXsYEkystG5HLfaWousHU2nAfPYVcQpyxiZPu8DYAEnVP802z6Uer+QJ1WyElaMky
         7vjHK6ou3VoLPXT8CfAA9VJ6V/eJcyxhmOgh9Tf6u1z60ZC3+EaHXb49xMq5eeOIPt6f
         iDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767189722; x=1767794522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kF3B5IdjLDGAw+kMK0g4LlwArvDLn5Kmbe4r9Q45hmQ=;
        b=ZXOCKaCkLhuKa4znHi5V8D5z1I6A7d3+13E7r9yAfAnw+e/0ngI2jsH/C1rqjeRn9p
         rcW7QMARsKTpopOWlYDzUW40368mipf7Eu73MsGogo8dDo6aTD52idIZqgMrlpw0G4FR
         V/5BwxbbkN6ILv8gk31L/7mnVtpyUzVu7xIQZc0Kuy1akh8kBCOldnn+2RyuOXjg9A5a
         zbj7vRK/53up1LnJ2h8RJ3PL+n/hKcB8fFehSCz27zeXy11cLtFRqOdRkuomnkWJjbw7
         EjTdPfjIyYtc04lVR/RUkdo+mXTAyGfV9IlypG4NxOdhdLerb1g16t5Yl0YWaWLWozU5
         z8xQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3e+b5b7L7xtnbiedvVVnG+539MSGaoUOnJdAqXyP0GiAX6bwFTRhGXRB1yNJYozWPelLRiQA/eGSr@vger.kernel.org
X-Gm-Message-State: AOJu0YxpXkRomSJv945HxSfOK92uXraSftXnPW8ao9wtKZxZSWbXdfV0
	yNoV89H9EMhuNbsWPuvMD/X15LfeA0nBUgPGDmZ2n48UUlXF9LdkWTq2hYRtISCkip0=
X-Gm-Gg: AY/fxX6Vk7KS3h24k9Xw9YU+fW5Rw1nKFYRvBqRyyQG9Zr5EOR2BCU9QdNf4TT6YspF
	mbu2hLO8mYj4kprpMFvMeK/YxIF7u4WI1YBbMxF5mV/AwUD5u3vpGWhx5mmrLAOhfH7mNDcqFL5
	3fP0yDEFoOqY297ei8g1hnkFXIAdL4DxWgRMQlhAT3vmq8Ba7bON8Mlh6NgjhpUt4LNRykeKeqM
	v8SJjtoPfMP08Ld3HdOlAChzuZYSvn93UJld4O4HbxrPlcBlMjgaHKFL0DEh7Jm7yrwpb/Haho/
	H2Uxm6MZkPWEK9205dAcQPkzvObXPEVIfOfbAJeiRrPpEziZc9GA1hPKvLrrsXJ8BrCOuft7RZ7
	PGqTQRNrB8oqhVSTHVIlEBsI0IzSlUtXfGmi960gHvMa+fTtKnQZctY262a8synYTP3LtwlWVnm
	pL9YRi895a3L8ASxeE6/n6ZLOXzRYim602UF4RdoLay1eYY53oDmXScUIS5QcuBu1jDOlcLTmXD
	T/j
X-Google-Smtp-Source: AGHT+IE0s0lyU5FbbMJZMjZzb/JdJphgG95YZRZrXFcSa/kp+KRPaXRAnUQjMNNmxS+JnzgO7HwnTw==
X-Received: by 2002:a05:600c:4fc6:b0:47a:94fc:d063 with SMTP id 5b1f17b1804b1-47d19538e2cmr221697055e9.1.1767189721959;
        Wed, 31 Dec 2025 06:02:01 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab2ebfsm73767887f8f.40.2025.12.31.06.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 06:02:01 -0800 (PST)
Date: Wed, 31 Dec 2025 15:01:59 +0100
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
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 01/13] dma-mapping: add
 __dma_from_device_align_begin/end
Message-ID: <20251231150159.1779b585@mordecai>
In-Reply-To: <ca12c790f6dee2ca0e24f16c0ebf3591867ddc4a.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
	<ca12c790f6dee2ca0e24f16c0ebf3591867ddc4a.1767089672.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Dec 2025 05:15:46 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> When a structure contains a buffer that DMA writes to alongside fields
> that the CPU writes to, cache line sharing between the DMA buffer and
> CPU-written fields can cause data corruption on non-cache-coherent
> platforms.
> 
> Add __dma_from_device_aligned_begin/__dma_from_device_aligned_end
> annotations to ensure proper alignment to prevent this:
> 
> struct my_device {
> 	spinlock_t lock1;
> 	__dma_from_device_aligned_begin char dma_buffer1[16];
> 	char dma_buffer2[16];
> 	__dma_from_device_aligned_end spinlock_t lock2;
> };
> 
> When the DMA buffer is the last field in the structure, just
> __dma_from_device_aligned_begin is enough - the compiler's struct
> padding protects the tail:
> 
> struct my_device {
> 	spinlock_t lock;
> 	struct mutex mlock;
> 	__dma_from_device_aligned_begin char dma_buffer1[16];
> 	char dma_buffer2[16];
> };

This works, but it's a bit hard to read. Can we reuse the
__cacheline_group_{begin, end}() macros from <linux/cache.h>?
Something like this:

#define __dma_from_device_group_begin(GROUP)			\
	__cacheline_group_begin(GROUP)				\
	____dma_from_device_aligned
#define __dma_from_device_group_end(GROUP)			\
	__cacheline_group_end(GROUP)				\
	____dma_from_device_aligned

And used like this (the "rxbuf" group id was chosen arbitrarily):

struct my_device {
	spinlock_t lock1;
	__dma_from_device_group_begin(rxbuf);
	char dma_buffer1[16];
	char dma_buffer2[16];
	__dma_from_device_group_end(rxbuf);
	spinlock_t lock2;
};

Petr T

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/dma-mapping.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index aa36a0d1d9df..47b7de3786a1 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -703,6 +703,16 @@ static inline int dma_get_cache_alignment(void)
>  }
>  #endif
>  
> +#ifdef ARCH_HAS_DMA_MINALIGN
> +#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
> +#else
> +#define ____dma_from_device_aligned
> +#endif
> +/* Apply to the 1st field of the DMA buffer */
> +#define __dma_from_device_aligned_begin ____dma_from_device_aligned
> +/* Apply to the 1st field beyond the DMA buffer */
> +#define __dma_from_device_aligned_end ____dma_from_device_aligned
> +
>  static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
>  		dma_addr_t *dma_handle, gfp_t gfp)
>  {

