From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/6] lpfc 8.3.9: Changes to sysfs interface for the lpfc
 driver.
Date: Fri, 12 Feb 2010 14:42:33 -0500
Message-ID: <1266003773.2939.17.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:49984 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757181Ab0BLTnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 14:43:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Convert all sysfs parameters to uint instead of int.
- Add lpfc_supress_link_up parameter.
- Change link_state to writable sysfs parameter.
- Add support to be able to "up" or "down" link from link_state parameter.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    5 ++
 lpfc_attr.c |  110 ++++++++++++++++++++++++++++++++++++++++++------------------
 lpfc_init.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_scsi.c |    1 
 4 files changed, 183 insertions(+), 33 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-01-22 12:03:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-02-12 10:53:25.000000000 -0500
@@ -482,6 +482,41 @@ lpfc_link_state_show(struct device *dev,
 }
 
 /**
+ * lpfc_link_state_store - Transition the link_state on an HBA port
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: one or more lpfc_polling_flags values.
+ * @count: not used.
+ *
+ * Returns:
+ * -EINVAL if the buffer is not "up" or "down"
+ * return from link state change function if non-zero
+ * length of the buf on success
+ **/
+static ssize_t
+lpfc_link_state_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	int status = -EINVAL;
+
+	if ((strncmp(buf, "up", sizeof("up") - 1) == 0) &&
+			(phba->link_state == LPFC_LINK_DOWN))
+		status = phba->lpfc_hba_init_link(phba);
+	else if ((strncmp(buf, "down", sizeof("down") - 1) == 0) &&
+			(phba->link_state >= LPFC_LINK_UP))
+		status = phba->lpfc_hba_down_link(phba);
+
+	if (status == 0)
+		return strlen(buf);
+	else
+		return status;
+}
+
+/**
  * lpfc_num_discovered_ports_show - Return sum of mapped and unmapped vports
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
@@ -1219,7 +1254,7 @@ lpfc_##attr##_show(struct device *dev, s
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
 	struct lpfc_hba   *phba = vport->phba;\
-	int val = 0;\
+	uint val = 0;\
 	val = phba->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%d\n",\
 			phba->cfg_##attr);\
@@ -1247,7 +1282,7 @@ lpfc_##attr##_show(struct device *dev, s
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
 	struct lpfc_hba   *phba = vport->phba;\
-	int val = 0;\
+	uint val = 0;\
 	val = phba->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%#x\n",\
 			phba->cfg_##attr);\
@@ -1274,7 +1309,7 @@ lpfc_##attr##_show(struct device *dev, s
  **/
 #define lpfc_param_init(attr, default, minval, maxval)	\
 static int \
-lpfc_##attr##_init(struct lpfc_hba *phba, int val) \
+lpfc_##attr##_init(struct lpfc_hba *phba, uint val) \
 { \
 	if (val >= minval && val <= maxval) {\
 		phba->cfg_##attr = val;\
@@ -1309,7 +1344,7 @@ lpfc_##attr##_init(struct lpfc_hba *phba
  **/
 #define lpfc_param_set(attr, default, minval, maxval)	\
 static int \
-lpfc_##attr##_set(struct lpfc_hba *phba, int val) \
+lpfc_##attr##_set(struct lpfc_hba *phba, uint val) \
 { \
 	if (val >= minval && val <= maxval) {\
 		phba->cfg_##attr = val;\
@@ -1350,7 +1385,7 @@ lpfc_##attr##_store(struct device *dev, 
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
 	struct lpfc_hba   *phba = vport->phba;\
-	int val=0;\
+	uint val = 0;\
 	if (!isdigit(buf[0]))\
 		return -EINVAL;\
 	if (sscanf(buf, "%i", &val) != 1)\
@@ -1382,7 +1417,7 @@ lpfc_##attr##_show(struct device *dev, s
 { \
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
-	int val = 0;\
+	uint val = 0;\
 	val = vport->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%d\n", vport->cfg_##attr);\
 }
@@ -1409,7 +1444,7 @@ lpfc_##attr##_show(struct device *dev, s
 { \
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
-	int val = 0;\
+	uint val = 0;\
 	val = vport->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%#x\n", vport->cfg_##attr);\
 }
@@ -1434,7 +1469,7 @@ lpfc_##attr##_show(struct device *dev, s
  **/
 #define lpfc_vport_param_init(attr, default, minval, maxval)	\
 static int \
-lpfc_##attr##_init(struct lpfc_vport *vport, int val) \
+lpfc_##attr##_init(struct lpfc_vport *vport, uint val) \
 { \
 	if (val >= minval && val <= maxval) {\
 		vport->cfg_##attr = val;\
@@ -1466,7 +1501,7 @@ lpfc_##attr##_init(struct lpfc_vport *vp
  **/
 #define lpfc_vport_param_set(attr, default, minval, maxval)	\
 static int \
-lpfc_##attr##_set(struct lpfc_vport *vport, int val) \
+lpfc_##attr##_set(struct lpfc_vport *vport, uint val) \
 { \
 	if (val >= minval && val <= maxval) {\
 		vport->cfg_##attr = val;\
@@ -1502,7 +1537,7 @@ lpfc_##attr##_store(struct device *dev, 
 { \
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
-	int val=0;\
+	uint val = 0;\
 	if (!isdigit(buf[0]))\
 		return -EINVAL;\
 	if (sscanf(buf, "%i", &val) != 1)\
@@ -1515,22 +1550,22 @@ lpfc_##attr##_store(struct device *dev, 
 

 #define LPFC_ATTR(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_init(name, defval, minval, maxval)
 
 #define LPFC_ATTR_R(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_show(name)\
 lpfc_param_init(name, defval, minval, maxval)\
 static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
 
 #define LPFC_ATTR_RW(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_show(name)\
 lpfc_param_init(name, defval, minval, maxval)\
@@ -1540,16 +1575,16 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 		   lpfc_##name##_show, lpfc_##name##_store)
 
 #define LPFC_ATTR_HEX_R(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_hex_show(name)\
 lpfc_param_init(name, defval, minval, maxval)\
 static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
 
 #define LPFC_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_hex_show(name)\
 lpfc_param_init(name, defval, minval, maxval)\
@@ -1559,22 +1594,22 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 		   lpfc_##name##_show, lpfc_##name##_store)
 
 #define LPFC_VPORT_ATTR(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_init(name, defval, minval, maxval)
 
 #define LPFC_VPORT_ATTR_R(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
 static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
 
 #define LPFC_VPORT_ATTR_RW(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
@@ -1584,16 +1619,16 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 		   lpfc_##name##_show, lpfc_##name##_store)
 
 #define LPFC_VPORT_ATTR_HEX_R(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_hex_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
 static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
 
 #define LPFC_VPORT_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
-static int lpfc_##name = defval;\
-module_param(lpfc_##name, int, 0);\
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_hex_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
@@ -1614,7 +1649,8 @@ static DEVICE_ATTR(programtype, S_IRUGO,
 static DEVICE_ATTR(portnum, S_IRUGO, lpfc_vportnum_show, NULL);
 static DEVICE_ATTR(fwrev, S_IRUGO, lpfc_fwrev_show, NULL);
 static DEVICE_ATTR(hdw, S_IRUGO, lpfc_hdw_show, NULL);
-static DEVICE_ATTR(link_state, S_IRUGO, lpfc_link_state_show, NULL);
+static DEVICE_ATTR(link_state, S_IRUGO | S_IWUSR, lpfc_link_state_show,
+		lpfc_link_state_store);
 static DEVICE_ATTR(option_rom_version, S_IRUGO,
 		   lpfc_option_rom_version_show, NULL);
 static DEVICE_ATTR(num_discovered_ports, S_IRUGO,
@@ -1897,6 +1933,15 @@ static DEVICE_ATTR(lpfc_enable_npiv, S_I
 			 lpfc_enable_npiv_show, NULL);
 
 /*
+# lpfc_suppress_link_up:  Bring link up at initialization
+#            0x0  = bring link up (issue MBX_INIT_LINK)
+#            0x1  = do NOT bring link up at initialization(MBX_INIT_LINK)
+#            0x2  = never bring up link
+# Default value is 0.
+*/
+LPFC_ATTR_R(suppress_link_up, 0, 0, 2, "Suppress Link Up at initialization");
+
+/*
 # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
 # until the timer expires. Value range is [0,255]. Default value is 30.
 */
@@ -3278,6 +3323,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_prot_sg_seg_cnt,
 	&dev_attr_lpfc_aer_support,
 	&dev_attr_lpfc_aer_state_cleanup,
+	&dev_attr_lpfc_suppress_link_up,
 	NULL,
 };
 
@@ -4456,7 +4502,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
 	lpfc_aer_support_init(phba, lpfc_aer_support);
-
+	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	return;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-02-12 10:53:25.000000000 -0500
@@ -504,6 +504,10 @@ struct lpfc_hba {
 		(struct lpfc_hba *);
 	void (*lpfc_stop_port)
 		(struct lpfc_hba *);
+	int (*lpfc_hba_init_link)
+		(struct lpfc_hba *);
+	int (*lpfc_hba_down_link)
+		(struct lpfc_hba *);
 

 	/* SLI4 specific HBA data structure */
@@ -618,6 +622,7 @@ struct lpfc_hba {
 	uint32_t cfg_enable_bg;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_aer_support;
+	uint32_t cfg_suppress_link_up;
 
 	lpfc_vpd_t vpd;		/* vital product data */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:53:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:53:25.000000000 -0500
@@ -544,7 +544,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 			mempool_free(pmb, phba->mbox_mem_pool);
 			return -EIO;
 		}
-	} else {
+	} else if (phba->cfg_suppress_link_up == 0) {
 		lpfc_init_link(phba, pmb, phba->cfg_topology,
 			phba->cfg_link_speed);
 		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
@@ -603,6 +603,102 @@ lpfc_config_port_post(struct lpfc_hba *p
 }
 
 /**
+ * lpfc_hba_init_link - Initialize the FC link
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine will issue the INIT_LINK mailbox command call.
+ * It is available to other drivers through the lpfc_hba data
+ * structure for use as a delayed link up mechanism with the
+ * module parameter lpfc_suppress_link_up.
+ *
+ * Return code
+ *		0 - success
+ *		Any other value - error
+ **/
+int
+lpfc_hba_init_link(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+	LPFC_MBOXQ_t *pmb;
+	MAILBOX_t *mb;
+	int rc;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		phba->link_state = LPFC_HBA_ERROR;
+		return -ENOMEM;
+	}
+	mb = &pmb->u.mb;
+	pmb->vport = vport;
+
+	lpfc_init_link(phba, pmb, phba->cfg_topology,
+		phba->cfg_link_speed);
+	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	lpfc_set_loopback_flag(phba);
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"0498 Adapter failed to init, mbxCmd x%x "
+			"INIT_LINK, mbxStatus x%x\n",
+			mb->mbxCommand, mb->mbxStatus);
+		/* Clear all interrupt enable conditions */
+		writel(0, phba->HCregaddr);
+		readl(phba->HCregaddr); /* flush */
+		/* Clear all pending interrupts */
+		writel(0xffffffff, phba->HAregaddr);
+		readl(phba->HAregaddr); /* flush */
+		phba->link_state = LPFC_HBA_ERROR;
+		if (rc != MBX_BUSY)
+			mempool_free(pmb, phba->mbox_mem_pool);
+		return -EIO;
+	}
+	phba->cfg_suppress_link_up = 0;
+
+	return 0;
+}
+
+/**
+ * lpfc_hba_down_link - this routine downs the FC link
+ *
+ * This routine will issue the DOWN_LINK mailbox command call.
+ * It is available to other drivers through the lpfc_hba data
+ * structure for use to stop the link.
+ *
+ * Return code
+ *		0 - success
+ *		Any other value - error
+ **/
+int
+lpfc_hba_down_link(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *pmb;
+	int rc;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		phba->link_state = LPFC_HBA_ERROR;
+		return -ENOMEM;
+	}
+
+	lpfc_printf_log(phba,
+		KERN_ERR, LOG_INIT,
+		"0491 Adapter Link is disabled.\n");
+	lpfc_down_link(phba, pmb);
+	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	if ((rc != MBX_SUCCESS) && (rc != MBX_BUSY)) {
+		lpfc_printf_log(phba,
+		KERN_ERR, LOG_INIT,
+		"2522 Adapter failed to issue DOWN_LINK"
+		" mbox command rc 0x%x\n", rc);
+
+		mempool_free(pmb, phba->mbox_mem_pool);
+		return -EIO;
+	}
+	return 0;
+}
+
+/**
  * lpfc_hba_down_prep - Perform lpfc uninitialization prior to HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
@@ -3952,6 +4048,8 @@ lpfc_sli4_driver_resource_unset(struct l
 int
 lpfc_init_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 {
+	phba->lpfc_hba_init_link = lpfc_hba_init_link;
+	phba->lpfc_hba_down_link = lpfc_hba_down_link;
 	switch (dev_grp) {
 	case LPFC_PCI_DEV_LP:
 		phba->lpfc_hba_down_post = lpfc_hba_down_post_s3;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-12 10:53:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-12 10:53:25.000000000 -0500
@@ -2640,6 +2640,7 @@ lpfc_scsi_api_table_setup(struct lpfc_hb
 	}
 	phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf;
 	phba->lpfc_rampdown_queue_depth = lpfc_rampdown_queue_depth;
+	phba->lpfc_scsi_cmd_iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
 	return 0;
 }
 


