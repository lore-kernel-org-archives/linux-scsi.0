Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E4449DBAD;
	Sat,  3 Oct 2026 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050226; cv=none; b=pFhs9mnXwDW6z3z+2+gQKitwJ3Xypf8y3xvURsrUzkwt9K9p4PiePVpS/FSzKphHsHmV2l2/P59+az/zHbG171+qchXx9R1q4/c/p1gyL84olH3Zgt02NESutN4+tworU+mnHf+K9iyu9v4JG3IQQmfI9lhtMAcbWcKNXGuxWio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050226; c=relaxed/simple;
	bh=g4yv4w+IQEE66nfDK6VQ322rv3viQPlezzmFOWCs+Yc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kN/BVQhsSwKt9TTnxXM1/5iVVszZ0sq/qM4yGdasE/3/otr3+ZHfGjJdvTLB2A83YmdMBwcfBSME+OurDZO8V3qLHeVodqlk5wxIFiwUn/+q5SvcK8aoknPxlWaZuzHa76ty4tDaY31ScdUWz+fM6UYDk5MfmZvW2JpC5/6NMrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLtn1Iyk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLtn1Iyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F5D1F0089B;
	Sat,  3 Oct 2026 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050225;
	bh=g4yv4w+IQEE66nfDK6VQ322rv3viQPlezzmFOWCs+Yc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FLtn1IykhxfI6UNeG0jKCeRlPIBad1zd2WT0Thvi2sWyauxm8OMquepIfCfzLsU5B
	 PYRFzQdPhG28mxym2uh49IX4Bq9Zydrh7azxqj+Q0BPurYMo15rsE5Xl/fghLVhSqT
	 +5XQnXtRSBcBCU6h5m/1FKZiH8K3uyuiDVVyZcYue9Xp3Alk3ghXeJmF0Uhu2KsdMr
	 dxJTK1HT/9+OSB2UE9RPmpJvfGc8h7RUhYdWfF2XAb+7zyEFMxy2Baqq9aOnSLQa8J
	 LL9Z0yG+BO3xJn2Z55PwC6dxDKAmhHEsEVXTXV8fs+c9pBDQdJ8/7YmAMiVhYRIM+B
	 Ez7OkH5ieZvVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 21/38] uprobes: remove VM_IO, set VM_MIXEDMAP for
 mapped kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-perf-users@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, bpf@vger.kernel.org, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-21-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-21-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:02 +0000
Message-Id: <20261003175703.17F5D1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.
>=20
> Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
> the appropriate flag to set for those.
>=20
> This provides the semantics required - no VMA merging is permitted, but
> does not prevent GUP.
>=20
> However this has no meaningful impact as these are refcounted and thus can
> be GUPed.
>=20
> A previous commit already prevented __mm_populate() from being invoked on
> XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is =
no
> longer required.
>=20
> Both VMAs set a VMA name, so always_dump_vma() returns true before
> vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
> in core dump behaviour.
>=20
> Change this for both the core xol_add_vma() function and the x86-specific
> get_uprobe_trampoline() function.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D21

