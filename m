Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03765414A17;
	Mon, 14 Sep 2026 22:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424179; cv=none; b=iYsH8JcqeaRdc7lbtPY0wT85Ix7iiT7NzuSBtHgxPsvnXgcgdQuT1i9dNB1wKDCPTJfwhJVsx1EUcIRDmEbPMwdjmsjKCwrCE7lmE9fubOeNQ9+oiY0ZuE+rGLsyTf5NIg2NlgQH+AocB6TeDioBnA6KY46ia+79v0FUyscuM74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424179; c=relaxed/simple;
	bh=XamPDl9NXlZRtpllZkc5ElLHE++HgOKjnxkf4Fhft6A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NdK07NVseKkQihB1pFnxLuI5sWMm72SoHsqLRYiZunFimO+DiNz5YVfjZp4ZXG8gS63OuxWAmPb09Hea8su4xM2Z2SljLnpYxECJ4y2zCVVGbtMKV++oU0MAtE7fOJAe9rNS5UeUIVX9n8vsxS6rQP1ceBQ91aHjnCSAeSpcBDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvoJgdSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvoJgdSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57F11F000FF;
	Mon, 14 Sep 2026 22:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424177;
	bh=XamPDl9NXlZRtpllZkc5ElLHE++HgOKjnxkf4Fhft6A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CvoJgdSXfrot0Eqzk4UtAnIGExifHja0JllTayBjcyT6eWu8erwjsAt3Rlose/UYB
	 lyNGDm7U1L1NDxiEyu2xM0YoCTVS6Qryy6hNRSfBBQvMfXE9fXop5P5XnOwIQIqnSB
	 huWU82Zvf/cK08nAFvbPSjQWQ5ZtZl77bwkv4rlahqbFCxPqsWZQUTrhK0HIjwUbaN
	 DcfgooTbIXdNK6cQJXY+7a4ghthtLVTa2tNsz7wL+ojGoSpu1zXllT3bhNiav2tqyC
	 /Q5cBOdIkSQ5hnHRVizPKvFMYRawtoBHh1qFPOvyUcmA/aUUxCz4Lwrs9ldiRq6G0j
	 s+15ujKGfQXzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 32/40] mm/uffd: use predicates for userfaultfd checks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, bpf@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, linux-s390@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-32-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-32-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:16:16 +0000
Message-Id: <20260914221616.D57F11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than directly checking VMA flags, use the newly introduced
> vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
> assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
>=20
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
>=20
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
>=20
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that only kernel-owned mappings may set
> VMA_IO_BIT so the check is now redundant.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D32

