From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/8] lpfc 8.3.24: Extended hardware support and support
 dump images
Date: Tue, 24 May 2011 11:41:34 -0400
Message-ID: <1306251694.6335.14.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23135 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932Ab1EXPmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2011 11:42:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Extended hardware support and support dump images:
- Make the size to be MAILBOX_SYSFS_MAX (4096) so that it allows the maximum
  sysfs binary access interface possible.
- Add ids and model names for new hardware
- Add capability of inducing SLI4 firmware dump obj file


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lpfc_hw.h   |    4 ++-
 lpfc_hw4.h  |   19 +++++++++++++++++
 lpfc_init.c |   18 ++++++++++++----
 4 files changed, 98 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-04-16 08:29:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-05-23 16:58:34.000000000 -0400
@@ -755,6 +755,61 @@ lpfc_issue_reset(struct device *dev, str
 }
 
 /**
+ * lpfc_sli4_fw_dump_request - Request firmware to perform a firmware dump
+ * @phba: lpfc_hba pointer.
+ *
+ * Description:
+ * Request SLI4 interface type-2 device to perform a dump of firmware dump
+ * object into it's /dbg directory of the flash file system.
+ *
+ * Returns:
+ * zero for success
+ **/
+static ssize_t
+lpfc_sli4_fw_dump_request(struct lpfc_hba *phba)
+{
+	struct completion online_compl;
+	uint32_t reg_val;
+	int status = 0;
+	int rc;
+
+	if (!phba->cfg_enable_hba_reset)
+		return -EIO;
+
+	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
+
+	if (status != 0)
+		return status;
+
+	/* wait for the device to be quiesced before firmware reset */
+	msleep(100);
+
+	reg_val = readl(phba->sli4_hba.conf_regs_memmap_p +
+			LPFC_CTL_PDEV_CTL_OFFSET);
+	reg_val |= LPFC_FW_DUMP_REQUEST;
+	writel(reg_val, phba->sli4_hba.conf_regs_memmap_p +
+	       LPFC_CTL_PDEV_CTL_OFFSET);
+	/* flush */
+	readl(phba->sli4_hba.conf_regs_memmap_p + LPFC_CTL_PDEV_CTL_OFFSET);
+
+	/* delay driver action following IF_TYPE_2 reset */
+	msleep(100);
+
+	init_completion(&online_compl);
+	rc = lpfc_workq_post_event(phba, &status, &online_compl,
+				   LPFC_EVT_ONLINE);
+	if (rc == 0)
+		return -ENOMEM;
+
+	wait_for_completion(&online_compl);
+
+	if (status != 0)
+		return -EIO;
+
+	return 0;
+}
+
+/**
  * lpfc_nport_evt_cnt_show - Return the number of nport events
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
@@ -848,6 +903,13 @@ lpfc_board_mode_store(struct device *dev
 			return -EINVAL;
 		else
 			status = lpfc_do_offline(phba, LPFC_EVT_KILL);
+	else if (strncmp(buf, "dump", sizeof("dump") - 1) == 0)
+		if ((phba->sli_rev < LPFC_SLI_REV4) ||
+		    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+		     LPFC_SLI_INTF_IF_TYPE_2))
+			return -EPERM;
+		else
+			status = lpfc_sli4_fw_dump_request(phba);
 	else
 		return -EINVAL;
 
@@ -3961,7 +4023,7 @@ static struct bin_attribute sysfs_mbox_a
 		.name = "mbox",
 		.mode = S_IRUSR | S_IWUSR,
 	},
-	.size = MAILBOX_CMD_SIZE,
+	.size = MAILBOX_SYSFS_MAX,
 	.read = sysfs_mbox_read,
 	.write = sysfs_mbox_write,
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 16:51:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 16:58:34.000000000 -0400
@@ -170,6 +170,25 @@ struct lpfc_sli_intf {
 #define LPFC_PCI_FUNC3		3
 #define LPFC_PCI_FUNC4		4
 
+/* SLI4 interface type-2 control register offsets */
+#define LPFC_CTL_PORT_SEM_OFFSET	0x400
+#define LPFC_CTL_PORT_STA_OFFSET	0x404
+#define LPFC_CTL_PORT_CTL_OFFSET	0x408
+#define LPFC_CTL_PORT_ER1_OFFSET	0x40C
+#define LPFC_CTL_PORT_ER2_OFFSET	0x410
+#define LPFC_CTL_PDEV_CTL_OFFSET	0x414
+
+/* Some SLI4 interface type-2 PDEV_CTL register bits */
+#define LPFC_CTL_PDEV_CTL_DRST		0x00000001
+#define LPFC_CTL_PDEV_CTL_FRST		0x00000002
+#define LPFC_CTL_PDEV_CTL_DD		0x00000004
+#define LPFC_CTL_PDEV_CTL_LC		0x00000008
+#define LPFC_CTL_PDEV_CTL_FRL_ALL	0x00
+#define LPFC_CTL_PDEV_CTL_FRL_FC_FCOE	0x10
+#define LPFC_CTL_PDEV_CTL_FRL_NIC	0x20
+
+#define LPFC_FW_DUMP_REQUEST    (LPFC_CTL_PDEV_CTL_DD | LPFC_CTL_PDEV_CTL_FRST)
+
 /* Active interrupt test count */
 #define LPFC_ACT_INTR_CNT	4
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2011-03-27 11:03:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2011-05-23 16:58:34.000000000 -0400
@@ -1199,7 +1199,9 @@ typedef struct {
 #define PCI_DEVICE_ID_BALIUS        0xe131
 #define PCI_DEVICE_ID_PROTEUS_PF    0xe180
 #define PCI_DEVICE_ID_LANCER_FC     0xe200
+#define PCI_DEVICE_ID_LANCER_FC_VF  0xe208
 #define PCI_DEVICE_ID_LANCER_FCOE   0xe260
+#define PCI_DEVICE_ID_LANCER_FCOE_VF 0xe268
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
@@ -3021,7 +3023,7 @@ typedef struct {
 #define MAILBOX_EXT_SIZE	(MAILBOX_EXT_WSIZE * sizeof(uint32_t))
 #define MAILBOX_HBA_EXT_OFFSET  0x100
 /* max mbox xmit size is a page size for sysfs IO operations */
-#define MAILBOX_MAX_XMIT_SIZE   PAGE_SIZE
+#define MAILBOX_SYSFS_MAX	4096
 
 typedef union {
 	uint32_t varWords[MAILBOX_CMD_WSIZE - 1]; /* first word is type/
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 16:51:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 16:58:34.000000000 -0400
@@ -1784,7 +1784,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		&& descp && descp[0] != '\0')
 		return;
 
-	if (phba->lmt & LMT_10Gb)
+	if (phba->lmt & LMT_16Gb)
+		max_speed = 16;
+	else if (phba->lmt & LMT_10Gb)
 		max_speed = 10;
 	else if (phba->lmt & LMT_8Gb)
 		max_speed = 8;
@@ -1951,12 +1953,13 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 				"Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_FC:
-		oneConnect = 1;
-		m = (typeof(m)){"Undefined", "PCIe", "Fibre Channel Adapter"};
+	case PCI_DEVICE_ID_LANCER_FC_VF:
+		m = (typeof(m)){"LPe16000", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_FCOE:
+	case PCI_DEVICE_ID_LANCER_FCOE_VF:
 		oneConnect = 1;
-		m = (typeof(m)){"Undefined", "PCIe", "FCoE"};
+		m = (typeof(m)){"OCe50100", "PCIe", "FCoE"};
 		break;
 	default:
 		m = (typeof(m)){"Unknown", "", ""};
@@ -1965,7 +1968,8 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 
 	if (mdp && mdp[0] == '\0')
 		snprintf(mdp, 79,"%s", m.name);
-	/* oneConnect hba requires special processing, they are all initiators
+	/*
+	 * oneConnect hba requires special processing, they are all initiators
 	 * and we put the port number on the end
 	 */
 	if (descp && descp[0] == '\0') {
@@ -9580,6 +9584,10 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FC_VF,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE_VF,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 


