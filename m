Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A900502D6E;
	Thu, 17 Sep 2026 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666337; cv=none; b=AtfBl3x9BdF9DPuz+Y+1YAVzH8heN3hVquF9ZnF+l9PxjwkZcB5gvGOK6sbvXhfiMGB9UTXD+KGyuVp6FudxUylEHU0BaZQJFXyYpI45eo+9gLO5QH0t2wc8BpY3qhNCkWRczNZMBgj4V7Ip5OfIIUnZtDR0nITL4k+HYCwFAEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666337; c=relaxed/simple;
	bh=73tpt0WhTo+M94ABOVHuD8WEoK6gImM1ow5RGFHDXBA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YGRFqg/82vlzLlrzNtNztE0U/M+J1uKCmFXkdjUr+CidEhvSoZ/EaTTcV/1Puoq3As+wMGFfPKC+uuQQ/Zx6Q350HWrcNwOjiWyb5FlZk7sI8MVdGuAR83IbzFDlmWAJF5sX2iYbq4icf0l+/0YdN8ABTM1qOU3x9yqiosZuTkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSGBQscj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSGBQscj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3931F00893;
	Thu, 17 Sep 2026 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666335;
	bh=K8RtRengzTEeWXTRaucj7qyiM/qqsLCBySDP161wmr8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hSGBQscjsXQsGoBzGtzL2uqiUSAV9pa8xiW7pCitYdOskyxVE0H4QkeUPyPnqq5+5
	 bxolDWpmB2/+UcIviR2cOeZvSCrbHZ6N84SzlrvVBYjJqUOrHQcKcRYxbdQtGZZHQF
	 oaj6xzPrGqceMj05E7TVfKmLU1sRMB0l5RbssFz02HYOmtvmots8NOTICjzsuBQgZe
	 6Fxe4hcrL5nLaGmXrXEJWNxtxWI1CkPSn9alWo0gEcMcZ8OUjL6BMPjUHlXNdOEr7T
	 gpyGnrt6PMn+nOS66zV7muqIHXI2VtRvaGnUOG/PQHfrt//ZmQONBmYIx46fxlsiGP
	 O+Uq2gD5D0reQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 29/40] mm: drop some redundant checks around hugetlb
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-29-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-29-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:32:13 +0000
Message-Id: <20260917173214.ED3931F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Adjust code which inadvertently perform redundant checks on hugetlb VMAs
> and clean them up:
>=20
> * hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
>   suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
>   the series, once VMA_SPECIAL_FLAGS is removed.)
>=20
> * hugetlb VMAs unconditionally set vma->vm_ops, so they are never
>   anonymous.
>=20
> * hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundan=
t.
>=20
> While we're here also drop a VM_BUG_ON() which the simplified check above
> makes unreachable, and use the new VMA flag API.
>=20
> No functional change intended.
>=20
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D29

