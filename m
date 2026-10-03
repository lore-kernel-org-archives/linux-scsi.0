Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5379149E5CF;
	Sat,  3 Oct 2026 17:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050228; cv=none; b=A0vhH4dkk7onEfDwgu7TM9ryoJTNLwYkGodLvRqWIAv69Wwc3m+d4KP6IaJP1qM/yFqqq737Kpdt+zyVLIYgzIiGhYb2+NuaxFcBCz8Tze6yNkHDC5LthV1poonEOhfYtXlu1hO0f5ZsBFbHYViYn8z200qXrkRiEYy5H++9gng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050228; c=relaxed/simple;
	bh=aGa09R4SL98RnomL7f0xOzV0xhfcl0WYU9z4TaKL6wo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iClUGGXX7RZW+XYncAXo3wD3Nxdswik/7m+j0mjdQSXJfq22Vei0MfgNVExmtQWWVuarMlQz8G6yGPnBCtZsyXR20TuFE9hOPgg1yCBpDJOuSaAx7+m/CBetMfaBirr81q8YNF7HanVD0wSd19/jrc0YGC1CVszSU0E1N5fzmNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcuMQ+s3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcuMQ+s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2A81F00902;
	Sat,  3 Oct 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050227;
	bh=aGa09R4SL98RnomL7f0xOzV0xhfcl0WYU9z4TaKL6wo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IcuMQ+s3nyVV03FS1oZtW24aJp5zurdBlJKBD+iIJ3d+qYxTyDYtKml6otqCcBi/h
	 udRLENUkT+2+9EvNx5/9jkBFC7gVKjpc4oGASJ7E1lLOm+0tEEhbtI/+BS8f/3d4Sd
	 Rfvk8ga+raHywJyMOEUk3rUTto9N/R8UOyj9groBThuty0hk6lmeOxGqtDEB+w6lQV
	 jjFKgmGMB01V+ahCDCvMxwG+UGhTLWlYGkiyyZyufWx+h+7t87jYa9XUspxGK7wHN4
	 4yLW78NHX7hkwejmmpoUKIRI541NvAlAM+4nqGd/GIG0PQMje7u8nfXSVywpNw6863
	 fQpbwwiqXHTfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/38] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-9-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-9-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:05 +0000
Message-Id: <20261003175705.7C2A81F00902@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
> part of this change, additionally take the approach of mapping pages upon
> mmap rather than providing a fault handler.
>=20
> The page span cannot be mutated when an mmap mapping is in place, so this
> is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
> -EBUSY if it's attempted, gated by the rp->mmap_active reference count).
>=20
> Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to =
do
> this, which allows for iteration over pages in mon_bin_discontig_get().
>=20
> mon_bin_discontig_init() increments the rp->mmap_active reference count to
> stabilise page spans. Should an error arise the core unmaps the VMA and
> mon_bin_vma_close() drops the reference again.
>=20
> [ ... ]
> page discarded with MADV_DONTNEED is not repopulated and a subsequent
> access raises SIGBUS, as with other pre-populated kernel mappings.
>=20
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D9

