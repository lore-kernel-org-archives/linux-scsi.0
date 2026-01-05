Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D859832F745
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 09:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606050; cv=none; b=cz5qFyAixBuu6I+fz29x2fmAR1YxNo+a2EK76W/dEdhzbvxtH8yI7elJo/TpRCpQS3NSUgvg62MudZgOo/3rZ709TFo2G/FMwpubKMoC09T5avygYqtvNXVpo7ldHYJHgJu3bFMCRBeXDDcZjZo6gUT2O9gy/kuYHs9XGn15ZCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606050; c=relaxed/simple;
	bh=kfKJrQ5a7Po2zi22PzxrbpGrQhRcJMv+xYYFiP1AGz8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uizENka6VUeCM5k1WZg9acYZi0LjRyUC/p7eaqWAHA2zpIf0GEfwFxfU8wSowut7u6MU2kbMduYRqjHzhRfhfzyYsIPLPcEl5YotVJTFgOVym7HpZEDKarNd/Z/OfH6bkXk0w8AHlAOE3Ds+M3w3m3ELp7KIoVPD/wj/UJvoR+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bqTttIPN; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bqTttIPN"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-430f3273b92so651800f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 01:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606040; x=1768210840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uoPF4qbo+ysXILWF9RMN1mDoAoivYGl4rzNQocqtbj4=;
        b=bqTttIPNXYA02SvzTJN+Iq2teAV4gvhztpFmGuTDYNQmZSW73vvAB1E9iAMwQAdG95
         +2dN6IzaMbz96nWQwBsJuSmXZEKRAZW6cGZNlG5prU3nO/SaQLFCAsLrDDY1ehMxp5h+
         z/AMR8rEXiTZLYVksNz1E4ouEDHzfO9p17we+pJqDgK2Jn5N4hh0imjGEBnl2wqDQDOd
         ORs5/0peeGMBqvb1bzqjT8PY/f+CUXiWQJUT/jALouTFuJNYCGLZ7rZL25+yY1KxBbAy
         JlS6gdFy47ebCoiUqTo0jN3T9SpiOTqtc50xJix+6jvOH+Q0OFRVVePn2z61tJQF8SnP
         2p/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606040; x=1768210840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uoPF4qbo+ysXILWF9RMN1mDoAoivYGl4rzNQocqtbj4=;
        b=c4siOlYA/pol5cPMIoj9F9O5Gq4GF2gUPqWmSxhp4/+KU8mJh4AymGUz/rxovYLt+e
         lTVaClLg6pap256+2lT61DTtb02FdEd8rZrBUqi6sGVkK+/lXxyLlAae2EZeC4VCp91t
         +I9JRNVxMal2DRvOHL7D4pLJUt2WArt1HgqskEGRRBo3KEOUcJUm2d7St9NEOex05J/a
         BycTFGoP7HidksPR3ZuWc8e1C0aWHzE5qqSGTE/AeZ7IS8tIYuAEOOQQ+5FYSkbH7l5d
         3Tu3+cube9ZjUn68HkMVxsO/yWICRe0r/gy4MYT6Lxvx4fVBs9WOOLmyxRmhKc7Ok1nj
         XrYA==
X-Forwarded-Encrypted: i=1; AJvYcCXlffpL4z2h0yh/9CB03BXvx2gN0VL87+OVCueswxJ+hHHf1OA9g+V3Pz3RyXIvGuqJ/yj2CyD0JiiB@vger.kernel.org
X-Gm-Message-State: AOJu0YzdyRY8n4NlxJS4uKLpeIY9TmTf7tXRpxFurIL2kqrky0GGkGUS
	kzJn5VnZNe1Vijp7ZPtgeNCcCOGf32qE/X8nr/G9XaVVy0SF9xYxwiShiX4RchiCpbk=
X-Gm-Gg: AY/fxX5S3ykJT6SpDXyKz9DMgMqDRSFrOoZX5Q++qPq/EmewKrZWubTT70Fz3v5FZh0
	Ia3y5S9aMtpB/dNmuTIN1rHfFSR0rwR8PKdo4mykr7yqCpJ3rbF/wUYAeYELgut03h66i20zLIi
	BJljIkVfpM06AAJGdpphk+1+SrsNposrmYi1PF5GfMZ3aeuNYLxLpPaKc17kFBdqWC7PfvgmQTb
	ZiTsTqPfg0bi0wvH65AdkOSLFoDpNkNrBcBisKNZl9JdfdggxlrG5lLXydmFNq7hPIdSLl5Q0xx
	0/IUaDEMDp6scwow5aodPLb+SiTxMuOSkJ4H1h8KTwRU5Pz8yBaHEUBTsp/oRYPzn53Utw1fXNk
	7dSxeXfBTvIMgnkJETSZczG2IzfiB2LT44RulWASELclcvmWKTiW6wsgvSQF+38vJ7PvbL/tMN4
	TuozE0z+PjlW6BPiZyBAMaSzbLbGKbBP8vY53flzBPppBbpTHgIwfTHJRJv/1HypmXSUWf7GGxi
	t1Z6G3/b6yX3NU=
X-Google-Smtp-Source: AGHT+IH9uJ6jLlQ3sMbfjfqB2tBZwtUo3Z4YZNjyI98ICTrDJSXZI/68FFDolBTS/hTy3IR7RjNHZw==
X-Received: by 2002:a05:6000:1841:b0:432:84fc:46bb with SMTP id ffacd0b85a97d-43284fc4782mr21485079f8f.6.1767606040029;
        Mon, 05 Jan 2026 01:40:40 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324e9ba877sm100563291f8f.0.2026.01.05.01.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:40:39 -0800 (PST)
Date: Mon, 5 Jan 2026 10:40:36 +0100
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
Subject: Re: [PATCH v2 01/15] dma-mapping: add
 __dma_from_device_group_begin()/end()
Message-ID: <20260105104036.09a77f13@mordecai>
In-Reply-To: <19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:22:54 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> When a structure contains a buffer that DMA writes to alongside fields
> that the CPU writes to, cache line sharing between the DMA buffer and
> CPU-written fields can cause data corruption on non-cache-coherent
> platforms.
> 
> Add __dma_from_device_group_begin()/end() annotations to ensure proper
> alignment to prevent this:
> 
> struct my_device {
> 	spinlock_t lock1;
> 	__dma_from_device_group_begin();
> 	char dma_buffer1[16];
> 	char dma_buffer2[16];
> 	__dma_from_device_group_end();
> 	spinlock_t lock2;
> };
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

LGTM. I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

> ---
>  include/linux/dma-mapping.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index aa36a0d1d9df..29ad2ce700f0 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -7,6 +7,7 @@
>  #include <linux/dma-direction.h>
>  #include <linux/scatterlist.h>
>  #include <linux/bug.h>
> +#include <linux/cache.h>
>  
>  /**
>   * List of possible attributes associated with a DMA mapping. The semantics
> @@ -703,6 +704,18 @@ static inline int dma_get_cache_alignment(void)
>  }
>  #endif
>  
> +#ifdef ARCH_HAS_DMA_MINALIGN
> +#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
> +#else
> +#define ____dma_from_device_aligned
> +#endif
> +/* Mark start of DMA buffer */
> +#define __dma_from_device_group_begin(GROUP)			\
> +	__cacheline_group_begin(GROUP) ____dma_from_device_aligned
> +/* Mark end of DMA buffer */
> +#define __dma_from_device_group_end(GROUP)			\
> +	__cacheline_group_end(GROUP) ____dma_from_device_aligned
> +
>  static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
>  		dma_addr_t *dma_handle, gfp_t gfp)
>  {

