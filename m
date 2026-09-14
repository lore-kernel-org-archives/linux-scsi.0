Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206F3419FB2;
	Mon, 14 Sep 2026 22:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424772; cv=none; b=cjJZb26nTkY+j2UrFq8aOTK2WIu97CtKkbgcKXDMJXuEh4cX/GFwrMiLDyvjfVkzWMVzZ7tWtu7q0RHKZtjpLAB6M2uYRGAaxfOwM2fmaEprg7Wpal3j3235wY2jBXdDP/2HGsgEftqjZSxhizWxruNT5NMPNwBFAawRgBYmTZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424772; c=relaxed/simple;
	bh=K1whoTuIPvEZm+ajxZr6H/l62B8RMmj9n/opWEIrEDI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=djWwMXvvksrHTxCxJn+L2QprVc+i2vWTT7zKU6WbKqJ3BqvXzptYNULDOqsqhBRJrLXxAbdqSHur8sCLYTqh7x03iQvRX8nPNSlVvQNy4EiBTgOJDqnYm4yAYGsyG0ACJFEdM09U5mfLKoPDocNIp/x0phZ0sEee0CEwwqRkWaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3EQhx8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3EQhx8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24AE1F00893;
	Mon, 14 Sep 2026 22:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424770;
	bh=K1whoTuIPvEZm+ajxZr6H/l62B8RMmj9n/opWEIrEDI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k3EQhx8YjtQQr0FX+doB7EYdJiI4X1NTivVkUGkPbXEoXt5VY6fVpx7n/0rf7DaPz
	 GzdXtVl6t0enNdnjLEEVzxcwmw4bnQeFRYcvfn/F5O0VhyRqU8D1Z5eeF/YUQWhH/N
	 M6W8eNXP3ccZ/whhTNZZp+lXQEpNz2XoD5Z9fBz5II9YhXaP5lfDOs7zbcqJg+jl+7
	 voNiCu229AvnThBQ6Z8SpXX4Kl9lJEPYGpEy6A38L8n2NkP8ivA2Qb6OuvxFjkv6fG
	 m9Ll+4qTqyJ87rc3QyukjjnFXoneu82DyTV6ObWN/nDll6+gjWxGgBUptoqw6JS/rp
	 hvmCE5zVgDUjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 39/40] mm/huge_memory: remove vma_is_special_huge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Oliver
 Upton" <oupton@kernel.org>, linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-39-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-39-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:26:09 +0000
Message-Id: <20260914222609.D24AE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is a kernel-owned mapping),
> but with a DAX carve-out.
>=20
> DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no long=
er
> required.
>=20
> Therefore test for vma_is_kernel_owned() instead and also drop the
> VMA_IO_BIT check, as it is now redundant since it is enforced that only
> kernel-owned mappings can set this flag.
>=20
> This also eliminates another overloaded use of 'special' within mm.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D39

