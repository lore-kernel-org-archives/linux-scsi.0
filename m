Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3EB502795;
	Tue, 13 Oct 2026 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908964; cv=none; b=SYRhPt1U73TT4NfWmVaNppknIpQkAroEmTPC9fiE0Mf7wYtB1vcrzBR5pTsOadCp1tcLKUah+wCP7ogZ40TrrmA2cdNDT/Dfn1mblwJo1NSGT60mH7STZmhzqPQlwlF9kTDPJODj9qL1ZGMowNZJrv977eltrkXAG4R3OANG6O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908964; c=relaxed/simple;
	bh=vM85zR2fOVurYBxjn8fT5iW4OxrI/h14uZrugbUdlkY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YaBD6puDEn9YMwQFSxgXyJxRF0GcRlydr7ODi2/Pn4eHVHUQUUoNXcTmWmpwB2d0FF0ePhUhuFh/3rO2XF3GoO3up2sAahRYbZqxGCC34a/UWDeWNm0NBkP/31C0SgxQX3B7JMyHNbX4y6UnFKGI+g7IIoLulbwC/5E1AY4xIP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nh5lZUsI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nh5lZUsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEF01F000FF;
	Tue, 13 Oct 2026 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791908962;
	bh=2MSKGWi5sSTXPxshy0khHGQFOGEaARrsUzF69RTi9us=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nh5lZUsI00aE3cPEz2OT/FZEYPg4h6SI/G9fLd8I8GbBxvGn7Uy+G0t/Y5HnPvih5
	 SD5sDhB85Itm65IyDanL2L6ix/6sThqZYZim+pOR7Tf8IZbsbKOQazjDnDHzZiZUu0
	 Pb0JRbMPuunzrsBVAtuztHOBCcafuATGlv8iUze9mWAfF82adDnhQElQDj5FWrf59v
	 Quwnc1vGch6JEZ3OSp2xEg7STFPr5ZsdAvcTM8aZ3OofM5bseGmWVBrqSgDxNbt1cD
	 AjK4u117W1bn2hBBK9uXbKgxDektLa785Jnaywiz/gekeuhP4MAtvxX9YBQkbjoh30
	 z1XaVUdGNVjSg==
Message-ID: <sashiko-outbox-170114@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/39] mm: add mmap action for discontiguous kernel
 page mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-8-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-8-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 16:29:21 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: mmap_action_finish bypasses error_override for compat tasks
--

commit 21d3d0c977ac349611c733fc3c288ae67e5f71a1
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm: add mmap action for discontiguous kernel page mapping

This commit introduces discontig_kernel_page_ops and a new mmap action type
to allow drivers to map discontiguous arrays of kernel pages into a VMA.
It updates the compatibility layer via compat_mmap_action_abort() to proper=
ly
handle VMA teardown on mmap action failures.

> diff --git a/mm/util.c b/mm/util.c
> --- a/mm/util.c
> +++ b/mm/util.c

[ ... ]

> @@ -1412,12 +1421,13 @@ static int mmap_action_finish(struct vm_area_stru=
ct *vma,
> =20
>  	/* do_munmap() might take rmap lock, so release if held. */
>  	maybe_rmap_unlock_action(vma, action);
> -	/*
> -	 * If this is invoked from the compatibility layer, post-mmap() hook
> -	 * logic will handle cleanup for us.
> -	 */
> -	if (!err || is_compat)
> +	if (!err)
> +		return 0;
> +
> +	if (is_compat) {
> +		compat_mmap_action_abort(vma);
>  		return err;

[Severity: Medium]
Does this bypass the error_override logic for compat tasks?

When an mmap action fails, the mmap_action struct provides an error_override
field to allow drivers to replace the internal error code with a user-facing
one. Later in this function, non-compat tasks return=20
action->error_override ?: err.

By returning err directly here when is_compat is true, it seems 32-bit comp=
at
tasks might receive different error codes than 64-bit tasks, potentially
breaking ABI consistency.

> +	}
> =20
>  	/*
>  	 * If an error occurs, unmap the VMA altogether and return an error. We

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D8
