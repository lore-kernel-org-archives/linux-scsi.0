Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1F0497B62;
	Sat,  3 Oct 2026 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050220; cv=none; b=Ccf4hnJyzzomC3wFLdBFmN+g/xEarNxjdiRvfvtnItU1uZLTLsW+0cbGSNAYbeNNEtSWm7UoGmBDFJnJzAsY+xeUl1vppZteobsMjwpvPmuT0Or8t8xKtSId9Ep5/uSLkPtFqd8tTA80Ctb+MfjWIwJgHJWOHW4oLSXg4dY0tBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050220; c=relaxed/simple;
	bh=lMqzGrevuZyIV81gMzODrgnDDgMMvoPZvVHwfAQZtFE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TN6uayHqvFFRXUFZVbC2cQ053Z87JOxqcQcWroQCOCeKsu7o6VA0cVCkqjScHO3S/zGE1fENQ435XXIRbzi3cBdbJwAwokn+ybWt+qDngTKEBhTrGqIM5GZPmf+nM0FDne+GxEVdh4qJWsNSCrLTmyKmk6uHBPNW14OS8WD12qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NttK/9w4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NttK/9w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24A41F0089B;
	Sat,  3 Oct 2026 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050218;
	bh=Gbkz6lysJZG+gRhNdZptnnk5NkcNW5/sD7L6CC6y9Ns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NttK/9w4BHpjOhYN6y8pgBdvIUfLPncG0fWvlMgnQYURg9i5k51mx4Kcr5gAl5M6b
	 lLWxb8D9bSmqPj/QfE6k2Py5DHbEX1GOXeacUjuCS+93xWKxdhua8GRveOdp7zRc0e
	 wZtwqk/3yIGW2PNKVvQpsBFqOESZUxn/XkeZPey4rs6Zlrwze4q/965ItxjXtnZ5xS
	 vqsPVsKk7IO471IoeT1hz1BG/ZQVQMMcbiXxJlpvU6vRA9NyUKWaqyVJNwyA10WT5y
	 P6gfIkwvtT+ln9XXsd5WX859XMXDHq83iQwQYnhwGZB5lQiA5Rii8arE3TpvHyWeAn
	 5efghUeZIHdTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 28/38] mm: drop some redundant checks around hugetlb
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-28-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-28-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:57 +0000
Message-Id: <20261003175657.F24A41F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Adjust code which inadvertently perform redundant checks on hugetlb VMAs
> and clean them up:
>=20
> * hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
>   suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
>   the series, once VMA_SPECIAL_FLAGS is removed.)
>=20
> * hugetlb VMAs unconditionally set vma->vm_ops, so they are never
>   anonymous.
>=20
> * hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundan=
t.
>=20
> While we're here also drop a VM_BUG_ON() which the simplified check above
> makes unreachable, and use the new VMA flag API.
>=20
> No functional change intended.
>=20
> Acked-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D28

