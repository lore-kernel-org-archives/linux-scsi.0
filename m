Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AD34F649C;
	Fri,  9 Oct 2026 18:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570415; cv=none; b=J7gKtD9ebb2aTSGBQGieHbIF/kn5WY2IK86FS6GiRGST1hiLBLqxIIiDuFVYAtPxMZVrcXmRzkgKebmjwDj0ZSR70SaWNDbaf8V9aqcFRbqyesQSwNBrIUrAzc+fXba/NYfmOSEm0gzbCD9ZTUvr8GWGDCZgHgE9X5F2FKv7+AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570415; c=relaxed/simple;
	bh=n9GMDy/R1UgfttvwZhvfhmFdvjuuPlOAsVdTKlAlOWM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=K5Pvd7XxAp71WSo/OURlhMKO/3AmfX6JNdPUzgN4CqTHO5XAhQl6ZZoFZ1XWNe/y9lmZK/bE1oLEpFQOtVjfQ2fNgQ5xqmGIqqQcByS15oCaZdk4QPjk3p1O3KR7DfHlS1FgiI7yclcz3cFbv+eLT9fecQwwhO9qqrmd9q/jhyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+NmX9+V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+NmX9+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032611F00898;
	Fri,  9 Oct 2026 18:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570413;
	bh=n9GMDy/R1UgfttvwZhvfhmFdvjuuPlOAsVdTKlAlOWM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C+NmX9+VHEvaJrcf+awbOATPxFbMv5CSoC2ic9OVqfD8wDE3DwmfihLbI9kLu7RTX
	 NMMa59/VofRuvBSCOotI+pOcSis7QC5xtHvdKGhQz5gKKDPlT4rD04Qd6M58WopCXZ
	 tNsO4qe3MR33XMhbfgYshQq0xXEHtSmDTDYijFSM8+U1E7heFDR5NlCWDwi6H9gUKm
	 MiP+rimIHakYedE8y7dgk7bmtfTlvdjwJQ1qvXxCsZaBOaJY6Y6VY3bO9exBG/CruD
	 pjwvA2OFF7AGgowbSv81ytcljfGCqpXLBhgwYs/XS8UJj3EOjcCoQwMwV5LQQgNg6a
	 kLRnoaszO1XDg==
Message-ID: <sashiko-outbox-165945@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/38] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-usb@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-14-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-14-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:26:51 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
> VMA_MIXEDMAP_BIT flags means, and then refer to that function for
> determining VMA mergeability.
>=20
> If neither of these flags are set, that means the contents of the mapping
> are managed by core mm.
>=20
> Otherwise they are instead owned by some other kernel component, usually a
> driver: the memory may be MMIO, kernel-allocated pages or even ordinary
> pages the driver maps itself, but core mm must not populate, reclaim,
> migrate, copy-on-write or merge the range itself.
>=20
> We initially also treat VMA_IO_BIT as implying a mapping is not mm-manage=
d,
> as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
> [ ... ]
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D14

