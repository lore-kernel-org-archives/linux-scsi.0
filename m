Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6E12F7F07
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 22:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784152904; cv=none; b=jSA6XBO2emBSKO3QdFoJDlZE1py/O15r0F5bzzH1iLa243HOmtZkc640+oUr9H6BtuSEALyiCfZgSJLgBOScciCwZ6DPbEz8yx959xPbDxXJK+ahaToc1DVW5VAHrlfOBl4+6SJNN/L+myBtzZEA6lhUtWVeqCBEWLDfaGN/TbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784152904; c=relaxed/simple;
	bh=doygDGZWRT6AEK4qu0xKGOPjvZ4xv1osc/EX8uoI1E8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tyv3LYP4LCy6yJL90VZwZmsDDu9K4BEL0ZYA3COTICjOQ3FycFdFlLTXLmTDMvCaACAs53looQsAWTNau99lRKz3+WdwvX78d/GbTG6f8PlzkkwMET5am5OLHY93SZngZFm1ETtkVvJ/vC2s+94Y/2QkTsfr3LHTjbC9j82E30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBHKjHgq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBHKjHgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916F41F000E9;
	Wed, 15 Jul 2026 22:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784152902;
	bh=7s1ewHoJOliKtzlCSA5IvPFn7Fx28jsAOnsGA9jHuCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JBHKjHgq6dVvKB9bgVVJcI4JjyEAQ3rMCbs8KTahSy8gZ5sdWCTMDPdzamQU7Ly/L
	 vYxNBg/wJxssJlW94R49ORILWA7h9wwFULIiYij++haaqPGWaoxY8nTTQaVavglWBg
	 8U4vaqNVGOY/SAl93f8+yI4WtAKrY274D7ReVkS1d8E/nkv5StCCXFuUL31ai/BiF5
	 6IsCyGp1mkpJTWNYaJyDZ/rkVCzlUPiKjAKHJK4uVoRxu0/KUwul78QtNINjEkHErN
	 xXCdlUcAgNxhf3UI09EaC0YMWye8IYCxTx5KRvzeGGC+YF4Rq6mTUiMGLHlwYKa746
	 ejn44Tlk/aLrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the
 RPMB WLUN
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jorge Ramirez-Ortiz" <jorge.ramirez@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260715214327.1933560-2-jorge.ramirez@oss.qualcomm.com>
References: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
 <20260715214327.1933560-2-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 22:01:41 +0000
Message-Id: <20260715220142.916F41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The code uses SCMD_FAILURE_ASC_ANY to retry any Unit Attention, =
contradicting the documented intent.
- [Low] The 'sshdr' variable is allocated and passed to scsi_execute_cmd bu=
t is never used by the caller.
--

--- Patch [1]: [PATCH 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the =
RPMB WLUN ---
commit 7f3e584cbe66720f776d9dd47015f86621c3fdb8
Author: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN

After a power cycle, the first command to the RPMB WLUN fails with a
power-on UNIT ATTENTION. This patch asks the SCSI core to retry this
condition so RPMB works immediately after boot.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9a..adbec80cf3811 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -40,6 +40,25 @@ struct ufs_rpmb_dev {
>  static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, s=
ize_t len, bool send)
>  {
>  	struct scsi_device *sdev =3D hba->ufs_rpmb_wlun;
> +	struct scsi_sense_hdr sshdr;

[Severity: Low]
Does this code need to allocate and pass sshdr?

It appears that sshdr is passed to scsi_execute_cmd() via exec_args but the
result is never read by the caller. Leaving .sshdr as NULL would avoid the
unnecessary sense data normalization overhead in scsi_execute_cmd().

> +	/* Retry the power-on UNIT ATTENTION (ASC 0x29); the SCSI core does not=
. */
> +	struct scsi_failure failure_defs[] =3D {
> +		{
> +			.sense =3D UNIT_ATTENTION,
> +			.asc =3D SCMD_FAILURE_ASC_ANY,

[Severity: Medium]
Will this retry ANY Unit Attention condition instead of just ASC 0x29?

The commit message and inline comment explicitly target the power-on
UNIT ATTENTION (ASC 0x29), but using SCMD_FAILURE_ASC_ANY configures the SC=
SI
core to retry any Unit Attention condition up to 3 times. Could this mask
other unexpected device state changes?

> +			.ascq =3D SCMD_FAILURE_ASCQ_ANY,
> +			.allowed =3D 3,
> +			.result =3D SAM_STAT_CHECK_CONDITION,
> +		},
> +		{}
> +	};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715214327.1933=
560-1-jorge.ramirez@oss.qualcomm.com?part=3D1
