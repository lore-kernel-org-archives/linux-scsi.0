From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 05/17] cxlflash: Support dynamic number of FC ports
Date: Wed, 12 Apr 2017 14:13:50 -0500
Message-ID: <1492024430-55809-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39950 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752393AbdDLTOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:14:11 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ999G086711
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:10 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29sn06gkym-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:10 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:14:08 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Transition from a static number of FC ports to a value that is derived
during probe. For now, a static value is used but this will later be
based on the type of card being configured.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h    |  7 ++--
 drivers/scsi/cxlflash/main.c      | 71 ++++++++++++++++++++++++---------------
 drivers/scsi/cxlflash/main.h      |  2 --
 drivers/scsi/cxlflash/sislite.h   |  1 +
 drivers/scsi/cxlflash/superpipe.h |  2 +-
 5 files changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 3ff05f1..6a04867 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -25,7 +25,9 @@
 
 extern const struct file_operations cxlflash_cxl_fops;
 
-#define MAX_CONTEXT  CXLFLASH_MAX_CONTEXT       /* num contexts per afu */
+#define MAX_CONTEXT	CXLFLASH_MAX_CONTEXT	/* num contexts per afu */
+#define NUM_FC_PORTS	CXLFLASH_NUM_FC_PORTS	/* ports per AFU */
+#define MAX_FC_PORTS	CXLFLASH_MAX_FC_PORTS	/* ports per AFU */
 
 #define CXLFLASH_BLOCK_SIZE	4096	/* 4K blocks */
 #define CXLFLASH_MAX_XFER_SIZE	16777216	/* 16MB transfer */
@@ -98,6 +100,7 @@ struct cxlflash_cfg {
 	struct pci_dev *dev;
 	struct pci_device_id *dev_id;
 	struct Scsi_Host *host;
+	int num_fc_ports;
 
 	ulong cxlflash_regs_pci;
 
@@ -118,7 +121,7 @@ struct cxlflash_cfg {
 	struct file_operations cxl_fops;
 
 	/* Parameters that are LUN table related */
-	int last_lun_index[CXLFLASH_NUM_FC_PORTS];
+	int last_lun_index[MAX_FC_PORTS];
 	int promote_lun_index;
 	struct list_head lluns; /* list of llun_info structs */
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 157d806..3f9c869 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -689,7 +689,7 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
 	global = &afu->afu_map->global;
 
 	/* Notify AFU */
-	for (i = 0; i < NUM_FC_PORTS; i++) {
+	for (i = 0; i < cfg->num_fc_ports; i++) {
 		reg = readq_be(&global->fc_regs[i][FC_CONFIG2 / 8]);
 		reg |= SISL_FC_SHUTDOWN_NORMAL;
 		writeq_be(reg, &global->fc_regs[i][FC_CONFIG2 / 8]);
@@ -699,7 +699,7 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
 		return;
 
 	/* Wait up to 1.5 seconds for shutdown processing to complete */
-	for (i = 0; i < NUM_FC_PORTS; i++) {
+	for (i = 0; i < cfg->num_fc_ports; i++) {
 		retry_cnt = 0;
 		while (true) {
 			status = readq_be(&global->fc_regs[i][FC_STATUS / 8]);
@@ -1072,6 +1072,7 @@ static const struct asyc_intr_info *find_ainfo(u64 status)
  */
 static void afu_err_intr_init(struct afu *afu)
 {
+	struct cxlflash_cfg *cfg = afu->parent;
 	int i;
 	u64 reg;
 
@@ -1107,7 +1108,7 @@ static void afu_err_intr_init(struct afu *afu)
 	writeq_be(reg, &afu->afu_map->global.fc_regs[0][FC_CONFIG2 / 8]);
 
 	/* now clear FC errors */
-	for (i = 0; i < NUM_FC_PORTS; i++) {
+	for (i = 0; i < cfg->num_fc_ports; i++) {
 		writeq_be(0xFFFFFFFFU,
 			  &afu->afu_map->global.fc_regs[i][FC_ERROR / 8]);
 		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRCAP / 8]);
@@ -1394,7 +1395,7 @@ static int start_context(struct cxlflash_cfg *cfg)
 /**
  * read_vpd() - obtains the WWPNs from VPD
  * @cfg:	Internal structure associated with the host.
- * @wwpn:	Array of size NUM_FC_PORTS to pass back WWPNs
+ * @wwpn:	Array of size MAX_FC_PORTS to pass back WWPNs
  *
  * Return: 0 on success, -errno on failure
  */
@@ -1407,7 +1408,7 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	ssize_t vpd_size;
 	char vpd_data[CXLFLASH_VPD_LEN];
 	char tmp_buf[WWPN_BUF_LEN] = { 0 };
-	char *wwpn_vpd_tags[NUM_FC_PORTS] = { "V5", "V6" };
+	char *wwpn_vpd_tags[MAX_FC_PORTS] = { "V5", "V6" };
 
 	/* Get the VPD data from the device */
 	vpd_size = cxl_read_adapter_vpd(pdev, vpd_data, sizeof(vpd_data));
@@ -1445,7 +1446,7 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 	 * because the conversion service requires that the ASCII
 	 * string be terminated.
 	 */
-	for (k = 0; k < NUM_FC_PORTS; k++) {
+	for (k = 0; k < cfg->num_fc_ports; k++) {
 		j = ro_size;
 		i = ro_start + PCI_VPD_LRDT_TAG_SIZE;
 
@@ -1474,6 +1475,8 @@ static int read_vpd(struct cxlflash_cfg *cfg, u64 wwpn[])
 			rc = -ENODEV;
 			goto out;
 		}
+
+		dev_dbg(dev, "%s: wwpn%d=%016llx\n", __func__, k, wwpn[k]);
 	}
 
 out:
@@ -1520,7 +1523,7 @@ static int init_global(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
-	u64 wwpn[NUM_FC_PORTS];	/* wwpn of AFU ports */
+	u64 wwpn[MAX_FC_PORTS];	/* wwpn of AFU ports */
 	int i = 0, num_ports = 0;
 	int rc = 0;
 	u64 reg;
@@ -1531,9 +1534,6 @@ static int init_global(struct cxlflash_cfg *cfg)
 		goto out;
 	}
 
-	dev_dbg(dev, "%s: wwpn0=%016llx wwpn1=%016llx\n",
-		__func__, wwpn[0], wwpn[1]);
-
 	/* Set up RRQ and SQ in AFU for master issued cmds */
 	writeq_be((u64) afu->hrrq_start, &afu->host_map->rrq_start);
 	writeq_be((u64) afu->hrrq_end, &afu->host_map->rrq_end);
@@ -1556,10 +1556,10 @@ static int init_global(struct cxlflash_cfg *cfg)
 	if (afu->internal_lun) {
 		/* Only use port 0 */
 		writeq_be(PORT0, &afu->afu_map->global.regs.afu_port_sel);
-		num_ports = NUM_FC_PORTS - 1;
+		num_ports = 0;
 	} else {
 		writeq_be(BOTH_PORTS, &afu->afu_map->global.regs.afu_port_sel);
-		num_ports = NUM_FC_PORTS;
+		num_ports = cfg->num_fc_ports;
 	}
 
 	for (i = 0; i < num_ports; i++) {
@@ -2061,19 +2061,25 @@ static int cxlflash_change_queue_depth(struct scsi_device *sdev, int qdepth)
  * @cfg:	Internal structure associated with the host.
  * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
  *
- * Return: The size of the ASCII string returned in @buf.
+ * Return: The size of the ASCII string returned in @buf or -EINVAL.
  */
 static ssize_t cxlflash_show_port_status(u32 port,
 					 struct cxlflash_cfg *cfg,
 					 char *buf)
 {
+	struct device *dev = &cfg->dev->dev;
 	struct afu *afu = cfg->afu;
 	char *disp_status;
 	u64 status;
 	__be64 __iomem *fc_regs;
 
-	if (port >= NUM_FC_PORTS)
-		return 0;
+	WARN_ON(port >= MAX_FC_PORTS);
+
+	if (port >= cfg->num_fc_ports) {
+		dev_info(dev, "%s: Port %d not supported on this card.\n",
+			__func__, port);
+		return -EINVAL;
+	}
 
 	fc_regs = &afu->afu_map->global.fc_regs[port][0];
 	status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
@@ -2178,12 +2184,13 @@ static ssize_t lun_mode_store(struct device *dev,
 
 		/*
 		 * When configured for internal LUN, there is only one channel,
-		 * channel number 0, else there will be 2 (default).
+		 * channel number 0, else there will be one less than the number
+		 * of fc ports for this card.
 		 */
 		if (afu->internal_lun)
 			shost->max_channel = 0;
 		else
-			shost->max_channel = NUM_FC_PORTS - 1;
+			shost->max_channel = cfg->num_fc_ports - 1;
 
 		afu_reset(cfg);
 		scsi_scan_host(cfg->host);
@@ -2212,19 +2219,25 @@ static ssize_t ioctl_version_show(struct device *dev,
  * @cfg:	Internal structure associated with the host.
  * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
  *
- * Return: The size of the ASCII string returned in @buf.
+ * Return: The size of the ASCII string returned in @buf or -EINVAL.
  */
 static ssize_t cxlflash_show_port_lun_table(u32 port,
 					    struct cxlflash_cfg *cfg,
 					    char *buf)
 {
+	struct device *dev = &cfg->dev->dev;
 	struct afu *afu = cfg->afu;
 	int i;
 	ssize_t bytes = 0;
 	__be64 __iomem *fc_port;
 
-	if (port >= NUM_FC_PORTS)
-		return 0;
+	WARN_ON(port >= MAX_FC_PORTS);
+
+	if (port >= cfg->num_fc_ports) {
+		dev_info(dev, "%s: Port %d not supported on this card.\n",
+			__func__, port);
+		return -EINVAL;
+	}
 
 	fc_port = &afu->afu_map->global.fc_port[port][0];
 
@@ -2499,6 +2512,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	struct device *dev = &pdev->dev;
 	struct dev_dependent_vals *ddv;
 	int rc = 0;
+	int k;
 
 	dev_dbg(&pdev->dev, "%s: Found CXLFLASH with IRQ: %d\n",
 		__func__, pdev->irq);
@@ -2531,17 +2545,20 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	cfg->init_state = INIT_STATE_NONE;
 	cfg->dev = pdev;
+	cfg->num_fc_ports = NUM_FC_PORTS;
 	cfg->cxl_fops = cxlflash_cxl_fops;
 
 	/*
-	 * The promoted LUNs move to the top of the LUN table. The rest stay
-	 * on the bottom half. The bottom half grows from the end
-	 * (index = 255), whereas the top half grows from the beginning
-	 * (index = 0).
+	 * Promoted LUNs move to the top of the LUN table. The rest stay on
+	 * the bottom half. The bottom half grows from the end (index = 255),
+	 * whereas the top half grows from the beginning (index = 0).
+	 *
+	 * Initialize the last LUN index for all possible ports.
 	 */
-	cfg->promote_lun_index  = 0;
-	cfg->last_lun_index[0] = CXLFLASH_NUM_VLUNS/2 - 1;
-	cfg->last_lun_index[1] = CXLFLASH_NUM_VLUNS/2 - 1;
+	cfg->promote_lun_index = 0;
+
+	for (k = 0; k < MAX_FC_PORTS; k++)
+		cfg->last_lun_index[k] = CXLFLASH_NUM_VLUNS/2 - 1;
 
 	cfg->dev_id = (struct pci_device_id *)dev_id;
 
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 0be2261..49657f1 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -37,8 +37,6 @@
 
 #define CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT	(120 * HZ)
 
-#define NUM_FC_PORTS	CXLFLASH_NUM_FC_PORTS	/* ports per AFU */
-
 /* FC defines */
 #define FC_MTIP_CMDCONFIG 0x010
 #define FC_MTIP_STATUS 0x018
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index a6e48a8..0db4bc1 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -367,6 +367,7 @@ struct sisl_global_regs {
 #define SISL_INTVER_CAP_RESERVED_CMD_MODE_B	0x100000000000ULL
 };
 
+#define CXLFLASH_MAX_FC_PORTS   2
 #define CXLFLASH_NUM_FC_PORTS   2
 #define CXLFLASH_MAX_CONTEXT  512	/* how many contexts per afu */
 #define CXLFLASH_NUM_VLUNS    512
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 9e62ff3..690ce9c 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -59,7 +59,7 @@ struct glun_info {
 
 /* Local (per-adapter) lun_info structure */
 struct llun_info {
-	u64 lun_id[CXLFLASH_NUM_FC_PORTS]; /* from REPORT_LUNS */
+	u64 lun_id[MAX_FC_PORTS]; /* from REPORT_LUNS */
 	u32 lun_index;		/* Index in the LUN table */
 	u32 host_no;		/* host_no from Scsi_host */
 	u32 port_sel;		/* What port to use for this LUN */
-- 
2.1.0
