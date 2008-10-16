From: Anirban Chakraborty <anirban@qlogic.com>
Subject: [PATCH 4/5] qla2xxx: Code Refactoring
Date: Wed, 15 Oct 2008 22:47:13 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0810152233510.24642@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:41949 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYJPF7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 01:59:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |  759 +++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_mid.c |  173 ++++------
 2 files changed, 462 insertions(+), 470 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 36bc685..f65b629 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -29,7 +29,7 @@
  *	Kernel context.
  */
 static int
-qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
+qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 {
 	int		rval;
 	unsigned long    flags = 0;
@@ -42,15 +42,16 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	uint32_t	cnt;
 	uint32_t	mboxes;
 	unsigned long	wait_time;
-	scsi_qla_host_t *ha = to_qla_parent(pvha);
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	reg = ha->iobase;
-	io_lock_on = ha->flags.init_done;
+	io_lock_on = base_vha->flags.init_done;
 
 	rval = QLA_SUCCESS;
-	abort_active = test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+	abort_active = test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, pvha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, base_vha->host_no));
 
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most tov
@@ -62,7 +63,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		    mcp->tov * HZ)) {
 			/* Timeout occurred. Return error. */
 			DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
-			    "Exiting.\n", __func__, ha->host_no));
+			    "Exiting.\n", __func__, base_vha->host_no));
 			return QLA_FUNCTION_TIMEOUT;
 		}
 	}
@@ -72,7 +73,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	ha->mcp = mcp;
 
 	DEBUG11(printk("scsi(%ld): prepare to issue mbox cmd=0x%x.\n",
-	    ha->host_no, mcp->mb[0]));
+	    base_vha->host_no, mcp->mb[0]));
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -100,15 +101,16 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 #if defined(QL_DEBUG_LEVEL_1)
 	printk("%s(%ld): Loaded MBX registers (displayed in bytes) = \n",
-	    __func__, ha->host_no);
+	    __func__, base_vha->host_no);
 	qla2x00_dump_buffer((uint8_t *)mcp->mb, 16);
 	printk("\n");
 	qla2x00_dump_buffer(((uint8_t *)mcp->mb + 0x10), 16);
 	printk("\n");
 	qla2x00_dump_buffer(((uint8_t *)mcp->mb + 0x20), 8);
 	printk("\n");
-	printk("%s(%ld): I/O address = %p.\n", __func__, ha->host_no, optr);
-	qla2x00_dump_regs(ha);
+	printk("%s(%ld): I/O address = %p.\n", __func__, base_vha->host_no,
+		optr);
+	qla2x00_dump_regs(base_vha);
 #endif
 
 	/* Issue set host interrupt command to send cmd out. */
@@ -117,7 +119,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	/* Unlock mbx registers and wait for interrupt */
 	DEBUG11(printk("%s(%ld): going to unlock irq & waiting for interrupt. "
-	    "jiffies=%lx.\n", __func__, ha->host_no, jiffies));
+	    "jiffies=%lx.\n", __func__, base_vha->host_no, jiffies));
 
 	/* Wait for mbx cmd completion until timeout */
 
@@ -137,7 +139,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	} else {
 		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
-		    ha->host_no, command));
+		    base_vha->host_no, command));
 
 		if (IS_FWI2_CAPABLE(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
@@ -151,7 +153,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 				break;
 
 			/* Check for pending interrupts. */
-			qla2x00_poll(ha);
+			qla2x00_poll(ha->rsp);
 
 			if (command != MBC_LOAD_RISC_RAM_EXTENDED &&
 			    !ha->flags.mbox_int)
@@ -164,7 +166,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		uint16_t *iptr2;
 
 		DEBUG3_11(printk("%s(%ld): cmd %x completed.\n", __func__,
-		    ha->host_no, command));
+		    base_vha->host_no, command));
 
 		/* Got interrupt. Clear the flag. */
 		ha->flags.mbox_int = 0;
@@ -200,12 +202,12 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 			ictrl = RD_REG_WORD(&reg->isp.ictrl);
 		}
 		printk("%s(%ld): **** MB Command Timeout for cmd %x ****\n",
-		    __func__, ha->host_no, command);
+		    __func__, base_vha->host_no, command);
 		printk("%s(%ld): icontrol=%x jiffies=%lx\n", __func__,
-		    ha->host_no, ictrl, jiffies);
+		    base_vha->host_no, ictrl, jiffies);
 		printk("%s(%ld): *** mailbox[0] = 0x%x ***\n", __func__,
-		    ha->host_no, mb0);
-		qla2x00_dump_regs(ha);
+		    base_vha->host_no, mb0);
+		qla2x00_dump_regs(base_vha);
 #endif
 
 		rval = QLA_FUNCTION_TIMEOUT;
@@ -218,10 +220,10 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	if (abort_active || !io_lock_on) {
 		DEBUG11(printk("%s(%ld): checking for additional resp "
-		    "interrupt.\n", __func__, ha->host_no));
+		    "interrupt.\n", __func__, base_vha->host_no));
 
 		/* polling mode for non isp_abort commands. */
-		qla2x00_poll(ha);
+		qla2x00_poll(ha->rsp);
 	}
 
 	if (rval == QLA_FUNCTION_TIMEOUT &&
@@ -229,35 +231,37 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		if (!io_lock_on || (mcp->flags & IOCTL_CMD)) {
 			/* not in dpc. schedule it for dpc to take over. */
 			DEBUG(printk("%s(%ld): timeout schedule "
-			    "isp_abort_needed.\n", __func__, ha->host_no));
+			"isp_abort_needed.\n", __func__,
+			base_vha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): timeout schedule "
-			    "isp_abort_needed.\n", __func__, ha->host_no));
+			"isp_abort_needed.\n", __func__,
+			base_vha->host_no));
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occurred. Scheduling ISP "
 			    "abort.\n");
-			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-			qla2xxx_wake_dpc(ha);
+			set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
 		} else if (!abort_active) {
 			/* call abort directly since we are in the DPC thread */
 			DEBUG(printk("%s(%ld): timeout calling abort_isp\n",
-			    __func__, ha->host_no));
+			    __func__, base_vha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): timeout calling "
-			    "abort_isp\n", __func__, ha->host_no));
+			    "abort_isp\n", __func__, base_vha->host_no));
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occurred. Issuing ISP "
 			    "abort.\n");
 
-			set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-			clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-			if (qla2x00_abort_isp(ha)) {
+			set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+			clear_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
+			if (qla2x00_abort_isp(base_vha)) {
 				/* Failed. retry later. */
-				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+				set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 			}
-			clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+			clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 			DEBUG(printk("%s(%ld): finished abort_isp\n", __func__,
-			    ha->host_no));
+			    base_vha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): finished abort_isp\n",
-			    __func__, ha->host_no));
+			    __func__, base_vha->host_no));
 		}
 	}
 
@@ -267,24 +271,26 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	if (rval) {
 		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
-		    "mbx2=%x, cmd=%x ****\n", __func__, ha->host_no,
+		    "mbx2=%x, cmd=%x ****\n", __func__, base_vha->host_no,
 		    mcp->mb[0], mcp->mb[1], mcp->mb[2], command));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__,
+		base_vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
+qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
     uint32_t risc_code_size)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	if (MSW(risc_addr) || IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
@@ -312,13 +318,13 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -340,13 +346,14 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
  *     Kernel context.
  */
 int
-qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
+qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_EXECUTE_FIRMWARE;
 	mcp->out_mb = MBX_0;
@@ -369,18 +376,18 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
 
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
 		if (IS_FWI2_CAPABLE(ha)) {
 			DEBUG11(printk("%s(%ld): done exchanges=%x.\n",
-			    __func__, ha->host_no, mcp->mb[1]));
+			    __func__, vha->host_no, mcp->mb[1]));
 		} else {
 			DEBUG11(printk("%s(%ld): done.\n", __func__,
-			    ha->host_no));
+			    vha->host_no));
 		}
 	}
 
@@ -404,28 +411,28 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
  *	Kernel context.
  */
 void
-qla2x00_get_fw_version(scsi_qla_host_t *ha, uint16_t *major, uint16_t *minor,
+qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
     uint16_t *subminor, uint16_t *attributes, uint32_t *memory)
 {
 	int		rval;
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_VERSION;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->flags = 0;
 	mcp->tov = MBX_TOV_SECONDS;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return mailbox data. */
 	*major = mcp->mb[1];
 	*minor = mcp->mb[2];
 	*subminor = mcp->mb[3];
 	*attributes = mcp->mb[6];
-	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+	if (IS_QLA2100(vha->hw) || IS_QLA2200(vha->hw))
 		*memory = 0x1FFFF;			/* Defaults to 128KB. */
 	else
 		*memory = (mcp->mb[5] << 16) | mcp->mb[4];
@@ -433,10 +440,10 @@ qla2x00_get_fw_version(scsi_qla_host_t *ha, uint16_t *major, uint16_t *minor,
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 }
 
@@ -455,32 +462,32 @@ qla2x00_get_fw_version(scsi_qla_host_t *ha, uint16_t *major, uint16_t *minor,
  *	Kernel context.
  */
 int
-qla2x00_get_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
+qla2x00_get_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_OPTION;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		fwopts[0] = mcp->mb[0];
 		fwopts[1] = mcp->mb[1];
 		fwopts[2] = mcp->mb[2];
 		fwopts[3] = mcp->mb[3];
 
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -502,13 +509,13 @@ qla2x00_get_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
  *	Kernel context.
  */
 int
-qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
+qla2x00_set_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_SET_FIRMWARE_OPTION;
 	mcp->mb[1] = fwopts[1];
@@ -516,7 +523,7 @@ qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
 	mcp->mb[3] = fwopts[3];
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->in_mb |= MBX_1;
 	} else {
 		mcp->mb[10] = fwopts[10];
@@ -526,17 +533,17 @@ qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
 	}
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	fwopts[0] = mcp->mb[0];
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x/%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -558,13 +565,14 @@ qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
  *	Kernel context.
  */
 int
-qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
+qla2x00_mbx_reg_test(scsi_qla_host_t *vha)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_mbx_reg_test(%ld): entered.\n", ha->host_no));
+	DEBUG11(printk("qla2x00_mbx_reg_test(%ld): entered.\n", vha->host_no));
 
 	mcp->mb[0] = MBC_MAILBOX_REGISTER_TEST;
 	mcp->mb[1] = 0xAAAA;
@@ -578,7 +586,7 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
 	mcp->in_mb = MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[1] != 0xAAAA || mcp->mb[2] != 0x5555 ||
@@ -591,7 +599,7 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
 			struct device_reg_24xx __iomem *reg =
 			    &ha->iobase->isp24;
 
-			qla2xxx_hw_event_log(ha, HW_EVENT_ISP_ERR, 0,
+			qla2xxx_hw_event_log(vha, HW_EVENT_ISP_ERR, 0,
 			    LSW(RD_REG_DWORD(&reg->hccr)),
 			    LSW(RD_REG_DWORD(&reg->istatus)));
 		}
@@ -600,11 +608,11 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_mbx_reg_test(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_mbx_reg_test(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -626,18 +634,18 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 int
-qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
+qla2x00_verify_checksum(scsi_qla_host_t *vha, uint32_t risc_addr)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_VERIFY_CHECKSUM;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->out_mb |= MBX_2|MBX_1;
@@ -650,14 +658,14 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
 
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x chk sum=%x.\n", __func__,
-		    ha->host_no, rval, IS_FWI2_CAPABLE(ha) ?
+		    vha->host_no, rval, IS_FWI2_CAPABLE(vha->hw) ?
 		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -682,7 +690,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
  *	Kernel context.
  */
 static int
-qla2x00_issue_iocb_timeout(scsi_qla_host_t *ha, void *buffer,
+qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
     dma_addr_t phys_addr, size_t size, uint32_t tov)
 {
 	int		rval;
@@ -699,30 +707,30 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *ha, void *buffer,
 	mcp->in_mb = MBX_2|MBX_0;
 	mcp->tov = tov;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 		DEBUG2(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		sts_entry_t *sts_entry = (sts_entry_t *) buffer;
 
 		/* Mask reserved bits. */
 		sts_entry->entry_status &=
-		    IS_FWI2_CAPABLE(ha) ? RF_MASK_24XX :RF_MASK;
+		    IS_FWI2_CAPABLE(vha->hw) ? RF_MASK_24XX : RF_MASK;
 	}
 
 	return rval;
 }
 
 int
-qla2x00_issue_iocb(scsi_qla_host_t *ha, void *buffer, dma_addr_t phys_addr,
+qla2x00_issue_iocb(scsi_qla_host_t *vha, void *buffer, dma_addr_t phys_addr,
     size_t size)
 {
-	return qla2x00_issue_iocb_timeout(ha, buffer, phys_addr, size,
+	return qla2x00_issue_iocb_timeout(vha, buffer, phys_addr, size,
 	    MBX_TOV_SECONDS);
 }
 
@@ -741,7 +749,7 @@ qla2x00_issue_iocb(scsi_qla_host_t *ha, void *buffer, dma_addr_t phys_addr,
  *	Kernel context.
  */
 int
-qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
+qla2x00_abort_command(scsi_qla_host_t *vha, srb_t *sp)
 {
 	unsigned long   flags = 0;
 	fc_port_t	*fcport;
@@ -749,14 +757,16 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	uint32_t	handle;
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
-	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no));
+	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", vha->host_no));
 
 	fcport = sp->fcport;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
-		if (ha->outstanding_cmds[handle] == sp)
+		if (req->outstanding_cmds[handle] == sp)
 			break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -778,14 +788,14 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("qla2x00_abort_command(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		DEBUG11(printk("qla2x00_abort_command(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -797,40 +807,40 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
 	int rval, rval2;
 	mbx_cmd_t  mc;
 	mbx_cmd_t  *mcp = &mc;
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *vha;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
 	l = l;
-	ha = fcport->ha;
+	vha = fcport->vha;
 	mcp->mb[0] = MBC_ABORT_TARGET;
 	mcp->out_mb = MBX_9|MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
+	if (HAS_EXTENDED_IDS(vha->hw)) {
 		mcp->mb[1] = fcport->loop_id;
 		mcp->mb[10] = 0;
 		mcp->out_mb |= MBX_10;
 	} else {
 		mcp->mb[1] = fcport->loop_id << 8;
 	}
-	mcp->mb[2] = ha->loop_reset_delay;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[2] = vha->hw->loop_reset_delay;
+	mcp->mb[9] = vha->vp_idx;
 
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(ha, fcport->loop_id, 0, MK_SYNC_ID);
+	rval2 = qla2x00_marker(vha, fcport->loop_id, 0, MK_SYNC_ID);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval2));
+		    "(%x).\n", __func__, vha->host_no, rval2));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -842,37 +852,37 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
 	int rval, rval2;
 	mbx_cmd_t  mc;
 	mbx_cmd_t  *mcp = &mc;
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *vha;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
-	ha = fcport->ha;
+	vha = fcport->vha;
 	mcp->mb[0] = MBC_LUN_RESET;
 	mcp->out_mb = MBX_9|MBX_3|MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha))
+	if (HAS_EXTENDED_IDS(vha->hw))
 		mcp->mb[1] = fcport->loop_id;
 	else
 		mcp->mb[1] = fcport->loop_id << 8;
 	mcp->mb[2] = l;
 	mcp->mb[3] = 0;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(ha, fcport->loop_id, l, MK_SYNC_ID_LUN);
+	rval2 = qla2x00_marker(vha, fcport->loop_id, l, MK_SYNC_ID_LUN);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval2));
+		    "(%x).\n", __func__, vha->host_no, rval2));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -899,7 +909,7 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
  *	Kernel context.
  */
 int
-qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
+qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
     uint8_t *area, uint8_t *domain, uint16_t *top, uint16_t *sw_cap)
 {
 	int rval;
@@ -907,15 +917,15 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_adapter_id(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_GET_ADAPTER_LOOP_ID;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_0;
 	mcp->in_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (mcp->mb[0] == MBS_COMMAND_ERROR)
 		rval = QLA_COMMAND_ERROR;
 	else if (mcp->mb[0] == MBS_INVALID_COMMAND)
@@ -932,11 +942,11 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_adapter_id(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_get_adapter_id(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -958,7 +968,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
  *	Kernel context.
  */
 int
-qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
+qla2x00_get_retry_cnt(scsi_qla_host_t *vha, uint8_t *retry_cnt, uint8_t *tov,
     uint16_t *r_a_tov)
 {
 	int rval;
@@ -967,19 +977,19 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_retry_cnt(%ld): entered.\n",
-			ha->host_no));
+			vha->host_no));
 
 	mcp->mb[0] = MBC_GET_RETRY_COUNT;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_retry_cnt(%ld): failed = %x.\n",
-		    ha->host_no, mcp->mb[0]));
+		    vha->host_no, mcp->mb[0]));
 	} else {
 		/* Convert returned data and check our values. */
 		*r_a_tov = mcp->mb[3] / 2;
@@ -991,7 +1001,7 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
 		}
 
 		DEBUG11(printk("qla2x00_get_retry_cnt(%ld): done. mb3=%d "
-		    "ratov=%d.\n", ha->host_no, mcp->mb[3], ratov));
+		    "ratov=%d.\n", vha->host_no, mcp->mb[3], ratov));
 	}
 
 	return rval;
@@ -1015,14 +1025,15 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
  *	Kernel context.
  */
 int
-qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
+qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
 
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	if (ha->flags.npiv_supported)
 		mcp->mb[0] = MBC_MID_INITIALIZE_FIRMWARE;
@@ -1040,17 +1051,17 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
 	mcp->buf_size = size;
 	mcp->flags = MBX_DMA_OUT;
 	mcp->tov = MBX_TOV_SECONDS;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_init_firmware(%ld): failed=%x "
 		    "mb0=%x.\n",
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_init_firmware(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1073,7 +1084,7 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
  *	Kernel context.
  */
 int
-qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
+qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -1081,14 +1092,15 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 	port_database_t *pd;
 	struct port_database_24xx *pd24;
 	dma_addr_t pd_dma;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	pd24 = NULL;
 	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
 	if (pd  == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Port Database "
-		    "structure.\n", __func__, ha->host_no));
+		    "structure.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
@@ -1100,7 +1112,7 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 	mcp->mb[3] = LSW(pd_dma);
 	mcp->mb[6] = MSW(MSD(pd_dma));
 	mcp->mb[7] = LSW(MSD(pd_dma));
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(ha)) {
@@ -1120,7 +1132,7 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 	    PORT_DATABASE_24XX_SIZE : PORT_DATABASE_SIZE;
 	mcp->flags = MBX_DMA_IN;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS)
 		goto gpd_error_out;
 
@@ -1132,7 +1144,7 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 		    pd24->last_login_state != PDS_PRLI_COMPLETE) {
 			DEBUG2(printk("%s(%ld): Unable to verify "
 			    "login-state (%x/%x) for loop_id %x\n",
-			    __func__, ha->host_no,
+			    __func__, vha->host_no,
 			    pd24->current_login_state,
 			    pd24->last_login_state, fcport->loop_id));
 			rval = QLA_FUNCTION_FAILED;
@@ -1192,9 +1204,9 @@ gpd_error_out:
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -1217,21 +1229,21 @@ gpd_error_out:
  *	Kernel context.
  */
 int
-qla2x00_get_firmware_state(scsi_qla_host_t *ha, uint16_t *states)
+qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_firmware_state(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return firmware states. */
 	states[0] = mcp->mb[1];
@@ -1241,11 +1253,11 @@ qla2x00_get_firmware_state(scsi_qla_host_t *ha, uint16_t *states)
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_firmware_state(%ld): "
-		    "failed=%x.\n", ha->host_no, rval));
+		    "failed=%x.\n", vha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_get_firmware_state(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1270,7 +1282,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *ha, uint16_t *states)
  *	Kernel context.
  */
 int
-qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
+qla2x00_get_port_name(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t *name,
     uint8_t opt)
 {
 	int rval;
@@ -1278,12 +1290,12 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_port_name(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_GET_PORT_NAME;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
+	if (HAS_EXTENDED_IDS(vha->hw)) {
 		mcp->mb[1] = loop_id;
 		mcp->mb[10] = opt;
 		mcp->out_mb |= MBX_10;
@@ -1294,12 +1306,12 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
 	mcp->in_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_port_name(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		if (name != NULL) {
 			/* This function returns name in big endian. */
@@ -1314,7 +1326,7 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
 		}
 
 		DEBUG11(printk("qla2x00_get_port_name(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1336,45 +1348,45 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
  *	Kernel context.
  */
 int
-qla2x00_lip_reset(scsi_qla_host_t *ha)
+qla2x00_lip_reset(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 		mcp->mb[1] = BIT_6;
 		mcp->mb[2] = 0;
-		mcp->mb[3] = ha->loop_reset_delay;
+		mcp->mb[3] = vha->hw->loop_reset_delay;
 		mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	} else {
 		mcp->mb[0] = MBC_LIP_RESET;
 		mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
-		if (HAS_EXTENDED_IDS(ha)) {
+		if (HAS_EXTENDED_IDS(vha->hw)) {
 			mcp->mb[1] = 0x00ff;
 			mcp->mb[10] = 0;
 			mcp->out_mb |= MBX_10;
 		} else {
 			mcp->mb[1] = 0xff00;
 		}
-		mcp->mb[2] = ha->loop_reset_delay;
+		mcp->mb[2] = vha->hw->loop_reset_delay;
 		mcp->mb[3] = 0;
 	}
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n",
-		    __func__, ha->host_no, rval));
+		    __func__, vha->host_no, rval));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -1399,7 +1411,7 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 int
-qla2x00_send_sns(scsi_qla_host_t *ha, dma_addr_t sns_phys_address,
+qla2x00_send_sns(scsi_qla_host_t *vha, dma_addr_t sns_phys_address,
     uint16_t cmd_size, size_t buf_size)
 {
 	int rval;
@@ -1407,10 +1419,11 @@ qla2x00_send_sns(scsi_qla_host_t *ha, dma_addr_t sns_phys_address,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_send_sns(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	DEBUG11(printk("qla2x00_send_sns: retry cnt=%d ratov=%d total "
-	    "tov=%d.\n", ha->retry_count, ha->login_timeout, mcp->tov));
+		"tov=%d.\n", vha->hw->retry_count, vha->hw->login_timeout,
+		mcp->tov));
 
 	mcp->mb[0] = MBC_SEND_SNS_COMMAND;
 	mcp->mb[1] = cmd_size;
@@ -1422,25 +1435,25 @@ qla2x00_send_sns(scsi_qla_host_t *ha, dma_addr_t sns_phys_address,
 	mcp->in_mb = MBX_0|MBX_1;
 	mcp->buf_size = buf_size;
 	mcp->flags = MBX_DMA_OUT|MBX_DMA_IN;
-	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
-	rval = qla2x00_mailbox_command(ha, mcp);
+	mcp->tov = (vha->hw->login_timeout * 2) + (vha->hw->login_timeout / 2);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG(printk("qla2x00_send_sns(%ld): failed=%x mb[0]=%x "
-		    "mb[1]=%x.\n", ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    "mb[1]=%x.\n", vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 		DEBUG2_3_11(printk("qla2x00_send_sns(%ld): failed=%x mb[0]=%x "
-		    "mb[1]=%x.\n", ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    "mb[1]=%x.\n", vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_send_sns(%ld): done.\n", ha->host_no));
+		DEBUG11(printk("qla2x00_send_sns(%ld): done.\n", vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa, uint16_t *mb, uint8_t opt)
 {
 	int		rval;
@@ -1448,13 +1461,14 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
 	uint32_t	iop[2];
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Login IOCB.\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(lg, 0, sizeof(struct logio_entry_24xx));
@@ -1470,14 +1484,14 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = ha->vp_idx;
-	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
+	lg->vp_index = vha->vp_idx;
+	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Login IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval));
+		    "(%x).\n", __func__, vha->host_no, rval));
 	} else if (lg->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, vha->host_no,
 		    lg->entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
@@ -1486,7 +1500,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
-		    ha->host_no, le16_to_cpu(lg->comp_status), iop[0],
+		    vha->host_no, le16_to_cpu(lg->comp_status), iop[0],
 		    iop[1]));
 
 		switch (iop[0]) {
@@ -1515,7 +1529,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 			break;
 		}
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 
 		iop[0] = le32_to_cpu(lg->io_parameter[0]);
 
@@ -1562,14 +1576,15 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
  *	Kernel context.
  */
 int
-qla2x00_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+qla2x00_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa, uint16_t *mb, uint8_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("qla2x00_login_fabric(%ld): entered.\n", ha->host_no));
+	DEBUG11(printk("qla2x00_login_fabric(%ld): entered.\n", vha->host_no));
 
 	mcp->mb[0] = MBC_LOGIN_FABRIC_PORT;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
@@ -1586,7 +1601,7 @@ qla2x00_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	mcp->in_mb = MBX_7|MBX_6|MBX_2|MBX_1|MBX_0;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return mailbox statuses. */
 	if (mb != NULL) {
@@ -1613,12 +1628,12 @@ qla2x00_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_login_fabric(%ld): failed=%x "
-		    "mb[0]=%x mb[1]=%x mb[2]=%x.\n", ha->host_no, rval,
+		    "mb[0]=%x mb[1]=%x mb[2]=%x.\n", vha->host_no, rval,
 		    mcp->mb[0], mcp->mb[1], mcp->mb[2]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_login_fabric(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1641,19 +1656,20 @@ qla2x00_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
  *
  */
 int
-qla2x00_login_local_device(scsi_qla_host_t *ha, fc_port_t *fcport,
+qla2x00_login_local_device(scsi_qla_host_t *vha, fc_port_t *fcport,
     uint16_t *mb_ret, uint8_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (IS_FWI2_CAPABLE(ha))
-		return qla24xx_login_fabric(ha, fcport->loop_id,
+		return qla24xx_login_fabric(vha, fcport->loop_id,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb_ret, opt);
 
-	DEBUG3(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG3(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_LOGIN_LOOP_PORT;
 	if (HAS_EXTENDED_IDS(ha))
@@ -1665,7 +1681,7 @@ qla2x00_login_local_device(scsi_qla_host_t *ha, fc_port_t *fcport,
  	mcp->in_mb = MBX_7|MBX_6|MBX_1|MBX_0;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
  	/* Return mailbox statuses. */
  	if (mb_ret != NULL) {
@@ -1686,33 +1702,34 @@ qla2x00_login_local_device(scsi_qla_host_t *ha, fc_port_t *fcport,
  			rval = QLA_SUCCESS;
 
 		DEBUG(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
-		    "mb[6]=%x mb[7]=%x.\n", __func__, ha->host_no, rval,
+		    "mb[6]=%x mb[7]=%x.\n", __func__, vha->host_no, rval,
 		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]));
 		DEBUG2_3(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
-		    "mb[6]=%x mb[7]=%x.\n", __func__, ha->host_no, rval,
+		    "mb[6]=%x mb[7]=%x.\n", __func__, vha->host_no, rval,
 		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]));
 	} else {
 		/*EMPTY*/
-		DEBUG3(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG3(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return (rval);
 }
 
 int
-qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa)
 {
 	int		rval;
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Logout IOCB.\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(lg, 0, sizeof(struct logio_entry_24xx));
@@ -1725,25 +1742,25 @@ qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = ha->vp_idx;
-	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
+	lg->vp_index = vha->vp_idx;
+	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Logout IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval));
+		    "(%x).\n", __func__, vha->host_no, rval));
 	} else if (lg->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, vha->host_no,
 		    lg->entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
-		    ha->host_no, le16_to_cpu(lg->comp_status),
+		    vha->host_no, le16_to_cpu(lg->comp_status),
 		    le32_to_cpu(lg->io_parameter[0]),
 		    le32_to_cpu(lg->io_parameter[1])));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
@@ -1768,7 +1785,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
  *	Kernel context.
  */
 int
-qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+qla2x00_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa)
 {
 	int rval;
@@ -1776,11 +1793,11 @@ qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_fabric_logout(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_LOGOUT_FABRIC_PORT;
 	mcp->out_mb = MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
+	if (HAS_EXTENDED_IDS(vha->hw)) {
 		mcp->mb[1] = loop_id;
 		mcp->mb[10] = 0;
 		mcp->out_mb |= MBX_10;
@@ -1791,16 +1808,16 @@ qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_fabric_logout(%ld): failed=%x "
-		    "mbx1=%x.\n", ha->host_no, rval, mcp->mb[1]));
+		    "mbx1=%x.\n", vha->host_no, rval, mcp->mb[1]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_fabric_logout(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1822,33 +1839,33 @@ qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
  *	Kernel context.
  */
 int
-qla2x00_full_login_lip(scsi_qla_host_t *ha)
+qla2x00_full_login_lip(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_full_login_lip(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_LIP_FULL_LOGIN;
-	mcp->mb[1] = IS_FWI2_CAPABLE(ha) ? BIT_3: 0;
+	mcp->mb[1] = IS_FWI2_CAPABLE(vha->hw) ? BIT_3 : 0;
 	mcp->mb[2] = 0;
 	mcp->mb[3] = 0;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_full_login_lip(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_full_login_lip(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1867,7 +1884,7 @@ qla2x00_full_login_lip(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 int
-qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
+qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
     uint16_t *entries)
 {
 	int rval;
@@ -1875,20 +1892,20 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_id_list(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	if (id_list == NULL)
 		return QLA_FUNCTION_FAILED;
 
 	mcp->mb[0] = MBC_GET_ID_LIST;
 	mcp->out_mb = MBX_0;
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[2] = MSW(id_list_dma);
 		mcp->mb[3] = LSW(id_list_dma);
 		mcp->mb[6] = MSW(MSD(id_list_dma));
 		mcp->mb[7] = LSW(MSD(id_list_dma));
 		mcp->mb[8] = 0;
-		mcp->mb[9] = ha->vp_idx;
+		mcp->mb[9] = vha->vp_idx;
 		mcp->out_mb |= MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2;
 	} else {
 		mcp->mb[1] = MSW(id_list_dma);
@@ -1900,16 +1917,16 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_id_list(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		*entries = mcp->mb[1];
 		DEBUG11(printk("qla2x00_get_id_list(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1929,7 +1946,7 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
  *	Kernel context.
  */
 int
-qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
+qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
     uint16_t *orig_xchg_cnt, uint16_t *cur_iocb_cnt,
     uint16_t *orig_iocb_cnt, uint16_t *max_npiv_vports)
 {
@@ -1937,22 +1954,22 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_RESOURCE_COUNTS;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_11|MBX_10|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed = %x.\n", __func__,
-		    ha->host_no, mcp->mb[0]));
+		    vha->host_no, mcp->mb[0]));
 	} else {
 		DEBUG11(printk("%s(%ld): done. mb1=%x mb2=%x mb3=%x mb6=%x "
-		    "mb7=%x mb10=%x mb11=%x.\n", __func__, ha->host_no,
+		    "mb7=%x mb10=%x mb11=%x.\n", __func__, vha->host_no,
 		    mcp->mb[1], mcp->mb[2], mcp->mb[3], mcp->mb[6], mcp->mb[7],
 		    mcp->mb[10], mcp->mb[11]));
 
@@ -1964,7 +1981,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 			*cur_iocb_cnt = mcp->mb[7];
 		if (orig_iocb_cnt)
 			*orig_iocb_cnt = mcp->mb[10];
-		if (max_npiv_vports)
+		if (IS_FWI2_CAPABLE(vha->hw) && max_npiv_vports)
 			*max_npiv_vports = mcp->mb[11];
 	}
 
@@ -1987,18 +2004,19 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
  *	Kernel context.
  */
 int
-qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
+qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	char *pmap;
 	dma_addr_t pmap_dma;
+	struct qla_hw_data *ha = vha->hw;
 
 	pmap = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pmap_dma);
 	if (pmap  == NULL) {
 		DEBUG2_3_11(printk("%s(%ld): **** Mem Alloc Failed ****",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(pmap, 0, FCAL_MAP_SIZE);
@@ -2013,11 +2031,11 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
 	mcp->buf_size = FCAL_MAP_SIZE;
 	mcp->flags = MBX_DMA_IN;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		DEBUG11(printk("%s(%ld): (mb0=%x/mb1=%x) FC/AL Position Map "
-		    "size (%x)\n", __func__, ha->host_no, mcp->mb[0],
+		    "size (%x)\n", __func__, vha->host_no, mcp->mb[0],
 		    mcp->mb[1], (unsigned)pmap[0]));
 		DEBUG11(qla2x00_dump_buffer(pmap, pmap[0] + 1));
 
@@ -2028,9 +2046,9 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -2051,15 +2069,16 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
  *	BIT_1 = mailbox error.
  */
 int
-qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
+qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
     struct link_statistics *stats, dma_addr_t stats_dma)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	uint32_t *siter, *diter, dwords;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_LINK_STATUS;
 	mcp->mb[2] = MSW(stats_dma);
@@ -2084,12 +2103,12 @@ qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
 	}
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = IOCTL_CMD;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
-			    __func__, ha->host_no, mcp->mb[0]));
+			    __func__, vha->host_no, mcp->mb[0]));
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Copy over data -- firmware data is LE. */
@@ -2101,14 +2120,14 @@ qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	}
 
 	return rval;
 }
 
 int
-qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
+qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
     dma_addr_t stats_dma)
 {
 	int rval;
@@ -2116,7 +2135,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
 	mbx_cmd_t *mcp = &mc;
 	uint32_t *siter, *diter, dwords;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_LINK_PRIV_STATS;
 	mcp->mb[2] = MSW(stats_dma);
@@ -2124,18 +2143,18 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
 	mcp->mb[6] = MSW(MSD(stats_dma));
 	mcp->mb[7] = LSW(MSD(stats_dma));
 	mcp->mb[8] = sizeof(struct link_statistics) / 4;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 	mcp->mb[10] = 0;
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = IOCTL_CMD;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
-			    __func__, ha->host_no, mcp->mb[0]));
+			    __func__, vha->host_no, mcp->mb[0]));
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Copy over data -- firmware data is LE. */
@@ -2147,14 +2166,14 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	}
 
 	return rval;
 }
 
 int
-qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
+qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp)
 {
 	int		rval;
 	fc_port_t	*fcport;
@@ -2163,18 +2182,19 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	struct abort_entry_24xx *abt;
 	dma_addr_t	abt_dma;
 	uint32_t	handle;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	fcport = sp->fcport;
 
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
-		if (pha->outstanding_cmds[handle] == sp)
+		if (req->outstanding_cmds[handle] == sp)
 			break;
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (handle == MAX_OUTSTANDING_COMMANDS) {
 		/* Command not found. */
 		return QLA_FUNCTION_FAILED;
@@ -2183,7 +2203,7 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	abt = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
 	if (abt == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Abort IOCB.\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(abt, 0, sizeof(struct abort_entry_24xx));
@@ -2196,22 +2216,22 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	abt->port_id[1] = fcport->d_id.b.area;
 	abt->port_id[2] = fcport->d_id.b.domain;
 	abt->vp_index = fcport->vp_idx;
-	rval = qla2x00_issue_iocb(ha, abt, abt_dma, 0);
+	rval = qla2x00_issue_iocb(vha, abt, abt_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue IOCB (%x).\n",
-		    __func__, ha->host_no, rval));
+		    __func__, vha->host_no, rval));
 	} else if (abt->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, vha->host_no,
 		    abt->entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (abt->nport_handle != __constant_cpu_to_le16(0)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, ha->host_no,
+		    "-- completion status (%x).\n", __func__, vha->host_no,
 		    le16_to_cpu(abt->nport_handle)));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	dma_pool_free(ha->s_dma_pool, abt, abt_dma);
@@ -2233,16 +2253,17 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	int		rval, rval2;
 	struct tsk_mgmt_cmd *tsk;
 	dma_addr_t	tsk_dma;
-	scsi_qla_host_t *ha, *pha;
+	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
 
-	ha = fcport->ha;
-	pha = to_qla_parent(ha);
-	tsk = dma_pool_alloc(pha->s_dma_pool, GFP_KERNEL, &tsk_dma);
+	vha = fcport->vha;
+	ha = vha->hw;
+	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
 	if (tsk == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Task Management "
-		    "IOCB.\n", __func__, ha->host_no));
+		    "IOCB.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(tsk, 0, sizeof(struct tsk_mgmt_cmd));
@@ -2262,34 +2283,34 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		    sizeof(tsk->p.tsk.lun));
 	}
 
-	rval = qla2x00_issue_iocb(ha, tsk, tsk_dma, 0);
+	rval = qla2x00_issue_iocb(vha, tsk, tsk_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue %s Reset IOCB "
-		    "(%x).\n", __func__, ha->host_no, name, rval));
+		    "(%x).\n", __func__, vha->host_no, name, rval));
 	} else if (tsk->p.sts.entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, vha->host_no,
 		    tsk->p.sts.entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (tsk->p.sts.comp_status !=
 	    __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__,
-		    ha->host_no, le16_to_cpu(tsk->p.sts.comp_status)));
+		    vha->host_no, le16_to_cpu(tsk->p.sts.comp_status)));
 		rval = QLA_FUNCTION_FAILED;
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(ha, fcport->loop_id, l,
+	rval2 = qla2x00_marker(vha, fcport->loop_id, l,
 	    type == TCF_LUN_RESET ? MK_SYNC_ID_LUN: MK_SYNC_ID);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval2));
+		    "(%x).\n", __func__, vha->host_no, rval2));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
-	dma_pool_free(pha->s_dma_pool, tsk, tsk_dma);
+	dma_pool_free(ha->s_dma_pool, tsk, tsk_dma);
 
 	return rval;
 }
@@ -2307,29 +2328,30 @@ qla24xx_lun_reset(struct fc_port *fcport, unsigned int l)
 }
 
 int
-qla2x00_system_error(scsi_qla_host_t *ha)
+qla2x00_system_error(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA23XX(ha) && !IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GEN_SYSTEM_ERROR;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 5;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -2342,14 +2364,14 @@ qla2x00_system_error(scsi_qla_host_t *ha)
  * Returns
  */
 int
-qla2x00_set_serdes_params(scsi_qla_host_t *ha, uint16_t sw_em_1g,
+qla2x00_set_serdes_params(scsi_qla_host_t *vha, uint16_t sw_em_1g,
     uint16_t sw_em_2g, uint16_t sw_em_4g)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_SERDES_PARAMS;
 	mcp->mb[1] = BIT_0;
@@ -2360,61 +2382,61 @@ qla2x00_set_serdes_params(scsi_qla_host_t *ha, uint16_t sw_em_1g,
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_stop_firmware(scsi_qla_host_t *ha)
+qla2x00_stop_firmware(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_STOP_FIRMWARE;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 5;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_enable_eft_trace(scsi_qla_host_t *ha, dma_addr_t eft_dma,
+qla2x00_enable_eft_trace(scsi_qla_host_t *vha, dma_addr_t eft_dma,
     uint16_t buffers)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_EFT_ENABLE;
@@ -2428,28 +2450,28 @@ qla2x00_enable_eft_trace(scsi_qla_host_t *ha, dma_addr_t eft_dma,
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_disable_eft_trace(scsi_qla_host_t *ha)
+qla2x00_disable_eft_trace(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_EFT_DISABLE;
@@ -2457,29 +2479,29 @@ qla2x00_disable_eft_trace(scsi_qla_host_t *ha)
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
+qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
     uint16_t buffers, uint16_t *mb, uint32_t *dwords)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA25XX(ha))
+	if (!IS_QLA25XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_FCE_ENABLE;
@@ -2497,12 +2519,12 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 
 		if (mb)
 			memcpy(mb, mcp->mb, 8 * sizeof(*mb));
@@ -2514,16 +2536,16 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
 }
 
 int
-qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
+qla2x00_disable_fce_trace(scsi_qla_host_t *vha, uint64_t *wr, uint64_t *rd)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_FCE_DISABLE;
@@ -2533,12 +2555,12 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
 	    MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 
 		if (wr)
 			*wr = (uint64_t) mcp->mb[5] << 48 |
@@ -2556,17 +2578,17 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
 }
 
 int
-qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
+qla2x00_read_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint16_t addr,
     uint16_t off, uint16_t count)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_READ_SFP;
 	mcp->mb[1] = addr;
@@ -2581,30 +2603,30 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
+qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
     uint16_t port_speed, uint16_t *mb)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_IIDMA_CAPABLE(ha))
+	if (!IS_IIDMA_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_PORT_PARAMS;
 	mcp->mb[1] = loop_id;
@@ -2615,7 +2637,7 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return mailbox statuses. */
 	if (mb != NULL) {
@@ -2628,28 +2650,29 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 void
-qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
+qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	struct vp_rpt_id_entry_24xx *rptid_entry)
 {
 	uint8_t vp_idx;
 	uint16_t stat = le16_to_cpu(rptid_entry->vp_idx);
-	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *vp;
 
 	if (rptid_entry->entry_status != 0)
 		return;
 
 	if (rptid_entry->format == 0) {
 		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs setup %d,"
-			" number of VPs acquired %d\n", __func__, ha->host_no,
+			" number of VPs acquired %d\n", __func__, vha->host_no,
 			MSB(rptid_entry->vp_count), LSB(rptid_entry->vp_count)));
 		DEBUG15(printk("%s primary port id %02x%02x%02x\n", __func__,
 			rptid_entry->port_id[2], rptid_entry->port_id[1],
@@ -2658,7 +2681,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 		vp_idx = LSB(stat);
 		DEBUG15(printk("%s:format 1: scsi(%ld): VP[%d] enabled "
 		    "- status %d - "
-		    "with port id %02x%02x%02x\n",__func__,ha->host_no,
+		    "with port id %02x%02x%02x\n", __func__, vha->host_no,
 		    vp_idx, MSB(stat),
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]));
@@ -2668,25 +2691,24 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 		if (MSB(stat) == 1)
 			return;
 
-		list_for_each_entry(vha, &ha->vp_list, vp_list)
-			if (vp_idx == vha->vp_idx)
+		list_for_each_entry(vp, &ha->vp_list, list)
+			if (vp_idx == vp->vp_idx)
 				break;
-
-		if (!vha)
+		if (!vp)
 			return;
 
-		vha->d_id.b.domain = rptid_entry->port_id[2];
-		vha->d_id.b.area =  rptid_entry->port_id[1];
-		vha->d_id.b.al_pa = rptid_entry->port_id[0];
+		vp->d_id.b.domain = rptid_entry->port_id[2];
+		vp->d_id.b.area =  rptid_entry->port_id[1];
+		vp->d_id.b.al_pa = rptid_entry->port_id[0];
 
 		/*
 		 * Cannot configure here as we are still sitting on the
 		 * response queue. Handle it in dpc context.
 		 */
-		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
-		set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
+		set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
+		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 
-		qla2xxx_wake_dpc(ha);
+		qla2xxx_wake_dpc(vha);
 	}
 }
 
@@ -2709,15 +2731,15 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	int		rval;
 	struct vp_config_entry_24xx *vpmod;
 	dma_addr_t	vpmod_dma;
-	scsi_qla_host_t *pha;
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	/* This can be called by the parent */
-	pha = to_qla_parent(vha);
 
-	vpmod = dma_pool_alloc(pha->s_dma_pool, GFP_KERNEL, &vpmod_dma);
+	vpmod = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vpmod_dma);
 	if (!vpmod) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Modify VP "
-		    "IOCB.\n", __func__, pha->host_no));
+		    "IOCB.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
@@ -2732,26 +2754,27 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	memcpy(vpmod->port_name_idx1, vha->port_name, WWN_SIZE);
 	vpmod->entry_count = 1;
 
-	rval = qla2x00_issue_iocb(pha, vpmod, vpmod_dma, 0);
+	rval = qla2x00_issue_iocb(base_vha, vpmod, vpmod_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue VP config IOCB"
-			"(%x).\n", __func__, pha->host_no, rval));
+			"(%x).\n", __func__, base_vha->host_no, rval));
 	} else if (vpmod->comp_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-			"-- error status (%x).\n", __func__, pha->host_no,
+			"-- error status (%x).\n", __func__, base_vha->host_no,
 			vpmod->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vpmod->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, pha->host_no,
+		    "-- completion status (%x).\n", __func__, base_vha->host_no,
 		    le16_to_cpu(vpmod->comp_status)));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		/* EMPTY */
-		DEBUG11(printk("%s(%ld): done.\n", __func__, pha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__,
+							base_vha->host_no));
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_INITIALIZING);
 	}
-	dma_pool_free(pha->s_dma_pool, vpmod, vpmod_dma);
+	dma_pool_free(ha->s_dma_pool, vpmod, vpmod_dma);
 
 	return rval;
 }
@@ -2778,11 +2801,12 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	int		map, pos;
 	struct vp_ctrl_entry_24xx   *vce;
 	dma_addr_t	vce_dma;
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
 	int	vp_index = vha->vp_idx;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	DEBUG11(printk("%s(%ld): entered. Enabling index %d\n", __func__,
-	    ha->host_no, vp_index));
+	    vha->host_no, vp_index));
 
 	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
@@ -2791,7 +2815,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	if (!vce) {
 		DEBUG2_3(printk("%s(%ld): "
 		    "failed to allocate VP Control IOCB.\n", __func__,
-		    ha->host_no));
+		    base_vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(vce, 0, sizeof(struct vp_ctrl_entry_24xx));
@@ -2810,30 +2834,30 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	vce->vp_idx_map[map] |= 1 << pos;
 	mutex_unlock(&ha->vport_lock);
 
-	rval = qla2x00_issue_iocb(ha, vce, vce_dma, 0);
+	rval = qla2x00_issue_iocb(base_vha, vce, vce_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue VP control IOCB"
-		    "(%x).\n", __func__, ha->host_no, rval));
+		    "(%x).\n", __func__, base_vha->host_no, rval));
 		printk("%s(%ld): failed to issue VP control IOCB"
-		    "(%x).\n", __func__, ha->host_no, rval);
+		    "(%x).\n", __func__, base_vha->host_no, rval);
 	} else if (vce->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, base_vha->host_no,
 		    vce->entry_status));
 		printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, base_vha->host_no,
 		    vce->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vce->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, ha->host_no,
+		    "-- completion status (%x).\n", __func__, base_vha->host_no,
 		    le16_to_cpu(vce->comp_status)));
 		printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, ha->host_no,
+		    "-- completion status (%x).\n", __func__, base_vha->host_no,
 		    le16_to_cpu(vce->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG2(printk("%s(%ld): done.\n", __func__, base_vha->host_no));
 	}
 
 	dma_pool_free(ha->s_dma_pool, vce, vce_dma);
@@ -2863,7 +2887,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
  */
 
 int
-qla2x00_send_change_request(scsi_qla_host_t *ha, uint16_t format,
+qla2x00_send_change_request(scsi_qla_host_t *vha, uint16_t format,
 			    uint16_t vp_idx)
 {
 	int rval;
@@ -2884,7 +2908,7 @@ qla2x00_send_change_request(scsi_qla_host_t *ha, uint16_t format,
 	mcp->in_mb = MBX_0|MBX_1;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
@@ -2897,16 +2921,16 @@ qla2x00_send_change_request(scsi_qla_host_t *ha, uint16_t format,
 }
 
 int
-qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
+qla2x00_dump_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t addr,
     uint32_t size)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	if (MSW(addr) || IS_FWI2_CAPABLE(ha)) {
+	if (MSW(addr) || IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[0] = MBC_DUMP_RISC_RAM_EXTENDED;
 		mcp->mb[8] = MSW(addr);
 		mcp->out_mb = MBX_8|MBX_0;
@@ -2920,7 +2944,7 @@ qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
 	mcp->mb[6] = MSW(MSD(req_dma));
 	mcp->mb[7] = LSW(MSD(req_dma));
 	mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2|MBX_1;
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[4] = MSW(size);
 		mcp->mb[5] = LSW(size);
 		mcp->out_mb |= MBX_5|MBX_4;
@@ -2932,13 +2956,13 @@ qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -2954,20 +2978,21 @@ struct cs84xx_mgmt_cmd {
 };
 
 int
-qla84xx_verify_chip(struct scsi_qla_host *ha, uint16_t *status)
+qla84xx_verify_chip(struct scsi_qla_host *vha, uint16_t *status)
 {
 	int rval, retry;
 	struct cs84xx_mgmt_cmd *mn;
 	dma_addr_t mn_dma;
 	uint16_t options;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG16(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG16(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (mn == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Verify ISP84XX "
-		    "IOCB.\n", __func__, ha->host_no));
+		    "IOCB.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
@@ -2986,19 +3011,19 @@ qla84xx_verify_chip(struct scsi_qla_host *ha, uint16_t *status)
 		mn->p.req.options = cpu_to_le16(options);
 
 		DEBUG16(printk("%s(%ld): Dump of Verify Request.\n", __func__,
-		    ha->host_no));
+		    vha->host_no));
 		DEBUG16(qla2x00_dump_buffer((uint8_t *)mn,
 		    sizeof(*mn)));
 
-		rval = qla2x00_issue_iocb_timeout(ha, mn, mn_dma, 0, 120);
+		rval = qla2x00_issue_iocb_timeout(vha, mn, mn_dma, 0, 120);
 		if (rval != QLA_SUCCESS) {
 			DEBUG2_16(printk("%s(%ld): failed to issue Verify "
-			    "IOCB (%x).\n", __func__, ha->host_no, rval));
+			    "IOCB (%x).\n", __func__, vha->host_no, rval));
 			goto verify_done;
 		}
 
 		DEBUG16(printk("%s(%ld): Dump of Verify Response.\n", __func__,
-		    ha->host_no));
+		    vha->host_no));
 		DEBUG16(qla2x00_dump_buffer((uint8_t *)mn,
 		    sizeof(*mn)));
 
@@ -3006,21 +3031,21 @@ qla84xx_verify_chip(struct scsi_qla_host *ha, uint16_t *status)
 		status[1] = status[0] == CS_VCS_CHIP_FAILURE ?
 		    le16_to_cpu(mn->p.rsp.failure_code) : 0;
 		DEBUG2_16(printk("%s(%ld): cs=%x fc=%x\n", __func__,
-		    ha->host_no, status[0], status[1]));
+		    vha->host_no, status[0], status[1]));
 
 		if (status[0] != CS_COMPLETE) {
 			rval = QLA_FUNCTION_FAILED;
 			if (!(options & VCO_DONT_UPDATE_FW)) {
 				DEBUG2_16(printk("%s(%ld): Firmware update "
 				    "failed. Retrying without update "
-				    "firmware.\n", __func__, ha->host_no));
+				    "firmware.\n", __func__, vha->host_no));
 				options |= VCO_DONT_UPDATE_FW;
 				options &= ~VCO_FORCE_UPDATE;
 				retry = 1;
 			}
 		} else {
 			DEBUG2_16(printk("%s(%ld): firmware updated to %x.\n",
-			    __func__, ha->host_no,
+			    __func__, vha->host_no,
 			    le32_to_cpu(mn->p.rsp.fw_ver)));
 
 			/* NOTE: we only update OP firmware. */
@@ -3037,9 +3062,9 @@ verify_done:
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_16(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG16(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG16(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 93560cd..da3db3a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_gbl.h"
 
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
@@ -18,7 +19,7 @@
 void
 qla2x00_vp_stop_timer(scsi_qla_host_t *vha)
 {
-	if (vha->parent && vha->timer_active) {
+	if (vha->vp_idx && vha->timer_active) {
 		del_timer_sync(&vha->timer);
 		vha->timer_active = 0;
 	}
@@ -28,7 +29,7 @@ static uint32_t
 qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint32_t vp_id;
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Find an empty slot and assign an vp_id */
 	mutex_lock(&ha->vport_lock);
@@ -44,7 +45,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	ha->num_vhosts++;
 	ha->cur_vport_count++;
 	vha->vp_idx = vp_id;
-	list_add_tail(&vha->vp_list, &ha->vp_list);
+	list_add_tail(&vha->list, &ha->vp_list);
 	mutex_unlock(&ha->vport_lock);
 	return vp_id;
 }
@@ -53,24 +54,24 @@ void
 qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint16_t vp_id;
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
 
 	mutex_lock(&ha->vport_lock);
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
 	ha->cur_vport_count--;
 	clear_bit(vp_id, ha->vp_idx_map);
-	list_del(&vha->vp_list);
+	list_del(&vha->list);
 	mutex_unlock(&ha->vport_lock);
 }
 
 static scsi_qla_host_t *
-qla24xx_find_vhost_by_name(scsi_qla_host_t *ha, uint8_t *port_name)
+qla24xx_find_vhost_by_name(struct qla_hw_data *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
 
 	/* Locate matching device in database. */
-	list_for_each_entry(vha, &ha->vp_list, vp_list) {
+	list_for_each_entry(vha, &ha->vp_list, list) {
 		if (!memcmp(port_name, vha->port_name, WWN_SIZE))
 			return vha;
 	}
@@ -94,12 +95,8 @@ static void
 qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 {
 	fc_port_t *fcport;
-	scsi_qla_host_t *pha = to_qla_parent(vha);
-
-	list_for_each_entry(fcport, &pha->fcports, list) {
-		if (fcport->vp_idx != vha->vp_idx)
-			continue;
 
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		DEBUG15(printk("scsi(%ld): Marking port dead, "
 		    "loop_id=0x%04x :%x\n",
 		    vha->host_no, fcport->loop_id, fcport->vp_idx));
@@ -118,7 +115,6 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 
-	/* Delete all vp's fcports from parent's list */
 	qla2x00_mark_vp_devices_dead(vha);
 	atomic_set(&vha->vp_state, VP_FAILED);
 	vha->flags.management_server_logged_in = 0;
@@ -135,11 +131,12 @@ int
 qla24xx_enable_vp(scsi_qla_host_t *vha)
 {
 	int ret;
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	/* Check if physical ha port is Up */
-	if (atomic_read(&ha->loop_state) == LOOP_DOWN  ||
-		atomic_read(&ha->loop_state) == LOOP_DEAD ) {
+	if (atomic_read(&base_vha->loop_state) == LOOP_DOWN  ||
+		atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 		vha->vp_err_state =  VP_ERR_PORTDWN;
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_LINKDOWN);
 		goto enable_failed;
@@ -177,8 +174,8 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 	    vha->host_no, __func__));
 	ret = qla2x00_send_change_request(vha, 0x3, vha->vp_idx);
 	if (ret != QLA_SUCCESS) {
-		DEBUG15(qla_printk(KERN_ERR, vha, "Failed to enable receiving"
-		    " of RSCN requests: 0x%x\n", ret));
+		DEBUG15(qla_printk(KERN_ERR, vha->hw, "Failed to enable "
+		    "receiving of RSCN requests: 0x%x\n", ret));
 		return;
 	} else {
 		/* Corresponds to SCR enabled */
@@ -194,25 +191,13 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 }
 
 void
-qla2x00_alert_all_vps(scsi_qla_host_t *ha, uint16_t *mb)
+qla2x00_alert_all_vps(struct qla_hw_data *ha, uint16_t *mb)
 {
-	int i, vp_idx_matched;
 	scsi_qla_host_t *vha;
+	int i = 0;
 
-	if (ha->parent)
-		return;
-
-	for_each_mapped_vp_idx(ha, i) {
-		vp_idx_matched = 0;
-
-		list_for_each_entry(vha, &ha->vp_list, vp_list) {
-			if (i == vha->vp_idx) {
-				vp_idx_matched = 1;
-				break;
-			}
-		}
-
-		if (vp_idx_matched) {
+	list_for_each_entry(vha, &ha->vp_list, list) {
+		if (vha->vp_idx) {
 			switch (mb[0]) {
 			case MBA_LIP_OCCURRED:
 			case MBA_LOOP_UP:
@@ -223,16 +208,17 @@ qla2x00_alert_all_vps(scsi_qla_host_t *ha, uint16_t *mb)
 			case MBA_PORT_UPDATE:
 			case MBA_RSCN_UPDATE:
 				DEBUG15(printk("scsi(%ld)%s: Async_event for"
-				    " VP[%d], mb = 0x%x, vha=%p\n",
-				    vha->host_no, __func__,i, *mb, vha));
+				" VP[%d], mb = 0x%x, vha=%p\n",
+				vha->host_no, __func__, i, *mb, vha));
 				qla2x00_async_event(vha, mb);
 				break;
 			}
 		}
+		i++;
 	}
 }
 
-void
+int
 qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 {
 	/*
@@ -247,30 +233,49 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	}
 
+	/* To exclusively reset vport, we need to log it out first.*/
+	if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
+		qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
+
 	DEBUG15(printk("scsi(%ld): Scheduling enable of Vport %d...\n",
 	    vha->host_no, vha->vp_idx));
-	qla24xx_enable_vp(vha);
+	return qla24xx_enable_vp(vha);
 }
 
 static int
 qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 {
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
 		/* VP acquired. complete port configuration */
-		if (atomic_read(&ha->loop_state) == LOOP_READY) {
+		if (atomic_read(&base_vha->loop_state) == LOOP_READY) {
 			qla24xx_configure_vp(vha);
 		} else {
 			set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
-			set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
+			set_bit(VP_DPC_NEEDED, &base_vha->dpc_flags);
 		}
 
 		return 0;
 	}
 
-	if (test_and_clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
-		qla2x00_vp_abort_isp(vha);
+	if (test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags)) {
+		qla2x00_update_fcports(vha);
+		clear_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags);
+	}
+
+	if ((test_and_clear_bit(RELOGIN_NEEDED, &vha->dpc_flags)) &&
+		!test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) &&
+		atomic_read(&vha->loop_state) != LOOP_DOWN) {
+
+		DEBUG(printk("scsi(%ld): qla2x00_port_login()\n",
+						vha->host_no));
+		qla2x00_relogin(vha);
+
+		DEBUG(printk("scsi(%ld): qla2x00_port_login - end\n",
+							vha->host_no));
+	}
 
 	if (test_and_clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) &&
 	    (!(test_and_set_bit(RESET_ACTIVE, &vha->dpc_flags)))) {
@@ -289,38 +294,30 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 }
 
 void
-qla2x00_do_dpc_all_vps(scsi_qla_host_t *ha)
+qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 {
 	int ret;
-	int i, vp_idx_matched;
-	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *vp;
 
-	if (ha->parent)
+	if (vha->vp_idx)
 		return;
 	if (list_empty(&ha->vp_list))
 		return;
 
-	clear_bit(VP_DPC_NEEDED, &ha->dpc_flags);
-
-	for_each_mapped_vp_idx(ha, i) {
-		vp_idx_matched = 0;
-
-		list_for_each_entry(vha, &ha->vp_list, vp_list) {
-			if (i == vha->vp_idx) {
-				vp_idx_matched = 1;
-				break;
-			}
-		}
+	clear_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 
-		if (vp_idx_matched)
-			ret = qla2x00_do_dpc_vp(vha);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		if (vp->vp_idx)
+			ret = qla2x00_do_dpc_vp(vp);
 	}
 }
 
 int
 qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 {
-	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
+	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
+	struct qla_hw_data *ha = base_vha->hw;
 	scsi_qla_host_t *vha;
 	uint8_t port_name[WWN_SIZE];
 
@@ -337,7 +334,7 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 
 	/* Check up unique WWPN */
 	u64_to_wwn(fc_vport->port_name, port_name);
-	if (!memcmp(port_name, ha->port_name, WWN_SIZE))
+	if (!memcmp(port_name, base_vha->port_name, WWN_SIZE))
 		return VPCERR_BAD_WWN;
 	vha = qla24xx_find_vhost_by_name(ha, port_name);
 	if (vha)
@@ -346,7 +343,7 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 	/* Check up max-npiv-supports */
 	if (ha->num_vhosts > ha->max_npiv_vports) {
 		DEBUG15(printk("scsi(%ld): num_vhosts %ud is bigger than "
-		    "max_npv_vports %ud.\n", ha->host_no,
+		    "max_npv_vports %ud.\n", base_vha->host_no,
 		    ha->num_vhosts, ha->max_npiv_vports));
 		return VPCERR_UNSUPPORTED;
 	}
@@ -356,59 +353,35 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 scsi_qla_host_t *
 qla24xx_create_vhost(struct fc_vport *fc_vport)
 {
-	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
+	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
+	struct qla_hw_data *ha = base_vha->hw;
 	scsi_qla_host_t *vha;
+	struct scsi_host_template *sht = &qla24xx_driver_template;
 	struct Scsi_Host *host;
 
-	host = scsi_host_alloc(&qla24xx_driver_template,
-	    sizeof(scsi_qla_host_t));
-	if (!host) {
-		printk(KERN_WARNING
-		    "qla2xxx: scsi_host_alloc() failed for vport\n");
+	vha = qla2x00_create_host(sht, ha);
+	if (!vha) {
+		DEBUG(printk("qla2xxx: scsi_host_alloc() failed for vport\n"));
 		return(NULL);
 	}
 
-	vha = shost_priv(host);
-
-	/* clone the parent hba */
-	memcpy(vha, ha, sizeof (scsi_qla_host_t));
-
+	host = vha->host;
 	fc_vport->dd_data = vha;
 
-	vha->node_name = kmalloc(WWN_SIZE * sizeof(char), GFP_KERNEL);
-	if (!vha->node_name)
-		goto create_vhost_failed_1;
-
-	vha->port_name = kmalloc(WWN_SIZE * sizeof(char), GFP_KERNEL);
-	if (!vha->port_name)
-		goto create_vhost_failed_2;
-
 	/* New host info */
 	u64_to_wwn(fc_vport->node_name, vha->node_name);
 	u64_to_wwn(fc_vport->port_name, vha->port_name);
 
-	vha->host = host;
-	vha->host_no = host->host_no;
-	vha->parent = ha;
 	vha->fc_vport = fc_vport;
 	vha->device_flags = 0;
 	vha->vp_idx = qla24xx_allocate_vp_id(vha);
 	if (vha->vp_idx > ha->max_npiv_vports) {
 		DEBUG15(printk("scsi(%ld): Couldn't allocate vp_id.\n",
 			vha->host_no));
-		goto create_vhost_failed_3;
+		goto create_vhost_failed;
 	}
 	vha->mgmt_svr_loop_id = 10 + vha->vp_idx;
 
-	init_completion(&vha->mbx_cmd_comp);
-	complete(&vha->mbx_cmd_comp);
-	init_completion(&vha->mbx_intr_comp);
-
-	INIT_LIST_HEAD(&vha->list);
-	INIT_LIST_HEAD(&vha->fcports);
-	INIT_LIST_HEAD(&vha->vp_fcports);
-	INIT_LIST_HEAD(&vha->work_list);
-
 	vha->dpc_flags = 0L;
 	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 	set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
@@ -423,7 +396,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
 
-	host->can_queue = vha->request_q_length + 128;
+	host->can_queue = ha->req->length + 128;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->max_cmd_len = MAX_CMDSZ;
@@ -440,12 +413,6 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	return vha;
 
-create_vhost_failed_3:
-	kfree(vha->port_name);
-
-create_vhost_failed_2:
-	kfree(vha->node_name);
-
-create_vhost_failed_1:
+create_vhost_failed:
 	return NULL;
 }
