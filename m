Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FF237418C
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306185; cv=none; b=F5ij8/y78VfaMl0I7BV45z7UcfBp45Mu7snjq08PebgcC7FQljbQTpTH6UqaozzXsYQ+yv0VdtO3XlLNPbtBAEtrP2LLZjNuxFYJCNbmek2U5wCiE0byKvVnwAl/X5HPQIr8H4spRQgdH+zD5SjIG6E2aAJIqnnJ4Ct9ZgMHDwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306185; c=relaxed/simple;
	bh=o4cSVm/n1rxEzunE/9/Bf36jGD91Zs6LBna0IDPzbfk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sJnoU0C882ETlgLE2k4JSUwLoGo5swBwO8iTEhBWnSgCwv8OnFxGwn2zOBCY52PkeFZ3/yokOd5BTxfTn/wo5Z1aZV9tMLFBEV5ozih3CbAHBpr1t0TuKei0wKKGuRRaUZ59UvE0SjxkU8bNga9tiiMXRpunnyaxTShFDyaqFms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h2tUEnoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h2tUEnoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915491F000E9;
	Fri, 17 Jul 2026 16:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306183;
	bh=wK+J6Xg1qkwifPIrf0mNCWWeSNaCeZhrfAw/m1sDZhs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h2tUEnoCYidlU4kSvz9Rvh/2k7mc3iXYBCmHcSFqI1IV8Df5IGUjnuf3P0tIfHsU9
	 JbOB50378Il+JufNADrz0qF8TH2tmHSiJFTGf2ug4F6GQb4uNaw47aoAFIXDD9+BBU
	 tqw7RibSytgbkpvlClC++Eux5yjSl7IvkupQ1WU65QJ5vmqMDq9k9wSAS0INpLU0W7
	 QRIJ1dYKCvBKFCNGU0MIHItFE2/1AkrnXJO6tzGclli1LNb9i8XEq31HqhP2sqNdlB
	 4uTVuIT7NG/f4A6f8416Il2MAGoOe5RyZRHtHrkjt1cR0Zeq6juhxzA9tnWkU9HBp3
	 EgK9yQeNpKLEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/56] scsi: qla2xxx: Add 29xx series PCI device ID
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-2-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:36:23 +0000
Message-Id: <20260717163623.915491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] The patch fails to integrate IS_QLA29XX() into numerous hardware c=
apability macros and control paths, silently breaking hardware queue pointe=
rs, shadow registers, and other driver capabilities.
- [Medium] Initialization of ha->isp_type for QLA29XX incorrectly sets all =
four device variant bits simultaneously, breaking discrete model tracking.
- [Medium] The patch claims to extend speed-capability logic for 29xx adapt=
ers, but the logic is missing from the implementation.

Pre-existing issues:
- [High] Unconditional dereference of unmapped IO memory `ha->mqiobase` if =
ioremap fails for modern adapters (83XX, 27XX, 28XX, 29XX).
- [High] An integer underflow occurs when calculating the number of support=
ed queue pairs if the PCI device exposes exactly 1 MSI-X vector, leading to=
 out-of-bounds dereferences.
--

--- Patch [1]: [PATCH v5 01/56] scsi: qla2xxx: Add 29xx series PCI device I=
D support ---
commit b71b2c76f9739885a4fcd4a38d9ac5ed74df7767
Author: Manish Rangankar <mrangankar@marvell.com>
Subject: scsi: qla2xxx: Add 29xx series PCI device ID support

This commit adds support for the new QLA29xx generation of FC HBAs. It
registers the new PCI device IDs and updates various initialization paths
and capability checks to correctly recognize the 29xx adapters.

> The QLA29xx is a new generation FC HBA that shares much of its
> architecture with the 27xx/28xx family.  Register the new PCI
> device IDs, wire up IS_QLA29XX() capability checks in the probe
> and ISP-flags paths, and extend speed-capability logic so the
> driver correctly recognises and initialises 29xx adapters.

[Severity: Medium]
The commit message mentions extending speed-capability logic for 29xx adapt=
ers,
but are these changes missing from the implementation? Looking at functions
like qla25xx_fdmi_port_speed_capability() in qla_gs.c, they do not appear to
have been updated to check for IS_QLA29XX, which seems to contradict the
commit message.

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
[ ... ]
@@ -4372,9 +4386,10 @@ struct qla_hw_data {
 				IS_QLA25XX(ha) || IS_QLA81XX(ha) || \
 				IS_QLA82XX(ha) || IS_QLA83XX(ha) || \
 				IS_QLA8044(ha) || IS_QLA27XX(ha) || \
-				IS_QLA28XX(ha))
+				IS_QLA28XX(ha) || IS_QLA29XX(ha))
 #define IS_MSIX_NACK_CAPABLE(ha) (IS_QLA81XX(ha) || IS_QLA83XX(ha) || \
-				IS_QLA27XX(ha) || IS_QLA28XX(ha))
+				IS_QLA27XX(ha) || IS_QLA28XX(ha) || \
+				IS_QLA29XX(ha))
 #define IS_NOPOLLING_TYPE(ha)	(IS_QLA81XX(ha) && (ha)->flags.msix_enabled)
 #define IS_FAC_REQUIRED(ha)	(IS_QLA81XX(ha) || IS_QLA83XX(ha) || \
 				IS_QLA27XX(ha) || IS_QLA28XX(ha))

[Severity: High]
Does this patch miss integrating IS_QLA29XX() into some hardware capability
macros, such as ISP_QUE_REG() and IS_SHADOW_REG_CAPABLE()?

If IS_QLA29XX() is omitted from ISP_QUE_REG():

drivers/scsi/qla2xxx/qla_def.h:ISP_QUE_REG() {
#define ISP_QUE_REG(ha, id) \
        ((ha->mqenable || IS_QLA83XX(ha) || \
          IS_QLA27XX(ha) || IS_QLA28XX(ha)) ? \
         ((void __iomem *)ha->mqiobase + (QLA_QUE_PAGE * id)) :\
         ((void __iomem *)ha->iobase))
}

The driver will incorrectly fall back to ha->iobase instead of ha->mqiobase
when mqenable is false, causing queue pointers to be initialized to the wro=
ng
MMIO registers and leading to timeouts and crashes when qla24xx_config_ring=
s()
is called.

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
@@ -2203,10 +2202,18 @@ qla83xx_iospace_config(struct qla_hw_data *ha)
 	ha->msixbase =3D ioremap(pci_resource_start(ha->pdev, 2),
 			pci_resource_len(ha->pdev, 2));
 	if (ha->msixbase) {
+		int msix_cnt;
+
 		/* Read MSIX vector size of the board */
-		pci_read_config_word(ha->pdev,
-		    QLA_83XX_PCI_MSIX_CONTROL, &msix);
-		ha->msix_count =3D (msix & PCI_MSIX_FLAGS_QSIZE)  + 1;
+		msix_cnt =3D pci_msix_vec_count(ha->pdev);
+		if (msix_cnt <=3D 0) {
+			ql_log_pci(ql_log_warn, ha->pdev, 0x0120,
+				   "Failed to read MSI-X count (%d), falling back to base vectors.\n",
+				   msix_cnt);
+			goto mqiobase_exit;

[Severity: High]
This is a pre-existing issue, but can this error path lead to a NULL pointer
dereference? If ioremap for ha->mqiobase fails earlier in
qla83xx_iospace_config(), or if we jump to mqiobase_exit here, the function
returns 0 (success). Later in probe, qla2x00_probe_one() unconditionally
computes offsets against ha->mqiobase for these modern adapters:

drivers/scsi/qla2xxx/qla_os.c:qla2x00_probe_one() {
        if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
            IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
                req->req_q_in =3D &ha->mqiobase->isp25mq.req_q_in;
        ...
}

This would cause a crash during I/O since ha->mqiobase is NULL.

[Severity: High]
This is a pre-existing issue, but does this calculation risk integer underf=
low
if the PCI device exposes exactly 1 MSI-X vector? If msix_cnt is 1, the code
later in qla83xx_iospace_config() does:

drivers/scsi/qla2xxx/qla_os.c:qla83xx_iospace_config() {
        ha->max_req_queues =3D ha->msix_count - 1;
        ...
        ha->max_qpairs =3D ha->max_req_queues - 1;
}

Since ha->max_qpairs is a uint8_t, it would underflow to 255. During probe,
qla2x00_probe_one() will assign this underflowed value to host->nr_hw_queue=
s if
ql2xnvmeenable is active, which exposes 255 nonexistent hardware queues to =
the
NVMe/block layer and can lead to out-of-bounds accesses.

+		}
+		ha->msix_count =3D msix_cnt;
+
 		/*
 		 * By default, driver uses at least two msix vectors
 		 * (default & rspq)
[ ... ]
@@ -2796,6 +2803,20 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->device_type |=3D DT_T10_PI;
 		ha->fw_srisc_address =3D RISC_START_ADDRESS_2400;
 		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2099:
+	case PCI_DEVICE_ID_QLOGIC_ISP2299:
+	case PCI_DEVICE_ID_QLOGIC_ISP2091:
+	case PCI_DEVICE_ID_QLOGIC_ISP2291:
+		ha->isp_type |=3D DT_ISP2299;
+		ha->isp_type |=3D DT_ISP2099;
+		ha->isp_type |=3D DT_ISP2091;
+		ha->isp_type |=3D DT_ISP2291;

[Severity: Medium]
Will setting all four discrete device variant bits simultaneously break the
discrete model tracking? Since ha->isp_type contains all four bits, macros
like IS_QLA2091() will return true for any QLA29xx adapter. Should this code
only set the specific bit that corresponds to the detected PCI device ID?

+		ha->device_type |=3D DT_ZIO_SUPPORTED;
+		ha->device_type |=3D DT_FWI2;
+		ha->device_type |=3D DT_IIDMA;
+		ha->device_type |=3D DT_T10_PI;
+		ha->fw_srisc_address =3D RISC_START_ADDRESS_2400;
+		break;
 	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D1
