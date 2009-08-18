From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 20/27] zfcp: Use kthread API for zfcp erp thread
Date: Tue, 18 Aug 2009 15:43:25 +0200
Message-ID: <20090818135031.423756000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57699 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981AbZHRNuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:35 -0400
Content-Disposition: inline; filename=722-zfcp-kthread-api.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Switch the creation of the zfcp erp thread from the deprecated
kernel_thread API to the kthread API. This allows also the removal of
some flags in zfcp since the kthread API handles thread creation and
shutdown internally. To allow the usage of the kthread_stop function,
replace the erp ready semaphore with a waitqueue for waiting until erp
actions arrive on the ready queue.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    4 --
 drivers/s390/scsi/zfcp_def.h |    6 +---
 drivers/s390/scsi/zfcp_erp.c |   62 ++++++++++++++++---------------------------
 3 files changed, 27 insertions(+), 45 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:50.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:53.000000000 +0200
@@ -529,7 +529,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 		goto generic_services_failed;
 
 	init_waitqueue_head(&adapter->remove_wq);
-	init_waitqueue_head(&adapter->erp_thread_wqh);
+	init_waitqueue_head(&adapter->erp_ready_wq);
 	init_waitqueue_head(&adapter->erp_done_wqh);
 
 	INIT_LIST_HEAD(&adapter->port_list_head);
@@ -541,8 +541,6 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
 
-	sema_init(&adapter->erp_ready_sem, 0);
-
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
 	INIT_WORK(&adapter->scan_work, _zfcp_fc_scan_ports_later);
 
--- a/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:29:34.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:29:53.000000000 +0200
@@ -222,8 +222,6 @@ struct zfcp_ls_adisc {
 #define ZFCP_STATUS_ADAPTER_QDIOUP		0x00000002
 #define ZFCP_STATUS_ADAPTER_XCONFIG_OK		0x00000008
 #define ZFCP_STATUS_ADAPTER_HOST_CON_INIT	0x00000010
-#define ZFCP_STATUS_ADAPTER_ERP_THREAD_UP	0x00000020
-#define ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL	0x00000080
 #define ZFCP_STATUS_ADAPTER_ERP_PENDING		0x00000100
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
 
@@ -481,10 +479,9 @@ struct zfcp_adapter {
 	atomic_t		status;	           /* status of this adapter */
 	struct list_head	erp_ready_head;	   /* error recovery for this
 						      adapter/devices */
+	wait_queue_head_t	erp_ready_wq;
 	struct list_head	erp_running_head;
 	rwlock_t		erp_lock;
-	struct semaphore	erp_ready_sem;
-	wait_queue_head_t	erp_thread_wqh;
 	wait_queue_head_t	erp_done_wqh;
 	struct zfcp_erp_action	erp_action;	   /* pending error recovery */
         atomic_t                erp_counter;
@@ -492,6 +489,7 @@ struct zfcp_adapter {
 						      actions */
 	u32			erp_low_mem_count; /* nr of erp actions waiting
 						      for memory */
+	struct task_struct	*erp_thread;
 	struct zfcp_wka_ports	*gs;		   /* generic services */
 	struct zfcp_dbf		*dbf;		   /* debug traces */
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
--- a/drivers/s390/scsi/zfcp_erp.c	2009-08-17 11:29:38.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-08-17 11:29:53.000000000 +0200
@@ -9,6 +9,7 @@
 #define KMSG_COMPONENT "zfcp"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/kthread.h>
 #include "zfcp_ext.h"
 
 #define ZFCP_MAX_ERPS                   3
@@ -75,7 +76,7 @@ static void zfcp_erp_action_ready(struct
 
 	list_move(&act->list, &act->adapter->erp_ready_head);
 	zfcp_dbf_rec_action("erardy1", act);
-	up(&adapter->erp_ready_sem);
+	wake_up(&adapter->erp_ready_wq);
 	zfcp_dbf_rec_thread("erardy2", adapter->dbf);
 }
 
@@ -212,8 +213,7 @@ static int zfcp_erp_action_enqueue(int w
 	int retval = 1, need;
 	struct zfcp_erp_action *act = NULL;
 
-	if (!(atomic_read(&adapter->status) &
-	      ZFCP_STATUS_ADAPTER_ERP_THREAD_UP))
+	if (!adapter->erp_thread)
 		return -EIO;
 
 	need = zfcp_erp_required_act(want, adapter, port, unit);
@@ -226,7 +226,7 @@ static int zfcp_erp_action_enqueue(int w
 		goto out;
 	++adapter->erp_total_count;
 	list_add_tail(&act->list, &adapter->erp_ready_head);
-	up(&adapter->erp_ready_sem);
+	wake_up(&adapter->erp_ready_wq);
 	zfcp_dbf_rec_thread("eracte1", adapter->dbf);
 	retval = 0;
  out:
@@ -641,7 +641,8 @@ static int zfcp_erp_adapter_strat_fsf_xc
 		}
 
 		zfcp_dbf_rec_thread_lock("erasfx1", adapter->dbf);
-		down(&adapter->erp_ready_sem);
+		wait_event(adapter->erp_ready_wq,
+			   !list_empty(&adapter->erp_ready_head));
 		zfcp_dbf_rec_thread_lock("erasfx2", adapter->dbf);
 		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			break;
@@ -682,7 +683,8 @@ static int zfcp_erp_adapter_strategy_ope
 		return ZFCP_ERP_FAILED;
 
 	zfcp_dbf_rec_thread_lock("erasox1", adapter->dbf);
-	down(&adapter->erp_ready_sem);
+	wait_event(adapter->erp_ready_wq,
+		   !list_empty(&adapter->erp_ready_head));
 	zfcp_dbf_rec_thread_lock("erasox2", adapter->dbf);
 	if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 		return ZFCP_ERP_FAILED;
@@ -1285,21 +1287,17 @@ static int zfcp_erp_thread(void *data)
 	struct list_head *next;
 	struct zfcp_erp_action *act;
 	unsigned long flags;
-	int ignore;
-
-	daemonize("zfcperp%s", dev_name(&adapter->ccw_device->dev));
-	/* Block all signals */
-	siginitsetinv(&current->blocked, 0);
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-	wake_up(&adapter->erp_thread_wqh);
-
-	while (!(atomic_read(&adapter->status) &
-		 ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL)) {
 
+	for (;;) {
 		zfcp_dbf_rec_thread_lock("erthrd1", adapter->dbf);
-		ignore = down_interruptible(&adapter->erp_ready_sem);
+		wait_event_interruptible(adapter->erp_ready_wq,
+			   !list_empty(&adapter->erp_ready_head) ||
+			   kthread_should_stop());
 		zfcp_dbf_rec_thread_lock("erthrd2", adapter->dbf);
 
+		if (kthread_should_stop())
+			break;
+
 		write_lock_irqsave(&adapter->erp_lock, flags);
 		next = adapter->erp_ready_head.next;
 		write_unlock_irqrestore(&adapter->erp_lock, flags);
@@ -1313,9 +1311,6 @@ static int zfcp_erp_thread(void *data)
 		}
 	}
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-	wake_up(&adapter->erp_thread_wqh);
-
 	return 0;
 }
 
@@ -1327,18 +1322,17 @@ static int zfcp_erp_thread(void *data)
  */
 int zfcp_erp_thread_setup(struct zfcp_adapter *adapter)
 {
-	int retval;
+	struct task_struct *thread;
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-	retval = kernel_thread(zfcp_erp_thread, adapter, SIGCHLD);
-	if (retval < 0) {
+	thread = kthread_run(zfcp_erp_thread, adapter, "zfcperp%s",
+			     dev_name(&adapter->ccw_device->dev));
+	if (IS_ERR(thread)) {
 		dev_err(&adapter->ccw_device->dev,
 			"Creating an ERP thread for the FCP device failed.\n");
-		return retval;
+		return PTR_ERR(thread);
 	}
-	wait_event(adapter->erp_thread_wqh,
-		   atomic_read(&adapter->status) &
-			ZFCP_STATUS_ADAPTER_ERP_THREAD_UP);
+
+	adapter->erp_thread = thread;
 	return 0;
 }
 
@@ -1353,16 +1347,8 @@ int zfcp_erp_thread_setup(struct zfcp_ad
  */
 void zfcp_erp_thread_kill(struct zfcp_adapter *adapter)
 {
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
-	up(&adapter->erp_ready_sem);
-	zfcp_dbf_rec_thread_lock("erthrk1", adapter->dbf);
-
-	wait_event(adapter->erp_thread_wqh,
-		   !(atomic_read(&adapter->status) &
-				ZFCP_STATUS_ADAPTER_ERP_THREAD_UP));
-
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL,
-			  &adapter->status);
+	kthread_stop(adapter->erp_thread);
+	adapter->erp_thread = NULL;
 }
 
 /**

