Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F652C8300C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49BFA2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgD3MSv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:18:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50670 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726500AbgD3MSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 08:18:50 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6FD73288DB83002DBE5D;
        Thu, 30 Apr 2020 20:18:43 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 20:18:35 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <hmadhani@marvell.com>, <joe.carnuccio@cavium.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: qla2xxx: use true,false for ha->fw_dumped
Date:   Thu, 30 Apr 2020 20:18:00 +0800
Message-ID: <20200430121800.15323-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

drivers/scsi/qla2xxx/qla_tmpl.c:1120:2-20: WARNING: Assignment of 0/1 to
bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_dbg.c  | 4 ++--
 drivers/scsi/qla2xxx/qla_nx.c   | 4 ++--
 drivers/scsi/qla2xxx/qla_nx2.c  | 8 ++++----
 drivers/scsi/qla2xxx/qla_os.c   | 2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ca7118982c12..c54a1e72e30c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -84,7 +84,7 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 			qla82xx_md_prep(vha);
 		}
 		ha->fw_dump_reading = 0;
-		ha->fw_dumped = 0;
+		ha->fw_dumped = false;
 		break;
 	case 1:
 		if (ha->fw_dumped && !ha->fw_dump_reading) {
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b23f6f621f74..efdceeefaf45 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -706,12 +706,12 @@ qla2xxx_dump_post_process(scsi_qla_host_t *vha, int rval)
 		ql_log(ql_log_warn, vha, 0xd000,
 		    "Failed to dump firmware (%x), dump status flags (0x%lx).\n",
 		    rval, ha->fw_dump_cap_flags);
-		ha->fw_dumped = 0;
+		ha->fw_dumped = false;
 	} else {
 		ql_log(ql_log_info, vha, 0xd001,
 		    "Firmware dump saved to temp buffer (%ld/%p), dump status flags (0x%lx).\n",
 		    vha->host_no, ha->fw_dump, ha->fw_dump_cap_flags);
-		ha->fw_dumped = 1;
+		ha->fw_dumped = true;
 		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 185c5f34d4c1..d2037253e2d7 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -4177,7 +4177,7 @@ qla82xx_md_collect(scsi_qla_host_t *vha)
 		goto md_failed;
 	}
 
-	ha->fw_dumped = 0;
+	ha->fw_dumped = false;
 
 	if (!ha->md_tmplt_hdr || !ha->md_dump) {
 		ql_log(ql_log_warn, vha, 0xb038,
@@ -4357,7 +4357,7 @@ qla82xx_md_collect(scsi_qla_host_t *vha)
 	ql_log(ql_log_info, vha, 0xb044,
 	    "Firmware dump saved to temp buffer (%ld/%p %ld/%p).\n",
 	    vha->host_no, ha->md_tmplt_hdr, vha->host_no, ha->md_dump);
-	ha->fw_dumped = 1;
+	ha->fw_dumped = true;
 	qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 
 md_failed:
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index c056f466f1f4..b5c3e56edaba 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1441,7 +1441,7 @@ qla8044_device_bootstrap(struct scsi_qla_host *vha)
 	if (idc_ctrl & GRACEFUL_RESET_BIT1) {
 		qla8044_wr_reg(ha, QLA8044_IDC_DRV_CTRL,
 		    (idc_ctrl & ~GRACEFUL_RESET_BIT1));
-		ha->fw_dumped = 0;
+		ha->fw_dumped = false;
 	}
 
 dev_ready:
@@ -3249,7 +3249,7 @@ qla8044_collect_md_data(struct scsi_qla_host *vha)
 		goto md_failed;
 	}
 
-	ha->fw_dumped = 0;
+	ha->fw_dumped = false;
 
 	if (!ha->md_tmplt_hdr || !ha->md_dump) {
 		ql_log(ql_log_warn, vha, 0xb10e,
@@ -3470,7 +3470,7 @@ qla8044_collect_md_data(struct scsi_qla_host *vha)
 	ql_log(ql_log_info, vha, 0xb110,
 	    "Firmware dump saved to temp buffer (%ld/%p %ld/%p).\n",
 	    vha->host_no, ha->md_tmplt_hdr, vha->host_no, ha->md_dump);
-	ha->fw_dumped = 1;
+	ha->fw_dumped = true;
 	qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 
 
@@ -3487,7 +3487,7 @@ qla8044_get_minidump(struct scsi_qla_host *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!qla8044_collect_md_data(vha)) {
-		ha->fw_dumped = 1;
+		ha->fw_dumped = true;
 		ha->prev_minidump_failed = 0;
 	} else {
 		ql_log(ql_log_fatal, vha, 0xb0db,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 63e20c40e977..554e1d1b4c79 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4620,7 +4620,7 @@ qla2x00_free_fw_dump(struct qla_hw_data *ha)
 	ha->flags.fce_enabled = 0;
 	ha->eft = NULL;
 	ha->eft_dma = 0;
-	ha->fw_dumped = 0;
+	ha->fw_dumped = false;
 	ha->fw_dump_cap_flags = 0;
 	ha->fw_dump_reading = 0;
 	ha->fw_dump = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 342363862434..819c46f31c05 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -1117,7 +1117,7 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 		}
 
 		vha->hw->fw_dump_len = len;
-		vha->hw->fw_dumped = 1;
+		vha->hw->fw_dumped = true;
 
 		ql_log(ql_log_warn, vha, 0xd015,
 		    "-> Firmware dump saved to buffer (%lu/%p) <%lx>\n",
-- 
2.21.1

