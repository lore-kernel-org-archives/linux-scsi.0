From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 13/22] lpfc 8.1.2: Add ERROR and WARM_START modes for diagnostic purposes.
Date: Tue, 28 Feb 2006 19:25:27 -0500
Message-ID: <20060301002527.GA15496@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:47014 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932743AbWCAAZ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:29 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PRYg015502
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:27 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PR5Q015501
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add ERROR and WARM_START modes for diagnostic purposes.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -120,11 +120,33 @@ lpfc_work_list_done(struct lpfc_hba * ph
 			free_evt = 0;
 			break;
 		case LPFC_EVT_ONLINE:
-			*(int *)(evtp->evt_arg1)  = lpfc_online(phba);
+			if (phba->hba_state < LPFC_LINK_DOWN)
+				*(int *)(evtp->evt_arg1)  = lpfc_online(phba);
+			else
+				*(int *)(evtp->evt_arg1)  = 0;
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
 		case LPFC_EVT_OFFLINE:
-			*(int *)(evtp->evt_arg1)  = lpfc_offline(phba);
+			if (phba->hba_state >= LPFC_LINK_DOWN)
+				lpfc_offline(phba);
+			lpfc_sli_brdrestart(phba);
+			*(int *)(evtp->evt_arg1) =
+				lpfc_sli_brdready(phba,HS_FFRDY | HS_MBRDY);
+			complete((struct completion *)(evtp->evt_arg2));
+			break;
+		case LPFC_EVT_WARM_START:
+			if (phba->hba_state >= LPFC_LINK_DOWN)
+				lpfc_offline(phba);
+			lpfc_sli_brdreset(phba);
+			lpfc_hba_down_post(phba);
+			*(int *)(evtp->evt_arg1) =
+				lpfc_sli_brdready(phba, HS_MBRDY);
+			complete((struct completion *)(evtp->evt_arg2));
+			break;
+		case LPFC_EVT_KILL:
+			if (phba->hba_state >= LPFC_LINK_DOWN)
+				lpfc_offline(phba);
+			*(int *)(evtp->evt_arg1)  = lpfc_sli_brdkill(phba);
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
 		}
@@ -287,6 +309,10 @@ lpfc_linkdown(struct lpfc_hba * phba)
 	LPFC_MBOXQ_t     *mb;
 	int               rc, i;
 
+	if (phba->hba_state == LPFC_LINK_DOWN) {
+		return 0;
+	}
+
 	psli = &phba->sli;
 
 	/* sysfs or selective reset may call this routine to clean up */
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -459,11 +459,47 @@ lpfc_hba_down_prep(struct lpfc_hba * phb
 	lpfc_els_flush_cmd(phba);
 	lpfc_disc_flush_list(phba);
 
+	/* Disable SLI2 since we disabled interrupts */
+	phba->sli.sli_flag &= ~LPFC_SLI2_ACTIVE;
 	return (0);
 }
 
 /************************************************************************/
 /*                                                                      */
+/*    lpfc_hba_down_post                                                */
+/*    This routine will do uninitialization after the HBA is reset      */
+/*    when bringing down the SLI Layer.                                 */
+/*    This routine returns 0 on success. Any other return value         */
+/*    indicates an error.                                               */
+/*                                                                      */
+/************************************************************************/
+int
+lpfc_hba_down_post(struct lpfc_hba * phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring;
+	struct lpfc_dmabuf *mp, *next_mp;
+	int i;
+
+	/* Cleanup preposted buffers on the ELS ring */
+	pring = &psli->ring[LPFC_ELS_RING];
+	list_for_each_entry_safe(mp, next_mp, &pring->postbufq, list) {
+		list_del(&mp->list);
+		pring->postbufq_cnt--;
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
+		kfree(mp);
+	}
+
+	for (i = 0; i < psli->num_rings; i++) {
+		pring = &psli->ring[i];
+		lpfc_sli_abort_iocb_ring(phba, pring);
+	}
+
+	return 0;
+}
+
+/************************************************************************/
+/*                                                                      */
 /*    lpfc_handle_eratt                                                 */
 /*    This routine will handle processing a Host Attention              */
 /*    Error Status event. This will be initialized                      */
@@ -476,20 +512,6 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 
-	/*
-	 * If a reset is sent to the HBA restore PCI configuration registers.
-	 */
-	if ( phba->hba_state == LPFC_INIT_START ) {
-		mdelay(1);
-		readl(phba->HCregaddr); /* flush */
-		writel(0, phba->HCregaddr);
-		readl(phba->HCregaddr); /* flush */
-
-		/* Restore PCI cmd register */
-		pci_write_config_word(phba->pcidev,
-				      PCI_COMMAND, phba->pci_cfg_value);
-	}
-
 	if (phba->work_hs & HS_FFER6) {
 		/* Re-establishing Link */
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
@@ -516,6 +538,7 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 		 * attempt to restart it.
 		 */
 		lpfc_offline(phba);
+		lpfc_sli_brdrestart(phba);
 		if (lpfc_online(phba) == 0) {	/* Initialize the HBA */
 			mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
 			return;
@@ -532,7 +555,8 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 				phba->work_status[0], phba->work_status[1]);
 
 		lpfc_offline(phba);
-
+		phba->hba_state = LPFC_HBA_ERROR;
+		lpfc_hba_down_post(phba);
 	}
 }
 
@@ -1695,6 +1719,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	 * the HBA.
 	 */
 	lpfc_sli_hba_down(phba);
+	lpfc_sli_brdrestart(phba);
 
 	/* Release the irq reservation */
 	free_irq(phba->pcidev->irq, phba);
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -637,6 +637,17 @@ lpfc_config_port(struct lpfc_hba * phba,
 }
 
 void
+lpfc_kill_board(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
+{
+	MAILBOX_t *mb = &pmb->mb;
+
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+	mb->mbxCommand = MBX_KILL_BOARD;
+	mb->mbxOwner = OWN_HOST;
+	return;
+}
+
+void
 lpfc_mbox_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 {
 	struct lpfc_sli *psli;
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -149,6 +149,8 @@ lpfc_state_show(struct class_device *cde
 	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	int len = 0;
 	switch (phba->hba_state) {
+	case LPFC_STATE_UNKNOWN:
+	case LPFC_WARM_START:
 	case LPFC_INIT_START:
 	case LPFC_INIT_MBX_CMDS:
 	case LPFC_LINK_DOWN:
@@ -279,6 +281,58 @@ lpfc_board_online_store(struct class_dev
 }
 
 static ssize_t
+lpfc_board_mode_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	char  * state;
+
+	if (phba->hba_state == LPFC_HBA_ERROR)
+		state = "error";
+	else if (phba->hba_state == LPFC_WARM_START)
+		state = "warm start";
+	else if (phba->hba_state == LPFC_INIT_START)
+		state = "offline";
+	else
+		state = "online";
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", state);
+}
+
+static ssize_t
+lpfc_board_mode_store(struct class_device *cdev, const char *buf, size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	struct completion online_compl;
+	int status=0;
+
+	init_completion(&online_compl);
+
+	if(strncmp(buf, "online", sizeof("online") - 1) == 0)
+		lpfc_workq_post_event(phba, &status, &online_compl,
+				      LPFC_EVT_ONLINE);
+	else if (strncmp(buf, "offline", sizeof("offline") - 1) == 0)
+		lpfc_workq_post_event(phba, &status, &online_compl,
+				      LPFC_EVT_OFFLINE);
+	else if (strncmp(buf, "warm", sizeof("warm") - 1) == 0)
+		lpfc_workq_post_event(phba, &status, &online_compl,
+				      LPFC_EVT_WARM_START);
+ 	else if (strncmp(buf, "error", sizeof("error") - 1) == 0)
+		lpfc_workq_post_event(phba, &status, &online_compl,
+				      LPFC_EVT_KILL);
+	else
+		return -EINVAL;
+
+	wait_for_completion(&online_compl);
+
+	if (!status)
+		return strlen(buf);
+	else
+		return -EIO;
+}
+
+static ssize_t
 lpfc_poll_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -480,6 +534,8 @@ static CLASS_DEVICE_ATTR(management_vers
 			 NULL);
 static CLASS_DEVICE_ATTR(board_online, S_IRUGO | S_IWUSR,
 			 lpfc_board_online_show, lpfc_board_online_store);
+static CLASS_DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
+			 lpfc_board_mode_show, lpfc_board_mode_store);
 
 static int lpfc_poll = 0;
 module_param(lpfc_poll, int, 0);
@@ -674,6 +730,7 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_nport_evt_cnt,
 	&class_device_attr_management_version,
 	&class_device_attr_board_online,
+	&class_device_attr_board_mode,
 	&class_device_attr_lpfc_poll,
 	&class_device_attr_lpfc_poll_tmo,
 	NULL,
@@ -883,8 +940,11 @@ sysfs_mbox_read(struct kobject *kobj, ch
 		case MBX_DUMP_MEMORY:
 		case MBX_DOWN_LOAD:
 		case MBX_UPDATE_CFG:
+		case MBX_KILL_BOARD:
 		case MBX_LOAD_AREA:
 		case MBX_LOAD_EXP_ROM:
+		case MBX_BEACON:
+		case MBX_DEL_LD_ENTRY:
 			break;
 		case MBX_READ_SPARM64:
 		case MBX_READ_LA:
@@ -1042,6 +1102,8 @@ lpfc_get_host_port_state(struct Scsi_Hos
 		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
 	else {
 		switch (phba->hba_state) {
+		case LPFC_STATE_UNKNOWN:
+		case LPFC_WARM_START:
 		case LPFC_INIT_START:
 		case LPFC_INIT_MBX_CMDS:
 		case LPFC_LINK_DOWN:
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -107,6 +107,7 @@ void lpfc_fdmi_tmo_handler(struct lpfc_h
 int lpfc_config_port_prep(struct lpfc_hba *);
 int lpfc_config_port_post(struct lpfc_hba *);
 int lpfc_hba_down_prep(struct lpfc_hba *);
+int lpfc_hba_down_post(struct lpfc_hba *);
 void lpfc_hba_init(struct lpfc_hba *, uint32_t *);
 int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring *, int, int);
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
@@ -123,6 +124,7 @@ irqreturn_t lpfc_intr_handler(int, void 
 void lpfc_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_config_ring(struct lpfc_hba *, int, LPFC_MBOXQ_t *);
 void lpfc_config_port(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_kill_board(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbox_put(struct lpfc_hba *, LPFC_MBOXQ_t *);
 LPFC_MBOXQ_t *lpfc_mbox_get(struct lpfc_hba *);
 
@@ -135,6 +137,11 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
 void lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
+
+int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
+int lpfc_sli_brdkill(struct lpfc_hba *);
+int lpfc_sli_brdreset(struct lpfc_hba *);
+int lpfc_sli_brdrestart(struct lpfc_hba *);
 int lpfc_sli_hba_setup(struct lpfc_hba *);
 int lpfc_sli_hba_down(struct lpfc_hba *);
 int lpfc_sli_issue_mbox(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -1233,7 +1233,9 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_SET_MASK        0x20
 #define MBX_SET_SLIM        0x21
 #define MBX_UNREG_D_ID      0x23
+#define MBX_KILL_BOARD      0x24
 #define MBX_CONFIG_FARP     0x25
+#define MBX_BEACON          0x2A
 
 #define MBX_LOAD_AREA       0x81
 #define MBX_RUN_BIU_DIAG64  0x84
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -175,25 +175,27 @@ struct lpfc_hba {
 	uint16_t pci_cfg_value;
 
 	struct semaphore hba_can_block;
-	uint32_t hba_state;
+	int32_t hba_state;
 
-#define LPFC_INIT_START           1	/* Initial state after board reset */
-#define LPFC_INIT_MBX_CMDS        2	/* Initialize HBA with mbox commands */
-#define LPFC_LINK_DOWN            3	/* HBA initialized, link is down */
-#define LPFC_LINK_UP              4	/* Link is up  - issue READ_LA */
-#define LPFC_LOCAL_CFG_LINK       5	/* local NPORT Id configured */
-#define LPFC_FLOGI                6	/* FLOGI sent to Fabric */
-#define LPFC_FABRIC_CFG_LINK      7	/* Fabric assigned NPORT Id
+#define LPFC_STATE_UNKNOWN        0    /* HBA state is unknown */
+#define LPFC_WARM_START           1    /* HBA state after selective reset */
+#define LPFC_INIT_START           2    /* Initial state after board reset */
+#define LPFC_INIT_MBX_CMDS        3    /* Initialize HBA with mbox commands */
+#define LPFC_LINK_DOWN            4    /* HBA initialized, link is down */
+#define LPFC_LINK_UP              5    /* Link is up  - issue READ_LA */
+#define LPFC_LOCAL_CFG_LINK       6    /* local NPORT Id configured */
+#define LPFC_FLOGI                7    /* FLOGI sent to Fabric */
+#define LPFC_FABRIC_CFG_LINK      8    /* Fabric assigned NPORT Id
 					   configured */
-#define LPFC_NS_REG               8	/* Register with NameServer */
-#define LPFC_NS_QRY               9	/* Query NameServer for NPort ID list */
-#define LPFC_BUILD_DISC_LIST      10	/* Build ADISC and PLOGI lists for
+#define LPFC_NS_REG               9	/* Register with NameServer */
+#define LPFC_NS_QRY               10	/* Query NameServer for NPort ID list */
+#define LPFC_BUILD_DISC_LIST      11	/* Build ADISC and PLOGI lists for
 					 * device authentication / discovery */
-#define LPFC_DISC_AUTH            11	/* Processing ADISC list */
-#define LPFC_CLEAR_LA             12	/* authentication cmplt - issue
+#define LPFC_DISC_AUTH            12	/* Processing ADISC list */
+#define LPFC_CLEAR_LA             13	/* authentication cmplt - issue
 					   CLEAR_LA */
 #define LPFC_HBA_READY            32
-#define LPFC_HBA_ERROR            0xff
+#define LPFC_HBA_ERROR            -1
 
 	uint8_t fc_linkspeed;	/* Link speed after last READ_LA */
 
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -28,18 +28,24 @@
  * This is used by Fibre Channel protocol to support FCP.
  */
 
+/* worker thread events */
+enum lpfc_work_type {
+	LPFC_EVT_NODEV_TMO,
+	LPFC_EVT_ONLINE,
+	LPFC_EVT_OFFLINE,
+	LPFC_EVT_WARM_START,
+	LPFC_EVT_KILL,
+	LPFC_EVT_ELS_RETRY,
+};
+
 /* structure used to queue event to the discovery tasklet */
 struct lpfc_work_evt {
 	struct list_head      evt_listp;
 	void                * evt_arg1;
 	void                * evt_arg2;
-	uint32_t              evt;
+	enum lpfc_work_type   evt;
 };
 
-#define LPFC_EVT_NODEV_TMO	0x1
-#define LPFC_EVT_ONLINE		0x2
-#define LPFC_EVT_OFFLINE	0x3
-#define LPFC_EVT_ELS_RETRY	0x4
 
 struct lpfc_nodelist {
 	struct list_head nlp_listp;
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -513,7 +513,9 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_SET_MASK:
 	case MBX_SET_SLIM:
 	case MBX_UNREG_D_ID:
+	case MBX_KILL_BOARD:
 	case MBX_CONFIG_FARP:
+	case MBX_BEACON:
 	case MBX_LOAD_AREA:
 	case MBX_RUN_BIU_DIAG64:
 	case MBX_CONFIG_PORT:
@@ -1512,98 +1514,162 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 	return errcnt;
 }
 
-/******************************************************************************
-* lpfc_sli_send_reset
-*
-* Note: After returning from this function, the HBA cannot be accessed for
-* 1 ms. Since we do not wish to delay in interrupt context, it is the
-* responsibility of the caller to perform the mdelay(1) and flush via readl().
-******************************************************************************/
-static int
-lpfc_sli_send_reset(struct lpfc_hba * phba, uint16_t skip_post)
+int
+lpfc_sli_brdready(struct lpfc_hba * phba, uint32_t mask)
 {
-	MAILBOX_t *swpmb;
-	volatile uint32_t word0;
-	void __iomem *to_slim;
-	unsigned long flags = 0;
+	uint32_t status;
+	int i = 0;
+	int retval = 0;
 
-	spin_lock_irqsave(phba->host->host_lock, flags);
+	/* Read the HBA Host Status Register */
+	status = readl(phba->HSregaddr);
 
-	/* A board reset must use REAL SLIM. */
-	phba->sli.sli_flag &= ~LPFC_SLI2_ACTIVE;
+	/*
+	 * Check status register every 100ms for 5 retries, then every
+	 * 500ms for 5, then every 2.5 sec for 5, then reset board and
+	 * every 2.5 sec for 4.
+	 * Break our of the loop if errors occurred during init.
+	 */
+	while (((status & mask) != mask) &&
+	       !(status & HS_FFERM) &&
+	       i++ < 20) {
 
-	word0 = 0;
-	swpmb = (MAILBOX_t *) & word0;
-	swpmb->mbxCommand = MBX_RESTART;
-	swpmb->mbxHc = 1;
+		if (i <= 5)
+			msleep(10);
+		else if (i <= 10)
+			msleep(500);
+		else
+			msleep(2500);
 
-	to_slim = phba->MBslimaddr;
-	writel(*(uint32_t *) swpmb, to_slim);
-	readl(to_slim); /* flush */
+		if (i == 15) {
+			phba->hba_state = LPFC_STATE_UNKNOWN; /* Do post */
+			lpfc_sli_brdrestart(phba);
+		}
+		/* Read the HBA Host Status Register */
+		status = readl(phba->HSregaddr);
+	}
 
-	/* Only skip post after fc_ffinit is completed */
-	if (skip_post) {
-		word0 = 1;	/* This is really setting up word1 */
-	} else {
-		word0 = 0;	/* This is really setting up word1 */
+	/* Check to see if any errors occurred during init */
+	if ((status & HS_FFERM) || (i >= 20)) {
+		phba->hba_state = LPFC_HBA_ERROR;
+		retval = 1;
 	}
-	to_slim = phba->MBslimaddr + sizeof (uint32_t);
-	writel(*(uint32_t *) swpmb, to_slim);
-	readl(to_slim); /* flush */
 
-	/* Turn off parity checking and serr during the physical reset */
-	pci_read_config_word(phba->pcidev, PCI_COMMAND, &phba->pci_cfg_value);
-	pci_write_config_word(phba->pcidev, PCI_COMMAND,
-			      (phba->pci_cfg_value &
-			       ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
+	return retval;
+}
 
-	writel(HC_INITFF, phba->HCregaddr);
+int
+lpfc_sli_brdkill(struct lpfc_hba * phba)
+{
+	struct lpfc_sli *psli;
+	LPFC_MBOXQ_t *pmb;
+	uint32_t status;
+	uint32_t ha_copy;
+	int retval;
+	int i = 0;
 
-	phba->hba_state = LPFC_INIT_START;
-	spin_unlock_irqrestore(phba->host->host_lock, flags);
+	psli = &phba->sli;
 
-	return 0;
+	/* Kill HBA */
+	lpfc_printf_log(phba,
+		KERN_INFO,
+		LOG_SLI,
+		"%d:0329 Kill HBA Data: x%x x%x\n",
+		phba->brd_no,
+		phba->hba_state,
+		psli->sli_flag);
+
+	if ((pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
+						  GFP_ATOMIC)) == 0) {
+		return 1;
+	}
+
+	/* Disable the error attention */
+	spin_lock_irq(phba->host->host_lock);
+	status = readl(phba->HCregaddr);
+	status &= ~HC_ERINT_ENA;
+	writel(status, phba->HCregaddr);
+	readl(phba->HCregaddr); /* flush */
+	spin_unlock_irq(phba->host->host_lock);
+
+	lpfc_kill_board(phba, pmb);
+	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	retval = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+
+	if (retval != MBX_SUCCESS) {
+		if (retval != MBX_BUSY)
+			mempool_free(pmb, phba->mbox_mem_pool);
+		return 1;
+	}
+
+	mempool_free(pmb, phba->mbox_mem_pool);
+
+	/* There is no completion for a KILL_BOARD mbox cmd. Check for an error
+	 * attention every 100ms for 3 seconds. If we don't get ERATT after
+	 * 3 seconds we still set HBA_ERROR state because the status of the
+	 * board is now undefined.
+	 */
+	ha_copy = readl(phba->HAregaddr);
+
+	while ((i++ < 30) && !(ha_copy & HA_ERATT)) {
+		mdelay(100);
+		ha_copy = readl(phba->HAregaddr);
+	}
+
+	del_timer_sync(&psli->mbox_tmo);
+
+	spin_lock_irq(phba->host->host_lock);
+	psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	spin_unlock_irq(phba->host->host_lock);
+
+	psli->mbox_active = NULL;
+	lpfc_hba_down_post(phba);
+	phba->hba_state = LPFC_HBA_ERROR;
+
+	return (ha_copy & HA_ERATT ? 0 : 1);
 }
 
-static int
-lpfc_sli_brdreset(struct lpfc_hba * phba, uint16_t skip_post)
+int
+lpfc_sli_brdreset(struct lpfc_hba * phba)
 {
+	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
+	uint16_t cfg_value;
 	int i;
-	struct lpfc_dmabuf *mp, *next_mp;
-	unsigned long flags = 0;
 
-	lpfc_sli_send_reset(phba, skip_post);
-	mdelay(1);
-
-	spin_lock_irqsave(phba->host->host_lock, flags);
-	/* Risk the write on flush case ie no delay after the readl */
-	readl(phba->HCregaddr); /* flush */
-	/* Now toggle INITFF bit set by lpfc_sli_send_reset */
-	writel(0, phba->HCregaddr);
-	readl(phba->HCregaddr); /* flush */
+	psli = &phba->sli;
 
-	/* Restore PCI cmd register */
-	pci_write_config_word(phba->pcidev, PCI_COMMAND, phba->pci_cfg_value);
+	/* Reset HBA */
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"%d:0325 Reset HBA Data: x%x x%x\n", phba->brd_no,
+			phba->hba_state, psli->sli_flag);
 
 	/* perform board reset */
 	phba->fc_eventTag = 0;
 	phba->fc_myDID = 0;
-	phba->fc_prevDID = Mask_DID;
+	phba->fc_prevDID = 0;
 
-	/* Reset HBA */
-	lpfc_printf_log(phba,
-		KERN_INFO,
-		LOG_SLI,
-		"%d:0325 Reset HBA Data: x%x x%x x%x\n",
-		phba->brd_no,
-		phba->hba_state,
-		phba->sli.sli_flag,
-		skip_post);
+	psli->sli_flag = 0;
+
+	/* Turn off parity checking and serr during the physical reset */
+	pci_read_config_word(phba->pcidev, PCI_COMMAND, &cfg_value);
+	pci_write_config_word(phba->pcidev, PCI_COMMAND,
+			      (cfg_value &
+			       ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
+
+	/* Now toggle INITFF bit in the Host Control Register */
+	writel(HC_INITFF, phba->HCregaddr);
+	mdelay(1);
+	readl(phba->HCregaddr); /* flush */
+	writel(0, phba->HCregaddr);
+	readl(phba->HCregaddr); /* flush */
+
+	/* Restore PCI cmd register */
+	pci_write_config_word(phba->pcidev, PCI_COMMAND, cfg_value);
 
 	/* Initialize relevant SLI info */
-	for (i = 0; i < phba->sli.num_rings; i++) {
-		pring = &phba->sli.ring[i];
+	for (i = 0; i < psli->num_rings; i++) {
+		pring = &psli->ring[i];
 		pring->flag = 0;
 		pring->rspidx = 0;
 		pring->next_cmdidx  = 0;
@@ -1611,27 +1677,62 @@ lpfc_sli_brdreset(struct lpfc_hba * phba
 		pring->cmdidx = 0;
 		pring->missbufcnt = 0;
 	}
-	spin_unlock_irqrestore(phba->host->host_lock, flags);
 
-	if (skip_post) {
-		mdelay(100);
+	phba->hba_state = LPFC_WARM_START;
+	return 0;
+}
+
+int
+lpfc_sli_brdrestart(struct lpfc_hba * phba)
+{
+	MAILBOX_t *mb;
+	struct lpfc_sli *psli;
+	uint16_t skip_post;
+	volatile uint32_t word0;
+	void __iomem *to_slim;
+
+	spin_lock_irq(phba->host->host_lock);
+
+	psli = &phba->sli;
+
+	/* Restart HBA */
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"%d:0328 Restart HBA Data: x%x x%x\n", phba->brd_no,
+			phba->hba_state, psli->sli_flag);
+
+	word0 = 0;
+	mb = (MAILBOX_t *) &word0;
+	mb->mbxCommand = MBX_RESTART;
+	mb->mbxHc = 1;
+
+	to_slim = phba->MBslimaddr;
+	writel(*(uint32_t *) mb, to_slim);
+	readl(to_slim); /* flush */
+
+	/* Only skip post after fc_ffinit is completed */
+	if (phba->hba_state) {
+		skip_post = 1;
+		word0 = 1;	/* This is really setting up word1 */
 	} else {
-		mdelay(2000);
+		skip_post = 0;
+		word0 = 0;	/* This is really setting up word1 */
 	}
+	to_slim = (uint8_t *) phba->MBslimaddr + sizeof (uint32_t);
+	writel(*(uint32_t *) mb, to_slim);
+	readl(to_slim); /* flush */
 
-	spin_lock_irqsave(phba->host->host_lock, flags);
-	/* Cleanup preposted buffers on the ELS ring */
-	pring = &phba->sli.ring[LPFC_ELS_RING];
-	list_for_each_entry_safe(mp, next_mp, &pring->postbufq, list) {
-		list_del(&mp->list);
-		pring->postbufq_cnt--;
-		lpfc_mbuf_free(phba, mp->virt, mp->phys);
-		kfree(mp);
-	}
-	spin_unlock_irqrestore(phba->host->host_lock, flags);
+	lpfc_sli_brdreset(phba);
 
-	for (i = 0; i < phba->sli.num_rings; i++)
-		lpfc_sli_abort_iocb_ring(phba, &phba->sli.ring[i]);
+	phba->hba_state = LPFC_INIT_START;
+
+	spin_unlock_irq(phba->host->host_lock);
+
+	if (skip_post)
+		mdelay(100);
+	else
+		mdelay(2000);
+
+	lpfc_hba_down_post(phba);
 
 	return 0;
 }
@@ -1691,7 +1792,8 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 		}
 
 		if (i == 15) {
-			lpfc_sli_brdreset(phba, 0);
+			phba->hba_state = LPFC_STATE_UNKNOWN; /* Do post */
+			lpfc_sli_brdrestart(phba);
 		}
 		/* Read the HBA Host Status Register */
 		status = readl(phba->HSregaddr);
@@ -1735,8 +1837,8 @@ lpfc_sli_hba_setup(struct lpfc_hba * phb
 	}
 
 	while (resetcount < 2 && !done) {
-		phba->hba_state = 0;
-		lpfc_sli_brdreset(phba, 0);
+		phba->hba_state = LPFC_STATE_UNKNOWN;
+		lpfc_sli_brdrestart(phba);
 		msleep(2500);
 		rc = lpfc_sli_chipset_init(phba);
 		if (rc)
@@ -1920,6 +2022,14 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 	mb = &pmbox->mb;
 	status = MBX_SUCCESS;
 
+	if (phba->hba_state == LPFC_HBA_ERROR) {
+		spin_unlock_irqrestore(phba->host->host_lock, drvr_flag);
+
+		/* Mbox command <mbxCommand> cannot issue */
+		LOG_MBOX_CANNOT_ISSUE_DATA( phba, mb, psli, flag)
+		return (MBX_NOT_FINISHED);
+	}
+
 	if (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE) {
 		/* Polling for a mbox command when another one is already active
 		 * is not allowed in SLI. Also, the driver must have established
@@ -2002,7 +2112,8 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 
 	/* If we are not polling, we MUST be in SLI2 mode */
 	if (flag != MBX_POLL) {
-		if (!(psli->sli_flag & LPFC_SLI2_ACTIVE)) {
+		if (!(psli->sli_flag & LPFC_SLI2_ACTIVE) &&
+		    (mb->mbxCommand != MBX_KILL_BOARD)) {
 			psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 			spin_unlock_irqrestore(phba->host->host_lock,
 					       drvr_flag);
@@ -2035,7 +2146,8 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 		/* First copy command data to host SLIM area */
 		lpfc_sli_pcimem_bcopy(mb, &phba->slim2p->mbx, MAILBOX_CMD_SIZE);
 	} else {
-		if (mb->mbxCommand == MBX_CONFIG_PORT) {
+		if (mb->mbxCommand == MBX_CONFIG_PORT ||
+		    mb->mbxCommand == MBX_KILL_BOARD) {
 			/* copy command data into host mbox for cmpl */
 			lpfc_sli_pcimem_bcopy(mb, &phba->slim2p->mbx,
 					MAILBOX_CMD_SIZE);
@@ -2086,8 +2198,9 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 		ha_copy = readl(phba->HAregaddr);
 
 		/* Wait for command to complete */
-		while (((word0 & OWN_CHIP) == OWN_CHIP)
-		       || !(ha_copy & HA_MBATT)) {
+		while (((word0 & OWN_CHIP) == OWN_CHIP) ||
+		       (!(ha_copy & HA_MBATT) &&
+			(phba->hba_state > LPFC_WARM_START))) {
 			if (i++ >= 100) {
 				psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 				spin_unlock_irqrestore(phba->host->host_lock,
@@ -2455,15 +2568,6 @@ lpfc_sli_hba_down(struct lpfc_hba * phba
 
 	spin_unlock_irqrestore(phba->host->host_lock, flags);
 
-	/*
-	 * Provided the hba is not in an error state, reset it.  It is not
-	 * capable of IO anymore.
-	 */
-	if (phba->hba_state != LPFC_HBA_ERROR) {
-		phba->hba_state = LPFC_INIT_START;
-		lpfc_sli_brdreset(phba, 1);
-	}
-
 	return 1;
 }
 
@@ -2976,13 +3080,6 @@ lpfc_intr_handler(int irq, void *dev_id,
 			/* Clear Chip error bit */
 			writel(HA_ERATT, phba->HAregaddr);
 			readl(phba->HAregaddr); /* flush */
-
-			/*
-			 * Reseting the HBA is the only reliable way
-			 * to shutdown interrupt when there is a
-			 * ERROR.
-			 */
-			lpfc_sli_send_reset(phba, 1);
 		}
 
 		spin_lock(phba->host->host_lock);
