From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] scic: remove mmio wrappers
Date: Sun, 27 Mar 2011 20:07:54 -0400
Message-ID: <20110328000754.GA28347@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1C1AHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2011 20:07:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Remove a couple of layers around read/writel to make the driver readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 drivers/scsi/isci/core/scic_sds_controller_registers.h                |  463 ----------
 drivers/scsi/isci/core/scic_sds_pci.h                                 |   94 --
 drivers/scsi/isci/core/scic_sds_phy_registers.h                       |  248 -----
 linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c                |  225 ++--
 linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h                |   34 
 linux-2.6/drivers/scsi/isci/core/scic_sds_phy.c                       |  146 +--
 linux-2.6/drivers/scsi/isci/core/scic_sds_port.c                      |   95 --
 linux-2.6/drivers/scsi/isci/core/scic_sds_port.h                      |   23 
 linux-2.6/drivers/scsi/isci/core/scic_sds_port_registers.h            |   81 -
 linux-2.6/drivers/scsi/isci/core/scic_sds_request.c                   |   11 
 linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c |    4 
 11 files changed, 259 insertions(+), 1165 deletions(-)

Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.c	2011-03-28 00:12:06.457981999 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c	2011-03-28 01:52:45.240482390 +0200
@@ -59,8 +59,7 @@
 #include "scic_port.h"
 #include "scic_remote_device.h"
 #include "scic_sds_controller.h"
-#include "scic_sds_controller_registers.h"
-#include "scic_sds_pci.h"
+#include "scu_registers.h"
 #include "scic_sds_phy.h"
 #include "scic_sds_port_configuration_agent.h"
 #include "scic_sds_port.h"
@@ -355,7 +354,10 @@ static void scic_sds_controller_ram_init
 	 * Therefore it no longer comes out of memory in the MDL. */
 	mde = &this_controller->memory_descriptors[SCU_MDE_COMPLETION_QUEUE];
 	this_controller->completion_queue = (u32 *)mde->virtual_address;
-	SMU_CQBAR_WRITE(this_controller, mde->physical_address);
+	writel(lower_32_bits(mde->physical_address), \
+		&this_controller->smu_registers->completion_queue_lower);
+	writel(upper_32_bits(mde->physical_address),
+		&this_controller->smu_registers->completion_queue_upper);
 
 	/*
 	 * Program the location of the Remote Node Context table
@@ -363,13 +365,19 @@ static void scic_sds_controller_ram_init
 	mde = &this_controller->memory_descriptors[SCU_MDE_REMOTE_NODE_CONTEXT];
 	this_controller->remote_node_context_table = (union scu_remote_node_context *)
 						     mde->virtual_address;
-	SMU_RNCBAR_WRITE(this_controller, mde->physical_address);
+	writel(lower_32_bits(mde->physical_address),
+		&this_controller->smu_registers->remote_node_context_lower);
+	writel(upper_32_bits(mde->physical_address),
+		&this_controller->smu_registers->remote_node_context_upper);
 
 	/* Program the location of the Task Context table into the SCU. */
 	mde = &this_controller->memory_descriptors[SCU_MDE_TASK_CONTEXT];
 	this_controller->task_context_table = (struct scu_task_context *)
 					      mde->virtual_address;
-	SMU_HTTBAR_WRITE(this_controller, mde->physical_address);
+	writel(lower_32_bits(mde->physical_address),
+		&this_controller->smu_registers->host_task_table_lower);
+	writel(upper_32_bits(mde->physical_address),
+		&this_controller->smu_registers->host_task_table_upper);
 
 	mde = &this_controller->memory_descriptors[SCU_MDE_UF_BUFFER];
 	scic_sds_unsolicited_frame_control_construct(
@@ -378,13 +386,17 @@ static void scic_sds_controller_ram_init
 
 	/*
 	 * Inform the silicon as to the location of the UF headers and
-	 * address table. */
-	SCU_UFHBAR_WRITE(
-		this_controller,
-		this_controller->uf_control.headers.physical_address);
-	SCU_PUFATHAR_WRITE(
-		this_controller,
-		this_controller->uf_control.address_table.physical_address);
+	 * address table.
+	 */
+	writel(lower_32_bits(this_controller->uf_control.headers.physical_address),
+		&this_controller->scu_registers->sdma.uf_header_base_address_lower);
+	writel(upper_32_bits(this_controller->uf_control.headers.physical_address),
+		&this_controller->scu_registers->sdma.uf_header_base_address_upper);
+
+	writel(lower_32_bits(this_controller->uf_control.address_table.physical_address),
+		&this_controller->scu_registers->sdma.uf_address_table_lower);
+	writel(upper_32_bits(this_controller->uf_control.address_table.physical_address),
+		&this_controller->scu_registers->sdma.uf_address_table_upper);
 }
 
 /**
@@ -392,25 +404,26 @@ static void scic_sds_controller_ram_init
  * @this_controller:
  *
  */
-static void scic_sds_controller_assign_task_entries(
-	struct scic_sds_controller *this_controller)
+static void
+scic_sds_controller_assign_task_entries(struct scic_sds_controller *controller)
 {
 	u32 task_assignment;
 
 	/*
 	 * Assign all the TCs to function 0
-	 * TODO: Do we actually need to read this register to write it back? */
-	task_assignment = SMU_TCA_READ(this_controller, 0);
+	 * TODO: Do we actually need to read this register to write it back?
+	 */
 
 	task_assignment =
-		(
-			task_assignment
-			| (SMU_TCA_GEN_VAL(STARTING, 0))
-			| (SMU_TCA_GEN_VAL(ENDING,  this_controller->task_context_entries - 1))
-			| (SMU_TCA_GEN_BIT(RANGE_CHECK_ENABLE))
-		);
+		readl(&controller->smu_registers->task_context_assignment[0]);
+
+	task_assignment |= (SMU_TCA_GEN_VAL(STARTING, 0)) |
+		(SMU_TCA_GEN_VAL(ENDING,  controller->task_context_entries - 1)) |
+		(SMU_TCA_GEN_BIT(RANGE_CHECK_ENABLE));
+
+	writel(task_assignment,
+		&controller->smu_registers->task_context_assignment[0]);
 
-	SMU_TCA_WRITE(this_controller, 0, task_assignment);
 }
 
 /**
@@ -433,7 +446,9 @@ static void scic_sds_controller_initiali
 		| SMU_CQC_EVENT_LIMIT_SET(this_controller->completion_event_entries - 1)
 		);
 
-	SMU_CQC_WRITE(this_controller, completion_queue_control_value);
+	writel(completion_queue_control_value,
+		&this_controller->smu_registers->completion_queue_control);
+
 
 	/* Set the completion queue get pointer and enable the queue */
 	completion_queue_get_value = (
@@ -443,7 +458,8 @@ static void scic_sds_controller_initiali
 		| (SMU_CQGR_GEN_BIT(EVENT_ENABLE))
 		);
 
-	SMU_CQGR_WRITE(this_controller, completion_queue_get_value);
+	writel(completion_queue_get_value,
+		&this_controller->smu_registers->completion_queue_get);
 
 	/* Set the completion queue put pointer */
 	completion_queue_put_value = (
@@ -451,7 +467,9 @@ static void scic_sds_controller_initiali
 		| (SMU_CQPR_GEN_VAL(EVENT_POINTER, 0))
 		);
 
-	SMU_CQPR_WRITE(this_controller, completion_queue_put_value);
+	writel(completion_queue_put_value,
+		&this_controller->smu_registers->completion_queue_put);
+
 
 	/* Initialize the cycle bit of the completion queue entries */
 	for (index = 0; index < this_controller->completion_queue_entries; index++) {
@@ -479,7 +497,8 @@ static void scic_sds_controller_initiali
 	frame_queue_control_value =
 		SCU_UFQC_GEN_VAL(QUEUE_SIZE, this_controller->uf_control.address_table.count);
 
-	SCU_UFQC_WRITE(this_controller, frame_queue_control_value);
+	writel(frame_queue_control_value,
+		&this_controller->scu_registers->sdma.unsolicited_frame_queue_control);
 
 	/* Setup the get pointer for the unsolicited frame queue */
 	frame_queue_get_value = (
@@ -487,12 +506,12 @@ static void scic_sds_controller_initiali
 		|  SCU_UFQGP_GEN_BIT(ENABLE_BIT)
 		);
 
-	SCU_UFQGP_WRITE(this_controller, frame_queue_get_value);
-
+	writel(frame_queue_get_value,
+		&this_controller->scu_registers->sdma.unsolicited_frame_get_pointer);
 	/* Setup the put pointer for the unsolicited frame queue */
 	frame_queue_put_value = SCU_UFQPP_GEN_VAL(POINTER, 0);
-
-	SCU_UFQPP_WRITE(this_controller, frame_queue_put_value);
+	writel(frame_queue_put_value,
+		&this_controller->scu_registers->sdma.unsolicited_frame_put_pointer);
 }
 
 /**
@@ -505,12 +524,12 @@ static void scic_sds_controller_enable_p
 {
 	u32 port_task_scheduler_value;
 
-	port_task_scheduler_value = SCU_PTSGCR_READ(this_controller);
-
+	port_task_scheduler_value =
+		readl(&this_controller->scu_registers->peg0.ptsg.control);
 	port_task_scheduler_value |=
 		(SCU_PTSGCR_GEN_BIT(ETM_ENABLE) | SCU_PTSGCR_GEN_BIT(PTSG_ENABLE));
-
-	SCU_PTSGCR_WRITE(this_controller, port_task_scheduler_value);
+	writel(port_task_scheduler_value,
+		&this_controller->scu_registers->peg0.ptsg.control);
 }
 
 /**
@@ -531,35 +550,34 @@ static void scic_sds_controller_afe_init
 	u32 phy_id;
 
 	/* Clear DFX Status registers */
-	scu_afe_register_write(scic, afe_dfx_master_control0, 0x0081000f);
+	writel(0x0081000f, &scic->scu_registers->afe.afe_dfx_master_control0);
 	udelay(AFE_REGISTER_WRITE_DELAY);
 
 	/* Configure bias currents to normal */
 	if (is_a0())
-		scu_afe_register_write(scic, afe_bias_control, 0x00005500);
+		writel(0x00005500, &scic->scu_registers->afe.afe_bias_control);
 	else
-		scu_afe_register_write(scic, afe_bias_control, 0x00005A00);
+		writel(0x00005A00, &scic->scu_registers->afe.afe_bias_control);
 
 	udelay(AFE_REGISTER_WRITE_DELAY);
 
 	/* Enable PLL */
 	if (is_b0())
-		scu_afe_register_write(scic, afe_pll_control0, 0x80040A08);
+		writel(0x80040A08, &scic->scu_registers->afe.afe_pll_control0);
 	else
-		scu_afe_register_write(scic, afe_pll_control0, 0x80040908);
+		writel(0x80040908, &scic->scu_registers->afe.afe_pll_control0);
 
 	udelay(AFE_REGISTER_WRITE_DELAY);
 
 	/* Wait for the PLL to lock */
 	do {
-		afe_status = scu_afe_register_read(
-			scic, afe_common_block_status);
+		afe_status = readl(&scic->scu_registers->afe.afe_common_block_status);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 	} while ((afe_status & 0x00001000) == 0);
 
 	if (is_b0()) {
 		/* Shorten SAS SNW lock time (RxLock timer value from 76 us to 50 us) */
-		scu_afe_register_write(scic, afe_pmsn_master_control0, 0x7bcc96ad);
+		writel(0x7bcc96ad, &scic->scu_registers->afe.afe_pmsn_master_control0);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 	}
 
@@ -568,16 +586,16 @@ static void scic_sds_controller_afe_init
 
 		if (is_b0()) {
 			 /* Configure transmitter SSC parameters */
-			scu_afe_txreg_write(scic, phy_id, afe_tx_ssc_control, 0x00030000);
+			writel(0x00030000, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_tx_ssc_control);
 			udelay(AFE_REGISTER_WRITE_DELAY);
 		} else {
 			/*
 			 * All defaults, except the Receive Word Alignament/Comma Detect
 			 * Enable....(0xe800) */
-			scu_afe_txreg_write(scic, phy_id, afe_xcvr_control0, 0x00004512);
+			writel(0x00004512, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_xcvr_control0);
 			udelay(AFE_REGISTER_WRITE_DELAY);
 
-			scu_afe_txreg_write(scic, phy_id, afe_xcvr_control1, 0x0050100F);
+			writel(0x0050100F, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_xcvr_control1);
 			udelay(AFE_REGISTER_WRITE_DELAY);
 		}
 
@@ -585,61 +603,65 @@ static void scic_sds_controller_afe_init
 		 * Power up TX and RX out from power down (PWRDNTX and PWRDNRX)
 		 * & increase TX int & ext bias 20%....(0xe85c) */
 		if (is_a0())
-			scu_afe_txreg_write(scic, phy_id, afe_channel_control, 0x000003D4);
+			writel(0x000003D4, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_channel_control);
 		else if (is_a2())
-			scu_afe_txreg_write(scic, phy_id, afe_channel_control, 0x000003F0);
+			writel(0x000003F0, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_channel_control);
 		else {
 			 /* Power down TX and RX (PWRDNTX and PWRDNRX) */
-			scu_afe_txreg_write(scic, phy_id, afe_channel_control, 0x000003d7);
+			writel(0x000003d7, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_channel_control);
 			udelay(AFE_REGISTER_WRITE_DELAY);
 
 			/*
 			 * Power up TX and RX out from power down (PWRDNTX and PWRDNRX)
 			 * & increase TX int & ext bias 20%....(0xe85c) */
-			scu_afe_txreg_write(scic, phy_id, afe_channel_control, 0x000003d4);
+			writel(0x000003d4, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_channel_control);
 		}
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
 		if (is_a0() || is_a2()) {
 			/* Enable TX equalization (0xe824) */
-			scu_afe_txreg_write(scic, phy_id, afe_tx_control, 0x00040000);
+			writel(0x00040000, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_tx_control);
 			udelay(AFE_REGISTER_WRITE_DELAY);
 		}
 
 		/*
 		 * RDPI=0x0(RX Power On), RXOOBDETPDNC=0x0, TPD=0x0(TX Power On),
 		 * RDD=0x0(RX Detect Enabled) ....(0xe800) */
-		scu_afe_txreg_write(scic, phy_id, afe_xcvr_control0, 0x00004100);
+		writel(0x00004100, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_xcvr_control0);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
 		/* Leave DFE/FFE on */
 		if (is_a0())
-			scu_afe_txreg_write(scic, phy_id, afe_rx_ssc_control0, 0x3F09983F);
+			writel(0x3F09983F, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_rx_ssc_control0);
 		else if (is_a2())
-			scu_afe_txreg_write(scic, phy_id, afe_rx_ssc_control0, 0x3F11103F);
+			writel(0x3F11103F, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_rx_ssc_control0);
 		else {
-			scu_afe_txreg_write(scic, phy_id, afe_rx_ssc_control0, 0x3F11103F);
+			writel(0x3F11103F, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_rx_ssc_control0);
 			udelay(AFE_REGISTER_WRITE_DELAY);
 			/* Enable TX equalization (0xe824) */
-			scu_afe_txreg_write(scic, phy_id, afe_tx_control, 0x00040000);
+			writel(0x00040000, &scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_tx_control);
 		}
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
-		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, oem_phy->afe_tx_amp_control0);
+		writel(oem_phy->afe_tx_amp_control0,
+			&scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_tx_amp_control0);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
-		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, oem_phy->afe_tx_amp_control1);
+		writel(oem_phy->afe_tx_amp_control1,
+			&scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_tx_amp_control1);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
-		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, oem_phy->afe_tx_amp_control2);
+		writel(oem_phy->afe_tx_amp_control2,
+			&scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_tx_amp_control2);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 
-		scu_afe_txreg_write(scic, phy_id, afe_tx_amp_control0, oem_phy->afe_tx_amp_control3);
+		writel(oem_phy->afe_tx_amp_control3,
+			&scic->scu_registers->afe.scu_afe_xcvr[phy_id].afe_tx_amp_control3);
 		udelay(AFE_REGISTER_WRITE_DELAY);
 	}
 
 	/* Transfer control to the PEs */
-	scu_afe_register_write(scic, afe_dfx_master_control0, 0x00010f00);
+	writel(0x00010f00, &scic->scu_registers->afe.afe_dfx_master_control0);
 	udelay(AFE_REGISTER_WRITE_DELAY);
 }
 
@@ -1437,8 +1459,9 @@ static void scic_sds_controller_process_
 			| event_cycle | SMU_CQGR_GEN_VAL(EVENT_POINTER, event_index)
 			| get_cycle   | SMU_CQGR_GEN_VAL(POINTER, get_index);
 
-		SMU_CQGR_WRITE(this_controller,
-			       this_controller->completion_queue_get);
+		writel(this_controller->completion_queue_get,
+			&this_controller->smu_registers->completion_queue_get);
+
 	}
 
 	dev_dbg(scic_to_dev(this_controller),
@@ -1456,15 +1479,15 @@ bool scic_sds_controller_isr(struct scic
 		/*
 		 * we have a spurious interrupt it could be that we have already
 		 * emptied the completion queue from a previous interrupt */
-		SMU_ISR_WRITE(scic, SMU_ISR_COMPLETION);
+		writel(SMU_ISR_COMPLETION, &scic->smu_registers->interrupt_status);
 
 		/*
 		 * There is a race in the hardware that could cause us not to be notified
 		 * of an interrupt completion if we do not take this step.  We will mask
 		 * then unmask the interrupts so if there is another interrupt pending
 		 * the clearing of the interrupt source we get the next interrupt message. */
-		SMU_IMR_WRITE(scic, 0xFF000000);
-		SMU_IMR_WRITE(scic, 0x00000000);
+		writel(0xFF000000, &scic->smu_registers->interrupt_mask);
+		writel(0, &scic->smu_registers->interrupt_mask);
 	}
 
 	return false;
@@ -1477,18 +1500,18 @@ void scic_sds_controller_completion_hand
 		scic_sds_controller_process_completions(scic);
 
 	/* Clear the interrupt and enable all interrupts again */
-	SMU_ISR_WRITE(scic, SMU_ISR_COMPLETION);
+	writel(SMU_ISR_COMPLETION, &scic->smu_registers->interrupt_status);
 	/* Could we write the value of SMU_ISR_COMPLETION? */
-	SMU_IMR_WRITE(scic, 0xFF000000);
-	SMU_IMR_WRITE(scic, 0x00000000);
+	writel(0xFF000000, &scic->smu_registers->interrupt_mask);
+	writel(0, &scic->smu_registers->interrupt_mask);
 }
 
 bool scic_sds_controller_error_isr(struct scic_sds_controller *scic)
 {
 	u32 interrupt_status;
 
-	interrupt_status = SMU_ISR_READ(scic);
-
+	interrupt_status =
+		readl(&scic->smu_registers->interrupt_status);
 	interrupt_status &= (SMU_ISR_QUEUE_ERROR | SMU_ISR_QUEUE_SUSPEND);
 
 	if (interrupt_status != 0) {
@@ -1504,8 +1527,8 @@ bool scic_sds_controller_error_isr(struc
 	 * then unmask the error interrupts so if there was another interrupt
 	 * pending we will be notified.
 	 * Could we write the value of (SMU_ISR_QUEUE_ERROR | SMU_ISR_QUEUE_SUSPEND)? */
-	SMU_IMR_WRITE(scic, 0x000000FF);
-	SMU_IMR_WRITE(scic, 0x00000000);
+	writel(0xff, &scic->smu_registers->interrupt_mask);
+	writel(0, &scic->smu_registers->interrupt_mask);
 
 	return false;
 }
@@ -1514,14 +1537,14 @@ void scic_sds_controller_error_handler(s
 {
 	u32 interrupt_status;
 
-	interrupt_status = SMU_ISR_READ(scic);
+	interrupt_status =
+		readl(&scic->smu_registers->interrupt_status);
 
 	if ((interrupt_status & SMU_ISR_QUEUE_SUSPEND) &&
 	    scic_sds_controller_completion_queue_has_entries(scic)) {
 
 		scic_sds_controller_process_completions(scic);
-		SMU_ISR_WRITE(scic, SMU_ISR_QUEUE_SUSPEND);
-
+		writel(SMU_ISR_QUEUE_SUSPEND, &scic->smu_registers->interrupt_status);
 	} else {
 		dev_err(scic_to_dev(scic), "%s: status: %#x\n", __func__,
 			interrupt_status);
@@ -1535,7 +1558,7 @@ void scic_sds_controller_error_handler(s
 	/* If we dont process any completions I am not sure that we want to do this.
 	 * We are in the middle of a hardware fault and should probably be reset.
 	 */
-	SMU_IMR_WRITE(scic, 0x00000000);
+	writel(0, &scic->smu_registers->interrupt_mask);
 }
 
 
@@ -1648,7 +1671,7 @@ void scic_sds_controller_post_request(
 		this_controller,
 		request);
 
-	SMU_PCP_WRITE(this_controller, request);
+	writel(request, &this_controller->smu_registers->post_context_port);
 }
 
 /**
@@ -1871,7 +1894,8 @@ void scic_sds_controller_release_frame(
 {
 	if (scic_sds_unsolicited_frame_control_release_frame(
 		    &this_controller->uf_control, frame_index) == true)
-		SCU_UFQGP_WRITE(this_controller, this_controller->uf_control.get);
+		writel(this_controller->uf_control.get,
+			&this_controller->scu_registers->sdma.unsolicited_frame_get_pointer);
 }
 
 /**
@@ -2478,14 +2502,14 @@ void scic_controller_enable_interrupts(
 	struct scic_sds_controller *scic)
 {
 	BUG_ON(scic->smu_registers == NULL);
-	SMU_IMR_WRITE(scic, 0x00000000);
+	writel(0, &scic->smu_registers->interrupt_mask);
 }
 
 void scic_controller_disable_interrupts(
 	struct scic_sds_controller *scic)
 {
 	BUG_ON(scic->smu_registers == NULL);
-	SMU_IMR_WRITE(scic, 0xffffffff);
+	writel(0xffffffff, &scic->smu_registers->interrupt_mask);
 }
 
 static enum sci_status scic_controller_set_mode(
@@ -2543,16 +2567,16 @@ static void scic_sds_controller_reset_ha
 	scic_controller_disable_interrupts(scic);
 
 	/* Reset the SCU */
-	SMU_SMUSRCR_WRITE(scic, 0xFFFFFFFF);
+	writel(0xFFFFFFFF, &scic->smu_registers->soft_reset_control);
 
 	/* Delay for 1ms to before clearing the CQP and UFQPR. */
 	udelay(1000);
 
 	/* The write to the CQGR clears the CQP */
-	SMU_CQGR_WRITE(scic, 0x00000000);
+	writel(0x00000000, &scic->smu_registers->completion_queue_get);
 
 	/* The write to the UFQGP clears the UFQPR */
-	SCU_UFQGP_WRITE(scic, 0x00000000);
+	writel(0, &scic->scu_registers->sdma.unsolicited_frame_get_pointer);
 }
 
 enum sci_status scic_user_parameters_set(
@@ -2778,11 +2802,10 @@ static enum sci_status scic_controller_s
 			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 	}
 
-	SMU_ICC_WRITE(
-		scic_controller,
-		(SMU_ICC_GEN_VAL(NUMBER, coalesce_number) |
-		 SMU_ICC_GEN_VAL(TIMER, timeout_encode))
-		);
+	writel(SMU_ICC_GEN_VAL(NUMBER, coalesce_number) |
+	       SMU_ICC_GEN_VAL(TIMER, timeout_encode),
+	       &scic_controller->smu_registers->interrupt_coalesce_control);
+
 
 	scic_controller->interrupt_coalesce_number = (u16)coalesce_number;
 	scic_controller->interrupt_coalesce_timeout = coalesce_timeout / 100;
@@ -2868,7 +2891,7 @@ static enum sci_status scic_sds_controll
 		u32 terminate_loop;
 
 		/* Take the hardware out of reset */
-		SMU_SMUSRCR_WRITE(scic, 0x00000000);
+		writel(0, &scic->smu_registers->soft_reset_control);
 
 		/*
 		 * / @todo Provide meaningfull error code for hardware failure
@@ -2879,7 +2902,7 @@ static enum sci_status scic_sds_controll
 		while (terminate_loop-- && (result != SCI_SUCCESS)) {
 			/* Loop until the hardware reports success */
 			udelay(SCU_CONTEXT_RAM_INIT_STALL_TIME);
-			status = SMU_SMUCSR_READ(scic);
+			status = readl(&scic->smu_registers->control_status);
 
 			if ((status & SCU_RAM_INIT_COMPLETED) ==
 					SCU_RAM_INIT_COMPLETED)
@@ -2896,7 +2919,9 @@ static enum sci_status scic_sds_controll
 		/*
 		 * Determine what are the actaul device capacities that the
 		 * hardware will support */
-		device_context_capacity = SMU_DCC_READ(scic);
+		device_context_capacity =
+			readl(&scic->smu_registers->device_context_capacity);
+
 
 		max_supported_ports = smu_dcc_get_max_ports(device_context_capacity);
 		max_supported_devices = smu_dcc_get_max_remote_node_context(device_context_capacity);
@@ -2910,9 +2935,7 @@ static enum sci_status scic_sds_controll
 			struct scu_port_task_scheduler_group_registers *ptsg =
 				&scic->scu_registers->peg0.ptsg;
 
-			scu_register_write(scic,
-					   ptsg->protocol_engine[index],
-					   index);
+			writel(index, &ptsg->protocol_engine[index]);
 		}
 
 		/* Record the smaller of the two capacity values */
@@ -2939,16 +2962,20 @@ static enum sci_status scic_sds_controll
 		u32 dma_configuration;
 
 		/* Configure the payload DMA */
-		dma_configuration = SCU_PDMACR_READ(scic);
+		dma_configuration =
+			readl(&scic->scu_registers->sdma.pdma_configuration);
 		dma_configuration |=
 			SCU_PDMACR_GEN_BIT(PCI_RELAXED_ORDERING_ENABLE);
-		SCU_PDMACR_WRITE(scic, dma_configuration);
+		writel(dma_configuration,
+			&scic->scu_registers->sdma.pdma_configuration);
 
 		/* Configure the control DMA */
-		dma_configuration = SCU_CDMACR_READ(scic);
+		dma_configuration =
+			readl(&scic->scu_registers->sdma.cdma_configuration);
 		dma_configuration |=
 			SCU_CDMACR_GEN_BIT(PCI_RELAXED_ORDERING_ENABLE);
-		SCU_CDMACR_WRITE(scic, dma_configuration);
+		writel(dma_configuration,
+			&scic->scu_registers->sdma.cdma_configuration);
 	}
 
 	/*
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.h	2011-03-28 00:12:06.393982529 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h	2011-03-28 00:29:02.285004208 +0200
@@ -57,6 +57,7 @@
 #define _SCIC_SDS_CONTROLLER_H_
 
 #include <linux/string.h>
+#include <linux/io.h>
 
 /**
  * This file contains the structures, constants and prototypes used for the
@@ -80,7 +81,6 @@
 #include "scu_unsolicited_frame.h"
 #include "scic_sds_unsolicited_frame_control.h"
 #include "scic_sds_port_configuration_agent.h"
-#include "scic_sds_pci.h"
 
 struct scic_sds_remote_device;
 struct scic_sds_request;
@@ -428,38 +428,6 @@ extern const struct scic_sds_controller_
 	(&(controller)->port_agent)
 
 /**
- * smu_register_write() -
- *
- * This macro writes to the smu_register for this controller
- */
-#define smu_register_write(controller, reg, value) \
-	scic_sds_pci_write_smu_dword((controller), &(reg), (value))
-
-/**
- * smu_register_read() -
- *
- * This macro reads the smu_register for this controller
- */
-#define smu_register_read(controller, reg) \
-	scic_sds_pci_read_smu_dword((controller), &(reg))
-
-/**
- * scu_register_write() -
- *
- * This mcaro writes the scu_register for this controller
- */
-#define scu_register_write(controller, reg, value) \
-	scic_sds_pci_write_scu_dword((controller), &(reg), (value))
-
-/**
- * scu_register_read() -
- *
- * This macro reads the scu_register for this controller
- */
-#define scu_register_read(controller, reg) \
-	scic_sds_pci_read_scu_dword((controller), &(reg))
-
-/**
  * scic_sds_controller_get_protocol_engine_group() -
  *
  * This macro returns the protocol engine group for this controller object.
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller_registers.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller_registers.h	2011-03-28 00:12:06.417982989 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,463 +0,0 @@
-/*
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of Intel Corporation nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef _SCIC_SDS_CONTROLLER_REGISTERS_H_
-#define _SCIC_SDS_CONTROLLER_REGISTERS_H_
-
-/**
- * This file contains macros used to perform the register reads/writes to the
- *    SCU hardware.
- *
- *
- */
-
-#include "scu_registers.h"
-#include "scic_sds_controller.h"
-
-/**
- * scic_sds_controller_smu_register_read() -
- *
- * SMU_REGISTER_ACCESS_MACROS
- */
-#define scic_sds_controller_smu_register_read(controller, reg) \
-	smu_register_read(\
-		(controller), \
-		(controller)->smu_registers->reg \
-		)
-
-#define scic_sds_controller_smu_register_write(controller, reg, value) \
-	smu_register_write(\
-		(controller), \
-		(controller)->smu_registers->reg, \
-		(value)	\
-		)
-
-/**
- * scu_afe_register_write() -
- *
- * AFE_REGISTER_ACCESS_MACROS
- */
-#define scu_afe_register_write(controller, reg, value) \
-	scu_register_write(\
-		(controller), \
-		(controller)->scu_registers->afe.reg, \
-		(value)	\
-		)
-
-#define scu_afe_txreg_write(controller, phy, reg, value) \
-	scu_register_write(\
-		(controller), \
-		(controller)->scu_registers->afe.scu_afe_xcvr[phy].reg,\
-		(value) \
-		)
-
-#define scu_afe_register_read(controller, reg) \
-	scu_register_read(\
-		(controller), \
-		(controller)->scu_registers->afe.reg \
-		)
-
-/**
- * scu_controller_viit_register_write() -
- *
- * VIIT_REGISTER_ACCESS_MACROS
- */
-#define scu_controller_viit_register_write(controller, index, reg, value) \
-	scu_register_write(\
-		(controller), \
-		(controller)->scu_registers->peg0.viit[index].reg, \
-		value \
-		)
-
-/*
- * *****************************************************************************
- * * SMU REGISTERS
- * ***************************************************************************** */
-
-/**
- * SMU_PCP_WRITE() -
- *
- * struct smu_registers
- */
-#define SMU_PCP_WRITE(controller, value) \
-	scic_sds_controller_smu_register_write(\
-		controller, post_context_port, value \
-		)
-
-#define SMU_TCR_READ(controller, value)	\
-	scic_sds_controller_smu_register_read(\
-		controller, task_context_range \
-		)
-
-#define SMU_TCR_WRITE(controller, value) \
-	scic_sds_controller_smu_register_write(\
-		controller, task_context_range, value \
-		)
-
-#define SMU_HTTBAR_WRITE(controller, address) \
-	{ \
-		scic_sds_controller_smu_register_write(\
-			controller, \
-			host_task_table_lower, \
-			lower_32_bits(address) \
-			); \
-		scic_sds_controller_smu_register_write(\
-			controller, \
-			host_task_table_upper, \
-			upper_32_bits(address) \
-			); \
-	}
-
-#define SMU_CQBAR_WRITE(controller, address) \
-	{ \
-		scic_sds_controller_smu_register_write(\
-			controller, \
-			completion_queue_lower,	\
-			lower_32_bits(address) \
-			); \
-		scic_sds_controller_smu_register_write(\
-			controller, \
-			completion_queue_upper,	\
-			upper_32_bits(address) \
-			); \
-	}
-
-#define SMU_CQGR_WRITE(controller, value) \
-	scic_sds_controller_smu_register_write(\
-		controller, completion_queue_get, value	\
-		)
-
-#define SMU_CQGR_READ(controller, value) \
-	scic_sds_controller_smu_register_read(\
-		controller, completion_queue_get \
-		)
-
-#define SMU_CQPR_WRITE(controller, value) \
-	scic_sds_controller_smu_register_write(\
-		controller, completion_queue_put, value	\
-		)
-
-#define SMU_RNCBAR_WRITE(controller, address) \
-	{ \
-		scic_sds_controller_smu_register_write(\
-			controller, \
-			remote_node_context_lower, \
-			lower_32_bits(address) \
-			); \
-		scic_sds_controller_smu_register_write(\
-			controller, \
-			remote_node_context_upper, \
-			upper_32_bits(address) \
-			); \
-	}
-
-#define SMU_AMR_READ(controller) \
-	scic_sds_controller_smu_register_read(\
-		controller, address_modifier \
-		)
-
-#define SMU_IMR_READ(controller) \
-	scic_sds_controller_smu_register_read(\
-		controller, interrupt_mask \
-		)
-
-#define SMU_IMR_WRITE(controller, mask)	\
-	scic_sds_controller_smu_register_write(\
-		controller, interrupt_mask, mask \
-		)
-
-#define SMU_ISR_READ(controller) \
-	scic_sds_controller_smu_register_read(\
-		controller, interrupt_status \
-		)
-
-#define SMU_ISR_WRITE(controller, status) \
-	scic_sds_controller_smu_register_write(\
-		controller, interrupt_status, status \
-		)
-
-#define SMU_ICC_READ(controller) \
-	scic_sds_controller_smu_register_read(\
-		controller, interrupt_coalesce_control \
-		)
-
-#define SMU_ICC_WRITE(controller, value) \
-	scic_sds_controller_smu_register_write(\
-		controller, interrupt_coalesce_control, value \
-		)
-
-#define SMU_CQC_WRITE(controller, value) \
-	scic_sds_controller_smu_register_write(\
-		controller, completion_queue_control, value \
-		)
-
-#define SMU_SMUSRCR_WRITE(controller, value) \
-	scic_sds_controller_smu_register_write(\
-		controller, soft_reset_control, value \
-		)
-
-#define SMU_TCA_WRITE(controller, index, value)	\
-	scic_sds_controller_smu_register_write(\
-		controller, task_context_assignment[index], value \
-		)
-
-#define SMU_TCA_READ(controller, index)	\
-	scic_sds_controller_smu_register_read(\
-		controller, task_context_assignment[index] \
-		)
-
-#define SMU_DCC_READ(controller) \
-	scic_sds_controller_smu_register_read(\
-		controller, device_context_capacity \
-		)
-
-#define SMU_DFC_READ(controller) \
-	scic_sds_controller_smu_register_read(\
-		controller, device_function_capacity \
-		)
-
-#define SMU_SMUCSR_READ(controller) \
-	scic_sds_controller_smu_register_read(\
-		controller, control_status \
-		)
-
-#define SMU_CQPR_READ(controller) \
-	scic_sds_controller_smu_register_read(\
-		controller, completion_queue_put \
-		)
-
-
-/**
- * scic_sds_controller_scu_register_read() -
- *
- * SCU_REGISTER_ACCESS_MACROS
- */
-#define scic_sds_controller_scu_register_read(controller, reg) \
-	scu_register_read(\
-		(controller), \
-		(controller)->scu_registers->reg \
-		)
-
-#define scic_sds_controller_scu_register_write(controller, reg, value) \
-	scu_register_write(\
-		(controller), \
-		(controller)->scu_registers->reg, \
-		(value)	\
-		)
-
-
-/*
- * ****************************************************************************
- * *  SCU SDMA REGISTERS
- * **************************************************************************** */
-
-/**
- * scu_sdma_register_read() -
- *
- * SCU_SDMA_REGISTER_ACCESS_MACROS
- */
-#define scu_sdma_register_read(controller, reg)	\
-	scu_register_read(\
-		(controller), \
-		(controller)->scu_registers->sdma.reg \
-		)
-
-#define scu_sdma_register_write(controller, reg, value)	\
-	scu_register_write(\
-		(controller), \
-		(controller)->scu_registers->sdma.reg, \
-		(value)	\
-		)
-
-/**
- * SCU_PUFATHAR_WRITE() -
- *
- * struct scu_sdma_registers
- */
-#define SCU_PUFATHAR_WRITE(controller, address)	\
-	{ \
-		scu_sdma_register_write(\
-			controller, \
-			uf_address_table_lower,	\
-			lower_32_bits(address) \
-			); \
-		scu_sdma_register_write(\
-			controller, \
-			uf_address_table_upper,	\
-			upper_32_bits(address) \
-			); \
-	}
-
-#define SCU_UFHBAR_WRITE(controller, address) \
-	{ \
-		scu_sdma_register_write(\
-			controller, \
-			uf_header_base_address_lower, \
-			lower_32_bits(address) \
-			); \
-		scu_sdma_register_write(\
-			controller, \
-			uf_header_base_address_upper, \
-			upper_32_bits(address) \
-			); \
-	}
-
-#define SCU_UFQC_READ(controller) \
-	scu_sdma_register_read(\
-		controller,  \
-		unsolicited_frame_queue_control	\
-		)
-
-#define SCU_UFQC_WRITE(controller, value) \
-	scu_sdma_register_write(\
-		controller, \
-		unsolicited_frame_queue_control, \
-		value \
-		)
-
-#define SCU_UFQPP_READ(controller) \
-	scu_sdma_register_read(\
-		controller, \
-		unsolicited_frame_put_pointer \
-		)
-
-#define SCU_UFQPP_WRITE(controller, value) \
-	scu_sdma_register_write(\
-		controller, \
-		unsolicited_frame_put_pointer, \
-		value \
-		)
-
-#define SCU_UFQGP_WRITE(controller, value) \
-	scu_sdma_register_write(\
-		controller, \
-		unsolicited_frame_get_pointer, \
-		value \
-		)
-
-#define SCU_PDMACR_READ(controller) \
-	scu_sdma_register_read(\
-		controller, \
-		pdma_configuration \
-		)
-
-#define SCU_PDMACR_WRITE(controller, value) \
-	scu_sdma_register_write(\
-		controller, \
-		pdma_configuration, \
-		value \
-		)
-
-#define SCU_CDMACR_READ(controller) \
-	scu_sdma_register_read(\
-		controller, \
-		cdma_configuration \
-		)
-
-#define SCU_CDMACR_WRITE(controller, value) \
-	scu_sdma_register_write(\
-		controller, \
-		cdma_configuration, \
-		value \
-		)
-
-/*
- * *****************************************************************************
- * * SCU Port Task Scheduler Group Registers
- * ***************************************************************************** */
-
-/**
- * scu_ptsg_register_read() -
- *
- * SCU_PTSG_REGISTER_ACCESS_MACROS
- */
-#define scu_ptsg_register_read(controller, reg)	\
-	scu_register_read(\
-		(controller), \
-		(controller)->scu_registers->peg0.ptsg.reg \
-		)
-
-#define scu_ptsg_register_write(controller, reg, value)	\
-	scu_register_write(\
-		(controller), \
-		(controller)->scu_registers->peg0.ptsg.reg, \
-		(value)	\
-		)
-
-/**
- * SCU_PTSGCR_READ() -
- *
- * SCU_PTSG_REGISTERS
- */
-#define SCU_PTSGCR_READ(controller) \
-	scu_ptsg_register_read(\
-		(controller), \
-		control	\
-		)
-
-#define SCU_PTSGCR_WRITE(controller, value) \
-	scu_ptsg_register_write(\
-		(controller), \
-		control, \
-		value \
-		)
-
-#define SCU_PTSGRTC_READ(controller) \
-	scu_ptsg_register_read(\
-		contoller, \
-		real_time_clock	\
-		)
-
-#endif /* _SCIC_SDS_CONTROLLER_REGISTERS_H_ */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_pci.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_pci.h	2011-03-28 00:12:06.381982317 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,94 +0,0 @@
-/*
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of Intel Corporation nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef _SCIC_SDS_PCI_H_
-#define _SCIC_SDS_PCI_H_
-
-/**
- * This file contains the prototypes/macros utilized in writing out PCI data
- *    for the SCI core.
- *
- *
- */
-
-#include <asm/io.h>
-
-struct scic_sds_controller;
-
-void scic_sds_pci_bar_initialization(struct scic_sds_controller *scic);
-
-/* for debug we separate scu and smu accesses and require a controller */
-static inline u32 scic_sds_pci_read_smu_dword(struct scic_sds_controller *scic, void __iomem *addr)
-{
-	return readl(addr);
-}
-
-static inline void scic_sds_pci_write_smu_dword(struct scic_sds_controller *scic, void __iomem *addr, u32 value)
-{
-	writel(value, addr);
-}
-
-static inline u32 scic_sds_pci_read_scu_dword(struct scic_sds_controller *scic, void __iomem *addr)
-{
-	return readl(addr);
-}
-
-static inline void scic_sds_pci_write_scu_dword(struct scic_sds_controller *scic, void __iomem *addr, u32 value)
-{
-	writel(value, addr);
-}
-
-
-#endif /* _SCIC_SDS_PCI_H_ */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_phy_registers.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_phy_registers.h	2011-03-28 00:12:06.429982075 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,248 +0,0 @@
-/*
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of Intel Corporation nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef _SCIC_SDS_PHY_REGISTERS_H_
-#define _SCIC_SDS_PHY_REGISTERS_H_
-
-/**
- * This file contains the macros used by the phy object to read/write to the
- *    SCU link layer registers.
- *
- *
- */
-
-#include "scic_sds_controller.h"
-
-/* **************************************************************************
- * * SCU TRANSPORT LAYER REGISTER OPERATIONS
- * ************************************************************************** */
-
-/**
- * Macro to read the transport layer register associated with this phy
- * object.
- */
-#define scu_transport_layer_read(phy, reg) \
-	scu_register_read( \
-		scic_sds_phy_get_controller(phy), \
-		(phy)->transport_layer_registers->reg \
-		)
-
-/**
- * Macro to write the transport layer register associated with this phy
- * object.
- */
-#define scu_transport_layer_write(phy, reg, value) \
-	scu_register_write( \
-		scic_sds_phy_get_controller(phy), \
-		(phy)->transport_layer_registers->reg, \
-		(value) \
-		)
-
-/* **************************************************************************
- * * Transport Layer registers controlled by the phy object
- * ************************************************************************** */
-
-/* This macro reads the Transport layer control register */
-#define SCU_TLCR_READ(phy) \
-	scu_transport_layer_read(phy, control)
-
-/* This macro writes the Transport layer control register */
-#define SCU_TLCR_WRITE(phy, value) \
-	scu_transport_layer_write(phy, control, value)
-
-/* This macro reads the Transport layer address translation register */
-#define SCU_TLADTR_READ(phy) \
-	scu_transport_layer_read(phy, address_translation)
-
-/* This macro writes the Transport layer address translation register */
-#define SCU_TLADTR_WRITE(phy) \
-	scu_transport_layer_write(phy, address_translation, value)
-
-/* This macro writes the STP Transport Layer Direct Attached RNi register */
-#define SCU_STPTLDARNI_WRITE(phy, index) \
-	scu_transport_layer_write(phy, stp_rni, index)
-
-/* This macro reads the STP Transport Layer Direct Attached RNi register */
-#define SCU_STPTLDARNI_READ(phy) \
-	scu_transport_layer_read(phy, stp_rni)
-
-/*
- * *****************************************************************************
- * * SCU LINK LAYER REGISTER OPERATIONS
- * ***************************************************************************** */
-
-/**
- * scu_link_layer_register_read() -
- *
- * THis macro requests the SCU register write for the specified link layer
- * register.
- */
-#define scu_link_layer_register_read(phy, reg) \
-	scu_register_read(\
-		scic_sds_phy_get_controller(phy), \
-		(phy)->link_layer_registers->reg \
-		)
-
-/**
- * scu_link_layer_register_write() -
- *
- * This macro requests the SCU register read for the specified link layer
- * register.
- */
-#define scu_link_layer_register_write(phy, reg, value) \
-	scu_register_write(\
-		scic_sds_phy_get_controller(phy), \
-		(phy)->link_layer_registers->reg, \
-		(value)	\
-		)
-
-/*
- * *****************************************************************************
- * * SCU LINK LAYER REGISTERS
- * ***************************************************************************** */
-
-/* / This macro reads from the SAS Identify Frame PHY Identifier register */
-#define SCU_SAS_TIPID_READ(phy)	\
-	scu_link_layer_register_read(phy, identify_frame_phy_id)
-
-/* / This macro writes to the SAS Identify Frame PHY Identifier register */
-#define SCU_SAS_TIPID_WRITE(phy, value)	\
-	scu_link_layer_register_write(phy, identify_frame_phy_id, value)
-
-/* / This macro reads from the SAS Identification register */
-#define SCU_SAS_TIID_READ(phy) \
-	scu_link_layer_register_read(phy, transmit_identification)
-
-/* / This macro writes to the SAS Identification register */
-#define SCU_SAS_TIID_WRITE(phy, value) \
-	scu_link_layer_register_write(phy, transmit_identification, value)
-
-/* / This macro reads the SAS Device Name High register */
-#define SCU_SAS_TIDNH_READ(phy)	\
-	scu_link_layer_register_read(phy, sas_device_name_high)
-
-/* / This macro writes the SAS Device Name High register */
-#define SCU_SAS_TIDNH_WRITE(phy, value)	\
-	scu_link_layer_register_write(phy, sas_device_name_high, value)
-
-/* / This macro reads the SAS Device Name Low register */
-#define SCU_SAS_TIDNL_READ(phy)	\
-	scu_link_layer_register_read(phy, sas_device_name_low)
-
-/* / This macro writes the SAS Device Name Low register */
-#define SCU_SAS_TIDNL_WRITE(phy, value)	\
-	scu_link_layer_register_write(phy, sas_device_name_low, value)
-
-/* / This macro reads the Source SAS Address High register */
-#define SCU_SAS_TISSAH_READ(phy) \
-	scu_link_layer_register_read(phy, source_sas_address_high)
-
-/* / This macro writes the Source SAS Address High register */
-#define SCU_SAS_TISSAH_WRITE(phy, value) \
-	scu_link_layer_register_write(phy, source_sas_address_high, value)
-
-/* / This macro reads the Source SAS Address Low register */
-#define SCU_SAS_TISSAL_READ(phy) \
-	scu_link_layer_register_read(phy, source_sas_address_low)
-
-/* / This macro writes the Source SAS Address Low register */
-#define SCU_SAS_TISSAL_WRITE(phy, value) \
-	scu_link_layer_register_write(phy, source_sas_address_low, value)
-
-/* / This macro reads the PHY Configuration register */
-#define SCU_SAS_PCFG_READ(phy) \
-	scu_link_layer_register_read(phy, phy_configuration);
-
-/* / This macro writes the PHY Configuration register */
-#define SCU_SAS_PCFG_WRITE(phy, value) \
-	scu_link_layer_register_write(phy, phy_configuration, value)
-
-/* / This macro reads the PHY Enable Spinup register */
-#define SCU_SAS_ENSPINUP_READ(phy) \
-	scu_link_layer_register_read(phy, notify_enable_spinup_control)
-
-/* / This macro writes the PHY Enable Spinup register */
-#define SCU_SAS_ENSPINUP_WRITE(phy, value) \
-	scu_link_layer_register_write(phy, notify_enable_spinup_control, value)
-
-/* This macro reads the CLKSM register */
-#define SCU_SAS_CLKSM_READ(phy) \
-	scu_link_layer_register_read(phy, clock_skew_management)
-
-/* This macro writes the CLKSM register */
-#define SCU_SAS_CLKSM_WRITE(phy, value) \
-	scu_link_layer_register_write(phy, clock_skew_management, value)
-
-/* / This macro reads the PHY Capacity register */
-#define SCU_SAS_PHYCAP_READ(phy) \
-	scu_link_layer_register_read(phy, phy_capabilities)
-
-/* / This macro writes the PHY Capacity register */
-#define SCU_SAS_PHYCAP_WRITE(phy, value) \
-	scu_link_layer_register_write(phy, phy_capabilities, value)
-
-/* / This macro reads the Recieved PHY Capacity register */
-#define SCU_SAS_RECPHYCAP_READ(phy) \
-	scu_link_layer_register_read(phy, receive_phycap)
-
-/* / This macro reads the link layer control register */
-#define SCU_SAS_LLCTL_READ(phy)	\
-	scu_link_layer_register_read(phy, link_layer_control);
-
-/* / This macro writes the link layer control register */
-#define SCU_SAS_LLCTL_WRITE(phy, value)	\
-	scu_link_layer_register_write(phy, link_layer_control, value);
-
-#endif /* _SCIC_SDS_PHY_REGISTERS_H_ */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_port_registers.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_port_registers.h	2011-03-28 00:12:06.441982180 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_port_registers.h	2011-03-28 00:39:55.020982467 +0200
@@ -63,85 +63,4 @@
  *
  */
 
-/**
- * scu_port_task_scheduler_read() -
- *
- * Macro to read the port task scheduler register associated with this port
- * object
- */
-#define scu_port_task_scheduler_read(port, reg)	\
-	scu_register_read(\
-		scic_sds_port_get_controller(port), \
-		(port)->port_task_scheduler_registers->reg \
-		)
-
-/**
- * scu_port_task_scheduler_write() -
- *
- * Macro to write the port task scheduler register associated with this port
- * object
- */
-#define scu_port_task_scheduler_write(port, reg, value)	\
-	scu_register_write(\
-		scic_sds_port_get_controller(port), \
-		(port)->port_task_scheduler_registers->reg, \
-		(value)	\
-		)
-
-#define scu_port_viit_register_write(port, reg, value) \
-	scu_register_write(\
-		scic_sds_port_get_controller(port), \
-		(port)->viit_registers->reg, \
-		(value)	\
-		)
-
-/*
- * ****************************************************************************
- * * Port Task Scheduler registers controlled by the port object
- * **************************************************************************** */
-
-/**
- * SCU_PTSxCR_READ() -
- *
- * Macro to read the port task scheduler control register
- */
-#define SCU_PTSxCR_READ(port) \
-	scu_port_task_scheduler_read(port, control)
-
-/**
- * SCU_PTSxCR_WRITE() -
- *
- * Macro to write the port task scheduler control regsister
- */
-#define SCU_PTSxCR_WRITE(port, value) \
-	scu_port_task_scheduler_write(port, control, value)
-
-/*
- * ****************************************************************************
- * * Port PE Configuration registers
- * **************************************************************************** */
-
-/**
- * SCU_PCSPExCR_WRITE() -
- *
- * Macro to write the PE Port Configuration Register
- */
-#define SCU_PCSPExCR_WRITE(port, phy_id, value)	\
-	scu_register_write(\
-		scic_sds_port_get_controller(port), \
-		(port)->port_pe_configuration_register[phy_id],	\
-		(value)	\
-		)
-
-/**
- * SCU_PCSPExCR_READ() -
- *
- * Macro to read the PE Port Configuration Regsiter
- */
-#define SCU_PCSPExCR_READ(port, phy_id)	\
-	scu_register_read(\
-		scic_sds_port_get_controller(port), \
-		(port)->port_pe_configuration_register[phy_id] \
-		)
-
 #endif /* _SCIC_SDS_PORT_REGISTERS_H_ */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_request.c	2011-03-28 00:12:06.405981154 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_request.c	2011-03-28 01:48:23.120981718 +0200
@@ -62,8 +62,7 @@
 #include "scic_io_request.h"
 #include "scic_remote_device.h"
 #include "scic_sds_controller.h"
-#include "scic_sds_controller_registers.h"
-#include "scic_sds_pci.h"
+#include "scu_registers.h"
 #include "scic_sds_port.h"
 #include "scic_sds_remote_device.h"
 #include "scic_sds_request.h"
@@ -862,20 +861,16 @@ u32 scic_io_request_get_number_of_bytes_
 {
 	u32 ret_val = 0;
 
-	if (SMU_AMR_READ(scic_sds_request->owning_controller) == 0) {
+	if (readl(&scic_sds_request->owning_controller->smu_registers->address_modifier) == 0) {
 		/*
 		 * get the bytes of data from the Address == BAR1 + 20002Ch + (256*TCi) where
 		 *   BAR1 is the scu_registers
 		 *   0x20002C = 0x200000 + 0x2c
 		 *            = start of task context SRAM + offset of (type.ssp.data_offset)
 		 *   TCi is the io_tag of struct scic_sds_request */
-		ret_val =  scic_sds_pci_read_scu_dword(
-			scic_sds_request->owning_controller,
-			(
-				(u8 *)scic_sds_request->owning_controller->scu_registers +
+		ret_val = readl((u8 *)scic_sds_request->owning_controller->scu_registers +
 				(SCU_TASK_CONTEXT_SRAM + SCI_FIELD_OFFSET(struct scu_task_context, type.ssp.data_offset)) +
 				((sizeof(struct scu_task_context)) * scic_sds_io_tag_get_index(scic_sds_request->io_tag))
-			)
 			);
 	}
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_port.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_port.c	2011-03-28 00:30:28.684985234 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_port.c	2011-03-28 01:57:49.824617212 +0200
@@ -60,14 +60,12 @@
 #include "scic_port.h"
 #include "scic_sds_controller.h"
 #include "scic_sds_phy.h"
-#include "scic_sds_phy_registers.h"
 #include "scic_sds_port.h"
-#include "scic_sds_port_registers.h"
 #include "scic_sds_remote_device.h"
 #include "scic_sds_remote_node_context.h"
 #include "scic_sds_request.h"
 #include "sci_environment.h"
-#include "scic_sds_controller_registers.h"
+#include "scu_registers.h"
 
 #define SCIC_SDS_PORT_MIN_TIMER_COUNT  (SCI_MAX_PORTS)
 #define SCIC_SDS_PORT_MAX_TIMER_COUNT  (SCI_MAX_PORTS)
@@ -706,7 +704,8 @@ void scic_sds_port_deactivate_phy(struct
 	sci_phy->max_negotiated_speed = SCI_SAS_NO_LINK_RATE;
 
 	/* Re-assign the phy back to the LP as if it were a narrow port */
-	SCU_PCSPExCR_WRITE(sci_port, sci_phy->phy_index, sci_phy->phy_index);
+	writel(sci_phy->phy_index,
+		&sci_port->port_pe_configuration_register[sci_phy->phy_index]);
 
 	if (do_notify_user == true)
 		isci_port_link_down(ihost, iphy, iport);
@@ -969,25 +968,20 @@ static void scic_sds_port_update_viit_en
 
 	scic_sds_port_get_sas_address(this_port, &sas_address);
 
-	scu_port_viit_register_write(
-		this_port, initiator_sas_address_hi, sas_address.high);
-
-	scu_port_viit_register_write(
-		this_port, initiator_sas_address_lo, sas_address.low);
+	writel(sas_address.high,
+		&this_port->viit_registers->initiator_sas_address_hi);
+	writel(sas_address.low,
+		&this_port->viit_registers->initiator_sas_address_lo);
 
 	/* This value get cleared just in case its not already cleared */
-	scu_port_viit_register_write(
-		this_port, reserved, 0);
+	writel(0, &this_port->viit_registers->reserved);
 
 	/* We are required to update the status register last */
-	scu_port_viit_register_write(
-		this_port, status, (
-			SCU_VIIT_ENTRY_ID_VIIT
-			| SCU_VIIT_IPPT_INITIATOR
-			| ((1 << this_port->physical_port_index) << SCU_VIIT_ENTRY_LPVIE_SHIFT)
-			| SCU_VIIT_STATUS_ALL_VALID
-			)
-		);
+	writel(SCU_VIIT_ENTRY_ID_VIIT |
+	       SCU_VIIT_IPPT_INITIATOR |
+	       ((1 << this_port->physical_port_index) << SCU_VIIT_ENTRY_LPVIE_SHIFT) |
+	       SCU_VIIT_STATUS_ALL_VALID,
+	       &this_port->viit_registers->status);
 }
 
 /**
@@ -1059,10 +1053,12 @@ void scic_port_enable_broadcast_change_n
 	for (index = 0; index < SCI_MAX_PHYS; index++) {
 		phy = port->phy_table[index];
 		if (phy != NULL) {
-			register_value = SCU_SAS_LLCTL_READ(phy);
+			register_value =
+				readl(&phy->link_layer_registers->link_layer_control);
 
 			/* clear the bit by writing 1. */
-			SCU_SAS_LLCTL_WRITE(phy, register_value);
+			writel(register_value,
+				&phy->link_layer_registers->link_layer_control);
 		}
 	}
 }
@@ -1618,16 +1614,14 @@ scic_sds_port_ready_substate_handler_tab
  *
  * This method will susped the port task scheduler for this port object. none
  */
-static void scic_sds_port_suspend_port_task_scheduler(
-	struct scic_sds_port *this_port)
+static void
+scic_sds_port_suspend_port_task_scheduler(struct scic_sds_port *port)
 {
 	u32 pts_control_value;
 
-	pts_control_value = scu_port_task_scheduler_read(this_port, control);
-
+	pts_control_value = readl(&port->port_task_scheduler_registers->control);
 	pts_control_value |= SCU_PTSxCR_GEN_BIT(SUSPEND);
-
-	scu_port_task_scheduler_write(this_port, control, pts_control_value);
+	writel(pts_control_value, &port->port_task_scheduler_registers->control);
 }
 
 /**
@@ -1688,16 +1682,14 @@ static void scic_sds_port_abort_dummy_re
  *
  * This method will resume the port task scheduler for this port object. none
  */
-static void scic_sds_port_resume_port_task_scheduler(
-	struct scic_sds_port *this_port)
+static void
+scic_sds_port_resume_port_task_scheduler(struct scic_sds_port *port)
 {
 	u32 pts_control_value;
 
-	pts_control_value = scu_port_task_scheduler_read(this_port, control);
-
+	pts_control_value = readl(&port->port_task_scheduler_registers->control);
 	pts_control_value &= ~SCU_PTSxCR_GEN_BIT(SUSPEND);
-
-	scu_port_task_scheduler_write(this_port, control, pts_control_value);
+	writel(pts_control_value, &port->port_task_scheduler_registers->control);
 }
 
 /*
@@ -1763,10 +1755,11 @@ static void scic_sds_port_ready_substate
 	isci_port_ready(ihost, iport);
 
 	for (index = 0; index < SCI_MAX_PHYS; index++) {
-		if (sci_port->phy_table[index] != NULL)
-			scic_sds_port_write_phy_assignment(
-					sci_port,
-					sci_port->phy_table[index]);
+		if (sci_port->phy_table[index]) {
+			writel(sci_port->physical_port_index,
+				&sci_port->port_pe_configuration_register[
+					sci_port->phy_table[index]->phy_index]);
+		}
 	}
 
 	scic_sds_port_update_viit_entry(sci_port);
@@ -2308,16 +2301,14 @@ scic_sds_port_state_handler_table[SCI_BA
  * This method will enable the SCU Port Task Scheduler for this port object but
  * will leave the port task scheduler in a suspended state. none
  */
-static void scic_sds_port_enable_port_task_scheduler(
-	struct scic_sds_port *this_port)
+static void
+scic_sds_port_enable_port_task_scheduler(struct scic_sds_port *port)
 {
 	u32 pts_control_value;
 
-	pts_control_value = scu_port_task_scheduler_read(this_port, control);
-
+	pts_control_value = readl(&port->port_task_scheduler_registers->control);
 	pts_control_value |= SCU_PTSxCR_GEN_BIT(ENABLE) | SCU_PTSxCR_GEN_BIT(SUSPEND);
-
-	scu_port_task_scheduler_write(this_port, control, pts_control_value);
+	writel(pts_control_value, &port->port_task_scheduler_registers->control);
 }
 
 /**
@@ -2327,17 +2318,15 @@ static void scic_sds_port_enable_port_ta
  * This method will disable the SCU port task scheduler for this port object.
  * none
  */
-static void scic_sds_port_disable_port_task_scheduler(
-	struct scic_sds_port *this_port)
+static void
+scic_sds_port_disable_port_task_scheduler(struct scic_sds_port *port)
 {
 	u32 pts_control_value;
 
-	pts_control_value = scu_port_task_scheduler_read(this_port, control);
-
-	pts_control_value &= ~(SCU_PTSxCR_GEN_BIT(ENABLE)
-			       | SCU_PTSxCR_GEN_BIT(SUSPEND));
-
-	scu_port_task_scheduler_write(this_port, control, pts_control_value);
+	pts_control_value = readl(&port->port_task_scheduler_registers->control);
+	pts_control_value &=
+		~(SCU_PTSxCR_GEN_BIT(ENABLE) | SCU_PTSxCR_GEN_BIT(SUSPEND));
+	writel(pts_control_value, &port->port_task_scheduler_registers->control);
 }
 
 static void scic_sds_port_post_dummy_remote_node(struct scic_sds_port *sci_port)
@@ -2359,7 +2348,7 @@ static void scic_sds_port_post_dummy_rem
 	/* ensure hardware has seen the post rnc command and give it
 	 * ample time to act before sending the suspend
 	 */
-	SMU_ISR_READ(scic); /* flush */
+	readl(&scic->smu_registers->interrupt_status); /* flush */
 	udelay(10);
 
 	command = SCU_CONTEXT_COMMAND_POST_RNC_SUSPEND_TX_RX |
@@ -2384,7 +2373,7 @@ static void scic_sds_port_invalidate_dum
 	 * controller and give it ample time to act before posting the rnc
 	 * invalidate
 	 */
-	SMU_ISR_READ(scic); /* flush */
+	readl(&scic->smu_registers->interrupt_status); /* flush */
 	udelay(10);
 
 	command = SCU_CONTEXT_COMMAND_POST_RNC_INVALIDATE |
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_port.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_port.h	2011-03-28 00:35:42.529982343 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_port.h	2011-03-28 00:39:59.228982545 +0200
@@ -289,29 +289,6 @@ static inline void scic_sds_port_decreme
 		sci_port->started_request_count--;
 }
 
-/**
- * scic_sds_port_write_phy_assignment() -
- *
- * Helper macro to write the phys port assignment
- */
-#define scic_sds_port_write_phy_assignment(port, phy) \
-	SCU_PCSPExCR_WRITE(\
-		(port),	\
-		(phy)->phy_index, \
-		(port)->physical_port_index \
-		)
-
-/**
- * scic_sds_port_read_phy_assignment() -
- *
- * Helper macro to read the phys port assignment
- */
-#define scic_sds_port_read_phy_assignment(port, phy) \
-	SCU_PCSPExCR_READ(\
-		(port),	\
-		(phy)->phy_index \
-		)
-
 #define scic_sds_port_active_phy(port, phy) \
 	(((port)->active_phy_mask & (1 << (phy)->phy_index)) != 0)
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_phy.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_phy.c	2011-03-28 00:43:26.000980085 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_phy.c	2011-03-28 01:58:40.708982284 +0200
@@ -60,7 +60,6 @@
 #include "scic_phy.h"
 #include "scic_sds_controller.h"
 #include "scic_sds_phy.h"
-#include "scic_sds_phy_registers.h"
 #include "scic_sds_port.h"
 #include "scic_sds_remote_node_context.h"
 #include "sci_environment.h"
@@ -98,12 +97,13 @@ static enum sci_status scic_sds_phy_tran
 
 	this_phy->transport_layer_registers = transport_layer_registers;
 
-	SCU_STPTLDARNI_WRITE(this_phy, SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX);
+	writel(SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX,
+		&this_phy->transport_layer_registers->stp_rni);
 
 	/* Hardware team recommends that we enable the STP prefetch for all transports */
-	tl_control = SCU_TLCR_READ(this_phy);
+	tl_control = readl(&this_phy->transport_layer_registers->control);
 	tl_control |= SCU_TLCR_GEN_BIT(STP_WRITE_DATA_PREFETCH);
-	SCU_TLCR_WRITE(this_phy, tl_control);
+	writel(tl_control, &this_phy->transport_layer_registers->control);
 
 	return SCI_SUCCESS;
 }
@@ -135,30 +135,36 @@ scic_sds_phy_link_layer_initialization(s
 	/* Set our IDENTIFY frame data */
 	#define SCI_END_DEVICE 0x01
 
-	SCU_SAS_TIID_WRITE(sci_phy, (SCU_SAS_TIID_GEN_BIT(SMP_INITIATOR) |
-				     SCU_SAS_TIID_GEN_BIT(SSP_INITIATOR) |
-				     SCU_SAS_TIID_GEN_BIT(STP_INITIATOR) |
-				     SCU_SAS_TIID_GEN_BIT(DA_SATA_HOST) |
-				     SCU_SAS_TIID_GEN_VAL(DEVICE_TYPE, SCI_END_DEVICE)));
+	writel(SCU_SAS_TIID_GEN_BIT(SMP_INITIATOR) |
+	       SCU_SAS_TIID_GEN_BIT(SSP_INITIATOR) |
+	       SCU_SAS_TIID_GEN_BIT(STP_INITIATOR) |
+	       SCU_SAS_TIID_GEN_BIT(DA_SATA_HOST) |
+	       SCU_SAS_TIID_GEN_VAL(DEVICE_TYPE, SCI_END_DEVICE),
+	       &sci_phy->link_layer_registers->transmit_identification);
 
 	/* Write the device SAS Address */
-	SCU_SAS_TIDNH_WRITE(sci_phy, 0xFEDCBA98);
-	SCU_SAS_TIDNL_WRITE(sci_phy, phy_idx);
+	writel(0xFEDCBA98, &sci_phy->link_layer_registers->sas_device_name_high);
+	writel(phy_idx, &sci_phy->link_layer_registers->sas_device_name_low);
 
 	/* Write the source SAS Address */
-	SCU_SAS_TISSAH_WRITE(sci_phy, phy_oem->sas_address.high);
-	SCU_SAS_TISSAL_WRITE(sci_phy, phy_oem->sas_address.low);
+	writel(phy_oem->sas_address.high,
+		&sci_phy->link_layer_registers->source_sas_address_high);
+	writel(phy_oem->sas_address.low,
+		&sci_phy->link_layer_registers->source_sas_address_low);
 
 	/* Clear and Set the PHY Identifier */
-	SCU_SAS_TIPID_WRITE(sci_phy, 0x00000000);
-	SCU_SAS_TIPID_WRITE(sci_phy, SCU_SAS_TIPID_GEN_VALUE(ID, phy_idx));
+	writel(0, &sci_phy->link_layer_registers->identify_frame_phy_id);
+	writel(SCU_SAS_TIPID_GEN_VALUE(ID, phy_idx),
+		&sci_phy->link_layer_registers->identify_frame_phy_id);
 
 	/* Change the initial state of the phy configuration register */
-	phy_configuration = SCU_SAS_PCFG_READ(sci_phy);
+	phy_configuration =
+		readl(&sci_phy->link_layer_registers->phy_configuration);
 
 	/* Hold OOB state machine in reset */
 	phy_configuration |=  SCU_SAS_PCFG_GEN_BIT(OOB_RESET);
-	SCU_SAS_PCFG_WRITE(sci_phy, phy_configuration);
+	writel(phy_configuration,
+		&sci_phy->link_layer_registers->phy_configuration);
 
 	/* Configure the SNW capabilities */
 	phy_capabilities.u.all = 0;
@@ -188,13 +194,15 @@ scic_sds_phy_link_layer_initialization(s
 	if ((parity_count % 2) != 0)
 		phy_capabilities.u.bits.parity = 1;
 
-	SCU_SAS_PHYCAP_WRITE(sci_phy, phy_capabilities.u.all);
+	writel(phy_capabilities.u.all,
+		&sci_phy->link_layer_registers->phy_capabilities);
 
 	/* Set the enable spinup period but disable the ability to send
 	 * notify enable spinup
 	 */
-	SCU_SAS_ENSPINUP_WRITE(sci_phy, SCU_ENSPINUP_GEN_VAL(COUNT,
-			       phy_user->notify_enable_spin_up_insertion_frequency));
+	writel(SCU_ENSPINUP_GEN_VAL(COUNT,
+			phy_user->notify_enable_spin_up_insertion_frequency),
+		&sci_phy->link_layer_registers->notify_enable_spinup_control);
 
 	/* Write the ALIGN Insertion Ferequency for connected phy and
 	 * inpendent of connected state
@@ -205,10 +213,11 @@ scic_sds_phy_link_layer_initialization(s
 	clksm_value |= SCU_ALIGN_INSERTION_FREQUENCY_GEN_VAL(GENERAL,
 			phy_user->align_insertion_frequency);
 
-	SCU_SAS_CLKSM_WRITE(sci_phy, clksm_value);
+	writel(clksm_value, &sci_phy->link_layer_registers->clock_skew_management);
 
 	/* @todo Provide a way to write this register correctly */
-	scu_link_layer_register_write(sci_phy, afe_lookup_table_control, 0x02108421);
+	writel(0x02108421,
+		&sci_phy->link_layer_registers->afe_lookup_table_control);
 
 	llctl = SCU_SAS_LLCTL_GEN_VAL(NO_OUTBOUND_TASK_TIMEOUT,
 		(u8)scic->user_parameters.sds1.no_outbound_task_timeout);
@@ -225,8 +234,7 @@ scic_sds_phy_link_layer_initialization(s
 		break;
 	}
 	llctl |= SCU_SAS_LLCTL_GEN_VAL(MAX_LINK_RATE, link_rate);
-
-	scu_link_layer_register_write(sci_phy, link_layer_control, llctl);
+	writel(llctl, &sci_phy->link_layer_registers->link_layer_control);
 
 	if (is_a0() || is_a2()) {
 		/* Program the max ARB time for the PHY to 700us so we inter-operate with
@@ -234,16 +242,15 @@ scic_sds_phy_link_layer_initialization(s
 		 * many breaks.  This time value will guarantee that the initiator PHY will
 		 * generate the break.
 		 */
-		scu_link_layer_register_write(sci_phy,
-					      maximum_arbitration_wait_timer_timeout,
-					      SCIC_SDS_PHY_MAX_ARBITRATION_WAIT_TIME);
+		writel(SCIC_SDS_PHY_MAX_ARBITRATION_WAIT_TIME,
+			&sci_phy->link_layer_registers->maximum_arbitration_wait_timer_timeout);
 	}
 
 	/*
 	 * Set the link layer hang detection to 500ms (0x1F4) from its default
-	 * value of 128ms.  Max value is 511 ms. */
-	scu_link_layer_register_write(sci_phy, link_layer_hang_detection_timeout,
-				      0x1F4);
+	 * value of 128ms.  Max value is 511 ms.
+	 */
+	writel(0x1F4, &sci_phy->link_layer_registers->link_layer_hang_detection_timeout);
 
 	/* We can exit the initial state to the stopped state */
 	sci_base_state_machine_change_state(&sci_phy->parent.state_machine,
@@ -367,15 +374,15 @@ void scic_sds_phy_setup_transport(
 {
 	u32 tl_control;
 
-	SCU_STPTLDARNI_WRITE(this_phy, device_id);
+	writel(device_id, &this_phy->transport_layer_registers->stp_rni);
 
 	/*
 	 * The read should guarantee that the first write gets posted
 	 * before the next write
 	 */
-	tl_control = SCU_TLCR_READ(this_phy);
+	tl_control = readl(&this_phy->transport_layer_registers->control);
 	tl_control |= SCU_TLCR_GEN_BIT(CLEAR_TCI_NCQ_MAPPING_TABLE);
-	SCU_TLCR_WRITE(this_phy, tl_control);
+	writel(tl_control, &this_phy->transport_layer_registers->control);
 }
 
 /**
@@ -390,9 +397,12 @@ static void scic_sds_phy_suspend(
 {
 	u32 scu_sas_pcfg_value;
 
-	scu_sas_pcfg_value = SCU_SAS_PCFG_READ(this_phy);
+	scu_sas_pcfg_value =
+		readl(&this_phy->link_layer_registers->phy_configuration);
 	scu_sas_pcfg_value |= SCU_SAS_PCFG_GEN_BIT(SUSPEND_PROTOCOL_ENGINE);
-	SCU_SAS_PCFG_WRITE(this_phy, scu_sas_pcfg_value);
+	writel(scu_sas_pcfg_value,
+		&this_phy->link_layer_registers->phy_configuration);
+
 	scic_sds_phy_setup_transport(this_phy, SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX);
 }
 
@@ -408,11 +418,11 @@ void scic_sds_phy_resume(
 {
 	u32 scu_sas_pcfg_value;
 
-	scu_sas_pcfg_value = SCU_SAS_PCFG_READ(this_phy);
-
+	scu_sas_pcfg_value =
+		readl(&this_phy->link_layer_registers->phy_configuration);
 	scu_sas_pcfg_value &= ~SCU_SAS_PCFG_GEN_BIT(SUSPEND_PROTOCOL_ENGINE);
-
-	SCU_SAS_PCFG_WRITE(this_phy, scu_sas_pcfg_value);
+	writel(scu_sas_pcfg_value,
+		&this_phy->link_layer_registers->phy_configuration);
 }
 
 /**
@@ -427,8 +437,8 @@ void scic_sds_phy_get_sas_address(
 	struct scic_sds_phy *this_phy,
 	struct sci_sas_address *sas_address)
 {
-	sas_address->high = SCU_SAS_TISSAH_READ(this_phy);
-	sas_address->low  = SCU_SAS_TISSAL_READ(this_phy);
+	sas_address->high = readl(&this_phy->link_layer_registers->source_sas_address_high);
+	sas_address->low = readl(&this_phy->link_layer_registers->source_sas_address_low);
 }
 
 /**
@@ -460,7 +470,10 @@ void scic_sds_phy_get_protocols(
 	struct scic_sds_phy *this_phy,
 	struct sci_sas_identify_address_frame_protocols *protocols)
 {
-	protocols->u.all = (u16)(SCU_SAS_TIID_READ(this_phy) & 0x0000FFFF);
+	protocols->u.all =
+		(u16)(readl(&this_phy->
+			link_layer_registers->transmit_identification) &
+				0x0000FFFF);
 }
 
 /**
@@ -589,8 +602,8 @@ enum sci_status scic_sas_phy_get_propert
 			sizeof(struct sci_sas_identify_address_frame)
 			);
 
-		properties->received_capabilities.u.all
-			= SCU_SAS_RECPHYCAP_READ(sci_phy);
+		properties->received_capabilities.u.all =
+			readl(&sci_phy->link_layer_registers->receive_phycap);
 
 		return SCI_SUCCESS;
 	}
@@ -639,9 +652,11 @@ static void scic_sds_phy_start_sas_link_
 {
 	u32 phy_control;
 
-	phy_control = SCU_SAS_PCFG_READ(this_phy);
+	phy_control =
+		readl(&this_phy->link_layer_registers->phy_configuration);
 	phy_control |= SCU_SAS_PCFG_GEN_BIT(SATA_SPINUP_HOLD);
-	SCU_SAS_PCFG_WRITE(this_phy, phy_control);
+	writel(phy_control,
+		&this_phy->link_layer_registers->phy_configuration);
 
 	sci_base_state_machine_change_state(
 		&this_phy->starting_substate_machine,
@@ -1331,9 +1346,9 @@ static enum sci_status scic_sds_phy_star
 {
 	u32 enable_spinup;
 
-	enable_spinup = SCU_SAS_ENSPINUP_READ(sci_phy);
+	enable_spinup = readl(&sci_phy->link_layer_registers->notify_enable_spinup_control);
 	enable_spinup |= SCU_ENSPINUP_GEN_BIT(ENABLE);
-	SCU_SAS_ENSPINUP_WRITE(sci_phy, enable_spinup);
+	writel(enable_spinup, &sci_phy->link_layer_registers->notify_enable_spinup_control);
 
 	/* Change state to the final state this substate machine has run to completion */
 	sci_base_state_machine_change_state(&sci_phy->starting_substate_machine,
@@ -1357,16 +1372,19 @@ static enum sci_status scic_sds_phy_star
 	u32 scu_sas_pcfg_value;
 
 	/* Release the spinup hold state and reset the OOB state machine */
-	scu_sas_pcfg_value = SCU_SAS_PCFG_READ(sci_phy);
+	scu_sas_pcfg_value =
+		readl(&sci_phy->link_layer_registers->phy_configuration);
 	scu_sas_pcfg_value &=
 		~(SCU_SAS_PCFG_GEN_BIT(SATA_SPINUP_HOLD) | SCU_SAS_PCFG_GEN_BIT(OOB_ENABLE));
 	scu_sas_pcfg_value |= SCU_SAS_PCFG_GEN_BIT(OOB_RESET);
-	SCU_SAS_PCFG_WRITE(sci_phy, scu_sas_pcfg_value);
+	writel(scu_sas_pcfg_value,
+		&sci_phy->link_layer_registers->phy_configuration);
 
 	/* Now restart the OOB operation */
 	scu_sas_pcfg_value &= ~SCU_SAS_PCFG_GEN_BIT(OOB_RESET);
 	scu_sas_pcfg_value |= SCU_SAS_PCFG_GEN_BIT(OOB_ENABLE);
-	SCU_SAS_PCFG_WRITE(sci_phy, scu_sas_pcfg_value);
+	writel(scu_sas_pcfg_value,
+		&sci_phy->link_layer_registers->phy_configuration);
 
 	/* Change state to the final state this substate machine has run to completion */
 	sci_base_state_machine_change_state(&sci_phy->starting_substate_machine,
@@ -2120,18 +2138,20 @@ static void scu_link_layer_stop_protocol
 	u32 enable_spinup_value;
 
 	/* Suspend the protocol engine and place it in a sata spinup hold state */
-	scu_sas_pcfg_value  = SCU_SAS_PCFG_READ(this_phy);
+	scu_sas_pcfg_value =
+		readl(&this_phy->link_layer_registers->phy_configuration);
 	scu_sas_pcfg_value |= (
 		SCU_SAS_PCFG_GEN_BIT(OOB_RESET)
 		| SCU_SAS_PCFG_GEN_BIT(SUSPEND_PROTOCOL_ENGINE)
 		| SCU_SAS_PCFG_GEN_BIT(SATA_SPINUP_HOLD)
 		);
-	SCU_SAS_PCFG_WRITE(this_phy, scu_sas_pcfg_value);
+	writel(scu_sas_pcfg_value,
+		&this_phy->link_layer_registers->phy_configuration);
 
 	/* Disable the notify enable spinup primitives */
-	enable_spinup_value = SCU_SAS_ENSPINUP_READ(this_phy);
+	enable_spinup_value = readl(&this_phy->link_layer_registers->notify_enable_spinup_control);
 	enable_spinup_value &= ~SCU_ENSPINUP_GEN_BIT(ENABLE);
-	SCU_SAS_ENSPINUP_WRITE(this_phy, enable_spinup_value);
+	writel(enable_spinup_value, &this_phy->link_layer_registers->notify_enable_spinup_control);
 }
 
 /**
@@ -2144,12 +2164,13 @@ static void scu_link_layer_start_oob(
 {
 	u32 scu_sas_pcfg_value;
 
-	scu_sas_pcfg_value = SCU_SAS_PCFG_READ(this_phy);
+	scu_sas_pcfg_value =
+		readl(&this_phy->link_layer_registers->phy_configuration);
 	scu_sas_pcfg_value |= SCU_SAS_PCFG_GEN_BIT(OOB_ENABLE);
 	scu_sas_pcfg_value &=
 		~(SCU_SAS_PCFG_GEN_BIT(OOB_RESET) | SCU_SAS_PCFG_GEN_BIT(HARD_RESET));
-
-	SCU_SAS_PCFG_WRITE(this_phy, scu_sas_pcfg_value);
+	writel(scu_sas_pcfg_value,
+		&this_phy->link_layer_registers->phy_configuration);
 }
 
 /**
@@ -2168,15 +2189,18 @@ static void scu_link_layer_tx_hard_reset
 	/*
 	 * SAS Phys must wait for the HARD_RESET_TX event notification to transition
 	 * to the starting state. */
-	phy_configuration_value = SCU_SAS_PCFG_READ(this_phy);
+	phy_configuration_value =
+		readl(&this_phy->link_layer_registers->phy_configuration);
 	phy_configuration_value |=
 		(SCU_SAS_PCFG_GEN_BIT(HARD_RESET) | SCU_SAS_PCFG_GEN_BIT(OOB_RESET));
-	SCU_SAS_PCFG_WRITE(this_phy, phy_configuration_value);
+	writel(phy_configuration_value,
+		&this_phy->link_layer_registers->phy_configuration);
 
 	/* Now take the OOB state machine out of reset */
 	phy_configuration_value |= SCU_SAS_PCFG_GEN_BIT(OOB_ENABLE);
 	phy_configuration_value &= ~SCU_SAS_PCFG_GEN_BIT(OOB_RESET);
-	SCU_SAS_PCFG_WRITE(this_phy, phy_configuration_value);
+	writel(phy_configuration_value,
+		&this_phy->link_layer_registers->phy_configuration);
 }
 
 /*
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c	2011-03-28 01:40:43.704981485 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c	2011-03-28 01:41:14.336982622 +0200
@@ -317,8 +317,8 @@ enum sci_status scic_sds_unsolicited_fra
  * This method returns an indication to the caller as to whether the
  * unsolicited frame get pointer should be updated. true This value indicates
  * the unsolicited frame get pointer should be updated (i.e. write
- * SCU_UFQGP_WRITE). false This value indicates the get pointer should not be
- * updated.
+ * scu_registers->sdma.unsolicited_frame_get_pointer).
+ * false This value indicates the get pointer should not be updated.
  */
 bool scic_sds_unsolicited_frame_control_release_frame(
 	struct scic_sds_unsolicited_frame_control *uf_control,
