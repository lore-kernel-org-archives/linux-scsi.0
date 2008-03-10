From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/2] zfcp: Fix race during ERP thread shutdown
Date: Mon, 10 Mar 2008 16:18:53 +0100
Message-ID: <20080310152328.463410000@de.ibm.com>
References: <20080310151852.808020000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:28584 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYCJPXc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 11:23:32 -0400
Content-Disposition: inline; filename=zfcp-fix-erp-new-action-vs-thread-kill-race.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

When shutting down an adapter, recovery actions might have been
started between zfcp_erp_wait() and zfcp_erp_thread_kill(), breaking
assumptions in the latter function.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_ccw.c |    1 -
 drivers/s390/scsi/zfcp_def.h |    1 +
 drivers/s390/scsi/zfcp_erp.c |    7 ++++---
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2008-03-10 12:34:48.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-03-10 16:05:26.000000000 +0100
@@ -608,6 +608,7 @@ do { \
 #define ZFCP_STATUS_ADAPTER_XCONFIG_OK		0x00000008
 #define ZFCP_STATUS_ADAPTER_HOST_CON_INIT	0x00000010
 #define ZFCP_STATUS_ADAPTER_ERP_THREAD_UP	0x00000020
+#define ZFCP_STATUS_ADAPTER_ERP_ACCEPT		0x00000040
 #define ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL	0x00000080
 #define ZFCP_STATUS_ADAPTER_ERP_PENDING		0x00000100
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
--- a/drivers/s390/scsi/zfcp_erp.c	2008-03-10 12:34:48.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-03-10 16:05:26.000000000 +0100
@@ -1002,7 +1002,7 @@ zfcp_erp_thread_setup(struct zfcp_adapte
 					    &adapter->status));
 		debug_text_event(adapter->erp_dbf, 5, "a_thset_ok");
 	}
-
+	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status);
 	return (retval < 0);
 }
 
@@ -1025,6 +1025,8 @@ zfcp_erp_thread_kill(struct zfcp_adapter
 {
 	int retval = 0;
 
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status);
+	zfcp_erp_wait(adapter);
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
 	up(&adapter->erp_ready_sem);
 
@@ -2940,8 +2942,7 @@ zfcp_erp_action_enqueue(int action,
 	 * efficient.
 	 */
 
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
-			      &adapter->status))
+	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status))
 		return -EIO;
 
 	debug_event(adapter->erp_dbf, 4, &action, sizeof (int));
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-03-10 12:34:48.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-03-10 16:05:26.000000000 +0100
@@ -198,7 +198,6 @@ zfcp_ccw_set_offline(struct ccw_device *
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
 	zfcp_erp_adapter_shutdown(adapter, 0);
-	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
 	up(&zfcp_data.config_sema);
 	return 0;

-- 
