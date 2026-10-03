Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944BB47ACD4;
	Sat,  3 Oct 2026 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050242; cv=none; b=IqLST3csL56u8l0MNfh4WGdTpGMaEmzZe3aQ/yUNK3zDe7gxgWfaAv0WRQF2+ufUgSE9uXdruzacYREsESrg6b4hS+S8prqjDBK05dWxaOPJJA2ym7y+ueKJVWrh3gXvFXUj8ftYHW0L6W8DEPMvUQnqy3QfcF+tbocvJDHUZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050242; c=relaxed/simple;
	bh=txFAljp4AKiujC3GkJP+5kl/DflebvizBkAmsRwE0JE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lO8qbFWDvjS+7jbVQqFFG0qS3jKifrKGRnalbVnQ41irww+Y4e7Dd4wWQVTSU7bh2gy7Op5fMzql9UpX/YSagsmI5zEjrrc/eF+RxpFtTTBdSA6DiyKrXVSd6GkxTMuaRF2ZaAzU9oP6uWnH8sTrlvz84PnMlHi15ClNqCFcDtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByFBn4FU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByFBn4FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A858C1F008A7;
	Sat,  3 Oct 2026 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050240;
	bh=txFAljp4AKiujC3GkJP+5kl/DflebvizBkAmsRwE0JE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ByFBn4FUzM8zrgIohV0Ugk+GKeA1KhABQ70g0YqmH1icYmcbqaeWj1ox7SuhFTekx
	 bMknBRtPUzV/zMIPNt/GGRuD3sMmtv7kD3JDaphA/mKZdce7OipVjg7eKeyRsJhG7k
	 fJq26SLOj9VNkEUds5HTFySrtqf5I8hNYtUM6rVtV4m9czIA0BV3MaTemWO7QodIEe
	 ng8CihYy9ZyrI7uT9Ziuj0C5xrFeCpgV6AYM/47HoxUOLk82dgZkqPB0A6AozL3gE3
	 oSZ2dmJA//EyNqYeCTWlEIKDtlW8y6A96zNVf8Gcp0XdGedsX4ehXj+qCd/GvGtCpd
	 wNcp+CU2rv71Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 34/38] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-34-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-34-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:19 +0000
Message-Id: <20261003175719.A858C1F008A7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> A fixed or non-mm-managed mapping is one which sets VMA_PFNMAP_BIT,
> VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
> VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop =
as
> mm-managed mappings may not set it.
>=20
> Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
> self-documenting and helps eliminate the confusion around 'special' flags.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D34

