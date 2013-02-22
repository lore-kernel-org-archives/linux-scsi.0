From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: fix lpfc build when wmb() is defined as mb()
Date: Fri, 22 Feb 2013 10:23:54 -0800
Message-ID: <5127B7BA.3040703@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51606 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152Ab3BVSXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 13:23:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, James Smart <james.smart@emulex.com>

From: Randy Dunlap <rdunlap@infradead.org>

On architectures where wmb() is defined as mb(), a build error
happens since there is also a variable named 'mb' in lpfc_sli.c's
lpfc_sli_issue_mbox_s3() function.  Rename the variable to 'mbx'
to prevent the build error.

drivers/scsi/lpfc/lpfc_sli.c: error: called object 'mb' is not a function

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	James Smart <james.smart@emulex.com>
Cc:	"James E.J. Bottomley" <JBottomley@parallels.com>
Cc:	linux-scsi@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_sli.c |   56 ++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 28 deletions(-)

--- lnx-38.orig/drivers/scsi/lpfc/lpfc_sli.c
+++ lnx-38/drivers/scsi/lpfc/lpfc_sli.c
@@ -6599,7 +6599,7 @@ static int
 lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 		       uint32_t flag)
 {
-	MAILBOX_t *mb;
+	MAILBOX_t *mbx;
 	struct lpfc_sli *psli = &phba->sli;
 	uint32_t status, evtctr;
 	uint32_t ha_copy, hc_copy;
@@ -6653,7 +6653,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 
 	psli = &phba->sli;
 
-	mb = &pmbox->u.mb;
+	mbx = &pmbox->u.mb;
 	status = MBX_SUCCESS;
 
 	if (phba->link_state == LPFC_HBA_ERROR) {
@@ -6668,7 +6668,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 		goto out_not_finished;
 	}
 
-	if (mb->mbxCommand != MBX_KILL_BOARD && flag & MBX_NOWAIT) {
+	if (mbx->mbxCommand != MBX_KILL_BOARD && flag & MBX_NOWAIT) {
 		if (lpfc_readl(phba->HCregaddr, &hc_copy) ||
 			!(hc_copy & HC_MBINT_ENA)) {
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
@@ -6722,7 +6722,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 				"(%d):0308 Mbox cmd issue - BUSY Data: "
 				"x%x x%x x%x x%x\n",
 				pmbox->vport ? pmbox->vport->vpi : 0xffffff,
-				mb->mbxCommand, phba->pport->port_state,
+				mbx->mbxCommand, phba->pport->port_state,
 				psli->sli_flag, flag);
 
 		psli->slistat.mbox_busy++;
@@ -6732,15 +6732,15 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 			lpfc_debugfs_disc_trc(pmbox->vport,
 				LPFC_DISC_TRC_MBOX_VPORT,
 				"MBOX Bsy vport:  cmd:x%x mb:x%x x%x",
-				(uint32_t)mb->mbxCommand,
-				mb->un.varWords[0], mb->un.varWords[1]);
+				(uint32_t)mbx->mbxCommand,
+				mbx->un.varWords[0], mbx->un.varWords[1]);
 		}
 		else {
 			lpfc_debugfs_disc_trc(phba->pport,
 				LPFC_DISC_TRC_MBOX,
 				"MBOX Bsy:        cmd:x%x mb:x%x x%x",
-				(uint32_t)mb->mbxCommand,
-				mb->un.varWords[0], mb->un.varWords[1]);
+				(uint32_t)mbx->mbxCommand,
+				mbx->un.varWords[0], mbx->un.varWords[1]);
 		}
 
 		return MBX_BUSY;
@@ -6751,7 +6751,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 	/* If we are not polling, we MUST be in SLI2 mode */
 	if (flag != MBX_POLL) {
 		if (!(psli->sli_flag & LPFC_SLI_ACTIVE) &&
-		    (mb->mbxCommand != MBX_KILL_BOARD)) {
+		    (mbx->mbxCommand != MBX_KILL_BOARD)) {
 			psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 			/* Mbox command <mbxCommand> cannot issue */
@@ -6773,23 +6773,23 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 			"(%d):0309 Mailbox cmd x%x issue Data: x%x x%x "
 			"x%x\n",
 			pmbox->vport ? pmbox->vport->vpi : 0,
-			mb->mbxCommand, phba->pport->port_state,
+			mbx->mbxCommand, phba->pport->port_state,
 			psli->sli_flag, flag);
 
-	if (mb->mbxCommand != MBX_HEARTBEAT) {
+	if (mbx->mbxCommand != MBX_HEARTBEAT) {
 		if (pmbox->vport) {
 			lpfc_debugfs_disc_trc(pmbox->vport,
 				LPFC_DISC_TRC_MBOX_VPORT,
 				"MBOX Send vport: cmd:x%x mb:x%x x%x",
-				(uint32_t)mb->mbxCommand,
-				mb->un.varWords[0], mb->un.varWords[1]);
+				(uint32_t)mbx->mbxCommand,
+				mbx->un.varWords[0], mbx->un.varWords[1]);
 		}
 		else {
 			lpfc_debugfs_disc_trc(phba->pport,
 				LPFC_DISC_TRC_MBOX,
 				"MBOX Send:       cmd:x%x mb:x%x x%x",
-				(uint32_t)mb->mbxCommand,
-				mb->un.varWords[0], mb->un.varWords[1]);
+				(uint32_t)mbx->mbxCommand,
+				mbx->un.varWords[0], mbx->un.varWords[1]);
 		}
 	}
 
@@ -6797,12 +6797,12 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 	evtctr = psli->slistat.mbox_event;
 
 	/* next set own bit for the adapter and copy over command word */
-	mb->mbxOwner = OWN_CHIP;
+	mbx->mbxOwner = OWN_CHIP;
 
 	if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 		/* Populate mbox extension offset word. */
 		if (pmbox->in_ext_byte_len || pmbox->out_ext_byte_len) {
-			*(((uint32_t *)mb) + pmbox->mbox_offset_word)
+			*(((uint32_t *)mbx) + pmbox->mbox_offset_word)
 				= (uint8_t *)phba->mbox_ext
 				  - (uint8_t *)phba->mbox;
 		}
@@ -6814,11 +6814,11 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 				pmbox->in_ext_byte_len);
 		}
 		/* Copy command data to host SLIM area */
-		lpfc_sli_pcimem_bcopy(mb, phba->mbox, MAILBOX_CMD_SIZE);
+		lpfc_sli_pcimem_bcopy(mbx, phba->mbox, MAILBOX_CMD_SIZE);
 	} else {
 		/* Populate mbox extension offset word. */
 		if (pmbox->in_ext_byte_len || pmbox->out_ext_byte_len)
-			*(((uint32_t *)mb) + pmbox->mbox_offset_word)
+			*(((uint32_t *)mbx) + pmbox->mbox_offset_word)
 				= MAILBOX_HBA_EXT_OFFSET;
 
 		/* Copy the mailbox extension data */
@@ -6828,24 +6828,24 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 				pmbox->context2, pmbox->in_ext_byte_len);
 
 		}
-		if (mb->mbxCommand == MBX_CONFIG_PORT) {
+		if (mbx->mbxCommand == MBX_CONFIG_PORT) {
 			/* copy command data into host mbox for cmpl */
-			lpfc_sli_pcimem_bcopy(mb, phba->mbox, MAILBOX_CMD_SIZE);
+			lpfc_sli_pcimem_bcopy(mbx, phba->mbox, MAILBOX_CMD_SIZE);
 		}
 
 		/* First copy mbox command data to HBA SLIM, skip past first
 		   word */
 		to_slim = phba->MBslimaddr + sizeof (uint32_t);
-		lpfc_memcpy_to_slim(to_slim, &mb->un.varWords[0],
+		lpfc_memcpy_to_slim(to_slim, &mbx->un.varWords[0],
 			    MAILBOX_CMD_SIZE - sizeof (uint32_t));
 
 		/* Next copy over first word, with mbxOwner set */
-		ldata = *((uint32_t *)mb);
+		ldata = *((uint32_t *)mbx);
 		to_slim = phba->MBslimaddr;
 		writel(ldata, to_slim);
 		readl(to_slim); /* flush */
 
-		if (mb->mbxCommand == MBX_CONFIG_PORT) {
+		if (mbx->mbxCommand == MBX_CONFIG_PORT) {
 			/* switch over to host mailbox */
 			psli->sli_flag |= LPFC_SLI_ACTIVE;
 		}
@@ -6920,7 +6920,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 				/* First copy command data */
 				word0 = *((uint32_t *)phba->mbox);
 				word0 = le32_to_cpu(word0);
-				if (mb->mbxCommand == MBX_CONFIG_PORT) {
+				if (mbx->mbxCommand == MBX_CONFIG_PORT) {
 					MAILBOX_t *slimmb;
 					uint32_t slimword0;
 					/* Check real SLIM for any errors */
@@ -6947,7 +6947,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 
 		if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 			/* copy results back to user */
-			lpfc_sli_pcimem_bcopy(phba->mbox, mb, MAILBOX_CMD_SIZE);
+			lpfc_sli_pcimem_bcopy(phba->mbox, mbx, MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
 			if (pmbox->out_ext_byte_len && pmbox->context2) {
 				lpfc_sli_pcimem_bcopy(phba->mbox_ext,
@@ -6956,7 +6956,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 			}
 		} else {
 			/* First copy command data */
-			lpfc_memcpy_from_slim(mb, phba->MBslimaddr,
+			lpfc_memcpy_from_slim(mbx, phba->MBslimaddr,
 							MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
 			if (pmbox->out_ext_byte_len && pmbox->context2) {
@@ -6971,7 +6971,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 		readl(phba->HAregaddr); /* flush */
 
 		psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
-		status = mb->mbxStatus;
+		status = mbx->mbxStatus;
 	}
 
 	spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
