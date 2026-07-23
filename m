Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1722C3016EE
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784784584; cv=none; b=CNT/uDCJsKoBpg8E+WmSsfDu6ywECn8lECxyrSqcfQ9NY1JuHVGI/3CIS6WSKS+J6Z7MsX1d7HpfBySZVbi2rLKN/5BjKBrp4x4YTeRgbMU8F2td5sD9oZwhgmVFAGxUWanVYHwhBxLuZe9OBYlxwkelVxXMdMa30bXrWP+JQq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784784584; c=relaxed/simple;
	bh=MNLj0ef41gr1TlQi0YFlZ4l72+AvZHrFgmVflM9pfaQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IGxvxANPnOEnvGroGDQJD9ntRHrD+0+V7bIiNRVRtRDLXpTzMJwX/hNgB5folTwOQqMHvmZd9SOuoq4nzp/0stNd4fDviDAKIcRpHWHggxXNfRCJJ6fZU1kXyhbLzqMURa4hnWJ3NzmjwQxzn6eHpddvjGfoC+f/IpCsWWRlbAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nr/hwvEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nr/hwvEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9077E1F000E9;
	Thu, 23 Jul 2026 05:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784784582;
	bh=Hz+5ETbrYZweW37eDZDIztwv1n6VE6UG4uj31RZi27I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nr/hwvECESAHdUAxbVcWMH3KFQcNUJPAc5Q4enQzzahPKOWpbtzasXxDkmG8wH0s2
	 7SxzTNGcLLAtFWJ+UyKzgpM3LIcW/nm3tnJKeHdMyPLxgbGEGIXF1p1VcFQzZi4Bbf
	 F0eZbOVXGfc0RcRz7H3Mx5wJQoFkgPkiPka4VKdTSU8MpIde3uMv5kbffM5ZvP8pEB
	 0onfe8PoGYRfSYpvdh0eZ7zwy9ElR7KlpF5I3QZE30oRlz5NfuNOeCxepbo5osovjA
	 tHpueQelk79NKASmuTq2bicfNJmJFr9CSYtkM2Edv4+UR7lizr85R75JdpOodfj8sm
	 f/G+RYX5hpPDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/56] scsi: qla2xxx: Add 29xx series PCI device ID
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-2-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 05:29:42 +0000
Message-Id: <20260723052942.9077E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [High] Critical architectural capability macros omit the QLA29xx family, =
silently breaking Target Mode and other hardware offloads.
- [High] Hardware queue doorbell registers are incorrectly evaluated when M=
SI-X is disabled, causing immediate I/O hangs on QLA29XX adapters.
- [High] Optrom sysfs handlers perform invalid flash address calculations f=
or QLA29XX due to uninitialized (~0) offsets.
- [Medium] All four 29xx device-specific ISP type bits are OR'd together un=
conditionally, breaking individual device identification.
- [Medium] SysFS attributes and Block SCSI Generic (BSG) endpoints uncondit=
ionally reject requests for QLA29XX adapters.

Pre-existing issues:
- [High] Unchecked NULL pointer passed to dma_pool_free() in memory allocat=
ion error handling path.
- [High] MSI-X vector count truncation leads to ZERO_SIZE_PTR allocation an=
d subsequent kernel panic.
--

--- Patch [1]: [PATCH v6 01/56] scsi: qla2xxx: Add 29xx series PCI device I=
D support ---
commit c27da2e671417436f3a15a5fd351d1bc9cab793a
Author: Manish Rangankar <mrangankar@marvell.com>
Subject: scsi: qla2xxx: Add 29xx series PCI device ID support

This commit introduces support for the QLA29xx series FC HBA by registering
new PCI device IDs and adding capability checks in the probe and ISP-flag
paths. It also extends speed-capability logic to initialize 29xx adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 5593ad7fad274..6337a056b1497 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
[ ... ]
> @@ -4408,12 +4423,12 @@ struct qla_hw_data {
>  	(QLA_NVME_IOS(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
> =20
>  #define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
> -					 IS_QLA28XX(ha))
> +					 IS_QLA28XX(ha) || IS_QLA29XX(ha))
>  #define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
> -					 IS_QLA28XX(ha))
> +					 IS_QLA28XX(ha) || IS_QLA29XX(ha))
>  #define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
>  #define IS_PI_SPLIT_DET_CAPABLE_HBA(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha=
) || \
> -					IS_QLA28XX(ha))
> +					IS_QLA28XX(ha) || IS_QLA29XX(ha))

[Severity: High]
Are we missing QLA29XX additions in several other critical macros?

For instance, IS_ATIO_MSIX_CAPABLE() in qla_def.h omits IS_QLA29XX(ha).
Without this, qla24xx_enable_msix() will skip allocating the ATIO queue
MSI-X vector, which might cause Target Mode I/O hangs.

Similarly, ISP_QUE_REG() lacks IS_QLA29XX(ha). If mqenable is 0, this macro
evaluates to ha->iobase instead of the expected mqiobase for newer adapters.
Could this zero out unrelated registers in Region 0 during queue
configuration?

[Severity: Medium]
Will administrative sysfs and BSG endpoints reject 29xx adapters?

Several management endpoints in qla_attr.c (like qla2x00_port_speed_store)
and qla_bsg.c (like qla2x00_update_optrom) have explicit checks for
!IS_QLA27XX(ha) && !IS_QLA28XX(ha). Without adding IS_QLA29XX to these
checks, could user-space utilities attempting to read link data or execute
firmware updates fail with -EPERM?

>  #define IS_PI_SPLIT_DET_CAPABLE(ha)	(IS_PI_SPLIT_DET_CAPABLE_HBA(ha) && \
>      (((ha)->fw_attributes_h << 16 | (ha)->fw_attributes) & BIT_22))
>  #define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 72b1c28e4dae0..c91d2b8bd08e7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -2203,10 +2202,18 @@ qla83xx_iospace_config(struct qla_hw_data *ha)
>  	ha->msixbase =3D ioremap(pci_resource_start(ha->pdev, 2),
>  			pci_resource_len(ha->pdev, 2));
>  	if (ha->msixbase) {
> +		int msix_cnt;
> +
>  		/* Read MSIX vector size of the board */
> -		pci_read_config_word(ha->pdev,
> -		    QLA_83XX_PCI_MSIX_CONTROL, &msix);
> -		ha->msix_count =3D (msix & PCI_MSIX_FLAGS_QSIZE)  + 1;
> +		msix_cnt =3D pci_msix_vec_count(ha->pdev);
> +		if (msix_cnt <=3D 0) {
> +			ql_log_pci(ql_log_warn, ha->pdev, 0x0120,
> +				   "Failed to read MSI-X count (%d), falling back to base vectors.\n=
",
> +				   msix_cnt);
> +			goto mqiobase_exit;
> +		}
> +		ha->msix_count =3D msix_cnt;
> +
>  		/*
>  		 * By default, driver uses at least two msix vectors
>  		 * (default & rspq)

[Severity: High]
This is a pre-existing issue, but could this vector count calculation lead =
to
a kernel panic?

In qla83xx_iospace_config(), pci_msix_vec_count() returns the board's
supported MSI-X vectors, and the driver bounds it:

    ha->max_req_queues =3D ha->msix_count - 1;

Since max_req_queues is an 8-bit unsigned integer (uint8_t), if a device
supports 257 or more vectors, max_req_queues will overflow to 0.

When passed to kzalloc_objs() in qla2x00_alloc_queues():

    ha->req_q_map =3D kzalloc_objs(struct req_que *, ha->max_req_queues);

This 0-sized request returns ZERO_SIZE_PTR (0x10), which is later
dereferenced during queue initialization. Should we cap the msix_count to
ensure it fits within the 8-bit limit?

[ ... ]
> @@ -2796,6 +2803,20 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
>  		ha->device_type |=3D DT_T10_PI;
>  		ha->fw_srisc_address =3D RISC_START_ADDRESS_2400;
>  		break;
> +	case PCI_DEVICE_ID_QLOGIC_ISP2099:
> +	case PCI_DEVICE_ID_QLOGIC_ISP2299:
> +	case PCI_DEVICE_ID_QLOGIC_ISP2091:
> +	case PCI_DEVICE_ID_QLOGIC_ISP2291:
> +		ha->isp_type |=3D DT_ISP2299;
> +		ha->isp_type |=3D DT_ISP2099;
> +		ha->isp_type |=3D DT_ISP2091;
> +		ha->isp_type |=3D DT_ISP2291;

[Severity: Medium]
Does this unconditionally combine all four 29xx device-specific bits?

When any QLA29XX adapter is probed, all four bits are OR'd into
ha->isp_type. Will this cause specific device capability macros like
IS_QLA2299(ha) to incorrectly evaluate to true for all 29xx models
(e.g., ISP2091), breaking individual device identification?

> +		ha->device_type |=3D DT_ZIO_SUPPORTED;
> +		ha->device_type |=3D DT_FWI2;
> +		ha->device_type |=3D DT_IIDMA;
> +		ha->device_type |=3D DT_T10_PI;
> +		ha->fw_srisc_address =3D RISC_START_ADDRESS_2400;
> +		break;
>  	}
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

[Severity: High]
Will this generate an invalid physical address during firmware mailbox
commands?

For the QLA29XX, the driver assigns ha->isp_ops =3D &qla27xx_isp_ops; but s=
ets
ha->flash_data_off =3D ~0.

When the inherited 27xx read_optrom sysfs handler calls flash_data_addr(),
it calculates ha->flash_data_off + faddr. Since the offset is ~0, this will
wrap around to faddr - 1.

Could using this invalid physical address in commands like qla2x00_dump_ram
lead to uncontrolled firmware memory corruption or an adapter hang?

> +		ha->nvram_conf_off =3D ~0;
> +		ha->nvram_data_off =3D ~0;
>  	}
[ ... ]
> @@ -4387,7 +4429,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t =
req_len, uint16_t rsp_len,
> =20
>  	/* Get consistent memory allocated for EX-INIT-CB. */
>  	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
> -	    IS_QLA28XX(ha)) {
> +	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>  		ha->ex_init_cb =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
>  		    &ha->ex_init_cb_dma);

[Severity: High]
This isn't a bug introduced by this patch, but could this error recovery pa=
th
cause a kernel panic?

If a memory allocation fails during qla2x00_mem_alloc(), the error recovery
paths unconditionally call dma_pool_free():

fail_async_pd:
    dma_pool_free(ha->s_dma_pool, ha->sf_init_cb, ha->sf_init_cb_dma);
fail_sf_init_cb:
    dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);

If these pointers were never allocated, they remain NULL. Passing a NULL
pointer to dma_pool_free() causes an invalid memory dereference when
virt_to_head_page() evaluates it. Should we add NULL checks before freeing
these pool objects?

>  		if (!ha->ex_init_cb)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D1
