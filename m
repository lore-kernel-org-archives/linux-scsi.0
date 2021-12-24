Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13DBC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351815AbhLXHIS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:08:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11314 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351769AbhLXHHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2WGK3008452
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=LpgVAtLeIZYxRgjkxySq+d9rHKOpJ68bbpT+XwU2RuI=;
 b=fUksQDWmbs4TMcbnesWHCWy8DYwkkRqILwJxk6twYalReFKQixUpMy6B7PmieZrA/PPO
 n41DzcNjFX0FkvamMqGZJYy7wSXl8eYtVBnvCrPKopKJ9pEqitr489W4SlkUb2yp4iod
 8dxMjB9g0t0gPiQYwGNQmpBkoYuwzEbaOlGZFOkMu1D3ySkJe1ie8MfqTAQswxLZo+sI
 k0cxCOFtBhJ5MosjGdIi61TFNtDAA5yehPYDuR1b5/JvBbrM8AspSiSDLHu3cZaKSO3C
 kawzAuQCJl0XUsi0j+SnVyfXcUKyJUkE9s5pRiYWnn4SNBLZTnz9/RKYVeCPUkNTDkPo Lw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua2-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:54 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 23:07:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:51 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 19AEF3F7077;
        Thu, 23 Dec 2021 23:07:50 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77nYG018004;
        Thu, 23 Dec 2021 23:07:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77n1F018003;
        Thu, 23 Dec 2021 23:07:49 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 14/16] qla2xxx: Add devid's and conditionals for 28xx
Date:   Thu, 23 Dec 2021 23:07:10 -0800
Message-ID: <20211224070712.17905-15-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Wi6fXH1JxYRkfFddw54qLWh4I60EYH9f
X-Proofpoint-ORIG-GUID: Wi6fXH1JxYRkfFddw54qLWh4I60EYH9f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

28XX adapters are capable of detecting both T10 PI tag escape values
as well as IP guard. This was missed due to the adapter type missed
in the corresponding macros. Fix this by adding support for 28xx in
those macros.

Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |  7 ++-----
 drivers/scsi/qla2xxx/qla_init.c   | 17 +++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c    | 17 ++++++++++++++---
 drivers/scsi/qla2xxx/qla_os.c     |  3 +--
 drivers/scsi/qla2xxx/qla_sup.c    |  4 ++--
 drivers/scsi/qla2xxx/qla_target.c |  3 +--
 6 files changed, 31 insertions(+), 20 deletions(-)

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
index 24322eb01571..87382477ff85 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3482,6 +3482,14 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct qla2xxx_fw_dump *fw_dump;
 
+	if (ha->fw_dump) {
+		ql_dbg(ql_dbg_init, vha, 0x00bd,
+		    "Firmware dump already allocated.\n");
+		return;
+	}
+
+	ha->fw_dumped = 0;
+	ha->fw_dump_cap_flags = 0;
 	dump_size = fixed_size = mem_size = eft_size = fce_size = mq_size = 0;
 	req_q_size = rsp_q_size = 0;
 
@@ -3492,7 +3500,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
 		    sizeof(uint16_t);
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA83XX(ha))
 			fixed_size = offsetof(struct qla83xx_fw_dump, ext_mem);
 		else if (IS_QLA81XX(ha))
 			fixed_size = offsetof(struct qla81xx_fw_dump, ext_mem);
@@ -3504,8 +3512,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
 		if (ha->mqenable) {
-			if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) &&
-			    !IS_QLA28XX(ha))
+			if (!IS_QLA83XX(ha))
 				mq_size = sizeof(struct qla2xxx_mq_chain);
 			/*
 			 * Allocate maximum buffer size for all queues - Q0.
@@ -4065,9 +4072,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 			    "Unsupported FAC firmware (%d.%02d.%02d).\n",
 			    ha->fw_major_version, ha->fw_minor_version,
 			    ha->fw_subminor_version);
-
-			if (IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-			    IS_QLA28XX(ha)) {
+			if (IS_QLA83XX(ha)) {
 				ha->flags.fac_supported = 0;
 				rval = QLA_SUCCESS;
 			}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c4bd8a16d78c..826303f53f77 100644
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
@@ -728,6 +734,12 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 				vha->min_supported_speed =
 				    nv->min_supported_speed;
 			}
+
+			if (IS_PPCARCH)
+				mcp->mb[11] |= BIT_4;
+
+			if (ql2xnvmeenable)
+				mcp->mb[4] |= NVME_ENABLE_FLAG;
 		}
 
 		if (ha->flags.exlogins_enabled)
@@ -3035,8 +3047,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha)
 		ha->orig_fw_iocb_count = mcp->mb[10];
 		if (ha->flags.npiv_supported)
 			ha->max_npiv_vports = mcp->mb[11];
-		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-		    IS_QLA28XX(ha))
+		if (IS_QLA81XX(ha) || IS_QLA83XX(ha))
 			ha->fw_max_fcf_count = mcp->mb[12];
 	}
 
@@ -5627,7 +5638,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
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

