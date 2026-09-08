Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB9F3B47E5;
	Tue,  8 Sep 2026 20:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899788; cv=none; b=ECicPC0WpOWPZOLJlB88+gkkECxZV12oMPZoDNhLC8JcFIQe3Cp8UUiauxv6Z66eXQwZ8bAoNgSaJsttRHZ5WdiHrxWcfVQEEQkt/vQ9SXPM/7lT9Ty7frD4DgfC2bzKCzfzMpVKUs6apREJDPdXqM33eV7LkETuhrsV69+Z4L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899788; c=relaxed/simple;
	bh=t+D833j6t31vkN6McnGU97skh/ZlJEf/1+o6DAzfTEI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rUILRs8wn/DA7cmxEI+KPuBQuUG9JHb6Gor67ZbbqB8HOCQKn+2aSDnXig3Ow5In9+PG8tHQfeoeLkyDcaX76uNKv25yH5qiesBbGaMbj4uHjTIjiiLxr1aIf1pHS5Q9qG0Eb5Oww5AS5uUx76UtByS22zJNE0CK9rqNc387bbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAEpIra2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAEpIra2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DE91F00A3A;
	Tue,  8 Sep 2026 20:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899787;
	bh=t+D833j6t31vkN6McnGU97skh/ZlJEf/1+o6DAzfTEI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TAEpIra2hvB6y7dXZ36oW+PUzPf1UHefZq/ZkpKJy9gkUE6SPgqmsKdjo7Y/AQ6Ca
	 LaprLv2dWYZfftRpQfTQjvP22EVQPJ3EypqNqL7MtXCv3h5Eoecnxm9smmcN/mpL/z
	 69l8F3VapzzNT/dVn7OPG6tD45xY0GBJ/cAnwvTn2wGq0Iku9pmjUPSzMK7FgN9hnl
	 MTG4kdwGsLWiiXCE8dUB/rJFTqx0EI5ugeXpEvWMGN/0Lod2Kwwpa7swVS324rJ2vf
	 lCpmHSSvZmO4Aty/60MKlBV7CqzQbObCj0zzGj1L7Kf96JZLzt5gtPKe3tYmj9mThE
	 p2YzDqFsKbZhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 21/39] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped
 kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-21-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-21-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:36:26 +0000
Message-Id: <20260908203626.71DE91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.
>=20
> Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
> the appropriate flag to set for those.
>=20
> This provides the semantics required - no VMA merging is permitted, but
> does not prevent GUP.
>=20
> However this has no meaningful impact as these are refcounted and thus can
> be GUPed.
>=20
> A previous commit already prevented __mm_populate() from being invoked on
> XOL areas which prevents so that is no longer required.
>=20
> Both VMAs set a VMA name, so always_dump_vma() returns true before
> vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
> in core dump behaviour.
>=20
> Change this for both the core xol_add_vma() function and the x86-specific
> get_uprobe_trampoline() function.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D21

