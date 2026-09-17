Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067274F68B8;
	Thu, 17 Sep 2026 17:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666646; cv=none; b=k+MGP6nHgywVDjZy9qMUR6wkyd22MSvn5T9pJgMvak2s4vu2mcJYay10jeTbU1nw3tnWewvQOYqB9qrCLF1XFYfKFHhooElFAG/JikEyq2HTELM60Qtfm85PAc2Z0Ol0/wdx/KDVuKRyeR6/A/RVLQCCm9Y74KyhGKHUtaLfRuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666646; c=relaxed/simple;
	bh=Ni2lk/F+x51pxio27CcLR0ChrZ/liibTbsc9tVaaHHQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l4REy2wJbOL2fe7leE0ZqzozCtU3m59A9IZIcDNcJJo2pMGo6E4IAIrF3Mkb0qAj8eU7pvWJXqdD64Ad1Q2oJ3I2IjcITq38WGQr8f6fWXfQCNCox0nWNu6iYYriCj/VYxY5dkHeonf6ZnOhBeI2dOSkcNs6A0oPooMYU4BYHFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sz1/D6Se; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sz1/D6Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B521F000FF;
	Thu, 17 Sep 2026 17:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666644;
	bh=Ni2lk/F+x51pxio27CcLR0ChrZ/liibTbsc9tVaaHHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sz1/D6Se/JLZwI5eVhF7AC9FSNcWw7o1Cg7PcGUhtbCD2WViptuTWvox6tqQ+ONmg
	 VpILjyXW/7gTOHw5DLMvxhZDsNVf0ACnncnU8ieZI5QLg+5f8UxYu6EGcmzpqBEjxW
	 HUvvXs3eYSVBBWglC6RWsD/iVH56ofSknRitV1DzrTPFkHjQTiXOfvC8ufJC56/ctE
	 R0MW4AkLLZP278Ob9Ca1YWv4iuEXRqChmZyesx4NTgR05jCUcRf6rGuNdJ6QTMkVQz
	 wASCj54fP8cQ6wUoZHAvN5uZlrEaHCsjVbm4x54k+2Wie97p19E0cQx9Kzt9kjTdhf
	 HTHw7iaF43xdg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 33/40] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-33-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-33-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:37:23 +0000
Message-Id: <20260917173724.04B521F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Make it clear what we're blocking in MADV_DOFORK. Previously we simply
> disallowed VM_SPECIAL i.e. kernel-owned mappings, fixed mappings and
> VMA_IO_BIT.
>=20
> Now the invariant is established that only kernel-owned mappings can set
> VMA_IO_BIT, the VMA_IO_BIT check is redundant.
>=20
> The rest is equivalent to testing for a kernel-owned or fixed mapping,
> i.e. exactly the same check as whether the VMA is permitted to be merged.
>=20
> This was established by commit 0b2758f48f22 ("Require (reasonably) normal
> mappings for MADV_DOFORK") containing my hands-down favourite call out of
> all time.
>=20
> Express the same thing differently - if we wouldn't be allowed to merge i=
t,
> then we aren't allowed to manipulate CoW behaviour on fork.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D33

