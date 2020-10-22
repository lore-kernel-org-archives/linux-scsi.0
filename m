Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E27C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 08:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6151F22248
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 08:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508262AbgJVIkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 04:40:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15761 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2509380AbgJVIj2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 04:39:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5D42AE071DE8DAE113D7;
        Thu, 22 Oct 2020 16:39:24 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 22 Oct 2020
 16:39:16 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <andriy.shevchenko@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v1 4/5] usb: dwc3: debugfs: Introduce DEFINE_STORE_ATTRIBUTE
Date:   Thu, 22 Oct 2020 16:39:56 +0800
Message-ID: <1603355997-32350-5-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603355997-32350-1-git-send-email-luojiaxing@huawei.com>
References: <1603355997-32350-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seq instroduce a new helper marco DEFINE_STORE_ATTRIBUTE for
Read-Write file, So we apply it at dwc3 debugfs to reduce some duplicate
code.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/usb/dwc3/debugfs.c | 52 ++++------------------------------------------
 1 file changed, 4 insertions(+), 48 deletions(-)

diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index 5da4f60..27074cb 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -348,11 +348,6 @@ static int dwc3_lsp_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int dwc3_lsp_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dwc3_lsp_show, inode->i_private);
-}
-
 static ssize_t dwc3_lsp_write(struct file *file, const char __user *ubuf,
 			      size_t count, loff_t *ppos)
 {
@@ -377,13 +372,7 @@ static ssize_t dwc3_lsp_write(struct file *file, const char __user *ubuf,
 	return count;
 }
 
-static const struct file_operations dwc3_lsp_fops = {
-	.open			= dwc3_lsp_open,
-	.write			= dwc3_lsp_write,
-	.read			= seq_read,
-	.llseek			= seq_lseek,
-	.release		= single_release,
-};
+DEFINE_STORE_ATTRIBUTE(dwc3_lsp);
 
 static int dwc3_mode_show(struct seq_file *s, void *unused)
 {
@@ -412,11 +401,6 @@ static int dwc3_mode_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int dwc3_mode_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dwc3_mode_show, inode->i_private);
-}
-
 static ssize_t dwc3_mode_write(struct file *file,
 		const char __user *ubuf, size_t count, loff_t *ppos)
 {
@@ -445,13 +429,7 @@ static ssize_t dwc3_mode_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations dwc3_mode_fops = {
-	.open			= dwc3_mode_open,
-	.write			= dwc3_mode_write,
-	.read			= seq_read,
-	.llseek			= seq_lseek,
-	.release		= single_release,
-};
+DEFINE_STORE_ATTRIBUTE(dwc3_mode);
 
 static int dwc3_testmode_show(struct seq_file *s, void *unused)
 {
@@ -491,11 +469,6 @@ static int dwc3_testmode_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int dwc3_testmode_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dwc3_testmode_show, inode->i_private);
-}
-
 static ssize_t dwc3_testmode_write(struct file *file,
 		const char __user *ubuf, size_t count, loff_t *ppos)
 {
@@ -528,13 +501,7 @@ static ssize_t dwc3_testmode_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations dwc3_testmode_fops = {
-	.open			= dwc3_testmode_open,
-	.write			= dwc3_testmode_write,
-	.read			= seq_read,
-	.llseek			= seq_lseek,
-	.release		= single_release,
-};
+DEFINE_STORE_ATTRIBUTE(dwc3_testmode);
 
 static int dwc3_link_state_show(struct seq_file *s, void *unused)
 {
@@ -564,11 +531,6 @@ static int dwc3_link_state_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int dwc3_link_state_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dwc3_link_state_show, inode->i_private);
-}
-
 static ssize_t dwc3_link_state_write(struct file *file,
 		const char __user *ubuf, size_t count, loff_t *ppos)
 {
@@ -620,13 +582,7 @@ static ssize_t dwc3_link_state_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations dwc3_link_state_fops = {
-	.open			= dwc3_link_state_open,
-	.write			= dwc3_link_state_write,
-	.read			= seq_read,
-	.llseek			= seq_lseek,
-	.release		= single_release,
-};
+DEFINE_STORE_ATTRIBUTE(dwc3_link_state);
 
 struct dwc3_ep_file_map {
 	const char name[25];
-- 
2.7.4

