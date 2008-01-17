From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Use completion routines.
Date: Thu, 17 Jan 2008 09:02:13 -0800
Message-ID: <1200589340-19499-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYAQRCg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:36 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Marcus Barrow <marcus.barrow@qlogic.com>

From: Marcus Barrow <marcus.barrow@qlogic.com>

Instead of abusing the semaphore interfaces for mailbox command
completions.

Additional cleanups and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h |    2 -
 drivers/scsi/qla2xxx/qla_isr.c |    8 +++---
 drivers/scsi/qla2xxx/qla_mbx.c |   44 +++------------------------------------
 drivers/scsi/qla2xxx/qla_mid.c |    5 ++-
 drivers/scsi/qla2xxx/qla_os.c  |   22 ++-----------------
 6 files changed, 16 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d0b78af..144f6d0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2413,9 +2413,9 @@ typedef struct scsi_qla_host {
 #define MBX_INTR_WAIT	2
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
-	struct semaphore mbx_cmd_sem;	/* Serialialize mbx access */
 	struct semaphore vport_sem;	/* Virtual port synchronization */
-	struct semaphore mbx_intr_sem;  /* Used for completion notification */
+	struct completion mbx_cmd_comp;	/* Serialize mbx access */
+	struct completion mbx_intr_comp;  /* Used for completion notification */
 
 	uint32_t	mbx_flags;
 #define  MBX_IN_PROGRESS	BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f6917b9..fa4455f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -105,8 +105,6 @@ extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *, int);
 
-extern int qla2x00_down_timeout(struct semaphore *, unsigned long);
-
 extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 22216fe..642a0c3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -104,7 +104,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_comp);
 	}
 
 	return (IRQ_HANDLED);
@@ -216,7 +216,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_comp);
 	}
 
 	return (IRQ_HANDLED);
@@ -1597,7 +1597,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_comp);
 	}
 
 	return IRQ_HANDLED;
@@ -1734,7 +1734,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-		up(&ha->mbx_intr_sem);
+		complete(&ha->mbx_intr_comp);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0fc1652..d23d6fc 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -8,19 +8,6 @@
 
 #include <linux/delay.h>
 
-static void
-qla2x00_mbx_sem_timeout(unsigned long data)
-{
-	struct semaphore	*sem_ptr = (struct semaphore *)data;
-
-	DEBUG11(printk("qla2x00_sem_timeout: entered.\n"));
-
-	if (sem_ptr != NULL) {
-		up(sem_ptr);
-	}
-
-	DEBUG11(printk("qla2x00_mbx_sem_timeout: exiting.\n"));
-}
 
 /*
  * qla2x00_mailbox_command
@@ -47,7 +34,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	int		rval;
 	unsigned long    flags = 0;
 	device_reg_t __iomem *reg;
-	struct timer_list	tmp_intr_timer;
 	uint8_t		abort_active;
 	uint8_t		io_lock_on;
 	uint16_t	command;
@@ -72,7 +58,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	 * non ISP abort time.
 	 */
 	if (!abort_active) {
-		if (qla2x00_down_timeout(&ha->mbx_cmd_sem, mcp->tov * HZ)) {
+		if (!wait_for_completion_timeout(&ha->mbx_cmd_comp,
+		    mcp->tov * HZ)) {
 			/* Timeout occurred. Return error. */
 			DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
 			    "Exiting.\n", __func__, ha->host_no));
@@ -135,22 +122,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	/* Wait for mbx cmd completion until timeout */
 
 	if (!abort_active && io_lock_on) {
-		/* sleep on completion semaphore */
-		DEBUG11(printk("%s(%ld): INTERRUPT MODE. Initializing timer.\n",
-		    __func__, ha->host_no));
-
-		init_timer(&tmp_intr_timer);
-		tmp_intr_timer.data = (unsigned long)&ha->mbx_intr_sem;
-		tmp_intr_timer.expires = jiffies + mcp->tov * HZ;
-		tmp_intr_timer.function =
-		    (void (*)(unsigned long))qla2x00_mbx_sem_timeout;
-
-		DEBUG11(printk("%s(%ld): Adding timer.\n", __func__,
-		    ha->host_no));
-		add_timer(&tmp_intr_timer);
-
-		DEBUG11(printk("%s(%ld): going to unlock & sleep. "
-		    "time=0x%lx.\n", __func__, ha->host_no, jiffies));
 
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
@@ -160,17 +131,10 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		/* Wait for either the timer to expire
-		 * or the mbox completion interrupt
-		 */
-		down(&ha->mbx_intr_sem);
+		wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
 
-		DEBUG11(printk("%s(%ld): waking up. time=0x%lx\n", __func__,
-		    ha->host_no, jiffies));
 		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
-		/* delete the timer */
-		del_timer(&tmp_intr_timer);
 	} else {
 		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
 		    ha->host_no, command));
@@ -299,7 +263,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	/* Allow next mbx cmd to come in. */
 	if (!abort_active)
-		up(&ha->mbx_cmd_sem);
+		complete(&ha->mbx_cmd_comp);
 
 	if (rval) {
 		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 74096aa..325bdab 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -403,8 +403,9 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	}
 	vha->mgmt_svr_loop_id = 10 + vha->vp_idx;
 
-	init_MUTEX(&vha->mbx_cmd_sem);
-	init_MUTEX_LOCKED(&vha->mbx_intr_sem);
+	init_completion(&vha->mbx_cmd_comp);
+	complete(&vha->mbx_cmd_comp);
+	init_completion(&vha->mbx_intr_comp);
 
 	INIT_LIST_HEAD(&vha->list);
 	INIT_LIST_HEAD(&vha->fcports);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bb2d3d6..19d0f95 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1692,9 +1692,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* load the F/W, read paramaters, and init the H/W */
 	ha->instance = num_hosts;
 
-	init_MUTEX(&ha->mbx_cmd_sem);
 	init_MUTEX(&ha->vport_sem);
-	init_MUTEX_LOCKED(&ha->mbx_intr_sem);
+	init_completion(&ha->mbx_cmd_comp);
+	complete(&ha->mbx_cmd_comp);
+	init_completion(&ha->mbx_intr_comp);
 
 	INIT_LIST_HEAD(&ha->list);
 	INIT_LIST_HEAD(&ha->fcports);
@@ -2739,23 +2740,6 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	qla2x00_restart_timer(ha, WATCH_INTERVAL);
 }
 
-/* XXX(hch): crude hack to emulate a down_timeout() */
-int
-qla2x00_down_timeout(struct semaphore *sema, unsigned long timeout)
-{
-	const unsigned int step = 100; /* msecs */
-	unsigned int iterations = jiffies_to_msecs(timeout)/100;
-
-	do {
-		if (!down_trylock(sema))
-			return 0;
-		if (msleep_interruptible(step))
-			break;
-	} while (--iterations > 0);
-
-	return -ETIMEDOUT;
-}
-
 /* Firmware interface routines. */
 
 #define FW_BLOBS	6
-- 
1.5.4.rc3.14.g44397

