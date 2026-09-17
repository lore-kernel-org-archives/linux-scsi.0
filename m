Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A023449D5A6;
	Thu, 17 Sep 2026 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665707; cv=none; b=A1v62VqBZgEV/dNL3Wmtwe5eUoTMQeRDEbW1Q0/eEmjuEhMwLkpllCEAsEJ9FU2XqwQ9cRADuNsZ5I6gaSLr5FMF9pAXRxf19/geIYVg6FXNfb2SaOyvTtDbpgiH9iVm0QJqZqcDHJu8zQ5g05YQkRIFMpHCfD/2mQXBQ0gqkIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665707; c=relaxed/simple;
	bh=L82Tux/u+mQUEf4DvD7/QcAUtkd49ojvghfyHBePWFk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HCyyBekVWvQZjj1ojk7rOGDC9OPrLFO6Ki0nFiIEp8ddpd9VIf0AV0TtLkZALHfhwZjBNWBiiAqP6rosYtzxIpXaUqJ6tDkFV9uBCNWdgp/+VIs0lZEJ2B7pOBdfSzHoOoDp18+gYvBp9hUZZ7IUvOB9GiwzuivR36INHhi7E50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GlMOZzHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlMOZzHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC24E1F00893;
	Thu, 17 Sep 2026 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789665706;
	bh=L82Tux/u+mQUEf4DvD7/QcAUtkd49ojvghfyHBePWFk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GlMOZzHOrfJ2znNlH6kC7q0V5Mh7w0iijwzDZENVwRsjZEwcvDLcqx4zUBCAD99ew
	 VmSxOSzWgxrAjmokB8bxz9ajerFQlzsEaZw5PzqMrbDgO8u751KWtXQOe84Kn0e7jH
	 yr4eaNi1w77DJx6Zrr/8agoYWPvJRd3MGfSnDVi1SQz7BRGlHMcTc+YllQrsGaNnzy
	 3I5mBdDwjjLE7iVmAqd6U3f/ylY3UB4suBtymC3updgZXQelSKRQ0yWu7I7LOsQv4I
	 Bjj6piY3v/sfqYJmItrtqwSMbBZ75r3lOrV97lwYiauvSyhqFujCi5b8Ne5KkQzJ5r
	 DjBD/WLcMzXPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:21:45 +0000
Message-Id: <20260917172145.DC24E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
> or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
> determining VMA mergeability.
>=20
> Either flag means the contents of the mapping are owned by the kernel,
> usually a driver, rather than by the core mm: the memory may be MMIO,
> kernel-allocated pages or even ordinary pages the driver maps itself, but
> the core must not populate, reclaim, migrate, copy-on-write or merge the
> range on its own initiative.
>=20
> We initially also include VMA_IO_BIT here, as by implication, these must =
be
> kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
> while locking them, which is addressed later in this series.)
>=20
> However the intent is to in future remove this, as no mapping should be
> marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
>=20
> This forms the basis of further work intended to improve how we express V=
MA
> properties such as this.
>=20
> Also update the VMA userland tests to reflect the change.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D15

