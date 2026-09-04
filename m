Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB16235F5ED;
	Fri,  4 Sep 2026 01:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788483868; cv=none; b=gLFTpsueY4eg7LlZI/w49ipJyJhPVYMSDdobH0uft6LOn9NQ+kC6mCyvwZ10E8ebrjV+5p/GNKK0XnfJdxAapFLkmikWOrFrpexbCfd7cdTccb2PnCtQomXpcvvS3Vlw9mahw94MtDpPmmBhpBdhSC9yZnSDi2YcJ1s5t0/Bgr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788483868; c=relaxed/simple;
	bh=76EIWhRf6AkyV7OeJxTGeGsvgk1nNAd9AkH/D2jGFaA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YtQ2N07LTV3ZzkJetp/3bxr+G863K31Of8zQVNikFDDuODzzRbTjphudjbC3JwOc/WKgKWIGhNxX0H+eVJZ+WpjAFgYL9dBdh7ZZ0Il08D7BklPMuhUZT1K1P9S79GBLyLo9HmxrCVkIMR7KtnHE1zGobY5bTlmDema4xH57xPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyOeW05a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyOeW05a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021131F000E9;
	Fri,  4 Sep 2026 01:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788483866;
	bh=G1IQVOaNzBWqZ5TP6nvhkvP5+A2+9LQH95TrvsF7p68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eyOeW05aOy5rTTb/WJ6uvvIWtV+JcJYPs3D4Sw2JxiEeCmolwEERvP8m0wwE/eOH+
	 rLsigyy2lFuRjSfJAM7SvkM7x67iLGCsr+wVRynpuFIN1lTsGiLCsiLFp+DapG3NvM
	 9OEj78DkMy4q6UX03fUmeRIWDPbKi6HFj9Si3nd9zt6eoeS8pFPGGUtJAQZkn3M0I5
	 gUBgL4atIEBz/n7KTHcmiY9EslCvJXbAWWst0iIEiHkA1Dljz9ZoAL7jKHv64zanQS
	 whHOpeA2tTB/Eke6c3YCiUTJqfvIEXWxfLSsZPNLhVRbfQbPwltccfZ9s/tlT+TWPM
	 P5CkahGi0YeeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/40] scsi: sd: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260904002644.157668-9-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:04:25 +0000
Message-Id: <20260904010426.021131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Refactoring changes `sd_zbc_complete()` to strict ASC/ASCQ match=
 instead of just ASC, unintentionally altering behavior.
--

commit 5c4223357b4b8d6bbeafe176fdc1d3eeb2183125
Author: Damien Le Moal <dlemoal@kernel.org>
Subject: scsi: sd: use 16-bits defined sense codes

This commit refactors the SCSI disk driver to use 16-bit sense codes where
possible, replacing hard-coded asc and ascq values with enums from
include/scsi/scsi_sense.h to improve code clarity.

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -369,7 +369,7 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, u=
nsigned int good_bytes,
>  	if (op_is_zone_mgmt(req_op(rq)) &&
>  	    result &&
>  	    sshdr->sense_key =3D=3D ILLEGAL_REQUEST &&
> -	    sshdr->asc =3D=3D 0x24) {
> +	    sshdr->sense_code =3D=3D INVALID_FIELD_IN_CDB) {

[Severity: Medium]
Could this refactoring introduce a regression in error handling for
non-compliant or buggy devices?

The previous code checked only sshdr->asc =3D=3D 0x24 (allowing any ascq),
whereas checking the 16-bit sshdr->sense_code against INVALID_FIELD_IN_CDB
requires an exact match where ascq is 0x00.

If a device returns an asc of 0x24 with a non-zero ascq for a zone
management command attempted on a conventional zone, the kernel will no
longer quiet the expected error with RQF_QUIET, potentially leading to
error log spam.

Since the commit message notes "No functional change intended", and other
parts of the patch (like in sd_done() in sd.c) deliberately preserve the
"any ascq" behavior by using scsi_sense_asc(sshdr) =3D=3D ASC_INVALID_FIELD=
_IN_CDB,
should this code use scsi_sense_asc() here as well?

>  		/*
>  		 * INVALID FIELD IN CDB error: a zone management command was
>  		 * attempted on a conventional zone. Nothing to worry about,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D8
