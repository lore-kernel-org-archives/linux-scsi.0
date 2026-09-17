Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECB74E36C3;
	Thu, 17 Sep 2026 17:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666693; cv=none; b=YjQcW9dIL5qRw5faQs+3agv6GnJBlsnQ3GGJ5iP0lDtvjyvaiQQuFU4fpXFqFZQJz/s6vabb9opkJ6l9BCGM0cfZ/Dhmfe157jrtwFjP9/jszjtBPFrRDmKFHTRODLpw9ruaLP8Q0KOz13w66ugFe7k4QE4BOjEB4Wpaa4ctDVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666693; c=relaxed/simple;
	bh=doCNSwjURbmhHg+0frD2eI6LIXLK7q+AfOXJiRsEf+0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AZXRUIoOxFlIkiHpdUhFuSWivW/N8wWEOAiydquikbSOEboX+k4kdTOZMXT6vj09BxxOK6ogfJHJUevddiLjHaHhY5tBwl2Bj5ksszItegQxdtC1M6a+tjelDHNOPjHy28n5nY75Oobc16T/crRYpu8jaXtzP54ubyVtdwHPrZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RcDwMYTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RcDwMYTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145AC1F00893;
	Thu, 17 Sep 2026 17:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666691;
	bh=doCNSwjURbmhHg+0frD2eI6LIXLK7q+AfOXJiRsEf+0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RcDwMYTWjAVjmL5SbqKtX8uLVBnIEyD/7kxdhxieXPHjp/PVkVwphRYDc+U24v+H0
	 BGtDABCZBYibFk3sThJZcZuHBY1inIjSG9+L084I/aALOwXP8H5T6zXmYPOYQ9mjMB
	 QHQop8Wde9DPDWu0+CIULjegrFZZISw3W0QAIfvNdDIYttKTn19gKqNH9rsZ3pFUNr
	 1bDQ0yRHvdjtK+C3KEQjSWlBtd4sbXFx53kTR2OWpBW6OZdQs7Zkzm27CI3MspdIi2
	 HAu/buPLcR+qcZI42vC5hBJPbQUTF1WkIAPIw4K1T9cGUL2fxajdFr+ZNRgoQlkwhi
	 r9XrrJsnn28Dw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 38/40] fuse: dax: do not set VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-38-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-38-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:38:10 +0000
Message-Id: <20260917173811.145AC1F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D38

