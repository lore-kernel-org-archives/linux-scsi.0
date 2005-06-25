From: James.Smart@Emulex.Com
Subject: [PATCH 1 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:00 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4146@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36030 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261237AbVFYOeC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:02 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEY09P008159
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:01 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


hgp/pgp cleanups from Christoph Hellwig

Merge patch from Christoph Hellwig <hch@lst.de>:
[PATCH] lpfc: hgp/pgp cleanups

 - rename PGP/HPH to lpfc_pgp/lpfc_hgp
 - use __le32 types for the members to start fixing sparse -Wbitwise
   issues
 - remove lpfc_sli.MBhostaddr, we can always use the pointer from
   SLI2_DESC directly

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_hw.h   |   20 ++---
 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_mbox.c |    7 -
 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_sli.c  |   45 +++---------
 3 files changed, 26 insertions(+), 46 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_mbox.c~hgp drivers/scsi/lpfc/lpfc_mbox.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_mbox.c~hgp	2005-06-25 09:41:44.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_mbox.c	2005-06-25 09:41:44.000000000 -0400
@@ -422,7 +422,6 @@ lpfc_config_pcb_setup(struct lpfc_hba * 
 	uint32_t iocbCnt;
 	int i;
 
-	psli->MBhostaddr = (uint32_t *)&phba->slim2p->mbx;
 	pcbp->maxRing = (psli->num_rings - 1);
 
 	iocbCnt = 0;
@@ -528,7 +527,7 @@ lpfc_config_port(struct lpfc_hba * phba,
 	dma_addr_t pdma_addr;
 	uint32_t bar_low, bar_high;
 	size_t offset;
-	HGP hgp;
+	struct lpfc_hgp hgp;
 	void __iomem *to_slim;
 
 	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
@@ -584,9 +583,9 @@ lpfc_config_port(struct lpfc_hba * phba,
 	else
 		phba->slim2p->pcb.hgpAddrHigh = 0;
 	/* write HGP data to SLIM at the required longword offset */
-	memset(&hgp, 0, sizeof(HGP));
+	memset(&hgp, 0, sizeof(struct lpfc_hgp));
 	to_slim = phba->MBslimaddr + (SLIMOFF*sizeof (uint32_t));
-	lpfc_memcpy_to_slim(to_slim, &hgp, sizeof (HGP));
+	lpfc_memcpy_to_slim(to_slim, &hgp, sizeof(struct lpfc_hgp));
 
 	/* Setup Port Group ring pointer */
 	offset = (uint8_t *)&phba->slim2p->mbx.us.s2.port -
diff -puN drivers/scsi/lpfc/lpfc_hw.h~hgp drivers/scsi/lpfc/lpfc_hw.h
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_hw.h~hgp	2005-06-25 09:41:44.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_hw.h	2005-06-25 09:41:44.000000000 -0400
@@ -2214,20 +2214,20 @@ typedef union {
  * SLI-2 specific structures
  */
 
-typedef struct {
-	uint32_t cmdPutInx;
-	uint32_t rspGetInx;
-} HGP;
+struct lpfc_hgp {
+	__le32 cmdPutInx;
+	__le32 rspGetInx;
+};
 
-typedef struct {
-	uint32_t cmdGetInx;
-	uint32_t rspPutInx;
-} PGP;
+struct lpfc_pgp {
+	__le32 cmdGetInx;
+	__le32 rspPutInx;
+};
 
 typedef struct _SLI2_DESC {
-	HGP host[MAX_RINGS];
+	struct lpfc_hgp host[MAX_RINGS];
 	uint32_t unused1[16];
-	PGP port[MAX_RINGS];
+	struct lpfc_pgp port[MAX_RINGS];
 } SLI2_DESC;
 
 typedef union {
diff -puN drivers/scsi/lpfc/lpfc_sli.c~hgp drivers/scsi/lpfc/lpfc_sli.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_sli.c~hgp	2005-06-25 09:41:44.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_sli.c	2005-06-25 09:41:44.000000000 -0400
@@ -225,8 +225,7 @@ lpfc_sli_ringtx_get(struct lpfc_hba * ph
 static IOCB_t *
 lpfc_sli_next_iocb_slot (struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
-	MAILBOX_t *mbox = (MAILBOX_t *)phba->sli.MBhostaddr;
-	PGP *pgp = (PGP *)&mbox->us.s2.port[pring->ringno];
+	struct lpfc_pgp *pgp = &phba->slim2p->mbx.us.s2.port[pring->ringno];
 	uint32_t  max_cmd_idx = pring->numCiocb;
 	IOCB_t *iocb = NULL;
 
@@ -411,9 +410,7 @@ lpfc_sli_resume_iocb(struct lpfc_hba * p
 static void
 lpfc_sli_turn_on_ring(struct lpfc_hba * phba, int ringno)
 {
-	PGP *pgp =
-		((PGP *) &
-		 (((MAILBOX_t *)phba->sli.MBhostaddr)->us.s2.port[ringno]));
+	struct lpfc_pgp *pgp = &phba->slim2p->mbx.us.s2.port[ringno];
 
 	/* If the ring is active, flag it */
 	if (phba->sli.ring[ringno].cmdringaddr) {
@@ -537,7 +534,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 	/* Get a Mailbox buffer to setup mailbox commands for callback */
 	if ((pmb = phba->sli.mbox_active)) {
 		pmbox = &pmb->mb;
-		mbox = (MAILBOX_t *) phba->sli.MBhostaddr;
+		mbox = &phba->slim2p->mbx;
 
 		/* First check out the status word */
 		lpfc_sli_pcimem_bcopy(mbox, pmbox, sizeof (uint32_t));
@@ -905,10 +902,10 @@ static int
 lpfc_sli_handle_fast_ring_event(struct lpfc_hba * phba,
 				struct lpfc_sli_ring * pring, uint32_t mask)
 {
+ 	struct lpfc_pgp *pgp = &phba->slim2p->mbx.us.s2.port[pring->ringno];
 	IOCB_t *irsp = NULL;
 	struct lpfc_iocbq *cmdiocbq = NULL;
 	struct lpfc_iocbq rspiocbq;
-	PGP *pgp;
 	uint32_t status;
 	uint32_t portRspPut, portRspMax;
 	int rc = 1;
@@ -920,10 +917,6 @@ lpfc_sli_handle_fast_ring_event(struct l
 	spin_lock_irqsave(phba->host->host_lock, iflag);
 	pring->stats.iocb_event++;
 
-	/* The driver assumes SLI-2 mode */
-	pgp = (PGP *) &((MAILBOX_t *) phba->sli.MBhostaddr)
-		->us.s2.port[pring->ringno];
-
 	/*
 	 * The next available response entry should never exceed the maximum
 	 * entries.  If it does, treat it as an adapter hardware error.
@@ -1075,9 +1068,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 	struct lpfc_iocbq *cmdiocbp;
 	struct lpfc_iocbq *saveq;
 	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
-	HGP *hgp;
-	PGP *pgp;
-	MAILBOX_t *mbox;
+	struct lpfc_pgp *pgp = &phba->slim2p->mbx.us.s2.port[pring->ringno];
 	uint8_t iocb_cmd_type;
 	lpfc_iocb_type type;
 	uint32_t status, free_saveq;
@@ -1089,11 +1080,6 @@ lpfc_sli_handle_slow_ring_event(struct l
 	spin_lock_irqsave(phba->host->host_lock, iflag);
 	pring->stats.iocb_event++;
 
-	/* The driver assumes SLI-2 mode */
-	mbox = (MAILBOX_t *) phba->sli.MBhostaddr;
-	pgp = (PGP *) & mbox->us.s2.port[pring->ringno];
-	hgp = (HGP *) & mbox->us.s2.host[pring->ringno];
-
 	/*
 	 * The next available response entry should never exceed the maximum
 	 * entries.  If it does, treat it as an adapter hardware error.
@@ -1771,7 +1757,6 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 int
 lpfc_sli_issue_mbox(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmbox, uint32_t flag)
 {
-	MAILBOX_t *mbox;
 	MAILBOX_t *mb;
 	struct lpfc_sli *psli;
 	uint32_t status, evtctr;
@@ -1901,15 +1886,13 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 	mb->mbxOwner = OWN_CHIP;
 
 	if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
-
 		/* First copy command data to host SLIM area */
-		mbox = (MAILBOX_t *) psli->MBhostaddr;
-		lpfc_sli_pcimem_bcopy(mb, mbox, MAILBOX_CMD_SIZE);
+		lpfc_sli_pcimem_bcopy(mb, &phba->slim2p->mbx, MAILBOX_CMD_SIZE);
 	} else {
 		if (mb->mbxCommand == MBX_CONFIG_PORT) {
 			/* copy command data into host mbox for cmpl */
-			mbox = (MAILBOX_t *) psli->MBhostaddr;
-			lpfc_sli_pcimem_bcopy(mb, mbox, MAILBOX_CMD_SIZE);
+			lpfc_sli_pcimem_bcopy(mb, &phba->slim2p->mbx,
+					MAILBOX_CMD_SIZE);
 		}
 
 		/* First copy mbox command data to HBA SLIM, skip past first
@@ -1946,8 +1929,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 		psli->mbox_active = NULL;
 		if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 			/* First read mbox status word */
-			mbox = (MAILBOX_t *) psli->MBhostaddr;
-			word0 = *((volatile uint32_t *)mbox);
+			word0 = *((volatile uint32_t *)&phba->slim2p->mbx);
 			word0 = le32_to_cpu(word0);
 		} else {
 			/* First read mbox status word */
@@ -1984,8 +1966,8 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 
 			if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 				/* First copy command data */
-				mbox = (MAILBOX_t *) psli->MBhostaddr;
-				word0 = *((volatile uint32_t *)mbox);
+				word0 = *((volatile uint32_t *)
+						&phba->slim2p->mbx);
 				word0 = le32_to_cpu(word0);
 				if (mb->mbxCommand == MBX_CONFIG_PORT) {
 					MAILBOX_t *slimmb;
@@ -2009,10 +1991,9 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 		}
 
 		if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
-			/* First copy command data */
-			mbox = (MAILBOX_t *) psli->MBhostaddr;
 			/* copy results back to user */
-			lpfc_sli_pcimem_bcopy(mbox, mb, MAILBOX_CMD_SIZE);
+			lpfc_sli_pcimem_bcopy(&phba->slim2p->mbx, mb,
+					MAILBOX_CMD_SIZE);
 		} else {
 			/* First copy command data */
 			lpfc_memcpy_from_slim(mb, phba->MBslimaddr,
_
