From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/3] [SCSI] osst: Remove casting the return value which is a
 void pointer
Date: Mon, 09 Sep 2013 14:44:36 +0900
Message-ID: <005901cead1f$ab029e30$0107da90$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44558 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3IIFon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 01:44:43 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00JP3FWCD5N0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 09 Sep 2013 14:44:36 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <jejb@kernel.org>, 'Willem Riede' <osst@riede.org>, 'Jingoo Han' <jg1.han@samsung.com>

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/osst.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 21883a2..a2641bf 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5687,7 +5687,7 @@ static void osst_remove_sysfs_files(struct device_driver *sysfs)
 static ssize_t osst_adr_rev_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
-	struct osst_tape * STp = (struct osst_tape *) dev_get_drvdata (dev);
+	struct osst_tape *STp = dev_get_drvdata(dev);
 	ssize_t l = 0;
 
 	if (STp && STp->header_ok && STp->linux_media)
@@ -5701,7 +5701,7 @@ static ssize_t osst_linux_media_version_show(struct device *dev,
 					     struct device_attribute *attr,
 					     char *buf)
 {
-	struct osst_tape * STp = (struct osst_tape *) dev_get_drvdata (dev);
+	struct osst_tape *STp = dev_get_drvdata(dev);
 	ssize_t l = 0;
 
 	if (STp && STp->header_ok && STp->linux_media)
@@ -5714,7 +5714,7 @@ DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
 static ssize_t osst_capacity_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	struct osst_tape * STp = (struct osst_tape *) dev_get_drvdata (dev);
+	struct osst_tape *STp = dev_get_drvdata(dev);
 	ssize_t l = 0;
 
 	if (STp && STp->header_ok && STp->linux_media)
@@ -5728,7 +5728,7 @@ static ssize_t osst_first_data_ppos_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct osst_tape * STp = (struct osst_tape *) dev_get_drvdata (dev);
+	struct osst_tape *STp = dev_get_drvdata(dev);
 	ssize_t l = 0;
 
 	if (STp && STp->header_ok && STp->linux_media)
@@ -5742,7 +5742,7 @@ static ssize_t osst_eod_frame_ppos_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct osst_tape * STp = (struct osst_tape *) dev_get_drvdata (dev);
+	struct osst_tape *STp = dev_get_drvdata(dev);
 	ssize_t l = 0;
 
 	if (STp && STp->header_ok && STp->linux_media)
@@ -5755,7 +5755,7 @@ DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
 static ssize_t osst_filemark_cnt_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct osst_tape * STp = (struct osst_tape *) dev_get_drvdata (dev);
+	struct osst_tape *STp = dev_get_drvdata(dev);
 	ssize_t l = 0;
 
 	if (STp && STp->header_ok && STp->linux_media)
-- 
1.7.10.4


