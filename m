From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/6] lpfc 8.2.5 : Fix buffer leaks
Date: Fri, 08 Feb 2008 18:50:25 -0500
Message-ID: <1202514625.20924.19.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44729 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYBHXuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 18:50:19 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m18NoC5n018613
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 15:50:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix buffer leaks:
- HBQ dma buffer leak at dma_pool_destroy when unloading driver
- Fix missing buffer free in slow ring buffer handling


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    2 +
 lpfc_hbadisc.c |   17 +++++++--
 lpfc_hw.h      |   17 +++++++++
 lpfc_init.c    |    2 +
 lpfc_mem.c     |    9 +++++
 lpfc_sli.c     |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 137 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:12:31.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-02-08 18:13:41.000000000 -0500
@@ -495,6 +495,8 @@ struct lpfc_hba {
 	wait_queue_head_t    *work_wait;
 	struct task_struct   *worker_thread;
 
+	uint32_t hbq_in_use;		/* HBQs in use flag */
+	struct list_head hbqbuf_in_list;  /* in-fly hbq buffer list */
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-02-08 18:11:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-02-08 18:13:50.000000000 -0500
@@ -629,9 +629,8 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t          *mb;
 	int i;
 
-	if (phba->link_state == LPFC_LINK_DOWN) {
+	if (phba->link_state == LPFC_LINK_DOWN)
 		return 0;
-	}
 	spin_lock_irq(&phba->hbalock);
 	if (phba->link_state > LPFC_LINK_DOWN) {
 		phba->link_state = LPFC_LINK_DOWN;
@@ -1122,7 +1121,7 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 	if (la->attType == AT_LINK_UP) {
 		phba->fc_stat.LinkUp++;
 		if (phba->link_flag & LS_LOOPBACK_MODE) {
-			lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
+			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 					"1306 Link Up Event in loop back mode "
 					"x%x received Data: x%x x%x x%x x%x\n",
 					la->eventTag, phba->fc_eventTag,
@@ -1139,11 +1138,21 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 		lpfc_mbx_process_link_up(phba, la);
 	} else {
 		phba->fc_stat.LinkDown++;
-		lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
+		if (phba->link_flag & LS_LOOPBACK_MODE) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
+				"1308 Link Down Event in loop back mode "
+				"x%x received "
+				"Data: x%x x%x x%x\n",
+				la->eventTag, phba->fc_eventTag,
+				phba->pport->port_state, vport->fc_flag);
+		}
+		else {
+			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 				"1305 Link Down Event x%x received "
 				"Data: x%x x%x x%x\n",
 				la->eventTag, phba->fc_eventTag,
 				phba->pport->port_state, vport->fc_flag);
+		}
 		lpfc_mbx_issue_link_down(phba);
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2008-02-08 18:13:04.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2008-02-08 18:13:50.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -1377,11 +1377,26 @@ typedef struct {		/* FireFly BIU registe
 #define CMD_QUE_XRI64_CX	0xB3
 #define CMD_IOCB_RCV_SEQ64_CX	0xB5
 #define CMD_IOCB_RCV_ELS64_CX	0xB7
+#define CMD_IOCB_RET_XRI64_CX	0xB9
 #define CMD_IOCB_RCV_CONT64_CX	0xBB
 
 #define CMD_GEN_REQUEST64_CR    0xC2
 #define CMD_GEN_REQUEST64_CX    0xC3
 
+/* Unhandled SLI-3 Commands */
+#define CMD_IOCB_XMIT_MSEQ64_CR		0xB0
+#define CMD_IOCB_XMIT_MSEQ64_CX		0xB1
+#define CMD_IOCB_RCV_SEQ_LIST64_CX	0xC1
+#define CMD_IOCB_RCV_ELS_LIST64_CX	0xCD
+#define CMD_IOCB_CLOSE_EXTENDED_CN	0xB6
+#define CMD_IOCB_ABORT_EXTENDED_CN	0xBA
+#define CMD_IOCB_RET_HBQE64_CN		0xCA
+#define CMD_IOCB_FCP_IBIDIR64_CR	0xAC
+#define CMD_IOCB_FCP_IBIDIR64_CX	0xAD
+#define CMD_IOCB_FCP_ITASKMGT64_CX	0xAF
+#define CMD_IOCB_LOGENTRY_CN		0x94
+#define CMD_IOCB_LOGENTRY_ASYNC_CN	0x96
+
 #define CMD_MAX_IOCB_CMD        0xE6
 #define CMD_IOCB_MASK           0xff
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:12:31.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-02-08 18:13:41.000000000 -0500
@@ -2087,6 +2087,8 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size());
 
+	INIT_LIST_HEAD(&phba->hbqbuf_in_list);
+
 	/* Initialize the SLI Layer to run with lpfc HBAs. */
 	lpfc_sli_setup(phba);
 	lpfc_sli_queue_setup(phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2008-02-08 18:12:31.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2008-02-08 18:13:41.000000000 -0500
@@ -264,18 +264,27 @@ void
 lpfc_in_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 {
 	struct hbq_dmabuf *hbq_entry;
+	unsigned long flags;
 
 	if (!mp)
 		return;
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		/* Check whether HBQ is still in use */
+		spin_lock_irqsave(&phba->hbalock, flags);
+		if (!phba->hbq_in_use) {
+			spin_unlock_irqrestore(&phba->hbalock, flags);
+			return;
+		}
 		hbq_entry = container_of(mp, struct hbq_dmabuf, dbuf);
+		list_del(&hbq_entry->dbuf.list);
 		if (hbq_entry->tag == -1) {
 			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
 				(phba, hbq_entry);
 		} else {
 			lpfc_sli_free_hbq(phba, hbq_entry);
 		}
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 	} else {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-02-08 18:13:15.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-02-08 18:13:50.000000000 -0500
@@ -203,8 +203,25 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_IOCB_RCV_SEQ64_CX:
 	case CMD_IOCB_RCV_ELS64_CX:
 	case CMD_IOCB_RCV_CONT64_CX:
+	case CMD_IOCB_RET_XRI64_CX:
 		type = LPFC_UNSOL_IOCB;
 		break;
+	case CMD_IOCB_XMIT_MSEQ64_CR:
+	case CMD_IOCB_XMIT_MSEQ64_CX:
+	case CMD_IOCB_RCV_SEQ_LIST64_CX:
+	case CMD_IOCB_RCV_ELS_LIST64_CX:
+	case CMD_IOCB_CLOSE_EXTENDED_CN:
+	case CMD_IOCB_ABORT_EXTENDED_CN:
+	case CMD_IOCB_RET_HBQE64_CN:
+	case CMD_IOCB_FCP_IBIDIR64_CR:
+	case CMD_IOCB_FCP_IBIDIR64_CX:
+	case CMD_IOCB_FCP_ITASKMGT64_CX:
+	case CMD_IOCB_LOGENTRY_CN:
+	case CMD_IOCB_LOGENTRY_ASYNC_CN:
+		printk("%s - Unhandled SLI-3 Command x%x\n",
+				__FUNCTION__, iocb_cmnd);
+		type = LPFC_UNKNOWN_IOCB;
+		break;
 	default:
 		type = LPFC_UNKNOWN_IOCB;
 		break;
@@ -529,10 +546,13 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
 {
 	struct lpfc_dmabuf *dmabuf, *next_dmabuf;
 	struct hbq_dmabuf *hbq_buf;
+	unsigned long flags;
 	int i, hbq_count;
+	uint32_t hbqno;
 
 	hbq_count = lpfc_sli_hbq_count();
 	/* Return all memory used by all HBQs */
+	spin_lock_irqsave(&phba->hbalock, flags);
 	for (i = 0; i < hbq_count; ++i) {
 		list_for_each_entry_safe(dmabuf, next_dmabuf,
 				&phba->hbqs[i].hbq_buffer_list, list) {
@@ -542,6 +562,28 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
 		}
 		phba->hbqs[i].buffer_count = 0;
 	}
+	/* Return all HBQ buffer that are in-fly */
+	list_for_each_entry_safe(dmabuf, next_dmabuf,
+			&phba->hbqbuf_in_list, list) {
+		hbq_buf = container_of(dmabuf, struct hbq_dmabuf, dbuf);
+		list_del(&hbq_buf->dbuf.list);
+		if (hbq_buf->tag == -1) {
+			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
+				(phba, hbq_buf);
+		} else {
+			hbqno = hbq_buf->tag >> 16;
+			if (hbqno >= LPFC_MAX_HBQS)
+				(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
+					(phba, hbq_buf);
+			else
+				(phba->hbqs[hbqno].hbq_free_buffer)(phba,
+					hbq_buf);
+		}
+	}
+
+	/* Mark the HBQs not in use */
+	phba->hbq_in_use = 0;
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 }
 
 static struct lpfc_hbq_entry *
@@ -603,6 +645,7 @@ static int
 lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
 {
 	uint32_t i, start, end;
+	unsigned long flags;
 	struct hbq_dmabuf *hbq_buffer;
 
 	if (!phba->hbqs[hbqno].hbq_alloc_buffer) {
@@ -615,6 +658,13 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 		end = lpfc_hbq_defs[hbqno]->entry_count;
 	}
 
+	/* Check whether HBQ is still in use */
+	spin_lock_irqsave(&phba->hbalock, flags);
+	if (!phba->hbq_in_use) {
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		return 0;
+	}
+
 	/* Populate HBQ entries */
 	for (i = start; i < end; i++) {
 		hbq_buffer = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
@@ -626,6 +676,8 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 		else
 			(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
 	}
+
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 	return 0;
 }
 
@@ -910,16 +962,29 @@ lpfc_sli_replace_hbqbuff(struct lpfc_hba
 	uint32_t hbqno;
 	void *virt;		/* virtual address ptr */
 	dma_addr_t phys;	/* mapped address */
+	unsigned long flags;
+
+	/* Check whether HBQ is still in use */
+	spin_lock_irqsave(&phba->hbalock, flags);
+	if (!phba->hbq_in_use) {
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		return NULL;
+	}
 
 	hbq_entry = lpfc_sli_hbqbuf_find(phba, tag);
-	if (hbq_entry == NULL)
+	if (hbq_entry == NULL) {
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return NULL;
+	}
 	list_del(&hbq_entry->dbuf.list);
 
 	hbqno = tag >> 16;
 	new_hbq_entry = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
-	if (new_hbq_entry == NULL)
+	if (new_hbq_entry == NULL) {
+		list_add_tail(&hbq_entry->dbuf.list, &phba->hbqbuf_in_list);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return &hbq_entry->dbuf;
+	}
 	new_hbq_entry->tag = -1;
 	phys = new_hbq_entry->dbuf.phys;
 	virt = new_hbq_entry->dbuf.virt;
@@ -928,6 +993,9 @@ lpfc_sli_replace_hbqbuff(struct lpfc_hba
 	hbq_entry->dbuf.phys = phys;
 	hbq_entry->dbuf.virt = virt;
 	lpfc_sli_free_hbq(phba, hbq_entry);
+	list_add_tail(&new_hbq_entry->dbuf.list, &phba->hbqbuf_in_list);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+
 	return &new_hbq_entry->dbuf;
 }
 
@@ -951,6 +1019,7 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	uint32_t           Rctl, Type;
 	uint32_t           match, i;
 	struct lpfc_iocbq *iocbq;
+	struct lpfc_dmabuf *dmzbuf;
 
 	match = 0;
 	irsp = &(saveq->iocb);
@@ -972,6 +1041,29 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 		return 1;
 	}
 
+	if ((irsp->ulpCommand == CMD_IOCB_RET_XRI64_CX) &&
+		(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)) {
+		if (irsp->ulpBdeCount > 0) {
+			dmzbuf = lpfc_sli_get_buff(phba, pring,
+					irsp->un.ulpWord[3]);
+			lpfc_in_buf_free(phba, dmzbuf);
+		}
+
+		if (irsp->ulpBdeCount > 1) {
+			dmzbuf = lpfc_sli_get_buff(phba, pring,
+					irsp->unsli3.sli3Words[3]);
+			lpfc_in_buf_free(phba, dmzbuf);
+		}
+
+		if (irsp->ulpBdeCount > 2) {
+			dmzbuf = lpfc_sli_get_buff(phba, pring,
+				irsp->unsli3.sli3Words[7]);
+			lpfc_in_buf_free(phba, dmzbuf);
+		}
+
+		return 1;
+	}
+
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		if (irsp->ulpBdeCount != 0) {
 			saveq->context2 = lpfc_sli_get_buff(phba, pring,
@@ -2293,6 +2385,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 
 	/* Initialize the struct lpfc_sli_hbq structure for each hbq */
 	phba->link_state = LPFC_INIT_MBX_CMDS;
+	phba->hbq_in_use = 1;
 
 	hbq_entry_index = 0;
 	for (hbqno = 0; hbqno < hbq_count; ++hbqno) {


