Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53388426410
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409643; cv=none; b=XkncVj0yVwrrXTj7SB/+PRVhfM1Ms0khhidx2JbU4GeGqk4hVDbN1QmFK+MSt8Kci+Z1meufGckcmY3/An/Rtfs1oCnvSiscyEmOOkLs7fqMCLfRhkCMwfO/JFRyAiVQ6ppuww19rEoNZ9KEuT9a7Rtv3dM/Kd3vGvkTA+CSYTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409643; c=relaxed/simple;
	bh=m5zhTTgNJnXA7MlkHiLOZ5KhJii8czHG8k3VSfehOy0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QCbQLdsbs0j18RG3jnGIy1e9l2EzSR1PrvM4CNQTM+OjxIAWTtJ/NopihApL8FDuTZdOqZupFxyO7SNChH01TTKKeRrBNC/4YBfLnQ9cUPp9ojYbbCe0wy1BDgl4JaJ56wrAuwALPiUmsZ5GGs7t9Z1pi3wq1xOaQ9tiyKUsB3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8aewZvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8aewZvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1932E1F00A3F;
	Tue,  7 Jul 2026 07:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409642;
	bh=D7V25pJLH9XQbiZ7rUXnn6Cv5pfBBv2rBR2Jpcdz5PI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d8aewZvomhyfYntlR5uDmL624lbV+SdNr10oRBU0hs9CMG3ptFe0xFurWumpgCBQf
	 T/8yAJ7KOGXh6JiA6WkP4IyI7+KPre3gtFfXTPCc3usWz0PPfusPXz9lqdUPKcW+7M
	 0sWuXBpaGB45FBxBR5sazL6gLfxMC5uFsxWitCId/N78UMgg+1ri1NPc/685QacbXS
	 xlfGQPWWBQBYWe962HeW60ec/wnJqrd6kMCpZNW9yRP2UxLUoxZ+7h6+NkIINjUHvi
	 aqdEckTWWL4ja5rV2EOmOG+rDunRyfKhd63Nucl3btmxgTG0zGcpfSv8gz0vLCIRP/
	 +2pQjTSZ02Ghg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 74/88] scsi: qla2xxx: Clamp max_npiv_vports to
 VP_CTRL bitmap capacity
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-75-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-75-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:34:01 +0000
Message-Id: <20260707073402.1932E1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The introduced cap on `ha->max_npiv_vports` is immediately overwri=
tten by firmware values, leaving the intended resource leak completely unpa=
tched.

Pre-existing issues:
- [High] A pre-existing off-by-one error in `qla24xx_control_vp()` guarante=
es that the vport at the highest valid index will always leak.
- [High] Data race on bitfields in the `ha->flags` structure leading to los=
t mailbox interrupts and adapter hangs.
--

--- Patch [74]: [PATCH v3 74/88] scsi: qla2xxx: Clamp max_npiv_vports to VP=
_CTRL bitmap capacity ---
commit 200dabdd0444e358cb943332543c7d1ad6735f45
Author: Nilesh Javali <njavali@marvell.com>
scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity

This commit attempts to prevent a virtual port resource leak by capping the
maximum number of NPIV vports to the capacity of the VP_CTRL IOCB index
bitmap. It updates the maximum count during chip setup and modifies the
bounds check during VP control operations.

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index d678e27213a94..1f20ab386003d 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4412,6 +4412,19 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
>  					    MIN_MULTI_ID_FABRIC))
>  						ha->max_npiv_vports =3D
>  						    MIN_MULTI_ID_FABRIC - 1;

[Severity: High]
This isn't a bug introduced by this patch, but can the initialization of
ha->flags in this block cause a data race that drops mailbox interrupts?

The ha->flags structure is a collection of bitfields sharing a 32-bit word.
During qla2x00_setup_chip(), lockless writes occur right before this logic,
such as setting npiv_supported:

qla2x00_setup_chip()
    ha->flags.npiv_supported =3D 1;

If the hardware issues a concurrent mailbox completion interrupt, the ISR
will acquire the hardware lock and set the mbox_int bit:

qla24xx_intr_handler() -> qla2x00_mbx_completion()
    ha->flags.mbox_int =3D 1;

Could the lockless read-modify-write phase of setting npiv_supported
overwrite and clear the newly set mbox_int bit, leading to a mailbox command
timeout?

> +
> +					/*
> +					 * The VP_CTRL IOCB selects target VPs
> +					 * through the fixed vp_idx_map bitmap,
> +					 * so a vp_index beyond it can be enabled
> +					 * via VP_CONFIG but never disabled via
> +					 * VP_CTRL, leaking the VP.  Cap the count
> +					 * to the bitmap capacity.
> +					 */
> +					if (ha->max_npiv_vports >=3D
> +					    VP_CTRL_IDX_MAP_BITS)
> +						ha->max_npiv_vports =3D
> +						    VP_CTRL_IDX_MAP_BITS - 1;
>  				}
>  				qlt_config_nvram_with_fw_version(vha);
>  				qla2x00_get_resource_cnts(vha);

[Severity: High]
Does the subsequent call to qla2x00_get_resource_cnts() immediately overwri=
te
this newly calculated cap?

Looking at qla2x00_get_resource_cnts(), it unconditionally assigns the raw
firmware value back to max_npiv_vports:

qla2x00_get_resource_cnts() {
    ...
    if (ha->flags.npiv_supported)
        ha->max_npiv_vports =3D mcp->mb[11];
    ...
}

Will this cause the intended cap to be lost before it can prevent the
resource leak?

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 33bfc61d81652..4ad23d206add2 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -996,7 +996,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>  	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
>  	 * if firmware advertises more NPIV vports.
>  	 */
> -	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
> +	if (vp_index > VP_CTRL_IDX_MAP_BITS)
>  		return QLA_PARAMETER_ERROR;

[Severity: High]
This is a pre-existing issue, but does the strict inequality check on
max_npiv_vports earlier in this function create an off-by-one error?

In qla24xx_allocate_vp_id(), the allocator searches up to max_npiv_vports +=
 1:

qla24xx_allocate_vp_id() {
    ...
    vp_id =3D find_first_zero_bit(ha->vp_idx_map, ha->max_npiv_vports + 1);
    if (vp_id > ha->max_npiv_vports) {
    ...
}

This permits allocating an ID exactly equal to ha->max_npiv_vports.

However, earlier in qla24xx_control_vp(), the check rejects values greater
than or equal to max_npiv_vports:

    if (vp_index =3D=3D 0 || vp_index >=3D ha->max_npiv_vports)
        return QLA_PARAMETER_ERROR;

Will this cause the virtual port at the highest index to be successfully
created, but silently rejected during deletion, leaving it permanently
active in the firmware?

> =20
>  	/* ref: INIT */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D74
