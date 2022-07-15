Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7362C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 06:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiGOGCu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 02:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiGOGCg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 02:02:36 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2454C7A53E
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:35 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26F1ifoB013575
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ALN/oPsks1/jbjujDUFPdwuWvYhVDzXAIN9iug2tAAg=;
 b=kAenYiscnIi9meG5TG+ma+YmRwlXHP6tXn22DsQsgvoepOxN8bPqqES3Z7Qif0TB8GXC
 9SJMA/av871/Xo3YuWwKc5Tmg8sj6xldYX8EuiuxrlbMYmLxZv/F8gBdDhiFS5f4xZ2C
 4rq+5JKKxpfdi1Hr991CgYhWQyNm9qeHg9XrN6F5YMsAcVs9Xbvp52aP++2YeroNa+Lh
 NrfJQg51EpyKnHdilS/MdxRiASKcJDt+wgW+5QJ97snYwsFrCthsgU94NVZyoT2R33NQ
 T8WIvg+CwPpt7XOKs0fkNFjKHgtt4BhSJte3HalWnQjGE659VOAIthMf/4kaVwvzm26e 4A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3haxu9gkug-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:34 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Jul
 2022 23:02:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Jul 2022 23:02:32 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C43663F7073;
        Thu, 14 Jul 2022 23:02:32 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 5/6] qla2xxx: Add NVMe parameters support in Auxiliary Image Status
Date:   Thu, 14 Jul 2022 23:02:26 -0700
Message-ID: <20220715060227.23923-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220715060227.23923-1-njavali@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5MhcFMssAvVLD6XeqoytdVls40OHQ8U9
X-Proofpoint-GUID: 5MhcFMssAvVLD6XeqoytdVls40OHQ8U9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_02,2022-07-14_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Anil Gurumurthy <agurumurthy@marvell.com>

Add new API to obtain the NVMe Parameters region status from the
Auxiliary Image Status bitmap.

Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  | 8 ++++++--
 drivers/scsi/qla2xxx/qla_bsg.h  | 3 ++-
 drivers/scsi/qla2xxx/qla_def.h  | 2 ++
 drivers/scsi/qla2xxx/qla_fw.h   | 3 +++
 drivers/scsi/qla2xxx/qla_init.c | 8 ++++++--
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5db9bf69dcff..cd75b179410d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2519,19 +2519,23 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 	qla27xx_get_active_image(vha, &active_regions);
 	regions.global_image = active_regions.global;
 
+	if (IS_QLA27XX(ha))
+		regions.nvme_params = QLA27XX_PRIMARY_IMAGE;
+
 	if (IS_QLA28XX(ha)) {
 		qla28xx_get_aux_images(vha, &active_regions);
 		regions.board_config = active_regions.aux.board_config;
 		regions.vpd_nvram = active_regions.aux.vpd_nvram;
 		regions.npiv_config_0_1 = active_regions.aux.npiv_config_0_1;
 		regions.npiv_config_2_3 = active_regions.aux.npiv_config_2_3;
+		regions.nvme_params = active_regions.aux.nvme_params;
 	}
 
 	ql_dbg(ql_dbg_user, vha, 0x70e1,
-	    "%s(%lu): FW=%u BCFG=%u VPDNVR=%u NPIV01=%u NPIV02=%u\n",
+	    "%s(%lu): FW=%u BCFG=%u VPDNVR=%u NPIV01=%u NPIV02=%u NVME_PARAMS=%u\n",
 	    __func__, vha->host_no, regions.global_image,
 	    regions.board_config, regions.vpd_nvram,
-	    regions.npiv_config_0_1, regions.npiv_config_2_3);
+	    regions.npiv_config_0_1, regions.npiv_config_2_3, regions.nvme_params);
 
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 	    bsg_job->reply_payload.sg_cnt, &regions, sizeof(regions));
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index bb64b9c5a74b..d38dab0a07e8 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -314,7 +314,8 @@ struct qla_active_regions {
 	uint8_t vpd_nvram;
 	uint8_t npiv_config_0_1;
 	uint8_t npiv_config_2_3;
-	uint8_t reserved[32];
+	uint8_t nvme_params;
+	uint8_t reserved[31];
 } __packed;
 
 #include "qla_edif_bsg.h"
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e1528a4e6ee4..994b2378e24a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4809,6 +4809,7 @@ struct active_regions {
 		uint8_t vpd_nvram;
 		uint8_t npiv_config_0_1;
 		uint8_t npiv_config_2_3;
+		uint8_t nvme_params;
 	} aux;
 };
 
@@ -5093,6 +5094,7 @@ struct qla27xx_image_status {
 #define QLA28XX_AUX_IMG_VPD_NVRAM		BIT_1
 #define QLA28XX_AUX_IMG_NPIV_CONFIG_0_1		BIT_2
 #define QLA28XX_AUX_IMG_NPIV_CONFIG_2_3		BIT_3
+#define QLA28XX_AUX_IMG_NVME_PARAMS		BIT_4
 
 #define SET_VP_IDX	1
 #define SET_AL_PA	2
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 361015b5763e..f307beed9d29 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1675,6 +1675,7 @@ struct qla_flt_location {
 #define FLT_REG_VPD_SEC_27XX_1	0x52
 #define FLT_REG_VPD_SEC_27XX_2	0xD8
 #define FLT_REG_VPD_SEC_27XX_3	0xDA
+#define FLT_REG_NVME_PARAMS_27XX	0x21
 
 /* 28xx */
 #define FLT_REG_AUX_IMG_PRI_28XX	0x125
@@ -1691,6 +1692,8 @@ struct qla_flt_location {
 #define FLT_REG_MPI_SEC_28XX		0xF0
 #define FLT_REG_PEP_PRI_28XX		0xD1
 #define FLT_REG_PEP_SEC_28XX		0xF1
+#define FLT_REG_NVME_PARAMS_PRI_28XX	0x14E
+#define FLT_REG_NVME_PARAMS_SEC_28XX	0x179
 
 struct qla_flt_region {
 	__le16	code;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e7fe0e52c11d..e12db95de688 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7933,6 +7933,9 @@ qla28xx_component_status(
 
 	active_regions->aux.npiv_config_2_3 =
 	    qla28xx_component_bitmask(aux, QLA28XX_AUX_IMG_NPIV_CONFIG_2_3);
+
+	active_regions->aux.nvme_params =
+	    qla28xx_component_bitmask(aux, QLA28XX_AUX_IMG_NVME_PARAMS);
 }
 
 static int
@@ -8041,11 +8044,12 @@ qla28xx_get_aux_images(
 	}
 
 	ql_dbg(ql_dbg_init, vha, 0x018f,
-	    "aux images active: BCFG=%u VPD/NVR=%u NPIV0/1=%u NPIV2/3=%u\n",
+	    "aux images active: BCFG=%u VPD/NVR=%u NPIV0/1=%u NPIV2/3=%u, NVME=%u\n",
 	    active_regions->aux.board_config,
 	    active_regions->aux.vpd_nvram,
 	    active_regions->aux.npiv_config_0_1,
-	    active_regions->aux.npiv_config_2_3);
+	    active_regions->aux.npiv_config_2_3,
+	    active_regions->aux.nvme_params);
 }
 
 void
-- 
2.19.0.rc0

