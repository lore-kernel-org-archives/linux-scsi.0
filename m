Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5A026059D
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536805; cv=none; b=RYfm0g2V4teBucEycxI7NQSIa97G4qANpS1weHB+I8a6qXwiUjlKo4QnHyWGAJw5leGVO5xmD49Z9DKLawTrq9sVU7xQ8ZXrah0ZVQROj3kpTDjhFBEU6gGA05X0X0IpACW+y9YVhQ37yuXawePOyvAUDmoUfv5oHKhs6bgqTC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536805; c=relaxed/simple;
	bh=rZjC7KSA3UvZKmko1uKGQDkEb0iAFgJwMePCx7FAvW8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YNFu0nMf7ymf7oMUHuePQajnNSf6cwimZqXSz+OlV7vUaVTOdpH05Cwrrk6c6hlWmJ3vBgjx10AGnGs8ML8AyuzTcWW9g6aHdLiNhLL0j48FEV55dKsxlOEq19RKtlSivQWd7xh42OLL+GPmZIe632CN3wIdIIZ8W9anqnI26NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jokQXWkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jokQXWkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861D21F00A3A;
	Wed,  8 Jul 2026 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783536804;
	bh=IzOW5aB5S4h0mpAzcQQCA2QLvmTN7AdRSIxRIfpOMZw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jokQXWkp80UR+UQWPNbxmolhpdsUjube8Vlf+W0uW5Pr5IVc+H/hCL6BmuP0GJKzt
	 cARnQ+p4ExZ8MnLW9mpiSsK6usQnICWkbB78ePzRaTdQ9p/iDgDHjZh2HnF6/PGpO/
	 WT50blwB7yycY2VNhJyf/svlntkDfzq1f89eChePGh/qIb8d7aed0VxP9luuNQ8oe8
	 E+3ZaPb7eRTfRmeubKTdJmlz2EzBeZ0/Dl0BbHpzRTJYqBEjViRxD5UrqjLw8q/Hrg
	 cir168n/uAiSdIbPeb8mGRKbMoU8WuSO/yDeoZrVTKGTGJk3BV9BqNH639e0xeGMY8
	 atZLJeEpRROFQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/10] mpi3mr: Skip device shutdown during unload per
 controller configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260708183305.244485-2-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
 <20260708183305.244485-2-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 18:53:24 +0000
Message-Id: <20260708185324.861D21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing endianness bug when reading struct mpi3_driver_page1 =
fields in mpi3mr_alloc_diag_bufs().
--

--- Patch [1]: [PATCH v2 01/10] mpi3mr: Skip device shutdown during unload =
per controller configuration ---
commit 06e862cedaadd19cd270a091a6097fdfe30c2c71
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Skip device shutdown during unload per controller configuration

This patch allows the controller to skip device shutdown requests during
driver unload if configured in Driver Page 1. It caches this setting during
IOC initialization and properly handles endianness for the flag evaluation
to prevent failures on big-endian architectures.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D1

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 31b19ed1528e5..59241038f689d 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
[ ... ]
> @@ -4107,26 +4107,35 @@ static int mpi3mr_repost_diag_bufs(struct mpi3mr_=
ioc *mrioc)
[ ... ]
> +	mrioc->skip_dev_shutdown_on_unload =3D
> +		(le32_to_cpu(driver_pg1.flags) &
> +		 MPI3_DRIVER1_FLAGS_DEVICE_SHUTDOWN_ON_UNLOAD_DISABLE) ? 1 : 0;
>  }

[Severity: High]
This is a pre-existing issue, but since this patch corrects the endianness
for driver_pg1.flags, should similar endianness conversions be applied to
the buffer size fields read from driver_pg1 in mpi3mr_alloc_diag_bufs()?

Looking at drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_alloc_diag_bufs():

    trace_size =3D driver_pg1.host_diag_trace_max_size * 1024;
    trace_dec_size =3D driver_pg1.host_diag_trace_decrement_size * 1024;
    trace_min_size =3D driver_pg1.host_diag_trace_min_size * 1024;
    fw_size =3D driver_pg1.host_diag_fw_max_size * 1024;

These 16-bit little-endian fields are accessed without le16_to_cpu(), which
can result in wildly incorrect buffer size calculations on big-endian
architectures. For example, a 4KB size (0x0004) would be interpreted as
0x0400 (1024), causing memory allocation of 1MB instead of 4KB.

Are there plans to fix these missing conversions in a subsequent patch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708183305.2444=
85-1-ranjan.kumar@broadcom.com?part=3D1
