Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203E64A1399;
	Sat,  3 Oct 2026 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050233; cv=none; b=Wwyvdtbjt1Meg0J//A7UbfetbH/JujdDF4nbSi0PIc5SsPHj4YLr0SCN0wDf8sk8+5GcjbVofxYRbOpzpwuQEM6K2WeypDnlFxgzvkmLj1Bw2m/4gZrbx/TMS9Fmp158eW9k+vl5GWy9CyyGhFmww3nv8pdtqL4P4LRFjRjExcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050233; c=relaxed/simple;
	bh=8h4tuJTv3NW1SzOFi173ubTgIepYCAu1HbVvRKWCxdo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kB0Y0v2MalxyNDYPd3Atnr1uBL3oDeEnxMJlzCxe4JHNrB5od0zOvvnqErs3TQQjEviTpOCXOHfyAYC56WecOiu1NgFSBi17FB/PKN2NYFq1uCaPp8iCKtDn1qOEy1HR1DDllDfq8k+xGsLneH5Hz+cqUPghBMW2/l+0cizzv0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UND+Awsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UND+Awsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CE41F0089E;
	Sat,  3 Oct 2026 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050232;
	bh=8h4tuJTv3NW1SzOFi173ubTgIepYCAu1HbVvRKWCxdo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UND+AwsuBMBdmW6gj6mziA913gg3gdgdPu2jexWyhTl0Crl1UVChoP9iwdgoeZM5m
	 D9nPft3MdfLSH8q2EtQJLJ5YmeyPTuhF/aFeKF/Ur5PoUoXEWnbko670LLyGettGpl
	 HzQJTt0PwBqMhSc03K9y8e4Gn+iBIgsJhs4SG2v0gf69OcR7HzWi+dcFiMNJE2K7cr
	 D4NWtUfPg5IpHS55hNoRjeus4Ul1ZbWLgVMbUjbUG2R6I1g6EgQl0jLmVp6XteBnbK
	 Wic7H5FjmG9m30pK+3AYKJM+MA7oFXAzoFyDbbtfGHAU5KJhWH9cISebmPvBFLW5dk
	 k/G2FNzzC9epw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 31/38] mm/uffd: use predicates for userfaultfd checks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, bpf@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-31-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-31-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:10 +0000
Message-Id: <20261003175711.39CE41F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than directly checking VMA flags, use the newly introduced
> vma_is_mm_managed() and vma_is_mm_backed() helpers in userfaultfd
> when assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
>=20
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
>=20
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
>=20
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that mm-managed mappings may not set
> VMA_IO_BIT so the check is now redundant.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D31

