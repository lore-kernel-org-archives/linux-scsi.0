Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7EC5158B1;
	Fri,  9 Oct 2026 18:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570899; cv=none; b=A1siS2wkWPd2ueCXu5CEwYt2JVyCtOn3b1S2iUxxaWIvnfTAjIwCDIeYg6uIuzXaLxhf4s5TzPRmCq4i8VZjmwlVazqGdwNFqlDLFlUA/kp3A6JVtT0QtS7VJjMwey1hgiZ512txbTBowfKtPffdf7OJxn8sOqFHoF01UL5XNj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570899; c=relaxed/simple;
	bh=ukJJhCUpy6ZAQIKANWi251pWONvGRx1MC9S4NHPidcE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YP2qLZturR533xq1UkPPfxtfOQjkvoUW6hq7nNhsVKPKYSkuCrKFRS8cWiAVfmuMgMLusx0/jAHtBOacmFQbh7cWeZmiaE6NMl5DaeGX5y+vDqeFzB+Kw5hCcbUIFHl6sF9uvj+FW6wkLJWbu/mW3mhNdxDTSdVzLoYcJqwIz/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCw/4jI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCw/4jI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832AD1F000FF;
	Fri,  9 Oct 2026 18:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570897;
	bh=ukJJhCUpy6ZAQIKANWi251pWONvGRx1MC9S4NHPidcE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oCw/4jI6s8YnDpOPKOjVp6M3uJgVEhX0t2pFHdZ3rrpz7UU5Sh/9Jz2AAYGebMARe
	 bQVhZFEMjLE/97M5fy2rq6DB1sYmVVi6nLyWPol9AWmgQ3aiubLnrUNEKgWkGwwHsc
	 3QuYxl7hc8BqzVJeIT2dEduchgqTYfNPniwNOE75u7OlOCUqzZ5oFsZRx0KwG/kNo5
	 pZtglswmdx61scyVRUZssfRoq6L9WfK5i9oCwHHTWi7ws0cvMcnxnWycVwWxIHQxY2
	 GcOkmoSykFgpDfaRpyVhft+YBjZkHwpNijSIIfKxo2J4YTE42taXp7PI7p1OO+3Tqy
	 M4ceDd5shQFPg==
Message-ID: <sashiko-outbox-165953@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 20/38] mm/gup: error out early on !VMA_MAYREAD_BIT
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, selinux@vger.kernel.org, linux-usb@vger.kernel.org, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, dri-devel@lists.freedesktop.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-20-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-20-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:34:56 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
>=20
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is no=
t.
>=20
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
>=20
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
>=20
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
>=20
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D20

