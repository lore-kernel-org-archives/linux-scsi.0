Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675F53B7B8B;
	Tue,  8 Sep 2026 20:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900024; cv=none; b=qFeoIa1lZgC54NEC2UIEvOaRpLSomjMrhdcijQTI6d9bZmtMjW6yxm2Z/wgxU7qZJZ8RjvYwEmu94XR7h+GfzrfRYvg5OvXRwjrpQ4nCeCZ+MBW/GIGfCOXs49HhgduvXmO90EkhdWA/CuMcKwagM5YUY6MbElyuaAlIEOkFt7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900024; c=relaxed/simple;
	bh=NfxFEqWgzsyysgen68P0bT+LbvYNMhsQXQuYa/vQPVY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cbDks3R+BPRdjHYuweJdhusoqa7vs+K813Sgm+F8H32rkUR3zG3BHCbs6TQTyN/v+ZCw9xHsBFYBzV6NbaaH+hnum5SXGGOkKe9zEKcmsDsOSCsRpgYf0TTWfI7FiWe9eErpDGQkO31L+YSEh5+6MS1v/kCILzdXidxCCOzdynI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GW6lmw0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GW6lmw0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A2A1F00A3A;
	Tue,  8 Sep 2026 20:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900023;
	bh=NfxFEqWgzsyysgen68P0bT+LbvYNMhsQXQuYa/vQPVY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GW6lmw0P3OMZhlc8JcIgfSAwLKcsv0dhgMYQjB0UkBG5zLccK7KZf2vwriCI77e/g
	 dP70BhWNJpeJ2Ld4RGVE6rEL4o/1UOFIyonSTb/+Zzo2YIz22Q22tP/DlTtIrB/u9I
	 ctCkvLlbAolPJ4wKMOk4UKj1ql6gO3F6abhID0H7z+rhQ1wECStOwu8TMZ6/zQQcmE
	 EyWef/lbJwYWK1AjM/rYf0SnL38+yHlaYMnh1r7rMPQA1bx4hsKy61XL8MGX+X8GEZ
	 ozipCaroIWT9XyvcaIMMh3h6DPcHNeo34XyOls3its5DnEuLeNeY3p0HDVeyAhoaAZ
	 pJHpPCb0Kxt4w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 27/39] mm: rename is_vm_hugetlb_page() to
 vma_is_hugetlb()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:40:22 +0000
Message-Id: <20260908204022.76A2A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> more than a page and it is inconsistent with other VMA predicates that
> typically are prefixed by vma_.
>=20
> Rename to vma_is_hugetlb() for consistency, and while we're here update
> some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> oopses.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D27

