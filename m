Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F06D4AA3F6;
	Sat,  3 Oct 2026 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050246; cv=none; b=nPzKsm0tFkDS64woY+MSoulkr49zC6nNMOmQNXqVuEWKTX6DCHu9zpIQoffw9EJ0/pS1YTsqMn+pSdUlZQKQLcKGeh8agmFXDAWMEON7eTYV5lcGE+5XvFuQqWHVhq9M9qAa6qScJEwZOzcakd0T0joTsX27nMOA6X2wbY956Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050246; c=relaxed/simple;
	bh=RC989HcI12wPyOanWxIBD7MOcc65XB3Vn73cbeKYUO8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V2Xnl+ZL209OtRzvMT4QiZBphP4YGOghBqS3idFg3Yo5JHts71JLsiEKbpss4DPHuj3+RM5D1bKfsmUo4UywKWJl+lXX1jbVm+v5sAzKoo0GsZlOJ1Hw27U9tzuFhj6LR+LoKvM9xRPYAE5eH60WCGIncnYjATeDut0Ujc5Bn3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2WF2DVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2WF2DVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B021F0089B;
	Sat,  3 Oct 2026 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050245;
	bh=RC989HcI12wPyOanWxIBD7MOcc65XB3Vn73cbeKYUO8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K2WF2DVjiC8L1kPZ54UxDD5eHjxBabtTANH5an1GfV6t6jTmGvOxU6KJG6zQKCejW
	 0WiJkYypgBhUcLXN2OzZxIK7DzJz1DspyPvG6YxTrNDbLWoV/eqF/X5s7Mc4QrkjdV
	 +f1f5zletnmvEN2WG+66+Regx3w82JzYk5TdvvPsGOmfGoGHT+IiF6H4hZQdaRbBY3
	 Feiw+L6a7dvqJ3oV4gvIOwd5tiSWXcX+MVb1hLcqoBYPLpTgeT0/xgC+eHT9dOmAtd
	 vDk60pFydgLEsAmmcjGny+rKdj3qhmpcYXBadwkJVyqCTtqV23kadO+euiZMI/6BsG
	 gON285uyAdURg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 36/38] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, selinux@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-36-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-36-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:24 +0000
Message-Id: <20261003175724.A0B021F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted =
to
> predicates which explicitly express what is actually being checked for
> rather than the nebulous concept of possessing 'special' VMA flags.
>=20
> In any case 'special' is not so special a term of art in mm - it includes
> VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
> other cases too.
>=20
> Therefore make things less special by eliminating these now unused flags.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D36

