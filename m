Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0F9314A84
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 14:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784039491; cv=none; b=fuMVuxR0gz3iqd0uq3mCDmOCmXgo3ssCfcGxBsSKC4zbYr4+dNfj3i2SK5iENdh7NAAgfx4bTtSmVh9cXINjt+UPx+ZhEnSGxwu0ZRA76ZAFp6Fqa8PyKEI19SRDs9Dr0SmNW22zVavJomrUql2mP1VvCpZQJgER6P6xco4jPDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784039491; c=relaxed/simple;
	bh=ZeMFS6UTNdX1d7se4ZNlHHXSkgh6Yl1tGj2EHgblV3Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=msTe1bZl9xj5h7jR9SOcqxLL79RSU0pXJoFX5tArD5FjwDppNtn6hsJP7WcnO3q+PoZmC/+aBl0keELtUPaXg0pFL07duAZ+nleX+/3WnCESfv6eZlaGQo1h5UtX2RAOuMH5yVzp5vQeuTV5eoBdvtSrVF45FO/B32u3IjP9nys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvJVYASc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvJVYASc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB281F000E9;
	Tue, 14 Jul 2026 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039488;
	bh=Ho8aHjduDjzoviWcYZQywIgFwUJNh5qxq2YXdI1Mmdg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CvJVYAScYrJC6Nnv8cHjsl5i4U8PhBebbmTn5Osm4W0qVrEKugoQH+uaq1Rsoqryo
	 M0azNSaSxyvNiSZIHUe7PpxmnbcNodsva2zWjkFzaO+xuq2v0Dlw0S+Kqe6n1KOjOa
	 95Vw4xJOTVpig7HKTe8knRfZDe/2fiyTOR2DG46sZRVTyIvRqHlDZg/AiIaaORGJsR
	 SvMJKsGPtgpDiDKLvjQ5ldRDlSNu5fU4kMFCw5gpMXeNfpdIs5PmKLWNlUuuw2YzlX
	 wrAKSTm0QVYM3FQ9k/lTiGWijul/WrQGdHGiyG5f1LgIZ77Wbwg8uER1dr0chcmwHF
	 9/gqyeNQPt4Jg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 30/56] scsi: qla2xxx: Add size check for ELS status
 entry layout on 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-31-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-31-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 14:31:27 +0000
Message-Id: <20260714143128.3CB281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Preexisting endianness bug in 29xx extended IOCB bitfields, which =
will cause corrupted DMA descriptors on Big Endian architectures.
--

--- Patch [30]: [PATCH v4 30/56] scsi: qla2xxx: Add size check for ELS stat=
us entry layout on 29xx ---
commit ef8ae6f09d5507520905d2b5e51c92a44459978f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add size check for ELS status entry layout on 29xx

This commit adds a BUILD_BUG_ON size check for the 29xx extended ELS status
entry layout. It also adds a documentation block explaining the byte-identi=
cal
offsets shared between the 24xx and 29xx layouts to justify casting in the
completion handler.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index e2653620e80be..c286465ae013d 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2359,6 +2359,22 @@ static void
>  qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
>  		     void *pkt, int iocb_type)
>  {
> +	/*
> +	 * els_sts_entry_24xx_ext (29xx) overlays els_sts_entry_24xx for every
> +	 * field touched in this completion handler: comp_status (offset 8),
> +	 * total_byte_count (32), error_subcode_1 (36), error_subcode_2 (40),
> +	 * d_id[]/s_id[] (24..29), control_flags (30) all sit at byte-identical
> +	 * offsets in both layouts (only vp_index/sof_type at offset 14-15 are
> +	 * bit-packed differently, and that field is write-only on the issue
> +	 * path -- we never read it here). All reads in this function are

[Severity: High]
This is a pre-existing issue, but since this new comment mentions the
differently bit-packed vp_index and sof_type fields on the issue path, is it
possible these bitfields are fundamentally broken on Big Endian machines?

Looking at struct els_entry_24xx_ext in drivers/scsi/qla2xxx/qla_fw29.h:

	__le16	vp_index : 9;
	__le16	reserved_1_sof : 3;
	__le16	sof_type : 4;

And its assignment in drivers/scsi/qla2xxx/qla_inline.h:qla_els_set_vp_sof(=
):

		ext->vp_index =3D vp_idx;
		ext->sof_type =3D ELS_EXT_EST_SOFI3;

Since compilers pack bitfields based on host endianness (typically starting
from the MSB on Big Endian systems) and do not automatically byte-swap
bitfields on assignment to an __le16 type, will this result in garbled DMA
descriptors when the Little Endian firmware reads this 16-bit word on a
Big Endian host?

> +	 * therefore stride-agnostic and go through a single struct
> +	 * els_sts_entry_24xx * view; the trailing reserved_4[] of the extended
> +	 * layout is irrelevant on completion.
> +	 *
> +	 * Likewise els_entry_24xx_ext overlays els_entry_24xx through
> +	 * control_flags (offset 30), so the SRB_ELS_CMD_HST_NOLOGIN ctl_flags
> +	 * read below also goes through the 24xx view.
> +	 */
>  	struct sts_entry_24xx *sts24 =3D pkt;
>  	struct els_sts_entry_24xx *ese =3D (struct els_sts_entry_24xx *)pkt;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D30
