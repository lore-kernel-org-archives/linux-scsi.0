From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/21] qla2xxx: Cruft cleanup of functions and structures.
Date: Thu,  3 Apr 2008 13:13:20 -0700
Message-ID: <1207253612-15538-9-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761787AbYDCUNq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:46 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Strip unused (DEBUG-ONLY) enabled functions, inlines, useless
wrappers, and unused DPC flags from the code.  Another step in
the migration towards a cleaner (less-crusty) driver.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |  122 -------------------------------------
 drivers/scsi/qla2xxx/qla_dbg.h    |   13 ----
 drivers/scsi/qla2xxx/qla_def.h    |    2 -
 drivers/scsi/qla2xxx/qla_gbl.h    |    4 -
 drivers/scsi/qla2xxx/qla_gs.c     |    6 --
 drivers/scsi/qla2xxx/qla_init.c   |   41 ------------
 drivers/scsi/qla2xxx/qla_inline.h |   85 -------------------------
 drivers/scsi/qla2xxx/qla_iocb.c   |    3 -
 drivers/scsi/qla2xxx/qla_isr.c    |   90 ---------------------------
 drivers/scsi/qla2xxx/qla_mid.c    |    2 -
 drivers/scsi/qla2xxx/qla_os.c     |   62 +------------------
 11 files changed, 2 insertions(+), 428 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 83dd68b..9d12d9f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1410,125 +1410,3 @@ qla2x00_dump_buffer(uint8_t * b, uint32_t size)
 	if (cnt % 16)
 		printk("\n");
 }
-
-/**************************************************************************
- *   qla2x00_print_scsi_cmd
- *	 Dumps out info about the scsi cmd and srb.
- *   Input
- *	 cmd : struct scsi_cmnd
- **************************************************************************/
-void
-qla2x00_print_scsi_cmd(struct scsi_cmnd * cmd)
-{
-	int i;
-	struct scsi_qla_host *ha;
-	srb_t *sp;
-
-	ha = shost_priv(cmd->device->host);
-
-	sp = (srb_t *) cmd->SCp.ptr;
-	printk("SCSI Command @=0x%p, Handle=0x%p\n", cmd, cmd->host_scribble);
-	printk("  chan=0x%02x, target=0x%02x, lun=0x%02x, cmd_len=0x%02x\n",
-	    cmd->device->channel, cmd->device->id, cmd->device->lun,
-	    cmd->cmd_len);
-	printk(" CDB: ");
-	for (i = 0; i < cmd->cmd_len; i++) {
-		printk("0x%02x ", cmd->cmnd[i]);
-	}
-	printk("\n  seg_cnt=%d, allowed=%d, retries=%d\n",
-	       scsi_sg_count(cmd), cmd->allowed, cmd->retries);
-	printk("  request buffer=0x%p, request buffer len=0x%x\n",
-	       scsi_sglist(cmd), scsi_bufflen(cmd));
-	printk("  tag=%d, transfersize=0x%x\n",
-	    cmd->tag, cmd->transfersize);
-	printk("  serial_number=%lx, SP=%p\n", cmd->serial_number, sp);
-	printk("  data direction=%d\n", cmd->sc_data_direction);
-
-	if (!sp)
-		return;
-
-	printk("  sp flags=0x%x\n", sp->flags);
-}
-
-#if defined(QL_DEBUG_ROUTINES)
-/*
- * qla2x00_formatted_dump_buffer
- *       Prints string plus buffer.
- *
- * Input:
- *       string  = Null terminated string (no newline at end).
- *       buffer  = buffer address.
- *       wd_size = word size 8, 16, 32 or 64 bits
- *       count   = number of words.
- */
-void
-qla2x00_formatted_dump_buffer(char *string, uint8_t * buffer,
-				uint8_t wd_size, uint32_t count)
-{
-	uint32_t cnt;
-	uint16_t *buf16;
-	uint32_t *buf32;
-
-	if (strcmp(string, "") != 0)
-		printk("%s\n",string);
-
-	switch (wd_size) {
-		case 8:
-			printk(" 0    1    2    3    4    5    6    7    "
-				"8    9    Ah   Bh   Ch   Dh   Eh   Fh\n");
-			printk("-----------------------------------------"
-				"-------------------------------------\n");
-
-			for (cnt = 1; cnt <= count; cnt++, buffer++) {
-				printk("%02x",*buffer);
-				if (cnt % 16 == 0)
-					printk("\n");
-				else
-					printk("  ");
-			}
-			if (cnt % 16 != 0)
-				printk("\n");
-			break;
-		case 16:
-			printk("   0      2      4      6      8      Ah "
-				"	Ch     Eh\n");
-			printk("-----------------------------------------"
-				"-------------\n");
-
-			buf16 = (uint16_t *) buffer;
-			for (cnt = 1; cnt <= count; cnt++, buf16++) {
-				printk("%4x",*buf16);
-
-				if (cnt % 8 == 0)
-					printk("\n");
-				else if (*buf16 < 10)
-					printk("   ");
-				else
-					printk("  ");
-			}
-			if (cnt % 8 != 0)
-				printk("\n");
-			break;
-		case 32:
-			printk("       0          4          8          Ch\n");
-			printk("------------------------------------------\n");
-
-			buf32 = (uint32_t *) buffer;
-			for (cnt = 1; cnt <= count; cnt++, buf32++) {
-				printk("%8x", *buf32);
-
-				if (cnt % 4 == 0)
-					printk("\n");
-				else if (*buf32 < 10)
-					printk("   ");
-				else
-					printk("  ");
-			}
-			if (cnt % 4 != 0)
-				printk("\n");
-			break;
-		default:
-			break;
-	}
-}
-#endif
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index c30f2fa..2a4043b 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -22,19 +22,6 @@
 /* #define QL_DEBUG_LEVEL_13 */ /* Output fdmi function trace msgs */
 /* #define QL_DEBUG_LEVEL_14 */ /* Output RSCN trace msgs */
 /* #define QL_DEBUG_LEVEL_15 */ /* Output NPIV trace msgs */
-/*
- *  Local Macro Definitions.
- */
-#if defined(QL_DEBUG_LEVEL_1)  || defined(QL_DEBUG_LEVEL_2) || \
-    defined(QL_DEBUG_LEVEL_3)  || defined(QL_DEBUG_LEVEL_4) || \
-    defined(QL_DEBUG_LEVEL_5)  || defined(QL_DEBUG_LEVEL_6) || \
-    defined(QL_DEBUG_LEVEL_7)  || defined(QL_DEBUG_LEVEL_8) || \
-    defined(QL_DEBUG_LEVEL_9)  || defined(QL_DEBUG_LEVEL_10) || \
-    defined(QL_DEBUG_LEVEL_11) || defined(QL_DEBUG_LEVEL_12) || \
-    defined(QL_DEBUG_LEVEL_13) || defined(QL_DEBUG_LEVEL_14) || \
-    defined(QL_DEBUG_LEVEL_15)
-    #define QL_DEBUG_ROUTINES
-#endif
 
 /*
 * Macros use for debugging the driver.
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 13ffeda..047973f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2449,8 +2449,6 @@ typedef struct scsi_qla_host {
 #define  MBX_TIMEDOUT		BIT_5
 #define  MBX_ACCESS_TIMEDOUT	BIT_6
 
-	mbx_cmd_t 	mc;
-
 	/* Basic firmware related information. */
 	uint16_t	fw_major_version;
 	uint16_t	fw_minor_version;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 276bd26..10c3f90 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -38,9 +38,6 @@ extern int qla2x00_loop_resync(scsi_qla_host_t *);
 extern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *);
 extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
-extern void qla2x00_restart_queues(scsi_qla_host_t *, uint8_t);
-
-extern void qla2x00_rescan_fcports(scsi_qla_host_t *);
 extern void qla2x00_update_fcports(scsi_qla_host_t *);
 
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
@@ -312,7 +309,6 @@ extern void qla24xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla25xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
-extern void qla2x00_print_scsi_cmd(struct scsi_cmnd *);
 
 /*
  * Global Function Prototypes in qla_gs.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index ea8a7d3..e6578ce 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -6,12 +6,6 @@
  */
 #include "qla_def.h"
 
-static inline struct ct_sns_req *
-qla2x00_prep_ct_req(struct ct_sns_req *, uint16_t, uint16_t);
-
-static inline struct sns_cmd_pkt *
-qla2x00_prep_sns_cmd(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
-
 static int qla2x00_sns_ga_nxt(scsi_qla_host_t *, fc_port_t *);
 static int qla2x00_sns_gid_pt(scsi_qla_host_t *, sw_info_t *);
 static int qla2x00_sns_gpn_id(scsi_qla_host_t *, sw_info_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e9a7c2d..d429e2f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -15,14 +15,6 @@
 #include <asm/prom.h>
 #endif
 
-/* XXX(hch): this is ugly, but we don't want to pull in exioctl.h */
-#ifndef EXT_IS_LUN_BIT_SET
-#define EXT_IS_LUN_BIT_SET(P,L) \
-    (((P)->mask[L/8] & (0x80 >> (L%8)))?1:0)
-#define EXT_SET_LUN_BIT(P,L) \
-    ((P)->mask[L/8] |= (0x80 >> (L%8)))
-#endif
-
 /*
 *  QLogic ISP2x00 Hardware Support Function Prototypes.
 */
@@ -2176,20 +2168,6 @@ cleanup_allocation:
 }
 
 static void
-qla2x00_probe_for_all_luns(scsi_qla_host_t *ha)
-{
-	fc_port_t	*fcport;
-
-	qla2x00_mark_all_devices_lost(ha, 0);
- 	list_for_each_entry(fcport, &ha->fcports, list) {
-		if (fcport->port_type != FCT_TARGET)
-			continue;
-
-		qla2x00_update_fcport(ha, fcport);
-	}
-}
-
-static void
 qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
 #define LS_UNKNOWN      2
@@ -3200,25 +3178,6 @@ qla2x00_loop_resync(scsi_qla_host_t *ha)
 }
 
 void
-qla2x00_rescan_fcports(scsi_qla_host_t *ha)
-{
-	int rescan_done;
-	fc_port_t *fcport;
-
-	rescan_done = 0;
-	list_for_each_entry(fcport, &ha->fcports, list) {
-		if ((fcport->flags & FCF_RESCAN_NEEDED) == 0)
-			continue;
-
-		qla2x00_update_fcport(ha, fcport);
-		fcport->flags &= ~FCF_RESCAN_NEEDED;
-
-		rescan_done = 1;
-	}
-	qla2x00_probe_for_all_luns(ha);
-}
-
-void
 qla2x00_update_fcports(scsi_qla_host_t *ha)
 {
 	fc_port_t *fcport;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 3e57a3e..e9bae27 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -5,7 +5,6 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 
-static __inline__ uint16_t qla2x00_debounce_register(volatile uint16_t __iomem *);
 /*
  * qla2x00_debounce_register
  *      Debounce register.
@@ -32,94 +31,12 @@ qla2x00_debounce_register(volatile uint16_t __iomem *addr)
 	return (first);
 }
 
-static __inline__ int qla2x00_normalize_dma_addr(
-    dma_addr_t *e_addr,  uint32_t *e_len,
-    dma_addr_t *ne_addr, uint32_t *ne_len);
-
-/**
- * qla2x00_normalize_dma_addr() - Normalize an DMA address.
- * @e_addr: Raw DMA address
- * @e_len: Raw DMA length
- * @ne_addr: Normalized second DMA address
- * @ne_len: Normalized second DMA length
- *
- * If the address does not span a 4GB page boundary, the contents of @ne_addr
- * and @ne_len are undefined.  @e_len is updated to reflect a normalization.
- *
- * Example:
- *
- * 	ffffabc0ffffeeee	(e_addr) start of DMA address
- * 	0000000020000000	(e_len)  length of DMA transfer
- *	ffffabc11fffeeed	end of DMA transfer
- *
- * Is the 4GB boundary crossed?
- *
- * 	ffffabc0ffffeeee	(e_addr)
- *	ffffabc11fffeeed	(e_addr + e_len - 1)
- *	00000001e0000003	((e_addr ^ (e_addr + e_len - 1))
- *	0000000100000000	((e_addr ^ (e_addr + e_len - 1)) & ~(0xffffffff)
- *
- * Compute start of second DMA segment:
- *
- * 	ffffabc0ffffeeee	(e_addr)
- *	ffffabc1ffffeeee	(0x100000000 + e_addr)
- *	ffffabc100000000	(0x100000000 + e_addr) & ~(0xffffffff)
- *	ffffabc100000000	(ne_addr)
- *
- * Compute length of second DMA segment:
- *
- *	00000000ffffeeee	(e_addr & 0xffffffff)
- *	0000000000001112	(0x100000000 - (e_addr & 0xffffffff))
- *	000000001fffeeee	(e_len - (0x100000000 - (e_addr & 0xffffffff))
- *	000000001fffeeee	(ne_len)
- *
- * Adjust length of first DMA segment
- *
- * 	0000000020000000	(e_len)
- *	0000000000001112	(e_len - ne_len)
- *	0000000000001112	(e_len)
- *
- * Returns non-zero if the specified address was normalized, else zero.
- */
-static __inline__ int
-qla2x00_normalize_dma_addr(
-    dma_addr_t *e_addr,  uint32_t *e_len,
-    dma_addr_t *ne_addr, uint32_t *ne_len)
-{
-	int normalized;
-
-	normalized = 0;
-	if ((*e_addr ^ (*e_addr + *e_len - 1)) & ~(0xFFFFFFFFULL)) {
-		/* Compute normalized crossed address and len */
-		*ne_addr = (0x100000000ULL + *e_addr) & ~(0xFFFFFFFFULL);
-		*ne_len = *e_len - (0x100000000ULL - (*e_addr & 0xFFFFFFFFULL));
-		*e_len -= *ne_len;
-
-		normalized++;
-	}
-	return (normalized);
-}
-
-static __inline__ void qla2x00_poll(scsi_qla_host_t *);
 static inline void
 qla2x00_poll(scsi_qla_host_t *ha)
 {
 	ha->isp_ops->intr_handler(0, ha);
 }
 
-static __inline__ void qla2x00_check_fabric_devices(scsi_qla_host_t *);
-/*
- * This routine will wait for fabric devices for
- * the reset delay.
- */
-static __inline__ void qla2x00_check_fabric_devices(scsi_qla_host_t *ha)
-{
-	uint16_t	fw_state;
-
-	qla2x00_get_firmware_state(ha, &fw_state);
-}
-
-static __inline__ scsi_qla_host_t * to_qla_parent(scsi_qla_host_t *);
 static __inline__ scsi_qla_host_t *
 to_qla_parent(scsi_qla_host_t *ha)
 {
@@ -152,7 +69,6 @@ qla2x00_issue_marker(scsi_qla_host_t *ha, int ha_locked)
 	return (QLA_SUCCESS);
 }
 
-static inline uint8_t *host_to_fcp_swap(uint8_t *, uint32_t);
 static inline uint8_t *
 host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
 {
@@ -166,7 +82,6 @@ host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
        return fcp;
 }
 
-static inline int qla2x00_is_reserved_id(scsi_qla_host_t *, uint16_t);
 static inline int
 qla2x00_is_reserved_id(scsi_qla_host_t *ha, uint16_t loop_id)
 {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 9192ad5..5489d50 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,9 +11,6 @@
 
 #include <scsi/scsi_tcq.h>
 
-static inline uint16_t qla2x00_get_cmd_direction(struct scsi_cmnd *cmd);
-static inline cont_entry_t *qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *);
-static inline cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *);
 static request_t *qla2x00_req_pkt(scsi_qla_host_t *ha);
 static void qla2x00_isp_cmd(scsi_qla_host_t *ha);
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0884642..e886000 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -14,9 +14,6 @@ static void qla2x00_process_completed_request(struct scsi_qla_host *, uint32_t);
 static void qla2x00_status_entry(scsi_qla_host_t *, void *);
 static void qla2x00_status_cont_entry(scsi_qla_host_t *, sts_cont_entry_t *);
 static void qla2x00_error_entry(scsi_qla_host_t *, sts_entry_t *);
-static void qla2x00_ms_entry(scsi_qla_host_t *, ms_iocb_entry_t *);
-
-static void qla24xx_ms_entry(scsi_qla_host_t *, struct ct_entry_24xx *);
 
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
@@ -809,9 +806,6 @@ qla2x00_process_response_queue(struct scsi_qla_host *ha)
 		case STATUS_CONT_TYPE:
 			qla2x00_status_cont_entry(ha, (sts_cont_entry_t *)pkt);
 			break;
-		case MS_IOCB_TYPE:
-			qla2x00_ms_entry(ha, (ms_iocb_entry_t *)pkt);
-			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
@@ -1346,44 +1340,6 @@ qla2x00_error_entry(scsi_qla_host_t *ha, sts_entry_t *pkt)
 }
 
 /**
- * qla2x00_ms_entry() - Process a Management Server entry.
- * @ha: SCSI driver HA context
- * @index: Response queue out pointer
- */
-static void
-qla2x00_ms_entry(scsi_qla_host_t *ha, ms_iocb_entry_t *pkt)
-{
-	srb_t          *sp;
-
-	DEBUG3(printk("%s(%ld): pkt=%p pkthandle=%d.\n",
-	    __func__, ha->host_no, pkt, pkt->handle1));
-
-	/* Validate handle. */
- 	if (pkt->handle1 < MAX_OUTSTANDING_COMMANDS)
- 		sp = ha->outstanding_cmds[pkt->handle1];
-	else
-		sp = NULL;
-
-	if (sp == NULL) {
-		DEBUG2(printk("scsi(%ld): MS entry - invalid handle\n",
-		    ha->host_no));
-		qla_printk(KERN_WARNING, ha, "MS entry - invalid handle\n");
-
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		return;
-	}
-
-	CMD_COMPL_STATUS(sp->cmd) = le16_to_cpu(pkt->status);
-	CMD_ENTRY_STATUS(sp->cmd) = pkt->entry_status;
-
-	/* Free outstanding command slot. */
-	ha->outstanding_cmds[pkt->handle1] = NULL;
-
-	qla2x00_sp_compl(ha, sp);
-}
-
-
-/**
  * qla24xx_mbx_completion() - Process mailbox command completions.
  * @ha: SCSI driver HA context
  * @mb0: Mailbox0 register
@@ -1455,9 +1411,6 @@ qla24xx_process_response_queue(struct scsi_qla_host *ha)
 		case STATUS_CONT_TYPE:
 			qla2x00_status_cont_entry(ha, (sts_cont_entry_t *)pkt);
 			break;
-		case MS_IOCB_TYPE:
-			qla24xx_ms_entry(ha, (struct ct_entry_24xx *)pkt);
-			break;
 		case VP_RPT_ID_IOCB_TYPE:
 			qla24xx_report_id_acquisition(ha,
 			    (struct vp_rpt_id_entry_24xx *)pkt);
@@ -1619,49 +1572,6 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/**
- * qla24xx_ms_entry() - Process a Management Server entry.
- * @ha: SCSI driver HA context
- * @index: Response queue out pointer
- */
-static void
-qla24xx_ms_entry(scsi_qla_host_t *ha, struct ct_entry_24xx *pkt)
-{
-	srb_t          *sp;
-
-	DEBUG3(printk("%s(%ld): pkt=%p pkthandle=%d.\n",
-	    __func__, ha->host_no, pkt, pkt->handle));
-
-	DEBUG9(printk("%s: ct pkt dump:\n", __func__));
-	DEBUG9(qla2x00_dump_buffer((void *)pkt, sizeof(struct ct_entry_24xx)));
-
-	/* Validate handle. */
- 	if (pkt->handle < MAX_OUTSTANDING_COMMANDS)
- 		sp = ha->outstanding_cmds[pkt->handle];
-	else
-		sp = NULL;
-
-	if (sp == NULL) {
-		DEBUG2(printk("scsi(%ld): MS entry - invalid handle\n",
-		    ha->host_no));
-		DEBUG10(printk("scsi(%ld): MS entry - invalid handle\n",
-		    ha->host_no));
-		qla_printk(KERN_WARNING, ha, "MS entry - invalid handle %d\n",
-		    pkt->handle);
-
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		return;
-	}
-
-	CMD_COMPL_STATUS(sp->cmd) = le16_to_cpu(pkt->comp_status);
-	CMD_ENTRY_STATUS(sp->cmd) = pkt->entry_status;
-
-	/* Free outstanding command slot. */
-	ha->outstanding_cmds[pkt->handle] = NULL;
-
-	qla2x00_sp_compl(ha, sp);
-}
-
 static irqreturn_t
 qla24xx_msix_rsp_q(int irq, void *dev_id)
 {
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 5305ec1..9f48cd4 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -16,8 +16,6 @@
 #include <scsi/scsicam.h>
 #include <linux/delay.h>
 
-void qla2x00_vp_stop_timer(scsi_qla_host_t *);
-
 void
 qla2x00_vp_stop_timer(scsi_qla_host_t *vha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3d29041..c0f6f66 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -26,9 +26,6 @@ char qla2x00_version_str[40];
  */
 static struct kmem_cache *srb_cachep;
 
-/*
- * Ioctl related information.
- */
 int num_hosts;
 int ql2xlogintimeout = 20;
 module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
@@ -105,7 +102,6 @@ static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
-static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
@@ -685,7 +681,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 		DEBUG2(printk("%s(%ld): aborting sp %p from RISC. pid=%ld.\n",
 		    __func__, ha->host_no, sp, serial));
-		DEBUG3(qla2x00_print_scsi_cmd(cmd));
 
 		spin_unlock_irqrestore(&pha->hardware_lock, flags);
 		if (ha->isp_ops->abort_command(ha, sp)) {
@@ -814,7 +809,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		goto eh_dev_reset_done;
 
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
-		if (qla2x00_device_reset(ha, fcport) == 0)
+		if (ha->isp_ops->abort_target(fcport) == 0)
 			ret = SUCCESS;
 	} else {
 		DEBUG2(printk(KERN_INFO
@@ -1071,7 +1066,7 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
-			ret = qla2x00_device_reset(ha, fcport);
+			ret = ha->isp_ops->abort_target(fcport);
 			if (ret != QLA_SUCCESS) {
 				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
 				    "target_reset=%d d_id=%x.\n", __func__,
@@ -1086,26 +1081,6 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 	return QLA_SUCCESS;
 }
 
-/*
- * qla2x00_device_reset
- *	Issue bus device reset message to the target.
- *
- * Input:
- *	ha = adapter block pointer.
- *	t = SCSI ID.
- *	TARGET_QUEUE_LOCK must be released.
- *	ADAPTER_STATE_LOCK must be released.
- *
- * Context:
- *	Kernel context.
- */
-static int
-qla2x00_device_reset(scsi_qla_host_t *ha, fc_port_t *reset_fcport)
-{
-	/* Abort Target command will clear Reservation */
-	return ha->isp_ops->abort_target(reset_fcport);
-}
-
 void
 qla2x00_abort_all_cmds(scsi_qla_host_t *ha, int res)
 {
@@ -2378,12 +2353,6 @@ qla2x00_do_dpc(void *data)
 		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags))
 			qla2x00_update_fcports(ha);
 
-		if (test_and_clear_bit(LOOP_RESET_NEEDED, &ha->dpc_flags)) {
-			DEBUG(printk("scsi(%ld): dpc: sched loop_reset()\n",
-			    ha->host_no));
-			qla2x00_loop_reset(ha);
-		}
-
 		if (test_and_clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) &&
 		    (!(test_and_set_bit(RESET_ACTIVE, &ha->dpc_flags)))) {
 
@@ -2454,19 +2423,6 @@ qla2x00_do_dpc(void *data)
 			    ha->host_no));
 		}
 
-		if ((test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags)) &&
-		    atomic_read(&ha->loop_state) != LOOP_DOWN) {
-
-			clear_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags);
-			DEBUG(printk("scsi(%ld): qla2x00_login_retry()\n",
-			    ha->host_no));
-
-			set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
-
-			DEBUG(printk("scsi(%ld): qla2x00_login_retry - end\n",
-			    ha->host_no));
-		}
-
 		if (test_and_clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
 
 			DEBUG(printk("scsi(%ld): qla2x00_loop_resync()\n",
@@ -2484,18 +2440,6 @@ qla2x00_do_dpc(void *data)
 			    ha->host_no));
 		}
 
-		if (test_and_clear_bit(FCPORT_RESCAN_NEEDED, &ha->dpc_flags)) {
-
-			DEBUG(printk("scsi(%ld): Rescan flagged fcports...\n",
-			    ha->host_no));
-
-			qla2x00_rescan_fcports(ha);
-
-			DEBUG(printk("scsi(%ld): Rescan flagged fcports..."
-			    "end.\n",
-			    ha->host_no));
-		}
-
 		if (!ha->interrupts_on)
 			ha->isp_ops->enable_intrs(ha);
 
@@ -2697,10 +2641,8 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
-	    test_bit(LOOP_RESET_NEEDED, &ha->dpc_flags) ||
 	    test_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags) ||
 	    start_dpc ||
-	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
 	    test_bit(BEACON_BLINK_NEEDED, &ha->dpc_flags) ||
 	    test_bit(VP_DPC_NEEDED, &ha->dpc_flags) ||
-- 
1.5.5.rc2

