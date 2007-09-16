From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 12/17] advansys: Sort out debug macros
Date: Sun, 16 Sep 2007 09:37:43 -0600
Message-ID: <118995706911-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:58904 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbXIPPiL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:38:11 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Replace ASC_DBG{,1,2,3,4,5} with a single variadic macro ASC_DBG.  As
suggested by Jeff Garzik, include DRV_NAME and __FUNCTION__ in the output.
Change all callers to no longer include the function name in the string.

Enabling ADVANSYS_DEBUG to test this feature shows a lot of other problems
that need to be fixed:
 - Reorder asc_prt_* functions now that their prototypes have been removed.
 - There is no longer a struct device in ASC_DVC_CFG/ADV_DVC_CFG, and it
   wasn't necessarily a PCI device to begin with.  Print the bus_id from
   asc_board->dev instead.
 - isr_callback no longer exists.
 - ASC_DBG_PRT_SCSI_CMND isn't being used, so delete asc_prt_scsi_cmnd
   too.
 - A missing semicolon

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  628 ++++++++++++++++++++---------------------------
 1 files changed, 262 insertions(+), 366 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 530765f..95df291 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -75,7 +75,7 @@
 #define ADVANSYS_STATS
 
 /* Enable driver tracing. */
-/* #define ADVANSYS_DEBUG */
+#undef ADVANSYS_DEBUG
 
 /*
  * Portable Data Types
@@ -2277,13 +2277,8 @@ do { \
 
 #ifndef ADVANSYS_DEBUG
 
-#define ASC_DBG(lvl, s)
-#define ASC_DBG1(lvl, s, a1)
-#define ASC_DBG2(lvl, s, a1, a2)
-#define ASC_DBG3(lvl, s, a1, a2, a3)
-#define ASC_DBG4(lvl, s, a1, a2, a3, a4)
+#define ASC_DBG(lvl, s...)
 #define ASC_DBG_PRT_SCSI_HOST(lvl, s)
-#define ASC_DBG_PRT_SCSI_CMND(lvl, s)
 #define ASC_DBG_PRT_ASC_SCSI_Q(lvl, scsiqp)
 #define ASC_DBG_PRT_ADV_SCSI_REQ_Q(lvl, scsiqp)
 #define ASC_DBG_PRT_ASC_QDONE_INFO(lvl, qdone)
@@ -2302,40 +2297,11 @@ do { \
  * 2-N: Verbose Tracing
  */
 
-#define ASC_DBG(lvl, s) \
-    { \
-        if (asc_dbglvl >= (lvl)) { \
-            printk(s); \
-        } \
-    }
-
-#define ASC_DBG1(lvl, s, a1) \
-    { \
-        if (asc_dbglvl >= (lvl)) { \
-            printk((s), (a1)); \
-        } \
-    }
-
-#define ASC_DBG2(lvl, s, a1, a2) \
-    { \
-        if (asc_dbglvl >= (lvl)) { \
-            printk((s), (a1), (a2)); \
-        } \
-    }
-
-#define ASC_DBG3(lvl, s, a1, a2, a3) \
-    { \
-        if (asc_dbglvl >= (lvl)) { \
-            printk((s), (a1), (a2), (a3)); \
-        } \
-    }
-
-#define ASC_DBG4(lvl, s, a1, a2, a3, a4) \
-    { \
-        if (asc_dbglvl >= (lvl)) { \
-            printk((s), (a1), (a2), (a3), (a4)); \
-        } \
-    }
+#define ASC_DBG(lvl, format, arg...) {					\
+	if (asc_dbglvl >= (lvl))					\
+		printk(KERN_DEBUG "%s: %s: " format, DRV_NAME,		\
+			__FUNCTION__ , ## arg);				\
+}
 
 #define ASC_DBG_PRT_SCSI_HOST(lvl, s) \
     { \
@@ -2344,13 +2310,6 @@ do { \
         } \
     }
 
-#define ASC_DBG_PRT_SCSI_CMND(lvl, s) \
-    { \
-        if (asc_dbglvl >= (lvl)) { \
-            asc_prt_scsi_cmnd(s); \
-        } \
-    }
-
 #define ASC_DBG_PRT_ASC_SCSI_Q(lvl, scsiqp) \
     { \
         if (asc_dbglvl >= (lvl)) { \
@@ -2519,64 +2478,6 @@ static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
 static int asc_dbglvl = 3;
 
 /*
- * asc_prt_scsi_host()
- */
-static void asc_prt_scsi_host(struct Scsi_Host *s)
-{
-	struct asc_board *boardp = shost_priv(s);
-
-	printk("Scsi_Host at addr 0x%lx\n", (ulong)s);
-	printk(" host_busy %u, host_no %d, last_reset %d,\n",
-	       s->host_busy, s->host_no, (unsigned)s->last_reset);
-
-	printk(" base 0x%lx, io_port 0x%lx, irq 0x%x,\n",
-	       (ulong)s->base, (ulong)s->io_port, boardp->irq);
-
-	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
-	       s->dma_channel, s->this_id, s->can_queue);
-
-	printk(" cmd_per_lun %d, sg_tablesize %d, unchecked_isa_dma %d\n",
-	       s->cmd_per_lun, s->sg_tablesize, s->unchecked_isa_dma);
-
-	if (ASC_NARROW_BOARD(boardp)) {
-		asc_prt_asc_dvc_var(boardp->dvc_var.asc_dvc_var);
-		asc_prt_asc_dvc_cfg(boardp->dvc_cfg.asc_dvc_cfg);
-	} else {
-		asc_prt_adv_dvc_var(boardp->dvc_var.adv_dvc_var);
-		asc_prt_adv_dvc_cfg(boardp->dvc_cfg.adv_dvc_cfg);
-	}
-}
-
-/*
- * asc_prt_scsi_cmnd()
- */
-static void asc_prt_scsi_cmnd(struct scsi_cmnd *s)
-{
-	printk("struct scsi_cmnd at addr 0x%lx\n", (ulong)s);
-
-	printk(" host 0x%lx, device 0x%lx, target %u, lun %u, channel %u,\n",
-	       (ulong)s->device->host, (ulong)s->device, s->device->id,
-	       s->device->lun, s->device->channel);
-
-	asc_prt_hex(" CDB", s->cmnd, s->cmd_len);
-
-	printk("sc_data_direction %u, resid %d\n",
-	       s->sc_data_direction, s->resid);
-
-	printk(" use_sg %u, sglist_len %u\n", s->use_sg, s->sglist_len);
-
-	printk(" serial_number 0x%x, retries %d, allowed %d\n",
-	       (unsigned)s->serial_number, s->retries, s->allowed);
-
-	printk(" timeout_per_command %d\n", s->timeout_per_command);
-
-	printk(" scsi_done 0x%p, done 0x%p, host_scribble 0x%p, result 0x%x\n",
-		s->scsi_done, s->done, s->host_scribble, s->result);
-
-	printk(" tag %u, pid %u\n", (unsigned)s->tag, (unsigned)s->pid);
-}
-
-/*
  * asc_prt_asc_dvc_var()
  */
 static void asc_prt_asc_dvc_var(ASC_DVC_VAR *h)
@@ -2627,65 +2528,11 @@ static void asc_prt_asc_dvc_cfg(ASC_DVC_CFG *h)
 		"chip_version %d,\n", h->chip_scsi_id, h->isa_dma_speed,
 		h->isa_dma_channel, h->chip_version);
 
-	printk(" pci_device_id %d, mcode_date 0x%x, mcode_version %d, "
-		"overrun_buf 0x%p\n", to_pci_dev(h->dev)->device,
+	printk(" mcode_date 0x%x, mcode_version %d, overrun_buf 0x%p\n",
 		h->mcode_date, h->mcode_version, h->overrun_buf);
 }
 
 /*
- * asc_prt_asc_scsi_q()
- */
-static void asc_prt_asc_scsi_q(ASC_SCSI_Q *q)
-{
-	ASC_SG_HEAD *sgp;
-	int i;
-
-	printk("ASC_SCSI_Q at addr 0x%lx\n", (ulong)q);
-
-	printk
-	    (" target_ix 0x%x, target_lun %u, srb_ptr 0x%lx, tag_code 0x%x,\n",
-	     q->q2.target_ix, q->q1.target_lun, (ulong)q->q2.srb_ptr,
-	     q->q2.tag_code);
-
-	printk
-	    (" data_addr 0x%lx, data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
-	     (ulong)le32_to_cpu(q->q1.data_addr),
-	     (ulong)le32_to_cpu(q->q1.data_cnt),
-	     (ulong)le32_to_cpu(q->q1.sense_addr), q->q1.sense_len);
-
-	printk(" cdbptr 0x%lx, cdb_len %u, sg_head 0x%lx, sg_queue_cnt %u\n",
-	       (ulong)q->cdbptr, q->q2.cdb_len,
-	       (ulong)q->sg_head, q->q1.sg_queue_cnt);
-
-	if (q->sg_head) {
-		sgp = q->sg_head;
-		printk("ASC_SG_HEAD at addr 0x%lx\n", (ulong)sgp);
-		printk(" entry_cnt %u, queue_cnt %u\n", sgp->entry_cnt,
-		       sgp->queue_cnt);
-		for (i = 0; i < sgp->entry_cnt; i++) {
-			printk(" [%u]: addr 0x%lx, bytes %lu\n",
-			       i, (ulong)le32_to_cpu(sgp->sg_list[i].addr),
-			       (ulong)le32_to_cpu(sgp->sg_list[i].bytes));
-		}
-
-	}
-}
-
-/*
- * asc_prt_asc_qdone_info()
- */
-static void asc_prt_asc_qdone_info(ASC_QDONE_INFO *q)
-{
-	printk("ASC_QDONE_INFO at addr 0x%lx\n", (ulong)q);
-	printk(" srb_ptr 0x%lx, target_ix %u, cdb_len %u, tag_code %u,\n",
-	       (ulong)q->d2.srb_ptr, q->d2.target_ix, q->d2.cdb_len,
-	       q->d2.tag_code);
-	printk
-	    (" done_stat 0x%x, host_stat 0x%x, scsi_stat 0x%x, scsi_msg 0x%x\n",
-	     q->d3.done_stat, q->d3.host_stat, q->d3.scsi_stat, q->d3.scsi_msg);
-}
-
-/*
  * asc_prt_adv_dvc_var()
  *
  * Display an ADV_DVC_VAR structure.
@@ -2697,9 +2544,8 @@ static void asc_prt_adv_dvc_var(ADV_DVC_VAR *h)
 	printk("  iop_base 0x%lx, err_code 0x%x, ultra_able 0x%x\n",
 	       (ulong)h->iop_base, h->err_code, (unsigned)h->ultra_able);
 
-	printk("  isr_callback 0x%lx, sdtr_able 0x%x, wdtr_able 0x%x\n",
-	       (ulong)h->isr_callback, (unsigned)h->sdtr_able,
-	       (unsigned)h->wdtr_able);
+	printk("  sdtr_able 0x%x, wdtr_able 0x%x\n",
+	       (unsigned)h->sdtr_able, (unsigned)h->wdtr_able);
 
 	printk("  start_motor 0x%x, scsi_reset_wait 0x%x\n",
 	       (unsigned)h->start_motor, (unsigned)h->scsi_reset_wait);
@@ -2733,87 +2579,36 @@ static void asc_prt_adv_dvc_cfg(ADV_DVC_CFG *h)
 	printk("  chip_version 0x%x, mcode_date 0x%x\n",
 	       h->chip_version, h->mcode_date);
 
-	printk("  mcode_version 0x%x, pci_device_id 0x%x\n",
-	       h->mcode_version, to_pci_dev(h->dev)->device);
-
-	printk("  control_flag 0x%x\n", h->control_flag);
+	printk("  mcode_version 0x%x, control_flag 0x%x\n",
+	       h->mcode_version, h->control_flag);
 }
 
 /*
- * asc_prt_adv_scsi_req_q()
- *
- * Display an ADV_SCSI_REQ_Q structure.
+ * asc_prt_scsi_host()
  */
-static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
+static void asc_prt_scsi_host(struct Scsi_Host *s)
 {
-	int sg_blk_cnt;
-	struct asc_sg_block *sg_ptr;
-
-	printk("ADV_SCSI_REQ_Q at addr 0x%lx\n", (ulong)q);
-
-	printk("  target_id %u, target_lun %u, srb_ptr 0x%lx, a_flag 0x%x\n",
-	       q->target_id, q->target_lun, (ulong)q->srb_ptr, q->a_flag);
-
-	printk("  cntl 0x%x, data_addr 0x%lx, vdata_addr 0x%lx\n",
-	       q->cntl, (ulong)le32_to_cpu(q->data_addr), (ulong)q->vdata_addr);
-
-	printk("  data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
-	       (ulong)le32_to_cpu(q->data_cnt),
-	       (ulong)le32_to_cpu(q->sense_addr), q->sense_len);
-
-	printk
-	    ("  cdb_len %u, done_status 0x%x, host_status 0x%x, scsi_status 0x%x\n",
-	     q->cdb_len, q->done_status, q->host_status, q->scsi_status);
+	struct asc_board *boardp = shost_priv(s);
 
-	printk("  sg_working_ix 0x%x, target_cmd %u\n",
-	       q->sg_working_ix, q->target_cmd);
+	printk("Scsi_Host at addr 0x%p, device %s\n", s, boardp->dev->bus_id);
+	printk(" host_busy %u, host_no %d, last_reset %d,\n",
+	       s->host_busy, s->host_no, (unsigned)s->last_reset);
 
-	printk("  scsiq_rptr 0x%lx, sg_real_addr 0x%lx, sg_list_ptr 0x%lx\n",
-	       (ulong)le32_to_cpu(q->scsiq_rptr),
-	       (ulong)le32_to_cpu(q->sg_real_addr), (ulong)q->sg_list_ptr);
+	printk(" base 0x%lx, io_port 0x%lx, irq %d,\n",
+	       (ulong)s->base, (ulong)s->io_port, boardp->irq);
 
-	/* Display the request's ADV_SG_BLOCK structures. */
-	if (q->sg_list_ptr != NULL) {
-		sg_blk_cnt = 0;
-		while (1) {
-			/*
-			 * 'sg_ptr' is a physical address. Convert it to a virtual
-			 * address by indexing 'sg_blk_cnt' into the virtual address
-			 * array 'sg_list_ptr'.
-			 *
-			 * XXX - Assumes all SG physical blocks are virtually contiguous.
-			 */
-			sg_ptr =
-			    &(((ADV_SG_BLOCK *)(q->sg_list_ptr))[sg_blk_cnt]);
-			asc_prt_adv_sgblock(sg_blk_cnt, sg_ptr);
-			if (sg_ptr->sg_ptr == 0) {
-				break;
-			}
-			sg_blk_cnt++;
-		}
-	}
-}
+	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
+	       s->dma_channel, s->this_id, s->can_queue);
 
-/*
- * asc_prt_adv_sgblock()
- *
- * Display an ADV_SG_BLOCK structure.
- */
-static void asc_prt_adv_sgblock(int sgblockno, ADV_SG_BLOCK *b)
-{
-	int i;
+	printk(" cmd_per_lun %d, sg_tablesize %d, unchecked_isa_dma %d\n",
+	       s->cmd_per_lun, s->sg_tablesize, s->unchecked_isa_dma);
 
-	printk(" ASC_SG_BLOCK at addr 0x%lx (sgblockno %d)\n",
-	       (ulong)b, sgblockno);
-	printk("  sg_cnt %u, sg_ptr 0x%lx\n",
-	       b->sg_cnt, (ulong)le32_to_cpu(b->sg_ptr));
-	BUG_ON(b->sg_cnt > NO_OF_SG_PER_BLOCK);
-	if (b->sg_ptr != 0)
-		BUG_ON(b->sg_cnt != NO_OF_SG_PER_BLOCK);
-	for (i = 0; i < b->sg_cnt; i++) {
-		printk("  [%u]: sg_addr 0x%lx, sg_count 0x%lx\n",
-		       i, (ulong)b->sg_list[i].sg_addr,
-		       (ulong)b->sg_list[i].sg_count);
+	if (ASC_NARROW_BOARD(boardp)) {
+		asc_prt_asc_dvc_var(&boardp->dvc_var.asc_dvc_var);
+		asc_prt_asc_dvc_cfg(&boardp->dvc_cfg.asc_dvc_cfg);
+	} else {
+		asc_prt_adv_dvc_var(&boardp->dvc_var.adv_dvc_var);
+		asc_prt_adv_dvc_cfg(&boardp->dvc_cfg.adv_dvc_cfg);
 	}
 }
 
@@ -2873,6 +2668,137 @@ static void asc_prt_hex(char *f, uchar *s, int l)
 		printk("\n");
 	}
 }
+
+/*
+ * asc_prt_asc_scsi_q()
+ */
+static void asc_prt_asc_scsi_q(ASC_SCSI_Q *q)
+{
+	ASC_SG_HEAD *sgp;
+	int i;
+
+	printk("ASC_SCSI_Q at addr 0x%lx\n", (ulong)q);
+
+	printk
+	    (" target_ix 0x%x, target_lun %u, srb_ptr 0x%lx, tag_code 0x%x,\n",
+	     q->q2.target_ix, q->q1.target_lun, (ulong)q->q2.srb_ptr,
+	     q->q2.tag_code);
+
+	printk
+	    (" data_addr 0x%lx, data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
+	     (ulong)le32_to_cpu(q->q1.data_addr),
+	     (ulong)le32_to_cpu(q->q1.data_cnt),
+	     (ulong)le32_to_cpu(q->q1.sense_addr), q->q1.sense_len);
+
+	printk(" cdbptr 0x%lx, cdb_len %u, sg_head 0x%lx, sg_queue_cnt %u\n",
+	       (ulong)q->cdbptr, q->q2.cdb_len,
+	       (ulong)q->sg_head, q->q1.sg_queue_cnt);
+
+	if (q->sg_head) {
+		sgp = q->sg_head;
+		printk("ASC_SG_HEAD at addr 0x%lx\n", (ulong)sgp);
+		printk(" entry_cnt %u, queue_cnt %u\n", sgp->entry_cnt,
+		       sgp->queue_cnt);
+		for (i = 0; i < sgp->entry_cnt; i++) {
+			printk(" [%u]: addr 0x%lx, bytes %lu\n",
+			       i, (ulong)le32_to_cpu(sgp->sg_list[i].addr),
+			       (ulong)le32_to_cpu(sgp->sg_list[i].bytes));
+		}
+
+	}
+}
+
+/*
+ * asc_prt_asc_qdone_info()
+ */
+static void asc_prt_asc_qdone_info(ASC_QDONE_INFO *q)
+{
+	printk("ASC_QDONE_INFO at addr 0x%lx\n", (ulong)q);
+	printk(" srb_ptr 0x%lx, target_ix %u, cdb_len %u, tag_code %u,\n",
+	       (ulong)q->d2.srb_ptr, q->d2.target_ix, q->d2.cdb_len,
+	       q->d2.tag_code);
+	printk
+	    (" done_stat 0x%x, host_stat 0x%x, scsi_stat 0x%x, scsi_msg 0x%x\n",
+	     q->d3.done_stat, q->d3.host_stat, q->d3.scsi_stat, q->d3.scsi_msg);
+}
+
+/*
+ * asc_prt_adv_sgblock()
+ *
+ * Display an ADV_SG_BLOCK structure.
+ */
+static void asc_prt_adv_sgblock(int sgblockno, ADV_SG_BLOCK *b)
+{
+	int i;
+
+	printk(" ASC_SG_BLOCK at addr 0x%lx (sgblockno %d)\n",
+	       (ulong)b, sgblockno);
+	printk("  sg_cnt %u, sg_ptr 0x%lx\n",
+	       b->sg_cnt, (ulong)le32_to_cpu(b->sg_ptr));
+	BUG_ON(b->sg_cnt > NO_OF_SG_PER_BLOCK);
+	if (b->sg_ptr != 0)
+		BUG_ON(b->sg_cnt != NO_OF_SG_PER_BLOCK);
+	for (i = 0; i < b->sg_cnt; i++) {
+		printk("  [%u]: sg_addr 0x%lx, sg_count 0x%lx\n",
+		       i, (ulong)b->sg_list[i].sg_addr,
+		       (ulong)b->sg_list[i].sg_count);
+	}
+}
+
+/*
+ * asc_prt_adv_scsi_req_q()
+ *
+ * Display an ADV_SCSI_REQ_Q structure.
+ */
+static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
+{
+	int sg_blk_cnt;
+	struct asc_sg_block *sg_ptr;
+
+	printk("ADV_SCSI_REQ_Q at addr 0x%lx\n", (ulong)q);
+
+	printk("  target_id %u, target_lun %u, srb_ptr 0x%lx, a_flag 0x%x\n",
+	       q->target_id, q->target_lun, (ulong)q->srb_ptr, q->a_flag);
+
+	printk("  cntl 0x%x, data_addr 0x%lx, vdata_addr 0x%lx\n",
+	       q->cntl, (ulong)le32_to_cpu(q->data_addr), (ulong)q->vdata_addr);
+
+	printk("  data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
+	       (ulong)le32_to_cpu(q->data_cnt),
+	       (ulong)le32_to_cpu(q->sense_addr), q->sense_len);
+
+	printk
+	    ("  cdb_len %u, done_status 0x%x, host_status 0x%x, scsi_status 0x%x\n",
+	     q->cdb_len, q->done_status, q->host_status, q->scsi_status);
+
+	printk("  sg_working_ix 0x%x, target_cmd %u\n",
+	       q->sg_working_ix, q->target_cmd);
+
+	printk("  scsiq_rptr 0x%lx, sg_real_addr 0x%lx, sg_list_ptr 0x%lx\n",
+	       (ulong)le32_to_cpu(q->scsiq_rptr),
+	       (ulong)le32_to_cpu(q->sg_real_addr), (ulong)q->sg_list_ptr);
+
+	/* Display the request's ADV_SG_BLOCK structures. */
+	if (q->sg_list_ptr != NULL) {
+		sg_blk_cnt = 0;
+		while (1) {
+			/*
+			 * 'sg_ptr' is a physical address. Convert it to a virtual
+			 * address by indexing 'sg_blk_cnt' into the virtual address
+			 * array 'sg_list_ptr'.
+			 *
+			 * XXX - Assumes all SG physical blocks are virtually contiguous.
+			 */
+			sg_ptr =
+			    &(((ADV_SG_BLOCK *)(q->sg_list_ptr))[sg_blk_cnt]);
+			asc_prt_adv_sgblock(sg_blk_cnt, sg_ptr);
+			if (sg_ptr->sg_ptr == 0) {
+				break;
+			}
+			sg_blk_cnt++;
+		}
+	}
+}
 #endif /* ADVANSYS_DEBUG */
 
 /*
@@ -2895,7 +2821,7 @@ static const char *advansys_info(struct Scsi_Host *shost)
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
-		ASC_DBG(1, "advansys_info: begin\n");
+		ASC_DBG(1, "begin\n");
 		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
 			if ((asc_dvc_varp->bus_type & ASC_IS_ISAPNP) ==
 			    ASC_IS_ISAPNP) {
@@ -2955,7 +2881,7 @@ static const char *advansys_info(struct Scsi_Host *shost)
 			(ulong)adv_dvc_varp->iop_base + boardp->asc_n_io_port - 1, boardp->irq);
 	}
 	BUG_ON(strlen(info) >= ASC_INFO_SIZE);
-	ASC_DBG(1, "advansys_info: end\n");
+	ASC_DBG(1, "end\n");
 	return info;
 }
 
@@ -4118,12 +4044,12 @@ asc_proc_copy(off_t advoffset, off_t offset, char *curbuf, int leftlen,
 {
 	int cnt = 0;
 
-	ASC_DBG3(2, "asc_proc_copy: offset %d, advoffset %d, cplen %d\n",
+	ASC_DBG(2, "offset %d, advoffset %d, cplen %d\n",
 		 (unsigned)offset, (unsigned)advoffset, cplen);
 	if (offset <= advoffset) {
 		/* Read offset below current offset, copy everything. */
 		cnt = min(cplen, leftlen);
-		ASC_DBG3(2, "asc_proc_copy: curbuf 0x%lx, cp 0x%lx, cnt %d\n",
+		ASC_DBG(2, "curbuf 0x%lx, cp 0x%lx, cnt %d\n",
 			 (ulong)curbuf, (ulong)cp, cnt);
 		memcpy(curbuf, cp, cnt);
 	} else if (offset < advoffset + cplen) {
@@ -4131,7 +4057,7 @@ asc_proc_copy(off_t advoffset, off_t offset, char *curbuf, int leftlen,
 		cnt = (advoffset + cplen) - offset;
 		cp = (cp + cplen) - cnt;
 		cnt = min(cnt, leftlen);
-		ASC_DBG3(2, "asc_proc_copy: curbuf 0x%lx, cp 0x%lx, cnt %d\n",
+		ASC_DBG(2, "curbuf 0x%lx, cp 0x%lx, cnt %d\n",
 			 (ulong)curbuf, (ulong)cp, cnt);
 		memcpy(curbuf, cp, cnt);
 	}
@@ -4270,7 +4196,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	char *curbuf;
 	off_t advoffset;
 
-	ASC_DBG(1, "advansys_proc_info: begin\n");
+	ASC_DBG(1, "begin\n");
 
 	/*
 	 * User write not supported.
@@ -4302,7 +4228,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	totcnt += cnt;
 	leftlen -= cnt;
 	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		ASC_DBG(1, "totcnt %d\n", totcnt);
 		return totcnt;
 	}
 	advoffset += cplen;
@@ -4320,7 +4246,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		totcnt += cnt;
 		leftlen -= cnt;
 		if (leftlen == 0) {
-			ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+			ASC_DBG(1, "totcnt %d\n", totcnt);
 			return totcnt;
 		}
 		advoffset += cplen;
@@ -4337,7 +4263,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	totcnt += cnt;
 	leftlen -= cnt;
 	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		ASC_DBG(1, "totcnt %d\n", totcnt);
 		return totcnt;
 	}
 	advoffset += cplen;
@@ -4357,7 +4283,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	totcnt += cnt;
 	leftlen -= cnt;
 	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		ASC_DBG(1, "totcnt %d\n", totcnt);
 		return totcnt;
 	}
 	advoffset += cplen;
@@ -4373,7 +4299,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	totcnt += cnt;
 	leftlen -= cnt;
 	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		ASC_DBG(1, "totcnt %d\n", totcnt);
 		return totcnt;
 	}
 	advoffset += cplen;
@@ -4390,7 +4316,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	totcnt += cnt;
 	leftlen -= cnt;
 	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		ASC_DBG(1, "totcnt %d\n", totcnt);
 		return totcnt;
 	}
 	advoffset += cplen;
@@ -4412,13 +4338,13 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	totcnt += cnt;
 	leftlen -= cnt;
 	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		ASC_DBG(1, "totcnt %d\n", totcnt);
 		return totcnt;
 	}
 	advoffset += cplen;
 	curbuf += cnt;
 
-	ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+	ASC_DBG(1, "totcnt %d\n", totcnt);
 
 	return totcnt;
 }
@@ -4530,11 +4456,10 @@ static int AscFindSignature(PortAddr iop_base)
 {
 	ushort sig_word;
 
-	ASC_DBG2(1, "AscFindSignature: AscGetChipSignatureByte(0x%x) 0x%x\n",
+	ASC_DBG(1, "AscGetChipSignatureByte(0x%x) 0x%x\n",
 		 iop_base, AscGetChipSignatureByte(iop_base));
 	if (AscGetChipSignatureByte(iop_base) == (uchar)ASC_1000_ID1B) {
-		ASC_DBG2(1,
-			 "AscFindSignature: AscGetChipSignatureWord(0x%x) 0x%x\n",
+		ASC_DBG(1, "AscGetChipSignatureWord(0x%x) 0x%x\n",
 			 iop_base, AscGetChipSignatureWord(iop_base));
 		sig_word = AscGetChipSignatureWord(iop_base);
 		if ((sig_word == (ushort)ASC_1000_ID0W) ||
@@ -4785,18 +4710,17 @@ AscLoadMicroCode(PortAddr iop_base,
 	AscMemWordCopyPtrToLram(iop_base, s_addr, mcode_buf, mcode_word_size);
 
 	chksum = AscMemSumLramWord(iop_base, s_addr, mcode_word_size);
-	ASC_DBG1(1, "AscLoadMicroCode: chksum 0x%lx\n", (ulong)chksum);
+	ASC_DBG(1, "chksum 0x%lx\n", (ulong)chksum);
 	mcode_chksum = (ushort)AscMemSumLramWord(iop_base,
 						 (ushort)ASC_CODE_SEC_BEG,
 						 (ushort)((mcode_size -
 							   s_addr - (ushort)
 							   ASC_CODE_SEC_BEG) /
 							  2));
-	ASC_DBG1(1, "AscLoadMicroCode: mcode_chksum 0x%lx\n",
-		 (ulong)mcode_chksum);
+	ASC_DBG(1, "mcode_chksum 0x%lx\n", (ulong)mcode_chksum);
 	AscWriteLramWord(iop_base, ASCV_MCODE_CHKSUM_W, mcode_chksum);
 	AscWriteLramWord(iop_base, ASCV_MCODE_SIZE_W, mcode_size);
-	return (chksum);
+	return chksum;
 }
 
 /* Microcode buffer is kept after initialization for error recovery. */
@@ -6511,8 +6435,7 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	warn_code |= AscInitLram(asc_dvc);
 	if (asc_dvc->err_code != 0)
 		return UW_ERR;
-	ASC_DBG1(1, "AscInitAsc1000Driver: _asc_mcode_chksum 0x%lx\n",
-		 (ulong)_asc_mcode_chksum);
+	ASC_DBG(1, "_asc_mcode_chksum 0x%lx\n", (ulong)_asc_mcode_chksum);
 	if (AscLoadMicroCode(iop_base, 0, _asc_mcode_buf,
 			     _asc_mcode_size) != _asc_mcode_chksum) {
 		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
@@ -6613,7 +6536,7 @@ DvcGetPhyAddr(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq,
 {
 	ADV_PADDR paddr = virt_to_bus(vaddr);
 
-	ASC_DBG4(4, "DvcGetPhyAddr: vaddr 0x%p, lenp 0x%p *lenp %lu, paddr 0x%lx\n",
+	ASC_DBG(4, "vaddr 0x%p, lenp 0x%p *lenp %lu, paddr 0x%lx\n",
 		 vaddr, lenp, (ulong)*((ulong *)lenp), (ulong)paddr);
 
 	return paddr;
@@ -8291,8 +8214,7 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
 		/*
 		 * The firmware detected a SCSI Bus reset.
 		 */
-		ASC_DBG(0,
-			"adv_async_callback: ADV_ASYNC_SCSI_BUS_RESET_DET\n");
+		ASC_DBG(0, "ADV_ASYNC_SCSI_BUS_RESET_DET\n");
 		break;
 
 	case ADV_ASYNC_RDMA_FAILURE:
@@ -8301,7 +8223,7 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
 		 * possibly the chip if it is unresponsive. Log the error
 		 * with a unique code.
 		 */
-		ASC_DBG(0, "adv_async_callback: ADV_ASYNC_RDMA_FAILURE\n");
+		ASC_DBG(0, "ADV_ASYNC_RDMA_FAILURE\n");
 		AdvResetChipAndSB(adv_dvc_varp);
 		break;
 
@@ -8309,11 +8231,11 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
 		/*
 		 * Host generated SCSI bus reset occurred.
 		 */
-		ASC_DBG(0, "adv_async_callback: ADV_HOST_SCSI_BUS_RESET\n");
+		ASC_DBG(0, "ADV_HOST_SCSI_BUS_RESET\n");
 		break;
 
 	default:
-		ASC_DBG1(0, "DvcAsyncCallBack: unknown code 0x%x\n", code);
+		ASC_DBG(0, "unknown code 0x%x\n", code);
 		break;
 	}
 }
@@ -8332,7 +8254,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	struct Scsi_Host *shost;
 	ADV_DCNT resid_cnt;
 
-	ASC_DBG2(1, "adv_isr_callback: adv_dvc_varp 0x%lx, scsiqp 0x%lx\n",
+	ASC_DBG(1, "adv_dvc_varp 0x%lx, scsiqp 0x%lx\n",
 		 (ulong)adv_dvc_varp, (ulong)scsiqp);
 	ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
 
@@ -8342,7 +8264,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	 * completed ADV_SCSI_REQ_Q structure.
 	 */
 	reqp = (adv_req_t *)ADV_U32_TO_VADDR(scsiqp->srb_ptr);
-	ASC_DBG1(1, "adv_isr_callback: reqp 0x%lx\n", (ulong)reqp);
+	ASC_DBG(1, "reqp 0x%lx\n", (ulong)reqp);
 	if (reqp == NULL) {
 		ASC_PRINT("adv_isr_callback: reqp is NULL\n");
 		return;
@@ -8357,7 +8279,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	 * determined.
 	 */
 	scp = reqp->cmndp;
-	ASC_DBG1(1, "adv_isr_callback: scp 0x%lx\n", (ulong)scp);
+	ASC_DBG(1, "scp 0x%p\n", scp);
 	if (scp == NULL) {
 		ASC_PRINT
 		    ("adv_isr_callback: scp is NULL; adv_req_t dropped.\n");
@@ -8367,7 +8289,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 
 	shost = scp->device->host;
 	ASC_STATS(shost, callback);
-	ASC_DBG1(1, "adv_isr_callback: shost 0x%lx\n", (ulong)shost);
+	ASC_DBG(1, "shost 0x%p\n", shost);
 
 	boardp = shost_priv(shost);
 	BUG_ON(adv_dvc_varp != &boardp->dvc_var.adv_dvc_var);
@@ -8377,7 +8299,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	 */
 	switch (scsiqp->done_status) {
 	case QD_NO_ERROR:
-		ASC_DBG(2, "adv_isr_callback: QD_NO_ERROR\n");
+		ASC_DBG(2, "QD_NO_ERROR\n");
 		scp->result = 0;
 
 		/*
@@ -8389,20 +8311,18 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 		resid_cnt = le32_to_cpu(scsiqp->data_cnt);
 		if (scp->request_bufflen != 0 && resid_cnt != 0 &&
 		    resid_cnt <= scp->request_bufflen) {
-			ASC_DBG1(1,
-				 "adv_isr_callback: underrun condition %lu bytes\n",
+			ASC_DBG(1, "underrun condition %lu bytes\n",
 				 (ulong)resid_cnt);
 			scp->resid = resid_cnt;
 		}
 		break;
 
 	case QD_WITH_ERROR:
-		ASC_DBG(2, "adv_isr_callback: QD_WITH_ERROR\n");
+		ASC_DBG(2, "QD_WITH_ERROR\n");
 		switch (scsiqp->host_status) {
 		case QHSTA_NO_ERROR:
 			if (scsiqp->scsi_status == SAM_STAT_CHECK_CONDITION) {
-				ASC_DBG(2,
-					"adv_isr_callback: SAM_STAT_CHECK_CONDITION\n");
+				ASC_DBG(2, "SAM_STAT_CHECK_CONDITION\n");
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  sizeof(scp->sense_buffer));
 				/*
@@ -8426,22 +8346,20 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 
 		default:
 			/* Some other QHSTA error occurred. */
-			ASC_DBG1(1, "adv_isr_callback: host_status 0x%x\n",
-				 scsiqp->host_status);
+			ASC_DBG(1, "host_status 0x%x\n", scsiqp->host_status);
 			scp->result = HOST_BYTE(DID_BAD_TARGET);
 			break;
 		}
 		break;
 
 	case QD_ABORTED_BY_HOST:
-		ASC_DBG(1, "adv_isr_callback: QD_ABORTED_BY_HOST\n");
+		ASC_DBG(1, "QD_ABORTED_BY_HOST\n");
 		scp->result =
 		    HOST_BYTE(DID_ABORT) | STATUS_BYTE(scsiqp->scsi_status);
 		break;
 
 	default:
-		ASC_DBG1(1, "adv_isr_callback: done_status 0x%x\n",
-			 scsiqp->done_status);
+		ASC_DBG(1, "done_status 0x%x\n", scsiqp->done_status);
 		scp->result =
 		    HOST_BYTE(DID_ERROR) | STATUS_BYTE(scsiqp->scsi_status);
 		break;
@@ -8479,7 +8397,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	reqp->next_reqp = boardp->adv_reqp;
 	boardp->adv_reqp = reqp;
 
-	ASC_DBG(1, "adv_isr_callback: done\n");
+	ASC_DBG(1, "done\n");
 
 	return;
 }
@@ -9299,8 +9217,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	struct scsi_cmnd *scp;
 	struct Scsi_Host *shost;
 
-	ASC_DBG2(1, "asc_isr_callback: asc_dvc_varp 0x%lx, qdonep 0x%lx\n",
-		 (ulong)asc_dvc_varp, (ulong)qdonep);
+	ASC_DBG(1, "asc_dvc_varp 0x%p, qdonep 0x%p\n", asc_dvc_varp, qdonep);
 	ASC_DBG_PRT_ASC_QDONE_INFO(2, qdonep);
 
 	/*
@@ -9308,7 +9225,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	 * command that has been completed.
 	 */
 	scp = (struct scsi_cmnd *)ASC_U32_TO_VADDR(qdonep->d2.srb_ptr);
-	ASC_DBG1(1, "asc_isr_callback: scp 0x%lx\n", (ulong)scp);
+	ASC_DBG(1, "scp 0x%p\n", scp);
 
 	if (scp == NULL) {
 		ASC_PRINT("asc_isr_callback: scp is NULL\n");
@@ -9318,7 +9235,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 
 	shost = scp->device->host;
 	ASC_STATS(shost, callback);
-	ASC_DBG1(1, "asc_isr_callback: shost 0x%lx\n", (ulong)shost);
+	ASC_DBG(1, "shost 0x%p\n", shost);
 
 	boardp = shost_priv(shost);
 	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
@@ -9328,7 +9245,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	 */
 	switch (qdonep->d3.done_stat) {
 	case QD_NO_ERROR:
-		ASC_DBG(2, "asc_isr_callback: QD_NO_ERROR\n");
+		ASC_DBG(2, "QD_NO_ERROR\n");
 		scp->result = 0;
 
 		/*
@@ -9339,20 +9256,18 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 		 */
 		if (scp->request_bufflen != 0 && qdonep->remain_bytes != 0 &&
 		    qdonep->remain_bytes <= scp->request_bufflen) {
-			ASC_DBG1(1,
-				 "asc_isr_callback: underrun condition %u bytes\n",
+			ASC_DBG(1, "underrun condition %u bytes\n",
 				 (unsigned)qdonep->remain_bytes);
 			scp->resid = qdonep->remain_bytes;
 		}
 		break;
 
 	case QD_WITH_ERROR:
-		ASC_DBG(2, "asc_isr_callback: QD_WITH_ERROR\n");
+		ASC_DBG(2, "QD_WITH_ERROR\n");
 		switch (qdonep->d3.host_stat) {
 		case QHSTA_NO_ERROR:
 			if (qdonep->d3.scsi_stat == SAM_STAT_CHECK_CONDITION) {
-				ASC_DBG(2,
-					"asc_isr_callback: SAM_STAT_CHECK_CONDITION\n");
+				ASC_DBG(2, "SAM_STAT_CHECK_CONDITION\n");
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  sizeof(scp->sense_buffer));
 				/*
@@ -9376,15 +9291,14 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 
 		default:
 			/* QHSTA error occurred */
-			ASC_DBG1(1, "asc_isr_callback: host_stat 0x%x\n",
-				 qdonep->d3.host_stat);
+			ASC_DBG(1, "host_stat 0x%x\n", qdonep->d3.host_stat);
 			scp->result = HOST_BYTE(DID_BAD_TARGET);
 			break;
 		}
 		break;
 
 	case QD_ABORTED_BY_HOST:
-		ASC_DBG(1, "asc_isr_callback: QD_ABORTED_BY_HOST\n");
+		ASC_DBG(1, "QD_ABORTED_BY_HOST\n");
 		scp->result =
 		    HOST_BYTE(DID_ABORT) | MSG_BYTE(qdonep->d3.
 						    scsi_msg) |
@@ -9392,8 +9306,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 		break;
 
 	default:
-		ASC_DBG1(1, "asc_isr_callback: done_stat 0x%x\n",
-			 qdonep->d3.done_stat);
+		ASC_DBG(1, "done_stat 0x%x\n", qdonep->d3.done_stat);
 		scp->result =
 		    HOST_BYTE(DID_ERROR) | MSG_BYTE(qdonep->d3.
 						    scsi_msg) |
@@ -9681,7 +9594,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	int status;
 	int ret = SUCCESS;
 
-	ASC_DBG1(1, "advansys_reset: 0x%p\n", scp);
+	ASC_DBG(1, "0x%p\n", scp);
 
 	ASC_STATS(shost, reset);
 
@@ -9691,7 +9604,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 
 		/* Reset the chip and SCSI bus. */
-		ASC_DBG(1, "advansys_reset: before AscInitAsc1000Driver()\n");
+		ASC_DBG(1, "before AscInitAsc1000Driver()\n");
 		status = AscInitAsc1000Driver(asc_dvc);
 
 		/* Refer to ASC_IERR_* defintions for meaning of 'err_code'. */
@@ -9707,7 +9620,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 				    "successful\n");
 		}
 
-		ASC_DBG(1, "advansys_reset: after AscInitAsc1000Driver()\n");
+		ASC_DBG(1, "after AscInitAsc1000Driver()\n");
 		spin_lock_irqsave(&boardp->lock, flags);
 	} else {
 		/*
@@ -9719,7 +9632,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		/*
 		 * Reset the target's SCSI bus.
 		 */
-		ASC_DBG(1, "advansys_reset: before AdvResetChipAndSB()\n");
+		ASC_DBG(1, "before AdvResetChipAndSB()\n");
 		switch (AdvResetChipAndSB(adv_dvc)) {
 		case ASC_TRUE:
 			scmd_printk(KERN_INFO, scp, "SCSI bus reset "
@@ -9739,7 +9652,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	boardp->last_reset = jiffies;
 	spin_unlock_irqrestore(&boardp->lock, flags);
 
-	ASC_DBG1(1, "advansys_reset: ret %d\n", ret);
+	ASC_DBG(1, "ret %d\n", ret);
 
 	return ret;
 }
@@ -9761,7 +9674,7 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 {
 	struct asc_board *boardp = shost_priv(sdev->host);
 
-	ASC_DBG(1, "advansys_biosparam: begin\n");
+	ASC_DBG(1, "begin\n");
 	ASC_STATS(sdev->host, biosparam);
 	if (ASC_NARROW_BOARD(boardp)) {
 		if ((boardp->dvc_var.asc_dvc_var.dvc_cntl &
@@ -9783,7 +9696,7 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		}
 	}
 	ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
-	ASC_DBG(1, "advansys_biosparam: end\n");
+	ASC_DBG(1, "end\n");
 	return 0;
 }
 
@@ -9799,17 +9712,17 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	struct asc_board *boardp = shost_priv(shost);
 	irqreturn_t result = IRQ_NONE;
 
-	ASC_DBG1(2, "advansys_interrupt: boardp 0x%p\n", boardp);
+	ASC_DBG(2, "boardp 0x%p\n", boardp);
 	spin_lock_irqsave(&boardp->lock, flags);
 	if (ASC_NARROW_BOARD(boardp)) {
 		if (AscIsIntPending(shost->io_port)) {
 			result = IRQ_HANDLED;
 			ASC_STATS(shost, interrupt);
-			ASC_DBG(1, "advansys_interrupt: before AscISR()\n");
+			ASC_DBG(1, "before AscISR()\n");
 			AscISR(&boardp->dvc_var.asc_dvc_var);
 		}
 	} else {
-		ASC_DBG(1, "advansys_interrupt: before AdvISR()\n");
+		ASC_DBG(1, "before AdvISR()\n");
 		if (AdvISR(&boardp->dvc_var.adv_dvc_var)) {
 			result = IRQ_HANDLED;
 			ASC_STATS(shost, interrupt);
@@ -9817,7 +9730,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	}
 	spin_unlock_irqrestore(&boardp->lock, flags);
 
-	ASC_DBG(1, "advansys_interrupt: end\n");
+	ASC_DBG(1, "end\n");
 	return result;
 }
 
@@ -10186,7 +10099,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		}
 	}
 
-	ASC_DBG_PRT_ASC_SCSI_Q(2, &asc_scsi_q);
+	ASC_DBG_PRT_ASC_SCSI_Q(2, asc_scsi_q);
 	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
 
 	return ASC_NOERROR;
@@ -10229,7 +10142,7 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 		 * (15) scatter-gather elements.
 		 */
 		if ((sgblkp = boardp->adv_sgblkp) == NULL) {
-			ASC_DBG(1, "adv_get_sglist: no free adv_sgblk_t\n");
+			ASC_DBG(1, "no free adv_sgblk_t\n");
 			ASC_STATS(scp->device->host, adv_build_nosg);
 
 			/*
@@ -10328,7 +10241,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * the command.
 	 */
 	if (boardp->adv_reqp == NULL) {
-		ASC_DBG(1, "adv_build_req: no free adv_req_t\n");
+		ASC_DBG(1, "no free adv_req_t\n");
 		ASC_STATS(scp->device->host, adv_build_noreq);
 		return ASC_BUSY;
 	} else {
@@ -11205,7 +11118,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 	int ret, err_code;
 	struct asc_board *boardp = shost_priv(scp->device->host);
 
-	ASC_DBG1(1, "asc_execute_scsi_cmnd: scp 0x%p\n", scp);
+	ASC_DBG(1, "scp 0x%p\n", scp);
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
@@ -11227,12 +11140,10 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 
 		switch (adv_build_req(boardp, scp, &adv_scsiqp)) {
 		case ASC_NOERROR:
-			ASC_DBG(3, "asc_execute_scsi_cmnd: adv_build_req "
-				"ASC_NOERROR\n");
+			ASC_DBG(3, "adv_build_req ASC_NOERROR\n");
 			break;
 		case ASC_BUSY:
-			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
-				"ASC_BUSY\n");
+			ASC_DBG(1, "adv_build_req ASC_BUSY\n");
 			/*
 			 * The asc_stats fields 'adv_build_noreq' and
 			 * 'adv_build_nosg' count wide board busy conditions.
@@ -11242,8 +11153,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			return ASC_BUSY;
 		case ASC_ERROR:
 		default:
-			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
-				"ASC_ERROR\n");
+			ASC_DBG(1, "adv_build_req ASC_ERROR\n");
 			ASC_STATS(scp->device->host, build_error);
 			return ASC_ERROR;
 		}
@@ -11260,8 +11170,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		 * successful request counter. Wrapping doesn't matter.
 		 */
 		boardp->reqcnt[scp->device->id]++;
-		ASC_DBG(1, "asc_execute_scsi_cmnd: ExeScsiQueue(), "
-			"ASC_NOERROR\n");
+		ASC_DBG(1, "ExeScsiQueue() ASC_NOERROR\n");
 		break;
 	case ASC_BUSY:
 		ASC_STATS(scp->device->host, exe_busy);
@@ -11280,7 +11189,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		break;
 	}
 
-	ASC_DBG(1, "asc_execute_scsi_cmnd: end\n");
+	ASC_DBG(1, "end\n");
 	return ret;
 }
 
@@ -11911,7 +11820,7 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 		AscSetChipCfgMsw(iop_base, cfg_msw);
 	}
 	chksum = AscGetEEPConfig(iop_base, eep_config, asc_dvc->bus_type);
-	ASC_DBG1(1, "AscInitFromEEP: chksum 0x%x\n", chksum);
+	ASC_DBG(1, "chksum 0x%x\n", chksum);
 	if (chksum == 0) {
 		chksum = 0xaa55;
 	}
@@ -11932,13 +11841,11 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 	}
 	eep_config->cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
 	eep_config->cfg_lsw |= ASC_CFG0_HOST_INT_ON;
-	ASC_DBG1(1, "AscInitFromEEP: eep_config->chksum 0x%x\n",
-		 eep_config->chksum);
+	ASC_DBG(1, "eep_config->chksum 0x%x\n", eep_config->chksum);
 	if (chksum != eep_config->chksum) {
 		if (AscGetChipVersion(iop_base, asc_dvc->bus_type) ==
 		    ASC_CHIP_VER_PCI_ULTRA_3050) {
-			ASC_DBG(1,
-				"AscInitFromEEP: chksum error ignored; EEPROM-less board\n");
+			ASC_DBG(1, "chksum error ignored; EEPROM-less board\n");
 			eep_config->init_sdtr = 0xFF;
 			eep_config->disc_enable = 0xFF;
 			eep_config->start_motor = 0xFF;
@@ -13517,11 +13424,11 @@ AdvInitGetConfig(struct pci_dev *pdev, struct asc_board *boardp)
 	asc_dvc->cfg->chip_version =
 	    AdvGetChipVersion(iop_base, asc_dvc->bus_type);
 
-	ASC_DBG2(1, "AdvInitGetConfig: iopb_chip_id_1: 0x%x 0x%x\n",
+	ASC_DBG(1, "iopb_chip_id_1: 0x%x 0x%x\n",
 		 (ushort)AdvReadByteRegister(iop_base, IOPB_CHIP_ID_1),
 		 (ushort)ADV_CHIP_ID_BYTE);
 
-	ASC_DBG2(1, "AdvInitGetConfig: iopw_chip_id_0: 0x%x 0x%x\n",
+	ASC_DBG(1, "iopw_chip_id_0: 0x%x 0x%x\n",
 		 (ushort)AdvReadWordRegister(iop_base, IOPW_CHIP_ID_0),
 		 (ushort)ADV_CHIP_ID_WORD);
 
@@ -13616,7 +13523,7 @@ advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	 * is about 4 KB, so allocate all at once.
 	 */
 	boardp->carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
-	ASC_DBG1(1, "advansys_wide_init_chip: carrp 0x%p\n", boardp->carrp);
+	ASC_DBG(1, "carrp 0x%p\n", boardp->carrp);
 
 	if (!boardp->carrp)
 		goto kmalloc_failed;
@@ -13629,8 +13536,7 @@ advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	for (req_cnt = adv_dvc_varp->max_host_qng; req_cnt > 0; req_cnt--) {
 		reqp = kmalloc(sizeof(adv_req_t) * req_cnt, GFP_KERNEL);
 
-		ASC_DBG3(1, "advansys_wide_init_chip: reqp 0x%p, req_cnt %d, "
-			 "bytes %lu\n", reqp, req_cnt,
+		ASC_DBG(1, "reqp 0x%p, req_cnt %d, bytes %lu\n", reqp, req_cnt,
 			 (ulong)sizeof(adv_req_t) * req_cnt);
 
 		if (reqp)
@@ -13658,8 +13564,7 @@ advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 
 	}
 
-	ASC_DBG3(1, "advansys_wide_init_chip: sg_cnt %d * %u = %u bytes\n",
-		 sg_cnt, sizeof(adv_sgblk_t),
+	ASC_DBG(1, "sg_cnt %d * %u = %u bytes\n", sg_cnt, sizeof(adv_sgblk_t),
 		 (unsigned)(sizeof(adv_sgblk_t) * sg_cnt));
 
 	if (!boardp->adv_sgblkp)
@@ -13679,15 +13584,13 @@ advansys_wide_init_chip(struct asc_board *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	boardp->adv_reqp = &reqp[0];
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-		ASC_DBG(2, "advansys_wide_init_chip: AdvInitAsc3550Driver()\n");
+		ASC_DBG(2, "AdvInitAsc3550Driver()\n");
 		warn_code = AdvInitAsc3550Driver(adv_dvc_varp);
 	} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
-		ASC_DBG(2, "advansys_wide_init_chip: AdvInitAsc38C0800Driver()"
-			   "\n");
+		ASC_DBG(2, "AdvInitAsc38C0800Driver()\n");
 		warn_code = AdvInitAsc38C0800Driver(adv_dvc_varp);
 	} else {
-		ASC_DBG(2, "advansys_wide_init_chip: AdvInitAsc38C1600Driver()"
-			   "\n");
+		ASC_DBG(2, "AdvInitAsc38C1600Driver()\n");
 		warn_code = AdvInitAsc38C1600Driver(adv_dvc_varp);
 	}
 	err_code = adv_dvc_varp->err_code;
@@ -13734,7 +13637,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	pdev = (bus_type == ASC_IS_PCI) ? to_pci_dev(boardp->dev) : NULL;
 
 	if (ASC_NARROW_BOARD(boardp)) {
-		ASC_DBG(1, "advansys_board_found: narrow board\n");
+		ASC_DBG(1, "narrow board\n");
 		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
 		asc_dvc_varp->bus_type = bus_type;
 		asc_dvc_varp->drv_ptr = boardp;
@@ -13743,18 +13646,17 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		asc_dvc_varp->iop_base = iop;
 	} else {
 #ifdef CONFIG_PCI
-		ASC_DBG(1, "advansys_board_found: wide board\n");
 		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
 		adv_dvc_varp->drv_ptr = boardp;
 		adv_dvc_varp->cfg = &boardp->dvc_cfg.adv_dvc_cfg;
 		if (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW) {
-			ASC_DBG(1, "advansys_board_found: ASC-3550\n");
+			ASC_DBG(1, "wide board ASC-3550\n");
 			adv_dvc_varp->chip_type = ADV_CHIP_ASC3550;
 		} else if (pdev->device == PCI_DEVICE_ID_38C0800_REV1) {
-			ASC_DBG(1, "advansys_board_found: ASC-38C0800\n");
+			ASC_DBG(1, "wide board ASC-38C0800\n");
 			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C0800;
 		} else {
-			ASC_DBG(1, "advansys_board_found: ASC-38C1600\n");
+			ASC_DBG(1, "wide board ASC-38C1600\n");
 			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C1600;
 		}
 
@@ -13769,9 +13671,8 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 			ret = -ENODEV;
 			goto err_shost;
 		}
-		adv_dvc_varp->iop_base = (AdvPortAddr)boardp->ioremap_addr
-		ASC_DBG1(1, "advansys_board_found: iop_base: 0x%lx\n",
-			 adv_dvc_varp->iop_base);
+		adv_dvc_varp->iop_base = (AdvPortAddr)boardp->ioremap_addr;
+		ASC_DBG(1, "iop_base: 0x%p\n", adv_dvc_varp->iop_base);
 
 		/*
 		 * Even though it isn't used to access wide boards, other
@@ -13780,9 +13681,8 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		 */
 		boardp->ioport = iop;
 
-		ASC_DBG2(1, "advansys_board_found: iopb_chip_id_1 0x%x, "
-			 "iopw_chip_id_0 0x%x\n", (ushort)inp(iop + 1),
-			 (ushort)inpw(iop));
+		ASC_DBG(1, "iopb_chip_id_1 0x%x, iopw_chip_id_0 0x%x\n",
+				(ushort)inp(iop + 1), (ushort)inpw(iop));
 #endif /* CONFIG_PCI */
 	}
 
@@ -13841,7 +13741,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		 * longer be used. If the bus_type field must be
 		 * referenced only use the bit-wise AND operator "&".
 		 */
-		ASC_DBG(2, "advansys_board_found: AscInitGetConfig()\n");
+		ASC_DBG(2, "AscInitGetConfig()\n");
 		ret = AscInitGetConfig(boardp) ? -ENODEV : 0;
 	} else {
 #ifdef CONFIG_PCI
@@ -13851,7 +13751,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		 */
 		shost->unchecked_isa_dma = FALSE;
 		share_irq = IRQF_SHARED;
-		ASC_DBG(2, "advansys_board_found: AdvInitGetConfig()\n");
+		ASC_DBG(2, "AdvInitGetConfig()\n");
 
 		ret = AdvInitGetConfig(pdev, boardp) ? -ENODEV : 0;
 #endif /* CONFIG_PCI */
@@ -13900,7 +13800,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		/*
 		 * Modify board configuration.
 		 */
-		ASC_DBG(2, "advansys_board_found: AscInitSetConfig()\n");
+		ASC_DBG(2, "AscInitSetConfig()\n");
 		ret = AscInitSetConfig(pdev, boardp) ? -ENODEV : 0;
 		if (ret)
 			goto err_free_proc;
@@ -14081,7 +13981,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		shost->sg_tablesize = SG_ALL;
 	}
 
-	ASC_DBG1(1, "advansys_board_found: sg_tablesize: %d\n", shost->sg_tablesize);
+	ASC_DBG(1, "sg_tablesize: %d\n", shost->sg_tablesize);
 
 	/* BIOS start address. */
 	if (ASC_NARROW_BOARD(boardp)) {
@@ -14101,12 +14001,10 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		AdvReadWordLram(adv_dvc_varp->iop_base,
 				BIOS_CODELEN, boardp->bios_codelen);
 
-		ASC_DBG2(1,
-			 "advansys_board_found: bios_signature 0x%x, bios_version 0x%x\n",
+		ASC_DBG(1, "bios_signature 0x%x, bios_version 0x%x\n",
 			 boardp->bios_signature, boardp->bios_version);
 
-		ASC_DBG2(1,
-			 "advansys_board_found: bios_codeseg 0x%x, bios_codelen 0x%x\n",
+		ASC_DBG(1, "bios_codeseg 0x%x, bios_codelen 0x%x\n",
 			 boardp->bios_codeseg, boardp->bios_codelen);
 
 		/*
@@ -14148,7 +14046,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 #endif /* CONFIG_ISA */
 
 	/* Register IRQ Number. */
-	ASC_DBG1(2, "advansys_board_found: request_irq() %d\n", boardp->irq);
+	ASC_DBG(2, "request_irq(%d, %p)\n", boardp->irq, shost);
 
 	ret = request_irq(boardp->irq, advansys_interrupt, share_irq,
 			  DRV_NAME, shost);
@@ -14174,7 +14072,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	 * Initialize board RISC chip and enable interrupts.
 	 */
 	if (ASC_NARROW_BOARD(boardp)) {
-		ASC_DBG(2, "advansys_board_found: AscInitAsc1000Driver()\n");
+		ASC_DBG(2, "AscInitAsc1000Driver()\n");
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
 
 		if (warn_code || asc_dvc_varp->err_code) {
@@ -14225,11 +14123,11 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 static int advansys_release(struct Scsi_Host *shost)
 {
 	struct asc_board *boardp = shost_priv(shost); 
-	ASC_DBG(1, "advansys_release: begin\n");
+	ASC_DBG(1, "begin\n");
 	scsi_remove_host(shost);
 	free_irq(boardp->irq, shost);
 	if (shost->dma_channel != NO_ISA_DMA) {
-		ASC_DBG(1, "advansys_release: free_dma()\n");
+		ASC_DBG(1, "free_dma()\n");
 		free_dma(shost->dma_channel);
 	}
 	if (!ASC_NARROW_BOARD(boardp)) {
@@ -14238,7 +14136,7 @@ static int advansys_release(struct Scsi_Host *shost)
 	}
 	kfree(boardp->prtbuf);
 	scsi_host_put(shost);
-	ASC_DBG(1, "advansys_release: end\n");
+	ASC_DBG(1, "end\n");
 	return 0;
 }
 
@@ -14273,11 +14171,10 @@ static int __devinit advansys_isa_probe(struct device *dev, unsigned int id)
 	struct asc_board *board;
 
 	if (!request_region(iop_base, ASC_IOADR_GAP, DRV_NAME)) {
-		ASC_DBG1(1, "advansys_isa_match: I/O port 0x%x busy\n",
-			 iop_base);
+		ASC_DBG(1, "I/O port 0x%x busy\n", iop_base);
 		return -ENODEV;
 	}
-	ASC_DBG1(1, "advansys_isa_match: probing I/O port 0x%x\n", iop_base);
+	ASC_DBG(1, "probing I/O port 0x%x\n", iop_base);
 	if (!AscFindSignature(iop_base))
 		goto release_region;
 	if (!(AscGetChipVersion(iop_base, ASC_IS_ISA) & ASC_CHIP_VER_ISA_BIT))
@@ -14351,11 +14248,10 @@ static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
 	struct asc_board *board;
 
 	if (!request_region(iop_base, ASC_IOADR_GAP, DRV_NAME)) {
-		ASC_DBG1(1, "advansys_vlb_match: I/O port 0x%x busy\n",
-			 iop_base);
+		ASC_DBG(1, "I/O port 0x%x busy\n", iop_base);
 		return -ENODEV;
 	}
-	ASC_DBG1(1, "advansys_vlb_match: probing I/O port 0x%x\n", iop_base);
+	ASC_DBG(1, "probing I/O port 0x%x\n", iop_base);
 	if (!AscFindSignature(iop_base))
 		goto release_region;
 	/*
-- 
1.5.2.4

