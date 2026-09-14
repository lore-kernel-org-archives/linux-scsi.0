Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153EA37187E;
	Mon, 14 Sep 2026 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425035; cv=none; b=dUJX/mFcUCVlQqgCBnWO40pCCEXsYW8gi9OGdRa+s6wsXj2OzkK1o9R1O/SDeT1powAfsVRmcZAqrgrvo/JoOXWcIfl/gkwD6E7MxNFNfHlJttv89bx56NBq8JdrveOp8jqSKzk+aNkGkwDpXqxM8t8e+jr+4SWuylyfK/OEUWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425035; c=relaxed/simple;
	bh=/2uj6gnbrcSTZt6y2pavEHXKfeVvI+FO+GT7mt4Ifo0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tkZHoEnVrEBZilrDl6c7knKxsJDU2RXzyLhhp9yGsyTwGivd5kKvLdZsWU5JUWNaLfF2d5WRPDiAaWRqujExCBu2wh8X1HGXd2hO4KuZ+BF/6Bs7FH3/Ab4PACROkX35B1EI0sVdcq7y+pL7pyitDlGjbm3lo/GbSEGIb3ANlKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEmd8frv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEmd8frv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89121F000FF;
	Mon, 14 Sep 2026 22:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789425033;
	bh=/2uj6gnbrcSTZt6y2pavEHXKfeVvI+FO+GT7mt4Ifo0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TEmd8frvnqICeRRAik6YyE2DVeo56DqG3doRxv/mwxC6c0AmpGFhGEenLtDOBO1CJ
	 MEFclMLilOJ0Lj4pTi3uZ6Q71BlXF9aAfxZcUoBd/QckMqbJnwAPY+NcxNEL++uAdv
	 tSBHxO+1oOeR632sci41gfzj2TVxG9PSC3+Bzi318XTVljokDFcm87Dy1wpcHOT032
	 /hUuk97WpfliVuvPv0Fgq+VmBi97JxAGEn7YqDmjnLONaYWRkZtcZpPasKTBWYr2bd
	 WgCNRWm6fSi2zio1gYyvTpxYKsPZPf9fIDjv5O79yJGmzqGk5MVJ2NLDBDToKzKqtq
	 jule2Ckvkvdlg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 38/40] fuse: dax: do not set VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, selinux@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-38-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-38-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:30:32 +0000
Message-Id: <20260914223032.E89121F000FF@smtp.kernel.org>
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
> Setting it only serves to mark the mapping as kernel-owned, making fuse D=
AX
> the sole DAX implementation whose mappings are unmergeable, cannot be
> mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
> MADV_DODUMP.
>=20
> It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX o=
ut
> of its kernel-owned check explicitly.
>=20
> There is no reason for fuse DAX to keep on using this flag so drop it.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D38

