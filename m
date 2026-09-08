Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA175353A77;
	Tue,  8 Sep 2026 20:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900440; cv=none; b=BtF/10RZW+aEwg/9s0wXfy5OW/Yn9pXo9qIxr7qWEbDFMeJAwTG7h5yKl8jbl4EcawNhDhNSK5/zyuqs4Kwt8dNPzOMwpl9GMBH24zynAuy8GqHEEqnyo1C8zrxsZZnm3rozz31RZTSNhTry1wUzkiUnED6AtDjXcW+4ctSwPsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900440; c=relaxed/simple;
	bh=cUwKFWB7J3sVQVZePIjXLYJE/gtbWNYr1ZPaYna5+6s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cw3OHLQgMKOrHXS7lnmGs81vg4FvKJCXXiU0PkfAoFDQ5im2wHWTr5D9gskMk/F2HPkBAWW2YSGc1tYtMhfe54MM8jlCDkm3HrAHjGhVk3aICN4UVh3eoafS7taTz8LBC0TJGyF3/MxHCmDXD4Jriy9Ea+7CWJu1CVOkZVu8rDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VnasFriX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnasFriX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32661F00AC4;
	Tue,  8 Sep 2026 20:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900438;
	bh=cUwKFWB7J3sVQVZePIjXLYJE/gtbWNYr1ZPaYna5+6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VnasFriXnrYYiPlwsRTiW3y0gbXc/WyBB/s7qhkOnIb7cIVHfV1pFgMzjimujLdGp
	 wkgPpaP/EhP1jy0U2rIc9cwMYbL2NtAOc51B32c3Sy01iw2l2VMewNGGu68iKz6iMd
	 e5JNV5RzPJqcSIEM0o8F6U33D68fRNoA6jBMBr7QatpiqEHjbDqW+hBAk11Yer/RGD
	 9Ghx2k7r3mBxtmYPjC4EexB01hhjOPE0Zu4pkJY26OOx+XFY8hrKiQ8+JRJgClhKgn
	 fr7QSOEuH4fUAIRk8LjKL5UD3gpItknPsPY/CYLoZvnmP0BmrsLtdVquK56pvT3J8L
	 GEe2I5E2jHFuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 35/39] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, dri-devel@lists.freedesktop.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-35-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-35-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:47:17 +0000
Message-Id: <20260908204717.F32661F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now we have the expressive vma_is_kernel_owned() and vma_is_fixed_mapping=
()
> predicates, use them to determine whether to proceed with migration. This
> drops the VMA_IO_BIT test, which is safe as only kernel-owned mappings may
> set it.
>=20
> hugetlb mappings remain excluded, as they are fixed mappings.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D35

