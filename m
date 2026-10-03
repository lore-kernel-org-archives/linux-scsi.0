Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F773486406;
	Sat,  3 Oct 2026 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050246; cv=none; b=dHz4+gbDqQrj8+KbIDB/PLqo3Jru/VGWkYEwks7Dn12P4B2HvjbHRRnnwjg1jQGUL6+voYIBZTiVGjNCPKBgxPo86y/fEtfYgFfptk32CioKDP9IZ+qVFGggjCYqc+FzOopi1p5lPGkXuzsXV/B6mZlzWzctMBtACUnVnmpJa0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050246; c=relaxed/simple;
	bh=E0UjvnOvPNw9Xr5LWdEn25I0X3mokeuCbfwaQZ510aM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B2OqrP6llxTS7sNesgOjHOHgwFzr0k4fvXC2Qr5NqFDsqS3ghnygj+Lw2G/5HBN9c/q0Vw2Jh2dSVADFYuvbOvAOLZ+QujYxBButd9vru8KiUDhL7y1W8CltDOpY3zAutpiteDzh1zhC6k/1zGTjSLPi1ZuHiO6lSuX1hWlVqd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFzbWLDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFzbWLDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A75B1F008AB;
	Sat,  3 Oct 2026 17:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050244;
	bh=E0UjvnOvPNw9Xr5LWdEn25I0X3mokeuCbfwaQZ510aM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MFzbWLDSOubHMFELIAHuybEnyVK1wDmFK8to6Sq7zC+f7aR73tyaoj22oYN76NxbH
	 XTfOIS+DR+zGC6ziE82H8bSwNtx0aAMY43Qy7q+ejAbIHA9Uz6yF1qylpxqfIKpzAq
	 v05m2ULQncimDVGOvJyYVW/mI9DChOxpeeuUr1yjRjAKlNsUwG+ev3beEX2jvunKs1
	 oiOgPn8ZVrRXBHc1bfFkQ1iWXKT/BA34pjWLxIkQ4yhmc7olX2uC6MWxgcPEPjCyFt
	 RJ0Ph/HHthrX6Yh+3RkKF5pxjvW40dhWVLi439P00L5R3fEFzXBZGdBwAd8PoA3Hgt
	 VPehpdj19B0Tw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 19/38] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-19-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-19-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:22 +0000
Message-Id: <20261003175723.5A75B1F008AB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Use the mmap_prepare in favour of the deprecated mmap hook as part of the
> work to convert one to another.
>=20
> Since this is simply a refcounted kernel page that has been allocated, it
> should not be marked VM_IO and should be inserted using the kernel page
> insertion mechanism, so convert it to do this instead.
>=20
> Use the VMA descriptor's private data field as a scratch buffer to store
> the page in - this stays valid throughout the kernel page mapping
> operation.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D19

