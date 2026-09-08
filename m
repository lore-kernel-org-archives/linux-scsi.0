Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B0B3B7B79;
	Tue,  8 Sep 2026 20:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899805; cv=none; b=P1cm9hmzfvKcSAdTjRkl26MBxhKx5QkjmYUn+4M/ss5YdffpZOYTVotuWVnTWsNLP9gsnpq5POoq1V7/PvHKnbu890179MckGoJwJ3Hlti9AeXPlErL6TvYelYGaQfrxPkIRBdORYtbfQnzs0cW3+RKLR8WY4mlHMLIyZSdJN4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899805; c=relaxed/simple;
	bh=9tndEi2INNZ6IcQhJ83M6VAVqVtieKUYEgZipfM/wT0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g983I1wrIRXpBgKJuEhY9p5v4QzDzCHpBnuzfFBWX26HFO2IT9kHN+S/1debejjBLQqi5nROPcSaOdc287U4Mao+Nboy0/JzmwNw64VwJXyFAXrvg34sdgBrUjTzmQzLuRZouS3nTQ9Ou/W0qP9zMFeGvL/YIzFqQpjgNFLF5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elG/WADn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elG/WADn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D842A1F00A3A;
	Tue,  8 Sep 2026 20:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899803;
	bh=hyjLnquseXt3Sig0aykRcsZZ0Ak0XrxmINo3s38hEuE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=elG/WADnLNB7mOh29g9cQzG4hvN5oMtH36xxJcpzLhQl5lKsZa3I5ZolbSc/6Ddpg
	 Ju1Lgtdsqn5I7T64pLHxxAVlaIIjfLO16scP193KxRisJTlPAFcfnhwXkClHjpWZ6P
	 VIMJ4FfRNw2KqiK2u0vi8o86zdwKQows5ZwO/jYMiMxTpdu3rXo1XyUfgG1lVyWmUT
	 cGKBVg8MJv9wQTFq3LHtdV0zU6devo3DeA57YYdFu5lFhmswbTa2plSjT26SEjAlHZ
	 sO3q39/q7dCDkyjm/RMCMQUWnx316fHTxtGubScdcOKceeT5MioUgDFitf77BLNBBd
	 MsqxttUCOTxeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/39] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, kvm@vger.kernel.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-4-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-4-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:36:42 +0000
Message-Id: <20260908203642.D842A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] File reference leak in error paths of `call_mmap_prepare()` and `_=
_compat_vma_mmap()` when validation fails after file replacement.
--

commit c2c06e31f69acde90d013dcbd918472d63f3996c
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma

This commit adds validation to mmap_prepare_validate() to ensure that mmap
actions are not set on VMAs that can be merged. It returns -EINVAL if such =
an
action is detected.

> diff --git a/mm/vma.c b/mm/vma.c
> index a24f04428580b..9e45fc83f74c6 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2794,6 +2794,15 @@ static int mmap_validate(unsigned long prev_start,
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

[Severity: High]
This is a pre-existing issue, but by expanding the validation checks here, =
does
this increase the surface area of a struct file leak in the error paths of
call_mmap_prepare() and __compat_vma_mmap()?

If a driver's mmap_prepare hook replaces the mapping's backing file, it ret=
urns
a new file in desc->vm_file with an elevated refcount.

If this newly added validation step fails, call_mmap_prepare() returns earl=
y:

mm/vma.c:call_mmap_prepare() {
	...
	err =3D mmap_prepare_validate(&prev_desc, desc);
	if (err)
		return err;

This skips the crucial handoff that ensures the cleanup code in abort_munma=
p()
will drop the reference to the new file:

	if (desc->vm_file !=3D map->file) {
		map->file_doesnt_need_get =3D true;
		map->file =3D desc->vm_file;
	}
	...
}

Since map->file and map->file_doesnt_need_get are not updated on error, the
caller's cleanup code ignores the new file reference, leading to a permanent
leak of the struct file.

The same early return leak applies to __compat_vma_mmap() in mm/util.c, whe=
re
desc is a stack variable and desc->vm_file is lost on error.

Should these error paths handle fput() on desc->vm_file if it was replaced?

>  	return mmap_validate(prev_desc->start, desc->start,
>  			     &prev_desc->vma_flags, &desc->vma_flags);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D4
