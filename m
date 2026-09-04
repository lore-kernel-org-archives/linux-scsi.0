Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBB21A6817;
	Fri,  4 Sep 2026 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788483756; cv=none; b=P2wzSqVUNNWpegsM06w6WBZ9PBfpfoHnAb6g5Bs4Wb/R9nAEKBjNnjmXogGtxDWDi36nGjI+Cz6LsbKy/bQSFFGgC2jvCFNPrLEaeZFDxxR5YktfdHcMarliCtSexglcrMd0ovbDEEKKbtKIQq7oIMrvXeN1b+/EjFzz0kXJzSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788483756; c=relaxed/simple;
	bh=5dWgSAuQJ8ryAW+n49H6XZYE4cKJ2AOoGYqwBw0qXD0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z8aD/v7e8ThatQwnYYvr+GKD5C31XM3T+6ALjuBAMJpIwQnQcD6VyNNxX97EybOtRNy0kw1rdj1gOWzFKktNJWqxdRzrDZ6TuI5aw5dn30ZPBU7pnqP20r5NyxeH6VXI8MCiPxTwl04zpjIlBe9s1L4aVCTCjZWxbXgZAuScXbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkUhCFK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkUhCFK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3AA1F000E9;
	Fri,  4 Sep 2026 01:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788483755;
	bh=8H7FKRmJxco2My/hSFOF1ydTccYMVaTUepbzN5PSc9s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZkUhCFK4fSQAIf4wbFcSivYse88O3pPfARGX9OQwQqDHFjYPltvO1l/4vJN0VvsTS
	 dg0wXk5vvLR0PXBFBsBh1rKyDj2c9PK7R/vqZNWob63W3Ty9ewDpDdaEzO9mNOjxkt
	 PrHWHNq7F8zQ5fX8TxmIpMxqXwSukdPdv20BUWof/zNIo/5wAyIdN4q29sQAm7SBG2
	 jkNe0Pd8vRbpKinEZpl4kgReeMCTwySm1QdqoJs3ttNV2/T9TiYu73lzXOreuz3i5w
	 8lbBe1DuQNh37fvIKnNa1OlLYDhqcxcGhiG7t756b3AyIrj+PspfEQ/UMhO+7bW8it
	 SRqwIEAQcJ/Dg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/40] scsi: sr: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-10-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:02:34 +0000
Message-Id: <20260904010234.CD3AA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Uninitialized stack variable `sshdr` is read if `scsi_test_unit_re=
ady()` fails early with a negative error code.
--

commit d2b5b7991e7f6c50aa82d680e3e934465eeb894f
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: sr: use 16-bits defined sense codes
   =20
Refactor the SCSI CDROM driver to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h.

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index c36c54ecd354b..4f2e8d1be6da8 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -253,7 +253,8 @@ static unsigned int sr_check_events(struct cdrom_devi=
ce_info *cdi,
>  	 * (ASC 0x3a).
>  	 */
>  	cd->media_present =3D scsi_status_is_good(ret) ||
> -		(scsi_sense_valid(&sshdr) && sshdr.asc !=3D 0x3a);
> +		(scsi_sense_valid(&sshdr) &&
> +		 scsi_sense_asc(&sshdr) !=3D ASC_MEDIUM_NOT_PRESENT);

[Severity: High]
This is a pre-existing issue, but since the patch modifies this expression,=
 I
wanted to ask about the uninitialized use of the sshdr variable here.=20

In sr_check_events(), sshdr is declared on the stack without being zeroed. =
If
scsi_test_unit_ready() fails early and returns a negative error code (like
-ENOMEM or -ENODEV), sshdr is never populated. When ret is negative,
scsi_status_is_good(ret) evaluates to false, which causes scsi_sense_valid()
to evaluate the uninitialized sshdr structure.

Should ret be checked to ensure it is non-negative before processing the se=
nse
data?

> =20
>  	if (last_present !=3D cd->media_present)
>  		cd->device->changed =3D 1;

[ ... ]

> diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> index 089653018d32c..e4ec0f63cdccb 100644
> --- a/drivers/scsi/sr_ioctl.c
> +++ b/drivers/scsi/sr_ioctl.c
[ ... ]
> @@ -318,18 +314,18 @@ int sr_drive_status(struct cdrom_device_info *cdi, =
int slot)
>  	}
> =20
>  	/*
>  	 * Using CD_TRAY_OPEN results in an START_STOP_UNIT to close
>  	 * the tray, which resolves the initialization requirement.
>  	 */
> -	if (scsi_sense_valid(&sshdr) && sshdr.sense_key =3D=3D NOT_READY
> -			&& sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x02)
> +	if (scsi_sense_valid(&sshdr) && sshdr.sense_key =3D=3D NOT_READY &&
> +	    sshdr.sense_code =3D=3D LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED)
>  		return CDS_TRAY_OPEN;
> =20
>  	/*
>  	 * 0x04 is format in progress .. but there must be a disc present!
>  	 */
> -	if (sshdr.sense_key =3D=3D NOT_READY && sshdr.asc =3D=3D 0x04)
> +	if (sshdr.sense_key =3D=3D NOT_READY &&
> +	    scsi_sense_asc(&sshdr) =3D=3D ASC_LU_NOT_READY)

[Severity: High]
This is also a pre-existing issue, but I wanted to mention it since the code
is being updated.

Similar to the issue in sr_check_events(), sshdr is uninitialized in
sr_drive_status() if scsi_test_unit_ready() returns a negative error code.
Here, it looks like sshdr.sense_key is accessed unconditionally without even
being guarded by a call to scsi_sense_valid().

Could this lead to incorrect drive status reporting if the uninitialized
stack memory happens to match NOT_READY?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D9
