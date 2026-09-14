Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A923A1A27;
	Mon, 14 Sep 2026 19:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789413851; cv=none; b=BhoQ4w3+cmRrSEaZ3EH7pIB6J4whg0ysg1XMuIJhKtkrYqhQR/w7IvseUDeHXnwOTkmUrSJFuR2Az0XB/Hf2NbwYODFjAazTd1xocv1e8VERCc7XTSxMc1pNs50DPLmdO9OicGWfBE6TTG5Utn7RKxC3I9N7pa74f3aOcdxVY7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789413851; c=relaxed/simple;
	bh=xJpm3JAnB8d92cWKo19WITb8mjLY7j6aTd0s9Ds6QEo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qRtJwwsWNzRDpBKVc09JC+tzc7cYTCLoHvgDRxRSnNod0362rlb3DMvl/Btk2+MvH5EDnc/X7XocEsGX99VTfg0x1iHKi53PwO+05EntiCDm5428B1Spz2LTjBHTdjsAABfZmV/hw4Y1JKLnE8vSGr2XH9VfMD0WG89q8/W150I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNoO6tTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNoO6tTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D545E1F00893;
	Mon, 14 Sep 2026 19:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789413849;
	bh=MQrbdO0wH/PI0B6eEieaZQZoXI8OMjTrX4x3Lp4/KHg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GNoO6tTUHsIjKiPXdPxlUal7Gpqr83iIhNmWVv8nEFxqQN0dzTrw0hZ7HLaOxiJel
	 K6mnNbHznYWoAv7r0ZmiJdIf0GvQOWA9ytKaCmW+cQaF9tejJsvFpNqOpWnd32cW2e
	 tgke/jJrOfX6uZe1NHLDfaQOcmNkeVmwTUAxl7HG24Xg4/pD66ss3HGR6gyk/myeA4
	 yo3gI5X7uXCPWMcRMnjK4szuIlJZfDaCYKwSHWnsu7pp8tj+4PMwEFsTK1jHdiktG2
	 /50WQPVXMMCaMxkZVBcf5eHdcc/W8GtueIgWBVdU7Z9FFQGLTF/ORENGYNfXL158hh
	 V7jAPjfCdMvSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 17/40] mm/vma: add and use
 vma_[flags]_is_fixed_mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-17-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-17-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 19:24:08 +0000
Message-Id: <20260914192408.D545E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Incomplete refactoring: vma_flags_can_merge() in the VMA testing fr=
amework (tools/testing/vma/include/dup.h) was not updated to use the new vm=
a_flags_is_fixed_mapping() predicate.
--

commit 11aa075e5d40e13021c110a6f4f112bc2d087fdf
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/vma: add and use vma_[flags]_is_fixed_mapping

This commit introduces new predicates to determine if a VMA is a fixed
mapping that cannot be expanded or merged. It updates core VMA merging logic
and mremap checks to use these new helpers.

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cab29d6e15c14..ca598e5f97154 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h

[ ... ]

> @@ -1671,7 +1702,7 @@ static inline bool vma_flags_can_merge(const vma_fl=
ags_t *flags)
>  	if (vma_flags_is_kernel_owned(flags))
>  		return false;
>  	/* VMA explicitly marked as being unmergeable. */
> -	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +	if (vma_flags_is_fixed_mapping(flags))

[Severity: Low]
Since this patch updates vma_flags_can_merge() in include/linux/mm.h to use
the new vma_flags_is_fixed_mapping() helper, should the duplicated version
of vma_flags_can_merge() in tools/testing/vma/include/dup.h also be updated
to match?

Leaving it out causes the mock in the testing framework to textually diverge
from the core implementation. While the logical behavior remains the same
because vma_flags_is_kernel_owned() catches VMA_PFNMAP_BIT, it seems the
duplicated code missed getting this newly introduced helper.

For reference, vma_flags_can_merge() in tools/testing/vma/include/dup.h
still contains the old test:

        /* VMA explicitly marked as being unmergeable. */
        if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
                return false;

>  		return false;
> =20
>  	return true;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D17
