Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B94C43465
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 02:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7B02344C
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 02:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgISCwC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 22:52:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51396 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbgISCvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 22:51:42 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 232E1E11E9FB619E256E;
        Sat, 19 Sep 2020 10:51:40 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:51:30 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] scsi: qla2xxx: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Sat, 19 Sep 2020 10:52:02 +0800
Message-ID: <20200919025202.17531-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
v2: based on linux-next(20200917), and can be applied to
    mainline cleanly now.

 drivers/scsi/qla2xxx/qla_dfs.c | 68 ++++------------------------------
 1 file changed, 8 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index e62b21152..9e49b47f6 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -37,20 +37,7 @@ qla2x00_dfs_tgt_sess_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla2x00_dfs_tgt_sess_open(struct inode *inode, struct file *file)
-{
-	scsi_qla_host_t *vha = inode->i_private;
-
-	return single_open(file, qla2x00_dfs_tgt_sess_show, vha);
-}
-
-static const struct file_operations dfs_tgt_sess_ops = {
-	.open		= qla2x00_dfs_tgt_sess_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(qla2x00_dfs_tgt_sess);
 
 static int
 qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
@@ -106,20 +93,7 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla2x00_dfs_tgt_port_database_open(struct inode *inode, struct file *file)
-{
-	scsi_qla_host_t *vha = inode->i_private;
-
-	return single_open(file, qla2x00_dfs_tgt_port_database_show, vha);
-}
-
-static const struct file_operations dfs_tgt_port_database_ops = {
-	.open		= qla2x00_dfs_tgt_port_database_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(qla2x00_dfs_tgt_port_database);
 
 static int
 qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
@@ -154,20 +128,7 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla_dfs_fw_resource_cnt_open(struct inode *inode, struct file *file)
-{
-	struct scsi_qla_host *vha = inode->i_private;
-
-	return single_open(file, qla_dfs_fw_resource_cnt_show, vha);
-}
-
-static const struct file_operations dfs_fw_resource_cnt_ops = {
-	.open           = qla_dfs_fw_resource_cnt_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(qla_dfs_fw_resource_cnt);
 
 static int
 qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
@@ -244,20 +205,7 @@ qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla_dfs_tgt_counters_open(struct inode *inode, struct file *file)
-{
-	struct scsi_qla_host *vha = inode->i_private;
-
-	return single_open(file, qla_dfs_tgt_counters_show, vha);
-}
-
-static const struct file_operations dfs_tgt_counters_ops = {
-	.open           = qla_dfs_tgt_counters_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(qla_dfs_tgt_counters);
 
 static int
 qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
@@ -459,19 +407,19 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 
 create_nodes:
 	ha->dfs_fw_resource_cnt = debugfs_create_file("fw_resource_count",
-	    S_IRUSR, ha->dfs_dir, vha, &dfs_fw_resource_cnt_ops);
+	    S_IRUSR, ha->dfs_dir, vha, &qla_dfs_fw_resource_cnt_fops);
 
 	ha->dfs_tgt_counters = debugfs_create_file("tgt_counters", S_IRUSR,
-	    ha->dfs_dir, vha, &dfs_tgt_counters_ops);
+	    ha->dfs_dir, vha, &qla_dfs_tgt_counters_fops);
 
 	ha->tgt.dfs_tgt_port_database = debugfs_create_file("tgt_port_database",
-	    S_IRUSR,  ha->dfs_dir, vha, &dfs_tgt_port_database_ops);
+	    S_IRUSR,  ha->dfs_dir, vha, &qla2x00_dfs_tgt_port_database_fops);
 
 	ha->dfs_fce = debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, vha,
 	    &dfs_fce_ops);
 
 	ha->tgt.dfs_tgt_sess = debugfs_create_file("tgt_sess",
-		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
+		S_IRUSR, ha->dfs_dir, vha, &qla2x00_dfs_tgt_sess_fops);
 
 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha))
 		ha->tgt.dfs_naqp = debugfs_create_file("naqp",
-- 
2.23.0

