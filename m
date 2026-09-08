Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E2E4B486B;
	Tue,  8 Sep 2026 20:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900334; cv=none; b=jpNt1eh1BSUcKhHrohRvkkxBgLLAqQCztsMcmqcnbzGj4HUDVgIj2n1sPJp6owFsQO6lEMYc0WtAl0d3/jIE6btTLw3GGgR2G/dzoXPffLF8wGePFNeyrTO0MGIYCr9jKie5KmIjEWF1IxcF1lsDzf0dMUjjcyZrTwC6gjeSLCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900334; c=relaxed/simple;
	bh=ApDhUfrd1P/uYBJjoAdcf9tprB6c8L0RsYzGyaIrjlA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eyU4gcoQPodWyKAup+JdKWtl2kB3WH1eLuiOmAhNT5iVwC/BYgOf/K/kV7cLMHGWBPXrsUzy/TId0mVtNWqGh/UjvGEnqFHBw2Dkxo/uA57rSjPgCN+4/+1DVw0DSe/eXWblPs/E5xFtKnS3/0FVs6Vpsq0Gu4VdHpnhk+cxcys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7/dUd9G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7/dUd9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39021F00A3A;
	Tue,  8 Sep 2026 20:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900333;
	bh=LG3j4gE7ldemd+Dz5YDZ3pNh4yAUNQomOC0AFet+F64=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K7/dUd9GqMcbXdFhyJVTslN73aAhJW1HfNTyK3o5UzoC1efA49lqbS0mIredigrCa
	 w5QEaE2CSjZDyJCreoXNzMyobDPMYOSnXzoN4CrtfFqY2Ivvu6qfb4VabSCZikn/Vt
	 dDeZOEMFXO8x3qCG0Kf5gFwFzO/4n9UIunVjzxuc1wICpEWpLWCGSvjQri5hl4n8Kx
	 axg9Wrsd2dzM07Y3N6sIiKd+nrgZsLkA5kue8OpehjSEHb9X68B8y8SvBmTrBmqWLQ
	 TPItx1ytI0ONKmkY4G3sEgnsGJstMjuNTsue8ejlmJyRo4wPmsGF5O+jhwUxFurU81
	 KJwTBcVzhwMUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/39] ALSA: pcm: use vm_insert_page() to map PCM status
 page
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-12-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-12-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:45:31 +0000
Message-Id: <20260908204531.D39021F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Eager PTE insertion via `vm_insert_page()` during the `mmap` callb=
ack uses a stale `vm_page_prot`, inadvertently granting userspace write acc=
ess to the kernel-owned ALSA status page.
--

commit 31ad2114dee595c7dfa978aa004add8157e4aa43
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

ALSA: pcm: use vm_insert_page() to map PCM status page

This commit replaces the fault handler for the PCM status page mapping
with a direct vm_insert_page() call during the mmap callback. It also
ensures the VM_MAYWRITE flag is cleared so the status page remains
kernel-owned and read-only to userspace.

> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index 62324282fcae9..37a157d558325 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
[ ... ]
> @@ -3760,39 +3760,26 @@ static __poll_t snd_pcm_poll(struct file *file, p=
oll_table *wait)
[ ... ]
> -static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, stru=
ct file *file,
> -			       struct vm_area_struct *area)
> +static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, stru=
ct file *file,
> +			       struct vm_area_struct *vma)
>  {
[ ... ]
> -	vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
> +
> +	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
>  		     VM_WRITE | VM_MAYWRITE);
> =20
> -	return 0;
> +	runtime =3D substream->runtime;
> +	page =3D virt_to_page(runtime->status);
> +	return vm_insert_page(vma, vma->vm_start, page);

[Severity: High]
Does this eager PTE insertion inadvertently grant userspace write access to
the kernel-owned ALSA status page?

When a user requests mmap with PROT_WRITE, the core MM's mmap_region()
initializes vma->vm_page_prot with hardware write permissions.

This driver callback clears VM_WRITE and VM_MAYWRITE from vma->vm_flags
using vm_flags_mod(). However, vm_flags_mod() modifies only the software
VMA flags and does not update vma->vm_page_prot.

The callback then eagerly populates the page table by calling
vm_insert_page(). This function reads the unmodified, still-writable
vma->vm_page_prot and installs a writable hardware PTE.

Only after the driver callback returns does the core MM invoke
vma_set_page_prot() via __mmap_complete() to recalculate the protection
based on the new flags. But by then, the PTE is already populated with the
stale writable protection, allowing kernel state corruption.

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D12
