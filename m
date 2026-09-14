Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B53A59A8;
	Mon, 14 Sep 2026 22:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789423719; cv=none; b=QQvzPyJZ55MF7fAUe6iTNljY5QMUpmmdmebF7Tbeo6sRwVMTQRtRtZq/FJIMp5Jr2ZvO9dtLOxBDRmzJ1RBcA7H+Aa++u1klI7gcWbyEM0Uj3jKNCi8K9pelZASeeFuMUINEAmJJSO7LYaH774jpbIQgzQYWY2oEdp9msDKKpcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789423719; c=relaxed/simple;
	bh=Qs36YUXxB5ieEK5KA2yhw9j2KHzrlbshGoaoOiGRHOE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mNtv88BECZ+zi0Jk8xRaq4YsFIV8MXtHwMQg25KgNxq5SxudGszy/EgJzohtK6kn5X7Q21dRazliFTdovZga+y8e0LdkYTzVrNeCV2KeD/1rt7VtpY3XzfG3HY0ovQkerGJdhfiTmUdiY/8jSgsNSpdR6I4hv2/FDmkufP1ZrFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lO0Ce06w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lO0Ce06w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784CD1F000FF;
	Mon, 14 Sep 2026 22:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789423718;
	bh=WoNRymsDtMx0indCFrDBQWLcq1c1c1hScGVe9WFZ1a0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lO0Ce06wepaswViDsWnuypcA16rVVixQFdjlmi07ll8y1RISY8730mNqykbmyBOs3
	 +/sVxQSJpPAc2ypIprbhpD69WIYyD29pBaH2ALbSb4k+j8qA5ZWhF8wEmbjW0dbshC
	 PlGc1w9CVv7vqKxQIiff645szr42N5PhCce6/6odVkMM21iBldMFMXb0/zG6fSPL9o
	 PuzhpeEbHjHRUtDf8Qg+7MYKuRtdMyNCTTbnkdaMUZa9MYzptJfH6ewss1SdvAyFPT
	 cLj5XbZ0FBTZHckabJuv+iRk5MUGZCJp/WOUD558WLjeAZ7YjXNbPvbXC+Ps0CRWzI
	 3Tom2Icbh+GyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 29/40] mm: drop some redundant checks around hugetlb
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-rdma@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, kvm@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, bpf@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-29-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-29-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:08:37 +0000
Message-Id: <20260914220837.784CD1F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D29

