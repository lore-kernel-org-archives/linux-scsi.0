Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEC62DCF6C;
	Tue,  8 Sep 2026 20:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900655; cv=none; b=mUpqwa1uwxH6Dj8nTFp6b72I1kopSdHkTBIt8qg1noHJAG4DhOs8LE87d2tU7vk96C+gj3e3W35Hd/FFLHwm0u5TCatlAHCrg8XR+Y9QPfM4Z4mUfQUaF5fweA6xWqupo3GbcKKPGTqCA0i+CNvz696CcSpfyT59td+8Wg2c008=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900655; c=relaxed/simple;
	bh=vD8pyvJH9zExt6WnCQIxdMdMPT7fIPfl/Tt6ZaSa2io=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ESuy31WMHPxkUE0umweR44S0PdT2pqtcbqC1HHisvbdeOiqniFx5aQM0qbUCCzBZ383XvSXdq9ikQcSDgxDh3PX8BbDZF9ilxe2RFQzS6Z8kQfhepagFHTrgGhRXDEPtRF8PgboWw43xLdulUnFgvy2PAmWWIeFQShmr6LjN7RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ct01ES6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ct01ES6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458911F00A3A;
	Tue,  8 Sep 2026 20:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900654;
	bh=vD8pyvJH9zExt6WnCQIxdMdMPT7fIPfl/Tt6ZaSa2io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ct01ES6Luu+8LvDBzBh2nqCNSNHUgfpBzJaXjML+RJMmTOkUZQo6ubYHgsaqlIC+p
	 1htTPGEpYOps6ztf5bmYa4fprchScdXUpKphHZqPNbjiAI+r+kFnEQzR4CiA0D1sW0
	 ZdAofQpCalMdBzmLjftE1Wju59UjQWTI/ZkQUlyLaLu33YDGuxs9z5XrT+W0nKUGsE
	 RatWbXhV8Vhivnhv9kpFYKwjpgSzjX+QOBcu2f5xhVXubc9P9VGAfXtlOq8nCTouHl
	 yTwyu4T2glKdWqPZ11eCcGzyfzfcTJijoFh9RKQ5tDhl3jal/IURHmWhVPSM4gRdpl
	 1U32vRYkpzBVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 37/39] fuse: dax: do not set VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-37-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-37-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:50:52 +0000
Message-Id: <20260908205053.458911F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D37

