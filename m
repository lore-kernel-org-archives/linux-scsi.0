Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143B74B486B;
	Tue,  8 Sep 2026 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900352; cv=none; b=kK0DTiWZMFWuKv2EluDMZv2b4COHh8+BqZ7Ajc4+nAoTlHbEb4kqacZ1zSS/KWFWvVq0lMTuubYZ3Nn52EB4Kk2+6goWqadOMSqoNk40bCpqoIBT4XyFaQT3OvLs5RigD/Mp/pTq7npSsqI2QaIo/TFX6/iFW4MG+lv3K6aF0ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900352; c=relaxed/simple;
	bh=zf8obVmNBMr9E5yKj4xDD0P4g28xfJ1NNsxHNcAU2tM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZnAuJGz8f1XL3iM8rRBJtU6ex3a6N6UvI2q5ZXkGBswMGrtRIsYsRZ3OeLD5MpcOG0bjM2YQMlZV8aTqXv4zhEy6E75LIhaijEbtuRStzJMR5aZWOQe+x+YoBQwPshc2YihcmwAEWzTjpKw0KidggljCRtHgetHsM/DdHirMg6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qxqqumte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qxqqumte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BAF1F00A3A;
	Tue,  8 Sep 2026 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900350;
	bh=zf8obVmNBMr9E5yKj4xDD0P4g28xfJ1NNsxHNcAU2tM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QxqqumteZwtRbhVKHO5f6jPLWVXdCz1ACagil+LPa3Qu9/bdPj/HuNqLdE2r5zYDs
	 TsYIblFff3a4nDIpsHaSRxmHDNWpZ0E0vK0sHUh2Op3Ru9ZN18h9KWNqOyVKkEealm
	 RWkw7siXHeznRjMcSza4NxFv8fdY82NQsAkYXpc7t95fFNiGy8hlp5x85sdIblh4Ah
	 xsOBVTB7Ms55Clk2/oHh6bfTe8i0OupTV+MyLBUK7FfBm86RA2GeqhbG/0PqXZmWM9
	 UpgTpih5wCHkX4HA9UyijvlhEeetbdXD7BCSKfvOqZeeG+SktbuovlQWFQsf3iRqpR
	 qiPsneA5dNP+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 29/39] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, selinux@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-29-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-29-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:45:49 +0000
Message-Id: <20260908204550.00BAF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> We currently disallow the installation of lightweight guard regions in VM=
As
> whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
> VMA_LOCKED_BIT unless allow_locked is set.
>=20
> hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
> VMA_SPECIAL_FLAGS already sufficed.
>=20
> However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
> is set, this check collapses to being the equivalent of
> !vma_can_merge().
>=20
> Update is_valid_guard_vma() to reflect this.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D29

