Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B46ECAAA3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343670AbiHZK0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245238AbiHZK0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:26:23 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06225CCE3F
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q319Bj027726
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zpVyerr0aa3TJnleEu21/cyVKgr0MINvHjUeMO8p+zs=;
 b=hC5+KrcWx7spcMALMzc5JnCks0U78M0XDbHQjBvAF1b0qYcvMBSs3DTLhS+X7c/Scb0h
 eivTBcdDiU18jMAUlzJPftrxiydjOzdNDmVC7NGazMLfTLhtZGZK+b26eKoJnvD9ilqE
 abeqvaNlms4uZmSjfbBdGjF9Qmksm6iXlD0TqBe16b1ELLH/Xlg4muEB8WVDjtr+T8xC
 7KGaWgHjHNqBCbU61Fue2pjlVsVIZSpbieongBX+uYoijzZ0soAqBrepsCKmAvxHYMn0
 8f0WeLzRJ1QEMQBl/+agkP5UqjQMao8yKZMJIMz9RalogBkWkJkiiKhc8reMnlMf45/d wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j5a67na2p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 03:26:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Aug
 2022 03:26:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 26 Aug 2022 03:26:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 966423F70F2;
        Fri, 26 Aug 2022 03:26:17 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH v2 3/7] qla2xxx: Add debugfs create/delete helpers
Date:   Fri, 26 Aug 2022 03:25:55 -0700
Message-ID: <20220826102559.17474-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220826102559.17474-1-njavali@marvell.com>
References: <20220826102559.17474-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: md6wmRXFU74yP_02nCTPxPnBca2e9t9U
X-Proofpoint-GUID: md6wmRXFU74yP_02nCTPxPnBca2e9t9U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Define a few helpful macros for creating debugfs files.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  5 ++
 drivers/scsi/qla2xxx/qla_dfs.c | 93 ++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3ec6a200942e..22274b405d01 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -35,6 +35,11 @@
 
 #include <uapi/scsi/fc/fc_els.h>
 
+#define QLA_DFS_DEFINE_DENTRY(_debugfs_file_name) \
+	struct dentry *dfs_##_debugfs_file_name
+#define QLA_DFS_ROOT_DEFINE_DENTRY(_debugfs_file_name) \
+	struct dentry *qla_dfs_##_debugfs_file_name
+
 /* Big endian Fibre Channel S_ID (source ID) or D_ID (destination ID). */
 typedef struct {
 	uint8_t domain;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 85bd0e468d43..777808af5634 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -489,6 +489,99 @@ qla_dfs_naqp_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
+/*
+ * Helper macros for setting up debugfs entries.
+ * _name: The name of the debugfs entry
+ * _ctx_struct: The context that was passed when creating the debugfs file
+ *
+ * QLA_DFS_SETUP_RD could be used when there is only a show function.
+ * - show function take the name qla_dfs_<sysfs-name>_show
+ *
+ * QLA_DFS_SETUP_RW could be used when there are both show and write functions.
+ * - show function take the name  qla_dfs_<sysfs-name>_show
+ * - write function take the name qla_dfs_<sysfs-name>_write
+ *
+ * To have a new debugfs entry, do:
+ * 1. Create a "struct dentry *" in the appropriate structure in the format
+ * dfs_<sysfs-name>
+ * 2. Setup debugfs entries using QLA_DFS_SETUP_RD / QLA_DFS_SETUP_RW
+ * 3. Create debugfs file in qla2x00_dfs_setup() using QLA_DFS_CREATE_FILE
+ * or QLA_DFS_ROOT_CREATE_FILE
+ * 4. Remove debugfs file in qla2x00_dfs_remove() using QLA_DFS_REMOVE_FILE
+ * or QLA_DFS_ROOT_REMOVE_FILE
+ *
+ * Example for creating "TEST" sysfs file:
+ * 1. struct qla_hw_data { ... struct dentry *dfs_TEST; }
+ * 2. QLA_DFS_SETUP_RD(TEST, scsi_qla_host_t);
+ * 3. In qla2x00_dfs_setup():
+ * QLA_DFS_CREATE_FILE(ha, TEST, 0600, ha->dfs_dir, vha);
+ * 4. In qla2x00_dfs_remove():
+ * QLA_DFS_REMOVE_FILE(ha, TEST);
+ */
+#define QLA_DFS_SETUP_RD(_name, _ctx_struct)				\
+static int								\
+qla_dfs_##_name##_open(struct inode *inode, struct file *file)		\
+{									\
+	_ctx_struct *__ctx = inode->i_private;				\
+									\
+	return single_open(file, qla_dfs_##_name##_show, __ctx);	\
+}									\
+									\
+static const struct file_operations qla_dfs_##_name##_ops = {		\
+	.open           = qla_dfs_##_name##_open,			\
+	.read           = seq_read,					\
+	.llseek         = seq_lseek,					\
+	.release        = single_release,				\
+};
+
+#define QLA_DFS_SETUP_RW(_name, _ctx_struct)				\
+static int								\
+qla_dfs_##_name##_open(struct inode *inode, struct file *file)		\
+{									\
+	_ctx_struct *__ctx = inode->i_private;				\
+									\
+	return single_open(file, qla_dfs_##_name##_show, __ctx);	\
+}									\
+									\
+static const struct file_operations qla_dfs_##_name##_ops = {		\
+	.open           = qla_dfs_##_name##_open,			\
+	.read           = seq_read,					\
+	.llseek         = seq_lseek,					\
+	.release        = single_release,				\
+	.write		= qla_dfs_##_name##_write,			\
+};
+
+#define QLA_DFS_ROOT_CREATE_FILE(_name, _perm, _ctx)			\
+	do {								\
+		if (!qla_dfs_##_name)					\
+			qla_dfs_##_name = debugfs_create_file(#_name,	\
+					_perm, qla2x00_dfs_root, _ctx,	\
+					&qla_dfs_##_name##_ops);	\
+	} while (0)
+
+#define QLA_DFS_ROOT_REMOVE_FILE(_name)					\
+	do {								\
+		if (qla_dfs_##_name) {					\
+			debugfs_remove(qla_dfs_##_name);		\
+			qla_dfs_##_name = NULL;				\
+		}							\
+	} while (0)
+
+#define QLA_DFS_CREATE_FILE(_struct, _name, _perm, _parent, _ctx)	\
+	do {								\
+		(_struct)->dfs_##_name = debugfs_create_file(#_name,	\
+					_perm, _parent, _ctx,		\
+					&qla_dfs_##_name##_ops)		\
+	} while (0)
+
+#define QLA_DFS_REMOVE_FILE(_struct, _name)				\
+	do {								\
+		if ((_struct)->dfs_##_name) {				\
+			debugfs_remove((_struct)->dfs_##_name);		\
+			(_struct)->dfs_##_name = NULL;			\
+		}							\
+	} while (0)
+
 static int
 qla_dfs_naqp_open(struct inode *inode, struct file *file)
 {
-- 
2.19.0.rc0

