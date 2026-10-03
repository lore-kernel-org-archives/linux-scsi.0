Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9603B585F;
	Sat,  3 Oct 2026 17:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050210; cv=none; b=OT6i0awWBM/0KBSacBpxZyb/BBDfYOCbI/aO0vJIy4bN8ZeLhpVlxcKnLX48JO2P75KTNmWDGaO/u5OIP1WLD/wzy9hMfOI8aCzhvcvusHeEXijA7Os0FEEf2WVnyp/qLR7pOoNSsliVGQWZBWr2Wr1G1E0pMYq1tfkaIKbI+WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050210; c=relaxed/simple;
	bh=Qlw/6VopiASWFUc39bJ7XH+NISe/U4KYCR82r/LcIN0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dhyNLkquuOb5YVERNXniaCY1IM2a/1EB2GoVBuCRJl+YQ0MMcWFZnwhSMqIexzTBc3v9n/FucQMM7dFhwYB+LBImy/xg/8fzmZlLbR9GbD/UqgGVOqpFXcvhWkLSZXYnz+T8ktPItoK2rCxMA+cYhOUZdX3WrDSWf5tadxS2P3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DS4qz6P6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DS4qz6P6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BA91F0089F;
	Sat,  3 Oct 2026 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050202;
	bh=Qlw/6VopiASWFUc39bJ7XH+NISe/U4KYCR82r/LcIN0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DS4qz6P6V6hUruZYG+z1kg2IvxXKDdUD+71B2y/D2P5zu9a6w9s4TStWnDhDQW+pj
	 x2uPwUW522e4ua5HOvit62HiYLLJcXjHTPfsQvC5l/ORN556P3wDrSgev6MWS19BSJ
	 DFNE57Z4SsRAehpdpeOnl0rFBb+pHwcpZdqteYogEqeKuGlCv87pT4c+/2A14ltLiJ
	 Byq3mjRn1rArBGA1/OlyODnmkohuZtiNmjme2cA0pqzZC4q/Q9NtRN9Qzm1Fthh0cG
	 QN66PWQsEeqjdUhoVc7VTsl1hdwF1Kff0F1J9ZyIE9+KehylgEuK5onlAZUFt/pJW9
	 k2ZL66B1D6tOg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-13-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-13-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:40 +0000
Message-Id: <20261003175641.52BA91F0089F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set =
to
> one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
> or arena_map_mmap().
>=20
> It is convention in mm to mark mappings whose pages the kernel manages
> itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
> page cache or anonymous memory.
>=20
> The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
> use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and =
so
> marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
> explicitly.
>=20
> However, the exception to this is arena_map_mmap(), which doesn't set the
> flag.
>=20
> This patch corrects this and updates the comment to reflect it.
>=20
> The pages are refcounted and vm_normal_page() finds them regardless of the
> flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
> thus unmergeable). The one effect is that NUMA balancing now skips these
> VMAs, as it already does for the other bpf map mappings, which is the
> reason array_map_mmap() gives for setting the flag.
>=20
> The intent of this patch is to be able to establish the invariant that on=
ly
> PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
> in bpf_map_mmap().
>=20
> Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D13

