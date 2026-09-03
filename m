Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD6328D831;
	Thu,  3 Sep 2026 03:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407818; cv=none; b=CV+Q9pwvU3Sj+mL/jhvGP14P9pwyql3+FLCSDRXbb3IZQs13pakY0xFZkn9yvx2KygliQC2+r9idN3A/uAGHFhE8/KPSang0ZIPFEmVlruPubtV1j+23Kh+NdeWGKPrGfeJQQvN1/GzSdYJew7cGs0sJfgFA2FqrrDPXXmhBUzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407818; c=relaxed/simple;
	bh=RJhQia5a03aaZg6+/7IQ941AnOhf4CqWtp7Gft9t2gg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y+T1KZemPIdVdckWekaMAiypfeQ6la9JArmYBXUd+yFWo8HYGLa65krSUFL7V5FeCfb/ilcglsMwmcajIsC11rMCacV+XORlLslQ88epCMFOVwD3GEa0iRSloe20hTA3DIOofta0UlCMqu97Y4Mnm0LL1ntYpTtTNn/xDkZBsSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aN+nXzoM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aN+nXzoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3EB1F000E9;
	Thu,  3 Sep 2026 03:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407817;
	bh=wsfqj5SRck6OggdYyYGkCz1DMqMi+7Cx1PLvhK8LcXc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aN+nXzoMFc3rbcmA69MC2RSAibitLK5OSLNFrvnAALv/gO6qp/CIIj/UfHLUuOrl6
	 16pYQoa019daVcfzULeihyPW9AqTTYB8N3nFsyd/xTlr78grWaB9eDl4H4W86WSP9g
	 iu07122vn0uPMoPdv1WkLBIwAefp4y+fAQ+bMuYfeoyYtKD0UfmTlcqgIXsrAiJlf5
	 GjMCMH5OXryhHMIh07j4C3CuOBBdcPYKsg65ZNrjuyhGXhkdZfmv21IBnTAq9Bb9vb
	 AOhx8vi6QDBUTQqVttFnH/I0JivjOKhBRPGEyJ6CHxEm8KZLT4oKGXLwthecvWDFAY
	 U2LrObtozM2Wg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/40] scsi: core: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260903034201.112211-8-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:56:56 +0000
Message-Id: <20260903035656.9C3EB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Duplicate KUNIT_EXPECT_EQ execution in scsi_lib_test_multiple_sense
--

commit 7abd3d2760cfc6366060acbd670a7ba4cba45ea2
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: core: use 16-bits defined sense codes
   =20
Refactor the SCSI core code to use the 16-bits sense_code field of
struct scsi_sense_hdr and struct scsi_failure. This replaces hard-coded
additional sense codes with enum values to improve code clarity and
testing.

> diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
> --- a/drivers/scsi/scsi_lib_test.c
> +++ b/drivers/scsi/scsi_lib_test.c
[ ... ]
> @@ -72,32 +73,37 @@ static void scsi_lib_test_multiple_sense(struct kunit=
 *test)
[ ... ]
>  	/* Match using SCMD_FAILURE_ASC_ANY */
> -	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
> +	scsi_set_sense(&sc, 0, HARDWARE_ERROR,
> +		       scsi_sense_code(ASC_UNRECOVERED_READ_ERROR, 0x22));
> +	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
>  	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));

[Severity: Low]
Is this duplicated KUNIT_EXPECT_EQ call intentional?

Since scsi_check_passthrough() modifies internal state by incrementing the
retry counter in the failures array, calling it twice for the exact same
mock failure consumes two retries instead of one.

The test still passes because the retry limit isn't exceeded, but does
this unintentionally mask future issues by using up the retry budget?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D7
