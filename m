Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868453AEF28;
	Thu, 17 Sep 2026 17:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666560; cv=none; b=ugNINsRdPdA0vmnbS0pgIFytjclAcFz2k8VJYGnWpoPwzEqeJ94H8BOYgVa8RO6JQdN2wLj9dZ7++th0wqmYsItckGy9mU5Ax99uEQB9wn+cEXSnf/VwtOBOeQjdQrlP/AGXju1W1Sr6gJzPQxgukcS/RuEbXF+ukK3xNzA6QuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666560; c=relaxed/simple;
	bh=6tOptKKaUIfdbCC+OYy+cL7SOm+5SVScVq8IaDuPSUU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L8HQetsVCzP9oFsbLM9w3AV91Enx+wC9OWppqNs1296s6Gq4+DE4MiejadIF8OAei8xKy11PKrALvmjbS48Zyws/CKNdiD2vcJTO+Lt4cVG5fS/nCvd9I9VqftXQ+MoCp+/Kt7Q6+8ZzSinzecqeZDTrIyY+YV42+biIftL2/Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UA/nCxKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UA/nCxKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F891F00893;
	Thu, 17 Sep 2026 17:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666559;
	bh=6tOptKKaUIfdbCC+OYy+cL7SOm+5SVScVq8IaDuPSUU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UA/nCxKFZDwOeW4GBCFNBQTDcEkyAbWZ7LNHqS8jYLd289sMsiBLEfyI/4SKHpiIC
	 N/nUm/V8W6V+u7SoEEgdniIJjt+XiylkwDYOL1/riT8kx++Ox/mqaFGcMP+bQQeQXx
	 iqColM8CYqvwYXkp/PF7wxEcE875NVMkewDs3N+ZTaO5rvK6O2+/wlV/3/22imA6N3
	 cSydItMuFpViPWkDmtV1e+l7CK1r9M86v3gcRiL47HcfOlOakC/NehL2N4tfdMEcMR
	 Xebgg6ApXyS4KjD3JgMpFhWupMdpoisLeGHPHbA3WVB2VuMZcOo7WqACXcD5AM9Mj2
	 /0bfGqL7Dn/QQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:35:58 +0000
Message-Id: <20260917173558.74F891F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Introduce vma[_flags]_is_persistent() for the purposes of identifying
> mappings that are persistent in the sense that bytes to the mapping stay
> there, and bytes read from the mapping are the same unless changed by
> actions taken by userland.
>=20
> Kernel-owned mappings do not fall into this category, as their owner may
> change the contents without the user having initiated it, and nor of cour=
se
> does memory-mapped I/O.
>=20
> We exclude fixed mappings as these are singled out as being unmergeable a=
nd
> so cannot be guaranteed to persist user data.
>=20
> hugetlb mappings are fixed mappings, but their contents are entirely the
> user's, so they are explicitly carved out as persistent, as the MADV_DODU=
MP
> check already does.
>=20
> It excludes droppable mappings, which by their nature are ephemeral.
>=20
> Use this functionality to update the madvise MADV_DODUMP check to test for
> persistence rather than open-coding this.
>=20
> This replaces the VM_SPECIAL check which means it no longer checks for
> VMA_IO_BIT, however this is safe as we have established the invariant that
> only kernel-owned mappings may set VMA_IO_BIT, so we implicitly include
> these.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D31

