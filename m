Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836753B058F;
	Tue,  8 Sep 2026 20:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900035; cv=none; b=J+X+neP9t571Csnx0Z0hu8hppIGmtQEB90o7rkAaiBGIwDiAESHmniXoDD1KuXEKYcWl5uG84uUosuDvCbDZyyLNgY7KXSuABY/t0p3+rLoTLrikmoPursyWOjsvsxakurdqZAEzg553J0KaUxnCffhT7SiuZndm+L1UbjGWQQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900035; c=relaxed/simple;
	bh=9nHR2XkkJxbYh8F/JlrSJtOWZJ5UBNzg5lPKj8wjUDo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YgR8o91gqNtxq0UPvE8FqESkoidKbpaURHrC4o50owYI5bZzzSM4Z6PTUDE3ROsOn/xe/VEQO0MS2Rary/l2n7rcd0egEluMhaaNHLHGHTXAmxHALNUAwSDudrJd2lZfF+NqqAF33mmlsatBIZGasyqRojdN1zN0QP4MtwzM+J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3GTy5lc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3GTy5lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6501F00A3D;
	Tue,  8 Sep 2026 20:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900034;
	bh=ZKvjiarJylswGYL47MJAYi9QQDOenfl7sW60D9TqVAE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j3GTy5lcLfwJ9zh8zIP4jpSd9xgjU4ClloZ3qT6A+AsYHz76uDJ3D4It71oPzbKVy
	 fhjk8IwIXgYjnh9sgego1cWeCYzTouCI8mMA94rjLu6qocOAxIcLmCY5quOdt6Zs4N
	 jwGxxFYcP0SHMN4Fa2f39ItMuXH9XVoV2/9xnaoCyuLFRvrEPjRQptagzoNMgBstBu
	 /N3wAmXnNOAa5evhT3j8tU3NRFSkZLUvhNvxFyMPl1YVMb1lLnGww/q9PXtZ/8BajH
	 WIp9xSABdsxqy2rTlGbneRV2rVnY+3juYAo4EcqF6B2owz9vh5ppRvrVtvwPfv1RDe
	 ZQh3LB9vTT8cg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/39] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-scsi@vger.kernel.org, selinux@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-3-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-3-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:40:33 +0000
Message-Id: <20260908204033.BE6501F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Error cleanup path unmaps arbitrary memory if a driver illegally a=
lters vma->vm_start.
- [High] Driver resources and file reference are leaked when mmap_prepare_v=
alidate() fails after a successful hook.
--

commit 7871b5bece83247c9fe3efaac4b928710f478390
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm: consistently validate VMA state after mmap[_prepare] hooks

This commit introduces mmap_prepare_validate() and mmap_hook_validate() to
verify that mmap hooks do not perform unauthorized operations, such as
modifying the VMA start address. It applies these checks uniformly across
VMA creation paths.

> diff --git a/mm/internal.h b/mm/internal.h
> --- a/mm/internal.h
> +++ b/mm/internal.h
[ ... ]
> @@ -238,26 +259,14 @@ static inline int mmap_file(struct file *file, stru=
ct vm_area_struct *vma)
>  	 */
>  	if (unlikely(err || !vma->vm_ops))
>  		vma->vm_ops =3D &vma_dummy_vm_ops;
> +	if (unlikely(err))
> +		return err;
> =20
> +	err =3D mmap_hook_validate(prev_start, &prev_flags, vma);
> +	if (unlikely(err))
> +		vma_close(vma);
> =20
> +	return err;
>  }

[Severity: High]
If a driver illegally alters vma->vm_start, mmap_hook_validate() will
correctly catch the violation and return -EINVAL. However, does this leave
the corrupted vma->vm_start in place when returning to the caller?

Looking at __mmap_new_file_vma(), the error handling path relies on
vma->vm_start:

	error =3D mmap_file(vma->vm_file, vma);
	if (error) {
		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
			    map->prev, map->next);
		...
		unmap_region(&unmap);
		return error;
	}

If mmap_file() fails because the driver altered vma->vm_start, could
unmap_region() accidentally unmap arbitrary user memory using the corrupted
start address?

> diff --git a/mm/util.c b/mm/util.c
> --- a/mm/util.c
> +++ b/mm/util.c
[ ... ]
> @@ -1224,10 +1224,17 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
>  int __compat_vma_mmap(struct vm_area_desc *desc,
>  		      struct vm_area_struct *vma)
>  {
> +	struct vm_area_desc prev_desc;
>  	int err;
> =20
> +	/* Derive state prior to mmap_prepare hook. */
> +	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
>  	/* Perform any preparatory tasks for mmap action. */
>  	err =3D mmap_action_prepare(desc);
> +	if (err)
> +		return err;
> +	/* Check the caller did nothing crazy. */
> +	err =3D mmap_prepare_validate(&prev_desc, desc);
>  	if (err)
>  		return err;

[Severity: High]
If mmap_prepare_validate() detects an invariant violation and returns an
error here, does this early return leak driver resources and the file
reference?

If the driver's mmap_prepare() hook succeeded, it may have allocated
resources (expecting them to be freed later via vm_ops->close) or placed
a new file reference in desc->vm_file. Since vma_close() is never called
and the local desc structure is discarded, it appears these resources
might be leaked.

> diff --git a/mm/vma.c b/mm/vma.c
> --- a/mm/vma.c
> +++ b/mm/vma.c
[ ... ]
> @@ -2800,10 +2855,16 @@ static int call_mmap_prepare(struct mmap_state *m=
ap,
>  	if (!desc->vm_ops)
>  		return -EINVAL;
> =20
> +	/* Perform any preparatory tasks for mmap action. */
>  	err =3D call_action_prepare(map, desc);
>  	if (err)
>  		return err;
> =20
> +	/* Check the caller did nothing crazy. */
> +	err =3D mmap_prepare_validate(&prev_desc, desc);
> +	if (err)
> +		return err;
> +
>  	/* Update fields permitted to be changed. */
>  	map->pgoff =3D desc->pgoff;

[Severity: High]
This early return appears to have the same resource leak behavior as
__compat_vma_mmap() above. Would a validation failure here also skip
releasing driver resources or a newly assigned desc->vm_file before the VMA
is fully established?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D3
