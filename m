From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/9] lpfc 8.2.3 : Internal loopback fixes
Date: Sat, 27 Oct 2007 13:38:00 -0400
Message-ID: <1193506680.8770.26.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46365 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbXJ0Rhy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:37:54 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHbrXE021389
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:37:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Internal loopback fixes:
- Use HBQs rather than Q_RING_BUFF
- Correct HBQs continuation entries
- Update CT handler to SLI3 iocbs

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 13:07:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-10-27 13:12:18.000000000 -0400
@@ -211,6 +211,11 @@ int lpfc_sli_ringpostbuf_put(struct lpfc
 struct lpfc_dmabuf *lpfc_sli_ringpostbuf_get(struct lpfc_hba *,
 					     struct lpfc_sli_ring *,
 					     dma_addr_t);
+
+uint32_t lpfc_sli_get_buffer_tag(struct lpfc_hba *);
+struct lpfc_dmabuf * lpfc_sli_ring_taggedbuf_get(struct lpfc_hba *,
+			struct lpfc_sli_ring *, uint32_t );
+
 int lpfc_sli_hbq_count(void);
 int lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *, uint32_t);
 int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-10-27 13:11:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-10-27 13:12:18.000000000 -0400
@@ -68,6 +68,7 @@ struct lpfc_dmabuf {
 	struct list_head list;
 	void *virt;		/* virtual address ptr */
 	dma_addr_t phys;	/* mapped address */
+	uint32_t   buffer_tag;	/* used for tagged queue ring */
 };
 
 struct lpfc_dma_pool {
@@ -582,6 +583,12 @@ struct lpfc_hba {
 	unsigned long last_completion_time;
 	struct timer_list hb_tmofunc;
 	uint8_t hb_outstanding;
+	/*
+	 * Following bit will be set for all buffer tags which are not
+	 * associated with any HBQ.
+	 */
+#define QUE_BUFTAG_BIT  (1<<31)
+	uint32_t buffer_tag_count;
 };
 
 static inline struct Scsi_Host *
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2007-10-27 13:11:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2007-10-27 13:12:18.000000000 -0400
@@ -1373,6 +1373,7 @@ typedef struct {		/* FireFly BIU registe
 #define CMD_FCP_TRECEIVE64_CX   0xA1
 #define CMD_FCP_TRSP64_CX       0xA3
 
+#define CMD_QUE_XRI64_CX	0xB3
 #define CMD_IOCB_RCV_SEQ64_CX	0xB5
 #define CMD_IOCB_RCV_ELS64_CX	0xB7
 #define CMD_IOCB_RCV_CONT64_CX	0xBB
@@ -3039,7 +3040,26 @@ struct rcv_sli3 {
 	struct ulp_bde64 bde2;
 };
 
+/* Structure used for a single HBQ entry */
+struct lpfc_hbq_entry {
+	struct ulp_bde64 bde;
+	uint32_t buffer_tag;
+};
 
+/* IOCB Command template for QUE_XRI64_CX (0xB3) command */
+typedef struct {
+	struct lpfc_hbq_entry   buff;
+	uint32_t                rsvd;
+	uint32_t		rsvd1;
+} QUE_XRI64_CX_FIELDS;
+
+struct que_xri64cx_ext_fields {
+	uint32_t	iotag64_low;
+	uint32_t	iotag64_high;
+	uint32_t	ebde_count;
+	uint32_t	rsvd;
+	struct lpfc_hbq_entry	buff[5];
+};
 
 typedef struct _IOCB {	/* IOCB structure */
 	union {
@@ -3064,6 +3084,7 @@ typedef struct _IOCB {	/* IOCB structure
 		FCPI_FIELDS64 fcpi64;	/* FCP 64 bit Initiator template */
 		FCPT_FIELDS64 fcpt64;	/* FCP 64 bit target template */
 		ASYNCSTAT_FIELDS asyncstat; /* async_status iocb */
+		QUE_XRI64_CX_FIELDS quexri64cx; /* que_xri64_cx fields */
 
 		uint32_t ulpWord[IOCB_WORD_SZ - 2];	/* generic 6 'words' */
 	} un;
@@ -3121,6 +3142,10 @@ typedef struct _IOCB {	/* IOCB structure
 
 	union {
 		struct rcv_sli3 rcvsli3; /* words 8 - 15 */
+
+		/* words 8-31 used for que_xri_cx iocb */
+		struct que_xri64cx_ext_fields que_xri64cx_ext_words;
+
 		uint32_t sli3Words[24]; /* 96 extra bytes for SLI-3 */
 	} unsli3;
 
@@ -3160,12 +3185,6 @@ typedef struct _IOCB {	/* IOCB structure
 
 } IOCB_t;
 
-/* Structure used for a single HBQ entry */
-struct lpfc_hbq_entry {
-	struct ulp_bde64 bde;
-	uint32_t buffer_tag;
-};
-
 
 #define SLI1_SLIM_SIZE   (4 * 1024)
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 13:11:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 13:12:18.000000000 -0400
@@ -931,6 +931,16 @@ lpfc_sli_replace_hbqbuff(struct lpfc_hba
 	return &new_hbq_entry->dbuf;
 }
 
+static struct lpfc_dmabuf *
+lpfc_sli_get_buff(struct lpfc_hba *phba,
+			struct lpfc_sli_ring *pring,
+			uint32_t tag)
+{
+	if (tag & QUE_BUFTAG_BIT)
+		return lpfc_sli_ring_taggedbuf_get(phba, pring, tag);
+	else
+		return lpfc_sli_replace_hbqbuff(phba, tag);
+}
 
 static int
 lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
@@ -940,6 +950,7 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	WORD5            * w5p;
 	uint32_t           Rctl, Type;
 	uint32_t           match, i;
+	struct lpfc_iocbq *iocbq;
 
 	match = 0;
 	irsp = &(saveq->iocb);
@@ -984,12 +995,69 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	}
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
-		if (irsp->ulpBdeCount != 0)
-			saveq->context2 = lpfc_sli_replace_hbqbuff(phba,
+		struct lpfc_hbq_entry *hbqe_1, *hbqe_2;
+		hbqe_1 = (struct lpfc_hbq_entry *) &saveq->iocb.un.ulpWord[0];
+		hbqe_2 = (struct lpfc_hbq_entry *) &saveq->iocb.
+				unsli3.sli3Words[4];
+
+		if (irsp->ulpBdeCount != 0) {
+			saveq->context2 = lpfc_sli_get_buff(phba, pring,
+						irsp->un.ulpWord[3]);
+			if (!saveq->context2)
+				lpfc_printf_log(phba,
+					KERN_ERR,
+					LOG_SLI,
+					"0341 Ring %d Cannot find buffer for "
+					"an unsolicited iocb. tag 0x%x\n",
+					pring->ringno,
+					irsp->un.ulpWord[3]);
+
+		}
+		if (irsp->ulpBdeCount == 2) {
+			saveq->context3 = lpfc_sli_get_buff(phba, pring,
+						irsp->unsli3.sli3Words[7]);
+			if (!saveq->context3)
+				lpfc_printf_log(phba,
+					KERN_ERR,
+					LOG_SLI,
+					"0342 Ring %d Cannot find buffer for an"
+					" unsolicited iocb. tag 0x%x\n",
+					pring->ringno,
+					irsp->unsli3.sli3Words[7]);
+		}
+		list_for_each_entry(iocbq, &saveq->list, list) {
+			hbqe_1 = (struct lpfc_hbq_entry *) &iocbq->iocb.
+				un.ulpWord[0];
+			hbqe_2 = (struct lpfc_hbq_entry *) &iocbq->iocb.
+				unsli3.sli3Words[4];
+			irsp = &(iocbq->iocb);
+
+			if (irsp->ulpBdeCount != 0) {
+				iocbq->context2 = lpfc_sli_get_buff(phba, pring,
+							irsp->un.ulpWord[3]);
+				if (!saveq->context2)
+					lpfc_printf_log(phba,
+						KERN_ERR,
+						LOG_SLI,
+						"0343 Ring %d Cannot find "
+						"buffer for an unsolicited iocb"
+						". tag 0x%x\n", pring->ringno,
 						irsp->un.ulpWord[3]);
-		if (irsp->ulpBdeCount == 2)
-			saveq->context3 = lpfc_sli_replace_hbqbuff(phba,
+			}
+			if (irsp->ulpBdeCount == 2) {
+				iocbq->context3 = lpfc_sli_get_buff(phba, pring,
+						irsp->unsli3.sli3Words[7]);
+				if (!saveq->context3)
+					lpfc_printf_log(phba,
+						KERN_ERR,
+						LOG_SLI,
+						"0344 Ring %d Cannot find "
+						"buffer for an unsolicited "
+						"iocb. tag 0x%x\n",
+						pring->ringno,
 						irsp->unsli3.sli3Words[7]);
+			}
+		}
 	}
 
 	/* unSolicited Responses */
@@ -2480,7 +2548,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	lpfc_sli_abort_iocb_ring(phba, pring);
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-			"0316 Resetting board due to mailbox timeout\n");
+			"0345 Resetting board due to mailbox timeout\n");
 	/*
 	 * lpfc_offline calls lpfc_sli_hba_down which will clean up
 	 * on oustanding mailbox commands.
@@ -2975,7 +3043,7 @@ lpfc_sli_async_event_handler(struct lpfc
 		lpfc_printf_log(phba,
 			KERN_ERR,
 			LOG_SLI,
-			"0327 Ring %d handler: unexpected ASYNC_STATUS"
+			"0346 Ring %d handler: unexpected ASYNC_STATUS"
 			" evt_code 0x%x\n",
 			pring->ringno,
 			icmd->un.asyncstat.evt_code);
@@ -2988,7 +3056,7 @@ lpfc_sli_async_event_handler(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_WARNING,
 				LOG_TEMP,
-				"0339 Adapter is very hot, please take "
+				"0347 Adapter is very hot, please take "
 				"corrective action. temperature : %d Celsius\n",
 				temp);
 	}
@@ -3314,6 +3382,47 @@ lpfc_sli_ringpostbuf_put(struct lpfc_hba
 	return 0;
 }
 
+uint32_t
+lpfc_sli_get_buffer_tag(struct lpfc_hba *phba)
+{
+	spin_lock_irq(&phba->hbalock);
+	phba->buffer_tag_count++;
+	/*
+	 * Always set the QUE_BUFTAG_BIT to distiguish between
+	 * a tag assigned by HBQ.
+	 */
+	phba->buffer_tag_count |= QUE_BUFTAG_BIT;
+	spin_unlock_irq(&phba->hbalock);
+	return phba->buffer_tag_count;
+}
+
+struct lpfc_dmabuf *
+lpfc_sli_ring_taggedbuf_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			uint32_t tag)
+{
+	struct lpfc_dmabuf *mp, *next_mp;
+	struct list_head *slp = &pring->postbufq;
+
+	/* Search postbufq, from the begining, looking for a match on tag */
+	spin_lock_irq(&phba->hbalock);
+	list_for_each_entry_safe(mp, next_mp, &pring->postbufq, list) {
+		if (mp->buffer_tag == tag) {
+			list_del_init(&mp->list);
+			pring->postbufq_cnt--;
+			spin_unlock_irq(&phba->hbalock);
+			return mp;
+		}
+	}
+
+	spin_unlock_irq(&phba->hbalock);
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"0410 Cannot find virtual addr for buffer tag on "
+			"ring %d Data x%lx x%p x%p x%x\n",
+			pring->ringno, (unsigned long) tag,
+			slp->next, slp->prev, pring->postbufq_cnt);
+
+	return NULL;
+}
 
 struct lpfc_dmabuf *
 lpfc_sli_ringpostbuf_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,


