Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933863B71A5;
	Tue,  8 Sep 2026 20:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900002; cv=none; b=qiNtdMj5QHNbFadEoOVBKrfFSW3vn4R/+bj6YB+oSruJ6u75BbWoompz2nxXv30BqtlSLoy6/b72xNjSG284xiirtteG0uHLYDF1GwIEkxvTEL5qGsGv4/iUNm6Je3OSDgptAqBQkd/kvthDiCHZb3Jf0WmDgb18g04WfNBKsEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900002; c=relaxed/simple;
	bh=BLo5ftxyMmRHchqVi3/Y51Rgk7jYxcrNx1zJS4iGtno=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VbeDk5PSc4xWGbdMxhEV3NqsnzZbWowpy+L6MMRumlRbjo3Ci8wEzQM/jUTjuZXv7iS4n5ZxMfUk0SSB6qyz+9lkc5scbiRThQWFCB55yqfjRVxTmwbHcA8Tay41OLjpQpb1mKzvadzJY2xDosPcc8X9PGfHSg/PNkG+hUNIfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jW484Q3r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jW484Q3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670501F00A3A;
	Tue,  8 Sep 2026 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900001;
	bh=nZP0chXgSajYLY4pSNJKUrrR2eFjUEXUiEpF5faqrsQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jW484Q3rycw9v9F9BMLOpquDZkZu6kl73ZR7lNSci4TkpoOHVMILOrdNeF6iPgO+/
	 ygt2Qxklp8ineSkoZgkjSL/HQPIGag+ZzXyGPhlPAd4RpyFoGoqNdlaDL8U4rU7Ws8
	 iwMPa2pEo7rjN9mIBaldDSHBgJ9dBdhnBUnKz/fa3z6P/7aj+fYNPHHaDJ5slu22qn
	 aEInbDCnhgbnVS/tkDslxJCYqUTE9YTNAadeez1w3/QWs68jq1kyqD2sSp+YfNQB7f
	 0orwBFX6fMVDXzpop+leJ/RFl3wgRqTfGjanOJiB3yBRl47IAKKOH+fKEO7Da1RWMl
	 p0xlh+wlAkckw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 28/39] mm: drop some redundant checks around hugetlb
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, bpf@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-28-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-28-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:39:59 +0000
Message-Id: <20260908204000.670501F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Adjust code which inadvertently perform redundant checks on hugetlb VMAs
> and clean them up:
>=20
> * hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
>   suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
>   the series, once VMA_SPECIAL_FLAGS is removed.)
>=20
> * hugetlb VMAs unconditionally set vma->vm_ops, so they are never
>   anonymous.
>=20
> * hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundan=
t.
>=20
> While we're here also drop a VM_BUG_ON() which the simplified check above
> makes unreachable, and use the new VMA flag API.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D28

