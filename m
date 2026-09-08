Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD79B4B4889;
	Tue,  8 Sep 2026 20:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900423; cv=none; b=oA8HKEjAiL8mgZPvrwB3X6deyETz7R8VJoK3L/w8kcaqr3VcpGqEMGdPGTIO3xohSxP8mJwluI4XPGHvH9bQrne5rNcQw/yKTiOG97kvSq8lXVGKj6prGRpN0ZKNVPWKk2EopOEd7tEPL5V3yER79k719UvPDa3FLMKqZY+4c7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900423; c=relaxed/simple;
	bh=JJa1OO12s87ryIs9oCBAxGrrN8+UTcZipnv+AvPk7ww=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EqoI7bvXmB47UCaVhJG0vvcpLMoLMoquls7eZgUsCMCZaE+kln3fK72mwib1RIFB1GHZ3ZmHAQQXgf0IaAYFOUUmSNaZpG9A1Yck6KeEnRrIdlSadTN4GX2a4JRkWmea43NYultJgsiThVP4UIeIWpxe2mFXaCiL7JILBQflAVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UO5F/4p5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UO5F/4p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB971F00A3A;
	Tue,  8 Sep 2026 20:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900422;
	bh=JJa1OO12s87ryIs9oCBAxGrrN8+UTcZipnv+AvPk7ww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UO5F/4p5pGeS17jHBcESniZi08TuamoiBbhahfXjcRybz8fzbMMp4+hfkC+HfGWax
	 B2pqToBd5urLYg1uWB0AjeIBm+Z3djxhVmYWTgEZF2HND7e/JdRGTJ5CRTEcLpK+ZP
	 TqC257GA7lNk8TVPK7nlE/f28pK9BixYiyK5Spf/ld/lXmlPmsPEhR74VqTVLZYfcU
	 0MmMgpxto7/ADrWFVFHDwoYUVZ9GUAiRMsTziy4YyNqGElFuf7SeIzt3ol8sj34A9P
	 QfcHkexS1TRDfVy8t4zAzCF0v0OdJV7TbuJpv1qvRPVnY8voSw3OF4QF8j6io8C9WT
	 3qSdRomLKj4zg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 30/39] mm/vma: introduce vma[_flags]_is_persistent()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-30-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-30-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:47:01 +0000
Message-Id: <20260908204701.9EB971F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Introduce vma[_flags]_is_persistent() for the purposes of identifying
> mappings that are persistent in the sense that bytes to the mapping stay
> there, and bytes read from the mapping are the same unless changed by
> actions taken by userland.
>=20
> Kernel-owned mappings do not fall into this category, as their owner may
> change the contents without the user having initiated it, and nor of cour=
se
> does memory-mapped I/O.
>=20
> We exclude fixed mappings as these are singled out as being unmergeable a=
nd
> so cannot be guaranteed to persist user data.
>=20
> hugetlb mappings are fixed mappings, but their contents are entirely the
> user's, so they are explicitly carved out as persistent, as the MADV_DODU=
MP
> check already does.
>=20
> It excludes droppable mappings, which by their nature are ephemeral.
>=20
> Use this functionality to update the madvise MADV_DODUMP check to test for
> persistence rather than open-coding this.
>=20
> This replaces the VM_SPECIAL check which means it no longer checks for
> VMA_IO_BIT, however this is safe as we have established the invariant that
> only kernel-owned mappings may set VMA_IO_BIT, so we implicitly include
> these.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D30

