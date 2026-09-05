Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160391F4634;
	Sat,  5 Sep 2026 03:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579061; cv=none; b=WJ51dSdNfs1Tb4TiaLA3bp7V9f+cus43Sg/DK6J6Klq/99x6AMrCNA9Gb/fRyeqo5cttLDErBoNBCId/tlfBKMl7Am1iNMvm5IJ+S3eaAkYUnxs8u/Ihufh+yIZuVvOuFrBjni6/toIGqfpUVNVDQveLF+aPARvXRev6UjsXjnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579061; c=relaxed/simple;
	bh=cqW2tRe66GN4fmh/78ls1D2KfdpTlO3zzoWlVr9Dlh8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OOctHgx6o5T1yFfKQdQG3xk36MkIwYzAEu8IaehIyoTjXIMWubslelQ073Wxok0DbWdyl0JPWdQZPIp4A7jYwKDLOSb0s12fVCLY94M4XCNKe7JuPV6O4w5wd7dLx74KUGLUsFv1MJky8ojHPxYj//YVPQd/tkMFN4FBljVHtlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGg8QLfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGg8QLfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E52F1F00A3D;
	Sat,  5 Sep 2026 03:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579060;
	bh=cqW2tRe66GN4fmh/78ls1D2KfdpTlO3zzoWlVr9Dlh8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MGg8QLfBwrCUlaLm9RDjVbVNZ1urUcNQtm09cFA2KctA0fluhK8rnr4RPD8cusUDh
	 Huk/qk45vEa8UFm2LwPokXoeQMm9ByrPFveggdhkKyw5X8X8HUB6Kii38P2vsT5v+f
	 TdBT0noY/PBIh8ubVSWxa2XCSO2E3Omr9w9SAORJwKknV9BloP4ASoknNfMomosf0U
	 X5grROI64WkTntNaQ7Pb8yFk+dVm9WyREMOm+Kq04z+saLiS74tNuiya0bMak1mEkw
	 eD0beQpTCWN9idIpQZr2OW9CDdTx0LpbUbCkH7E739kuEZ5Es7oryqa9EsBoKRNzMl
	 Zi/FYXDdfU4dw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 04/40] scsi: rename sense field of struct
 scsi_failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, dlemoal@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260905032224.509860-5-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:30:59 +0000
Message-Id: <20260905033059.6E52F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rename the sense field of struct scsi_failure to sense_key. This makes
> it clear that this field stores the sense key, and also unifies this
> structure field names with the names used in struct scsi_sense_hdr.
>=20
> To be consistent with this change, the macro SCMD_FAILURE_SENSE_ANY is
> renamed SCMD_FAILURE_SENSE_KEY_ANY.
>=20
> Of note is that the definition of the array any_sense_failure_defs in
> scsi_lib_test_any_sense() is modified to change the initialization of the
> result field to use SCMD_FAILURE_RESULT_ANY and add the .sense_key field
> initialization to SCMD_FAILURE_SENSE_KEY_ANY to match the test target
> case.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D4

