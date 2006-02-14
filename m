From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] qla2xxx: use kthread_ API
Date: Tue, 14 Feb 2006 18:46:22 +0100
Message-ID: <20060214174622.GB18919@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37068 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422710AbWBNRqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 12:46:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Use the kthread_ API instead of opencoding lots of hairy code for kernel
thread creation and teardown.

Also switch from semaphore-based thread wakeup to wake_up_process.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/qla2xxx/qla_def.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_def.h	2006-02-04 13:35:00.000000000 +0100
+++ linux-2.6/drivers/scsi/qla2xxx/qla_def.h	2006-02-14 16:04:40.000000000 +0100
@@ -2390,11 +2390,7 @@
 	struct sns_cmd_pkt	*sns_cmd;
 	dma_addr_t		sns_cmd_dma;
 
-	pid_t			dpc_pid;
-	int			dpc_should_die;
-	struct completion	dpc_inited;
-	struct completion	dpc_exited;
-	struct semaphore	*dpc_wait;
+	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
 	/* Timeout timers. */
Index: linux-2.6/drivers/scsi/qla2xxx/qla_gbl.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_gbl.h	2006-02-04 13:35:00.000000000 +0100
+++ linux-2.6/drivers/scsi/qla2xxx/qla_gbl.h	2006-02-14 16:11:22.000000000 +0100
@@ -81,6 +81,8 @@
 
 extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
+extern void qla2xxx_wake_dpc(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
Index: linux-2.6/drivers/scsi/qla2xxx/qla_isr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_isr.c	2006-02-04 13:35:00.000000000 +0100
+++ linux-2.6/drivers/scsi/qla2xxx/qla_isr.c	2006-02-14 16:01:10.000000000 +0100
@@ -838,9 +838,7 @@
 		qla_printk(KERN_WARNING, ha, "Status Entry invalid handle.\n");
 
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		if (ha->dpc_wait && !ha->dpc_active)
-			up(ha->dpc_wait);
-
+		qla2xxx_wake_dpc(ha);
 		return;
 	}
 	cp = sp->cmd;
@@ -1271,8 +1269,7 @@
 		    "Error entry - invalid handle\n");
 
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		if (ha->dpc_wait && !ha->dpc_active)
-			up(ha->dpc_wait);
+		qla2xxx_wake_dpc(ha);
 	}
 }
 
Index: linux-2.6/drivers/scsi/qla2xxx/qla_mbx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_mbx.c	2006-01-15 21:45:28.000000000 +0100
+++ linux-2.6/drivers/scsi/qla2xxx/qla_mbx.c	2006-02-14 16:01:22.000000000 +0100
@@ -285,9 +285,7 @@
 			    "Mailbox command timeout occured. Scheduling ISP "
 			    "abort.\n");
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-			if (ha->dpc_wait && !ha->dpc_active)
-				up(ha->dpc_wait);
-
+			qla2xxx_wake_dpc(ha);
 		} else if (!abort_active) {
 			/* call abort directly since we are in the DPC thread */
 			DEBUG(printk("%s(%ld): timeout calling abort_isp\n",
Index: linux-2.6/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_os.c	2006-02-04 13:35:00.000000000 +0100
+++ linux-2.6/drivers/scsi/qla2xxx/qla_os.c	2006-02-14 16:12:00.000000000 +0100
@@ -8,8 +8,8 @@
 
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -1295,8 +1295,6 @@
 	ha->brd_info = brd_info;
 	sprintf(ha->host_str, "%s_%ld", ha->brd_info->drv_name, ha->host_no);
 
-	ha->dpc_pid = -1;
-
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
 	if (ret)
@@ -1422,9 +1420,6 @@
 	 */
 	spin_lock_init(&ha->mbx_reg_lock);
 
-	init_completion(&ha->dpc_inited);
-	init_completion(&ha->dpc_exited);
-
 	qla2x00_config_dma_addressing(ha);
 	if (qla2x00_mem_alloc(ha)) {
 		qla_printk(KERN_WARNING, ha,
@@ -1451,16 +1446,14 @@
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
-	ha->dpc_should_die = 0;
-	ha->dpc_pid = kernel_thread(qla2x00_do_dpc, ha, 0);
-	if (ha->dpc_pid < 0) {
+	ha->dpc_thread = kthread_create(qla2x00_do_dpc, ha,
+			"%s_dpc", ha->host_str);
+	if (IS_ERR(ha->dpc_thread)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to start DPC thread!\n");
-
-		ret = -ENODEV;
+		ret = PTR_ERR(ha->dpc_thread);
 		goto probe_failed;
 	}
-	wait_for_completion(&ha->dpc_inited);
 
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
@@ -1594,8 +1587,6 @@
 static void
 qla2x00_free_device(scsi_qla_host_t *ha)
 {
-	int ret;
-
 	/* Abort any outstanding IO descriptors. */
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha))
 		qla2x00_cancel_io_descriptors(ha);
@@ -1605,18 +1596,15 @@
 		qla2x00_stop_timer(ha);
 
 	/* Kill the kernel thread for this host */
-	if (ha->dpc_pid >= 0) {
-		ha->dpc_should_die = 1;
-		wmb();
-		ret = kill_proc(ha->dpc_pid, SIGHUP, 1);
-		if (ret) {
-			qla_printk(KERN_ERR, ha,
-			    "Unable to signal DPC thread -- (%d)\n", ret);
+	if (ha->dpc_thread) {
+		struct task_struct *t = ha->dpc_thread;
 
-			/* TODO: SOMETHING MORE??? */
-		} else {
-			wait_for_completion(&ha->dpc_exited);
-		}
+		/*
+		 * qla2xxx_wake_dpc checks for ->dpc_thread
+		 * so we need to zero it out.
+		 */
+		ha->dpc_thread = NULL;
+		kthread_stop(t);
 	}
 
 	/* Stop currently executing firmware. */
@@ -1746,8 +1734,8 @@
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 
-	if (defer && ha->dpc_wait && !ha->dpc_active)
-		up(ha->dpc_wait);
+	if (defer)
+		qla2xxx_wake_dpc(ha);
 }
 
 /*
@@ -1964,7 +1952,6 @@
 {
 	struct list_head	*fcpl, *fcptemp;
 	fc_port_t	*fcport;
-	unsigned int	wtime;/* max wait time if mbx cmd is busy. */
 
 	if (ha == NULL) {
 		/* error */
@@ -1972,11 +1959,6 @@
 		return;
 	}
 
-	/* Make sure all other threads are stopped. */
-	wtime = 60 * 1000;
-	while (ha->dpc_wait && wtime)
-		wtime = msleep_interruptible(wtime);
-
 	/* free ioctl memory */
 	qla2x00_free_ioctl_mem(ha);
 
@@ -2125,7 +2107,6 @@
 static int
 qla2x00_do_dpc(void *data)
 {
-	DECLARE_MUTEX_LOCKED(sem);
 	scsi_qla_host_t *ha;
 	fc_port_t	*fcport;
 	uint8_t		status;
@@ -2133,32 +2114,19 @@
 
 	ha = (scsi_qla_host_t *)data;
 
-	lock_kernel();
-
-	daemonize("%s_dpc", ha->host_str);
-	allow_signal(SIGHUP);
-
-	ha->dpc_wait = &sem;
-
 	set_user_nice(current, -20);
 
-	unlock_kernel();
-
-	complete(&ha->dpc_inited);
-
-	while (1) {
+	while (!kthread_should_stop()) {
 		DEBUG3(printk("qla2x00: DPC handler sleeping\n"));
 
-		if (down_interruptible(&sem))
-			break;
-
-		if (ha->dpc_should_die)
-			break;
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+		__set_current_state(TASK_RUNNING);
 
 		DEBUG3(printk("qla2x00: DPC handler waking up\n"));
 
 		/* Initialization not yet finished. Don't do anything yet. */
-		if (!ha->flags.init_done || ha->dpc_active)
+		if (!ha->flags.init_done)
 			continue;
 
 		DEBUG3(printk("scsi(%ld): DPC handler\n", ha->host_no));
@@ -2322,10 +2290,16 @@
 	/*
 	 * Make sure that nobody tries to wake us up again.
 	 */
-	ha->dpc_wait = NULL;
 	ha->dpc_active = 0;
 
-	complete_and_exit(&ha->dpc_exited, 0);
+	return 0;
+}
+
+void
+qla2xxx_wake_dpc(scsi_qla_host_t *ha)
+{
+	if (ha->dpc_thread)
+		wake_up_process(ha->dpc_thread);
 }
 
 /*
@@ -2499,11 +2473,8 @@
 	    start_dpc ||
 	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
-	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)) &&
-	    ha->dpc_wait && !ha->dpc_active) {
-
-		up(ha->dpc_wait);
-	}
+	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)))
+		qla2xxx_wake_dpc(ha);
 
 	qla2x00_restart_timer(ha, WATCH_INTERVAL);
 }
