Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EDA4D4878;
	Thu, 17 Sep 2026 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664049; cv=none; b=nCC3SBUDWBCGto1sTU7yyHkFuumkEex2HNIpxDPwgWlhAOvJ8RHKva9ljTbKcQoDzuAbJf/YnT9mMArV0dNVboi1IRzBbERnMNvKWHk5HAtfhP2rRb7sLCYXJ36aISRzMP5nGwjxbA0UXWoMkXjuALqgfQCAMQtv1v+xX6bs4go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664049; c=relaxed/simple;
	bh=Vp/jIn0og786bFdu9pn8hWmYXlY09SYJ6iWsUNZBipA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cbFRCGew7Sh43oZfI7Wez0rIFQB2LbxTjm31L6pP+BJtnBhs4/cWFCCU3lZ7EvFm7m7gsEnIL1WF3cV7t5fyS2L0KjFDM2ozH3AM2dd0q0sJl5finweQL4Geu2llSSAO0Ehzewcqj/vowlJjWqDtoJ3J83iJlmy3BhYvszoMtwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyLCjGmd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyLCjGmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3671F00893;
	Thu, 17 Sep 2026 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664048;
	bh=soTBV+PjMnLk3CJqDep3SeaGxjjzvxEjiNUk8qBpmsU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eyLCjGmdrDwctVmdHC7BJ3p9PF7o5gpRumDdAuDAaNy8Ld2HpjE2vuKO9qOrrRHPW
	 BIVGQKAcpQ8Tj0OpdswMByR6ajR3Dr82AtiefkpkLRgfILf0If9zPj9JfsJLEwzHko
	 lZ+oKPguQan3LQuuXUKVNSNNMX5mooVKrg6a07th26o4uULzeIlVKJQilArdmXeR1I
	 hEXdXdBvG98j1Uhq6/S7vugxw7MRbvx2aNsyq2olk+tmmGC5oeXOUXad9+03EQgA/r
	 PRR7KJN5XzZUPvjgUyDNjVHsKlxnZtkUnez9B+V0y/tkfkcJzV+ScJO0Z4Cj1IA/FQ
	 1fth1ZkQIXKUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:54:06 +0000
Message-Id: <20260917165406.DF3671F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: NULL pointer dereference in compat_vma_mmap() error and succes=
s paths
--

commit ed2cb69a22a3cc12d20a6c5599880de22d11566c
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
   =20
The map->file_doesnt_need_get flag is confusing and the existing
implementation has holes.

[ ... ]

> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d08..016932780925e 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
> =20
>  	/* Perform any preparatory tasks for mmap action. */
>  	err =3D mmap_action_prepare(desc);
> -	if (err)
> +	if (err) {
> +		if (desc->vm_file !=3D vma->vm_file)
> +			fput(desc->vm_file);

[Severity: High]
Is it possible for desc->vm_file to be NULL here? If a stacked driver's
mmap_prepare() hook changes the mapping to anonymous (clearing desc->vm_file
to NULL) and mmap_action_prepare() fails, this error path would call
fput(desc->vm_file) passing NULL. Because fput() does not tolerate NULL
pointers, would this lead to a NULL pointer dereference?

>  		return err;
> +	}
>  	/* Update the VMA from the descriptor. */
>  	compat_set_vma_from_desc(vma, desc);
>  	/* Complete any specified mmap actions. */

[ ... ]

> diff --git a/mm/vma.h b/mm/vma.h
> index e97bd2dfa786d..f15faa83f3d63 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct v=
m_area_struct *vma,
> =20
>  	/* Mutable fields. Populated with initial state. */
>  	vma_set_pgoff(vma, desc->pgoff);
> -	if (desc->vm_file !=3D vma->vm_file)
> -		vma_set_file(vma, desc->vm_file);
> +	if (desc->vm_file !=3D vma->vm_file) {
> +		fput(vma->vm_file);

[Severity: High]
Similarly, could vma->vm_file be NULL here? If __compat_vma_mmap() is invok=
ed
on an initially anonymous VMA (where vma->vm_file is NULL) and the driver
provides a backing file, this success path calls fput(vma->vm_file) passing
NULL.

> +		vma->vm_file =3D desc->vm_file;
> +	}
>  	vma->flags =3D desc->vma_flags;
>  	vma->vm_page_prot =3D desc->page_prot;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D1
