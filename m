Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B4D4A49BC;
	Sat,  3 Oct 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050243; cv=none; b=bxT84yM9XtR3zCbxYUg54U37vwLjTWygNii/Zow+neM+Nkvec0+EYybnKffaBa8e630wa9bU41EA5CUW8z0JXEBeeijBF/LVga2/dkboO4Iub1iL+zFig9J80tbjWR2pzETk26xsa+omvWute7vlmbz5uxnwCZZIx0En5Ogg4c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050243; c=relaxed/simple;
	bh=OLY9w2XbsM/wWMx6eotBol6vg2HBNbPhEEMbXMzQS4U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aLf6ljTt6fSKyOqEwhrihs/YjytcfsNcHhXQR6bNL+HRW8YlOH7ia268hQuJflZT0NCwAQkfwXQgrJjTpN8KoZwn1ckp1SqK15sGlSrxTOvWgj0avLj8nJvRP/1Hxq+QAGJH7wXKp4Ej6NNLR2/d3Zd210d3PaZZFCXYV8ZsYBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wi8ouz3E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wi8ouz3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055A21F00A12;
	Sat,  3 Oct 2026 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050241;
	bh=OLY9w2XbsM/wWMx6eotBol6vg2HBNbPhEEMbXMzQS4U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wi8ouz3EtCN19JquLYzSVPRnSL81x9cLC6YPLjla1VMpYfGrr400yMJPBEmIYLiY4
	 szNnj1kNgule0brxfgOm8GZPh706QDCsM1iCie0EWB/ejgx7zSwx5U+Px9J2Z08SQF
	 mEozSx6xUVwBzHp/sP19uUP6yFFTfl/f7kQCfAtlSiSrS5u8Xz9dUT5/NgaakMcULQ
	 mLbQVQVMbViMrQx6uG+9KRDjFwtTQPXenhgkX1sXhObVDSFySCG8w3vBJnckm4/yqX
	 RNr5+isUii4Nu4h8mab+2EpvmJ8S9TgoQ1OSt0WHhbd/0yJzTQThRhIUidd4/RchA/
	 YXWenuorX2wEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 37/38] fuse: dax: do not set VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-37-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-37-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:20 +0000
Message-Id: <20261003175721.055A21F00A12@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
> prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
> relies on it to direct core mm paths.
>=20
> The fuse DAX implementation, added later, copied the old pattern and still
> sets it.
>=20
> Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
> ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
> insert ordinary refcounted pages and so do not require VM_MIXEDMAP.
>=20
> Setting it only serves to mark the mapping as not mm-managed, making fuse
> DAX the sole DAX implementation whose mappings are unmergeable, cannot be
> mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
> MADV_DODUMP.
>=20
> It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX o=
ut
> of its check for mappings not managed by core mm explicitly.
>=20
> There is no reason for fuse DAX to keep on using this flag so drop it.
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D37

