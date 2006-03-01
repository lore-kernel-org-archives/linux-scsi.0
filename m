From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: use kthread_ API
Date: Wed, 1 Mar 2006 14:02:00 -0800
Message-ID: <20060301220200.GB7288@spe2>
References: <20060214174622.GB18919@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:20488 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751291AbWCAWCH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 17:02:07 -0500
Content-Disposition: inline
In-Reply-To: <20060214174622.GB18919@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tue, 14 Feb 2006, Christoph Hellwig wrote:

> Use the kthread_ API instead of opencoding lots of hairy code for kernel
> thread creation and teardown.
> 
> Also switch from semaphore-based thread wakeup to wake_up_process.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ack.  Thanks for doing this.

I've also rebased it against the lastest linux-2.6.git tree to correct
the rejected hunk and additonal DPC ringing done in qla_sup.c.

I've added something similar to qla4xxx (which I hope will be
submitted soon... nudge...nudge...).

--
av

---

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b31a03b..2e16f32 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2414,11 +2414,7 @@ typedef struct scsi_qla_host {
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
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ffdc268..e897ead 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -81,6 +81,8 @@ extern struct fw_blob *qla2x00_request_f
 
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
 
+extern void qla2xxx_wake_dpc(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 42aa7a7..c15458c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -838,9 +838,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		qla_printk(KERN_WARNING, ha, "Status Entry invalid handle.\n");
 
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		if (ha->dpc_wait && !ha->dpc_active)
-			up(ha->dpc_wait);
-
+		qla2xxx_wake_dpc(ha);
 		return;
 	}
 	cp = sp->cmd;
@@ -1271,8 +1269,7 @@ qla2x00_error_entry(scsi_qla_host_t *ha,
 		    "Error entry - invalid handle\n");
 
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		if (ha->dpc_wait && !ha->dpc_active)
-			up(ha->dpc_wait);
+		qla2xxx_wake_dpc(ha);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 363dfdd..584cc2f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -284,9 +284,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
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
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9f91f1a..43ca0d8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8,8 +8,8 @@
 
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -1307,8 +1307,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->brd_info = brd_info;
 	sprintf(ha->host_str, "%s_%ld", ha->brd_info->drv_name, ha->host_no);
 
-	ha->dpc_pid = -1;
-
 	/* Configure PCI I/O space */
 	ret = qla2x00_iospace_config(ha);
 	if (ret)
@@ -1449,9 +1447,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 	 */
 	spin_lock_init(&ha->mbx_reg_lock);
 
-	init_completion(&ha->dpc_inited);
-	init_completion(&ha->dpc_exited);
-
 	qla2x00_config_dma_addressing(ha);
 	if (qla2x00_mem_alloc(ha)) {
 		qla_printk(KERN_WARNING, ha,
@@ -1478,16 +1473,14 @@ int qla2x00_probe_one(struct pci_dev *pd
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
@@ -1621,8 +1614,6 @@ EXPORT_SYMBOL_GPL(qla2x00_remove_one);
 static void
 qla2x00_free_device(scsi_qla_host_t *ha)
 {
-	int ret;
-
 	/* Abort any outstanding IO descriptors. */
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha))
 		qla2x00_cancel_io_descriptors(ha);
@@ -1632,18 +1623,15 @@ qla2x00_free_device(scsi_qla_host_t *ha)
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
@@ -1775,8 +1763,8 @@ qla2x00_mark_all_devices_lost(scsi_qla_h
 		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 
-	if (defer && ha->dpc_wait && !ha->dpc_active)
-		up(ha->dpc_wait);
+	if (defer)
+		qla2xxx_wake_dpc(ha);
 }
 
 /*
@@ -1993,7 +1981,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 {
 	struct list_head	*fcpl, *fcptemp;
 	fc_port_t	*fcport;
-	unsigned int	wtime;/* max wait time if mbx cmd is busy. */
 
 	if (ha == NULL) {
 		/* error */
@@ -2001,11 +1988,6 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 		return;
 	}
 
-	/* Make sure all other threads are stopped. */
-	wtime = 60 * 1000;
-	while (ha->dpc_wait && wtime)
-		wtime = msleep_interruptible(wtime);
-
 	/* free ioctl memory */
 	qla2x00_free_ioctl_mem(ha);
 
@@ -2156,7 +2138,6 @@ qla2x00_free_sp_pool( scsi_qla_host_t *h
 static int
 qla2x00_do_dpc(void *data)
 {
-	DECLARE_MUTEX_LOCKED(sem);
 	scsi_qla_host_t *ha;
 	fc_port_t	*fcport;
 	uint8_t		status;
@@ -2164,32 +2145,19 @@ qla2x00_do_dpc(void *data)
 
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
@@ -2356,10 +2324,16 @@ qla2x00_do_dpc(void *data)
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
@@ -2540,11 +2514,8 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
 	    test_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags) ||
-	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)) &&
-	    ha->dpc_wait && !ha->dpc_active) {
-
-		up(ha->dpc_wait);
-	}
+	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)))
+		qla2xxx_wake_dpc(ha);
 
 	qla2x00_restart_timer(ha, WATCH_INTERVAL);
 }
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 3866a57..8d68c46 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1354,7 +1354,7 @@ qla2x00_resume_hba(struct scsi_qla_host 
 	/* Resume HBA. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-	up(ha->dpc_wait);
+	qla2xxx_wake_dpc(ha);
 	qla2x00_wait_for_hba_online(ha);
 	scsi_unblock_requests(ha->host);
 }
@@ -1652,7 +1652,7 @@ qla24xx_write_optrom_data(struct scsi_ql
 	/* Resume HBA -- RISC reset needed. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-	up(ha->dpc_wait);
+	qla2xxx_wake_dpc(ha);
 	qla2x00_wait_for_hba_online(ha);
 	scsi_unblock_requests(ha->host);
 
