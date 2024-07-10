Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93A6194A59
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631493; cv=none; b=Hg/SafJmTuUjBWwci0ObIHAIog41C9XTSPH9krpoSAAZh3OHaAJAc/wft3mznMRoKHCPDiKtopGmPZqot2p1PvEZcMP6RD5Boly91FZiybcf2VdPREFKHlV27TqsxbluQF8OQjAhcqkMNG+7xKUJiuOEJiHXy5Jsv2RkQImyh38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631493; c=relaxed/simple;
	bh=o5tWcg1ed2bpUAhE2MejztNtXdVlC6oTOiAEaCM6mLA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4NBmNL+zsIjDRBcA4CKnLBD/LmAJLWEN7uZ2XRm0EYo1UbtQtIXxDV6rCOdZEpC15EfDHIiyZKS20EGQTzJlYeOJwYFxnuu6zmt35uyUTX5qP4uZMLzYt7QvYLcADBPpVXIk0pofcYe1qtdDzg8GpXEA3Jwrlrrkh+iCvoBU/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=eB4bns6J; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eB4bns6J"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AGCxJa017206;
	Wed, 10 Jul 2024 10:11:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=U
	4OjbsxBInl7y4/8YYKhyUW5Le1QI3abOOMFbIxrMt0=; b=eB4bns6JlxwstlDuO
	YjK6ndt/eFENZ8nK4EmYeoLudTmALoeCms0m+nPHEmNnSAsMhMMpvfDr29t95vmQ
	+1orjBo5eFUu7QDymxEE6uvbiNi8zLYxDcGPzcFit05lJdjdfGEFXSasZ834Y/0x
	LAknBH3iiCKwMFrfBvMHVlEB/P9WrRfHThYG95vnXocqnyFmT/X0TCaunuqtm8U8
	aBRYljMMPnOHQXXPb/ofn+kApZLfjqkHLc/RpIqwwL6uimq5WHiC/VL6CdScit6r
	X454OKnzDg3/B5VBi4bNJ0G5IhbJno2Ty9XpZbDSuQuscQHFTAW8gMBSdZBVw2MH
	LDYRg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 409wmd8avu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 10:11:26 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 10:11:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 10:11:26 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id C01A53F708F;
	Wed, 10 Jul 2024 10:11:23 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 05/11] qla2xxx: Fix flash read failure
Date: Wed, 10 Jul 2024 22:40:51 +0530
Message-ID: <20240710171057.35066-6-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240710171057.35066-1-njavali@marvell.com>
References: <20240710171057.35066-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: rjyB2SDAu6xiYsY7MtTZX1luZgOoocEv
X-Proofpoint-ORIG-GUID: rjyB2SDAu6xiYsY7MtTZX1luZgOoocEv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_12,2024-07-10_01,2024-05-17_01

From: Quinn Tran <qutran@marvell.com>

Link up failure is observed as a result of flash read failure.
Current code does not check flash read return code where it relies on
FW checksum to detect the problem.

Add check of flash read failure to detect the problem sooner.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/202406210815.rPDRDMBi-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
v2:
- Fix smatch warn, qla24xx_get_flash_version() warn: missing error code? 'ret'

 drivers/scsi/qla2xxx/qla_init.c |  63 +++++++++++++++----
 drivers/scsi/qla2xxx/qla_sup.c  | 108 ++++++++++++++++++++++----------
 2 files changed, 125 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d88f05ea55cb..5ff017546540 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8221,15 +8221,21 @@ qla28xx_get_aux_images(
 	struct qla27xx_image_status pri_aux_image_status, sec_aux_image_status;
 	bool valid_pri_image = false, valid_sec_image = false;
 	bool active_pri_image = false, active_sec_image = false;
+	int rc;
 
 	if (!ha->flt_region_aux_img_status_pri) {
 		ql_dbg(ql_dbg_init, vha, 0x018a, "Primary aux image not addressed\n");
 		goto check_sec_image;
 	}
 
-	qla24xx_read_flash_data(vha, (uint32_t *)&pri_aux_image_status,
+	rc = qla24xx_read_flash_data(vha, (uint32_t *)&pri_aux_image_status,
 	    ha->flt_region_aux_img_status_pri,
 	    sizeof(pri_aux_image_status) >> 2);
+	if (rc) {
+		ql_log(ql_log_info, vha, 0x01a1,
+		    "Unable to read Primary aux image(%x).\n", rc);
+		goto check_sec_image;
+	}
 	qla27xx_print_image(vha, "Primary aux image", &pri_aux_image_status);
 
 	if (qla28xx_check_aux_image_status_signature(&pri_aux_image_status)) {
@@ -8260,9 +8266,15 @@ qla28xx_get_aux_images(
 		goto check_valid_image;
 	}
 
-	qla24xx_read_flash_data(vha, (uint32_t *)&sec_aux_image_status,
+	rc = qla24xx_read_flash_data(vha, (uint32_t *)&sec_aux_image_status,
 	    ha->flt_region_aux_img_status_sec,
 	    sizeof(sec_aux_image_status) >> 2);
+	if (rc) {
+		ql_log(ql_log_info, vha, 0x01a2,
+		    "Unable to read Secondary aux image(%x).\n", rc);
+		goto check_valid_image;
+	}
+
 	qla27xx_print_image(vha, "Secondary aux image", &sec_aux_image_status);
 
 	if (qla28xx_check_aux_image_status_signature(&sec_aux_image_status)) {
@@ -8320,6 +8332,7 @@ qla27xx_get_active_image(struct scsi_qla_host *vha,
 	struct qla27xx_image_status pri_image_status, sec_image_status;
 	bool valid_pri_image = false, valid_sec_image = false;
 	bool active_pri_image = false, active_sec_image = false;
+	int rc;
 
 	if (!ha->flt_region_img_status_pri) {
 		ql_dbg(ql_dbg_init, vha, 0x018a, "Primary image not addressed\n");
@@ -8361,8 +8374,14 @@ qla27xx_get_active_image(struct scsi_qla_host *vha,
 		goto check_valid_image;
 	}
 
-	qla24xx_read_flash_data(vha, (uint32_t *)(&sec_image_status),
+	rc = qla24xx_read_flash_data(vha, (uint32_t *)(&sec_image_status),
 	    ha->flt_region_img_status_sec, sizeof(sec_image_status) >> 2);
+	if (rc) {
+		ql_log(ql_log_info, vha, 0x01a3,
+		    "Unable to read Secondary image status(%x).\n", rc);
+		goto check_valid_image;
+	}
+
 	qla27xx_print_image(vha, "Secondary image", &sec_image_status);
 
 	if (qla27xx_check_image_status_signature(&sec_image_status)) {
@@ -8434,11 +8453,10 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	    "FW: Loading firmware from flash (%x).\n", faddr);
 
 	dcode = (uint32_t *)req->ring;
-	qla24xx_read_flash_data(vha, dcode, faddr, 8);
-	if (qla24xx_risc_firmware_invalid(dcode)) {
+	rval = qla24xx_read_flash_data(vha, dcode, faddr, 8);
+	if (rval || qla24xx_risc_firmware_invalid(dcode)) {
 		ql_log(ql_log_fatal, vha, 0x008c,
-		    "Unable to verify the integrity of flash firmware "
-		    "image.\n");
+		    "Unable to verify the integrity of flash firmware image (rval %x).\n", rval);
 		ql_log(ql_log_fatal, vha, 0x008d,
 		    "Firmware data: %08x %08x %08x %08x.\n",
 		    dcode[0], dcode[1], dcode[2], dcode[3]);
@@ -8452,7 +8470,12 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	for (j = 0; j < segments; j++) {
 		ql_dbg(ql_dbg_init, vha, 0x008d,
 		    "-> Loading segment %u...\n", j);
-		qla24xx_read_flash_data(vha, dcode, faddr, 10);
+		rval = qla24xx_read_flash_data(vha, dcode, faddr, 10);
+		if (rval) {
+			ql_log(ql_log_fatal, vha, 0x016a,
+			    "-> Unable to read segment addr + size .\n");
+			return QLA_FUNCTION_FAILED;
+		}
 		risc_addr = be32_to_cpu((__force __be32)dcode[2]);
 		risc_size = be32_to_cpu((__force __be32)dcode[3]);
 		if (!*srisc_addr) {
@@ -8468,7 +8491,13 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 			ql_dbg(ql_dbg_init, vha, 0x008e,
 			    "-> Loading fragment %u: %#x <- %#x (%#lx dwords)...\n",
 			    fragment, risc_addr, faddr, dlen);
-			qla24xx_read_flash_data(vha, dcode, faddr, dlen);
+			rval = qla24xx_read_flash_data(vha, dcode, faddr, dlen);
+			if (rval) {
+				ql_log(ql_log_fatal, vha, 0x016b,
+				    "-> Unable to read fragment(faddr %#x dlen %#lx).\n",
+				    faddr, dlen);
+				return QLA_FUNCTION_FAILED;
+			}
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(dcode[i]);
 
@@ -8497,7 +8526,14 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 		fwdt->length = 0;
 
 		dcode = (uint32_t *)req->ring;
-		qla24xx_read_flash_data(vha, dcode, faddr, 7);
+
+		rval = qla24xx_read_flash_data(vha, dcode, faddr, 7);
+		if (rval) {
+			ql_log(ql_log_fatal, vha, 0x016c,
+			    "-> Unable to read template size.\n");
+			goto failed;
+		}
+
 		risc_size = be32_to_cpu((__force __be32)dcode[2]);
 		ql_dbg(ql_dbg_init, vha, 0x0161,
 		    "-> fwdt%u template array at %#x (%#x dwords)\n",
@@ -8523,11 +8559,12 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 		}
 
 		dcode = fwdt->template;
-		qla24xx_read_flash_data(vha, dcode, faddr, risc_size);
+		rval = qla24xx_read_flash_data(vha, dcode, faddr, risc_size);
 
-		if (!qla27xx_fwdt_template_valid(dcode)) {
+		if (rval || !qla27xx_fwdt_template_valid(dcode)) {
 			ql_log(ql_log_warn, vha, 0x0165,
-			    "-> fwdt%u failed template validate\n", j);
+			    "-> fwdt%u failed template validate (rval %x)\n",
+			    j, rval);
 			goto failed;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index c092a6b1ced4..6d16546e1729 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -555,6 +555,7 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 	struct qla_flt_location *fltl = (void *)req->ring;
 	uint32_t *dcode = (uint32_t *)req->ring;
 	uint8_t *buf = (void *)req->ring, *bcode,  last_image;
+	int rc;
 
 	/*
 	 * FLT-location structure resides after the last PCI region.
@@ -584,14 +585,24 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 	pcihdr = 0;
 	do {
 		/* Verify PCI expansion ROM header. */
-		qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
+		rc = qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
+		if (rc) {
+			ql_log(ql_log_info, vha, 0x016d,
+			    "Unable to read PCI Expansion Rom Header (%x).\n", rc);
+			return QLA_FUNCTION_FAILED;
+		}
 		bcode = buf + (pcihdr % 4);
 		if (bcode[0x0] != 0x55 || bcode[0x1] != 0xaa)
 			goto end;
 
 		/* Locate PCI data structure. */
 		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
-		qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
+		rc = qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
+		if (rc) {
+			ql_log(ql_log_info, vha, 0x0179,
+			    "Unable to read PCI Data Structure (%x).\n", rc);
+			return QLA_FUNCTION_FAILED;
+		}
 		bcode = buf + (pcihdr % 4);
 
 		/* Validate signature of PCI data structure. */
@@ -606,7 +617,12 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 	} while (!last_image);
 
 	/* Now verify FLT-location structure. */
-	qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, sizeof(*fltl) >> 2);
+	rc = qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, sizeof(*fltl) >> 2);
+	if (rc) {
+		ql_log(ql_log_info, vha, 0x017a,
+		    "Unable to read FLT (%x).\n", rc);
+		return QLA_FUNCTION_FAILED;
+	}
 	if (memcmp(fltl->sig, "QFLT", 4))
 		goto end;
 
@@ -2605,13 +2621,18 @@ qla24xx_read_optrom_data(struct scsi_qla_host *vha, void *buf,
     uint32_t offset, uint32_t length)
 {
 	struct qla_hw_data *ha = vha->hw;
+	int rc;
 
 	/* Suspend HBA. */
 	scsi_block_requests(vha->host);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with read. */
-	qla24xx_read_flash_data(vha, buf, offset >> 2, length >> 2);
+	rc = qla24xx_read_flash_data(vha, buf, offset >> 2, length >> 2);
+	if (rc) {
+		ql_log(ql_log_info, vha, 0x01a0,
+		    "Unable to perform optrom read(%x).\n", rc);
+	}
 
 	/* Resume HBA. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
@@ -3412,7 +3433,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	struct active_regions active_regions = { };
 
 	if (IS_P3P_TYPE(ha))
-		return ret;
+		return QLA_SUCCESS;
 
 	if (!mbuf)
 		return QLA_FUNCTION_FAILED;
@@ -3432,20 +3453,31 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 
 	do {
 		/* Verify PCI expansion ROM header. */
-		qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
+		ret = qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
+		if (ret) {
+			ql_log(ql_log_info, vha, 0x017d,
+			    "Unable to read PCI EXP Rom Header(%x).\n", ret);
+			return QLA_FUNCTION_FAILED;
+		}
+
 		bcode = mbuf + (pcihdr % 4);
 		if (memcmp(bcode, "\x55\xaa", 2)) {
 			/* No signature */
 			ql_log(ql_log_fatal, vha, 0x0059,
 			    "No matching ROM signature.\n");
-			ret = QLA_FUNCTION_FAILED;
-			break;
+			return QLA_FUNCTION_FAILED;
 		}
 
 		/* Locate PCI data structure. */
 		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
 
-		qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
+		ret = qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
+		if (ret) {
+			ql_log(ql_log_info, vha, 0x018e,
+			    "Unable to read PCI Data Structure (%x).\n", ret);
+			return QLA_FUNCTION_FAILED;
+		}
+
 		bcode = mbuf + (pcihdr % 4);
 
 		/* Validate signature of PCI data structure. */
@@ -3454,8 +3486,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			ql_log(ql_log_fatal, vha, 0x005a,
 			    "PCI data struct not found pcir_adr=%x.\n", pcids);
 			ql_dump_buffer(ql_dbg_init, vha, 0x0059, dcode, 32);
-			ret = QLA_FUNCTION_FAILED;
-			break;
+			return QLA_FUNCTION_FAILED;
 		}
 
 		/* Read version */
@@ -3507,20 +3538,26 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			faddr = ha->flt_region_fw_sec;
 	}
 
-	qla24xx_read_flash_data(vha, dcode, faddr, 8);
-	if (qla24xx_risc_firmware_invalid(dcode)) {
-		ql_log(ql_log_warn, vha, 0x005f,
-		    "Unrecognized fw revision at %x.\n",
-		    ha->flt_region_fw * 4);
-		ql_dump_buffer(ql_dbg_init, vha, 0x005f, dcode, 32);
+	ret = qla24xx_read_flash_data(vha, dcode, faddr, 8);
+	if (ret) {
+		ql_log(ql_log_info, vha, 0x019e,
+		    "Unable to read FW version (%x).\n", ret);
+		return ret;
 	} else {
-		for (i = 0; i < 4; i++)
-			ha->fw_revision[i] =
+		if (qla24xx_risc_firmware_invalid(dcode)) {
+			ql_log(ql_log_warn, vha, 0x005f,
+			    "Unrecognized fw revision at %x.\n",
+			    ha->flt_region_fw * 4);
+			ql_dump_buffer(ql_dbg_init, vha, 0x005f, dcode, 32);
+		} else {
+			for (i = 0; i < 4; i++)
+				ha->fw_revision[i] =
 				be32_to_cpu((__force __be32)dcode[4+i]);
-		ql_dbg(ql_dbg_init, vha, 0x0060,
-		    "Firmware revision (flash) %u.%u.%u (%x).\n",
-		    ha->fw_revision[0], ha->fw_revision[1],
-		    ha->fw_revision[2], ha->fw_revision[3]);
+			ql_dbg(ql_dbg_init, vha, 0x0060,
+			    "Firmware revision (flash) %u.%u.%u (%x).\n",
+			    ha->fw_revision[0], ha->fw_revision[1],
+			    ha->fw_revision[2], ha->fw_revision[3]);
+		}
 	}
 
 	/* Check for golden firmware and get version if available */
@@ -3531,18 +3568,23 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 
 	memset(ha->gold_fw_version, 0, sizeof(ha->gold_fw_version));
 	faddr = ha->flt_region_gold_fw;
-	qla24xx_read_flash_data(vha, dcode, ha->flt_region_gold_fw, 8);
-	if (qla24xx_risc_firmware_invalid(dcode)) {
-		ql_log(ql_log_warn, vha, 0x0056,
-		    "Unrecognized golden fw at %#x.\n", faddr);
-		ql_dump_buffer(ql_dbg_init, vha, 0x0056, dcode, 32);
+	ret = qla24xx_read_flash_data(vha, dcode, ha->flt_region_gold_fw, 8);
+	if (ret) {
+		ql_log(ql_log_info, vha, 0x019f,
+		    "Unable to read Gold FW version (%x).\n", ret);
 		return ret;
-	}
-
-	for (i = 0; i < 4; i++)
-		ha->gold_fw_version[i] =
-			be32_to_cpu((__force __be32)dcode[4+i]);
+	} else {
+		if (qla24xx_risc_firmware_invalid(dcode)) {
+			ql_log(ql_log_warn, vha, 0x0056,
+			    "Unrecognized golden fw at %#x.\n", faddr);
+			ql_dump_buffer(ql_dbg_init, vha, 0x0056, dcode, 32);
+			return QLA_FUNCTION_FAILED;
+		}
 
+		for (i = 0; i < 4; i++)
+			ha->gold_fw_version[i] =
+			   be32_to_cpu((__force __be32)dcode[4+i]);
+	}
 	return ret;
 }
 
-- 
2.23.1

