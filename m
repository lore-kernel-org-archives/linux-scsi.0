Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053DB35E1CE;
	Mon, 31 Aug 2026 02:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788142671; cv=none; b=V3c1SAfh9Tp6kJjzOhIe32mfaeL6XGoxPg7/DcGED12L3nTlJ3FbLZqy2fvrXkA+sCLjsplOM42nIZ4zBiu1NYBivBAmohL1IruauFyYdwf0aa0E0HZ/DkAPOdtlRstmBZjKIS2qNbJ5h/h7OXehpOs3dfXLGcquf0SUQg6El+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788142671; c=relaxed/simple;
	bh=gRZhtzWHdkNr5Qp6V5W2c3t+qmfi1jOitTb8o+iM9jg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JhyzUew3Yq0U5MhRtQE1Yn+5X4NKF8pX1lQDJoxGUi2HvkV2qHxUiQYH+LhpFugTYXTb9YCFRsWZF4kFJhIAQWZz8mDlxgCOSluYkcodAqF/FqpJUgOljF8hnjv0c3NX0AjD5C5/oWf8rv8r+kIdZt6xJSt3AwHowQgI4CdTMBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3NmhF9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3NmhF9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CD01F000E9;
	Mon, 31 Aug 2026 02:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788142669;
	bh=gf1TRzrFEPUzjIXPz/snoLKMCABC4GtwJviroPGsThg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V3NmhF9H5Tb6uCqOolI/G0MOxdmo9e3k5e/WnS2Xu3rwhph7fdPtXPOzkHTVMw24a
	 G/6Fp++PeaVuaf82Sluv49641S+OjD7e+HoAxAhWJk4yRNMM0xEXxggjK0P9yRQRgR
	 Nujt4gs4xlR7o3VGs8yR9/U/ypPQtV0VKpn0qIihMFp+vBGRM1vPm3g+snfyA1wqJ+
	 UrgopoqJf+Oi2eI+xPA5Gi81dl8ZZ4cRNLCoCzIxMAoAbLsLfjBJJDCwVpkt5gzEOK
	 653sXGVf10wd8Ej0jdyxIEtwSUgXKdyBU45/UKBjQcNbFibXkg6nYboEvNcq1WLfh6
	 dN17xh6zbMYIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/37] scsi: rename sense field of struct scsi_failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org
In-Reply-To: <20260831020451.585944-5-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:17:48 +0000
Message-Id: <20260831021749.52CD01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The unit test `scsi_lib_test_any_sense()` is broken because `.re=
sult` is incorrectly initialized to `SCMD_FAILURE_RESULT_ANY`, completely b=
ypassing the sense key check.
--

commit be75fcae059f5a6c0fee14ecc0a6ae4e8a66d23d
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: rename sense field of struct scsi_failure

This commit renames the sense field of struct scsi_failure to sense_key
to make its purpose clearer and align it with struct scsi_sense_hdr. It
also renames the associated SCMD_FAILURE_SENSE_ANY macro and updates
initializations in tests.

> diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
> index ae8af0e0047a8..4558dc853e26e 100644
> --- a/drivers/scsi/scsi_lib_test.c
> +++ b/drivers/scsi/scsi_lib_test.c
[ ... ]
> @@ -116,8 +116,9 @@ static void scsi_lib_test_any_sense(struct kunit *tes=
t)
>  {
>  	struct scsi_failure any_sense_failure_defs[] =3D {
>  		{
> -			.result =3D SCMD_FAILURE_SENSE_ANY,
> +			.sense_key =3D SCMD_FAILURE_SENSE_KEY_ANY,
>  			.allowed =3D SCSI_LIB_TEST_MAX_ALLOWED,
> +			.result =3D SCMD_FAILURE_RESULT_ANY,
>  		},
>  		{}
>  	};

[Severity: Medium]
Does setting .result to SCMD_FAILURE_RESULT_ANY here cause the test to
bypass the sense key checking logic completely?

Looking at scsi_check_passthrough() in drivers/scsi/scsi_lib.c, the check
short-circuits when .result is SCMD_FAILURE_RESULT_ANY:

drivers/scsi/scsi_lib.c:scsi_check_passthrough() {
	...
	for (failure =3D failures->failure_definitions; failure->result;
	     failure++) {
		if (failure->result =3D=3D SCMD_FAILURE_RESULT_ANY)
			goto maybe_retry;
	...
}

Because of this short-circuit, the sense key check logic is never actually
evaluated. To properly test SCMD_FAILURE_SENSE_KEY_ANY, shouldn't .result be
initialized to SAM_STAT_CHECK_CONDITION instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D4
