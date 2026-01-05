Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA0718DB1E
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 09:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606725; cv=none; b=tr1eqTbE/iKx0iZvCe9dE96CIM3VZJrnUkqXKJfdsCeqjdW2/N5PTU9iuhs35NpxeN6XSONUQo55b6BcavMZ7mVaqLCiwceeFUqLO1jt+PWlfCa4OvXMNCVLeVleWl/Q0UDFjLOe0DSe4VMFLTtVuT/1tf2FmbB/KYcw0f2bZrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606725; c=relaxed/simple;
	bh=5ejwvdViHGpZahmzeANBNrpoCx269JspGOeia0IssR8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fqe3G4rlfwOWccAJn/nSEP1A7opR67hTbV9q9nLiIbV1neMFVQAjh8cXN7mEsQiXSLaQap+h0kQKdLKsSzw8YLqBSo5CJmj/IvARtSK1czUcq66rf1FzvmFFy+AUUV+4mUFjtDX5OqtRohaSs5wMwdVGx1Z10uGNmcb5qoPwwY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U6x72nMH; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U6x72nMH"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-430f6ab1f67so693119f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 01:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606721; x=1768211521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txMxKLJCIQFzStXgaX6zCY9uCsyn60vWSct+HXcfqZM=;
        b=U6x72nMHxpmbQRXs1gnsE0GzwU9BM8OMC8fDOUEuszh/7vfjE3AvoxufBx+ZjziY55
         j9XpiczMVZ2WuGt6gdThIsTQXQ4wJFmMRUuoK1Cd3WyYjsJK/oC6+Z3J4LosaJDZw9L0
         WK7R9vTUx8GashsEauSiZc27QN3PZPeKtbTjQTejebn2GdPST/MM2eS8CEtjk/VZ0BJe
         lAC5Q5bGVIZQ8YyAXXcu/d9ChWPDfUSWxCRTGDfGpmkRA9eYFooxD/yM76hPB3pEAzjQ
         JbSrEg6nhtP08npXldyRH8jEiJwwljOBkglCGAZ+2ihUdiCfnkYpre6UjJl+XUsvU/us
         a0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606721; x=1768211521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=txMxKLJCIQFzStXgaX6zCY9uCsyn60vWSct+HXcfqZM=;
        b=V592O2GLDpU1kcxz4Jfm4mSmK6pJalNHDlyKZ6Ap8lBsl2iFqbyNZRaHr+vVgA5J9W
         n6o5hewUhUs3PKA8eaTiJoOy3a/qxzZG45BAj3J5adHY+wxrMOlOVWlugiyFKaWYy1vX
         cAezheTIeI4VmgBEdfqSBcf/n2JWFdJQPMSOmQf+MelpJ7fCwJHh2DGPjqarTo9czhBj
         N8DYbYbFFC/q1rxv9h6Antwo2UDTumh2yPSchQT2gEUizGKJiWLHYff4noM+Vcp/kZPi
         atfXJBDHPXclgZifGk3SlafSnRgbaIwO1RIOI0cnMXfeagJmf/J6YH5gcGPOFwKNQa+5
         63fQ==
X-Forwarded-Encrypted: i=1; AJvYcCViBBskL8Rxkw9nXJ8GVg73u8wc9Lyqe8nTrUKu1qoXeZe/MIqIZGXjWWk4DydXwsNAyuQoQoILA08Y@vger.kernel.org
X-Gm-Message-State: AOJu0YwdDAupzrqFxVhDQ8Yvek/s+6DTWqgtoWlfG5hjKl54X0dpBRba
	gWs2unxMyvOGvb03Sh0LCU53ROSJvtsnwZAteEZXB1H2qBgKall0geSNkWuC2Phhyao=
X-Gm-Gg: AY/fxX51PuTlZFo3h4M0pwwVAu0O0/IzkCLSNfDNX/teS74p6mz8fWJRMcOiBjX8YOo
	uYzxeRkorMKz8gaB/LkEmSRKgWAV7alkYwnl62gyRoTLYtTa7O1a4k6Ih9OIxwHGBzllx2FOxNd
	jtvWbP8DL6aTT8iIU+Kd2XQYhfwwhZH+0zr6Rk3fo+7AwOufaYFDl7otxSks/fxOB68ZG98ldeG
	Sw+YkyvPNLJn6sm3SNe/0zptjmqKyG0UaGQKIgIyIozxMsOUyhC+wVIUs+3AnYZXOoPcwdAC35k
	xxqTGHVdNWPPjlzDppzfVVVUNq5MLvRMNKL+x4COaKZsAlUJ982Bl0nTzV4KgFtznBsVFf/zjBA
	MJ3a8tlUlRkI/JbnSYSg8eeWKuO1NtNbnb0rd4Ke7phTTze6Epk/4CoJhjza1jzxEdkrXyC5BKL
	xbnqdKT6AfIFUkfMxNJ/frNgOF2WYa92sMy7oi70Da1+9T/wBjHzKVmThcxcwDsQH/p10OatUij
	HvY
X-Google-Smtp-Source: AGHT+IG/wqgOkqwXrB1rsCOv37yZ5+KfBZKuhJz5pDuTeJ4oXS1iaQsQoWFexgrkxGoC7pycuuDd5g==
X-Received: by 2002:a05:6000:2305:b0:429:cf2b:cb0a with SMTP id ffacd0b85a97d-4324e4bf220mr35541794f8f.2.1767606721058;
        Mon, 05 Jan 2026 01:52:01 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4327778e27bsm66263511f8f.12.2026.01.05.01.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:52:00 -0800 (PST)
Date: Mon, 5 Jan 2026 10:51:58 +0100
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
Subject: Re: [PATCH v2 04/15] docs: dma-api: document
 DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <20260105105158.248b4dd2@mordecai>
In-Reply-To: <0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:23:05 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Document DMA_ATTR_CPU_CACHE_CLEAN as implemented in the
> previous patch.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

LGTM. I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

> ---
>  Documentation/core-api/dma-attributes.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
> index 0bdc2be65e57..1d7bfad73b1c 100644
> --- a/Documentation/core-api/dma-attributes.rst
> +++ b/Documentation/core-api/dma-attributes.rst
> @@ -148,3 +148,12 @@ DMA_ATTR_MMIO is appropriate.
>  For architectures that require cache flushing for DMA coherence
>  DMA_ATTR_MMIO will not perform any cache flushing. The address
>  provided must never be mapped cacheable into the CPU.
> +
> +DMA_ATTR_CPU_CACHE_CLEAN
> +------------------------
> +
> +This attribute indicates the CPU will not dirty any cacheline overlapping this
> +DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
> +multiple small buffers to safely share a cacheline without risk of data
> +corruption, suppressing DMA debug warnings about overlapping mappings.
> +All mappings sharing a cacheline should have this attribute.

