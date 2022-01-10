Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841EFC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 05:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbiAJFDN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 00:03:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17370 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237394AbiAJFDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 00:03:01 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 209KQlqn023499
        for <linux-scsi@vger.kernel.org>; Sun, 9 Jan 2022 21:03:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=P59fH1l/X84cyCGWRU+hROflNyq/tkMyLO/3b/jM4f0=;
 b=O6Fa1kehU/HpmmsELHoiq9P9y8/mHacvhIbvNXvmTcDXLZoTBU2WgJh310gTGs9bDU1a
 7kHrGdgK2v2iIGDcG/bk+JmppesNWImJHLDDXz7/CCtDvfLBw9n6cECMA0sOdN6ujWmy
 P2/Pha/k4QbzIZwb8IkNROlMFkPteY1amLjjndXmz2mx5Vn27mjsqKl5pT8EnvZC/wyS
 3nog0I2EzzUFuXBKjGOytg4hGU+BpuPtQtIDwAtFftzrMr8qNTGkaqSJfq12uceiwytG
 oarqGULoDnKuYA1MLyLq5PSi1rUsR5ja2bzT5sZ/MUXv4ZrYDoEY9AKdUzKKnTF1bgMa XA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dfy8nhjf0-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jan 2022 21:03:01 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 9 Jan
 2022 21:02:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 9 Jan 2022 21:02:55 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A9B713F70A5;
        Sun,  9 Jan 2022 21:02:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20A52tKJ004053;
        Sun, 9 Jan 2022 21:02:55 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20A52tRe004052;
        Sun, 9 Jan 2022 21:02:55 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 15/17] qla2xxx: Add devid's and conditionals for 28xx
Date:   Sun, 9 Jan 2022 21:02:16 -0800
Message-ID: <20220110050218.3958-16-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220110050218.3958-1-njavali@marvell.com>
References: <20220110050218.3958-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Cdnh1OPCby374tsqqF0Xtme_P3_dLl_a
X-Proofpoint-ORIG-GUID: Cdnh1OPCby374tsqqF0Xtme_P3_dLl_a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_01,2022-01-07_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

This is an update to the original 28xx adapter enablement. This patch
adds a bunch of conditionals that is applicable for 28xx.

Cc: stable@vger.kernel.org
Fixes: ecc89f25e225 ("scsi: qla2xxx: Add Device ID for ISP28XX")
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
v1->v2:
- update author of patch
- add Fixes tag
- separate out few hunk as a separate commit
- update description of the commit

 drivers/scsi/qla2xxx/qla_attr.c   |  7 ++-----
 drivers/scsi/qla2xxx/qla_init.c   |  8 +++-----
 drivers/scsi/qla2xxx/qla_mbx.c    | 14 +++++++++++---
 drivers/scsi/qla2xxx/qla_os.c     |  3 +--
 drivers/scsi/qla2xxx/qla_sup.c    |  4 ++--
 drivers/scsi/qla2xxx/qla_target.c |  3 +--
 6 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index db55737000ab..3b3e4234f37a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -555,7 +555,7 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EINVAL;
 
-	if (IS_NOCACHE_VPD_TYPE(ha))
+	if (!IS_NOCACHE_VPD_TYPE(ha))
 		goto skip;
 
 	faddr = ha->flt_region_vpd << 2;
@@ -745,7 +745,7 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 		ql_log(ql_log_info, vha, 0x706f,
 		    "Issuing MPI reset.\n");
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha)) {
 			uint32_t idc_control;
 
 			qla83xx_idc_lock(vha, 0);
@@ -1056,9 +1056,6 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *vha, bool stop_beacon)
 			continue;
 		if (iter->type == 3 && !(IS_CNA_CAPABLE(ha)))
 			continue;
-		if (iter->type == 0x27 &&
-		    (!IS_QLA27XX(ha) || !IS_QLA28XX(ha)))
-			continue;
 
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 71e31e4bfa61..acc39a08454c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3492,7 +3492,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
 		    sizeof(uint16_t);
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA83XX(ha))
 			fixed_size = offsetof(struct qla83xx_fw_dump, ext_mem);
 		else if (IS_QLA81XX(ha))
 			fixed_size = offsetof(struct qla81xx_fw_dump, ext_mem);
@@ -3504,8 +3504,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
 		if (ha->mqenable) {
-			if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) &&
-			    !IS_QLA28XX(ha))
+			if (!IS_QLA83XX(ha))
 				mq_size = sizeof(struct qla2xxx_mq_chain);
 			/*
 			 * Allocate maximum buffer size for all queues - Q0.
@@ -4066,8 +4065,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 			    ha->fw_major_version, ha->fw_minor_version,
 			    ha->fw_subminor_version);
 
-			if (IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-			    IS_QLA28XX(ha)) {
+			if (IS_QLA83XX(ha)) {
 				ha->flags.fac_supported = 0;
 				rval = QLA_SUCCESS;
 			}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c4bd8a16d78c..892caf2475df 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -9,6 +9,12 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
+#ifdef CONFIG_PPC
+#define IS_PPCARCH      true
+#else
+#define IS_PPCARCH      false
+#endif
+
 static struct mb_cmd_name {
 	uint16_t cmd;
 	const char *str;
@@ -728,6 +734,9 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 				vha->min_supported_speed =
 				    nv->min_supported_speed;
 			}
+
+			if (IS_PPCARCH)
+				mcp->mb[11] |= BIT_4;
 		}
 
 		if (ha->flags.exlogins_enabled)
@@ -3035,8 +3044,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha)
 		ha->orig_fw_iocb_count = mcp->mb[10];
 		if (ha->flags.npiv_supported)
 			ha->max_npiv_vports = mcp->mb[11];
-		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-		    IS_QLA28XX(ha))
+		if (IS_QLA81XX(ha) || IS_QLA83XX(ha))
 			ha->fw_max_fcf_count = mcp->mb[12];
 	}
 
@@ -5627,7 +5635,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
-		mcp->in_mb |= MBX_3;
+		mcp->in_mb |= MBX_4|MBX_3;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 88bff825aa5e..cff5e4a710d1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3762,8 +3762,7 @@ qla2x00_unmap_iobases(struct qla_hw_data *ha)
 		if (ha->mqiobase)
 			iounmap(ha->mqiobase);
 
-		if ((IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
-		    ha->msixbase)
+		if (ha->msixbase)
 			iounmap(ha->msixbase);
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index a0aeba69513d..c092a6b1ced4 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -844,7 +844,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 				ha->flt_region_nvram = start;
 			break;
 		case FLT_REG_IMG_PRI_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_img_status_pri = start;
 			break;
 		case FLT_REG_IMG_SEC_27XX:
@@ -1356,7 +1356,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, __le32 *dwptr, uint32_t faddr,
 		    flash_data_addr(ha, faddr), le32_to_cpu(*dwptr));
 		if (ret) {
 			ql_dbg(ql_dbg_user, vha, 0x7006,
-			    "Failed slopw write %x (%x)\n", faddr, *dwptr);
+			    "Failed slow write %x (%x)\n", faddr, *dwptr);
 			break;
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index feb054c688a3..b109716d44fb 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -7220,8 +7220,7 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
-	if  ((ql2xenablemsix == 0) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	if  (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
 		ISP_ATIO_Q_IN(base_vha) = &ha->mqiobase->isp25mq.atio_q_in;
 		ISP_ATIO_Q_OUT(base_vha) = &ha->mqiobase->isp25mq.atio_q_out;
 	} else {
-- 
2.23.1

