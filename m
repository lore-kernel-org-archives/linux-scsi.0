Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4469C5517A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 07:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A82C2085B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 07:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgKLHHw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 02:07:52 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7518 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgKLHH0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 02:07:26 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CWt2V1WpVzhkl7;
        Thu, 12 Nov 2020 15:07:14 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Nov 2020
 15:07:15 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <andriy.shevchenko@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v4 5/5] drm/i915/display: Introduce DEFINE_SHOW_STORE_ATTRIBUTE for debugfs
Date:   Thu, 12 Nov 2020 15:07:43 +0800
Message-ID: <1605164864-58944-6-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605164864-58944-1-git-send-email-luojiaxing@huawei.com>
References: <1605164864-58944-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seq introduce a new helper macro DEFINE_SHOW_STORE_ATTRIBUTE for
Read-Write file, so we apply it at drm/i915/display to reduce some
duplicated code.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 .../gpu/drm/i915/display/intel_display_debugfs.c   | 55 ++--------------------
 1 file changed, 4 insertions(+), 51 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_debugfs.c b/drivers/gpu/drm/i915/display/intel_display_debugfs.c
index 0bf31f9..8bf839f 100644
--- a/drivers/gpu/drm/i915/display/intel_display_debugfs.c
+++ b/drivers/gpu/drm/i915/display/intel_display_debugfs.c
@@ -1329,21 +1329,7 @@ static int i915_displayport_test_active_show(struct seq_file *m, void *data)
 	return 0;
 }
 
-static int i915_displayport_test_active_open(struct inode *inode,
-					     struct file *file)
-{
-	return single_open(file, i915_displayport_test_active_show,
-			   inode->i_private);
-}
-
-static const struct file_operations i915_displayport_test_active_fops = {
-	.owner = THIS_MODULE,
-	.open = i915_displayport_test_active_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.write = i915_displayport_test_active_write
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(i915_displayport_test_active);
 
 static int i915_displayport_test_data_show(struct seq_file *m, void *data)
 {
@@ -1733,19 +1719,7 @@ static ssize_t i915_hpd_storm_ctl_write(struct file *file,
 	return len;
 }
 
-static int i915_hpd_storm_ctl_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, i915_hpd_storm_ctl_show, inode->i_private);
-}
-
-static const struct file_operations i915_hpd_storm_ctl_fops = {
-	.owner = THIS_MODULE,
-	.open = i915_hpd_storm_ctl_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.write = i915_hpd_storm_ctl_write
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(i915_hpd_storm_ctl);
 
 static int i915_hpd_short_storm_ctl_show(struct seq_file *m, void *data)
 {
@@ -1811,14 +1785,7 @@ static ssize_t i915_hpd_short_storm_ctl_write(struct file *file,
 	return len;
 }
 
-static const struct file_operations i915_hpd_short_storm_ctl_fops = {
-	.owner = THIS_MODULE,
-	.open = i915_hpd_short_storm_ctl_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.write = i915_hpd_short_storm_ctl_write,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(i915_hpd_short_storm_ctl);
 
 static int i915_drrs_ctl_set(void *data, u64 val)
 {
@@ -2181,21 +2148,7 @@ static ssize_t i915_dsc_fec_support_write(struct file *file,
 	return len;
 }
 
-static int i915_dsc_fec_support_open(struct inode *inode,
-				     struct file *file)
-{
-	return single_open(file, i915_dsc_fec_support_show,
-			   inode->i_private);
-}
-
-static const struct file_operations i915_dsc_fec_support_fops = {
-	.owner = THIS_MODULE,
-	.open = i915_dsc_fec_support_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.write = i915_dsc_fec_support_write
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(i915_dsc_fec_support);
 
 /**
  * intel_connector_debugfs_add - add i915 specific connector debugfs files
-- 
2.7.4

