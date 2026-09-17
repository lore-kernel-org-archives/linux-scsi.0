Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938344D17B7;
	Thu, 17 Sep 2026 17:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666023; cv=none; b=tWb2GFeRSSGd6N2kY4FGiN1NZSmmeZpUgJGz/n0Tdke+BwPUvQN4wNfIUBOkN2iP73Aw7QSd0nhvwRIgBYCtlyYTZclizzD9Te1dPa8XdB2JkMiTM+8q6KRGSVW6AwvhEmB+e3qVTEbh/6/T+JUe/W7JsueWtRL1Uz3vdeOOajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666023; c=relaxed/simple;
	bh=v3UhQiz8AmAPpRrxRLbtp7TQEavk8vTuQrUPBhxh86M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K025cbtP3OKZUJWFzeljdL3mitOp8PUt20DUfVVXyMw2mI53+E3LnQER3vikWtI6e8ptv3Yu7RGKZfiJRlQGYhdxiEO0laaPDHnAlOGvwijXfZJXAle3PpnjTc8ugBWVwPDANkG9SjcWlvBlX9wuiJaA0HSoM1X2gJ8wFjjVCsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvKvmVZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvKvmVZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78B31F00898;
	Thu, 17 Sep 2026 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666022;
	bh=v3UhQiz8AmAPpRrxRLbtp7TQEavk8vTuQrUPBhxh86M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bvKvmVZr6yKb9k5x8WN66FBb5S4j9VAooeVfDl3ium8lWLtKGMhw+8W92VuniDYkA
	 EOGA9v4lMsJ4u2IRcWIvzO0lGGIRrUSrdM28KEkz36OUMx1urslP2weE4JoDVXaL4z
	 RKw4JcsWqOQ2DJU5hvvV72RSGArPv+G2Sg4+KlcUZRxsAJhhdt4cOxfYGvtdWM8/zZ
	 j9IshvQyo43Syy0iuYNu+4Wk/RbgPiqidot1s4XrcMXOdUmzhyvyRJiv0rFtC3HTg3
	 Bek9TVk3R4xXhf5uS+F9sBwuh9m3i93nFew4invO7M6hIUsPpkUBF6fmur9wAUAgEj
	 H53ndwe8a4dHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/40] mm/vma: add and use
 vma_[flags]_is_fixed_mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-17-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-17-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:27:01 +0000
Message-Id: <20260917172701.C78B31F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> This determines whether a VMA cannot be expanded or merged because what
> they mapped was determined to be a set size at mmap time.
>=20
> This typically refers to kernel-owned mappings, however VMA_DONTEXPAND_BIT
> is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
> must explicitly test for this for now.
>=20
> We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not =
be
> set for VMA_PFNMAP_BIT's despite the one implying the other.
>=20
> Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
> mremap logic testing to see if mremap() can expand the VMA. The criteria
> for khugepaged and MADV_COLLAPSE eligibility in
> __thp_vma_allowable_orders() are precisely those for mergeability, so use
> vma_can_merge() there (with an expanded comment).
>=20
> This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.
>=20
> Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
> VMA_DONTEXPAND_BIT.
>=20
> Also update the userland VMA tests to reflect the change.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D17

