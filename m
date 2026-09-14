Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739773B42CD;
	Mon, 14 Sep 2026 19:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789414245; cv=none; b=WNNqeMRL8MtdVJgZgPD46AIUtb8dAEBOx7Y8jiW3m8hZ8cI6RGj/A+3w/NSxx+1jBEGNli8V0fJM/qWr19eyLtokqTe2p3bp1X8UAWZ13HoEndYLXsd3Kt47qKXxGn/J7IFKZYAL1dTAZV3C8KQK4pp2PMdvhhXU0zmNpBa4yFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789414245; c=relaxed/simple;
	bh=RYNo57I33B8B6G5soVxuM2FDSfkKyXuqNa0URMDrOrw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rxXzi2QjcAhOXowb7R1ZXC7V3uUYjAEO/SQ/gZaIjkXxDVeHaHrMmfrBxRmgUoh6YCrA/QqtiE0cb4M94W74QzlVhxjg5MHNngOV0WkjagHhItKJ2M5jE8UwxzrRShcsCa7G9x6rwRS62Y2pswA/d5sG6AEe1xo6kMnpTWgMCI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocgFENtc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocgFENtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881811F000FF;
	Mon, 14 Sep 2026 19:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789414239;
	bh=RYNo57I33B8B6G5soVxuM2FDSfkKyXuqNa0URMDrOrw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ocgFENtctck8/1LbDx7qCHTjPJ8FC73vxB9khKkNOtsqgHkgvq3Mml61t65Up4Zi7
	 wXU051uwgpTe1OMCEuXBN6NBnRmtUkoyqA2YiMgo+BGph9D9iGwMzglpKhNwF89yzj
	 2jjomdD5T1OSV/hykxQ6mTf67G2GskZn9TQUXTjK0PH6/qmlhsuj3iWx05fzHeYeu3
	 OauKBH+R04LfMgpon0PDXpkJmrfYsHUjfUt4IAjHJMnXJ5FJTr9pzSAe61EGjW+zD9
	 XdEs5riJHkjHYzFBDjrb1E9BfuVkeDdJzD1qi8T3RZJDOtOi+uVUFo9VH+B3dw8sTB
	 zodEj/VSqMUfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/40] scsi: sg: convert mmap hook to mmap_prepare
 and rework
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-18-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-18-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 19:30:38 +0000
Message-Id: <20260914193038.881811F000FF@smtp.kernel.org>
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
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D18

