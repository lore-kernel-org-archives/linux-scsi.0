Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537674;
	b=Dzqg7P6LTDxurnNi0myQPU/6sSF2X7xjadzfeoYDpybaxs0352t+Xl8Ug1lNIE4tNuFV
	 cM7x0WF0SJy3BF5FAim/H20BDuH9/sBDEjKsM9XZu7SMxzu+jhc7s8+AWruEi6te4Rwv7
	 kIo1eaAT4svaWCAhNzM4l181ioZBRwNABUiUn7eVHlNq4+fQk4iPdkbx+PSj+GdMvLg7m
	 0134nE1XkViuvkaFpYLp0xwECfIW5hlNRlvTQxtkQDZ0cU2vXAFen3rsXzcf6qQVGksfw
	 O7f2m2jC7FBvOpqrFG0aF6laHiqOaMgMX2zgAphZaT3Yl+ejjpYouny+0xez3J1rdYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537674;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xZiYkBSzpKRR++wI/mT9ivMLlzYNsoGPLNOZ8snLVOw=;
	b=UDe8+vTKOZH/Fon3hQhAhz/H4DEV/lz3cyafrvTTr7uHHYB/WHSiBJc/y+GJeML7VB9Y
	 4KTT/epZsoFZRKz5wbs1cG/5NLyOFVcY7ycFVdCdRceLA6k+CiklRu57O7wqShf3ZPvrL
	 fzLBjnw+xkaLKRLU1igdTtza6l50OUInq5Dg/Vwj/W7fL2S5dCeX6gfwzp0yDWOkOZ/ou
	 ML2OYj9kTt1O0Zzy0MdZ5w2SILdeMNwoNp9xMJE7P0FHcY/N9J9sgLKHv9bsDEk8xtLy6
	 zPATzwyRZoTAlLE5vd71PxhA1PUWB797J6wShHoyCUb+VQfofMvgAbEJhpFxBgQBZ/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2kXsXYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DD6606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2kXsXYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F042A1F000C0;
	Tue, 24 Nov 2026 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537674;
	bh=xZiYkBSzpKRR++wI/mT9ivMLlzYNsoGPLNOZ8snLVOw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l2kXsXYxlNUd8yLSzIA/p4nM6l2j57YItlt5T4EIk6+XsKkh2ssIi9WOuSmH1cAN5
	 kA6yJbpPtg91Z9O5mpyXM8RRWJ+NxPTOfeYHmBxetOnYccrg56XUzZU+4q/4PBvYdQ
	 YRUUUnN+zN3YaHMn0WFklRimIV4tLLL4z0SBCTLuTemSRr3nFkGzjQmAnFFxEHvF0B
	 8xiKyZqvhAZ3pOe4r873FeIj35pZ5rKBELopRA6HYGO62j/vV59Iw3GLwInbKKn7vZ
	 eRbRTTFx5KIS8Ctcu7CFOI91ICdO914zWOkQlwSdspATovLpXcOXCiGYbT4Gctk8hM
	 q0jTF1/8ofZ4w==
Message-ID: <sashiko-outbox-231565@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 05/13] scsi: ibmvfc: fix resource leaks on partial
 queue allocation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261124-ibmvfc-fpin-support-v19-5-2aaffe5fe7d2@linux.ibm.com>
References: <20261124-ibmvfc-fpin-support-v19-0-2aaffe5fe7d2@linux.ibm.com>
 <20261124-ibmvfc-fpin-support-v19-5-2aaffe5fe7d2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 16:27:53 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: ibmvfc: missing Fixes trailer for ibmvfc_alloc_queue()
  event pool leak
--

commit 5a5077e1a8676fb044e914b0ec60aa4bd727eb2d
Author: Dave Marquardt <davemarq@linux.ibm.com>

> scsi: ibmvfc: fix resource leaks on partial queue allocation failure
>
> ibmvfc_alloc_queue() leaks the event pool on both failure paths
> after ibmvfc_init_event_pool() succeeds: neither the
> get_zeroed_page() failure path nor the dma_mapping_error() failure
> path calls ibmvfc_free_event_pool(). No caller compensates, since
> ibmvfc_init_crq() returns immediately on ibmvfc_alloc_queue()
> failure, ibmvfc_alloc_channels() only unwinds previously succeeded
> queues, and ibmvfc_alloc_mem() jumps to a label that does not free
> the failed queue. Add ibmvfc_free_event_pool() calls on both error
> paths in ibmvfc_alloc_queue() to close the leak.
>
> ibmvfc_free_queue() also unconditionally calls dma_unmap_single()
> and free_page(), even if the message page was never allocated. In
> that case msgs.handle and msg_token are both zero/NULL, and calling
> dma_unmap_single() with address 0 is unsafe on many architectures.
> Guard dma_unmap_single() and free_page() together under a
> msgs.handle check.
>
> ibmvfc_alloc_queue() releases everything it allocated when it
> fails, so a queue it failed to allocate must not be passed to
> ibmvfc_free_queue(): ibmvfc_free_event_pool() does not reset the
> pool size or pointers, so the stale values would be used again. No
> caller does this.
>
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>

[Severity: Low]
This fixes the event pool leak introduced when ibmvfc_init_event_pool()
was moved into ibmvfc_alloc_queue().  Should the commit message include:

  Fixes: 003d91a1393d ("scsi: ibmvfc: Init/free event pool during queue all=
ocation/free")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-ibmvfc-fpi=
n-support-v19-0-2aaffe5fe7d2@linux.ibm.com?part=3D5
