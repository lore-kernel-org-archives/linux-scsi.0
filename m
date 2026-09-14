Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815AD1EB5FD;
	Mon, 14 Sep 2026 22:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789423767; cv=none; b=po5hFO4O+pJssrbO5ZsdqSvkXa0uX9qa83LkoVoafUGK12VtqFjYrLJ8WOzGjJfXpub5m1aI4YpECFj+uwJ6beegB44rtL0yTB+CJyoIU4FwNdZf43bdHV5F2rI9n1aTLKZyvUOdf0pxMZR8quw+J6z3S9UjxQvvtfMIZ+6duPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789423767; c=relaxed/simple;
	bh=URsiDikOU1m9AQWG4RNqOvLBN3qofHCzrj/OVx8GoD4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ejKFdvoKsbVeB/018brvoBcy7eTB4lwUC3CnUYyZEzqIVHL/bdCrPWukUIhLphkdyGYSu93HtqQMs8xU4WspMkaq0dahasOOuZkA/0RVmsT4Aj832l5dikGL3yIF/NVUGw7Zw2k+Q82o0HU7CO3G4epV8GtQ+9+w3vqb4aE0L7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ee54wVnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ee54wVnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400C61F000FF;
	Mon, 14 Sep 2026 22:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789423766;
	bh=URsiDikOU1m9AQWG4RNqOvLBN3qofHCzrj/OVx8GoD4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ee54wVnf97zCc5J3PcrklBVpZWo8uOlZlvdl31yWq2lmRKiHNb2rQtO84bnctkc9Q
	 swUvPHKi3ua5swzvT6MBIyATVbcFblQZqWnjG6uVRVWPfy55NO/5McO4way+HnyQtf
	 r/8fgJCQW1XzLxymA5uthEl9D3EPWEMo/HDr/H2btcwl4jTy+L1NWcah1R66tq7z1D
	 eFM+QmjJ/EVytopbqDuZihYwHS8C4vOljXFrELxZdtd8aCx2uqF+TfL0vp/i0yUCuV
	 KkqbNdGZzfrOVYgKzTEHzg2s4xZkO7RrK0ioH7ueq/BZMoUiUnRVlM00SeQEJyTpoh
	 H3OC6nVaAJghA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 26/40] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_kernel_owned()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-26-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-26-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:09:24 +0000
Message-Id: <20260914220925.400C61F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D26

