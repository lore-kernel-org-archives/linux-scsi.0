Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4A7C5517A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14B3220739
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJ3Ic4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:32:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:6941 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3Icz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 04:32:55 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CMwWp1nMxz70Sb;
        Fri, 30 Oct 2020 16:31:34 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 30 Oct 2020
 16:31:26 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <andriy.shevchenko@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v2 5/5] drm/i915/display: Introduce DEFINE_SHOW_STORE_ATTRIBUTE for debugfs
Date:   Fri, 30 Oct 2020 16:32:02 +0800
Message-ID: <1604046722-15531-6-git-send-email-luojiaxing@huawei.com>
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
Read-Write file, So we apply it at drm/i915/display to reduce some
duplicate code.

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

