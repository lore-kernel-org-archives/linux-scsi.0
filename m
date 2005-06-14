From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/11]  qla2xxx: Add MBX command routines for ISP24xx support.
Date: Mon, 13 Jun 2005 22:31:56 -0700 (PDT)
Message-ID: <20050614053156.12127.12164.sendpatchset@plap.qlogic.com>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:44438 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261201AbVFNFb6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 01:31:58 -0400
In-Reply-To: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add MBX command routines for ISP24xx support.

Generalize several routines [qla2x00_load_ram_ext(),
qla2x00_execute_fw(), qla2x00_verify_checksum()] to handle
larger addressing space.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_gbl.h |   19 +
 drivers/scsi/qla2xxx/qla_mbx.c | 1024 +++++++++++++++++++++++++++++++---------
 2 files changed, 811 insertions(+), 232 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -95,10 +95,10 @@ extern int
 qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t);
 
 extern int
-qla2x00_load_ram_ext(scsi_qla_host_t *, dma_addr_t, uint32_t, uint16_t);
+qla2x00_load_ram_ext(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
 
 extern int
-qla2x00_execute_fw(scsi_qla_host_t *);
+qla2x00_execute_fw(scsi_qla_host_t *, uint32_t);
 
 extern void
 qla2x00_get_fw_version(scsi_qla_host_t *, uint16_t *,
@@ -114,7 +114,7 @@ extern int
 qla2x00_mbx_reg_test(scsi_qla_host_t *);
 
 extern int
-qla2x00_verify_checksum(scsi_qla_host_t *);
+qla2x00_verify_checksum(scsi_qla_host_t *, uint32_t);
 
 extern int
 qla2x00_issue_iocb(scsi_qla_host_t *, void *, dma_addr_t, size_t);
@@ -124,7 +124,7 @@ qla2x00_abort_command(scsi_qla_host_t *,
 
 #if USE_ABORT_TGT
 extern int
-qla2x00_abort_target(fc_port_t *fcport);
+qla2x00_abort_target(fc_port_t *);
 #endif
 
 extern int
@@ -163,7 +163,7 @@ extern int
 qla2x00_login_local_device(scsi_qla_host_t *, uint16_t, uint16_t *, uint8_t);
 
 extern int
-qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id);
+qla2x00_fabric_logout(scsi_qla_host_t *, uint16_t, uint8_t, uint8_t, uint8_t);
 
 extern int
 qla2x00_full_login_lip(scsi_qla_host_t *ha);
@@ -178,6 +178,15 @@ qla2x00_get_resource_cnts(scsi_qla_host_
 extern int
 qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map);
 
+extern int qla2x00_system_error(scsi_qla_host_t *);
+
+extern int
+qla2x00_get_serdes_params(scsi_qla_host_t *, uint16_t *, uint16_t *,
+    uint16_t *);
+
+extern int
+qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -20,6 +20,10 @@
 
 #include <linux/delay.h>
 
+//ISP24xx
+int qla24xx_abort_command(scsi_qla_host_t *, srb_t *);
+int qla24xx_abort_target(scsi_qla_host_t *, fc_port_t *);
+
 static void
 qla2x00_mbx_sem_timeout(unsigned long data)
 {
@@ -57,10 +61,12 @@ static int
 qla2x00_mailbox_command(scsi_qla_host_t *ha, mbx_cmd_t *mcp)
 {
 	int		rval;
-	unsigned long    flags = 0;
-	device_reg_t __iomem *reg = ha->iobase;
-	struct timer_list	tmp_intr_timer;
-	uint8_t		abort_active = test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+	unsigned long	flags = 0;
+	device_reg_t __iomem *reg = NULL;
+	struct device_reg_24xx __iomem *reg24 = NULL;
+
+	struct timer_list tmp_intr_timer;
+	uint8_t		abort_active;
 	uint8_t		io_lock_on = ha->flags.init_done;
 	uint16_t	command;
 	uint16_t	*iptr;
@@ -71,19 +77,20 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	unsigned long	wait_time;
 
 	rval = QLA_SUCCESS;
+	abort_active = test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
 
-	DEBUG11(printk("qla2x00_mailbox_command(%ld): entered.\n",
-	    ha->host_no);)
 	/*
-	 * Wait for active mailbox commands to finish by waiting at most
-	 * tov seconds. This is to serialize actual issuing of mailbox cmds
-	 * during non ISP abort time.
+	 * Wait for active mailbox commands to finish by waiting at most tov
+	 * seconds. This is to serialize actual issuing of mailbox cmds during
+	 * non ISP abort time.
 	 */
 	if (!abort_active) {
 		if (qla2x00_down_timeout(&ha->mbx_cmd_sem, mcp->tov * HZ)) {
 			/* Timeout occurred. Return error. */
-			DEBUG2_3_11(printk("qla2x00_mailbox_command(%ld): cmd "
-			    "access timeout. Exiting.\n", ha->host_no);)
+			DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
+			    "Exiting.\n", __func__, ha->host_no);)
 			return QLA_FUNCTION_TIMEOUT;
 		}
 	}
@@ -96,13 +103,19 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	if (!abort_active)
 		spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);
 
-	DEBUG11(printk("scsi%d: prepare to issue mbox cmd=0x%x.\n",
-	    (int)ha->host_no, mcp->mb[0]);)
+	DEBUG11(printk("scsi(%ld): prepare to issue mbox cmd=0x%x.\n",
+	    ha->host_no, mcp->mb[0]);)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Load mailbox registers. */
-	optr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 0);
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		reg24 = (struct device_reg_24xx __iomem *)ha->iobase;
+		optr = (uint16_t __iomem *)&reg24->mailbox0;
+	} else {
+		reg = ha->iobase;
+		optr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 0);
+	}
 
 	iptr = mcp->mb;
 	command = mcp->mb[0];
@@ -120,16 +133,15 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	}
 
 #if defined(QL_DEBUG_LEVEL_1)
-	printk("qla2x00_mailbox_command: Loaded MBX registers "
-	    "(displayed in bytes) = \n");
+	printk("%s(%ld): Loaded MBX registers (displayed in bytes) = \n",
+	    __func__, ha->host_no);
 	qla2x00_dump_buffer((uint8_t *)mcp->mb, 16);
 	printk("\n");
 	qla2x00_dump_buffer(((uint8_t *)mcp->mb + 0x10), 16);
 	printk("\n");
 	qla2x00_dump_buffer(((uint8_t *)mcp->mb + 0x20), 8);
 	printk("\n");
-	printk("qla2x00_mailbox_command: I/O address = %lx.\n",
-	    (u_long)optr);
+	printk("%s(%ld): I/O address = %p.\n", __func__, ha->host_no, optr);
 	qla2x00_dump_regs(ha);
 #endif
 
@@ -138,17 +150,15 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
 	/* Unlock mbx registers and wait for interrupt */
-
-	DEBUG11(printk("qla2x00_mailbox_command: going to unlock irq & "
-	    "waiting for interrupt. jiffies=%lx.\n", jiffies);)
+	DEBUG11(printk("%s(%ld): going to unlock irq & waiting for interrupt. "
+	    "jiffies=%lx.\n", __func__, ha->host_no, jiffies);)
 
 	/* Wait for mbx cmd completion until timeout */
 
 	if (!abort_active && io_lock_on) {
 		/* sleep on completion semaphore */
-		DEBUG11(printk("qla2x00_mailbox_command(%ld): "
-		    "INTERRUPT MODE. Initializing timer.\n",
-		    ha->host_no);)
+		DEBUG11(printk("%s(%ld): INTERRUPT MODE. Initializing timer.\n",
+		    __func__, ha->host_no);)
 
 		init_timer(&tmp_intr_timer);
 		tmp_intr_timer.data = (unsigned long)&ha->mbx_intr_sem;
@@ -156,16 +166,19 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 		tmp_intr_timer.function =
 		    (void (*)(unsigned long))qla2x00_mbx_sem_timeout;
 
-		DEBUG11(printk("qla2x00_mailbox_command(%ld): "
-		    "Adding timer.\n", ha->host_no);)
+		DEBUG11(printk("%s(%ld): Adding timer.\n", __func__,
+		    ha->host_no);)
 		add_timer(&tmp_intr_timer);
 
-		DEBUG11(printk("qla2x00_mailbox_command: going to "
-		    "unlock & sleep. time=0x%lx.\n", jiffies);)
+		DEBUG11(printk("%s(%ld): going to unlock & sleep. "
+		    "time=0x%lx.\n", __func__, ha->host_no, jiffies);)
 
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
-		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			WRT_REG_DWORD(&reg24->hccr, HCCRX_SET_HOST_INT);
+		else
+			WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		if (!abort_active)
@@ -176,19 +189,20 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 		 */
 		down(&ha->mbx_intr_sem);
 
-		DEBUG11(printk("qla2x00_mailbox_command:"
-		    "waking up."
-		    "time=0x%lx\n", jiffies);)
+		DEBUG11(printk("%s(%ld): waking up. time=0x%lx\n", __func__,
+		    ha->host_no, jiffies);)
 		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
 		/* delete the timer */
 		del_timer(&tmp_intr_timer);
 	} else {
+		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
+		    ha->host_no, command);)
 
-		DEBUG3_11(printk("qla2x00_mailbox_command(%ld): cmd=%x "
-			"POLLING MODE.\n", ha->host_no, command);)
-
-		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			WRT_REG_DWORD(&reg24->hccr, HCCRX_SET_HOST_INT);
+		else
+			WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		if (!abort_active)
 			spin_unlock_irqrestore(&ha->mbx_reg_lock, mbx_flags);
@@ -212,8 +226,8 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	if (ha->flags.mbox_int) {
 		uint16_t *iptr2;
 
-		DEBUG3_11(printk("qla2x00_mailbox_cmd: cmd %x completed.\n",
-		    command);)
+		DEBUG3_11(printk("%s(%ld): cmd %x completed.\n", __func__,
+		    ha->host_no, command);)
 
 		/* Got interrupt. Clear the flag. */
 		ha->flags.mbox_int = 0;
@@ -238,12 +252,22 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 
 #if defined(QL_DEBUG_LEVEL_2) || defined(QL_DEBUG_LEVEL_3) || \
 		defined(QL_DEBUG_LEVEL_11)
-		printk("qla2x00_mailbox_command(%ld): **** MB Command Timeout "
-		    "for cmd %x ****\n", ha->host_no, command);
-		printk("qla2x00_mailbox_command: icontrol=%x jiffies=%lx\n",
-		    RD_REG_WORD(&reg->ictrl), jiffies);
-		printk("qla2x00_mailbox_command: *** mailbox[0] = 0x%x ***\n",
-		    RD_REG_WORD(optr));
+		uint16_t mb0;
+		uint32_t ictrl;
+
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+			mb0 = RD_REG_WORD(&reg24->mailbox0);
+			ictrl = RD_REG_DWORD(&reg24->ictrl);
+		} else {
+			mb0 = RD_MAILBOX_REG(ha, reg, 0);
+			ictrl = RD_REG_WORD(&reg->ictrl);
+		}
+		printk("%s(%ld): **** MB Command Timeout for cmd %x ****\n",
+		    __func__, ha->host_no, command);
+		printk("%s(%ld): icontrol=%x jiffies=%lx\n", __func__,
+		    ha->host_no, ictrl, jiffies);
+		printk("%s(%ld): *** mailbox[0] = 0x%x ***\n", __func__,
+		    ha->host_no, mb0);
 		qla2x00_dump_regs(ha);
 #endif
 
@@ -259,22 +283,21 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	ha->mcp = NULL;
 
 	if (!abort_active) {
-		DEBUG11(printk("qla2x00_mailbox_cmd: checking for additional "
-		    "resp interrupt.\n");)
+		DEBUG11(printk("%s(%ld): checking for additional resp "
+		    "interrupt.\n", __func__, ha->host_no);)
 
 		/* polling mode for non isp_abort commands. */
 		qla2x00_poll(ha);
 	}
 
-	if (rval == QLA_FUNCTION_TIMEOUT) {
+	if (rval == QLA_FUNCTION_TIMEOUT &&
+	    mcp->mb[0] != MBC_GEN_SYSTEM_ERROR) {
 		if (!io_lock_on || (mcp->flags & IOCTL_CMD)) {
 			/* not in dpc. schedule it for dpc to take over. */
-			DEBUG(printk("qla2x00_mailbox_command(%ld): timeout "
-			    "schedule isp_abort_needed.\n",
-			    ha->host_no);)
-			DEBUG2_3_11(printk("qla2x00_mailbox_command(%ld): "
-			    "timeout schedule isp_abort_needed.\n",
-			    ha->host_no);)
+			DEBUG(printk("%s(%ld): timeout schedule "
+			    "isp_abort_needed.\n", __func__, ha->host_no);)
+			DEBUG2_3_11(printk("%s(%ld): timeout schedule "
+			    "isp_abort_needed.\n", __func__, ha->host_no);)
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occured. Scheduling ISP "
 			    "abort.\n");
@@ -283,12 +306,11 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 				up(ha->dpc_wait);
 
 		} else if (!abort_active) {
-
 			/* call abort directly since we are in the DPC thread */
-			DEBUG(printk("qla2x00_mailbox_command(%ld): timeout "
-			    "calling abort_isp\n", ha->host_no);)
-			DEBUG2_3_11(printk("qla2x00_mailbox_command(%ld): "
-			    "timeout calling abort_isp\n", ha->host_no);)
+			DEBUG(printk("%s(%ld): timeout calling abort_isp\n",
+			    __func__, ha->host_no);)
+			DEBUG2_3_11(printk("%s(%ld): timeout calling "
+			    "abort_isp\n", __func__, ha->host_no);)
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occured. Issuing ISP "
 			    "abort.\n");
@@ -296,15 +318,14 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 			set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 			clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			if (qla2x00_abort_isp(ha)) {
-				/* failed. retry later. */
+				/* Failed. retry later. */
 				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			}
 			clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-
-			DEBUG(printk("qla2x00_mailbox_command: finished "
-			    "abort_isp\n");)
-			DEBUG2_3_11(printk("qla2x00_mailbox_command: finished "
-			    "abort_isp\n");)
+			DEBUG(printk("%s(%ld): finished abort_isp\n", __func__,
+			    ha->host_no);)
+			DEBUG2_3_11(printk("%s(%ld): finished abort_isp\n",
+			    __func__, ha->host_no);)
 		}
 	}
 
@@ -313,17 +334,13 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 		up(&ha->mbx_cmd_sem);
 
 	if (rval) {
-		DEBUG2_3_11(printk("qla2x00_mailbox_command(%ld): **** FAILED. "
-		    "mbx0=%x, mbx1=%x, mbx2=%x, cmd=%x ****\n",
-		ha->host_no, mcp->mb[0], mcp->mb[1], mcp->mb[2], command);)
+		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
+		    "mbx2=%x, cmd=%x ****\n", __func__, ha->host_no,
+		    mcp->mb[0], mcp->mb[1], mcp->mb[2], command);)
 	} else {
-		DEBUG11(printk("qla2x00_mailbox_command(%ld): done.\n",
-		    ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
 	}
 
-	DEBUG11(printk("qla2x00_mailbox_command(%ld): exiting.\n",
-	    ha->host_no);)
-
 	return rval;
 }
 
@@ -418,64 +435,40 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dm
  */
 int
 qla2x00_load_ram_ext(scsi_qla_host_t *ha, dma_addr_t req_dma,
-    uint32_t risc_addr, uint16_t risc_code_size)
+    uint32_t risc_addr, uint32_t risc_code_size)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	uint32_t	req_len;
-	dma_addr_t	nml_dma;
-	uint32_t	nml_len;
-	uint32_t	normalized;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	req_len = risc_code_size;
-	nml_dma = 0;
-	nml_len = 0;
-
-	normalized = qla2x00_normalize_dma_addr(&req_dma, &req_len, &nml_dma,
-	    &nml_len);
-
-	/* Load first segment */
 	mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
 	mcp->mb[1] = LSW(risc_addr);
 	mcp->mb[2] = MSW(req_dma);
 	mcp->mb[3] = LSW(req_dma);
-	mcp->mb[4] = (uint16_t)req_len;
 	mcp->mb[6] = MSW(MSD(req_dma));
 	mcp->mb[7] = LSW(MSD(req_dma));
 	mcp->mb[8] = MSW(risc_addr);
-	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->mb[4] = MSW(risc_code_size);
+		mcp->mb[5] = LSW(risc_code_size);
+		mcp->out_mb |= MBX_5|MBX_4;
+	} else {
+		mcp->mb[4] = LSW(risc_code_size);
+		mcp->out_mb |= MBX_4;
+	}
+
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
-	/* Load second segment - if necessary */
-	if (normalized && (rval == QLA_SUCCESS)) {
-		risc_addr += req_len;
-		mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
-		mcp->mb[1] = LSW(risc_addr);
-		mcp->mb[2] = MSW(nml_dma);
-		mcp->mb[3] = LSW(nml_dma);
-		mcp->mb[4] = (uint16_t)nml_len;
-		mcp->mb[6] = MSW(MSD(nml_dma));
-		mcp->mb[7] = LSW(MSD(nml_dma));
-		mcp->mb[8] = MSW(risc_addr);
-		mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-		mcp->in_mb = MBX_0;
-		mcp->tov = 30;
-		mcp->flags = 0;
-		rval = qla2x00_mailbox_command(ha, mcp);
-	}
-
 	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0]));
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
+		    ha->host_no, rval, mcp->mb[0]));
 	} else {
-		/*EMPTY*/
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
@@ -484,42 +477,62 @@ qla2x00_load_ram_ext(scsi_qla_host_t *ha
 
 /*
  * qla2x00_execute_fw
- *	Start adapter firmware.
+ *     Start adapter firmware.
  *
  * Input:
- *	ha = adapter block pointer.
- *	TARGET_QUEUE_LOCK must be released.
- *	ADAPTER_STATE_LOCK must be released.
+ *     ha = adapter block pointer.
+ *     TARGET_QUEUE_LOCK must be released.
+ *     ADAPTER_STATE_LOCK must be released.
  *
  * Returns:
- *	qla2x00 local function return status code.
+ *     qla2x00 local function return status code.
  *
  * Context:
- *	Kernel context.
+ *     Kernel context.
  */
 int
-qla2x00_execute_fw(scsi_qla_host_t *ha)
+qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_execute_fw(%ld): entered.\n", ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
 
 	mcp->mb[0] = MBC_EXECUTE_FIRMWARE;
-	mcp->mb[1] = *ha->brd_info->fw_info[0].fwstart;
-	mcp->out_mb = MBX_1|MBX_0;
-	if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
-		mcp->mb[2] = 0;
-		mcp->out_mb |= MBX_2;
+	mcp->out_mb = MBX_0;
+	mcp->in_mb = MBX_0;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->mb[1] = MSW(risc_addr);
+		mcp->mb[2] = LSW(risc_addr);
+		mcp->mb[3] = 0;
+		mcp->out_mb |= MBX_3|MBX_2|MBX_1;
+		mcp->in_mb |= MBX_1;
+	} else {
+		mcp->mb[1] = LSW(risc_addr);
+		mcp->out_mb |= MBX_1;
+		if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
+			mcp->mb[2] = 0;
+			mcp->out_mb |= MBX_2;
+		}
 	}
 
-	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
-	DEBUG11(printk("qla2x00_execute_fw(%ld): done.\n", ha->host_no);)
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
+		    ha->host_no, rval, mcp->mb[0]));
+	} else {
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+			DEBUG11(printk("%s(%ld): done exchanges=%x.\n",
+			    __func__, ha->host_no, mcp->mb[1]);)
+		} else {
+			DEBUG11(printk("%s(%ld): done.\n", __func__,
+			    ha->host_no);)
+		}
+	}
 
 	return rval;
 }
@@ -612,6 +625,7 @@ qla2x00_get_fw_options(scsi_qla_host_t *
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
 		    ha->host_no, rval));
 	} else {
+		fwopts[0] = mcp->mb[0];
 		fwopts[1] = mcp->mb[1];
 		fwopts[2] = mcp->mb[2];
 		fwopts[3] = mcp->mb[3];
@@ -650,19 +664,26 @@ qla2x00_set_fw_options(scsi_qla_host_t *
 	mcp->mb[1] = fwopts[1];
 	mcp->mb[2] = fwopts[2];
 	mcp->mb[3] = fwopts[3];
-	mcp->mb[10] = fwopts[10];
-	mcp->mb[11] = fwopts[11];
-	mcp->mb[12] = 0;	/* Undocumented, but used */
-	mcp->out_mb = MBX_12|MBX_11|MBX_10|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->in_mb |= MBX_1;
+	} else {
+		mcp->mb[10] = fwopts[10];
+		mcp->mb[11] = fwopts[11];
+		mcp->mb[12] = 0;	/* Undocumented, but used */
+		mcp->out_mb |= MBX_12|MBX_11|MBX_10;
+	}
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
+	fwopts[0] = mcp->mb[0];
+
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x/%x).\n", __func__,
+		    ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
@@ -747,31 +768,38 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha
  *	Kernel context.
  */
 int
-qla2x00_verify_checksum(scsi_qla_host_t *ha)
+qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_verify_checksum(%ld): entered.\n",
-	    ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
 
 	mcp->mb[0] = MBC_VERIFY_CHECKSUM;
-	mcp->mb[1] = *ha->brd_info->fw_info[0].fwstart;
-	mcp->out_mb = MBX_1|MBX_0;
-	mcp->in_mb = MBX_2|MBX_0;
+	mcp->out_mb = MBX_0;
+	mcp->in_mb = MBX_0;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->mb[1] = MSW(risc_addr);
+		mcp->mb[2] = LSW(risc_addr);
+		mcp->out_mb |= MBX_2|MBX_1;
+		mcp->in_mb |= MBX_2|MBX_1;
+	} else {
+		mcp->mb[1] = LSW(risc_addr);
+		mcp->out_mb |= MBX_1;
+		mcp->in_mb |= MBX_1;
+	}
+
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_verify_checksum(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		DEBUG2_3_11(printk("%s(%ld): failed=%x chk sum=%x.\n", __func__,
+		    ha->host_no, rval, (IS_QLA24XX(ha) || IS_QLA25XX(ha) ?
+		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1]));)
 	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla2x00_verify_checksum(%ld): done.\n",
-		    ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
 	}
 
 	return rval;
@@ -817,12 +845,18 @@ qla2x00_issue_iocb(scsi_qla_host_t *ha, 
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x",
+		DEBUG(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
 		    ha->host_no,rval);)
-		DEBUG2(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x",
+		DEBUG2(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
 		    ha->host_no,rval);)
 	} else {
-		/*EMPTY*/
+		sts_entry_t *sts_entry = (sts_entry_t *) buffer;
+
+		/* Mask reserved bits. */
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			sts_entry->entry_status &= RF_MASK_24XX;
+		else
+			sts_entry->entry_status &= RF_MASK;
 	}
 
 	return rval;
@@ -852,6 +886,9 @@ qla2x00_abort_command(scsi_qla_host_t *h
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		return qla24xx_abort_command(ha, sp);
+
 	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no);)
 
 	fcport = sp->fcport;
@@ -918,41 +955,44 @@ qla2x00_abort_target(fc_port_t *fcport)
 	int        rval;
 	mbx_cmd_t  mc;
 	mbx_cmd_t  *mcp = &mc;
+	scsi_qla_host_t *ha;
 
-	DEBUG11(printk("qla2x00_abort_target(%ld): entered.\n",
-	    fcport->ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no);)
 
 	if (fcport == NULL) {
 		/* no target to abort */
 		return 0;
 	}
+	ha = fcport->ha;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		return qla24xx_abort_target(ha, fcport);
 
 	mcp->mb[0] = MBC_ABORT_TARGET;
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(fcport->ha)) {
+	if (HAS_EXTENDED_IDS(ha)) {
 		mcp->mb[1] = fcport->loop_id;
 		mcp->mb[10] = 0;
 		mcp->out_mb |= MBX_10;
 	} else {
 		mcp->mb[1] = fcport->loop_id << 8;
 	}
-	mcp->mb[2] = fcport->ha->loop_reset_delay;
+	mcp->mb[2] = ha->loop_reset_delay;
 
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(fcport->ha, mcp);
+	rval = qla2x00_mailbox_command(ha, mcp);
 
 	/* Issue marker command. */
-	fcport->ha->marker_needed = 1;
+	ha->marker_needed = 1;
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("qla2x00_abort_target(%ld): failed=%x.\n",
-		    fcport->ha->host_no, rval);)
+		    ha->host_no, rval);)
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_abort_target(%ld): done.\n",
-		    fcport->ha->host_no);)
+		    ha->host_no);)
 	}
 
 	return rval;
@@ -1202,82 +1242,117 @@ qla2x00_get_port_database(scsi_qla_host_
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	port_database_t *pd;
+	struct port_database_24xx *pd24;
 	dma_addr_t pd_dma;
 
-	DEBUG11(printk("qla2x00_get_port_database(%ld): entered.\n",
-	    ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
 
-	pd = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &pd_dma);
+	pd24 = NULL;
+	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
 	if (pd  == NULL) {
-		DEBUG2_3_11(printk("qla2x00_get_port_database(%ld): **** "
-		    "Mem Alloc Failed ****", ha->host_no);)
+		DEBUG2_3(printk("%s(%ld): failed to allocate Port Database "
+		    "structure.\n", __func__, ha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
-	memset(pd, 0, PORT_DATABASE_SIZE);
+	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
 
-	if (opt != 0)
+	mcp->mb[0] = MBC_GET_PORT_DATABASE;
+	if (opt != 0 && !IS_QLA24XX(ha) && !IS_QLA25XX(ha))
 		mcp->mb[0] = MBC_ENHANCED_GET_PORT_DATABASE;
-	else
-		mcp->mb[0] = MBC_GET_PORT_DATABASE;
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
-		mcp->mb[1] = fcport->loop_id;
-		mcp->mb[10] = opt;
-		mcp->out_mb |= MBX_10;
-	} else {
-		mcp->mb[1] = fcport->loop_id << 8 | opt;
-	}
 	mcp->mb[2] = MSW(pd_dma);
 	mcp->mb[3] = LSW(pd_dma);
 	mcp->mb[6] = MSW(MSD(pd_dma));
 	mcp->mb[7] = LSW(MSD(pd_dma));
-
+	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
-	mcp->buf_size = PORT_DATABASE_SIZE;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->mb[1] = fcport->loop_id;
+		mcp->mb[10] = opt;
+		mcp->out_mb |= MBX_10|MBX_1;
+		mcp->in_mb |= MBX_1;
+	} else if (HAS_EXTENDED_IDS(ha)) {
+		mcp->mb[1] = fcport->loop_id;
+		mcp->mb[10] = opt;
+		mcp->out_mb |= MBX_10|MBX_1;
+	} else {
+		mcp->mb[1] = fcport->loop_id << 8 | opt;
+		mcp->out_mb |= MBX_1;
+	}
+	mcp->buf_size = (IS_QLA24XX(ha) || IS_QLA25XX(ha) ?
+	    PORT_DATABASE_24XX_SIZE : PORT_DATABASE_SIZE);
 	mcp->flags = MBX_DMA_IN;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS)
 		goto gpd_error_out;
 
-	/* Check for logged in state. */
-	if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
-	    pd->slave_state != PD_STATE_PORT_LOGGED_IN) {
-		rval = QLA_FUNCTION_FAILED;
-		goto gpd_error_out;
-	}
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		pd24 = (struct port_database_24xx *) pd;
 
-	/* Names are little-endian. */
-	memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
-	memcpy(fcport->port_name, pd->port_name, WWN_SIZE);
-
-	/* Get port_id of device. */
-	fcport->d_id.b.al_pa = pd->port_id[2];
-	fcport->d_id.b.area = pd->port_id[3];
-	fcport->d_id.b.domain = pd->port_id[0];
-	fcport->d_id.b.rsvd_1 = 0;
-
-	/* Check for device require authentication. */
-	pd->common_features & BIT_5 ? (fcport->flags |= FCF_AUTH_REQ) :
-	    (fcport->flags &= ~FCF_AUTH_REQ);
-
-	/* If not target must be initiator or unknown type. */
-	if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
-		fcport->port_type = FCT_INITIATOR;
-	else
-		fcport->port_type = FCT_TARGET;
+		/* Check for logged in state. */
+		if (pd24->current_login_state != PDS_PRLI_COMPLETE &&
+		    pd24->last_login_state != PDS_PRLI_COMPLETE) {
+			DEBUG2(printk("%s(%ld): Unable to verify "
+			    "login-state (%x/%x) for loop_id %x\n",
+			    __func__, ha->host_no,
+			    pd24->current_login_state,
+			    pd24->last_login_state, fcport->loop_id));
+			rval = QLA_FUNCTION_FAILED;
+			goto gpd_error_out;
+		}
+
+		/* Names are little-endian. */
+		memcpy(fcport->node_name, pd24->node_name, WWN_SIZE);
+		memcpy(fcport->port_name, pd24->port_name, WWN_SIZE);
+
+		/* Get port_id of device. */
+		fcport->d_id.b.domain = pd24->port_id[0];
+		fcport->d_id.b.area = pd24->port_id[1];
+		fcport->d_id.b.al_pa = pd24->port_id[2];
+		fcport->d_id.b.rsvd_1 = 0;
+
+		/* If not target must be initiator or unknown type. */
+		if ((pd24->prli_svc_param_word_3[0] & BIT_4) == 0)
+			fcport->port_type = FCT_INITIATOR;
+		else
+			fcport->port_type = FCT_TARGET;
+	} else {
+		/* Check for logged in state. */
+		if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
+		    pd->slave_state != PD_STATE_PORT_LOGGED_IN) {
+			rval = QLA_FUNCTION_FAILED;
+			goto gpd_error_out;
+		}
+
+		/* Names are little-endian. */
+		memcpy(fcport->node_name, pd->node_name, WWN_SIZE);
+		memcpy(fcport->port_name, pd->port_name, WWN_SIZE);
+
+		/* Get port_id of device. */
+		fcport->d_id.b.domain = pd->port_id[0];
+		fcport->d_id.b.area = pd->port_id[3];
+		fcport->d_id.b.al_pa = pd->port_id[2];
+		fcport->d_id.b.rsvd_1 = 0;
+
+		/* Check for device require authentication. */
+		pd->common_features & BIT_5 ? (fcport->flags |= FCF_AUTH_REQ) :
+		    (fcport->flags &= ~FCF_AUTH_REQ);
+
+		/* If not target must be initiator or unknown type. */
+		if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
+			fcport->port_type = FCT_INITIATOR;
+		else
+			fcport->port_type = FCT_TARGET;
+	}
 
 gpd_error_out:
 	dma_pool_free(ha->s_dma_pool, pd, pd_dma);
 
 	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_get_port_database(%ld): "
-		    "failed=%x.\n", ha->host_no, rval);)
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
+		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		/*EMPTY*/
-		DEBUG11(printk("qla2x00_get_port_database(%ld): done.\n",
-		    ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	return rval;
@@ -1422,21 +1497,27 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_lip_reset(%ld): entered.\n",
-	    ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
 
-	mcp->mb[0] = MBC_LIP_RESET;
-	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
-		mcp->mb[1] = 0x00ff;
-		mcp->mb[10] = 0;
-		mcp->out_mb |= MBX_10;
-	} else {
-		mcp->mb[1] = 0xff00;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
+		mcp->mb[1] = BIT_0;
+		mcp->mb[2] = 0xff;
+		mcp->mb[3] = 0;
+		mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
+	} else {
+		mcp->mb[0] = MBC_LIP_RESET;
+		mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
+		if (HAS_EXTENDED_IDS(ha)) {
+			mcp->mb[1] = 0x00ff;
+			mcp->mb[10] = 0;
+			mcp->out_mb |= MBX_10;
+		} else {
+			mcp->mb[1] = 0xff00;
+		}
+		mcp->mb[2] = ha->loop_reset_delay;
+		mcp->mb[3] = 0;
 	}
-	mcp->mb[2] = ha->loop_reset_delay;
-	mcp->mb[3] = 0;
-
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
@@ -1444,11 +1525,11 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_lip_reset(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n",
+		    __func__, ha->host_no, rval);)
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_lip_reset(%ld): done.\n", ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
 	}
 
 	return rval;
@@ -1513,6 +1594,97 @@ qla2x00_send_sns(scsi_qla_host_t *ha, dm
 	return rval;
 }
 
+int
+qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+    uint8_t area, uint8_t al_pa, uint16_t *mb, uint8_t opt)
+{
+	int		rval;
+
+	struct logio_entry_24xx *lg;
+	dma_addr_t	lg_dma;
+	uint32_t	iop[2];
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+
+	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
+	if (lg == NULL) {
+		DEBUG2_3(printk("%s(%ld): failed to allocate Login IOCB.\n",
+		    __func__, ha->host_no));
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+	memset(lg, 0, sizeof(struct logio_entry_24xx));
+
+	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	lg->entry_count = 1;
+	lg->nport_handle = cpu_to_le16(loop_id);
+	lg->control_flags = __constant_cpu_to_le16(LCF_COMMAND_PLOGI);
+	if (opt & BIT_0)
+		lg->control_flags |= __constant_cpu_to_le16(LCF_COND_PLOGI);
+	lg->port_id[0] = al_pa;
+	lg->port_id[1] = area;
+	lg->port_id[2] = domain;
+	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue Login IOCB "
+		    "(%x).\n", __func__, ha->host_no, rval);)
+	} else if (lg->entry_status != 0) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- error status (%x).\n", __func__, ha->host_no,
+		    lg->entry_status));
+		rval = QLA_FUNCTION_FAILED;
+	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+		iop[0] = le32_to_cpu(lg->io_parameter[0]);
+		iop[1] = le32_to_cpu(lg->io_parameter[1]);
+
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
+		    ha->host_no, le16_to_cpu(lg->comp_status), iop[0],
+		    iop[1]));
+
+		switch (iop[0]) {
+		case LSC_SCODE_PORTID_USED:
+			mb[0] = MBS_PORT_ID_USED;
+			mb[1] = LSW(iop[1]);
+			break;
+		case LSC_SCODE_NPORT_USED:
+			mb[0] = MBS_LOOP_ID_USED;
+			break;
+		case LSC_SCODE_NOLINK:
+		case LSC_SCODE_NOIOCB:
+		case LSC_SCODE_NOXCB:
+		case LSC_SCODE_CMD_FAILED:
+		case LSC_SCODE_NOFABRIC:
+		case LSC_SCODE_FW_NOT_READY:
+		case LSC_SCODE_NOT_LOGGED_IN:
+		case LSC_SCODE_NOPCB:
+		case LSC_SCODE_ELS_REJECT:
+		case LSC_SCODE_CMD_PARAM_ERR:
+		case LSC_SCODE_NONPORT:
+		case LSC_SCODE_LOGGED_IN:
+		case LSC_SCODE_NOFLOGI_ACC:
+		default:
+			mb[0] = MBS_COMMAND_ERROR;
+			break;
+		}
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+
+		iop[0] = le32_to_cpu(lg->io_parameter[0]);
+
+		mb[0] = MBS_COMMAND_COMPLETE;
+		mb[1] = 0;
+		if (iop[0] & BIT_4) {
+			if (iop[0] & BIT_8)
+				mb[1] |= BIT_1;
+		} else
+			mb[1] = BIT_0;
+	}
+
+	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
+
+	return rval;
+}
+
 /*
  * qla2x00_login_fabric
  *	Issue login fabric port mailbox command.
@@ -1542,6 +1714,10 @@ qla2x00_login_fabric(scsi_qla_host_t *ha
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		return qla24xx_login_fabric(ha, loop_id, domain, area, al_pa,
+		    mb, opt);
+
 	DEBUG11(printk("qla2x00_login_fabric(%ld): entered.\n", ha->host_no);)
 
 	mcp->mb[0] = MBC_LOGIN_FABRIC_PORT;
@@ -1665,6 +1841,57 @@ qla2x00_login_local_device(scsi_qla_host
 	return (rval);
 }
 
+int
+qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+    uint8_t area, uint8_t al_pa)
+{
+	int		rval;
+	struct logio_entry_24xx *lg;
+	dma_addr_t	lg_dma;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+
+	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
+	if (lg == NULL) {
+		DEBUG2_3(printk("%s(%ld): failed to allocate Logout IOCB.\n",
+		    __func__, ha->host_no));
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+	memset(lg, 0, sizeof(struct logio_entry_24xx));
+
+	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	lg->entry_count = 1;
+	lg->nport_handle = cpu_to_le16(loop_id);
+	lg->control_flags =
+	    __constant_cpu_to_le16(LCF_COMMAND_LOGO|LCF_EXPL_LOGO);
+	lg->port_id[0] = al_pa;
+	lg->port_id[1] = area;
+	lg->port_id[2] = domain;
+	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue Logout IOCB "
+		    "(%x).\n", __func__, ha->host_no, rval);)
+	} else if (lg->entry_status != 0) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- error status (%x).\n", __func__, ha->host_no,
+		    lg->entry_status));
+		rval = QLA_FUNCTION_FAILED;
+	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
+		    ha->host_no, le16_to_cpu(lg->comp_status),
+		    le32_to_cpu(lg->io_parameter[0]),
+		    le32_to_cpu(lg->io_parameter[1]));)
+	} else {
+		/*EMPTY*/
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+	}
+
+	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
+
+	return rval;
+}
+
 /*
  * qla2x00_fabric_logout
  *	Issue logout fabric port mailbox command.
@@ -1682,12 +1909,16 @@ qla2x00_login_local_device(scsi_qla_host
  *	Kernel context.
  */
 int
-qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id)
+qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+    uint8_t area, uint8_t al_pa)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		return qla24xx_fabric_logout(ha, loop_id, domain, area, al_pa);
+
 	DEBUG11(printk("qla2x00_fabric_logout(%ld): entered.\n",
 	    ha->host_no);)
 
@@ -1746,7 +1977,7 @@ qla2x00_full_login_lip(scsi_qla_host_t *
 
 	mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 	mcp->mb[1] = 0;
-	mcp->mb[2] = 0;
+	mcp->mb[2] = 0xff;
 	mcp->mb[3] = 0;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
@@ -1757,7 +1988,7 @@ qla2x00_full_login_lip(scsi_qla_host_t *
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_full_login_lip(%ld): failed=%x.\n",
-		    ha->instance, rval);)
+		    ha->host_no, rval);)
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_full_login_lip(%ld): done.\n",
@@ -1794,11 +2025,20 @@ qla2x00_get_id_list(scsi_qla_host_t *ha,
 		return QLA_FUNCTION_FAILED;
 
 	mcp->mb[0] = MBC_GET_ID_LIST;
-	mcp->mb[1] = MSW(id_list_dma);
-	mcp->mb[2] = LSW(id_list_dma);
-	mcp->mb[3] = MSW(MSD(id_list_dma));
-	mcp->mb[6] = LSW(MSD(id_list_dma));
-	mcp->out_mb = MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->out_mb = MBX_0;
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->mb[2] = MSW(id_list_dma);
+		mcp->mb[3] = LSW(id_list_dma);
+		mcp->mb[6] = MSW(MSD(id_list_dma));
+		mcp->mb[7] = LSW(MSD(id_list_dma));
+		mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2;
+	} else {
+		mcp->mb[1] = MSW(id_list_dma);
+		mcp->mb[2] = LSW(id_list_dma);
+		mcp->mb[3] = MSW(MSD(id_list_dma));
+		mcp->mb[6] = LSW(MSD(id_list_dma));
+		mcp->out_mb |= MBX_6|MBX_3|MBX_2|MBX_1;
+	}
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
@@ -1934,4 +2174,334 @@ qla2x00_get_fcal_position_map(scsi_qla_h
 
 	return rval;
 }
+
+uint8_t
+qla24xx_get_isp_stats(scsi_qla_host_t *ha, uint32_t *dwbuf, uint32_t dwords,
+    uint16_t *status)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	uint32_t *sbuf, *siter;
+	dma_addr_t sbuf_dma;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+
+	if (dwords > (DMA_POOL_SIZE / 4)) {
+		DEBUG2_3_11(printk("%s(%ld): Unabled to retrieve %d DWORDs "
+		    "(max %d).\n", __func__, ha->host_no, dwords,
+		    DMA_POOL_SIZE / 4));
+		return BIT_0;
+	}
+	sbuf = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &sbuf_dma);
+	if (sbuf == NULL) {
+		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
+		    __func__, ha->host_no));
+		return BIT_0;
+	}
+	memset(sbuf, 0, DMA_POOL_SIZE);
+
+	mcp->mb[0] = MBC_GET_LINK_PRIV_STATS;
+	mcp->mb[2] = MSW(sbuf_dma);
+	mcp->mb[3] = LSW(sbuf_dma);
+	mcp->mb[6] = MSW(MSD(sbuf_dma));
+	mcp->mb[7] = LSW(MSD(sbuf_dma));
+	mcp->mb[8] = dwords;
+	mcp->mb[10] = 0;
+	mcp->out_mb = MBX_10|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
+	mcp->in_mb = MBX_2|MBX_1|MBX_0;
+	mcp->tov = 30;
+	mcp->flags = IOCTL_CMD;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	if (rval == QLA_SUCCESS) {
+		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
+			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
+			    __func__, ha->host_no, mcp->mb[0]));
+			status[0] = mcp->mb[0];
+			rval = BIT_1;
+		} else {
+			/* Copy over data -- firmware data is LE. */
+			siter = sbuf;
+			while (dwords--)
+				*dwbuf++ = le32_to_cpu(*siter++);
+		}
+	} else {
+		/* Failed. */
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
+		    ha->host_no, rval));
+		rval = BIT_1;
+	}
+
+	dma_pool_free(ha->s_dma_pool, sbuf, sbuf_dma);
+
+	return rval;
+}
 #endif
+
+// Issue MAILBOX command 0x02 (Execute FW) -- ISP agnostic
+//
+
+// Alternative to MAILBOX command 0x15 (Abort IOCB Command)
+//
+
+int
+qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
+{
+	int		rval;
+	fc_port_t	*fcport;
+	unsigned long   flags = 0;
+
+	struct abort_entry_24xx *abt;
+	dma_addr_t	abt_dma;
+	uint32_t	handle;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+
+	fcport = sp->fcport;
+	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
+	    atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
+		return QLA_FUNCTION_FAILED;
+	}
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
+		if (ha->outstanding_cmds[handle] == sp)
+			break;
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (handle == MAX_OUTSTANDING_COMMANDS) {
+		/* Command not found. */
+		return QLA_FUNCTION_FAILED;
+	}
+
+	abt = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
+	if (abt == NULL) {
+		DEBUG2_3(printk("%s(%ld): failed to allocate Abort IOCB.\n",
+		    __func__, ha->host_no));
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+	memset(abt, 0, sizeof(struct abort_entry_24xx));
+
+	abt->entry_type = ABORT_IOCB_TYPE;
+	abt->entry_count = 1;
+	abt->nport_handle = cpu_to_le16(fcport->loop_id);
+	abt->handle_to_abort = handle;
+	abt->port_id[0] = fcport->d_id.b.al_pa;
+	abt->port_id[1] = fcport->d_id.b.area;
+	abt->port_id[2] = fcport->d_id.b.domain;
+	rval = qla2x00_issue_iocb(ha, abt, abt_dma, 0);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue IOCB (%x).\n",
+		    __func__, ha->host_no, rval);)
+	} else if (abt->entry_status != 0) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- error status (%x).\n", __func__, ha->host_no,
+		    abt->entry_status));
+		rval = QLA_FUNCTION_FAILED;
+	} else if (abt->nport_handle != __constant_cpu_to_le16(0)) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- completion status (%x).\n", __func__, ha->host_no,
+		    le16_to_cpu(abt->nport_handle));)
+		rval = QLA_FUNCTION_FAILED;
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		sp->flags |= SRB_ABORT_PENDING;
+	}
+
+	dma_pool_free(ha->s_dma_pool, abt, abt_dma);
+
+	return rval;
+}
+
+// NOTE: The driver does not issue an ABORT DEVICE mailbox command
+
+struct tsk_mgmt_cmd {
+	union {
+		struct tsk_mgmt_entry tsk;
+		struct sts_entry_24xx sts;
+	} p;
+};
+
+// NOTE: The following function handles mailbox command 0x17 and 0x66
+int
+qla24xx_abort_target(scsi_qla_host_t *ha, fc_port_t *fcport)
+{
+	int		rval;
+
+	struct tsk_mgmt_cmd *tsk;
+	dma_addr_t	tsk_dma;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+
+	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
+	if (tsk == NULL) {
+		DEBUG2_3(printk("%s(%ld): failed to allocate Task Management "
+		    "IOCB.\n", __func__, ha->host_no));
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+	memset(tsk, 0, sizeof(struct tsk_mgmt_cmd));
+
+	tsk->p.tsk.entry_type = TSK_MGMT_IOCB_TYPE;
+	tsk->p.tsk.entry_count = 1;
+	tsk->p.tsk.nport_handle = cpu_to_le16(fcport->loop_id);
+	tsk->p.tsk.timeout = __constant_cpu_to_le16(25);
+	tsk->p.tsk.control_flags = __constant_cpu_to_le32(TCF_TARGET_RESET);
+	tsk->p.tsk.port_id[0] = fcport->d_id.b.al_pa;
+	tsk->p.tsk.port_id[1] = fcport->d_id.b.area;
+	tsk->p.tsk.port_id[2] = fcport->d_id.b.domain;
+	rval = qla2x00_issue_iocb(ha, tsk, tsk_dma, 0);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue Target Reset IOCB "
+		    "(%x).\n", __func__, ha->host_no, rval);)
+		goto atarget_done;
+	} else if (tsk->p.sts.entry_status != 0) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- error status (%x).\n", __func__, ha->host_no,
+		    tsk->p.sts.entry_status));
+		rval = QLA_FUNCTION_FAILED;
+		goto atarget_done;
+	} else if (tsk->p.sts.comp_status !=
+	    __constant_cpu_to_le16(CS_COMPLETE)) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- completion status (%x).\n", __func__,
+		    ha->host_no, le16_to_cpu(tsk->p.sts.comp_status));)
+		rval = QLA_FUNCTION_FAILED;
+		goto atarget_done;
+	}
+
+	/* Issue marker IOCB. */
+	rval = qla2x00_marker(ha, fcport->loop_id, 0, MK_SYNC_ID);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
+		    "(%x).\n", __func__, ha->host_no, rval);)
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+	}
+
+atarget_done:
+	dma_pool_free(ha->s_dma_pool, tsk, tsk_dma);
+
+	return rval;
+}
+
+int
+qla2x00_system_error(scsi_qla_host_t *ha)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_GEN_SYSTEM_ERROR;
+	mcp->out_mb = MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 5;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
+		    ha->host_no, rval));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
+
+//UNKNOWNs
+
+// MAILBOX command 0x22 (Get Retry Counts)
+//	Mailbox 1 no longer populated with 'Retry Count'
+//
+// MAILBOX command 0x69 (Get Firmware State)
+//	Firmware state 1 (Waiting for Link) previously wait for AL_PA
+//	Firmware state 5 (Error) is missing
+//	Firmware state 6 (ReInit) is missing
+//
+
+/**
+ * qla2x00_get_serdes_params() -
+ * @ha: HA context
+ *
+ * Returns
+ */
+int
+qla2x00_get_serdes_params(scsi_qla_host_t *ha, uint16_t *sw_em_1g,
+    uint16_t *sw_em_2g, uint16_t *sw_em_4g)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_SERDES_PARAMS;
+	mcp->mb[1] = 0;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_4|MBX_3|MBX_2|MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		/*EMPTY*/
+		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
+		    ha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+
+		if (sw_em_1g)
+			*sw_em_1g = mcp->mb[2];
+		if (sw_em_2g)
+			*sw_em_2g = mcp->mb[3];
+		if (sw_em_4g)
+			*sw_em_4g = mcp->mb[4];
+	}
+
+	return rval;
+}
+
+/**
+ * qla2x00_set_serdes_params() -
+ * @ha: HA context
+ *
+ * Returns
+ */
+int
+qla2x00_set_serdes_params(scsi_qla_host_t *ha, uint16_t sw_em_1g,
+    uint16_t sw_em_2g, uint16_t sw_em_4g)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_SERDES_PARAMS;
+	mcp->mb[1] = BIT_0;
+	mcp->mb[2] = sw_em_1g;
+	mcp->mb[3] = sw_em_2g;
+	mcp->mb[4] = sw_em_4g;
+	mcp->out_mb = MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		/*EMPTY*/
+		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
+		    ha->host_no, rval, mcp->mb[0]));
+	} else {
+		/*EMPTY*/
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
------------

-- 
Andrew Vasquez
