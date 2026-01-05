Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB963164C1
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 04:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767589036; cv=none; b=j0L3aeUoO3HbA98VlahAxWWHXXJpprcgpmRPyCu+mUl12+JoBKYEeM0e7xAeqaQ+AVBmwNPSpMdERlRF4k/8WRdRCov/ohfJi3ZyXtrUYeXJov+HxJOkdM084bAnCx1VD6W6xDxAdL4kX2r9eDYgH3COkvOQqmtGn4sOSXNRIdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767589036; c=relaxed/simple;
	bh=wdM/b8hJbUaslNLfaUyaSG8t8yHTFzri8J0kMFatf2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVsJ/vNnbigmT2d03o67E8nIIT2jYh/TP0UaCI1FslmKGrpHLabVt+PA1qQpqjv9UmK9eez8uUPjuew/MYb0P2Y2UbSsDrLOSJ0GAlZfBzwUb2KBzq7N47a/akdEozEWzEnwWHjNJcjV9t6TtA63EUmOqJ6KlcChHuc7pRrNzxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ho85gyha; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ho85gyha"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34c2f52585fso12303347a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jan 2026 20:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767589034; x=1768193834; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EOEgCzmZP0GTJHcnce/bEe96Bif2a5t1CJ7MWxViYzU=;
        b=ho85gyhaKzhQd2LkobbDGyUs+P/owvm/KOpiZS4dO+Gf4YuFWvgFamob9qdCJ9r9lk
         CLr9/RyFtHqQFUBotNoAM7KhHAtZt1Jp5d0KrfTfEbwagr6SxMdsx/4fE0BSAkcxMDYW
         hBxIWUZzrdi1VxRIajuMMCUWM94J/ABCw0OqR1S9Q7KJQTpTvaIEnHNlkPc5J/4jESGd
         XTIkIW6zDUqzcVTAuqoCRGwL3BR2rGk9MaM3FmQJSNYeqluqV2cf553LNAaO+Ru5IIr6
         vpnPaBULT5dfb6ydqqvBTOTjU7RSO1ix7RqULQUiOx2UaSolPasj3CB9WpJAXHp8n2jn
         ZWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767589034; x=1768193834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EOEgCzmZP0GTJHcnce/bEe96Bif2a5t1CJ7MWxViYzU=;
        b=RISHB2QYbzq91skRyxO0/C7ctQ9wyNLzU7rSoBuLAJWxAQTtgSywCbdSPlXyR5iNZ0
         tn6rSF1G+NkfeT0b0IAnP50sfK3r3Er+TlHwE9+cfGDcXcLr5arWvZXPf2V0wIFVqyjE
         3101v2mWO8QHuNmU4LL0iY8Fy9JA0sl3Z626TyWF/+DNyNqtqKepezUy6bqfwD++xdY3
         mLGD7z72a6DmGwiHsTW5j2PqFyP8An2UKaW4x9xoYu3LRqwRL2/diDRrCZ86ezIRFbLl
         Xguab0UuSGcQE+SRk/js56qXebHMtiX+4bje3jbs8mWlxIUHEVh3MgerkcEQBEB8Alin
         ubEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe5spgnzaddEuhFf3G/UpND5MvR6ZAxQ3dXQAGYRwC59tvAzH1g67huC+SQhtYJkqjqPBmQQEY7bsY@vger.kernel.org
X-Gm-Message-State: AOJu0YzhR2Scosb/A4M4O/6Snd7Ddo8x0foT9piD2tIOMlNEjC/zuiUE
	JAdM28lozWeWErYAOLGdtZ1nVMTPhQK5cgvl6CMy3uVT1gF0+FLyMmPjRbgWsmVXRHc=
X-Gm-Gg: AY/fxX5+LmoXMrdverPI9gGttXhftRQx75cLwuk5VkMxhZXdiamp2yX7rgCf+cUEEDe
	Oqzn4OkLhoI9IIz7fjNOXiQH5e3kJQjLZfWehKtGho0EPtqK9nsSzqRGTEydLulBOVkSU1wbihp
	1LdlPeCbxWyszMHwWmd49msi30ll1bn885zb8/uTtoMHWEciZ5lJt5j0U8Auhf+CrMTTzLalRiX
	00z6WUkxjbITMj91UExFQ/vq2L2zH5LBi1SX2gvt2NsgrPFq8l0o+XGxXXUkE7lsxu2GLQ7uXlJ
	E8kqushpvVYJws7HHEawT+hdjOm92b9vIlMxHL7UM4D2lEAZRwv/rZrKg6Tm9CA9uF9X7SnGHfd
	GtcsHsKyZcV7A/GPegkyDTAC9nUcNlPll50yDjMYM2wo4bCuw9UC6OEP2PJtNeTFKrQjvy3JXm8
	n25CIvFWUPnXYoTw4h4KXUZA==
X-Google-Smtp-Source: AGHT+IECK/LcBFPZYYyRh4cCx6nIWU2Vivu4V4Wo0++VXRb6DotO+ATVsJPLekWH+2yfoIoKe3qHow==
X-Received: by 2002:a17:90b:278d:b0:32e:3c57:8a9e with SMTP id 98e67ed59e1d1-34e921f0439mr39742351a91.35.1767589033897;
        Sun, 04 Jan 2026 20:57:13 -0800 (PST)
Received: from localhost ([122.172.80.63])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f476ec31dsm4899585a91.3.2026.01.04.20.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 20:57:13 -0800 (PST)
Date: Mon, 5 Jan 2026 10:27:11 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, 
	"Enrico Weigelt, metux IT consult" <info@metux.net>, Viresh Kumar <vireshk@kernel.org>, 
	Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	linux-gpio@vger.kernel.org
Subject: Re: [PATCH RFC 15/13] gpio: virtio: reorder fields to reduce struct
 padding
Message-ID: <w6to6itartzrxgapaj6dys2q3yqqoz3zetpb5bejnjb4heof2c@jkhmal3chyn2>
References: <cover.1767089672.git.mst@redhat.com>
 <55e9351282f530e2302e11497c6339c4a2e74471.1767112757.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55e9351282f530e2302e11497c6339c4a2e74471.1767112757.git.mst@redhat.com>

On 30-12-25, 11:40, Michael S. Tsirkin wrote:
> Reorder struct virtio_gpio_line fields to place the DMA buffers (req/res)
> last. This eliminates the need for __dma_from_device_aligned_end padding
> after the DMA buffer, since struct tail padding naturally protects it,
> making the struct a bit smaller.
> 
> Size reduction estimation when ARCH_DMA_MINALIGN=128:
> - request is 8 bytes
> - response is 2 bytes
> - removing _end saves up to 128-6=122 bytes padding to align rxlen field
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/gpio/gpio-virtio.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
