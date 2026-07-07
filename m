Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17855217F27
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783404609; cv=none; b=fphPUpYqwIy2CncVb6v0yb7OVHyp2qlte1MSOVMJwVv5eS7yH9hSjjCsghHQ2vQ2Scs1WlUSzxPFJ0QXlt0BgbcEXDa+xWARHkdmV3idBE9c99QPGy5kpHVB7SQ9n9wyCUexSez7PedEF6zEMhiTPehgqEvz3NTVEad3ioxcebY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783404609; c=relaxed/simple;
	bh=IQr9Zy8A9Wi2VbQDG2E2zncwHBZYeN/VNpiIzil6JK8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HpSa4M1tKIoBeiSHPKefhTqNKe9Zjvqff23NaN++jzUfuEJlmflSKl4BdbtPx3tzH8/oCo4s99Bdu7r0JUReqAKfH6HXxVzhfG72gUt0pW37GBJ1PLFjWXF2R9GNpAFYlZ4LKS8tUN0AnDYeHpCEQevD0Vmq4xcxiICy9K+ZDZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxEWox+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxEWox+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945C51F000E9;
	Tue,  7 Jul 2026 06:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783404607;
	bh=5KWsHFH69uQHo6MfsgbAuI1fOeg2rLcHliHYQdsQMyE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KxEWox+c1G7oTqoGCCKgS1pPR+B+U/7iXLTaF8riQN6sUb6nTly0ItW6dZiFAZLK5
	 9r8tQ1EZTnikYRdLpvFa3+0m+A25+CVhR4ZZu3Vzb34GAYTxm6NxxIfeES9InsNW4A
	 hHTOkXA1snNEYG6DzQkl6AQeBF/Nc7lfoMcseW/LkSaxxD3ymxqJ5gm+VjVtzqt9xi
	 hSRTpdux8Ai1RxBMRrEc4WRHgxbBX/NQlZAZO3C/M5fuZVU1KyohRKWNBt1xFLvlr9
	 ALZiAayCTap9JVg12uF5vGthoqfWy5TyX6S9HYpkRV2LWhq8LjlhiesWybvtmrDTUW
	 ILQ85+yjhW1sA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/88] scsi: qla2xxx: Add extended status
 continuation and marker IOCBs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-11-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-11-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:10:07 +0000
Message-Id: <20260707061007.945C51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Meaningful code and commit message mismatch regarding added stru=
ctures.
--

--- Patch [10]: [PATCH v3 10/88] scsi: qla2xxx: Add extended status continu=
ation and marker IOCBs ---
commit f6e2db946a6c0b0669be6dd9042f40e733197841
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Add extended status continuation and marker IOCBs

This commit adds the 128-byte extended status continuation structure for
29xx firmware. It also includes the qla_fw29.h header into qla_def.h.

> scsi: qla2xxx: Add extended status continuation and marker IOCBs
>=20
> Add the 128-byte sts_cont_entry_ext_t and mrk_entry_ext_t
> structures required by 29xx firmware.

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h

[ ... ]

> @@ -2360,6 +2361,15 @@ typedef struct {
>  	uint8_t reserved_2[48];
>  } mrk_entry_t;
> =20
> +/* 29xx definitions */
> +struct sts_cont_entry_ext {
> +	uint8_t entry_type;		/* Entry type. */
> +	uint8_t entry_count;		/* Entry count. */
> +	uint8_t sys_define;		/* System defined. */
> +	uint8_t entry_status;		/* Entry Status. */
> +	uint8_t data[124];		/* data */
> +};

[Severity: Medium]
This isn't a bug in the code, but is the description in the commit message
accurate for this specific patch?

The commit message explicitly claims to add two structures: the extended
status continuation (sts_cont_entry_ext_t) and the marker IOCB
(mrk_entry_ext_t).

However, looking at drivers/scsi/qla2xxx/qla_def.h, only struct
sts_cont_entry_ext is added here, and it omits the _t typedef referenced
in the description. There is no mrk_entry_ext_t structure included in this
change.

Could the commit message be updated to reflect the actual contents, or is
the mrk_entry_ext_t structure unintentionally missing from this patch?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D10
