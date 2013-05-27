From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH 4/4] scsi: lock out SG_IO by default to unprivileged users
Date: Mon, 27 May 2013 15:50:22 +0200
Message-ID: <1369662622-5959-5-git-send-email-pbonzini__47351.7887563959$1369666544$gmane$org@redhat.com>
References: <1369662622-5959-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([208.118.235.10]:56362 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717Ab3E0Ozb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 May 2013 10:55:31 -0400
Received: from bonzini by fencepost.gnu.org with local (Exim 4.71)
	(envelope-from <bonzini@gnu.org>)
	id 1Ugype-0003WM-V3
	for linux-scsi@vger.kernel.org; Mon, 27 May 2013 10:55:31 -0400
In-Reply-To: <1369662622-5959-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, msnitzer@redhat.com, ksievers@redhat.com, jbottomley@parallels.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

Move policy on SG_IO access to userspace.  Some level of checking
at the kernel level (compared to just having an opt-out for the
default whitelist) is needed because any userspace whitelist is too
easily circumvented by doing ptrace on the program that has a file
descriptor open.  This would be a regression for those who are using Unix
permissions, security modules or the device cgroup to confine programs.

A meaningful whitelist can then be set by udev, for example.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	This is not yet usable, because sg devices do not have a link
	to the queue object.

 block/Kconfig      | 12 ++++++++++++
 block/scsi_ioctl.c | 10 ++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index e89d6a2..67d1f68 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -75,6 +75,18 @@ config BLK_DEV_SG_FILTER_SYSFS
 
 	  If unsure, say Y.
 
+config BLK_DEV_SG_FILTER_MMC
+	bool "Backwards-compatible default SG_IO filter"
+	default y
+	help
+	  Saying Y here will let you send several commands (mostly based
+	  on the MMC command set) by default to SCSI devices via /dev/sg,
+	  /dev/bsg or ioctls such as SG_IO) even for unprivileged users.
+	  Saying N will restrict the set of commands that unprivileged
+	  users can send to the bare minimum.
+
+	  If unsure, say Y.
+
 config BLK_DEV_BSGLIB
 	bool "Block layer SG support v4 helper lib"
 	default n
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 5db39b5..079dfa2 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -113,9 +113,12 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
 	memset(filter, 0, sizeof(*filter));
-
-	/* Basic read-only commands */
+	__set_bit(INQUIRY, filter->read_ok);
 	__set_bit(TEST_UNIT_READY, filter->read_ok);
+	__set_bit(REPORT_LUNS, filter->read_ok);
+
+#ifdef BLK_DEV_SG_FILTER_MMC
+	/* Basic read-only commands */
 	__set_bit(REQUEST_SENSE, filter->read_ok);
 	__set_bit(READ_6, filter->read_ok);
 	__set_bit(READ_10, filter->read_ok);
@@ -125,14 +128,12 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(READ_DEFECT_DATA, filter->read_ok);
 	__set_bit(READ_CAPACITY, filter->read_ok);
 	__set_bit(READ_LONG, filter->read_ok);
-	__set_bit(INQUIRY, filter->read_ok);
 	__set_bit(MODE_SENSE, filter->read_ok);
 	__set_bit(MODE_SENSE_10, filter->read_ok);
 	__set_bit(LOG_SENSE, filter->read_ok);
 	__set_bit(START_STOP, filter->read_ok);
 	__set_bit(GPCMD_VERIFY_10, filter->read_ok);
 	__set_bit(VERIFY_16, filter->read_ok);
-	__set_bit(REPORT_LUNS, filter->read_ok);
 	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
 	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
 	__set_bit(MAINTENANCE_IN, filter->read_ok);
@@ -193,6 +194,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
 	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
 	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
+#endif
 }
 
 int blk_verify_command(struct blk_cmd_filter *filter,
-- 
1.8.1.4

