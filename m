Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CBC4B4889;
	Tue,  8 Sep 2026 20:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900451; cv=none; b=staWz7VvH2VCCyH2U52ewQeo/pkpmeakAbzbEBoumTXEOj2ZiEZxrN2jc5xjz7YXvX613VGOjl1D3ZmbfHI2YUWu1leRWp2wTuw/htiZHse5r18MhGxz18PTgkmehUJQKg77jH4Z9LDQ9fuBRd6TZjmIEtCZtB63IRHg+70pPrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900451; c=relaxed/simple;
	bh=niMB27IUV6ipAAZF/CyQb2M5sbIk1w1rCI6/Vt2JDw0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=II1kPb41dA4GfmXvhRKdxZXDnZ2qACM/HL9pUWsd6QVyA8KUx3NcK2EiVCZ9XdVCO8plCVbU3L4aDNSP+gcq4JodB4I5xs/ozwHHtbeGfTSaaqDI/wEe6Rc1/fJf3GzUBe7Wzjyaaa9SmPqXOV+kvZqNGugNc/Hs0yqBqPDVCCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYkFZtZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYkFZtZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AEC1F00A3A;
	Tue,  8 Sep 2026 20:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900450;
	bh=DwC/YEbPBmiu256zcsr1Ykxnr6qOH2IoqHqiKaF1BDk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UYkFZtZ8rgPPXPHeLi9sdPgMiH25qGoi9+WjAP/WgA8UjdygBMvyXwNIK1z1mm2K1
	 wlfEFPVdgdDUnTFE2TjaZsTPt5ovIwN8P7VIaKeSj1B6mqmOjJYY4z0Csh/74ry5g0
	 Rp+vwSzfYc+z1EvVR0S+s0ZAH7/5aiyrb1FvyNbJvFwXASYPmMcHZMPp8bcqmEpy5l
	 un2Fg+20b+gyL1HYR7qUS5LvoJBhSzYoLYRw3m5W1Yb9arl4deE3m6AdohUo8d6/6A
	 7mFTWPMntkD4SNFQefiCIVqNNDx8NKo8pPG5yC4VTMgF00XQodqlySsApU4o4vdGRL
	 uYBnNhyPCNxkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 24/39] mm/vma: enforce that only kernel-owned mappings
 may set VMA_IO_BIT
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, selinux@vger.kernel.org, bpf@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-24-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-24-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:47:28 +0000
Message-Id: <20260908204729.47AEC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] Denial of Service

Pre-existing issues:
- [High] Memory Leak
- [High] Use-After-Free / Double Free
--

commit 12d56e2f89cf46c2631f51c17242ae01f2acd00b
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/vma: enforce that only kernel-owned mappings may set VMA_IO_BIT

This patch updates mmap_validate_vma_flags to warn and fail if a mapping se=
ts
VMA_IO_BIT without being marked as kernel-owned.

> diff --git a/mm/vma.c b/mm/vma.c
> index cb0c4c6257567..5996757d5aaf4 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2772,6 +2772,12 @@ static int mmap_validate_vma_flags(const vma_flags=
_t *flags)
>  		return -EINVAL;
>  #endif
> =20
> +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
> +		/* Only kernel-owned mappings may set VMA_IO_BIT. */
> +		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))

[Severity: Medium]
Can this warning be triggered by an unprivileged user intentionally mapping
a device exposed by a buggy or out-of-tree driver?

If a user interacts with a buggy driver that sets VMA_IO_BIT improperly,
triggering this warning will crash the system if panic_on_warn=3D1 is
configured. Is there a way to validate this without the warning to
prevent a local denial of service?

> +			return -EINVAL;

[Severity: High]
This is a pre-existing issue, but does returning an error here expose a
resource leak in call_mmap_prepare()?

If __mmap_region() handles an mmap call for a driver that implements the
.mmap_prepare hook, the driver may replace the mapping file:

mm/vma.c:call_mmap_prepare() {
    ...
	err =3D mmap_prepare_validate(&prev_desc, desc);
	if (err)
		return err;

	/* Update fields permitted to be changed. */
	map->pgoff =3D desc->pgoff;
	if (desc->vm_file !=3D map->file) {
...
		map->file =3D desc->vm_file;
		map->file_doesnt_need_get =3D true;
	}
    ...
}

If mmap_prepare_validate() fails because of this new VMA_IO_BIT check retur=
ning
an error, call_mmap_prepare() returns early. The state updates to map->file=
 and
map->file_doesnt_need_get are bypassed.

When __mmap_region() aborts, it evaluates map.file_doesnt_need_get to decide
whether to clean up the new file:

mm/vma.c:__mmap_region() {
...
	if (map.file_doesnt_need_get)
		fput(map.file);
...
}

Since map.file_doesnt_need_get evaluates to false, is the reference to the
newly allocated file permanently lost?


[Severity: High]
This is also a pre-existing issue, but can this failure path also lead to a
double-free when mmap_file() fails?

If a driver's .mmap_prepare hook successfully replaces the mapping file,
call_mmap_prepare() sets map->file_doesnt_need_get =3D true. In
__mmap_new_file_vma(), the get_file() call is skipped.

If mmap_file() then fails (either because the driver's .mmap hook returns an
error, or this validation fails), the error path unconditionally drops the
reference:

mm/vma.c:__mmap_new_file_vma() {
...
	error =3D mmap_file(map->file, vma, vmg);
	if (error) {
...
		fput(vma->vm_file);
		vma->vm_file =3D NULL;
		return error;
	}
...
}

The error propagates back to __mmap_region(), which executes the abort_munm=
ap
block:

mm/vma.c:__mmap_region() {
...
abort_munmap:
...
	if (map.file_doesnt_need_get)
		fput(map.file);
...
}

Because map.file_doesnt_need_get is still true, it calls fput() on the exact
same file pointer, leading to a double-free. Does this new validation step
make this sequence more reachable by unprivileged users interacting with
out-of-tree drivers?

> +	}
> +
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D24
