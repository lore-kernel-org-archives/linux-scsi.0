Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D380D4A3D3F;
	Sat,  3 Oct 2026 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050237; cv=none; b=cycnWmSAptO5VUv8SYJlqTfg7ezoxttUDs3Njrt0IcLdd44hxg1XaW2+uGQG6FsUpBDdiQvJub2E12/XyV8IMRFSe4sNp+3ujdfAFIGnfXwP1HcxjqBxa8jof1pvDxR3NwzsVc/KZIsjjm54WdlzKZLOrwhvheSFAfPk9MD2Q/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050237; c=relaxed/simple;
	bh=8QzmomK192UuCjKCJEilSVPRLqRAwu/fnjK2QKAFSCc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=psTd7JDsvBlINWWmQydHRMabwB9vMstiK3qD+iE9amHK/hPMSJrh53fJzikH6zUl3uq+20O/ewalS3hrwMednOUZoOjjUmYpB/YeLTK9hyobY1KbmsknBPsAbrvToQl0K/BhKjTjG9XA3SZpIoeEszmxmhDssNkcD4NiVRQYsDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGGKTcS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGGKTcS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF081F0089B;
	Sat,  3 Oct 2026 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050235;
	bh=8QzmomK192UuCjKCJEilSVPRLqRAwu/fnjK2QKAFSCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GGGKTcS2A1H0M5vag4dzmTqeD7dPp45/Iqo1ZzhwYclmkZB5ViYAGZVS8SRcow/la
	 supYst6SV/SQ5npqOpVOc6iadM6w9M/DtfZXE7y2Fb+LD33uYZeb0cxxObUnVAQXdx
	 0NU7q87aWk7eKHXJV4pROZHVoLbIaBuSXaKypRp4XQ3tyK/DXO7AUflHTpxgbv1FLg
	 c/7VDP5xxW64ECDssSoC9OUuw0Qy/29bieIr72360vayn7cgupqZfakotNULjzemqx
	 Tc0x1aHwa1MyvdOokAwqlABCmUCCtMS5awGXRf/7hszDakWtSOkbwQ4HeVGxDfNXPL
	 JgVb4laSPq36w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 30/38] mm/vma: introduce vma[_flags]_is_mm_backed()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-perf-users@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, kvmarm@lists.linux.dev, bpf@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-30-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-30-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:13 +0000
Message-Id: <20261003175713.DFF081F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
> mappings which are mm-managed and whose contents were placed there by core
> mm's own fault path - rather than a custom ->fault handler - and which co=
re
> mm has not reserved the right to discard.
>=20
> Mappings not managed by core mm do not fall into this category, as they a=
re
> populated by their owner, and nor of course does memory-mapped I/O.
>=20
> We exclude fixed mappings as these have a layout core mm cannot assume
> ordinary fault semantics over.
>=20
> hugetlb mappings are fixed mappings, but core mm owns them entirely, so
> they are explicitly carved out as mm-backed, as the MADV_DODUMP check
> already does.
>=20
> Droppable mappings are excluded as core mm has promised it may discard th=
em
> at any time.
>=20
> Use this functionality to update the madvise MADV_DODUMP check to test for
> this rather than open-coding it.
>=20
> This replaces the VM_SPECIAL check which means it no longer checks for
> VMA_IO_BIT, however this is safe as we have established the invariant that
> mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
> these.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D30

