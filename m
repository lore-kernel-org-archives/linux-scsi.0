Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DB8C388F7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 12:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7C022384
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 12:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgKCM3a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 07:29:30 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7587 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgKCM30 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 07:29:26 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CQTcB2Z5dzLt84;
        Tue,  3 Nov 2020 20:29:14 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 3 Nov 2020
 20:29:09 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <andriy.shevchenko@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v3 2/5] scsi: hisi_sas: Introduce DEFINE_SHOW_STORE_ATTRIBUTE for debugfs
Date:   Tue, 3 Nov 2020 20:29:41 +0800
Message-ID: <1604406584-53926-3-git-send-email-luojiaxing@huawei.com>
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
Read-Write file, so we use it at our code to reduce some duplicated code.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 135 ++++------------------------------
 1 file changed, 16 insertions(+), 119 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 128583d..b8a6fc9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3403,22 +3403,7 @@ static ssize_t hisi_sas_debugfs_bist_linkrate_write(struct file *filp,
 
 	return count;
 }
-
-static int hisi_sas_debugfs_bist_linkrate_open(struct inode *inode,
-					       struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_bist_linkrate_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_bist_linkrate_ops = {
-	.open = hisi_sas_debugfs_bist_linkrate_open,
-	.read = seq_read,
-	.write = hisi_sas_debugfs_bist_linkrate_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(hisi_sas_debugfs_bist_linkrate);
 
 static const struct {
 	int		value;
@@ -3493,22 +3478,7 @@ static ssize_t hisi_sas_debugfs_bist_code_mode_write(struct file *filp,
 
 	return count;
 }
-
-static int hisi_sas_debugfs_bist_code_mode_open(struct inode *inode,
-						struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_bist_code_mode_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_bist_code_mode_ops = {
-	.open = hisi_sas_debugfs_bist_code_mode_open,
-	.read = seq_read,
-	.write = hisi_sas_debugfs_bist_code_mode_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(hisi_sas_debugfs_bist_code_mode);
 
 static ssize_t hisi_sas_debugfs_bist_phy_write(struct file *filp,
 					       const char __user *buf,
@@ -3542,22 +3512,7 @@ static int hisi_sas_debugfs_bist_phy_show(struct seq_file *s, void *p)
 
 	return 0;
 }
-
-static int hisi_sas_debugfs_bist_phy_open(struct inode *inode,
-					  struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_bist_phy_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_bist_phy_ops = {
-	.open = hisi_sas_debugfs_bist_phy_open,
-	.read = seq_read,
-	.write = hisi_sas_debugfs_bist_phy_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(hisi_sas_debugfs_bist_phy);
 
 static const struct {
 	int		value;
@@ -3621,22 +3576,7 @@ static ssize_t hisi_sas_debugfs_bist_mode_write(struct file *filp,
 
 	return count;
 }
-
-static int hisi_sas_debugfs_bist_mode_open(struct inode *inode,
-					   struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_bist_mode_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_bist_mode_ops = {
-	.open = hisi_sas_debugfs_bist_mode_open,
-	.read = seq_read,
-	.write = hisi_sas_debugfs_bist_mode_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(hisi_sas_debugfs_bist_mode);
 
 static ssize_t hisi_sas_debugfs_bist_enable_write(struct file *filp,
 						  const char __user *buf,
@@ -3677,22 +3617,7 @@ static int hisi_sas_debugfs_bist_enable_show(struct seq_file *s, void *p)
 
 	return 0;
 }
-
-static int hisi_sas_debugfs_bist_enable_open(struct inode *inode,
-					     struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_bist_enable_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_bist_enable_ops = {
-	.open = hisi_sas_debugfs_bist_enable_open,
-	.read = seq_read,
-	.write = hisi_sas_debugfs_bist_enable_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(hisi_sas_debugfs_bist_enable);
 
 static const struct {
 	char *name;
@@ -3730,21 +3655,7 @@ static int hisi_sas_debugfs_show(struct seq_file *s, void *p)
 
 	return 0;
 }
-
-static int hisi_sas_debugfs_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_ops = {
-	.open = hisi_sas_debugfs_open,
-	.read = seq_read,
-	.write = hisi_sas_debugfs_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(hisi_sas_debugfs);
 
 static ssize_t hisi_sas_debugfs_phy_down_cnt_write(struct file *filp,
 						   const char __user *buf,
@@ -3776,21 +3687,7 @@ static int hisi_sas_debugfs_phy_down_cnt_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_phy_down_cnt_open(struct inode *inode,
-					      struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_phy_down_cnt_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_phy_down_cnt_ops = {
-	.open = hisi_sas_debugfs_phy_down_cnt_open,
-	.read = seq_read,
-	.write = hisi_sas_debugfs_phy_down_cnt_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(hisi_sas_debugfs_phy_down_cnt);
 
 void hisi_sas_debugfs_work_handler(struct work_struct *work)
 {
@@ -3937,7 +3834,7 @@ static void hisi_sas_debugfs_phy_down_cnt_init(struct hisi_hba *hisi_hba)
 		snprintf(name, 16, "%d", phy_no);
 		debugfs_create_file(name, 0600, dir,
 				    &hisi_hba->phy[phy_no],
-				    &hisi_sas_debugfs_phy_down_cnt_ops);
+				    &hisi_sas_debugfs_phy_down_cnt_fops);
 	}
 }
 
@@ -3950,34 +3847,34 @@ static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 			debugfs_create_dir("bist", hisi_hba->debugfs_dir);
 	debugfs_create_file("link_rate", 0600,
 			    hisi_hba->debugfs_bist_dentry, hisi_hba,
-			    &hisi_sas_debugfs_bist_linkrate_ops);
+			    &hisi_sas_debugfs_bist_linkrate_fops);
 
 	debugfs_create_file("code_mode", 0600,
 			    hisi_hba->debugfs_bist_dentry, hisi_hba,
-			    &hisi_sas_debugfs_bist_code_mode_ops);
+			    &hisi_sas_debugfs_bist_code_mode_fops);
 
 	debugfs_create_file("fixed_code", 0600,
 			    hisi_hba->debugfs_bist_dentry,
 			    &hisi_hba->debugfs_bist_fixed_code[0],
-			    &hisi_sas_debugfs_ops);
+			    &hisi_sas_debugfs_fops);
 
 	debugfs_create_file("fixed_code_1", 0600,
 			    hisi_hba->debugfs_bist_dentry,
 			    &hisi_hba->debugfs_bist_fixed_code[1],
-			    &hisi_sas_debugfs_ops);
+			    &hisi_sas_debugfs_fops);
 
 	debugfs_create_file("phy_id", 0600, hisi_hba->debugfs_bist_dentry,
-			    hisi_hba, &hisi_sas_debugfs_bist_phy_ops);
+			    hisi_hba, &hisi_sas_debugfs_bist_phy_fops);
 
 	debugfs_create_u32("cnt", 0600, hisi_hba->debugfs_bist_dentry,
 			   &hisi_hba->debugfs_bist_cnt);
 
 	debugfs_create_file("loopback_mode", 0600,
 			    hisi_hba->debugfs_bist_dentry,
-			    hisi_hba, &hisi_sas_debugfs_bist_mode_ops);
+			    hisi_hba, &hisi_sas_debugfs_bist_mode_fops);
 
 	debugfs_create_file("enable", 0600, hisi_hba->debugfs_bist_dentry,
-			    hisi_hba, &hisi_sas_debugfs_bist_enable_ops);
+			    hisi_hba, &hisi_sas_debugfs_bist_enable_fops);
 
 	ports_dentry = debugfs_create_dir("port", hisi_hba->debugfs_bist_dentry);
 
@@ -3996,7 +3893,7 @@ static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 			debugfs_create_file(hisi_sas_debugfs_ffe_name[i].name,
 					    0600, ffe_dentry,
 					    &hisi_hba->debugfs_bist_ffe[phy_no][i],
-					    &hisi_sas_debugfs_ops);
+					    &hisi_sas_debugfs_fops);
 		}
 	}
 
-- 
2.7.4

