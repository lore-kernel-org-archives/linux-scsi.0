Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70896442FBE;
	Mon, 14 Sep 2026 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789418008; cv=none; b=W4n1Gi72IYlh/wPKSGXMegsqFJVIkLoYxVUZJkNGirjBaX274TlDIUsSvu6zDEPL6xpWV3N4V7ckBnc5z7qv+0iTN+l0FVkEFdMRkx44iFy8KGCUux2eEfzdlTg6l2MVu7rbWZW23XNM3W+MigBIET6hpQYChmv8tjwD++KMOZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789418008; c=relaxed/simple;
	bh=s2mFw2wtqxr0yCUl07my9NMd3YnR6498rqp607KPz4g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KdcSVeNknYxTdRT3b8s2lO1bbrqWCM0X/kyS9A3GHLWoKHxocjCOYrV6MVX6YMZwqcxddUs8EVR2ClHFm+lejv6jVlP/lBSwkuJmLIwuIcxO+qrw0jPPQwPlMDupetiHxpdufY2UCORCDyV/oNSl6/lTyHwJGhSVKI9arQoGwN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUW+ecle; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUW+ecle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542D91F000FF;
	Mon, 14 Sep 2026 20:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789418007;
	bh=s2mFw2wtqxr0yCUl07my9NMd3YnR6498rqp607KPz4g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cUW+ecle5oNAuY7aEZEZt07v/VlHF+hyBtKnNLbY88MzGxIfmlJl2hpk8Xl0CZyvq
	 6YPkgoOygcBTZL9KMnHYgFCiySsyNwS+nYwtLy+e+hKJzfJEEtb5qJNpbYN284Mzyh
	 poTjBVztaRCr0uuztI1OL2x3hIMHozlNtQSMoP4IMDfNha8EF9pvPCUt0OuXgNZsWZ
	 WeItayAcJR9h0PeTMByCxPaltjmAsNJIOsPS4h9G+l48lEIHZTyeJ9kiCRg9IqvYRt
	 kjcYexNigshMaisV5t3ibzMTRF2kaH4DY245Ad+t9bycXF+hnYrVtMBcyxflk9zB2F
	 NAMSpbPvXxE9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 21/40] mm/gup: error out early on !VMA_MAYREAD_BIT
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-21-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-21-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 20:33:25 +0000
Message-Id: <20260914203326.542D91F000FF@smtp.kernel.org>
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
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D21

