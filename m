Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AA949620
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405284; cv=none; b=APb3PgZBmW29FuRUINuPpAQB+M/fy3GXZI9QSCkk251h0luAHKUGaaD3UVW1ddf1UGnzynhnlh12ev+4rC/Q76hwn4EBXC6xiEJSNspoqufQeVZWb8krxMA8gn/v3t2H7era5kICqCAsBlB1p0ksTHVkHyaE7eVbXoqOULmXcrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405284; c=relaxed/simple;
	bh=JyE83Kfbl+hUnT9jhDJHobEBKSPtAwJaIXpTuFBxT/M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=naBDaVeDyLk20afR3b6czIHSlovttmVcvHbrmrWk+p3F7fKEH41yxloINxiRSRmWB/5sGOqQdWhIhjm9l8HFS3Efew2ylBr4ADSkdtEVhq8A4zhpcRI2R3efbMttvwNOdYmTZeB9H+rlpTd3TvwAkurLl4N0GkytGoxXSm1IF44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=My0Jt5pG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="My0Jt5pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595771F000E9;
	Tue,  7 Jul 2026 06:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405282;
	bh=JL3mjFyz3ZX09htzm41bDjxSSnHjVFXCDCQ6f6ctVTY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=My0Jt5pGx/05AO56OLV70gz123E6p+4bfe0/Sd8ZLoolVq73ar4593XElIqPzD7u8
	 Sye9VcrnHDx8qO8hR9z9s7DmE/8pimq29RhfT+jC6hYblOUvxob9gZSdUC31Z9+ij5
	 d6W2wyqvQMUIxmKDmNKshTPpQa07PY4i41TyKPDwoKnGIwW2ixztGfAK5Ul/Hkhlnl
	 BNQ7BDAfnzFixmyUfo0+5LM0opsjAtO2IwvmE94ywORLJK2BXEBuAUUgNo7t8ksDPd
	 XEelb/FgCatU7f5DlbnUuruojMGT5u8XZ0QGw4L68oWcHNFz2taA3nordvF52KrNG3
	 v3iSyjiEFWgEw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/88] scsi: qla2xxx: Add 29xx series PCI device ID
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-2-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:21:21 +0000
Message-Id: <20260707062122.595771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Incomplete hardware initialization and capability detection for QL=
A29XX adapters.
- [Medium] Missing speed-capability logic modifications promised in the com=
mit message.
--

--- Patch [1]: [PATCH v3 01/88] scsi: qla2xxx: Add 29xx series PCI device I=
D support ---
commit bb93cf91545563a12abad49c8f50d47644a2f103
Author: Manish Rangankar <mrangankar@marvell.com>
Date:   Tue Jul 7 05:53:08 2026 +0000

    scsi: qla2xxx: Add 29xx series PCI device ID support
   =20
    The QLA29xx is a new generation FC HBA that shares much of its
    architecture with the 27xx/28xx family.  Register the new PCI
    device IDs, wire up IS_QLA29XX() capability checks in the probe
    and ISP-flags paths,

>     and extend speed-capability logic so the driver correctly recognises =
and initialises 29xx adapters.

[Severity: Medium]
This isn't a bug, but the commit message states it extends speed-capability
logic. Are there changes missing from this patch? I don't see any
modifications related to speed capability or link rates in the diff.

>    =20
>     Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
>     Signed-off-by: Nilesh Javali <njavali@marvell.com>
>     Reviewed-by: Hannes Reinecke <hare@kernel.org>

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 5593ad7fad274..6337a056b1497 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h

[ ... ]

> @@ -4372,9 +4386,10 @@ struct qla_hw_data {
>  				IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
>  				IS_QLA82XX(ha) || IS_QLA83XX(ha) || \
>  				IS_QLA8044(ha) || IS_QLA27XX(ha) || \
> -				IS_QLA28XX(ha))
> +				IS_QLA28XX(ha) || IS_QLA29XX(ha))
>  #define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha) || IS_QLA83XX(ha) || \
> -				IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +				IS_QLA27XX(ha) || IS_QLA28XX(ha) || \
> +				IS_QLA29XX(ha))
>  #define IS_NOPOLLING_TYPE(ha)	(IS_QLA81XX(ha) && (ha)->flags.msix_enable=
d)
>  #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha) || \
>  				IS_QLA27XX(ha) || IS_QLA28XX(ha))

[Severity: High]
Should IS_FAC_REQUIRED also be updated to include IS_QLA29XX(ha)? It looks
like it was missed here, which could cause missing hardware capability
detection.

[ ... ]

> @@ -4408,12 +4423,12 @@ struct qla_hw_data {
>  #define IS_PI_SPLIT_DET_CAPABLE(ha)	(IS_PI_SPLIT_DET_CAPABLE_HBA(ha) && \
>      (((ha)->fw_attributes_h << 16 | (ha)->fw_attributes) & BIT_22))
>  #define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha) || IS_QLA27XX(ha) || \

[Severity: High]
Should IS_ATIO_MSIX_CAPABLE and IS_SHADOW_REG_CAPABLE be updated to include
IS_QLA29XX(ha) as well? The macro definitions appear to omit the new adapte=
rs,
which might break ATIO interrupt setup and shadow register support.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 72b1c28e4dae0..c91d2b8bd08e7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c

[ ... ]

> @@ -3195,6 +3221,22 @@ qla2x00_probe_one(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
>  		ha->flash_data_off =3D FARX_ACCESS_FLASH_DATA_28XX;
>  		ha->nvram_conf_off =3D ~0;
>  		ha->nvram_data_off =3D ~0;
> +	} else if (IS_QLA29XX(ha)) {
> +		ha->portnum =3D PCI_FUNC(ha->pdev->devfn);
> +		ha->max_fibre_devices =3D MAX_FIBRE_DEVICES_2400;
> +		ha->mbx_count =3D MAILBOX_REGISTER_COUNT;
> +		req_length =3D REQUEST_ENTRY_CNT_83XX;
> +		rsp_length =3D RESPONSE_ENTRY_CNT_83XX;

[Severity: High]
Does this initialization block miss the ha->tgt.atio_q_length setup?
Looking at qla2x00_probe_one(), the older 27xx and 28xx families initialize
this field:

	} else if (IS_QLA28XX(ha)) {
		...
		req_length =3D REQUEST_ENTRY_CNT_83XX;
		rsp_length =3D RESPONSE_ENTRY_CNT_83XX;
		ha->tgt.atio_q_length =3D ATIO_ENTRY_CNT_24XX;

Would omitting it for IS_QLA29XX(ha) break Target mode (ATIO)? Also, should
qlt_probe_one_stage1() in qla_target.c and hardware mailbox functions in
qla_mbx.c (such as qla25xx_init_req_que()) be updated to include the
new IS_QLA29XX(ha) check?

> +		ha->max_loop_id =3D SNS_LAST_LOOP_ID_2300;
> +		ha->init_cb_size =3D sizeof(struct mid_init_cb_81xx);
> +		ha->gid_list_info_size =3D 8;
> +		ha->optrom_size =3D OPTROM_SIZE_28XX;
> +		ha->nvram_npiv_size =3D QLA_MAX_VPORTS_QLA25XX;
> +		ha->isp_ops =3D &qla27xx_isp_ops;
> +		ha->flash_conf_off =3D ~0;
> +		ha->flash_data_off =3D ~0;
> +		ha->nvram_conf_off =3D ~0;
> +		ha->nvram_data_off =3D ~0;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D1
