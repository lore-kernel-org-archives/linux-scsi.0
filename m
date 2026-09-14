Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A4A3E557A;
	Mon, 14 Sep 2026 22:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424092; cv=none; b=RvDRO46myvC+VWH5+IPvepm0VgWP2DdRGQwitA6hMqFo1mm3F2hrgCUTIQ/w7Ya6Pp6vF2bTfe00YLrIQd/vzJYcsnAjCQxHwnRtZf97jYSYcgde95g0W9mPC5CYSpstmK8xbFEMVLZtp2DBLYwOvEY2rlTce/ces/f2/amiEcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424092; c=relaxed/simple;
	bh=UeV2qKj6a5JiunFbkJWDa+hcg+Gm/8y1LH3SVrplud0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a/prMp7G8OecnGGuchauKQ1pOn3FOVE9eLmigGs0K0HWMpzYuJh+2NOOr9RkwAAKQOyVDLg53sHkcjC9oFcSpRKwb38/wEo0vUa/QTaJq7qLs9MOoDn+1y7Dq26U8XEH5AS5V7HP4dn9e9JS/hziYUnMWCw5T3bOJvv9iB+DocQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6S3ZhjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6S3ZhjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A33D1F000FF;
	Mon, 14 Sep 2026 22:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424091;
	bh=UeV2qKj6a5JiunFbkJWDa+hcg+Gm/8y1LH3SVrplud0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a6S3ZhjS4mQNpCgM64uTocjS2QuX4ZICv71v488xnZuYOyP7TK+WX6V1Z/9NTKUDj
	 Pw23iOFNoGjnyuJbN23LBBlHr+i+PGEH7a+oTU0+ug/VyKCyIp3yCzsOAd7SO2Doc7
	 S/90pyaz0Nfr4KtPg+XykNpg+Y4RzBVtRdbX7tb8U2sK8tO1tENJDjZDtTmFjb9aHb
	 RkiA9UX2HddNCqoRXCCtm683kIRDtHRxnXGQP1qbuu98shbrSJJRaVJWBGZmVUarfu
	 u//l4paZKMTFPyEpCWEQfDUxQ0bYQ4/YeLDjetF3LDSBMM1BRvoX90kpovmGnsS6t3
	 jIod3/1TTyHsg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 30/40] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Marc
 Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, selinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-30-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-30-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:14:49 +0000
Message-Id: <20260914221450.4A33D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> We currently disallow the installation of lightweight guard regions in VM=
As
> whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
> VMA_LOCKED_BIT unless allow_locked is set.
>=20
> hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
> VMA_SPECIAL_FLAGS already sufficed.
>=20
> However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
> is set, this check collapses to being the equivalent of
> !vma_can_merge().
>=20
> Update is_valid_guard_vma() to reflect this.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D30

