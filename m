Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A99B43F0A9
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306901; cv=none; b=A3tziMjcLu1t6QkZeAQL7PqJsTrgElrdrinHC6UljdE7usqUkMg74aDvhn3l79LvSgEeexXbJwb/o4YZjLVRarOzZqIU+TxZoqOwe2AONT64AYyPSfsa3oYg6Yz+J3KeogYRVHTcN35RYf1Ro0hw6CayNIy/cv/q5izI3aWWey0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306901; c=relaxed/simple;
	bh=XyesLw9Xsy4nI+YKBTBwOEKKlvho2wFx1j4PA2opHnE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Woao9+kw6MZ64In90nC82Z+Tgbftucl0OTW78YHsk02vbBeewv4wZQKZhU/FYl66rWX2QZJiKz7oK6lJouUIo0uoETi3ypHTjMw9tMJeQ9jNMd1FIw6xju0fk/73hSknwUBgUlXdeU8KyZqmvvF+dy3531dCtFbBd9COsq5MMkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6FYJkKp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6FYJkKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C32F1F000E9;
	Fri, 17 Jul 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306900;
	bh=bTB228bWdUQEvdrB/OznJLxcKR3gkmGVg8d44+m4zdw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c6FYJkKp+1bkQA4UfOtxbd5xT0edihDErRf91Zsmfa7uO/aRtqrEOyKMr/u2tEugB
	 CDSlqSe9BMxJ9S7uUVutCWUfa2JyPu1Jxyv8e7o3AaQkGDIDdBknigGPAe15Iq0qQX
	 NkYzVMzzyax+Zho5K946j0XUVGMLkBxGYrTDK1wL6cmP2CxdcV/nsEojRqpz9yGamD
	 8+QepWenW+CREWvlD9NoqtIAt2dHMzX/GonVLzV9EqAHEXOYe3s3ppPkQxj9A+4Ep/
	 KJz9wDeNVLuviadMxmeOYCgtK1iNkGvmwZWWz9xtJtAK1VVWbk7FO8q78gl3P3GBeM
	 8g2fvlgkF7FeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 35/56] scsi: qla2xxx: Update VP control IOCB handling
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-36-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-36-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:48:19 +0000
Message-Id: <20260717164820.0C32F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The VP control IOCB builder `qla25xx_ctrlvp_iocb()` lacks a bounds=
 check when calculating the index for `vce->vp_idx_map`, allowing an out-of=
-bounds array write if `vp_index` is large (> 128), which corrupts adjacent=
 IOCB payload fields.
--

--- Patch [35]: [PATCH v5 35/56] scsi: qla2xxx: Update VP control IOCB hand=
ling for 29xx series ---
commit 38b9d8323d247867ce71b530d5556e360732b075
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update VP control IOCB handling for 29xx series

This updates VP control IOCB command and response handling to support the
29xx series adapters. It modifies helper functions to accept generic void
pointers so they can handle both standard and extended VP control entry
layouts interchangeably.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c

[ ... ]

> @@ -4074,22 +4074,31 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd=
_pkt)
>  }
> =20
>  static void
> -qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
> +qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
>  {
> +	/*
> +	 * vp_ctrl_entry_24xx_ext is layout-identical to vp_ctrl_entry_24xx
> +	 * for all fields touched here (entry_type, handle, entry_count,

[ ... ]

>  	/*
>  	 * index map in firmware starts with 1; decrement index
>  	 * this is ok as we never use index 0
>  	 */
>  	map =3D (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) / 8;
>  	pos =3D (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) & 7;
> +
> +	vce->entry_type =3D VP_CTRL_IOCB_TYPE;
> +	vce->handle =3D sp->handle;
> +	vce->entry_count =3D 1;
> +	vce->command =3D cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
> +	vce->vp_count =3D cpu_to_le16(1);
>  	vce->vp_idx_map[map] |=3D 1 << pos;

[Severity: High]
This is a pre-existing issue, but does this code overflow the vp_idx_map
array if vp_index exceeds 128?

Looking at the struct definition for vp_ctrl_entry_24xx in qla_fw.h,=20
vp_idx_map is a 16-byte array. If the firmware advertises support for more
than 128 NPIV vports, the calculated map index in qla25xx_ctrlvp_iocb() cou=
ld
be up to 31.

Could this out-of-bounds write corrupt the subsequent fields in the=20
vp_ctrl_entry_24xx payload (like flags, id, and hopct) when an administrator
configures a large number of vports?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D35
