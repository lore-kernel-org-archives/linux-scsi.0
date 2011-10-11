From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6] lpfc 8.3.27: Changed worst case mailbox timeout
Date: Mon, 10 Oct 2011 21:32:43 -0400
Message-ID: <1318296765.5189.11.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:33726 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751595Ab1JKBiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2011 21:38:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Changed the timeout value for flash-based SLI_CONFIG (0x9B)
mailbox command to 300 seconds for worst case flash delays.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   12 ++--
 lpfc_crtn.h |    2 
 lpfc_hw4.h  |   48 ++++++++++------
 lpfc_init.c |   31 ++++++----
 lpfc_mbox.c |   80 ++++++++++++++++++++++++----
 lpfc_sli.c  |  170 +++++++++++++++++++++++++++++++++---------------------------
 lpfc_sli.h  |   18 ++----
 lpfc_sli4.h |    4 -
 8 files changed, 229 insertions(+), 136 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-10-10 19:53:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-10-10 19:53:30.000000000 -0400
@@ -4113,8 +4113,10 @@ sysfs_mbox_read(struct file *filp, struc
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	int rc;
+	LPFC_MBOXQ_t *mboxq;
 	MAILBOX_t *pmb;
+	uint32_t mbox_tmo;
+	int rc;
 
 	if (off > MAILBOX_CMD_SIZE)
 		return -ERANGE;
@@ -4139,7 +4141,8 @@ sysfs_mbox_read(struct file *filp, struc
 	if (off == 0 &&
 	    phba->sysfs_mbox.state  == SMBOX_WRITING &&
 	    phba->sysfs_mbox.offset >= 2 * sizeof(uint32_t)) {
-		pmb = &phba->sysfs_mbox.mbox->u.mb;
+		mboxq = (LPFC_MBOXQ_t *)&phba->sysfs_mbox.mbox;
+		pmb = &mboxq->u.mb;
 		switch (pmb->mbxCommand) {
 			/* Offline only */
 		case MBX_INIT_LINK:
@@ -4249,9 +4252,8 @@ sysfs_mbox_read(struct file *filp, struc
 
 		} else {
 			spin_unlock_irq(&phba->hbalock);
-			rc = lpfc_sli_issue_mbox_wait (phba,
-						       phba->sysfs_mbox.mbox,
-				lpfc_mbox_tmo_val(phba, pmb->mbxCommand) * HZ);
+			mbox_tmo = lpfc_mbox_tmo_val(phba, mboxq);
+			rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
 			spin_lock_irq(&phba->hbalock);
 		}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-10-10 19:53:30.000000000 -0400
@@ -209,7 +209,7 @@ void __lpfc_mbox_cmpl_put(struct lpfc_hb
 void lpfc_mbox_cmpl_put(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_mbox_cmd_check(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_mbox_dev_check(struct lpfc_hba *);
-int lpfc_mbox_tmo_val(struct lpfc_hba *, int);
+int lpfc_mbox_tmo_val(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_init_vfi(struct lpfcMboxq *, struct lpfc_vport *);
 void lpfc_reg_vfi(struct lpfcMboxq *, struct lpfc_vport *, dma_addr_t);
 void lpfc_init_vpi(struct lpfc_hba *, struct lpfcMboxq *, uint16_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-10-10 19:53:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-10-10 19:53:30.000000000 -0400
@@ -826,6 +826,7 @@ struct mbox_header {
 #define LPFC_EXTENT_VERSION_DEFAULT	0
 
 /* Subsystem Definitions */
+#define LPFC_MBOX_SUBSYSTEM_NA		0x0
 #define LPFC_MBOX_SUBSYSTEM_COMMON	0x1
 #define LPFC_MBOX_SUBSYSTEM_FCOE	0xC
 
@@ -836,25 +837,33 @@ struct mbox_header {
 #define HOST_ENDIAN_HIGH_WORD1	0xFF7856FF
 
 /* Common Opcodes */
-#define LPFC_MBOX_OPCODE_CQ_CREATE		0x0C
-#define LPFC_MBOX_OPCODE_EQ_CREATE		0x0D
-#define LPFC_MBOX_OPCODE_MQ_CREATE		0x15
-#define LPFC_MBOX_OPCODE_GET_CNTL_ATTRIBUTES	0x20
-#define LPFC_MBOX_OPCODE_NOP			0x21
-#define LPFC_MBOX_OPCODE_MQ_DESTROY		0x35
-#define LPFC_MBOX_OPCODE_CQ_DESTROY		0x36
-#define LPFC_MBOX_OPCODE_EQ_DESTROY		0x37
-#define LPFC_MBOX_OPCODE_QUERY_FW_CFG		0x3A
-#define LPFC_MBOX_OPCODE_FUNCTION_RESET		0x3D
-#define LPFC_MBOX_OPCODE_MQ_CREATE_EXT		0x5A
-#define LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO	0x9A
-#define LPFC_MBOX_OPCODE_GET_ALLOC_RSRC_EXTENT	0x9B
-#define LPFC_MBOX_OPCODE_ALLOC_RSRC_EXTENT	0x9C
-#define LPFC_MBOX_OPCODE_DEALLOC_RSRC_EXTENT	0x9D
-#define LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG    0xA0
-#define LPFC_MBOX_OPCODE_GET_PROFILE_CONFIG	0xA4
-#define LPFC_MBOX_OPCODE_WRITE_OBJECT		0xAC
-#define LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS	0xB5
+#define LPFC_MBOX_OPCODE_NA				0x00
+#define LPFC_MBOX_OPCODE_CQ_CREATE			0x0C
+#define LPFC_MBOX_OPCODE_EQ_CREATE			0x0D
+#define LPFC_MBOX_OPCODE_MQ_CREATE			0x15
+#define LPFC_MBOX_OPCODE_GET_CNTL_ATTRIBUTES		0x20
+#define LPFC_MBOX_OPCODE_NOP				0x21
+#define LPFC_MBOX_OPCODE_MQ_DESTROY			0x35
+#define LPFC_MBOX_OPCODE_CQ_DESTROY			0x36
+#define LPFC_MBOX_OPCODE_EQ_DESTROY			0x37
+#define LPFC_MBOX_OPCODE_QUERY_FW_CFG			0x3A
+#define LPFC_MBOX_OPCODE_FUNCTION_RESET			0x3D
+#define LPFC_MBOX_OPCODE_MQ_CREATE_EXT			0x5A
+#define LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO		0x9A
+#define LPFC_MBOX_OPCODE_GET_ALLOC_RSRC_EXTENT		0x9B
+#define LPFC_MBOX_OPCODE_ALLOC_RSRC_EXTENT		0x9C
+#define LPFC_MBOX_OPCODE_DEALLOC_RSRC_EXTENT		0x9D
+#define LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG    	0xA0
+#define LPFC_MBOX_OPCODE_GET_PROFILE_CONFIG		0xA4
+#define LPFC_MBOX_OPCODE_SET_PROFILE_CONFIG     	0xA5
+#define LPFC_MBOX_OPCODE_GET_PROFILE_LIST		0xA6
+#define LPFC_MBOX_OPCODE_SET_ACT_PROFILE        	0xA8
+#define LPFC_MBOX_OPCODE_GET_FACTORY_PROFILE_CONFIG	0xA9
+#define LPFC_MBOX_OPCODE_READ_OBJECT			0xAB
+#define LPFC_MBOX_OPCODE_WRITE_OBJECT			0xAC
+#define LPFC_MBOX_OPCODE_READ_OBJECT_LIST		0xAD
+#define LPFC_MBOX_OPCODE_DELETE_OBJECT			0xAE
+#define LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS		0xB5
 
 /* FCoE Opcodes */
 #define LPFC_MBOX_OPCODE_FCOE_WQ_CREATE			0x01
@@ -868,6 +877,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_FCOE_DELETE_FCF		0x0A
 #define LPFC_MBOX_OPCODE_FCOE_POST_HDR_TEMPLATE		0x0B
 #define LPFC_MBOX_OPCODE_FCOE_REDISCOVER_FCF		0x10
+#define LPFC_MBOX_OPCODE_FCOE_SET_FCLINK_SETTINGS	0x21
 #define LPFC_MBOX_OPCODE_FCOE_LINK_DIAG_STATE		0x22
 #define LPFC_MBOX_OPCODE_FCOE_LINK_DIAG_LOOPBACK	0x23
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-10-10 19:53:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-10-10 19:53:30.000000000 -0400
@@ -2441,17 +2441,19 @@ lpfc_block_mgmt_io(struct lpfc_hba * phb
 	uint8_t actcmd = MBX_HEARTBEAT;
 	unsigned long timeout;
 
-
+	timeout = msecs_to_jiffies(LPFC_MBOX_TMO * 1000) + jiffies;
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	phba->sli.sli_flag |= LPFC_BLOCK_MGMT_IO;
-	if (phba->sli.mbox_active)
+	if (phba->sli.mbox_active) {
 		actcmd = phba->sli.mbox_active->u.mb.mbxCommand;
+		/* Determine how long we might wait for the active mailbox
+		 * command to be gracefully completed by firmware.
+		 */
+		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
+				phba->sli.mbox_active) * 1000) + jiffies;
+	}
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
-	/* Determine how long we might wait for the active mailbox
-	 * command to be gracefully completed by firmware.
-	 */
-	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, actcmd) * 1000) +
-			jiffies;
+
 	/* Wait for the outstnading mailbox command to complete */
 	while (phba->sli.mbox_active) {
 		/* Check active mailbox complete status every 2ms */
@@ -7158,12 +7160,13 @@ lpfc_sli4_send_nop_mbox_cmds(struct lpfc
 	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
 			 LPFC_MBOX_OPCODE_NOP, length, LPFC_SLI4_MBX_EMBED);
 
-	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
 	for (cmdsent = 0; cmdsent < cnt; cmdsent++) {
 		if (!phba->sli4_hba.intr_enable)
 			rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-		else
+		else {
+			mbox_tmo = lpfc_mbox_tmo_val(phba, mboxq);
 			rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
+		}
 		if (rc == MBX_TIMEOUT)
 			break;
 		/* Check return status */
@@ -8129,7 +8132,7 @@ lpfc_pc_sli4_params_get(struct lpfc_hba 
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_PORT_CAPABILITIES);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mboxq);
 		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
 	}
 
@@ -8191,6 +8194,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba
 	int rc;
 	struct lpfc_mqe *mqe = &mboxq->u.mqe;
 	struct lpfc_pc_sli4_params *sli4_params;
+	uint32_t mbox_tmo;
 	int length;
 	struct lpfc_sli4_parameters *mbx_sli4_parameters;
 
@@ -8209,9 +8213,10 @@ lpfc_get_sli4_parameters(struct lpfc_hba
 			 length, LPFC_SLI4_MBX_EMBED);
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, mboxq,
-			lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG));
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mboxq);
+		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
+	}
 	if (unlikely(rc))
 		return rc;
 	sli4_params = &phba->sli4_hba.pc_sli4_params;
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2011-10-10 19:53:30.000000000 -0400
@@ -1598,9 +1598,12 @@ lpfc_mbox_dev_check(struct lpfc_hba *phb
  *    Timeout value to be used for the given mailbox command
  **/
 int
-lpfc_mbox_tmo_val(struct lpfc_hba *phba, int cmd)
+lpfc_mbox_tmo_val(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
-	switch (cmd) {
+	MAILBOX_t *mbox = &mboxq->u.mb;
+	uint8_t subsys, opcode;
+
+	switch (mbox->mbxCommand) {
 	case MBX_WRITE_NV:	/* 0x03 */
 	case MBX_UPDATE_CFG:	/* 0x1B */
 	case MBX_DOWN_LOAD:	/* 0x1C */
@@ -1610,6 +1613,28 @@ lpfc_mbox_tmo_val(struct lpfc_hba *phba,
 	case MBX_LOAD_EXP_ROM:	/* 0x9C */
 		return LPFC_MBOX_TMO_FLASH_CMD;
 	case MBX_SLI4_CONFIG:	/* 0x9b */
+		subsys = lpfc_sli_config_mbox_subsys_get(phba, mboxq);
+		opcode = lpfc_sli_config_mbox_opcode_get(phba, mboxq);
+		if (subsys == LPFC_MBOX_SUBSYSTEM_COMMON) {
+			switch (opcode) {
+			case LPFC_MBOX_OPCODE_READ_OBJECT:
+			case LPFC_MBOX_OPCODE_WRITE_OBJECT:
+			case LPFC_MBOX_OPCODE_READ_OBJECT_LIST:
+			case LPFC_MBOX_OPCODE_DELETE_OBJECT:
+			case LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG:
+			case LPFC_MBOX_OPCODE_GET_PROFILE_LIST:
+			case LPFC_MBOX_OPCODE_SET_ACT_PROFILE:
+			case LPFC_MBOX_OPCODE_SET_PROFILE_CONFIG:
+			case LPFC_MBOX_OPCODE_GET_FACTORY_PROFILE_CONFIG:
+				return LPFC_MBOX_SLI4_CONFIG_EXTENDED_TMO;
+			}
+		}
+		if (subsys == LPFC_MBOX_SUBSYSTEM_FCOE) {
+			switch (opcode) {
+			case LPFC_MBOX_OPCODE_FCOE_SET_FCLINK_SETTINGS:
+				return LPFC_MBOX_SLI4_CONFIG_EXTENDED_TMO;
+			}
+		}
 		return LPFC_MBOX_SLI4_CONFIG_TMO;
 	}
 	return LPFC_MBOX_TMO;
@@ -1859,7 +1884,7 @@ lpfc_sli4_mbox_rsrc_extent(struct lpfc_h
 	}
 
 	/* Complete the initialization for the particular Opcode. */
-	opcode = lpfc_sli4_mbox_opcode_get(phba, mbox);
+	opcode = lpfc_sli_config_mbox_opcode_get(phba, mbox);
 	switch (opcode) {
 	case LPFC_MBOX_OPCODE_ALLOC_RSRC_EXTENT:
 		if (emb == LPFC_SLI4_MBX_EMBED)
@@ -1886,23 +1911,56 @@ lpfc_sli4_mbox_rsrc_extent(struct lpfc_h
 }
 
 /**
- * lpfc_sli4_mbox_opcode_get - Get the opcode from a sli4 mailbox command
+ * lpfc_sli_config_mbox_subsys_get - Get subsystem from a sli_config mbox cmd
  * @phba: pointer to lpfc hba data structure.
- * @mbox: pointer to lpfc mbox command.
+ * @mbox: pointer to lpfc mbox command queue entry.
+ *
+ * This routine gets the subsystem from a SLI4 specific SLI_CONFIG mailbox
+ * command. If the mailbox command is not MBX_SLI4_CONFIG (0x9B) or if the
+ * sub-header is not present, subsystem LPFC_MBOX_SUBSYSTEM_NA (0x0) shall
+ * be returned.
+ **/
+uint8_t
+lpfc_sli_config_mbox_subsys_get(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
+{
+	struct lpfc_mbx_sli4_config *sli4_cfg;
+	union lpfc_sli4_cfg_shdr *cfg_shdr;
+
+	if (mbox->u.mb.mbxCommand != MBX_SLI4_CONFIG)
+		return LPFC_MBOX_SUBSYSTEM_NA;
+	sli4_cfg = &mbox->u.mqe.un.sli4_config;
+
+	/* For embedded mbox command, get opcode from embedded sub-header*/
+	if (bf_get(lpfc_mbox_hdr_emb, &sli4_cfg->header.cfg_mhdr)) {
+		cfg_shdr = &mbox->u.mqe.un.sli4_config.header.cfg_shdr;
+		return bf_get(lpfc_mbox_hdr_subsystem, &cfg_shdr->request);
+	}
+
+	/* For non-embedded mbox command, get opcode from first dma page */
+	if (unlikely(!mbox->sge_array))
+		return LPFC_MBOX_SUBSYSTEM_NA;
+	cfg_shdr = (union lpfc_sli4_cfg_shdr *)mbox->sge_array->addr[0];
+	return bf_get(lpfc_mbox_hdr_subsystem, &cfg_shdr->request);
+}
+
+/**
+ * lpfc_sli_config_mbox_opcode_get - Get opcode from a sli_config mbox cmd
+ * @phba: pointer to lpfc hba data structure.
+ * @mbox: pointer to lpfc mbox command queue entry.
  *
- * This routine gets the opcode from a SLI4 specific mailbox command for
- * sending IOCTL command. If the mailbox command is not MBX_SLI4_CONFIG
- * (0x9B) or if the IOCTL sub-header is not present, opcode 0x0 shall be
+ * This routine gets the opcode from a SLI4 specific SLI_CONFIG mailbox
+ * command. If the mailbox command is not MBX_SLI4_CONFIG (0x9B) or if
+ * the sub-header is not present, opcode LPFC_MBOX_OPCODE_NA (0x0) be
  * returned.
  **/
 uint8_t
-lpfc_sli4_mbox_opcode_get(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
+lpfc_sli_config_mbox_opcode_get(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 {
 	struct lpfc_mbx_sli4_config *sli4_cfg;
 	union lpfc_sli4_cfg_shdr *cfg_shdr;
 
 	if (mbox->u.mb.mbxCommand != MBX_SLI4_CONFIG)
-		return 0;
+		return LPFC_MBOX_OPCODE_NA;
 	sli4_cfg = &mbox->u.mqe.un.sli4_config;
 
 	/* For embedded mbox command, get opcode from embedded sub-header*/
@@ -1913,7 +1971,7 @@ lpfc_sli4_mbox_opcode_get(struct lpfc_hb
 
 	/* For non-embedded mbox command, get opcode from first dma page */
 	if (unlikely(!mbox->sge_array))
-		return 0;
+		return LPFC_MBOX_OPCODE_NA;
 	cfg_shdr = (union lpfc_sli4_cfg_shdr *)mbox->sge_array->addr[0];
 	return bf_get(lpfc_mbox_hdr_opcode, &cfg_shdr->request);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-10-10 19:53:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-10-10 19:53:30.000000000 -0400
@@ -635,5 +635,5 @@ void lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(s
 void lpfc_mbx_cmpl_read_fcf_rec(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli4_unregister_fcf(struct lpfc_hba *);
 int lpfc_sli4_post_status_check(struct lpfc_hba *);
-uint8_t lpfc_sli4_mbox_opcode_get(struct lpfc_hba *, struct lpfcMboxq *);
-
+uint8_t lpfc_sli_config_mbox_subsys_get(struct lpfc_hba *, LPFC_MBOXQ_t *);
+uint8_t lpfc_sli_config_mbox_opcode_get(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-10-10 19:53:18.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-10-10 19:54:37.000000000 -0400
@@ -2200,10 +2200,13 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 			/* Unknown mailbox command compl */
 			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 					"(%d):0323 Unknown Mailbox command "
-					"x%x (x%x) Cmpl\n",
+					"x%x (x%x/x%x) Cmpl\n",
 					pmb->vport ? pmb->vport->vpi : 0,
 					pmbox->mbxCommand,
-					lpfc_sli4_mbox_opcode_get(phba, pmb));
+					lpfc_sli_config_mbox_subsys_get(phba,
+									pmb),
+					lpfc_sli_config_mbox_opcode_get(phba,
+									pmb));
 			phba->link_state = LPFC_HBA_ERROR;
 			phba->work_hs = HS_FFER3;
 			lpfc_handle_eratt(phba);
@@ -2215,17 +2218,19 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 			if (pmbox->mbxStatus == MBXERR_NO_RESOURCES) {
 				/* Mbox cmd cmpl error - RETRYing */
 				lpfc_printf_log(phba, KERN_INFO,
-						LOG_MBOX | LOG_SLI,
-						"(%d):0305 Mbox cmd cmpl "
-						"error - RETRYing Data: x%x "
-						"(x%x) x%x x%x x%x\n",
-						pmb->vport ? pmb->vport->vpi :0,
-						pmbox->mbxCommand,
-						lpfc_sli4_mbox_opcode_get(phba,
-									  pmb),
-						pmbox->mbxStatus,
-						pmbox->un.varWords[0],
-						pmb->vport->port_state);
+					LOG_MBOX | LOG_SLI,
+					"(%d):0305 Mbox cmd cmpl "
+					"error - RETRYing Data: x%x "
+					"(x%x/x%x) x%x x%x x%x\n",
+					pmb->vport ? pmb->vport->vpi : 0,
+					pmbox->mbxCommand,
+					lpfc_sli_config_mbox_subsys_get(phba,
+									pmb),
+					lpfc_sli_config_mbox_opcode_get(phba,
+									pmb),
+					pmbox->mbxStatus,
+					pmbox->un.varWords[0],
+					pmb->vport->port_state);
 				pmbox->mbxStatus = 0;
 				pmbox->mbxOwner = OWN_HOST;
 				rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
@@ -2236,11 +2241,12 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 
 		/* Mailbox cmd <cmd> Cmpl <cmpl> */
 		lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-				"(%d):0307 Mailbox cmd x%x (x%x) Cmpl x%p "
+				"(%d):0307 Mailbox cmd x%x (x%x/x%x) Cmpl x%p "
 				"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x\n",
 				pmb->vport ? pmb->vport->vpi : 0,
 				pmbox->mbxCommand,
-				lpfc_sli4_mbox_opcode_get(phba, pmb),
+				lpfc_sli_config_mbox_subsys_get(phba, pmb),
+				lpfc_sli_config_mbox_opcode_get(phba, pmb),
 				pmb->mbox_cmpl,
 				*((uint32_t *) pmbox),
 				pmbox->un.varWords[0],
@@ -4754,7 +4760,7 @@ lpfc_sli4_get_avail_extnt_rsrc(struct lp
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
 	if (unlikely(rc)) {
@@ -4911,7 +4917,7 @@ lpfc_sli4_cfg_post_extnts(struct lpfc_hb
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
 
@@ -5194,7 +5200,7 @@ lpfc_sli4_dealloc_extent(struct lpfc_hba
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox_tmo);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
 	if (unlikely(rc)) {
@@ -5619,7 +5625,7 @@ lpfc_sli4_get_allocated_extnts(struct lp
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
 
@@ -6322,7 +6328,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 		}
 		/* timeout active mbox command */
 		mod_timer(&psli->mbox_tmo, (jiffies +
-			       (HZ * lpfc_mbox_tmo_val(phba, mb->mbxCommand))));
+			       (HZ * lpfc_mbox_tmo_val(phba, pmbox))));
 	}
 
 	/* Mailbox cmd <cmd> issue */
@@ -6446,9 +6452,8 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 						       drvr_flag);
 			goto out_not_finished;
 		}
-		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
-							     mb->mbxCommand) *
-					   1000) + jiffies;
+		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, pmbox) *
+							1000) + jiffies;
 		i = 0;
 		/* Wait for command to complete */
 		while (((word0 & OWN_CHIP) == OWN_CHIP) ||
@@ -6559,21 +6564,21 @@ static int
 lpfc_sli4_async_mbox_block(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
-	uint8_t actcmd = MBX_HEARTBEAT;
 	int rc = 0;
-	unsigned long timeout;
+	unsigned long timeout = 0;
 
 	/* Mark the asynchronous mailbox command posting as blocked */
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag |= LPFC_SLI_ASYNC_MBX_BLK;
-	if (phba->sli.mbox_active)
-		actcmd = phba->sli.mbox_active->u.mb.mbxCommand;
-	spin_unlock_irq(&phba->hbalock);
 	/* Determine how long we might wait for the active mailbox
 	 * command to be gracefully completed by firmware.
 	 */
-	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, actcmd) * 1000) +
-				   jiffies;
+	if (phba->sli.mbox_active)
+		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
+						phba->sli.mbox_active) *
+						1000) + jiffies;
+	spin_unlock_irq(&phba->hbalock);
+
 	/* Wait for the outstnading mailbox command to complete */
 	while (phba->sli.mbox_active) {
 		/* Check active mailbox complete status every 2ms */
@@ -6668,11 +6673,12 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 	if (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE) {
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"(%d):2532 Mailbox command x%x (x%x) "
+				"(%d):2532 Mailbox command x%x (x%x/x%x) "
 				"cannot issue Data: x%x x%x\n",
 				mboxq->vport ? mboxq->vport->vpi : 0,
 				mboxq->u.mb.mbxCommand,
-				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+				lpfc_sli_config_mbox_opcode_get(phba, mboxq),
 				psli->sli_flag, MBX_POLL);
 		return MBXERR_ERROR;
 	}
@@ -6695,7 +6701,7 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 	dma_address = &phba->sli4_hba.bmbx.dma_address;
 	writel(dma_address->addr_hi, phba->sli4_hba.BMBXregaddr);
 
-	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mbx_cmnd)
+	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq)
 				   * 1000) + jiffies;
 	do {
 		bmbx_reg.word0 = readl(phba->sli4_hba.BMBXregaddr);
@@ -6711,7 +6717,7 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 
 	/* Post the low mailbox dma address to the port. */
 	writel(dma_address->addr_lo, phba->sli4_hba.BMBXregaddr);
-	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mbx_cmnd)
+	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq)
 				   * 1000) + jiffies;
 	do {
 		bmbx_reg.word0 = readl(phba->sli4_hba.BMBXregaddr);
@@ -6750,11 +6756,12 @@ lpfc_sli4_post_sync_mbox(struct lpfc_hba
 		lpfc_sli4_swap_str(phba, mboxq);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-			"(%d):0356 Mailbox cmd x%x (x%x) Status x%x "
+			"(%d):0356 Mailbox cmd x%x (x%x/x%x) Status x%x "
 			"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x x%x x%x"
 			" x%x x%x CQ: x%x x%x x%x x%x\n",
-			mboxq->vport ? mboxq->vport->vpi : 0,
-			mbx_cmnd, lpfc_sli4_mbox_opcode_get(phba, mboxq),
+			mboxq->vport ? mboxq->vport->vpi : 0, mbx_cmnd,
+			lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+			lpfc_sli_config_mbox_opcode_get(phba, mboxq),
 			bf_get(lpfc_mqe_status, mb),
 			mb->un.mb_words[0], mb->un.mb_words[1],
 			mb->un.mb_words[2], mb->un.mb_words[3],
@@ -6800,11 +6807,12 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 	rc = lpfc_mbox_dev_check(phba);
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"(%d):2544 Mailbox command x%x (x%x) "
+				"(%d):2544 Mailbox command x%x (x%x/x%x) "
 				"cannot issue Data: x%x x%x\n",
 				mboxq->vport ? mboxq->vport->vpi : 0,
 				mboxq->u.mb.mbxCommand,
-				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+				lpfc_sli_config_mbox_opcode_get(phba, mboxq),
 				psli->sli_flag, flag);
 		goto out_not_finished;
 	}
@@ -6818,20 +6826,25 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 		if (rc != MBX_SUCCESS)
 			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
 					"(%d):2541 Mailbox command x%x "
-					"(x%x) cannot issue Data: x%x x%x\n",
+					"(x%x/x%x) cannot issue Data: "
+					"x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
-					lpfc_sli4_mbox_opcode_get(phba, mboxq),
+					lpfc_sli_config_mbox_subsys_get(phba,
+									mboxq),
+					lpfc_sli_config_mbox_opcode_get(phba,
+									mboxq),
 					psli->sli_flag, flag);
 		return rc;
 	} else if (flag == MBX_POLL) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
 				"(%d):2542 Try to issue mailbox command "
-				"x%x (x%x) synchronously ahead of async"
+				"x%x (x%x/x%x) synchronously ahead of async"
 				"mailbox command queue: x%x x%x\n",
 				mboxq->vport ? mboxq->vport->vpi : 0,
 				mboxq->u.mb.mbxCommand,
-				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+				lpfc_sli_config_mbox_opcode_get(phba, mboxq),
 				psli->sli_flag, flag);
 		/* Try to block the asynchronous mailbox posting */
 		rc = lpfc_sli4_async_mbox_block(phba);
@@ -6840,16 +6853,18 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 			rc = lpfc_sli4_post_sync_mbox(phba, mboxq);
 			if (rc != MBX_SUCCESS)
 				lpfc_printf_log(phba, KERN_ERR,
-						LOG_MBOX | LOG_SLI,
-						"(%d):2597 Mailbox command "
-						"x%x (x%x) cannot issue "
-						"Data: x%x x%x\n",
-						mboxq->vport ?
-						mboxq->vport->vpi : 0,
-						mboxq->u.mb.mbxCommand,
-						lpfc_sli4_mbox_opcode_get(phba,
-								mboxq),
-						psli->sli_flag, flag);
+					LOG_MBOX | LOG_SLI,
+					"(%d):2597 Mailbox command "
+					"x%x (x%x/x%x) cannot issue "
+					"Data: x%x x%x\n",
+					mboxq->vport ?
+					mboxq->vport->vpi : 0,
+					mboxq->u.mb.mbxCommand,
+					lpfc_sli_config_mbox_subsys_get(phba,
+									mboxq),
+					lpfc_sli_config_mbox_opcode_get(phba,
+									mboxq),
+					psli->sli_flag, flag);
 			/* Unblock the async mailbox posting afterward */
 			lpfc_sli4_async_mbox_unblock(phba);
 		}
@@ -6860,11 +6875,12 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 	rc = lpfc_mbox_cmd_check(phba, mboxq);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"(%d):2543 Mailbox command x%x (x%x) "
+				"(%d):2543 Mailbox command x%x (x%x/x%x) "
 				"cannot issue Data: x%x x%x\n",
 				mboxq->vport ? mboxq->vport->vpi : 0,
 				mboxq->u.mb.mbxCommand,
-				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+				lpfc_sli_config_mbox_opcode_get(phba, mboxq),
 				psli->sli_flag, flag);
 		goto out_not_finished;
 	}
@@ -6876,10 +6892,11 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
 			"(%d):0354 Mbox cmd issue - Enqueue Data: "
-			"x%x (x%x) x%x x%x x%x\n",
+			"x%x (x%x/x%x) x%x x%x x%x\n",
 			mboxq->vport ? mboxq->vport->vpi : 0xffffff,
 			bf_get(lpfc_mqe_command, &mboxq->u.mqe),
-			lpfc_sli4_mbox_opcode_get(phba, mboxq),
+			lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+			lpfc_sli_config_mbox_opcode_get(phba, mboxq),
 			phba->pport->port_state,
 			psli->sli_flag, MBX_NOWAIT);
 	/* Wake up worker thread to transport mailbox command from head */
@@ -6956,13 +6973,14 @@ lpfc_sli4_post_async_mbox(struct lpfc_hb
 
 	/* Start timer for the mbox_tmo and log some mailbox post messages */
 	mod_timer(&psli->mbox_tmo, (jiffies +
-		  (HZ * lpfc_mbox_tmo_val(phba, mbx_cmnd))));
+		  (HZ * lpfc_mbox_tmo_val(phba, mboxq))));
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-			"(%d):0355 Mailbox cmd x%x (x%x) issue Data: "
+			"(%d):0355 Mailbox cmd x%x (x%x/x%x) issue Data: "
 			"x%x x%x\n",
 			mboxq->vport ? mboxq->vport->vpi : 0, mbx_cmnd,
-			lpfc_sli4_mbox_opcode_get(phba, mboxq),
+			lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+			lpfc_sli_config_mbox_opcode_get(phba, mboxq),
 			phba->pport->port_state, psli->sli_flag);
 
 	if (mbx_cmnd != MBX_HEARTBEAT) {
@@ -6986,11 +7004,12 @@ lpfc_sli4_post_async_mbox(struct lpfc_hb
 	rc = lpfc_sli4_mq_put(phba->sli4_hba.mbx_wq, mqe);
 	if (rc != MBX_SUCCESS) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"(%d):2533 Mailbox command x%x (x%x) "
+				"(%d):2533 Mailbox command x%x (x%x/x%x) "
 				"cannot issue Data: x%x x%x\n",
 				mboxq->vport ? mboxq->vport->vpi : 0,
 				mboxq->u.mb.mbxCommand,
-				lpfc_sli4_mbox_opcode_get(phba, mboxq),
+				lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+				lpfc_sli_config_mbox_opcode_get(phba, mboxq),
 				psli->sli_flag, MBX_NOWAIT);
 		goto out_not_finished;
 	}
@@ -9407,23 +9426,24 @@ void
 lpfc_sli_mbox_sys_shutdown(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
-	uint8_t actcmd = MBX_HEARTBEAT;
 	unsigned long timeout;
 
+	timeout = msecs_to_jiffies(LPFC_MBOX_TMO * 1000) + jiffies;
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag |= LPFC_SLI_ASYNC_MBX_BLK;
 	spin_unlock_irq(&phba->hbalock);
 
 	if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 		spin_lock_irq(&phba->hbalock);
-		if (phba->sli.mbox_active)
-			actcmd = phba->sli.mbox_active->u.mb.mbxCommand;
-		spin_unlock_irq(&phba->hbalock);
 		/* Determine how long we might wait for the active mailbox
 		 * command to be gracefully completed by firmware.
 		 */
-		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, actcmd) *
-					   1000) + jiffies;
+		if (phba->sli.mbox_active)
+			timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba,
+						phba->sli.mbox_active) *
+						1000) + jiffies;
+		spin_unlock_irq(&phba->hbalock);
+
 		while (phba->sli.mbox_active) {
 			/* Check active mailbox complete status every 2ms */
 			msleep(2);
@@ -12532,7 +12552,7 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
 	/* The IOCTL status is embedded in the mailbox subheader. */
@@ -12747,7 +12767,7 @@ lpfc_sli4_post_els_sgl_list(struct lpfc_
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
 	shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
@@ -12910,7 +12930,7 @@ lpfc_sli4_post_els_sgl_list_ext(struct l
 		if (!phba->sli4_hba.intr_enable)
 			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 		else {
-			mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+			mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 			rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 		}
 		shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
@@ -13034,7 +13054,7 @@ lpfc_sli4_post_scsi_sgl_block(struct lpf
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
 	shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
@@ -13190,7 +13210,7 @@ lpfc_sli4_post_scsi_sgl_blk_ext(struct l
 		if (!phba->sli4_hba.intr_enable)
 			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 		else {
-			mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+			mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 			rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 		}
 		shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
@@ -14356,7 +14376,7 @@ lpfc_sli4_init_vpi(struct lpfc_vport *vp
 	if (!mboxq)
 		return -ENOMEM;
 	lpfc_init_vpi(phba, mboxq, vport->vpi);
-	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_INIT_VPI);
+	mbox_tmo = lpfc_mbox_tmo_val(phba, mboxq);
 	rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
 	if (rc != MBX_SUCCESS) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_SLI,
@@ -15232,7 +15252,7 @@ lpfc_wr_object(struct lpfc_hba *phba, st
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
 	/* The IOCTL status is embedded in the mailbox subheader. */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2011-07-06 10:53:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2011-10-10 19:53:30.000000000 -0400
@@ -293,13 +293,11 @@ struct lpfc_sli {
 	struct lpfc_lnk_stat lnk_stat_offsets;
 };
 
-#define LPFC_MBOX_TMO           30	/* Sec tmo for outstanding mbox
-					   command */
-#define LPFC_MBOX_SLI4_CONFIG_TMO 60	/* Sec tmo for outstanding mbox
-					   command */
-#define LPFC_MBOX_TMO_FLASH_CMD 300     /* Sec tmo for outstanding FLASH write
-					 * or erase cmds. This is especially
-					 * long because of the potential of
-					 * multiple flash erases that can be
-					 * spawned.
-					 */
+/* Timeout for normal outstanding mbox command (Seconds) */
+#define LPFC_MBOX_TMO				30
+/* Timeout for non-flash-based outstanding sli_config mbox command (Seconds) */
+#define LPFC_MBOX_SLI4_CONFIG_TMO		60
+/* Timeout for flash-based outstanding sli_config mbox command (Seconds) */
+#define LPFC_MBOX_SLI4_CONFIG_EXTENDED_TMO	300
+/* Timeout for other flash-based outstanding mbox command (Seconds) */
+#define LPFC_MBOX_TMO_FLASH_CMD			300



