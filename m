From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6][REPOST] lpfc 8.3.13: Initialization code clean up and
 fixes.
Date: Mon, 7 Jun 2010 15:23:35 -0400
Message-ID: <1275938648.9049.13.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38391 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752569Ab0FGTZO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2010 15:25:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add poll or wait flag parameter to hba_init_link and hba_down_link.
- (From Linux Community) Make return with ENXIO negative.
- Remove unused INB code from driver.
- Prevent block_magmt_io from returning until mailbox is inactive.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    8 ++------
 lpfc_attr.c |    4 ++--
 lpfc_hw.h   |    8 --------
 lpfc_init.c |   40 +++++++++++++++++++++++++++++++++++-----
 lpfc_mbox.c |    1 -
 lpfc_sli.c  |   22 ++++------------------
 6 files changed, 43 insertions(+), 40 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-05-12 09:02:39.000000000 -0400
@@ -506,10 +506,10 @@ lpfc_link_state_store(struct device *dev
 
 	if ((strncmp(buf, "up", sizeof("up") - 1) == 0) &&
 			(phba->link_state == LPFC_LINK_DOWN))
-		status = phba->lpfc_hba_init_link(phba);
+		status = phba->lpfc_hba_init_link(phba, MBX_NOWAIT);
 	else if ((strncmp(buf, "down", sizeof("down") - 1) == 0) &&
 			(phba->link_state >= LPFC_LINK_UP))
-		status = phba->lpfc_hba_down_link(phba);
+		status = phba->lpfc_hba_down_link(phba, MBX_NOWAIT);
 
 	if (status == 0)
 		return strlen(buf);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2010-05-12 09:02:39.000000000 -0400
@@ -510,9 +510,9 @@ struct lpfc_hba {
 	void (*lpfc_stop_port)
 		(struct lpfc_hba *);
 	int (*lpfc_hba_init_link)
-		(struct lpfc_hba *);
+		(struct lpfc_hba *, uint32_t);
 	int (*lpfc_hba_down_link)
-		(struct lpfc_hba *);
+		(struct lpfc_hba *, uint32_t);
 
 	/* SLI4 specific HBA data structure */
 	struct lpfc_sli4_hba sli4_hba;
@@ -525,7 +525,6 @@ struct lpfc_hba {
 #define LPFC_SLI3_NPIV_ENABLED		0x02
 #define LPFC_SLI3_VPORT_TEARDOWN	0x04
 #define LPFC_SLI3_CRP_ENABLED		0x08
-#define LPFC_SLI3_INB_ENABLED		0x10
 #define LPFC_SLI3_BG_ENABLED		0x20
 #define LPFC_SLI3_DSS_ENABLED		0x40
 	uint32_t iocb_cmd_size;
@@ -557,9 +556,6 @@ struct lpfc_hba {
 
 	MAILBOX_t *mbox;
 	uint32_t *mbox_ext;
-	uint32_t *inb_ha_copy;
-	uint32_t *inb_counter;
-	uint32_t inb_last_counter;
 	uint32_t ha_copy;
 	struct _PCB *pcb;
 	struct _IOCB *IOCBs;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-05-12 09:02:39.000000000 -0400
@@ -3014,18 +3014,10 @@ struct sli3_pgp {
 	uint32_t hbq_get[16];
 };
 
-struct sli3_inb_pgp {
-	uint32_t ha_copy;
-	uint32_t counter;
-	struct lpfc_pgp port[MAX_RINGS];
-	uint32_t hbq_get[16];
-};
-
 union sli_var {
 	struct sli2_desc	s2;
 	struct sli3_desc	s3;
 	struct sli3_pgp		s3_pgp;
-	struct sli3_inb_pgp	s3_inb_pgp;
 };
 
 typedef struct {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-05-12 09:02:39.000000000 -0400
@@ -621,6 +621,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 /**
  * lpfc_hba_init_link - Initialize the FC link
  * @phba: pointer to lpfc hba data structure.
+ * @flag: mailbox command issue mode - either MBX_POLL or MBX_NOWAIT
  *
  * This routine will issue the INIT_LINK mailbox command call.
  * It is available to other drivers through the lpfc_hba data
@@ -632,7 +633,7 @@ lpfc_config_port_post(struct lpfc_hba *p
  *		Any other value - error
  **/
 int
-lpfc_hba_init_link(struct lpfc_hba *phba)
+lpfc_hba_init_link(struct lpfc_hba *phba, uint32_t flag)
 {
 	struct lpfc_vport *vport = phba->pport;
 	LPFC_MBOXQ_t *pmb;
@@ -651,7 +652,7 @@ lpfc_hba_init_link(struct lpfc_hba *phba
 		phba->cfg_link_speed);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	lpfc_set_loopback_flag(phba);
-	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	rc = lpfc_sli_issue_mbox(phba, pmb, flag);
 	if (rc != MBX_SUCCESS) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"0498 Adapter failed to init, mbxCmd x%x "
@@ -664,17 +665,21 @@ lpfc_hba_init_link(struct lpfc_hba *phba
 		writel(0xffffffff, phba->HAregaddr);
 		readl(phba->HAregaddr); /* flush */
 		phba->link_state = LPFC_HBA_ERROR;
-		if (rc != MBX_BUSY)
+		if (rc != MBX_BUSY || flag == MBX_POLL)
 			mempool_free(pmb, phba->mbox_mem_pool);
 		return -EIO;
 	}
 	phba->cfg_suppress_link_up = LPFC_INITIALIZE_LINK;
+	if (flag == MBX_POLL)
+		mempool_free(pmb, phba->mbox_mem_pool);
 
 	return 0;
 }
 
 /**
  * lpfc_hba_down_link - this routine downs the FC link
+ * @phba: pointer to lpfc hba data structure.
+ * @flag: mailbox command issue mode - either MBX_POLL or MBX_NOWAIT
  *
  * This routine will issue the DOWN_LINK mailbox command call.
  * It is available to other drivers through the lpfc_hba data
@@ -685,7 +690,7 @@ lpfc_hba_init_link(struct lpfc_hba *phba
  *		Any other value - error
  **/
 int
-lpfc_hba_down_link(struct lpfc_hba *phba)
+lpfc_hba_down_link(struct lpfc_hba *phba, uint32_t flag)
 {
 	LPFC_MBOXQ_t *pmb;
 	int rc;
@@ -701,7 +706,7 @@ lpfc_hba_down_link(struct lpfc_hba *phba
 		"0491 Adapter Link is disabled.\n");
 	lpfc_down_link(phba, pmb);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	rc = lpfc_sli_issue_mbox(phba, pmb, flag);
 	if ((rc != MBX_SUCCESS) && (rc != MBX_BUSY)) {
 		lpfc_printf_log(phba,
 		KERN_ERR, LOG_INIT,
@@ -711,6 +716,9 @@ lpfc_hba_down_link(struct lpfc_hba *phba
 		mempool_free(pmb, phba->mbox_mem_pool);
 		return -EIO;
 	}
+	if (flag == MBX_POLL)
+		mempool_free(pmb, phba->mbox_mem_pool);
+
 	return 0;
 }
 
@@ -2279,10 +2287,32 @@ static void
 lpfc_block_mgmt_io(struct lpfc_hba * phba)
 {
 	unsigned long iflag;
+	uint8_t actcmd = MBX_HEARTBEAT;
+	unsigned long timeout;
+
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	phba->sli.sli_flag |= LPFC_BLOCK_MGMT_IO;
+	if (phba->sli.mbox_active)
+		actcmd = phba->sli.mbox_active->u.mb.mbxCommand;
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	/* Determine how long we might wait for the active mailbox
+	 * command to be gracefully completed by firmware.
+	 */
+	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, actcmd) * 1000) +
+			jiffies;
+	/* Wait for the outstnading mailbox command to complete */
+	while (phba->sli.mbox_active) {
+		/* Check active mailbox complete status every 2ms */
+		msleep(2);
+		if (time_after(jiffies, timeout)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2813 Mgmt IO is Blocked %x "
+				"- mbox cmd %x still active\n",
+				phba->sli.sli_flag, actcmd);
+			break;
+		}
+	}
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-05-12 09:02:39.000000000 -0400
@@ -1199,7 +1199,6 @@ lpfc_config_port(struct lpfc_hba *phba, 
 		mb->un.varCfgPort.cdss = 1; /* Configure Security */
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
 		mb->un.varCfgPort.ccrp = 1; /* Command Ring Polling */
-		mb->un.varCfgPort.cinb = 1; /* Interrupt Notification Block */
 		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count();
 		if (phba->max_vpi && phba->cfg_enable_npiv &&
 		    phba->vpd.sli3Feat.cmv) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-05-12 09:02:39.000000000 -0400
@@ -3794,7 +3794,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 
 			phba->link_state = LPFC_HBA_ERROR;
 			mempool_free(pmb, phba->mbox_mem_pool);
-			return ENXIO;
+			return -ENXIO;
 		}
 	}
 	phba->hbq_count = hbq_count;
@@ -3885,7 +3885,6 @@ lpfc_sli_config_port(struct lpfc_hba *ph
 		phba->sli3_options &= ~(LPFC_SLI3_NPIV_ENABLED |
 					LPFC_SLI3_HBQ_ENABLED |
 					LPFC_SLI3_CRP_ENABLED |
-					LPFC_SLI3_INB_ENABLED |
 					LPFC_SLI3_BG_ENABLED);
 		if (rc != MBX_SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -3927,20 +3926,9 @@ lpfc_sli_config_port(struct lpfc_hba *ph
 			phba->sli3_options |= LPFC_SLI3_HBQ_ENABLED;
 		if (pmb->u.mb.un.varCfgPort.gcrp)
 			phba->sli3_options |= LPFC_SLI3_CRP_ENABLED;
-		if (pmb->u.mb.un.varCfgPort.ginb) {
-			phba->sli3_options |= LPFC_SLI3_INB_ENABLED;
-			phba->hbq_get = phba->mbox->us.s3_inb_pgp.hbq_get;
-			phba->port_gp = phba->mbox->us.s3_inb_pgp.port;
-			phba->inb_ha_copy = &phba->mbox->us.s3_inb_pgp.ha_copy;
-			phba->inb_counter = &phba->mbox->us.s3_inb_pgp.counter;
-			phba->inb_last_counter =
-					phba->mbox->us.s3_inb_pgp.counter;
-		} else {
-			phba->hbq_get = phba->mbox->us.s3_pgp.hbq_get;
-			phba->port_gp = phba->mbox->us.s3_pgp.port;
-			phba->inb_ha_copy = NULL;
-			phba->inb_counter = NULL;
-		}
+
+		phba->hbq_get = phba->mbox->us.s3_pgp.hbq_get;
+		phba->port_gp = phba->mbox->us.s3_pgp.port;
 
 		if (phba->cfg_enable_bg) {
 			if (pmb->u.mb.un.varCfgPort.gbg)
@@ -3953,8 +3941,6 @@ lpfc_sli_config_port(struct lpfc_hba *ph
 	} else {
 		phba->hbq_get = NULL;
 		phba->port_gp = phba->mbox->us.s2.port;
-		phba->inb_ha_copy = NULL;
-		phba->inb_counter = NULL;
 		phba->max_vpi = 0;
 	}
 do_prep_failed:


