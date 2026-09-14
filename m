Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD68336B927;
	Mon, 14 Sep 2026 16:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404320; cv=none; b=c3/+d7RJ8cLGDb02m7AyTuiqpN9bUeP5KAY4CGKj0AbOiAAGXWWZoisTCEt4mXUEk74GGc0dU9301Pu94n8HEJk7xE+Mqi8WQ/ltoZIQ27zZaBUSO08Qguf0S9y4QkEE9pDVk3a/OHPKFV4OzxD5NFp2YZ9SjnyWwJ/9Kj3aM8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404320; c=relaxed/simple;
	bh=XIls4RBFFsg1eWKlYNWozBn3d3TN1RYolmOyIKZv0NA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W4/yNuUgDddGS5Ds/MsD+qpIyJl2hVnERRxcoAYa6MqaILZUhQ7/4vV/NGK3wDX11h30Rl/ugtJ9p/Qh3yuy0KkLNgsRr34hUWfJ8KtaWnRLZr/0QMkw+O5Vc2ihPeStosObUWhWu95uH6EOSLoHWzTUWiE5U5v6WNNlY6zWM9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFN8zg1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFN8zg1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A411F000FF;
	Mon, 14 Sep 2026 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789404318;
	bh=GzzUgpg5T3Fw7SIJWr0k/zDCNh06mog6jFMZsTNMkEA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CFN8zg1nrQKpSH9hKVbpq0yf2EVgikSGjZPZk55eTjlY98JNX4Rk2OEAvNFgYtgkH
	 M/HhnW4sXS3+DFMHs+GYXdqaEtphQuANd7xb1xkEMeIaifMeXnZ9kVzSh1b+0rzbE5
	 UF1kjreA3QUxTNDqjUY0nvz3VYrm5E+VQNJ59ywSKdc2JarhaA43ySTRVjrFd2IgPN
	 wrXFGRCwvLIAzzcSLsiFDUfl3RWIgaX/5jNiLwBBS78j/xOGP8hwY/plRY1WZ0NBoF
	 IMeLywf8hMHYz9O4eLOZJCb9ldQXctwKh/yuY8XHmq18C3mT1TU6lwLiuh7O8En7rJ
	 xwwPiAjJVNk3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/40] mm/vma: ensure mmap_prepare doesn't set
 actions on a mergeable vma
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-5-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-5-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 16:45:16 +0000
Message-Id: <20260914164517.61A411F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] State modification applied to `desc->vma_flags` during action =
preparation is not propagated back to `map->vma_flags`, resulting in incorr=
ect VMA merging and the silent loss of critical flags like `VM_PFNMAP` and =
`VM_IO`.
--

commit 31f214221abd5db93fe1f46874d29ea3c59a0cc7
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma

When a user requests an mmap_action be performed in mmap_prepare, this
involves populating the VMA range with data. This patch asserts that no
future mmap action is performed on a mergeable VMA upon mmap_prepare
validation.

> diff --git a/mm/vma.c b/mm/vma.c
> index 626a18c08a269..2648fb0e19959 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start,
>  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
>  			  const struct vm_area_desc *desc)
>  {
> +	/*
> +	 * It is not valid to execute mmap actions for VMAs which can be merged,
> +	 * as any such merge would leave portions of the mapping incorrectly
> +	 * unmapped.
> +	 */
> +	if (vma_flags_can_merge(&desc->vma_flags) &&
> +	    WARN_ON_ONCE(desc->action.type !=3D MMAP_NOTHING))
> +		return -EINVAL;
> +

[Severity: Critical]
Does this check actually prevent the merge? Looking at call_mmap_prepare(),
map->vma_flags is copied from desc->vma_flags before call_action_prepare()
is called:

mm/vma.c:call_mmap_prepare() {
	...
	map->vma_flags =3D desc->vma_flags;
	...
	err =3D call_action_prepare(map, desc);
	if (err)
		return err;

	err =3D mmap_prepare_validate(&prev_desc, desc);
	...
}

If call_action_prepare() mutates desc->vma_flags to include action-specific
unmergeable flags, vma_flags_can_merge(&desc->vma_flags) will be false here,
allowing the validation to pass. However, these changes don't appear to be
synchronized back to map->vma_flags.

Could this cause the actual VMA operations to operate on the stale and
mergeable map->vma_flags?

If a VMA lacks VM_PFNMAP or VM_IO but contains PFN-mapped pages, could this
lead to memory corruption if kernel mechanisms assume the pages are normal
memory and call put_page() on raw PFNs?

>  	return mmap_validate(prev_desc->start, desc->start,
>  			     &prev_desc->vma_flags, &desc->vma_flags);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D5
