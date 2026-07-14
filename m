Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BBC36492A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 10:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024400; cv=none; b=J39bEO0hgQqW9blxAkk4ujoO+e68PTh08othfXaCiZrLZ9zZxK02EeYMHWn4pXgquK3dh+StAZVu5wjkkaFCXQpNbEBtOVHwkruuQYf0X3JI6JsJw+DqkWR/Vbu6MPgnsV8ZkPe/6BoEYUFs5F2i2VOQ5C4F+JeQ0n66VfhpCm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024400; c=relaxed/simple;
	bh=cjxOpntkmkC8e0D2cGz6Rv1aYkpKUGAOc8KQl/kIXXQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PFVr9xMrW11GXO6RettOfSK4P1IbPcwIIiwLeo+nrvKNoyMZuQYJ0aL6gpL/Ta/UdS76bUtAQHTX65uduV7rAru3eyL0nQhnaVEtgEP4Wofjy24VCwDm1AB2MAlwBy/mPHKsXTdcL/tdv4mYyh8bIQqgY/wc4z/Yk/Z6Zzahq2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWBZPQt4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWBZPQt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE6D1F000E9;
	Tue, 14 Jul 2026 10:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784024399;
	bh=Ss6M42TommU1v4M1430DRf61ZAhsLXoMiN1RZkV/4h0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bWBZPQt4C9CLk11VZmaHISlIaBN1w/85p3e/IVf3i1SLsXsito27Gn1WhTTWVxgm0
	 MjPUYdt7dyf1eMW8nS+y26H01PIAovbCgcaup9U0mhkAf1U+2g+FzJBigoq5rYgc8q
	 hbP3ILCCGDBzgxPA8XRVsffEAe88nTQqC+KV1yadxAwNDtcVggiiyPxhjnVNSVP6HJ
	 TCDzRVcR9Vitl73B79c2yZfbgtcb21MpedA/cTRDYUDvoqxgledlPzzzwRgqBiZtpv
	 5suBvwRFD4Ecvuh3RnXd65o6oF4PmyVOnbKYgZFtyaHkgZFAfObZMGfr3lWqiJs0gk
	 GcOyxhEcNkJiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/56] scsi: qla2xxx: Add 29xx series PCI device ID
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-2-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:19:58 +0000
Message-Id: <20260714101958.EBE6D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [Critical] Missing initialization of ha->tgt.atio_q_length for QLA29XX ca=
uses an infinite loop in the interrupt handler and out-of-bounds DMA corrup=
tion.
- [High] Missing IS_QLA29XX capability checks in target mode initialization=
 logic causes fallback to legacy MMIO paths and skips ICB vector setup.
- [High] Mailbox queue creation commands for QLA29XX omit mandatory SR-IOV =
bits and illegally write to read-only RISC registers.
- [High] Omission of IS_QLA29XX from multiple core architectural capability=
 macros cripples 29xx functionality.
- [Medium] The patch fails to extend speed-capability logic for 29xx adapte=
rs, directly contradicting the commit message.

Pre-existing issues:
- [High] Freeing DMA pool memory into a slab-backed mempool causes slab cor=
ruption.
--

--- Patch [1]: [PATCH v4 01/56] scsi: qla2xxx: Add 29xx series PCI device I=
D support ---
commit d176fdd8e23c51253c0c8552a2ec8303d2e13126
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add 29xx series PCI device ID support

This commit adds PCI device ID support for the new generation QLA29xx
series FC HBA. It registers the new PCI device IDs and wires up
IS_QLA29XX() capability checks in the probe and ISP-flags paths.

> The QLA29xx is a new generation FC HBA that shares much of its
> architecture with the 27xx/28xx family.  Register the new PCI
> device IDs, wire up IS_QLA29XX() capability checks in the probe
> and ISP-flags paths, and extend speed-capability logic so the
> driver correctly recognises and initialises 29xx adapters.

[Severity: Medium]
The commit message mentions extending speed-capability logic for 29xx
adapters, but does this actually happen? In qla2x00_execute_fw(), the
speed-capability parsing logic checks IS_QLA27XX(ha) || IS_QLA28XX(ha)
but omits IS_QLA29XX. Will this cause the driver to fail to correctly
parse or report supported link speeds for 29xx hardware?

[Severity: High]
Are there missing IS_QLA29XX capability checks in the target mode
initialization logic? In qlt_probe_one_stage1(), if mqenable evaluates
to false on a 29xx adapter, the driver configures ATIO queue pointers
to the legacy iobase->isp24 instead of mqiobase. Since 29xx uses a
small legacy iobase, won't accessing ATIO queue registers lead to
out-of-bounds MMIO accesses? Furthermore, qlt_24xx_config_rings() omits
29xx from its checks, completely skipping the configuration of the ATIO
interrupt vector in the ICB.

[Severity: High]
Does this code omit mandatory SR-IOV bits and illegally write to
read-only RISC registers for 29xx? In qla25xx_init_req_que() and
qla25xx_init_rsp_que(), mailbox instructions are constructed using
checks for 83XX, 27XX, and 28XX. Missing the 29XX check skips setting
MBX_15 and MBX_9 | MBX_8 | MBX_7 for SR-IOV support, and critically,
it bypasses the check protecting against writing to the read-only
hardware pointers req_q_out and rsp_q_in, which could corrupt active
queue state on 29xx hardware.

[Severity: High]
This is a pre-existing issue, but can the error path in
qla24xx_start_scsi() and qla24xx_dif_start_scsi() corrupt the slab
allocator? The crc_ctx pointer is allocated from a DMA pool using
dma_pool_zalloc(ha->dl_dma_pool), but in the queuing_error paths, it is
incorrectly freed using mempool_free() back to the slab-backed
ha->ctx_mempool. Should this be freed with dma_pool_free() instead?

> ---
>  drivers/scsi/qla2xxx/qla_def.h  | 33 +++++++++++----
>  drivers/scsi/qla2xxx/qla_init.c |  2 +-
>  drivers/scsi/qla2xxx/qla_isr.c  |  5 ++-
>  drivers/scsi/qla2xxx/qla_os.c   | 74 ++++++++++++++++++++++++++-------
>  4 files changed, 88 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 5593ad7fad274..6337a056b1497 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h

[ ... ]

> @@ -4390,9 +4405,9 @@ struct qla_hw_data {
>  #define HAS_EXTENDED_IDS(ha)    ((ha)->device_type & DT_EXTENDED_IDS)
>  #define IS_CT6_SUPPORTED(ha)	((ha)->device_type & DT_CT6_SUPPORTED)
>  #define IS_MQUE_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
> -				 IS_QLA28XX(ha))
> +				 IS_QLA28XX(ha) || IS_QLA29XX(ha))
>  #define IS_BIDI_CAPABLE(ha) \
> -    (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha=
))
> +    (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha=
) || IS_QLA29XX(ha))

[Severity: High]
Are there other capability macros that need IS_QLA29XX added? For
example, IS_SHADOW_REG_CAPABLE and USE_ASYNC_SCAN in this file appear
to be missing the 29XX check. Will omitting this silently disable high
performance shadow registers and async discovery logic natively supported
by this architecture?

[ ... ]

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

[Severity: Critical]
Does this initialization block miss setting ha->tgt.atio_q_length? Leaving
it zero-initialized results in qlt_mem_alloc() allocating only a 1-entry DMA
buffer for the ATIO ring.=20

When an ATIO interrupt triggers in qlt_24xx_process_atio_queue(), cnt=20
evaluates to 0, causing the code to never update the ATIO_PROCESSED=20
signature or advance the pointer, trapping the CPU in an infinite loop.=20

Furthermore, if an NPIV vport is created, qlt_vport_create() overwrites=20
the length with ATIO_ENTRY_CNT_24XX, leading to out-of-bounds DMA accesses.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D1
