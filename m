From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] Disable task_timeout, status_thread and status_thread_tur
	device object attributes by default
Date: Wed, 19 Nov 2008 17:38:00 -0800
Message-ID: <1227145080.4192.318.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:35418 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751292AbYKTBiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2008 20:38:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 8086e1fb0c1f00aec7d4d453c0156e0e033e72b4 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 19 Nov 2008 12:14:21 -0800
Subject: [PATCH] Disable task_timeout, status_thread and status_thread_tur device object attributes by default

There is a known bug: http://linux-iscsi.org/bug/cgi-bin/bugzilla/show_bug.cgi?id=2 that
occurs when task_timeout fires while one of the Linux subsystems is still holding on to an
outstanding I/O.  In reality, when a Linux subsystem is not returning an I/O to us after
some period of time (the old default for task_timeout was 60 for TYPE_DISK), it usually
means there is bug outside of LIO-Target.

In any event, this functionality is now disabled by default and will wait forever
for Linux subsystems to return outstanding I/O to us.

This functionality may very well end up getting removed all together in v3.0, because
if I/Os are never getting returned to the target engine, it really does mean a BUG
outside of the target code.

Forward port to v3.0 Target_Core_Mod/ConfigFS from v2.9-STABLE r405

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |    7 -------
 drivers/lio-core/target_core_device.c    |    6 ++++++
 drivers/lio-core/target_core_transport.h |    4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 0b7b3f0..5ee04d3 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -43,13 +43,6 @@
 
 #define SCSI_CDB_SIZE			16 /* SCSI Command Descriptor Block Size a la SCSI's MAX_COMMAND_SIZE */
 
-/* se_dev_attrib_t sanity values */
-#define DA_TASK_TIMEOUT_MAX		600 /* 10 Minutes, see transport_get_default_task_timeout()  */
-#define DA_STATUS_THREAD		1 /* Enabled by default */
-#define DA_STATUS_THREAD_TUR		1 /* Enabled by default */
-#define DA_STATUS_MAX_SECTORS_MIN	16
-#define DA_STATUS_MAX_SECTORS_MAX	8192
-
 /* used by PSCSI and iBlock Transport drivers */
 #define READ_BLOCK_LEN          		6
 #define READ_CAP_LEN            		8
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 974574a..a262b19 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -376,7 +376,13 @@ extern void se_dev_set_default_attribs (se_device_t *dev)
 	/*
 	 * task_timeout is based on device type.
 	 */
+#if 1
+	// Disabled by default due to known BUG in some cases when task_timeout fires..
+	// task_timeout, status_thread and status_thread_tur may end up being removed in v3.0..
+	DEV_ATTRIB(dev)->task_timeout = 0;
+#else
 	DEV_ATTRIB(dev)->task_timeout = transport_get_default_task_timeout(dev);
+#endif
 
 	return;
 }
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index c2fd11a..fe7083d 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -84,8 +84,8 @@
 
 /* se_dev_attrib_t sanity values */
 #define DA_TASK_TIMEOUT_MAX			600 /* 10 Minutes, see transport_get_default_task_timeout()  */
-#define DA_STATUS_THREAD			1 /* Enabled by default */
-#define DA_STATUS_THREAD_TUR			1 /* Enabled by default */
+#define DA_STATUS_THREAD			0 /* Disabled by default */
+#define DA_STATUS_THREAD_TUR			0 /* Disabled by default */
 #define DA_STATUS_MAX_SECTORS_MIN		16
 #define DA_STATUS_MAX_SECTORS_MAX		8192
 
-- 
1.5.4.1



