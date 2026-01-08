Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133F540D715
	for <linux-scsi@vger.kernel.org>; Thu,  8 Jan 2026 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881520; cv=none; b=OcbQzQ5T1nodG0iE50hqsDfUl/u6dI0QE0iNag63ofkgP6BrdZFrZ0b47QEnHwADacPdChNOh4EnBNRy6jHKpgJ4Acpahid5MFZgyigZpAHK9XOfXHXLOa9Yt99uU8g/YELc8hOFzmSXMbVdPdjncrepBnm/dGCCyXCDNYP9I4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881520; c=relaxed/simple;
	bh=AFb8yUemGFVP+E1zn7JOJ8f6bE4z7sRVkT9bi0zm4eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYByD3zuv9UPeBCTV4blt/CUXXdm+OHdOMvTiJUQIxCsn8A+8i7nGCL63dVFAwVKBqSzuiM5m5mqdwJccRnmvGjpXRExR1fn+QFLXDI7WrYs6WZhUN47i2Y1EpGrPgNRzKMAV+q29HYxF9CwUgIP8iyf66PEqjrVpPmFqPKBoNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZYspJI45; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ipTnwXHD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYspJI45";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipTnwXHD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767881517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
	b=ZYspJI45MQXRGPwBNwrGxvfCjkovRKzgFgCIXO04g+MC7fzQ/mRUgXP33W8kcSxODQ03Zc
	WB2RHv3gQjC5gfPZA5S6UL0jbDykQhTo9QlELw/mQbj6iy8JcV9qge1EXlAM8SCPLHQTZG
	buFs+XeR97qOt8QZL5+Gs6q5wP0t790=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-bw5SXsxSNrG-wU2aeBFzaQ-1; Thu, 08 Jan 2026 09:11:56 -0500
X-MC-Unique: bw5SXsxSNrG-wU2aeBFzaQ-1
X-Mimecast-MFC-AGG-ID: bw5SXsxSNrG-wU2aeBFzaQ_1767881515
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-64c7242a456so4681380a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jan 2026 06:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767881515; x=1768486315; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
        b=ipTnwXHD+dLvDSmgaJopVLl/1O8dnyQsR1tZk+lqtAATXWbvS/P0QG+tojhsdu5HPI
         pv5SSJgMhShvO/6FGq1gyrxXpQRtHTmRjq3kjiQi9db2f/u50YyurFdq2eA3tMPFMu83
         7b8j8EaUsH6N949qWInjMDr7NqkFx/UWgc43C0n1jTdBjSsmOFeiF1PCSICFd/n0TZgm
         x6dZC343KryZI6rn/qDuvOHK5pI4LEQYtoBQ5GqsLvA1BeDZ2DYxZE+Og3+3EgLCiSOU
         /aQrIKL82HTc/43aEnyErBjIAbEEsAVicFXAYKgmaOPlK63fvd6vWuHbAo46exB5OpAR
         5ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881515; x=1768486315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
        b=JwW+SKmZL2THAExdDqNxf2Jn0u2Rgkap7NAZ6h4y3cdzxcEczuBMG92ThiVfvr7c6l
         1MVNbQYdexzjBi3pMuE4Gp3G2GBo/pnzbBR8bgmqrOfhwBwfNGV9ujMPCyFR4frT+Tu/
         +4wCgNLYBmqQ+onDXOAbNIDSmpOyLicnZ3N6XXSQbVTH1HH/XKN3Y4JORPPQtRJLSA9Q
         w1od/bl/IEkmhXp4NlchVriva+dkQ27Md+BXVqbwh51DN3jIP5lJboAcGalWlKFW2NYP
         XFfv0bM0Vi0FXgxzj2JbLviqBIbdnKeXbKlnOTFY+gE7pDesBLn5oRCj8+xUk+pcl3Ow
         +aoA==
X-Forwarded-Encrypted: i=1; AJvYcCUI7r9+srmBPvNlqMhs9zUvI9JlnR1z4icTxXq3ju7FLAU5b7Zpl7Ssp3NYFqavxytHwlWFMyhuv/nt@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3de12E7myc4rMH1bdKdFhQezG80FVomSGzZPahisXFyKsFeO7
	pxBrhyWAKnexGKlnAGv1uA/fG5pJOvhtduKdN/jF7VCfqNs1G3Wlue8V7HFR6531Z3qTbMKEJTf
	ER5jmKW4vYnnvEERADDqpoQbVmO2T3nS+o5qVWzTyHHj/p1hqbB9j5i88V3Mtn54=
X-Gm-Gg: AY/fxX7gTXp78b//HvVilzoCepng7DuU15SxM5y+1hJf/EEqAw3zrHAuhJBZrTIZjWk
	Pp1j4tH042SgTVGFCD55q4LPfE8e0bOZ/YayT1Mscp3k0wb7IaYu3FUZZBSzMbQ9t5h7HJlVEAA
	xYPwi7Ni2/p44yw6vELVeIcLZHy8HY/ZwTyNGU/KV3YjecqLoF+CW6STfSKNjbV6tpKUP3VonhX
	/5+B443YRMeHrBEUufQKX3yWYhNEW9EIwol7JdT5Ggn7Zobe/M+TwNUEkD5ZAPH6iyVWQSDKFTd
	JxFB2NC54tqmeW4Kvc37uUL6PWUsldmkSkf90GC4f9ekbF77eu8s5NtSiLwj15Zhd7NRzMng0JR
	UvIbh+r7Zs1SRKsJX
X-Received: by 2002:a05:6402:358c:b0:64d:1bbf:954a with SMTP id 4fb4d7f45d1cf-65097e01237mr6010704a12.15.1767881514767;
        Thu, 08 Jan 2026 06:11:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFH4GSSsuHOuOKzAWjnLjL93ZyftULQdKpADud0o+HUDbYN/JI+jAlKmTdijyyr2Y36a7d4Rw==
X-Received: by 2002:a05:6402:358c:b0:64d:1bbf:954a with SMTP id 4fb4d7f45d1cf-65097e01237mr6010647a12.15.1767881514187;
        Thu, 08 Jan 2026 06:11:54 -0800 (PST)
Received: from sgarzare-redhat ([193.207.223.215])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf65ca0sm7641163a12.24.2026.01.08.06.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:11:53 -0800 (PST)
Date: Thu, 8 Jan 2026 15:11:36 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 13/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <aV-6gniRnZlNvkwc@sgarzare-redhat>
References: <cover.1767601130.git.mst@redhat.com>
 <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>

On Mon, Jan 05, 2026 at 03:23:41AM -0500, Michael S. Tsirkin wrote:
>Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
>last. This eliminates the padding from aligning the struct size on
>ARCH_DMA_MINALIGN.
>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
> net/vmw_vsock/virtio_transport.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index ef983c36cb66..964d25e11858 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -60,9 +60,7 @@ struct virtio_vsock {
> 	 */
> 	struct mutex event_lock;
> 	bool event_run;
>-	__dma_from_device_group_begin();
>-	struct virtio_vsock_event event_list[8];
>-	__dma_from_device_group_end();
>+
> 	u32 guest_cid;
> 	bool seqpacket_allow;
>
>@@ -76,6 +74,10 @@ struct virtio_vsock {
> 	 */
> 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
>+

IIUC we would like to have these fields always on the bottom of this 
struct, so would be better to add a comment here to make sure we will 
not add other fields in the future after this?

Maybe we should also add a comment about the `event_lock` requirement we 
have in the section above.

Thanks,
Stefano

>+	__dma_from_device_group_begin();
>+	struct virtio_vsock_event event_list[8];
>+	__dma_from_device_group_end();
> };
>
> static u32 virtio_transport_get_local_cid(void)
>-- 
>MST
>

