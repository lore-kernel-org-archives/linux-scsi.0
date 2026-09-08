Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8BA3AFCED;
	Tue,  8 Sep 2026 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899252; cv=none; b=JsUERyzQe9lAKFjfEiHG2YHF1NP+AAWaMwH4zIKg+31WOZ++r2tJ4yNEcmxus5S+wm5SMAxip67Jm41s6ROIfgGUs9HK4bhCT1gOsTOyyVeVmNfIKpNx+tbycOL54dLPrEtoFTg5+cdrV/ehc6NcEAtHi0b1xzV85DJGqaRvWpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899252; c=relaxed/simple;
	bh=knPUMGPnqC15TKEwcjLwB4bS1neKjXQ+prhdgeJCVJw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D4DlByulTOzwW3MPLQ6k5csEWbJyuhNkMrdExR6Wn96wDqy6m3qJwPvLJzLtnqnK5+x6JLuF5YGFH5igDyMwwINZ2g3ymIfUaZYNWkpctRNkj/tl7SREjd+HzMdmV0Nf6KH7YQFc0Oys6miFzif6KS/KvvWMWtr9tclbs65g81o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hn4Vibo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hn4Vibo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4F31F00A3A;
	Tue,  8 Sep 2026 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899251;
	bh=knPUMGPnqC15TKEwcjLwB4bS1neKjXQ+prhdgeJCVJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hn4Vibo+Kj2gkfvEu3PAQ7RXogzStGrJlOtOCVNZ4PNZRO45Je3n/yPMcJ1n2uxEm
	 78bACCaHSPYa4LN91HlysFTHCclq8I26G2GSS1aYsK9lcLZj3Rvzz5wDwoGrIlanf3
	 KSBryTV0bPiJe8DnmlJD4gbPPw8l/8x8Ve7E84Paes5fs5WrCw/rupe4rqyqsJ4Vdf
	 zkx6x6s6atTOhB0ggjKdPK8FOpkgVT1Lw1mB9cTGPRiGfKRwdhZh62rN+cn74ATMJX
	 qb6MOMhdpfmlpAwdaxPGt1qv4tfZj3VwsBBB16CaxBsj7OfSyi4CUh2nxjCDtNo6xk
	 LgsYk68ZcUTfg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/39] mm/vma: introduce and use vma_[flags_]can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-2-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-2-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:27:30 +0000
Message-Id: <20260908202730.AE4F31F00A3A@smtp.kernel.org>
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
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D2

