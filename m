Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3392355055;
	Mon, 14 Sep 2026 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404643; cv=none; b=sLyfoWV17ZrppJ3F8GU6UMnHhSW6cqZqR/7+ll3lLoB1zpzB3y6/1aHaV8zN2/CmRddUwAXakDsY0aUCa5wPcIfpP5BxHGkuVZjkLj+viG68fikNsvnVeGeCMVIAaQ3yiJV4klqNgghH8B53rHm03oAVw7XzzuRXna18mVDDX3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404643; c=relaxed/simple;
	bh=fMHfm7FZeGf7wenZpfJYeYn6PjNgUU2eSII5RVcR2D4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cSjoXs4b9V1Sl+K+1qkFoB9X6goo1s7hp2dBjCI4WiWviAP7RWH4Bz2AdcYd10ltqrWEJ+tsZRFP64BYwr6L8kg+ulAdbxDLzTeWDlYC3SHsuuNWj6aZOXIKS5AW4LHVHs1P5vxWCJmCKTfyFhkydRffvoBHp/7gkygBlW9bQeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MbEpcLci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MbEpcLci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E641F000FF;
	Mon, 14 Sep 2026 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789404641;
	bh=fMHfm7FZeGf7wenZpfJYeYn6PjNgUU2eSII5RVcR2D4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MbEpcLcidWqFKrf9SNVAq8W2H0C9dzhHr/GINcnFsMH73oPTM4hbKmq98bj+S/5hY
	 QOi2Y9BIuK2+E0/dPXJVdQ7+WAhl/0oWPwH5+V1rUakRIjkPp3BcBqqaXW6QppFGlR
	 Em89N7BMuwlk6fvhD9XC4ol9sI6UZrzEEn6qNb1KHMTs7W2T5izJ8hWMZb+0e6Kd53
	 CLspDFzi5SGtxXNIGYxNV+0kjjgcue/t1EoLVaC5+RW/BaL7XNUHD+cKDWjAOEfSCK
	 kALJb4S7b9n/kUTKFaLgFRtYcIoGpKAjyqgTvgJ3CdxOB9YIihbYhPlcV4acKqcaAs
	 EyL/QhL8VkbFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/40] mm/vma: tidy up map kernel pages enum values
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-7-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-7-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 16:50:40 +0000
Message-Id: <20260914165041.01E641F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
> MMAP.
>=20
> Also while we're here delete useless comments for mmap actions whose names
> clearly indicate what they are for.
>=20
> Also update the userland VMA tests to reflect this change.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D7

