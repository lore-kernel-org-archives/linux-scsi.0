Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441AF3A8732;
	Sat,  3 Oct 2026 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050211; cv=none; b=lPBwGntm/jM7h9iD/y/8Z610CkvKeY9H0JPHFxX4OvEFKRQ3XcuLnB+fmpOvdpvTbtNoQoMAfW6YMF4yLrHIkn0SpT3KBPhs/Znw9kPc6wpfaf5XPXanc09RPjJcE23TnF2+YH2MPJo3Rr1NxVJ2fehUUVsQ2TdOGY/TeFbDduc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050211; c=relaxed/simple;
	bh=F79EdhQDIa5J/GDSfxMqJXg3D3l3+KznnazyjR3v5m0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aL657HgvswHtxrLN3AmhmmirAywUjIlApYqEcOpOXL71J9iKID3toCohuQDwHaVRia3UE5yC/AtHDyd2O9ydPOhN64IWGIJfy+z/bCBBvfh2AeusZ017gP6+VixGtwOLTgYIEEMViAjt7h0EN49K99RtSQp6ZOt5YNOphfnn73I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0txGX9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0txGX9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EA41F0089D;
	Sat,  3 Oct 2026 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050207;
	bh=F79EdhQDIa5J/GDSfxMqJXg3D3l3+KznnazyjR3v5m0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F0txGX9LdHZC0b5XiS0jHGGAh4q3LJ1eple4n7gumsiXsALv7qJ84uhVWCk0aClxB
	 wNtGFlcVhyCVdMoZcv+NSPPadMLpTqT+GtqD/WbWv2kogK8bS0IKUtjghFWPBU8bih
	 STyqxTAqgyfGXnRGC0gNZ2uX3J0XQEqDtxAzVDVutS2SK/FfT5jL5Dm58fx3+PLynF
	 DlJD+yd2I/rEGm/zsVPLxBmQzOXNa6NfD2S4YcXB37oIjEJWYb1PjZQ68g3iyIigP2
	 Uq+ACYDE7fQR3Kg+d0/8ZYxQUv8isPbYd4zfV/gs0kPFihVpEmbxMC+D/9kd6OriS5
	 duk7FM0z0IJQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 04/38] mm/vma: ensure mmap_prepare doesn't set
 actions on a mergeable vma
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-4-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-4-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:46 +0000
Message-Id: <20261003175646.B2EA41F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> When a user requests an mmap_action be performed in mmap_prepare, this
> involves populating the VMA range with data.
>=20
> However, if the VMA is mergeable, it might then mistakenly be merged with
> another VMA without having populated the range.
>=20
> Every mmap action currently available sets VMA flags such that the VMA
> cannot be merged.
>=20
> However, to ensure that no future mmap action falls foul of this, assert
> that this is the case upon mmap_prepare validation.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D4

