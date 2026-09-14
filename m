Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B87345EA8;
	Mon, 14 Sep 2026 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789401334; cv=none; b=DIDVAF1FxSYcYwINREjrujkeROF8LmVNCdppZb0Y5xHmWQnNh/90/0pmFqf8msUi8U1Bw4WRYGL/aE4UK3llEtbeQmPlKyT3xrS977qgv/y7YN0Dm7zMjcOnYc2IEIjXq2cxbdWyYyodb9zdhoRbnjUzfjMhQSm1k95/NyqCxA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789401334; c=relaxed/simple;
	bh=VHur4Ghp2feF+XLRi2pqjK7TGM1BObHqaM60oASpfAA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Wa8fvlLuROR1j2PzDnQ8zEedzR40vMIKjkpiS+ZnMqWfgnJ7yNnfug+gKJO5PAiLtkED0g/73kbmIYLB9gGBR346ucFZmXlwHDZpsF1ko5sBgh2xd6oOYEAXr+lWE7V2IrZuqQYrd8/tWrEUxKOxxLth/0tsxGRrV0uVfxdwuZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiyJ7/Wh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiyJ7/Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596F11F000FF;
	Mon, 14 Sep 2026 15:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789401332;
	bh=VHur4Ghp2feF+XLRi2pqjK7TGM1BObHqaM60oASpfAA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eiyJ7/WhZ2KgzJJTzmZ1rU5QpBpUVobSWf49TjrBwEf4kqnTU+6F63xwt6hFIAp0f
	 nJhjTapqGBvP9XGMwz2SDse1en+wvfdiXoX9Y5Q4Yosiv4nhaLMmQqIkImJ8m5XJY3
	 u2kdR5KRq3DLI/DSQCOXWBl4fUjE7OxjZM5aC5sZ0lryTlhlzrQnnmIB7nT43macMh
	 bLpH6/4yJ3F/dnHmTpTlAGpE/nfIzx05N0VwYjaEkypja39GtYhCfMbOp82YVZDL8M
	 o9dh+CHufojI1mmABJ+Pkk/tRHUpZfxwR/crZY1PXShba5nzadiISqY7TB9K1S0qEN
	 9HHUUbM6EDveg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-2-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-2-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 15:55:30 +0000
Message-Id: <20260914155531.596F11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> It only makes sense to manipulate VMA fields if we allocated a new VMA,
> rather than merged it.
>=20
> VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> keeps its own, which is also what the legacy f_op->mmap path does since it
> never touches an existing VMA. Previously set_vma_user_defined_fields()
> overwrote the merged VMA's fields with those set for the new mapping. In
> practice these are the same values, with rare exceptions such as shmem
> selecting vm_ops based on whether the file has been unlinked, so no
> user-visible change is expected.
>=20
> Make this dependency explicit, and additionally constify have_mmap_prepare
> while we're here.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D2

