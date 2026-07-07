Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6C3321420
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406929; cv=none; b=KTqu+NAHaxBHNznrPxMJKc2esPQHMH7bc5TQFAabS8wPNROS2xjb7MITx/5iu2Qk1zmQGPOcr1xVLDUkqUgqctq/ce+3d2TDtwNjVrUn/YifeAcGKwil2OuFc5sY07VI+tvmu9sJlF5M5lT+hev67z6K+bzlEERtjL58RnF6a3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406929; c=relaxed/simple;
	bh=MANKzUmOD5MuQ6SfOf4OHmxhoRsOzSQ7Fk2p0hpRDTY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XAQzpYBqA9f0MzhvOVJbentGdW498bj0pO/wkb1L1PzrCvMk9h/BksXFFtttpQ5Sj7NlizieQB73qj/BxaeyQMa2azcILuCkKTiyjDQV6UsOHk0P5dGo9llRnFy4hkhd9f6MOiLj59kyj43CcxVaTp/Kw4GxQKq4OUdmbwxGTpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wcj3i2Qt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wcj3i2Qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C211F00A3A;
	Tue,  7 Jul 2026 06:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406928;
	bh=8LPT/W/dvowW1uRLP31sEAl7ymiPE45RaI/fHX879lY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wcj3i2QtOX8T2m20bvAl/2J6HCocY2ofn0InmUqXcHxWd6srNQ0vIALSG6/HFrN2D
	 ke3lH2dudIbpHGZELxGcj1Xti0h07Ja1Kc+vXogpNRqvXjGjZELuPrShCT6STSwQef
	 f1nzWUrVG6UmHU+OoIuS2PdzEuX4SeuVH2AZAAXZPIxkTxrd+wo0yYwkIJOcA14mXr
	 Ujt1nKuAOd9KBAItp0hHrXFUEUmZZXijnQDZyFRG5wzewQpzlOn8AfJnQ8VLZ4pKpK
	 xyrPbCxCrv6xOTxyPZNtNo2cqNZ1iczio8bqg6wKlU8SlWsK53SlYrJDmUlxHZUH4h
	 3o0+LCm1FfKjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 39/88] scsi: qla2xxx: Adjust feature gating in BSG
 paths for 29xx support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-40-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-40-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:48:47 +0000
Message-Id: <20260707064848.31C211F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] Incomplete Feature Enablement: D-port diagnostics v2 API is not =
enabled for QLA29xx adapters because the IS_DPORT_CAPABLE macro was not upd=
ated, causing the command to unconditionally reject QLA29xx.

Pre-existing issues:
- [Critical] Information Leak: The function qla2x00_do_dport_diagnostics() =
leaks up to 62 bytes of uninitialized kernel heap memory to user space.
- [High] Resource Leak / Hanging Process: BSG job hangs indefinitely on val=
idation error because `bsg_job_done()` is skipped but the function returns =
`QLA_SUCCESS`.
--

--- Patch [39]: [PATCH v3 39/88] scsi: qla2xxx: Adjust feature gating in BS=
G paths for 29xx support ---
commit 9bba08258f3cd9b122f24b8370fef88669196b77
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

Extend qla2xxx BSG command handling to recognize QLA29xx adapters and
align feature availability with hardware capabilities.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 8a969174a261e..fade3638d31cb 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c

[ ... ]

> @@ -2789,7 +2789,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	struct qla_dport_diag *dd;
> =20
>  	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
> -	    !IS_QLA28XX(vha->hw))
> +	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return -EPERM;

[Severity: Medium]
Does enabling QLA29xx here leave out the v2 diagnostics interface?

Looking at qla2x00_do_dport_diagnostics_v2() in the same file, it relies on
the IS_DPORT_CAPABLE macro:

    if (!IS_DPORT_CAPABLE(vha->hw))
            return -EPERM;

Since IS_DPORT_CAPABLE in qla_def.h only checks for 83XX, 27XX, and 28XX,
won't qla2x00_do_dport_diagnostics_v2() incorrectly reject QLA29xx adapters
and fail with -EPERM?

[Severity: Critical]
This is a pre-existing issue, but does enabling this function for QLA29xx
expose an information leak?

In qla2x00_do_dport_diagnostics(), the dd structure is allocated without
zeroing the memory:

    dd =3D kmalloc_obj(*dd);

Later, sg_copy_to_buffer() only overwrites the portion of dd provided by
the user's request payload, which can leave bytes uninitialized (such as
the unused fields). Finally, sg_copy_from_buffer() copies the entire
sizeof(*dd) back to the reply payload:

    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
        bsg_job->reply_payload.sg_cnt, dd, sizeof(*dd));

Could this leak uninitialized kernel heap memory back to user space?

[ ... ]

> @@ -2915,8 +2915,13 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg=
_job)
>  	struct qla_active_regions regions =3D { };
>  	struct active_regions active_regions =3D { };
> =20
> -	qla27xx_get_active_image(vha, &active_regions);
> -	regions.global_image =3D active_regions.global;
> +	if (IS_QLA29XX(ha))
> +		return -EPERM;
> +
> +	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		qla27xx_get_active_image(vha, &active_regions);
> +		regions.global_image =3D active_regions.global;
> +	}

[Severity: High]
This is a pre-existing issue, but while reviewing the flash image handling
in this file, I noticed a potential hang in qla28xx_validate_flash_image().

When validation fails and rval is non-zero, the error path explicitly skips
calling bsg_job_done() but still returns QLA_SUCCESS:

    if (!rval)
            bsg_job_done(bsg_job, bsg_reply->result,
                         bsg_reply->reply_payload_rcv_len);

    return QLA_SUCCESS;

Since the BSG core expects bsg_job_done() to be called if the driver
returns a success code, won't this cause the user space process to hang
indefinitely waiting for the job to complete?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D39
