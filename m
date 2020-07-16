Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BA6C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 08:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F42520760
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 08:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgGPIml (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:42:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7757 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbgGPIml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jul 2020 04:42:41 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3042D61FE7B99EBF6193;
        Thu, 16 Jul 2020 16:42:39 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 16 Jul 2020 16:42:33 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] scsi: qla2xxx: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 16 Jul 2020 16:46:03 +0800
Message-ID: <20200716084603.7491-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yongqiang Liu <liuyongqiang13@huawei.com>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 69 +++++-----------------------------
 1 file changed, 9 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 581ed7597..954a4d9f7 100644
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
-	.read_iter		= seq_read_iter,
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
-	.read_iter		= seq_read_iter,
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
-	.read_iter           = seq_read_iter,
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
-	.read_iter           = seq_read_iter,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(qla_dfs_tgt_counters);
 
 static int
 qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
@@ -459,19 +407,20 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 
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
+
 
 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha))
 		ha->tgt.dfs_naqp = debugfs_create_file("naqp",
-- 
2.17.1

