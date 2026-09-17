Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152A04F4CE1;
	Thu, 17 Sep 2026 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666473; cv=none; b=eUjNy9LNzikNLM6NxYmtk1x5W6+L07kO3Y9O0Tk3NZfkiy5CD5eO/LBHsxl/4WwMaqrnrDThRmVJOG1C5Yt4gpjc6MQgO0lDZKkdI7lSDVw6XHcCqEDdq94pSdeZNFlQJ0AHuLM0Wwyk5UN6lplKCZbOQxalNQ4+oUfOlhCFr/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666473; c=relaxed/simple;
	bh=KdBYnzSoOUWFOS8U3CtxnViyabu/LqXcHUGFNUSOJdk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m/H9MWkqwNrWDkt2TTf6aegxe2XDcEc/ZjaJCDs0l9f6fhdrgRKWUTeUxI4WkBVsL2nQZPZVFCu2jxLQLWi1YzVUj1Ta6P+EdC4gXu4mht3OATUkKvRmHS9SPD19C6eUfviCa3cW+MECi/EzCFmGHwgKKgG6M8aM52Yb2n5PtEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ssd7PpXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ssd7PpXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEDE1F000FF;
	Thu, 17 Sep 2026 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666471;
	bh=KdBYnzSoOUWFOS8U3CtxnViyabu/LqXcHUGFNUSOJdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ssd7PpXwb+W53EddLrnj8P6zJGEf/OLU5s+7/bvimiHxKHkoh3556uXw/lAl3Qv6+
	 lz5zxHxVdG5H3rgjECM1YKMLj391oU9zsrVGhD4jDuzun4d5UsvInTQBbQ08ZgsYzu
	 1sUrxKDOTZAvT7b12Gx+kKyNx7SIciKhaIEsRkl3lzaFylbHz81m3kzJJAUSBY3zjA
	 3iRm2ruUZATtmO2r/ZiGa+qRo083hGbZKeFD/UqhtfHggfOjIB3eREG7aXvnyaHf5N
	 hqB1sCBP4msB6lsrlOLZ9nKp4Y+EwX1TfFvw1EdJhKqNLebSWQezw36tjr1lSV0qPX
	 Io5p4/7Ye1exA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 26/40] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_kernel_owned()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-26-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-26-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:34:30 +0000
Message-Id: <20260917173431.3EEDE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> We have now made it such that every driver which sets VMA_IO_BIT marks it
> as kernel-owned.
>=20
> However, vma_flags_is_kernel_owned() currently checks for VMA_IO_BIT. This
> was a product of drivers previously marking a range as kernel-owned by
> setting VMA_IO_BIT alone.
>=20
> Fix this by removing the VMA_IO_BIT check in vma_flags_is_kernel_owned(),
> and update mmap_validate_vma_flags() to use vma_flags_is_kernel_owned()
> rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.
>=20
> This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT a=
ny
> longer (which is now redundant) as it calls vma_flags_is_kernel_owned().
>=20
> Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
> [ ... ]
> Finally, update the VMA userland merge 'special' flag tests to no longer
> assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
> now suffices.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D26

