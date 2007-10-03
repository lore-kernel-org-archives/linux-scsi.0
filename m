From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 16/21] advansys: Move a couple of fields from struct board to struct adv_dvc
Date: Tue,  2 Oct 2007 21:55:37 -0400
Message-ID: <1191376543943-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:53919 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbXJCBzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:46 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

board->carrp is a duplicate of asc_dvc->carrier_buf, so cut out the
middle-man and assign directly to carrier_buf.  Move orig_reqp to adv_dvc
too, since it's wide-board specific.  Also eliminate an unnecessary BUG_ON
(we'll never get there with a NULL carrier_buf, and will crash if we do).
The bulk of this patch is rearranging structures so everything's declared
in the right order.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/advansys.c |  193 ++++++++++++++++++++++------------------------
 1 files changed, 92 insertions(+), 101 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 644582d..1e2b3b0 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -983,15 +983,14 @@ typedef struct asc_mc_saved {
  * elements. Allow each command to have at least one ADV_SG_BLOCK structure.
  * This allows about 15 commands to have the maximum 17 ADV_SG_BLOCK
  * structures or 255 scatter-gather elements.
- *
  */
 #define ADV_TOT_SG_BLOCK        ASC_DEF_MAX_HOST_QNG
 
 /*
- * Define Adv Library required maximum number of scatter-gather
- * elements per request.
+ * Define maximum number of scatter-gather elements per request.
  */
 #define ADV_MAX_SG_LIST         255
+#define NO_OF_SG_PER_BLOCK              15
 
 /* Number of SG blocks needed. */
 #define ADV_NUM_SG_BLOCK \
@@ -1839,55 +1838,6 @@ typedef struct adv_dvc_cfg {
 struct adv_dvc_var;
 struct adv_scsi_req_q;
 
-/*
- * Adapter operation variable structure.
- *
- * One structure is required per host adapter.
- *
- * Field naming convention:
- *
- *  *_able indicates both whether a feature should be enabled or disabled
- *  and whether a device isi capable of the feature. At initialization
- *  this field may be set, but later if a device is found to be incapable
- *  of the feature, the field is cleared.
- */
-typedef struct adv_dvc_var {
-	AdvPortAddr iop_base;	/* I/O port address */
-	ushort err_code;	/* fatal error code */
-	ushort bios_ctrl;	/* BIOS control word, EEPROM word 12 */
-	ushort wdtr_able;	/* try WDTR for a device */
-	ushort sdtr_able;	/* try SDTR for a device */
-	ushort ultra_able;	/* try SDTR Ultra speed for a device */
-	ushort sdtr_speed1;	/* EEPROM SDTR Speed for TID 0-3   */
-	ushort sdtr_speed2;	/* EEPROM SDTR Speed for TID 4-7   */
-	ushort sdtr_speed3;	/* EEPROM SDTR Speed for TID 8-11  */
-	ushort sdtr_speed4;	/* EEPROM SDTR Speed for TID 12-15 */
-	ushort tagqng_able;	/* try tagged queuing with a device */
-	ushort ppr_able;	/* PPR message capable per TID bitmask. */
-	uchar max_dvc_qng;	/* maximum number of tagged commands per device */
-	ushort start_motor;	/* start motor command allowed */
-	uchar scsi_reset_wait;	/* delay in seconds after scsi bus reset */
-	uchar chip_no;		/* should be assigned by caller */
-	uchar max_host_qng;	/* maximum number of Q'ed command allowed */
-	ushort no_scam;		/* scam_tolerant of EEPROM */
-	struct asc_board *drv_ptr;	/* driver pointer to private structure */
-	uchar chip_scsi_id;	/* chip SCSI target ID */
-	uchar chip_type;
-	uchar bist_err_code;
-	ADV_CARR_T *carrier_buf;
-	ADV_CARR_T *carr_freelist;	/* Carrier free list. */
-	ADV_CARR_T *icq_sp;	/* Initiator command queue stopper pointer. */
-	ADV_CARR_T *irq_sp;	/* Initiator response queue stopper pointer. */
-	ushort carr_pending_cnt;	/* Count of pending carriers. */
-	/*
-	 * Note: The following fields will not be used after initialization. The
-	 * driver may discard the buffer after initialization is done.
-	 */
-	ADV_DVC_CFG *cfg;	/* temporary configuration structure  */
-} ADV_DVC_VAR;
-
-#define NO_OF_SG_PER_BLOCK              15
-
 typedef struct asc_sg_block {
 	uchar reserved1;
 	uchar reserved2;
@@ -1946,6 +1896,83 @@ typedef struct adv_scsi_req_q {
 } ADV_SCSI_REQ_Q;
 
 /*
+ * The following two structures are used to process Wide Board requests.
+ *
+ * The ADV_SCSI_REQ_Q structure in adv_req_t is passed to the Adv Library
+ * and microcode with the ADV_SCSI_REQ_Q field 'srb_ptr' pointing to the
+ * adv_req_t. The adv_req_t structure 'cmndp' field in turn points to the
+ * Mid-Level SCSI request structure.
+ *
+ * Zero or more ADV_SG_BLOCK are used with each ADV_SCSI_REQ_Q. Each
+ * ADV_SG_BLOCK structure holds 15 scatter-gather elements. Under Linux
+ * up to 255 scatter-gather elements may be used per request or
+ * ADV_SCSI_REQ_Q.
+ *
+ * Both structures must be 32 byte aligned.
+ */
+typedef struct adv_sgblk {
+	ADV_SG_BLOCK sg_block;	/* Sgblock structure. */
+	uchar align[32];	/* Sgblock structure padding. */
+	struct adv_sgblk *next_sgblkp;	/* Next scatter-gather structure. */
+} adv_sgblk_t;
+
+typedef struct adv_req {
+	ADV_SCSI_REQ_Q scsi_req_q;	/* Adv Library request structure. */
+	uchar align[32];	/* Request structure padding. */
+	struct scsi_cmnd *cmndp;	/* Mid-Level SCSI command pointer. */
+	adv_sgblk_t *sgblkp;	/* Adv Library scatter-gather pointer. */
+	struct adv_req *next_reqp;	/* Next Request Structure. */
+} adv_req_t;
+
+/*
+ * Adapter operation variable structure.
+ *
+ * One structure is required per host adapter.
+ *
+ * Field naming convention:
+ *
+ *  *_able indicates both whether a feature should be enabled or disabled
+ *  and whether a device isi capable of the feature. At initialization
+ *  this field may be set, but later if a device is found to be incapable
+ *  of the feature, the field is cleared.
+ */
+typedef struct adv_dvc_var {
+	AdvPortAddr iop_base;	/* I/O port address */
+	ushort err_code;	/* fatal error code */
+	ushort bios_ctrl;	/* BIOS control word, EEPROM word 12 */
+	ushort wdtr_able;	/* try WDTR for a device */
+	ushort sdtr_able;	/* try SDTR for a device */
+	ushort ultra_able;	/* try SDTR Ultra speed for a device */
+	ushort sdtr_speed1;	/* EEPROM SDTR Speed for TID 0-3   */
+	ushort sdtr_speed2;	/* EEPROM SDTR Speed for TID 4-7   */
+	ushort sdtr_speed3;	/* EEPROM SDTR Speed for TID 8-11  */
+	ushort sdtr_speed4;	/* EEPROM SDTR Speed for TID 12-15 */
+	ushort tagqng_able;	/* try tagged queuing with a device */
+	ushort ppr_able;	/* PPR message capable per TID bitmask. */
+	uchar max_dvc_qng;	/* maximum number of tagged commands per device */
+	ushort start_motor;	/* start motor command allowed */
+	uchar scsi_reset_wait;	/* delay in seconds after scsi bus reset */
+	uchar chip_no;		/* should be assigned by caller */
+	uchar max_host_qng;	/* maximum number of Q'ed command allowed */
+	ushort no_scam;		/* scam_tolerant of EEPROM */
+	struct asc_board *drv_ptr;	/* driver pointer to private structure */
+	uchar chip_scsi_id;	/* chip SCSI target ID */
+	uchar chip_type;
+	uchar bist_err_code;
+	ADV_CARR_T *carrier_buf;
+	ADV_CARR_T *carr_freelist;	/* Carrier free list. */
+	ADV_CARR_T *icq_sp;	/* Initiator command queue stopper pointer. */
+	ADV_CARR_T *irq_sp;	/* Initiator response queue stopper pointer. */
+	ushort carr_pending_cnt;	/* Count of pending carriers. */
+	struct adv_req *orig_reqp;	/* adv_req_t memory block. */
+	/*
+	 * Note: The following fields will not be used after initialization. The
+	 * driver may discard the buffer after initialization is done.
+	 */
+	ADV_DVC_CFG *cfg;	/* temporary configuration structure  */
+} ADV_DVC_VAR;
+
+/*
  * Microcode idle loop commands
  */
 #define IDLE_CMD_COMPLETED           0
@@ -2362,37 +2389,6 @@ struct asc_stats {
 #endif /* ADVANSYS_STATS */
 
 /*
- * Adv Library Request Structures
- *
- * The following two structures are used to process Wide Board requests.
- *
- * The ADV_SCSI_REQ_Q structure in adv_req_t is passed to the Adv Library
- * and microcode with the ADV_SCSI_REQ_Q field 'srb_ptr' pointing to the
- * adv_req_t. The adv_req_t structure 'cmndp' field in turn points to the
- * Mid-Level SCSI request structure.
- *
- * Zero or more ADV_SG_BLOCK are used with each ADV_SCSI_REQ_Q. Each
- * ADV_SG_BLOCK structure holds 15 scatter-gather elements. Under Linux
- * up to 255 scatter-gather elements may be used per request or
- * ADV_SCSI_REQ_Q.
- *
- * Both structures must be 32 byte aligned.
- */
-typedef struct adv_sgblk {
-	ADV_SG_BLOCK sg_block;	/* Sgblock structure. */
-	uchar align[32];	/* Sgblock structure padding. */
-	struct adv_sgblk *next_sgblkp;	/* Next scatter-gather structure. */
-} adv_sgblk_t;
-
-typedef struct adv_req {
-	ADV_SCSI_REQ_Q scsi_req_q;	/* Adv Library request structure. */
-	uchar align[32];	/* Request structure padding. */
-	struct scsi_cmnd *cmndp;	/* Mid-Level SCSI command pointer. */
-	adv_sgblk_t *sgblkp;	/* Adv Library scatter-gather pointer. */
-	struct adv_req *next_reqp;	/* Next Request Structure. */
-} adv_req_t;
-
-/*
  * Structure allocated for each board.
  *
  * This structure is allocated by scsi_host_alloc() at the end
@@ -2437,8 +2433,6 @@ struct asc_board {
 	 */
 	void __iomem *ioremap_addr;	/* I/O Memory remap address. */
 	ushort ioport;		/* I/O Port address. */
-	ADV_CARR_T *carrp;	/* ADV_CARR_T memory block. */
-	adv_req_t *orig_reqp;	/* adv_req_t memory block. */
 	adv_req_t *adv_reqp;	/* Request structures. */
 	adv_sgblk_t *adv_sgblkp;	/* Scatter-gather structures. */
 	ushort bios_signature;	/* BIOS Signature. */
@@ -6518,8 +6512,6 @@ static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
 	ADV_SDCNT buf_size;
 	ADV_PADDR carr_paddr;
 
-	BUG_ON(!asc_dvc->carrier_buf);
-
 	carrp = (ADV_CARR_T *) ADV_16BALIGN(asc_dvc->carrier_buf);
 	asc_dvc->carr_freelist = NULL;
 	if (carrp == asc_dvc->carrier_buf) {
@@ -13442,10 +13434,10 @@ static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
 	 * Allocate buffer carrier structures. The total size
 	 * is about 4 KB, so allocate all at once.
 	 */
-	board->carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
-	ASC_DBG(1, "carrp 0x%p\n", board->carrp);
+	adv_dvc->carrier_buf = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
+	ASC_DBG(1, "carrier_buf 0x%p\n", adv_dvc->carrier_buf);
 
-	if (!board->carrp)
+	if (!adv_dvc->carrier_buf)
 		goto kmalloc_failed;
 
 	/*
@@ -13466,7 +13458,7 @@ static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
 	if (!reqp)
 		goto kmalloc_failed;
 
-	board->orig_reqp = reqp;
+	adv_dvc->orig_reqp = reqp;
 
 	/*
 	 * Allocate up to ADV_TOT_SG_BLOCK request structures for
@@ -13490,8 +13482,6 @@ static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
 	if (!board->adv_sgblkp)
 		goto kmalloc_failed;
 
-	adv_dvc->carrier_buf = board->carrp;
-
 	/*
 	 * Point 'adv_reqp' to the request structures and
 	 * link them together.
@@ -13529,15 +13519,16 @@ static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
 	return err_code;
 }
 
-static void advansys_wide_free_mem(struct asc_board *boardp)
+static void advansys_wide_free_mem(struct asc_board *board)
 {
-	kfree(boardp->carrp);
-	boardp->carrp = NULL;
-	kfree(boardp->orig_reqp);
-	boardp->orig_reqp = boardp->adv_reqp = NULL;
-	while (boardp->adv_sgblkp) {
-		adv_sgblk_t *sgp = boardp->adv_sgblkp;
-		boardp->adv_sgblkp = sgp->next_sgblkp;
+	struct adv_dvc_var *adv_dvc = &board->dvc_var.adv_dvc_var;
+	kfree(adv_dvc->carrier_buf);
+	adv_dvc->carrier_buf = NULL;
+	kfree(adv_dvc->orig_reqp);
+	adv_dvc->orig_reqp = board->adv_reqp = NULL;
+	while (board->adv_sgblkp) {
+		adv_sgblk_t *sgp = board->adv_sgblkp;
+		board->adv_sgblkp = sgp->next_sgblkp;
 		kfree(sgp);
 	}
 }
-- 
1.5.3.1

