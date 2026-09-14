Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A5F41167C;
	Mon, 14 Sep 2026 20:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789418825; cv=none; b=JYIbVa+3/OM6LF+KEj4h2szZaGInSNE+kxrUs+3ljA4lu3n5CllCfwEQMkmClhd0e2fxBfiKv8bHHrV3dbkl78d0jN4k4mLjCVAco5UeJ5+CyEEAv/3J1Sfwp0wxi9gE/vMO0EYwphvTHgc0/N4sjOzS+fVbGyQrlgM6buWWkF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789418825; c=relaxed/simple;
	bh=2IJq4xY/bBDFltvhIr2WF5Z6kFLO4/i0wExoi6+Tl+Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BUIAAw1QQRr4Wcjo5Mzr+GSDHCiaEAbjNfnDlIctODYRwtWT0SZC8jj3iybkcJRokQ2wEhsqsS1KTFeHxAL1MQCWs2Cb1iYLaZLIZ/85KWMbkKMoHkOT/AhQvMAQC3rPjlW47OS7DKVWu3y3H6Dm9GyGHJI/altwUoZEBdz1t4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gipMHZ3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gipMHZ3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABB11F00893;
	Mon, 14 Sep 2026 20:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789418823;
	bh=2IJq4xY/bBDFltvhIr2WF5Z6kFLO4/i0wExoi6+Tl+Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gipMHZ3x/T2w9lkfIH4SEGPOxEDLobWgDTqcmNNuJlAAUwkdI1I0Rq4OBuNzmtu2F
	 qA5JW2bSgphbh+ClexEfMPopcLNGbC9H3ULxn59XKtrbVnxIIJFufxVhwjOnN0qXdm
	 6EPxtBvRkBc/MXq/zZtLjNBlOhIvY2PraueKA3s6zwSG1XPgVmblgUYz2qZEC+s9dc
	 b0SCSdCaYNgSmF6uZjlBL0yM3rLSRRxBmNl+1rp7vq97hkcCxGaNXLzEi02zeG3khl
	 MOjsNcYuQ1u119M6Pn/Y2mhisIbnZidMNRRZQuXhmrXZJRx/hxSTXsJa+bCWqKWyst
	 Lxir5AOacPbgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/40] uprobes: remove VM_IO, set VM_MIXEDMAP for
 mapped kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-rdma@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, bpf@vger.kernel.org, selinux@vger.kernel.org, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-22-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-22-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 20:47:02 +0000
Message-Id: <20260914204702.BABB11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.
>=20
> Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
> the appropriate flag to set for those.
>=20
> This provides the semantics required - no VMA merging is permitted, but
> does not prevent GUP.
>=20
> However this has no meaningful impact as these are refcounted and thus can
> be GUPed.
>=20
> A previous commit already prevented __mm_populate() from being invoked on
> XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is =
no
> longer required.
>=20
> Both VMAs set a VMA name, so always_dump_vma() returns true before
> vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
> in core dump behaviour.
>=20
> Change this for both the core xol_add_vma() function and the x86-specific
> get_uprobe_trampoline() function.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D22

