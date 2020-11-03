Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83CFC2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 12:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D5CD22384
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 12:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgKCM3X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 07:29:23 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7584 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgKCM3W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 07:29:22 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CQTcB1qB7zLt6X;
        Tue,  3 Nov 2020 20:29:14 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 3 Nov 2020
 20:29:10 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <andriy.shevchenko@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v3 3/5] scsi: qla2xxx: Introduce DEFINE_SHOW_STORE_ATTRIBUTE for debugfs
Date:   Tue, 3 Nov 2020 20:29:42 +0800
Message-ID: <1604406584-53926-4-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604406584-53926-1-git-send-email-luojiaxing@huawei.com>
References: <1604406584-53926-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seq introduce a new helper macro DEFINE_SHOW_STORE_ATTRIBUTE for
Read-Write file, so we apply it at qla2xxx to reduce some duplicated code.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index f89ad32..a5de808 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -513,14 +513,6 @@ qla_dfs_naqp_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int
-qla_dfs_naqp_open(struct inode *inode, struct file *file)
-{
-	struct scsi_qla_host *vha = inode->i_private;
-
-	return single_open(file, qla_dfs_naqp_show, vha);
-}
-
 static ssize_t
 qla_dfs_naqp_write(struct file *file, const char __user *buffer,
     size_t count, loff_t *pos)
@@ -569,14 +561,7 @@ qla_dfs_naqp_write(struct file *file, const char __user *buffer,
 	return rc;
 }
 
-static const struct file_operations dfs_naqp_ops = {
-	.open		= qla_dfs_naqp_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= qla_dfs_naqp_write,
-};
-
+DEFINE_SHOW_STORE_ATTRIBUTE(qla_dfs_naqp);
 
 int
 qla2x00_dfs_setup(scsi_qla_host_t *vha)
@@ -622,7 +607,7 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 
 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha)) {
 		ha->tgt.dfs_naqp = debugfs_create_file("naqp",
-		    0400, ha->dfs_dir, vha, &dfs_naqp_ops);
+		    0400, ha->dfs_dir, vha, &qla_dfs_naqp_ops);
 		if (!ha->tgt.dfs_naqp) {
 			ql_log(ql_log_warn, vha, 0xd011,
 			       "Unable to create debugFS naqp node.\n");
-- 
2.7.4

