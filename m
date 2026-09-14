Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F8C357A25;
	Mon, 14 Sep 2026 18:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411577; cv=none; b=Fy03BPsBIqNOqyWH58B0E1dlaudOmItU4NfC/7gTc9tTelDZw5MAFg8CIhwrazAEIu1rCKQbPPylqOj7jrQIsodegeIzlPne4Ijh7/NjhVgp9VpXJepPigQFNHpX1O3Y3KNRBoro4tSl0meA3YncQKa11DYpAP0S8Egf+znwk6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411577; c=relaxed/simple;
	bh=xZdliKyKvg9RZIi2RYGmE/6sOzITteepzZ09bPtGNFc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gr6+m/9ed551IQYAneiVqaBOPvtoxjfW2dNsOKIXtpNGVHi/kYzw/q2Qn4aC6XArzBlcu7KuUDt5C7p+B1b8p8m8MiUrNQ+2oVw70hREwdzxbhrGslmEYwdH1aFKbWzb+7fLHkEHaLKNKU+F6iexeRluf9xZQmQ9r/rgY1iD+Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAfrsRge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAfrsRge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC931F000FF;
	Mon, 14 Sep 2026 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789411575;
	bh=bEBcmHDKWwXGEvslKkTKX2Z4OnjCfHeS0TNCxxRXnZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lAfrsRge7/cyIafkvwqITVVZ/PXQjRiIoxJJDknExgMB8kwOXn8B27Krq9vk1S8tj
	 5wXFhZZHwcv4i7I0Kje8G9/dDR0p12RaRSWHlRVM3QsCYJubFZg5H7PF05vt3qYLhR
	 POqKbYlAMTUOHNY110zpA2Tb0bkxdTEk8UuQjYaljrmvcpGOEmpdgRcwPSms8mzPXy
	 kCv4oJWgki3U/L2qlmOFu8x9BlNBjDlHMgAJRIDCgo0G9OaChz4RKfeBqYh+IfhWhz
	 xYCdRa5sXql5JY+9NL1MFfacql7vZwxsU0L9o3eoCCu0moQTcO/VXRd4lGsK3IJrj/
	 JE2hz1CU65GrQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/40] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-14-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-14-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 18:46:14 +0000
Message-Id: <20260914184614.BAC931F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] VMA traversal on an external `mm_struct` in `zap_pages` without ve=
rifying if the address space is stable.
--

commit cbf53175992b654249c64afadb9a535e0ca6aecd
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP

The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set to
one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
or arena_map_mmap().

[ ... ]

> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 7b6847200b431..b69fe5e343393 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct=
 vm_area_struct *vma)
>  	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
>  	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
>  	 * being copied into the child process on fork.
> +	 * This is a kernel page so set VM_MIXEDMAP.
>  	 */
> -	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
> +	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
>  	vma->vm_ops =3D &arena_vm_ops;
>  	return 0;
>  }

[Severity: High]
This is a pre-existing issue, but does zap_pages() traverse the maple tree
of an external mm without verifying if the address space is stable?

kernel/bpf/arena.c:zap_pages()
		mmap_read_lock(mm);
		/*
		 * Re-resolve: while we waited the VMA could have been unmapped
		 * and a different mapping installed at the same address.
		 */
		vma =3D find_vma(mm, vm_start);

If a BPF program frees arena pages, triggering zap_pages(), it iterates
over the mm_struct of every process that mapped the arena and calls
find_vma(mm, vm_start). If one of those processes concurrently failed
dup_mmap() during fork() or was reaped by the OOM killer, its address
space is marked MMF_UNSTABLE and its maple tree is in an inconsistent
state.

Can traversing an unstable maple tree here cause a kernel panic when
find_vma() encounters XA_ZERO_ENTRY markers or incomplete tree state?
Should this path call check_stable_address_space(mm) before traversing?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D14
