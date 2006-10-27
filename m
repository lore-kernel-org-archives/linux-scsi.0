From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH] zfcp: convert the zfcp_erp thread to the kthread api
Date: Fri, 27 Oct 2006 11:38:49 +0200
Message-ID: <200610271138.50201.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:55984 "EHLO
	mtagate4.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1946267AbWJ0Jiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Oct 2006 05:38:46 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k9R9ci6k186128
	for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2006 09:38:44 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9R9fKu82490500
	for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2006 10:41:20 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9R9ciPm022171
	for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2006 10:38:44 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

commit fc26d0531e48a7361ac7e46ead4eec2a46774413
Author: Cornelia Huck <cornelia.huck@de.ibm.com>
Date:   Fri Oct 27 11:31:05 2006 +0200

    Convert the zfcp_erp thread to the kthread api. Also make zfcp_erp_thread_killdrivers
    return void since it cannot fail.
    
    Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com> 
    Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 74c0eac..d47a0d5 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -605,8 +605,6 @@ #define ZFCP_STATUS_ADAPTER_QDIOUP		0x00
 #define ZFCP_STATUS_ADAPTER_REGISTERED		0x00000004
 #define ZFCP_STATUS_ADAPTER_XCONFIG_OK		0x00000008
 #define ZFCP_STATUS_ADAPTER_HOST_CON_INIT	0x00000010
-#define ZFCP_STATUS_ADAPTER_ERP_THREAD_UP	0x00000020
-#define ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL	0x00000080
 #define ZFCP_STATUS_ADAPTER_ERP_PENDING		0x00000100
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
 #define ZFCP_STATUS_ADAPTER_XPORT_OK		0x00000800
@@ -900,6 +898,7 @@ struct zfcp_adapter {
 						      completion races */
 	u16			status_read_failed; /* # failed status reads */
 	atomic_t		status;	           /* status of this adapter */
+	struct task_struct      *erp_thread;       /* error recovery thread */
 	struct list_head	erp_ready_head;	   /* error recovery for this
 						      adapter/devices */
 	struct list_head	erp_running_head;
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index c88babc..597104a 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -22,6 +22,7 @@
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_ERP
 
 #include "zfcp_ext.h"
+#include <linux/kthread.h>
 
 static int zfcp_erp_adisc(struct zfcp_port *);
 static void zfcp_erp_adisc_handler(unsigned long);
@@ -991,24 +992,18 @@ static void zfcp_erp_action_dismiss(stru
 int
 zfcp_erp_thread_setup(struct zfcp_adapter *adapter)
 {
-	int retval = 0;
-
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-
-	retval = kernel_thread(zfcp_erp_thread, adapter, SIGCHLD);
-	if (retval < 0) {
+	adapter->erp_thread = kthread_run(zfcp_erp_thread, adapter, "zfcperp%s",
+					  zfcp_get_busid_by_adapter(adapter));
+	if (IS_ERR(adapter->erp_thread)) {
 		ZFCP_LOG_NORMAL("error: creation of erp thread failed for "
 				"adapter %s\n",
 				zfcp_get_busid_by_adapter(adapter));
 		debug_text_event(adapter->erp_dbf, 5, "a_thset_fail");
-	} else {
-		wait_event(adapter->erp_thread_wqh,
-			   atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
-					    &adapter->status));
+		adapter->erp_thread = NULL;
+	} else
 		debug_text_event(adapter->erp_dbf, 5, "a_thset_ok");
-	}
 
-	return (retval < 0);
+	return (!adapter->erp_thread);
 }
 
 /*
@@ -1025,24 +1020,16 @@ zfcp_erp_thread_setup(struct zfcp_adapte
  *		has been completed. Thus, there are no pending erp_actions
  *		which would need to be handled here.
  */
-int
-zfcp_erp_thread_kill(struct zfcp_adapter *adapter)
+void zfcp_erp_thread_kill(struct zfcp_adapter *adapter)
 {
-	int retval = 0;
+	struct task_struct *erp_thread;
 
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
+	erp_thread = adapter->erp_thread;
+	adapter->erp_thread = NULL;
+	if (erp_thread)
+		kthread_stop(erp_thread);
 	up(&adapter->erp_ready_sem);
-
-	wait_event(adapter->erp_thread_wqh,
-		   !atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
-				     &adapter->status));
-
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL,
-			  &adapter->status);
-
 	debug_text_event(adapter->erp_dbf, 5, "a_thki_ok");
-
-	return retval;
 }
 
 /*
@@ -1060,15 +1047,12 @@ zfcp_erp_thread(void *data)
 	struct zfcp_erp_action *erp_action;
 	unsigned long flags;
 
-	daemonize("zfcperp%s", zfcp_get_busid_by_adapter(adapter));
 	/* Block all signals */
 	siginitsetinv(&current->blocked, 0);
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
 	debug_text_event(adapter->erp_dbf, 5, "a_th_run");
 	wake_up(&adapter->erp_thread_wqh);
 
-	while (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL,
-				 &adapter->status)) {
+	while (!kthread_should_stop()) {
 
 		write_lock_irqsave(&adapter->erp_lock, flags);
 		next = adapter->erp_ready_head.prev;
@@ -1093,7 +1077,6 @@ zfcp_erp_thread(void *data)
 		debug_text_event(adapter->erp_dbf, 5, "a_th_woken");
 	}
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
 	debug_text_event(adapter->erp_dbf, 5, "a_th_stop");
 	wake_up(&adapter->erp_thread_wqh);
 
@@ -2886,8 +2869,7 @@ zfcp_erp_action_enqueue(int action,
 	 * efficient.
 	 */
 
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
-			      &adapter->status))
+	if (!adapter->erp_thread)
 		return -EIO;
 
 	debug_event(adapter->erp_dbf, 4, &action, sizeof (int));
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index b8794d7..aec24af 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -148,7 +148,7 @@ extern int  zfcp_erp_unit_shutdown(struc
 extern void zfcp_erp_unit_failed(struct zfcp_unit *);
 
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
-extern int  zfcp_erp_thread_kill(struct zfcp_adapter *);
+extern void zfcp_erp_thread_kill(struct zfcp_adapter *);
 extern int  zfcp_erp_wait(struct zfcp_adapter *);
 extern void zfcp_erp_async_handler(struct zfcp_erp_action *, unsigned long);
 
