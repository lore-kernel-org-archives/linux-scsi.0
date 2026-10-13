Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A004A542EEF;
	Tue, 13 Oct 2026 19:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791920969; cv=none; b=tnNHwRsiBCydC4BxriQhz4GVCjcSibkVrE1BwI7yB5SE5zsHDNovYaW4D6Lyd3xLeuJLNYbve/0m8rJsTXYtX60DjbwBYsPLAGbvBTD5WpKo6GasLsIAUxdzm/cPPqyYWP1IQcs30zpAERh6um4h+wbwNHDnMkZebispxxBSEY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791920969; c=relaxed/simple;
	bh=ldwO3cFm64bnrynDvOBlQj8COmsGNqU+riOvCs2Dhm8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=dP7dZFDWT8dfcdM95yrnbIO1377WotIl0scmQ61UEZ+t7qMIL8X9WcDJnSUFrrZiuzqArxLDiCfbrNjNhvz6BP0ZdTi/PpguWq9jZUYKEu8MYN5EHjqDQbXr5PB9AP4kUvJP0m1n1/v1paR1EJoF5lQ9gtoPzGoD09KYNOcc0sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yd5yQsQe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yd5yQsQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431CE1F000FF;
	Tue, 13 Oct 2026 19:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791920967;
	bh=gSwdcBHqW0LbgQKT6nKt95Qv/QKLGxf35n8p5/QHy1g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yd5yQsQePlyWQ/7DLdU6gH+StuyrPQD/dKoim7jIAFNeoMUy3B7UL9iJ3AQNFMk9R
	 w/PDX3tvsPkuGZDSwA7BXuCgV5kgKR/ws+ak53JxTGzPV908Xte+SAQMscXAzWBvGa
	 t60g1PLpyOhbcS6O6G9pSKexEk1CvckJECT4sMCGZjsrDcPVgPZKB208rKYdWL/MXe
	 SpBzZSyfLEYrYOOyx52CXlkgdJ+Vh2KF+6Z9mZe+f96pkhBqUiRPwWule9auoGCYvR
	 1sr7n5atIA6NUr5bIuEDLyANGMGNPeRZbKbMCPzE7sg56p8sFAioFBqQGdv0G3tgMW
	 VCqZBhWZh/sgw==
Message-ID: <sashiko-outbox-170428@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 24/39] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-24-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-24-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 19:49:25 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] mm: TOCTOU race in try_to_migrate_one leaves folio pinned in mlock =
batch
--

commit cc15ce19ca95992151b61de2cedb165e4684ba4f
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify

This commit simplifies mlock VMA flag handling by eliminating the use of
VMA_IO_BIT during mlock operations. It relies on VMA_LOCKONFAULT_BIT to mark
walks and updates mlock and unmap code paths to test appropriate VMA lock
flags instead.

> diff --git a/mm/rmap.c b/mm/rmap.c
> index 5332c52909be1..b4a4b3929044c 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c

[ ... ]

> @@ -2395,7 +2397,7 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>  		}
>  finish_unmap:
>  		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
> -		if (vma->vm_flags & VM_LOCKED)
> +		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
>  			mlock_drain_local();

[Severity: Low]
Can this double-check of VMA_LOCKED_MASK lead to a TOCTOU race?

folio_remove_rmap_ptes() calls munlock_vma_folio() internally, which checks
vma_test_any_mask(vma, VMA_LOCKED_MASK) to decide whether to queue the folio
in the local CPU's mlock batch.

Immediately after, try_to_unmap_one() re-evaluates the same mask to decide
whether to call mlock_drain_local(). A concurrent munlock() can clear the
VMA's locked flags exactly between these two checks.

If this happens, the folio is queued in the batch, but the local drain is
skipped. The local batch retains a reference to the folio, which permanently
pins it and can force best-effort migration like compaction to fail for this
page in a tight loop.

>  		folio_put_refs(folio, nr_pages);

[ ... ]

> @@ -2770,7 +2772,7 @@ static bool try_to_migrate_one(struct folio *folio,=
 struct vm_area_struct *vma,
>  			hugetlb_remove_rmap(folio);
>  		else
>  			folio_remove_rmap_pte(folio, subpage, vma);
> -		if (vma->vm_flags & VM_LOCKED)
> +		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
>  			mlock_drain_local();

[Severity: Low]
Does this path suffer from the same TOCTOU vulnerability?

Like the unmap path above, if the VMA flags are cleared concurrently between
folio_remove_rmap_pte() and the check for mlock_drain_local(), the folio
could remain pinned in the local mlock batch.

>  		folio_put(folio);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D24
