From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/6] lpfc 8.1.7 : Fix failing firmware download due to
	mailbox delays needing to be longer
Date: Tue, 01 Aug 2006 07:33:43 -0400
Message-ID: <1154432023.18162.13.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64456 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932661AbWHALdq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Aug 2006 07:33:46 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k71BXjWT000880
	for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2006 04:33:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix failing firmware download due to mailbox delays needing to be longer.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-08-01 07:07:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-08-01 07:08:50.000000000 -0400
@@ -1000,7 +1000,8 @@ sysfs_mbox_read(struct kobject *kobj, ch
 			spin_unlock_irq(phba->host->host_lock);
 			rc = lpfc_sli_issue_mbox_wait (phba,
 						       phba->sysfs_mbox.mbox,
-						       phba->fc_ratov * 2);
+				lpfc_mbox_tmo_val(phba,
+				    phba->sysfs_mbox.mbox->mb.mbxCommand) * HZ);
 			spin_lock_irq(phba->host->host_lock);
 		}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2006-08-01 07:08:50.000000000 -0400
@@ -127,6 +127,7 @@ void lpfc_config_port(struct lpfc_hba *,
 void lpfc_kill_board(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbox_put(struct lpfc_hba *, LPFC_MBOXQ_t *);
 LPFC_MBOXQ_t *lpfc_mbox_get(struct lpfc_hba *);
+int lpfc_mbox_tmo_val(struct lpfc_hba *, int);
 
 int lpfc_mem_alloc(struct lpfc_hba *);
 void lpfc_mem_free(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2006-08-01 07:08:50.000000000 -0400
@@ -651,3 +651,19 @@ lpfc_mbox_get(struct lpfc_hba * phba)
 
 	return mbq;
 }
+
+int
+lpfc_mbox_tmo_val(struct lpfc_hba *phba, int cmd)
+{
+	switch (cmd) {
+	case MBX_WRITE_NV:	/* 0x03 */
+	case MBX_UPDATE_CFG:	/* 0x1B */
+	case MBX_DOWN_LOAD:	/* 0x1C */
+	case MBX_DEL_LD_ENTRY:	/* 0x1D */
+	case MBX_LOAD_AREA:	/* 0x81 */
+	case MBX_FLASH_WR_ULA:  /* 0x98 */
+	case MBX_LOAD_EXP_ROM:	/* 0x9C */
+		return LPFC_MBOX_TMO_FLASH_CMD;
+	}
+	return LPFC_MBOX_TMO;
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-08-01 07:07:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-08-01 07:08:50.000000000 -0400
@@ -2197,7 +2197,8 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 			return (MBX_NOT_FINISHED);
 		}
 		/* timeout active mbox command */
-		mod_timer(&psli->mbox_tmo, jiffies + HZ * LPFC_MBOX_TMO);
+		mod_timer(&psli->mbox_tmo, (jiffies +
+			       (HZ * lpfc_mbox_tmo_val(phba, mb->mbxCommand))));
 	}
 
 	/* Mailbox cmd <cmd> issue */
@@ -2257,7 +2258,6 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 		break;
 
 	case MBX_POLL:
-		i = 0;
 		psli->mbox_active = NULL;
 		if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 			/* First read mbox status word */
@@ -2271,11 +2271,14 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 		/* Read the HBA Host Attention Register */
 		ha_copy = readl(phba->HAregaddr);
 
+		i = lpfc_mbox_tmo_val(phba, mb->mbxCommand);
+		i *= 1000; /* Convert to ms */
+
 		/* Wait for command to complete */
 		while (((word0 & OWN_CHIP) == OWN_CHIP) ||
 		       (!(ha_copy & HA_MBATT) &&
 			(phba->hba_state > LPFC_WARM_START))) {
-			if (i++ >= 100) {
+			if (i-- <= 0) {
 				psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 				spin_unlock_irqrestore(phba->host->host_lock,
 						       drvr_flag);
@@ -2293,7 +2296,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 
 			/* Can be in interrupt context, do not sleep */
 			/* (or might be called with interrupts disabled) */
-			mdelay(i);
+			mdelay(1);
 
 			spin_lock_irqsave(phba->host->host_lock, drvr_flag);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2006-08-01 07:07:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2006-08-01 07:08:50.000000000 -0400
@@ -225,3 +225,9 @@ struct lpfc_sli {
 
 #define LPFC_MBOX_TMO           30	/* Sec tmo for outstanding mbox
 					   command */
+#define LPFC_MBOX_TMO_FLASH_CMD 300     /* Sec tmo for outstanding FLASH write
+					 * or erase cmds. This is especially
+					 * long because of the potential of
+					 * multiple flash erases that can be
+					 * spawned.
+					 */


