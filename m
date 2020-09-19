Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F6EC43464
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 02:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A472B21707
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 02:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgISCiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 22:38:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13711 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgISCiD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 22:38:03 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6D4AD5756FE30B666C8F;
        Sat, 19 Sep 2020 10:38:00 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:37:54 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] scsi: hisi_sas: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Sat, 19 Sep 2020 10:38:25 +0800
Message-ID: <20200919023825.5798-1-miaoqinglang@huawei.com>
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

 drivers/scsi/hisi_sas/hisi_sas_main.c | 137 ++------------------------
 1 file changed, 10 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index afc7ba892..11ad710cb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2870,19 +2870,7 @@ static int hisi_sas_debugfs_global_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_global_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_global_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_global_fops = {
-	.open = hisi_sas_debugfs_global_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_global);
 
 static int hisi_sas_debugfs_axi_show(struct seq_file *s, void *p)
 {
@@ -2897,19 +2885,7 @@ static int hisi_sas_debugfs_axi_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_axi_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_axi_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_axi_fops = {
-	.open = hisi_sas_debugfs_axi_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_axi);
 
 static int hisi_sas_debugfs_ras_show(struct seq_file *s, void *p)
 {
@@ -2924,19 +2900,7 @@ static int hisi_sas_debugfs_ras_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_ras_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_ras_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_ras_fops = {
-	.open = hisi_sas_debugfs_ras_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_ras);
 
 static int hisi_sas_debugfs_port_show(struct seq_file *s, void *p)
 {
@@ -2951,18 +2915,7 @@ static int hisi_sas_debugfs_port_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_port_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_port_show, inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_port_fops = {
-	.open = hisi_sas_debugfs_port_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_port);
 
 static void hisi_sas_show_row_64(struct seq_file *s, int index,
 				 int sz, __le64 *ptr)
@@ -3019,18 +2972,7 @@ static int hisi_sas_debugfs_cq_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_cq_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_cq_show, inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_cq_fops = {
-	.open = hisi_sas_debugfs_cq_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_cq);
 
 static void hisi_sas_dq_show_slot(struct seq_file *s, int slot, void *dq_ptr)
 {
@@ -3052,18 +2994,7 @@ static int hisi_sas_debugfs_dq_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_dq_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_dq_show, inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_dq_fops = {
-	.open = hisi_sas_debugfs_dq_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_dq);
 
 static int hisi_sas_debugfs_iost_show(struct seq_file *s, void *p)
 {
@@ -3080,18 +3011,7 @@ static int hisi_sas_debugfs_iost_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_iost_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_iost_show, inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_iost_fops = {
-	.open = hisi_sas_debugfs_iost_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_iost);
 
 static int hisi_sas_debugfs_iost_cache_show(struct seq_file *s, void *p)
 {
@@ -3117,20 +3037,7 @@ static int hisi_sas_debugfs_iost_cache_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_iost_cache_open(struct inode *inode,
-					    struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_iost_cache_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_iost_cache_fops = {
-	.open = hisi_sas_debugfs_iost_cache_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_iost_cache);
 
 static int hisi_sas_debugfs_itct_show(struct seq_file *s, void *p)
 {
@@ -3147,18 +3054,7 @@ static int hisi_sas_debugfs_itct_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_itct_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_itct_show, inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_itct_fops = {
-	.open = hisi_sas_debugfs_itct_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_itct);
 
 static int hisi_sas_debugfs_itct_cache_show(struct seq_file *s, void *p)
 {
@@ -3184,20 +3080,7 @@ static int hisi_sas_debugfs_itct_cache_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int hisi_sas_debugfs_itct_cache_open(struct inode *inode,
-					    struct file *filp)
-{
-	return single_open(filp, hisi_sas_debugfs_itct_cache_show,
-			   inode->i_private);
-}
-
-static const struct file_operations hisi_sas_debugfs_itct_cache_fops = {
-	.open = hisi_sas_debugfs_itct_cache_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(hisi_sas_debugfs_itct_cache);
 
 static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 {
-- 
2.23.0

