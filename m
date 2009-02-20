From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 7/7] [Target_Core_Mod/ConfigFS]: Add hw_block_size and
	block_size configfs attributes
Date: Fri, 20 Feb 2009 00:06:39 -0800
Message-ID: <1235117199.12375.1051.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:22317 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751420AbZBTIHo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 03:07:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>

>From 78b6d56c09bf1305e9ea532e734b885d0fa60b5d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:45:37 -0800
Subject: [PATCH 7/7] [Target_Core_Mod/ConfigFS]: Add hw_block_size and block_size configfs attributes

This patch adds the hw_block_size and block_size to /sys/kernel/config/target/core/$HBA/$DEV/attrib.
It allows block_size to be changed for IBLOCK, FILEIO and RAMDISK Target_Core_Mod/ConfigFS
storage objects to 4096, 2048, 1024 or 512 byte sector sizes, but currently requires that there be
*NO* active exports of said storage object to a active $FABRIC_MOD in order to change block_size.

By default, both hw_block_size and block_size are set to 512 bytes from IBLOCK, FILEIO and RAMDISK
subsystem plugins.  Note that for Target_Core_Mod/pSCSI storage objects, block_size is not allowed
to be changed (because we are doing passthrough into physical hardware registerd with Linux/SCSI)

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 46324a6..bcbd2cf 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -469,6 +469,12 @@ SE_DEV_ATTR(status_thread, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(status_thread_tur);
 SE_DEV_ATTR(status_thread_tur, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB_RO(hw_block_size);
+SE_DEV_ATTR_RO(hw_block_size);
+
+DEF_DEV_ATTRIB(block_size);
+SE_DEV_ATTR(block_size, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB_RO(hw_max_sectors);
 SE_DEV_ATTR_RO(hw_max_sectors);
 
@@ -489,6 +495,8 @@ CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib_s, da_group);
 static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_status_thread.attr,
 	&target_core_dev_attrib_status_thread_tur.attr,
+	&target_core_dev_attrib_hw_block_size.attr,
+	&target_core_dev_attrib_block_size.attr,
 	&target_core_dev_attrib_hw_max_sectors.attr,
 	&target_core_dev_attrib_max_sectors.attr,
 	&target_core_dev_attrib_hw_queue_depth.attr,
-- 
1.5.4.1



