Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F7B4432F8;
	Sat,  3 Oct 2026 17:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050239; cv=none; b=CHWz/T9yExz8BUPXNQ5SdWLGHrdlpcvseO/vQVxWxeMjAlAfb7ZiIMeqAmlmIvyVMRY7uFhy/imB596wgbTn+hoB9FlqgU7ibT1KQ85W5NNlbLuVOSpHVtSIYLKqtGmAGr3DJbgEsifhsCQILO2ehJ5+wKmIrTbp+7p6sZMhCXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050239; c=relaxed/simple;
	bh=UUQsrvx8/5TX6+rkKkzjqv5g7+EQwrzRsGJpOkhwMh0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a4fDOJVlRII6OvgLzWaAaiXONXgnk2iGqJ9oflhBH4kwn+pAGn8r+YB+EPHNzgk/gnvADNLd/iYcfYnBIG6Q+otoRNghRU6xgMh1P7TQOW0ddms8S9VuVVy7kDuk2vAM63tLieJwNow5s6y8KltbK6eLLTjXhz4whin+fs+sbUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itBPGsKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itBPGsKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5AD1F008A7;
	Sat,  3 Oct 2026 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050236;
	bh=UUQsrvx8/5TX6+rkKkzjqv5g7+EQwrzRsGJpOkhwMh0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=itBPGsKDC5orPTgI0bU4+blQXNfWnL/Gd/SCL0C7KdjwLdRe4AoIM6uC4N9qPLDsm
	 0tfkYAC77wNg9th+OXZ405eAYu8A2HGDqoLVOuSztP9e5JA0GIXwOZOKWMKJ3WtMya
	 dGYTS85RhkBpKm29e1d89gJp+80NWhVukx6gPzJ5cZB1PenpmZW6jppa57GQgDIJiV
	 8OPe/FdV++eOHR2BHguTN5SIR4gI9NKBZywwgVLs788ef4UZ0LpqO9c0qmdTlLZ9BZ
	 g3NRIQAbiffs2OMj/p2YSps/CZiQjLjdrRfIrBi94wxe8smKt7iqqQHaDDEo7Jczcq
	 Sux2z5iBaIpdw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 17/38] scsi: sg: convert mmap hook to mmap_prepare
 and rework
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-17-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-17-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:15 +0000
Message-Id: <20261003175716.2F5AD1F008A7@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D17

