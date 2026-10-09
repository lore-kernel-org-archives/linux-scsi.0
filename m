Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E736D3ECBE4;
	Fri,  9 Oct 2026 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571499; cv=none; b=gThBHbH4U+Th/gqwpevI+kLY5vmjqOCS702yD4ODmxZmxnYuT634yM7J22Cb3njUdBUPWtgt3AFxBcuQrdlQ8rYc4riGPgaOZ+LJzSRhfGYDtU9EMQQcUQLhz8hLoe02vGajfs0+BU2/FeUXppZXRSdINj9VthOGptCiV29UK9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571499; c=relaxed/simple;
	bh=ocrMeNkMQZu7lUW0ZX/nXGH/6NYNDpKamVvMXgsOpXg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CJ8eA3Vyt6ssKgMVNFST+vu1oEW/Y6c+B3MaQCMGLeEHdHKtZfOn87LmOXSDWpNupSNU3/CuY5KiYq4kj1oTMUnwOwtVmLRAX5mVvXClP0CLugAxAU5LrDhcRbC3gdO1g/SCx4eIyNncQRKs10S3GnA1riBqOt8hRvBtqU4PsWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvNJBZy9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvNJBZy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E99B1F000FF;
	Fri,  9 Oct 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571498;
	bh=ocrMeNkMQZu7lUW0ZX/nXGH/6NYNDpKamVvMXgsOpXg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HvNJBZy9Tsu7oES9CdsfR4f/4C+IE4xqTb5dLbuMSUyzbZsJ/yjMXR+167f3p//XP
	 ob9okM/QutTRXss9bRhSy32e9t+A72Lx1PrRuFf2/GmmRAXiVDVbwzemFvMgRSZxYa
	 mGBdpo12ahOey7dmJZEFs/eqKDPFLTw8kz22QIdmMIpU+qXV5ZLU0U9IUSkRL5i3rL
	 OIqQh4UappTglas5pgF9N8JI7YpuUHe0ZFJNh7EvC7+IM75vMMXflYmgSLcwMErzNk
	 4EiUwDS9kMlOCoyBbclPjMXyO/PYSmG2FK5aCTN1dnk9a11R8DFOwhl0lX7LvS5qgh
	 DL5Mh9PLzrdVQ==
Message-ID: <sashiko-outbox-165968@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 17/38] scsi: sg: convert mmap hook to mmap_prepare
 and rework
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, kvmarm@lists.linux.dev, "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Oliver
 Upton" <oupton@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-17-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-17-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:44:56 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Move from the deprecated mmap hook to the new mmap_prepare hook.
>=20
> We are mapping kernel pages here, so use the discontiguous kernel mapping
> mmap action to do so.
>=20
> Unwind the rather confusing loop and instead map as many pages as we can =
at
> one time.
>=20
> Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
> the pages are populated for the length of the buffer at
> rsv_schp->page_order granularity as compound pages.
>=20
> The discontiguous kernel page mapping logic handles the compound pages for
> us.
>=20
> sfp->mmap_called keeps the buffer stable for us. As before it is never
> cleared, so a failed mmap also leaves it set.
>=20
> We also remove some useless vma, vma->vm_file NULL checks - these will
> always be non-NULL if you reached the mmap hook logic.
>=20
> We retain log output for consistency, but change what's output on page
> mapping to indicate that sg_discontig_get() does the work now.
>=20
> Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
> necessary as we invoke alloc_pages() which gives us refcounted folios that
> are fine for GUP to access (VMA_IO_BIT would prevent that).
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D17

