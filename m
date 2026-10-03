Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930DB3A8732;
	Sat,  3 Oct 2026 17:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050202; cv=none; b=JIQMhbeXBTfIzEUs2tC9uMs2CkUnPNQufCU6sCs80zr9z0PPykJirlEoey89rNePfmTGR6n7KooZbay2m51DdzsyJWmuiBJDcoZsnN5m5auht8SDgSpTOu/Jemaaxr5G0kKS+Grrl73u1yPDgz1dByvro94B5TQIma0KAOLoIKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050202; c=relaxed/simple;
	bh=guDK4ipqit1C8gOrnrgRAemtCZfSwKUDyfH3BgXFvz0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oRSXP68VI2oOA6wfcT3XL+w4DJ6gFudpaPs3FehFOQJMg3YDS4DJ2g7Spl//XEkHyijsiyYQRtZrO6GuGGwnbNX3fdmELGtP38MOlQeNVGUwjpMGkqQWNtGfoySTAOFDm7JzUwzzdSpzAEuDnK2Zzuxc0mhM3Qw76JbwLg+8etw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CApnRc8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CApnRc8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ACD1F0089D;
	Sat,  3 Oct 2026 17:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050199;
	bh=guDK4ipqit1C8gOrnrgRAemtCZfSwKUDyfH3BgXFvz0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CApnRc8tlNHkyKJVXjdW2Vf8xycjuADWDD+AZKenodzUWijzQmxz/GJpSLPCYA0Z5
	 2UQ1LCZGeNc/dG+FdF9RCC8yRXgXQ3PJLk8xW+7qS1mz1beo+O77bVjjjryen5TgM2
	 PZmF8D11V2KnstGIfnfvnsY19K3cAS2m5C/s8U9/0J4cnPH2gUjCRNLva0hC8wIg81
	 5drQfXuO3+In0FhuwrfGyGyRtqBZZWAHlaDT8fZNGZaKdcPnHzz6vsIU4xd20ZoPIy
	 m0TtjMz0fGqEoh6XlQvc91+qD5rfR71SO74t5ek0zf3OozIKsEzjOT4Jm3zmnP/ha2
	 e8FUJLfVuziYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/38] mm/vma: introduce and use
 vma_[flags_]can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, linux-rdma@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-2-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-2-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:38 +0000
Message-Id: <20261003175638.A4ACD1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
> two new functions vma_flags_can_merge() and vma_can_merge() and update the
> merge logic to use the former.
>=20
> This abstracts the check and expresses it in terms of the desired behavio=
ur
> rather than an arbitrary and confusing VMA flag.
>=20
> This also lays the groundwork for making further improvements in VMA flag
> usage.
>=20
> Also update the userland VMA tests to reflect the change.
>=20
> No functional change intended.
>=20
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D2

