From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/15] lpfc 8.2.8 : Add new FCOE hardware support
Date: Sun, 24 Aug 2008 21:50:06 -0400
Message-ID: <1219629006.7890.37.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52492 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYHYBuD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:50:03 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1o2tp019981
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:50:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add new FCOE hardware support


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    4 ++-
 lpfc_attr.c    |   33 +++++++++++++++++++++++++---
 lpfc_hbadisc.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 lpfc_hw.h      |   26 ++++++++++++++++++++--
 lpfc_init.c    |   30 ++++++++++++++++++++++++-
 lpfc_sli.c     |   12 ++++++++++
 lpfc_sli.h     |    1 
 7 files changed, 153 insertions(+), 19 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-08-24 20:43:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-08-24 20:45:48.000000000 -0400
@@ -211,6 +211,25 @@ lpfc_programtype_show(struct device *dev
 }
 
 /**
+ * lpfc_mlomgmt_show: Return the Menlo Maintenance sli flag.
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the Menlo Maintenance sli flag.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_mlomgmt_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+		(phba->sli.sli_flag & LPFC_MENLO_MAINT));
+}
+
+/**
  * lpfc_vportnum_show: Return the port number in ascii of the hba.
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
@@ -352,8 +371,10 @@ lpfc_link_state_show(struct device *dev,
 					"Unknown\n");
 			break;
 		}
-
-		if (phba->fc_topology == TOPOLOGY_LOOP) {
+		if (phba->sli.sli_flag & LPFC_MENLO_MAINT)
+			len += snprintf(buf + len, PAGE_SIZE-len,
+					"   Menlo Maint Mode\n");
+		else if (phba->fc_topology == TOPOLOGY_LOOP) {
 			if (vport->fc_flag & FC_PUBLIC_LOOP)
 				len += snprintf(buf + len, PAGE_SIZE-len,
 						"   Public Loop\n");
@@ -1476,6 +1497,7 @@ static DEVICE_ATTR(option_rom_version, S
 		   lpfc_option_rom_version_show, NULL);
 static DEVICE_ATTR(num_discovered_ports, S_IRUGO,
 		   lpfc_num_discovered_ports_show, NULL);
+static DEVICE_ATTR(menlo_mgmt_mode, S_IRUGO, lpfc_mlomgmt_show, NULL);
 static DEVICE_ATTR(nport_evt_cnt, S_IRUGO, lpfc_nport_evt_cnt_show, NULL);
 static DEVICE_ATTR(lpfc_drvr_version, S_IRUGO, lpfc_drvr_version_show, NULL);
 static DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
@@ -2395,6 +2417,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_option_rom_version,
 	&dev_attr_link_state,
 	&dev_attr_num_discovered_ports,
+	&dev_attr_menlo_mgmt_mode,
 	&dev_attr_lpfc_drvr_version,
 	&dev_attr_lpfc_temp_sensor,
 	&dev_attr_lpfc_log_verbose,
@@ -2763,6 +2786,8 @@ sysfs_mbox_read(struct kobject *kobj, st
 		case MBX_DEL_LD_ENTRY:
 		case MBX_SET_VARIABLE:
 		case MBX_WRITE_WWN:
+		case MBX_PORT_CAPABILITIES:
+		case MBX_PORT_IOV_CONTROL:
 			break;
 		case MBX_READ_SPARM64:
 		case MBX_READ_LA:
@@ -2867,7 +2892,7 @@ static struct bin_attribute sysfs_mbox_a
 };
 
 /**
- * lpfc_alloc_sysfs_attr: Creates the sysfs, ctlreg, menlo and mbox entries.
+ * lpfc_alloc_sysfs_attr: Creates the ctlreg and mbox entries.
  * @vport: address of lpfc vport structure.
  *
  * Return codes:
@@ -2898,7 +2923,7 @@ out:
 }
 
 /**
- * lpfc_free_sysfs_attr: Removes the sysfs, ctlreg, menlo and mbox entries.
+ * lpfc_free_sysfs_attr: Removes the ctlreg and mbox entries.
  * @vport: address of lpfc vport structure.
  **/
 void
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-08-24 20:44:33.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-08-24 20:45:48.000000000 -0400
@@ -613,6 +613,7 @@ struct lpfc_hba {
 	unsigned long last_completion_time;
 	struct timer_list hb_tmofunc;
 	uint8_t hb_outstanding;
+	enum hba_temp_state over_temp_state;
 	/* ndlp reference management */
 	spinlock_t ndlp_lock;
 	/*
@@ -621,7 +622,8 @@ struct lpfc_hba {
 	 */
 #define QUE_BUFTAG_BIT  (1<<31)
 	uint32_t buffer_tag_count;
-	enum hba_temp_state over_temp_state;
+	int wait_4_mlo_maint_flg;
+	wait_queue_head_t wait_4_mlo_m_q;
 };
 
 static inline struct Scsi_Host *
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-08-24 20:43:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-08-24 20:45:48.000000000 -0400
@@ -1021,14 +1021,10 @@ out:
 }
 
 static void
-lpfc_mbx_issue_link_down(struct lpfc_hba *phba)
+lpfc_enable_la(struct lpfc_hba *phba)
 {
 	uint32_t control;
 	struct lpfc_sli *psli = &phba->sli;
-
-	lpfc_linkdown(phba);
-
-	/* turn on Link Attention interrupts - no CLEAR_LA needed */
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag |= LPFC_PROCESS_LA;
 	control = readl(phba->HCregaddr);
@@ -1038,6 +1034,15 @@ lpfc_mbx_issue_link_down(struct lpfc_hba
 	spin_unlock_irq(&phba->hbalock);
 }
 
+static void
+lpfc_mbx_issue_link_down(struct lpfc_hba *phba)
+{
+	lpfc_linkdown(phba);
+	lpfc_enable_la(phba);
+	/* turn on Link Attention interrupts - no CLEAR_LA needed */
+}
+
+
 /*
  * This routine handles processing a READ_LA mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
@@ -1085,8 +1090,12 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 	}
 
 	phba->fc_eventTag = la->eventTag;
+	if (la->mm)
+		phba->sli.sli_flag |= LPFC_MENLO_MAINT;
+	else
+		phba->sli.sli_flag &= ~LPFC_MENLO_MAINT;
 
-	if (la->attType == AT_LINK_UP) {
+	if (la->attType == AT_LINK_UP && (!la->mm)) {
 		phba->fc_stat.LinkUp++;
 		if (phba->link_flag & LS_LOOPBACK_MODE) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
@@ -1098,13 +1107,15 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 		} else {
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 					"1303 Link Up Event x%x received "
-					"Data: x%x x%x x%x x%x\n",
+					"Data: x%x x%x x%x x%x x%x x%x %d\n",
 					la->eventTag, phba->fc_eventTag,
 					la->granted_AL_PA, la->UlnkSpeed,
-					phba->alpa_map[0]);
+					phba->alpa_map[0],
+					la->mm, la->fa,
+					phba->wait_4_mlo_maint_flg);
 		}
 		lpfc_mbx_process_link_up(phba, la);
-	} else {
+	} else if (la->attType == AT_LINK_DOWN) {
 		phba->fc_stat.LinkDown++;
 		if (phba->link_flag & LS_LOOPBACK_MODE) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
@@ -1117,11 +1128,46 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *p
 		else {
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 				"1305 Link Down Event x%x received "
+				"Data: x%x x%x x%x x%x x%x\n",
+				la->eventTag, phba->fc_eventTag,
+				phba->pport->port_state, vport->fc_flag,
+				la->mm, la->fa);
+		}
+		lpfc_mbx_issue_link_down(phba);
+	}
+	if (la->mm && la->attType == AT_LINK_UP) {
+		if (phba->link_state != LPFC_LINK_DOWN) {
+			phba->fc_stat.LinkDown++;
+			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
+				"1312 Link Down Event x%x received "
+				"Data: x%x x%x x%x\n",
+				la->eventTag, phba->fc_eventTag,
+				phba->pport->port_state, vport->fc_flag);
+			lpfc_mbx_issue_link_down(phba);
+		} else
+			lpfc_enable_la(phba);
+
+		lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
+				"1310 Menlo Maint Mode Link up Event x%x rcvd "
 				"Data: x%x x%x x%x\n",
 				la->eventTag, phba->fc_eventTag,
 				phba->pport->port_state, vport->fc_flag);
+		/*
+		 * The cmnd that triggered this will be waiting for this
+		 * signal.
+		 */
+		/* WAKEUP for MENLO_SET_MODE or MENLO_RESET command. */
+		if (phba->wait_4_mlo_maint_flg) {
+			phba->wait_4_mlo_maint_flg = 0;
+			wake_up_interruptible(&phba->wait_4_mlo_m_q);
 		}
-		lpfc_mbx_issue_link_down(phba);
+	}
+
+	if (la->fa) {
+		if (la->mm)
+			lpfc_issue_clear_la(phba, vport);
+		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
+				"1311 fa %d\n", la->fa);
 	}
 
 lpfc_mbx_cmpl_read_la_free_mbuf:
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2008-08-24 20:43:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2008-08-24 20:45:48.000000000 -0400
@@ -1107,6 +1107,8 @@ typedef struct {
 /* Start FireFly Register definitions */
 #define PCI_VENDOR_ID_EMULEX        0x10df
 #define PCI_DEVICE_ID_FIREFLY       0x1ae5
+#define PCI_DEVICE_ID_PROTEUS_VF    0xe100
+#define PCI_DEVICE_ID_PROTEUS_PF    0xe180
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
@@ -1133,10 +1135,12 @@ typedef struct {
 #define PCI_DEVICE_ID_LP11000S      0xfc10
 #define PCI_DEVICE_ID_LPE11000S     0xfc20
 #define PCI_DEVICE_ID_SAT_S         0xfc40
+#define PCI_DEVICE_ID_PROTEUS_S     0xfc50
 #define PCI_DEVICE_ID_HELIOS        0xfd00
 #define PCI_DEVICE_ID_HELIOS_SCSP   0xfd11
 #define PCI_DEVICE_ID_HELIOS_DCSP   0xfd12
 #define PCI_DEVICE_ID_ZEPHYR        0xfe00
+#define PCI_DEVICE_ID_HORNET        0xfe05
 #define PCI_DEVICE_ID_ZEPHYR_SCSP   0xfe11
 #define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
 
@@ -1154,6 +1158,7 @@ typedef struct {
 #define ZEPHYR_JEDEC_ID             0x0577
 #define VIPER_JEDEC_ID              0x4838
 #define SATURN_JEDEC_ID             0x1004
+#define HORNET_JDEC_ID              0x2057706D
 
 #define JEDEC_ID_MASK               0x0FFFF000
 #define JEDEC_ID_SHIFT              12
@@ -1289,6 +1294,9 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_WRITE_VPARMS    0x32
 #define MBX_ASYNCEVT_ENABLE 0x33
 
+#define MBX_PORT_CAPABILITIES 0x3B
+#define MBX_PORT_IOV_CONTROL 0x3C
+
 #define MBX_CONFIG_HBQ	    0x7C
 #define MBX_LOAD_AREA       0x81
 #define MBX_RUN_BIU_DIAG64  0x84
@@ -2195,7 +2203,10 @@ typedef struct {
 typedef struct {
 	uint32_t eventTag;	/* Event tag */
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd1:22;
+	uint32_t rsvd1:19;
+	uint32_t fa:1;
+	uint32_t mm:1;		/* Menlo Maintenance mode enabled */
+	uint32_t rx:1;
 	uint32_t pb:1;
 	uint32_t il:1;
 	uint32_t attType:8;
@@ -2203,7 +2214,10 @@ typedef struct {
 	uint32_t attType:8;
 	uint32_t il:1;
 	uint32_t pb:1;
-	uint32_t rsvd1:22;
+	uint32_t rx:1;
+	uint32_t mm:1;
+	uint32_t fa:1;
+	uint32_t rsvd1:19;
 #endif
 
 #define AT_RESERVED    0x00	/* Reserved - attType */
@@ -2224,6 +2238,7 @@ typedef struct {
 
 #define TOPOLOGY_PT_PT 0x01	/* Topology is pt-pt / pt-fabric */
 #define TOPOLOGY_LOOP  0x02	/* Topology is FC-AL */
+#define TOPOLOGY_LNK_MENLO_MAINTENANCE 0x05 /* maint mode zephtr to menlo */
 
 	union {
 		struct ulp_bde lilpBde; /* This BDE points to a 128 byte buffer
@@ -3346,3 +3361,10 @@ lpfc_error_lost_link(IOCB_t *iocbp)
 		 iocbp->un.ulpWord[4] == IOERR_LINK_DOWN ||
 		 iocbp->un.ulpWord[4] == IOERR_SLI_DOWN));
 }
+
+#define MENLO_TRANSPORT_TYPE 0xfe
+#define MENLO_CONTEXT 0
+#define MENLO_PU 3
+#define MENLO_TIMEOUT 30
+#define SETVAR_MLOMNT 0x103107
+#define SETVAR_MLORST 0x103007
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:43:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:45:48.000000000 -0400
@@ -1130,6 +1130,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	lpfc_vpd_t *vp;
 	uint16_t dev_id = phba->pcidev->device;
 	int max_speed;
+	int GE = 0;
 	struct {
 		char * name;
 		int    max_speed;
@@ -1261,6 +1262,19 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	case PCI_DEVICE_ID_SAT_S:
 		m = (typeof(m)){"LPe12000-S", max_speed, "PCIe"};
 		break;
+	case PCI_DEVICE_ID_HORNET:
+		m = (typeof(m)){"LP21000", max_speed, "PCIe"};
+		GE = 1;
+		break;
+	case PCI_DEVICE_ID_PROTEUS_VF:
+		m = (typeof(m)) {"LPev12000", max_speed, "PCIe IOV"};
+		break;
+	case PCI_DEVICE_ID_PROTEUS_PF:
+		m = (typeof(m)) {"LPev12000", max_speed, "PCIe IOV"};
+		break;
+	case PCI_DEVICE_ID_PROTEUS_S:
+		m = (typeof(m)) {"LPemv12002-S", max_speed, "PCIe IOV"};
+		break;
 	default:
 		m = (typeof(m)){ NULL };
 		break;
@@ -1270,8 +1284,11 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		snprintf(mdp, 79,"%s", m.name);
 	if (descp && descp[0] == '\0')
 		snprintf(descp, 255,
-			 "Emulex %s %dGb %s Fibre Channel Adapter",
-			 m.name, m.max_speed, m.bus);
+			"Emulex %s %d%s %s %s",
+			m.name, m.max_speed,
+			(GE) ? "GE" : "Gb",
+			m.bus,
+			(GE) ? "FCoE Adapter" : "Fibre Channel Adapter");
 }
 
 /**
@@ -2248,6 +2265,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_free_phba;
 
 	INIT_LIST_HEAD(&phba->port_list);
+	init_waitqueue_head(&phba->wait_4_mlo_m_q);
 	/*
 	 * Get all the module params for configuring this host and then
 	 * establish the host.
@@ -2796,6 +2814,8 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HORNET,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_SCSP,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_DCSP,
@@ -2826,6 +2846,12 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_S,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_VF,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_PF,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_S,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:44:33.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:45:48.000000000 -0400
@@ -1050,6 +1050,8 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_REG_VPI:
 	case MBX_UNREG_VPI:
 	case MBX_HEARTBEAT:
+	case MBX_PORT_CAPABILITIES:
+	case MBX_PORT_IOV_CONTROL:
 		ret = mbxCommand;
 		break;
 	default:
@@ -3697,6 +3699,16 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *p
 		 * can be issued if the link is not up.
 		 */
 		switch (piocb->iocb.ulpCommand) {
+		case CMD_GEN_REQUEST64_CR:
+		case CMD_GEN_REQUEST64_CX:
+			if (!(phba->sli.sli_flag & LPFC_MENLO_MAINT) ||
+				(piocb->iocb.un.genreq64.w5.hcsw.Rctl !=
+					FC_FCP_CMND) ||
+				(piocb->iocb.un.genreq64.w5.hcsw.Type !=
+					MENLO_TRANSPORT_TYPE))
+
+				goto iocb_busy;
+			break;
 		case CMD_QUE_RING_BUF_CN:
 		case CMD_QUE_RING_BUF64_CN:
 			/*
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2008-08-24 20:45:48.000000000 -0400
@@ -233,6 +233,7 @@ struct lpfc_sli {
 #define LPFC_SLI2_ACTIVE          0x200	/* SLI2 overlay in firmware is active */
 #define LPFC_PROCESS_LA           0x400	/* Able to process link attention */
 #define LPFC_BLOCK_MGMT_IO        0x800	/* Don't allow mgmt mbx or iocb cmds */
+#define LPFC_MENLO_MAINT          0x1000 /* need for menl fw download */
 
 	struct lpfc_sli_ring ring[LPFC_MAX_RING];
 	int fcp_ring;		/* ring used for FCP initiator commands */


