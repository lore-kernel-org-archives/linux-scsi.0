From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 1/8] [SCSI] scsi_sysfs: Staticize local symbols
Date: Thu, 08 Aug 2013 10:13:32 +0900
Message-ID: <002401ce93d4$7f9c90c0$7ed5b240$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63056 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab3HHBNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 21:13:34 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR60055PU2A8TE0@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 08 Aug 2013 10:13:33 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

These local symbols are used only in this file.
Fix the following sparse warnings:

drivers/scsi/scsi_sysfs.c:201:25: warning: symbol 'dev_attr_hstate' was not declared. Should it be static?
drivers/scsi/scsi_sysfs.c:314:24: warning: symbol 'scsi_shost_attr_group' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/scsi/scsi_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7e50061..043150e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -198,7 +198,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
@@ -311,7 +311,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
-- 
1.7.10.4


