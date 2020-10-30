Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C175C55178
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2C522210
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgJ3Iu2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:50:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:7380 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgJ3Iu1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 04:50:27 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CMwWp1Vwcz70SZ;
        Fri, 30 Oct 2020 16:31:34 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 30 Oct 2020
 16:31:25 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <andriy.shevchenko@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v2 3/5] scsi: qla2xxx: Introduce DEFINE_SHOW_STORE_ATTRIBUTE for debugfs
Date:   Fri, 30 Oct 2020 16:32:00 +0800
Message-ID: <1604046722-15531-4-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604046722-15531-1-git-send-email-luojiaxing@huawei.com>
References: <1604046722-15531-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seq instroduce a new helper marco DEFINE_SHOW_STORE_ATTRIBUTE for
Read-Write file, So we apply it at qla2xxx to reduce some duplicate code.

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

