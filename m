Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABAD386571
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403713; cv=none; b=QZhSxompVHfKg8tUFf/1+WchTeHRhhQbmN0z333aXIahdD53iUrKkitnydBlt5WLt1gYhggWXwJDsIK11I5MhS3pOEUiELzxfqfkO3BkJUvGSHGmvJo4AgoQwRUILdm9kVmAI+lMNjnNmxF7FsASe5iDfoqZYjj5B64rio0B8qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403713; c=relaxed/simple;
	bh=34gmT2s23uXWBXJSMMWHYFW+sO38BhZgtGwKhWnsOBs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P9BAquu7loQAtwjAJ3Lnjqys9xiGT0H42VVU4C+7cZn81y7M58q/Jsi5DIMzPXjCOltKCzteeQGHgWQX2Oma08klG1ml0HJs0OcJgpI/Pugsws3geZk++5586j7jgVCfRwEZmFFxJTpbLQ16O9kML2nH9fQCY3eYgyIfVpaFhG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ho3q+gov; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ho3q+gov"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667481Ph872631;
	Mon, 6 Jul 2026 22:55:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=X
	/qOH1k216iN06aGGaYFNhMJPefYpgL6djyImr0+hak=; b=ho3q+gov6xbXEFBfH
	CG6mpRZw5gAeg/3XYljddRcJKkTJ9BgN4wU4a6AkDFjhZD/DKs83pPfGgHbUZx28
	lLENcP8Ve5u7sTjAYmYadDIHR0/OJLjUfvp4l14SfPWA/WdgzkOTBNCceFoU4MkV
	as9O76QH4Qjp4kO1rO5lzh+gezpltjcV7KLACUMduZrSdfNyCFEuTGXuAyvw4ezv
	XmxUGjcW74FjzxyqTdKpGaWEk8adPHm2YDj4M1lUgJAzjQ5lbEfrecFxLHsZWAIj
	rRhZug+tPn0sblpMc81WmZ8u35ptC80gtW7VcsiS3/0eMvRDL9oYhF0s9L3f6Wwk
	XgeeQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9wa9ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:09 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 8AF653F7066;
	Mon,  6 Jul 2026 22:55:05 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 03/88] scsi: qla2xxx: Add NVRAM config support for 29xx adapters
Date: Tue, 7 Jul 2026 11:23:10 +0530
Message-ID: <20260707055435.2680300-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jptSZya0KGsPPxdJZoywyKR3eNzi0Fb6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfXyAWEjBy5R/0X
 wwEOnt32rI/n8Bok6FDd3oUCO2y6gvwqrLmkXG/VCdHNVUuZWB1pOpYyd6KqJkLi4JgmL0KgVNB
 0PAhESFP/ZQTPp5HPL6NzVhytv4M4TMYHLiSwQJ9eQWQYH5PaJzuPvDQEy7MLTHMwKZw2lOXex8
 S/EykmqlISQoqTWZDP2v6ReqskOIzAtzEPy7X5KGIMEED7gSGJyWWJ3EeX3xejG/Eb+6jx52FUJ
 GNTLE2UK3DQsBueKyFKDLglIxxCpnWUhUuu+uIZojoEyGlYXYdYUfY30Bk58dr3J+cO49LWbntT
 1RB2MdUIuHyiLRwnXO0t7qdBrADkGAtiZpIUJ3kvbYT4WMbXdGYG0d2sH1YgIGuHA7jJDQGeZjz
 HLB1D+mLyO9G3IsY6MpOdEiZjg7yJQW0EgkHeFZJz8XVLCqrMK/m6DFN2Mt3k6Rk/SjJMVhwMzC
 Ypa4xajqlSouFfSUJ3A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfXz3P2bxQsg6i2
 FPIxYllpWDPvh25elFVfpwLSB8xGF2kXuW1D+RSe8eCSGGMl2Y2ic659lVCYHn4mcElewx8OFqs
 4S4WrsKmXktKCHHbf8EmwtaqkCKCXns=
X-Proofpoint-GUID: jptSZya0KGsPPxdJZoywyKR3eNzi0Fb6
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c94bd cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=vvvcwNWBXVQ8D827hgEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Extend the NVRAM read and configuration-apply paths to handle the
29xx series.  The 29xx NVRAM layout is similar to the 81xx family,
so reuse the existing nvram_81xx parsing while adding
29xx-specific fields and init-sequence integration.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |   1 +
 drivers/scsi/qla2xxx/qla_fw.h   |  42 ++++++++++-
 drivers/scsi/qla2xxx/qla_init.c | 123 +++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_os.c   |   2 +
 4 files changed, 141 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b5ad6ed3d5d1..89ddf332cdbd 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4469,6 +4469,7 @@ struct qla_hw_data {
 	uint16_t	vpd_size;
 	uint16_t	vpd_base;
 	void		*vpd;
+	struct qla_flash_memo_block *fiv;
 
 	uint16_t	loop_reset_delay;
 	uint8_t		retry_count;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index d27d09964a24..42f6125b3cfb 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1676,6 +1676,8 @@ struct qla_flt_location {
 #define FLT_REG_VPD_SEC_27XX_2	0xD8
 #define FLT_REG_VPD_SEC_27XX_3	0xDA
 #define FLT_REG_NVME_PARAMS_27XX	0x21
+#define FLT_REG_FMB_PRI		0xDF
+#define FLT_REG_FMB_SEC		0x124
 
 /* 28xx */
 #define FLT_REG_AUX_IMG_PRI_28XX	0x125
@@ -2110,7 +2112,7 @@ struct nvram_81xx {
 	 * BIT 7    = SCM Disabled if BIT is set (1)
 	 * BIT 8-15 = Unused
 	 */
-	uint16_t enhanced_features;
+	__le16	enhanced_features;
 
 	uint16_t reserved_24[4];
 
@@ -2338,4 +2340,42 @@ struct qla_fcp_prio_cfg {
 
 #define NVRAM_DUAL_FCP_NVME_FLAG_OFFSET	0x196
 
+struct qla_fmb_version {
+	uint8_t major;
+	uint8_t minor;
+	uint8_t sub;
+	uint8_t build;
+};
+
+struct qla_fmb_upd_time {
+	__le16   year;
+	uint8_t  month;
+	uint8_t  day;
+
+	uint8_t  hour;
+	uint8_t  minute;
+	uint8_t  second;
+	uint8_t  reserved;
+};
+
+struct qla_flash_memo_block {
+	__le32   signature;	/* "FMBS" */
+#define QLFC_FMB_SIG	cpu_to_le32(0x53424D46)
+	__le32   length;
+	__le32   version;
+#define QLFC_FMB_VERSION 3
+	__le32   checksum;
+	struct qla_fmb_version ffv_ver;
+	struct qla_fmb_version mbi_ver;
+	struct {
+		__le16   year;
+		uint8_t  month;
+		uint8_t  day;
+		uint8_t  reserve[4];
+	} bld_time;
+	uint8_t tool_id[4];
+	struct qla_fmb_upd_time upd_time;
+	struct qla_fmb_version  tool_version;
+};
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e23e7ac48ae2..f5d230fc3642 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4194,11 +4194,11 @@ qla24xx_detect_sfp(scsi_qla_host_t *vha)
 	used_nvram = 0;
 	ha->flags.lr_detected = 0;
 	if (IS_BPM_RANGE_CAPABLE(ha) &&
-	    (nv->enhanced_features & NEF_LR_DIST_ENABLE)) {
+	    (le16_to_cpu(nv->enhanced_features) & NEF_LR_DIST_ENABLE)) {
 		used_nvram = 1;
 		ha->flags.lr_detected = 1;
 		ha->lr_distance =
-		    (nv->enhanced_features >> LR_DIST_NV_POS)
+		    (le16_to_cpu(nv->enhanced_features) >> LR_DIST_NV_POS)
 		     & LR_DIST_NV_MASK;
 	}
 
@@ -9306,34 +9306,97 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	if (IS_P3P_TYPE(ha) || IS_QLA8031(ha))
 		ha->vpd_size = FA_VPD_SIZE_82XX;
 
-	if (IS_QLA28XX(ha) || IS_QLA27XX(ha))
-		qla28xx_get_aux_images(vha, &active_regions);
-
 	/* Get VPD data into cache */
 	ha->vpd = ha->nvram + VPD_OFFSET;
 
-	faddr = ha->flt_region_vpd;
-	if (IS_QLA28XX(ha)) {
-		if (active_regions.aux.vpd_nvram == QLA27XX_SECONDARY_IMAGE)
-			faddr = ha->flt_region_vpd_sec;
+	if (IS_QLA29XX(ha)) {
+		uint16_t fw_options = 0, r_code;
+		uint32_t vpd_r[] = {FLT_REG_VPD_0, FLT_REG_VPD_1,
+				    FLT_REG_VPD_2, FLT_REG_VPD_3};
+		uint32_t nvram_r[] = {FLT_REG_NVRAM_0, FLT_REG_NVRAM_1,
+				      FLT_REG_NVRAM_2, FLT_REG_NVRAM_3};
+		void *buf;
+
+		BUILD_BUG_ON((VPD_OFFSET + FA_NVRAM_VPD_SIZE +
+			      sizeof(struct qla_flash_memo_block)) >
+			     MAX_NVRAM_SIZE);
+
+		ha->fiv = (struct qla_flash_memo_block *)
+			((char *)ha->vpd + ha->vpd_size);
+
+		buf = qla29xx_read_optrom_data(vha, FLT_REG_FMB_PRI,
+					       fw_options, ha->fiv, 0,
+					       sizeof(struct qla_flash_memo_block));
+		if (!buf) {
+			ql_log(ql_log_info, vha, 0x01be,
+			    "Unable to read Flash Image Version.\n");
+		} else if (ha->fiv->signature != QLFC_FMB_SIG) {
+			ql_log(ql_log_warn, vha, 0x01bf,
+			    "Invalid FMB signature %#x, expected %#x.\n",
+			    le32_to_cpu(ha->fiv->signature),
+			    le32_to_cpu(QLFC_FMB_SIG));
+			ha->fiv = NULL;
+		} else {
+			ql_log(ql_log_info, vha, 0x0024,
+			    "Flash Image Version %u.%02u.%02u\n",
+			    ha->fiv->mbi_ver.major,
+			    ha->fiv->mbi_ver.minor,
+			    ha->fiv->mbi_ver.sub);
+		}
+
+		if (ha->port_no >= ARRAY_SIZE(vpd_r)) {
+			ql_log(ql_log_warn, vha, 0x002e,
+			    "Invalid port number %u, skipping VPD/NVRAM read.\n",
+			    ha->port_no);
+			goto out_29xx;
+		}
+
+		r_code = vpd_r[ha->port_no];
+		buf = qla29xx_read_optrom_data(vha, r_code, fw_options,
+					       ha->vpd, 0, ha->vpd_size);
+		if (!buf)
+			ql_log(ql_log_info, vha, 0x002d,
+			    "Unable to read VPD info.\n");
+
+		r_code = nvram_r[ha->port_no];
+		buf = qla29xx_read_optrom_data(vha, r_code, fw_options,
+					       ha->nvram, 0, ha->nvram_size);
+		if (!buf)
+			ql_log(ql_log_info, vha, 0x0013,
+			    "Unable to read nvram config info.\n");
+out_29xx:
+	} else {
+		if (IS_QLA28XX(ha) || IS_QLA27XX(ha))
+			qla28xx_get_aux_images(vha, &active_regions);
+
+		faddr = ha->flt_region_vpd;
+		if (IS_QLA28XX(ha)) {
+			if (active_regions.aux.vpd_nvram ==
+			    QLA27XX_SECONDARY_IMAGE)
+				faddr = ha->flt_region_vpd_sec;
+			ql_dbg(ql_dbg_init, vha, 0x0110,
+			    "Loading %s nvram image.\n",
+			    active_regions.aux.vpd_nvram ==
+			    QLA27XX_PRIMARY_IMAGE ?
+			    "primary" : "secondary");
+		}
+		ha->isp_ops->read_optrom(vha, ha->vpd, faddr << 2,
+					 ha->vpd_size);
+
+		/* Get NVRAM data into cache and calculate checksum. */
+		faddr = ha->flt_region_nvram;
+		if (IS_QLA28XX(ha)) {
+			if (active_regions.aux.vpd_nvram ==
+			    QLA27XX_SECONDARY_IMAGE)
+				faddr = ha->flt_region_nvram_sec;
+		}
 		ql_dbg(ql_dbg_init, vha, 0x0110,
 		    "Loading %s nvram image.\n",
 		    active_regions.aux.vpd_nvram == QLA27XX_PRIMARY_IMAGE ?
 		    "primary" : "secondary");
+		ha->isp_ops->read_optrom(vha, ha->nvram, faddr << 2,
+					 ha->nvram_size);
 	}
-	ha->isp_ops->read_optrom(vha, ha->vpd, faddr << 2, ha->vpd_size);
-
-	/* Get NVRAM data into cache and calculate checksum. */
-	faddr = ha->flt_region_nvram;
-	if (IS_QLA28XX(ha)) {
-		if (active_regions.aux.vpd_nvram == QLA27XX_SECONDARY_IMAGE)
-			faddr = ha->flt_region_nvram_sec;
-	}
-	ql_dbg(ql_dbg_init, vha, 0x0110,
-	    "Loading %s nvram image.\n",
-	    active_regions.aux.vpd_nvram == QLA27XX_PRIMARY_IMAGE ?
-	    "primary" : "secondary");
-	ha->isp_ops->read_optrom(vha, ha->nvram, faddr << 2, ha->nvram_size);
 
 	dptr = (__force __le32 *)nv;
 	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++, dptr++)
@@ -9386,7 +9449,10 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		nv->login_timeout = cpu_to_le16(0);
 		nv->firmware_options_1 =
 		    cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
-		nv->firmware_options_2 = cpu_to_le32(2 << 4);
+		if (IS_QLA29XX(ha))
+			nv->firmware_options_2 = cpu_to_le32(BIT_4);
+		else
+			nv->firmware_options_2 = cpu_to_le32(BIT_5);
 		nv->firmware_options_2 |= cpu_to_le32(BIT_12);
 		nv->firmware_options_3 = cpu_to_le32(2 << 13);
 		nv->host_p = cpu_to_le32(BIT_11|BIT_10);
@@ -9468,9 +9534,13 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		icb->node_name[0] &= 0xF0;
 	}
 
-	if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
-		if ((nv->enhanced_features & BIT_7) == 0)
+	/* SCM Enabled in NVRAM */
+	if (IS_QLA29XX(ha) || IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
+		if ((le16_to_cpu(nv->enhanced_features) & BIT_7) == 0) {
+			ql_log(ql_log_info, vha, 0x0062,
+			       "USCM enabled in NVRAM\n");
 			ha->flags.scm_supported_a = 1;
+		}
 	}
 
 	/* Set host adapter parameters. */
@@ -9546,7 +9616,8 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 
 	/* if not running MSI-X we need handshaking on interrupts */
 	if (!vha->hw->flags.msix_enabled &&
-	    (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)))
+	    (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+	     IS_QLA29XX(ha)))
 		icb->firmware_options_2 |= cpu_to_le32(BIT_22);
 
 	/* Enable ZIO. */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ebb97329e6ea..c3eb941f71ad 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4620,6 +4620,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 fail_free_nvram:
 	kfree(ha->nvram);
 	ha->nvram = NULL;
+	ha->fiv = NULL;
 fail_free_ctx_mempool:
 	mempool_destroy(ha->ctx_mempool);
 	ha->ctx_mempool = NULL;
@@ -5085,6 +5086,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->optrom_buffer = NULL;
 	kfree(ha->nvram);
 	ha->nvram = NULL;
+	ha->fiv = NULL;
 	kfree(ha->npiv_info);
 	ha->npiv_info = NULL;
 	kfree(ha->swl);
-- 
2.47.3

