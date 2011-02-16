From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/6] lpfc 8.3.21: Initialization and user interface changes
Date: Wed, 16 Feb 2011 12:39:57 -0500
Message-ID: <1297877997.1492.27.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:7549 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753738Ab1BPRkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2011 12:40:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Make link speed not supported by port message an error message.
- Add support for new SLI failure codes add sysfs parameter to reflect the
  security setting and current state.
- Add all lpfc module parameters to the /sys/modules/lpfc/parameters directory.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    2 -
 lpfc_attr.c    |   75 ++++++++++++++++++++++++++++++++++++++-------------------
 lpfc_debugfs.c |    8 +++---
 lpfc_hw.h      |    5 +++
 lpfc_init.c    |    2 -
 lpfc_mbox.c    |    3 +-
 lpfc_scsi.c    |   14 +++++++---
 7 files changed, 72 insertions(+), 37 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-02-16 11:32:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-02-16 11:35:01.000000000 -0500
@@ -678,6 +678,7 @@ lpfc_do_offline(struct lpfc_hba *phba, u
  *
  * Notes:
  * Assumes any error from lpfc_do_offline() will be negative.
+ * Do not make this function static.
  *
  * Returns:
  * lpfc_do_offline() return code if not zero
@@ -1293,6 +1294,28 @@ lpfc_fips_rev_show(struct device *dev,  
 }
 
 /**
+ * lpfc_dss_show - Return the current state of dss and the configured state
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the formatted text.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_dss_show(struct device *dev, struct device_attribute *attr,
+	      char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	return snprintf(buf, PAGE_SIZE, "%s - %sOperational\n",
+			(phba->cfg_enable_dss) ? "Enabled" : "Disabled",
+			(phba->sli3_options & LPFC_SLI3_DSS_ENABLED) ?
+				"" : "Not ");
+}
+
+/**
  * lpfc_param_show - Return a cfg attribute value in decimal
  *
  * Description:
@@ -1611,13 +1634,13 @@ lpfc_##attr##_store(struct device *dev, 
 
 #define LPFC_ATTR(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_init(name, defval, minval, maxval)
 
 #define LPFC_ATTR_R(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_show(name)\
 lpfc_param_init(name, defval, minval, maxval)\
@@ -1625,7 +1648,7 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 
 #define LPFC_ATTR_RW(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_show(name)\
 lpfc_param_init(name, defval, minval, maxval)\
@@ -1636,7 +1659,7 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 
 #define LPFC_ATTR_HEX_R(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_hex_show(name)\
 lpfc_param_init(name, defval, minval, maxval)\
@@ -1644,7 +1667,7 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 
 #define LPFC_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_hex_show(name)\
 lpfc_param_init(name, defval, minval, maxval)\
@@ -1655,13 +1678,13 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 
 #define LPFC_VPORT_ATTR(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_init(name, defval, minval, maxval)
 
 #define LPFC_VPORT_ATTR_R(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
@@ -1669,7 +1692,7 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 
 #define LPFC_VPORT_ATTR_RW(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
@@ -1680,7 +1703,7 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 
 #define LPFC_VPORT_ATTR_HEX_R(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_hex_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
@@ -1688,7 +1711,7 @@ static DEVICE_ATTR(lpfc_##name, S_IRUGO 
 
 #define LPFC_VPORT_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, 0);\
+module_param(lpfc_##name, uint, S_IRUGO);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_vport_param_hex_show(name)\
 lpfc_vport_param_init(name, defval, minval, maxval)\
@@ -1732,7 +1755,7 @@ static DEVICE_ATTR(npiv_info, S_IRUGO, l
 static DEVICE_ATTR(lpfc_temp_sensor, S_IRUGO, lpfc_temp_sensor_show, NULL);
 static DEVICE_ATTR(lpfc_fips_level, S_IRUGO, lpfc_fips_level_show, NULL);
 static DEVICE_ATTR(lpfc_fips_rev, S_IRUGO, lpfc_fips_rev_show, NULL);
-
+static DEVICE_ATTR(lpfc_dss, S_IRUGO, lpfc_dss_show, NULL);
 
 static char *lpfc_soft_wwn_key = "C99G71SL8032A";
 
@@ -1973,7 +1996,7 @@ static DEVICE_ATTR(lpfc_soft_wwnn, S_IRU
 
 
 static int lpfc_poll = 0;
-module_param(lpfc_poll, int, 0);
+module_param(lpfc_poll, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_poll, "FCP ring polling mode control:"
 		 " 0 - none,"
 		 " 1 - poll with interrupts enabled"
@@ -1983,21 +2006,21 @@ static DEVICE_ATTR(lpfc_poll, S_IRUGO | 
 		   lpfc_poll_show, lpfc_poll_store);
 
 int  lpfc_sli_mode = 0;
-module_param(lpfc_sli_mode, int, 0);
+module_param(lpfc_sli_mode, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_sli_mode, "SLI mode selector:"
 		 " 0 - auto (SLI-3 if supported),"
 		 " 2 - select SLI-2 even on SLI-3 capable HBAs,"
 		 " 3 - select SLI-3");
 
 int lpfc_enable_npiv = 1;
-module_param(lpfc_enable_npiv, int, 0);
+module_param(lpfc_enable_npiv, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_enable_npiv, "Enable NPIV functionality");
 lpfc_param_show(enable_npiv);
 lpfc_param_init(enable_npiv, 1, 0, 1);
 static DEVICE_ATTR(lpfc_enable_npiv, S_IRUGO, lpfc_enable_npiv_show, NULL);
 
 int lpfc_enable_rrq;
-module_param(lpfc_enable_rrq, int, 0);
+module_param(lpfc_enable_rrq, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_enable_rrq, "Enable RRQ functionality");
 lpfc_param_show(enable_rrq);
 lpfc_param_init(enable_rrq, 0, 0, 1);
@@ -2059,7 +2082,7 @@ static DEVICE_ATTR(txcmplq_hw, S_IRUGO,
 			 lpfc_txcmplq_hw_show, NULL);
 
 int lpfc_iocb_cnt = 2;
-module_param(lpfc_iocb_cnt, int, 1);
+module_param(lpfc_iocb_cnt, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_iocb_cnt,
 	"Number of IOCBs alloc for ELS, CT, and ABTS: 1k to 5k IOCBs");
 lpfc_param_show(iocb_cnt);
@@ -2211,7 +2234,7 @@ static DEVICE_ATTR(lpfc_nodev_tmo, S_IRU
 # disappear until the timer expires. Value range is [0,255]. Default
 # value is 30.
 */
-module_param(lpfc_devloss_tmo, int, 0);
+module_param(lpfc_devloss_tmo, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_devloss_tmo,
 		 "Seconds driver will hold I/O waiting "
 		 "for a device to come back");
@@ -2321,7 +2344,7 @@ LPFC_VPORT_ATTR_R(peer_port_login, 0, 0,
 # Default value of this parameter is 1.
 */
 static int lpfc_restrict_login = 1;
-module_param(lpfc_restrict_login, int, 0);
+module_param(lpfc_restrict_login, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_restrict_login,
 		 "Restrict virtual ports login to remote initiators.");
 lpfc_vport_param_show(restrict_login);
@@ -2492,7 +2515,7 @@ lpfc_topology_store(struct device *dev, 
 	return -EINVAL;
 }
 static int lpfc_topology = 0;
-module_param(lpfc_topology, int, 0);
+module_param(lpfc_topology, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_topology, "Select Fibre Channel topology");
 lpfc_param_show(topology)
 lpfc_param_init(topology, 0, 0, 6)
@@ -2934,7 +2957,7 @@ lpfc_link_speed_store(struct device *dev
 }
 
 static int lpfc_link_speed = 0;
-module_param(lpfc_link_speed, int, 0);
+module_param(lpfc_link_speed, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_link_speed, "Select link speed");
 lpfc_param_show(link_speed)
 
@@ -3062,7 +3085,7 @@ lpfc_aer_support_store(struct device *de
 }
 
 static int lpfc_aer_support = 1;
-module_param(lpfc_aer_support, int, 1);
+module_param(lpfc_aer_support, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_aer_support, "Enable PCIe device AER support");
 lpfc_param_show(aer_support)
 
@@ -3174,7 +3197,7 @@ LPFC_VPORT_ATTR_RW(use_adisc, 0, 0, 1,
 # The value is set in milliseconds.
 */
 static int lpfc_max_scsicmpl_time;
-module_param(lpfc_max_scsicmpl_time, int, 0);
+module_param(lpfc_max_scsicmpl_time, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_max_scsicmpl_time,
 	"Use command completion time to control queue depth");
 lpfc_vport_param_show(max_scsicmpl_time);
@@ -3350,7 +3373,7 @@ LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable 
 */
 unsigned int lpfc_prot_mask = SHOST_DIF_TYPE1_PROTECTION;
 
-module_param(lpfc_prot_mask, uint, 0);
+module_param(lpfc_prot_mask, uint, S_IRUGO);
 MODULE_PARM_DESC(lpfc_prot_mask, "host protection mask");
 
 /*
@@ -3362,7 +3385,7 @@ MODULE_PARM_DESC(lpfc_prot_mask, "host p
 #
 */
 unsigned char lpfc_prot_guard = SHOST_DIX_GUARD_IP;
-module_param(lpfc_prot_guard, byte, 0);
+module_param(lpfc_prot_guard, byte, S_IRUGO);
 MODULE_PARM_DESC(lpfc_prot_guard, "host protection guard type");
 
 /*
@@ -3380,7 +3403,7 @@ MODULE_PARM_DESC(lpfc_prot_guard, "host 
  * Default value is 0.
  */
 int lpfc_delay_discovery;
-module_param(lpfc_delay_discovery, int, 0);
+module_param(lpfc_delay_discovery, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_delay_discovery,
 	"Delay NPort discovery when Clean Address bit is cleared. "
 	"Allowed values: 0,1.");
@@ -3475,6 +3498,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_txcmplq_hw,
 	&dev_attr_lpfc_fips_level,
 	&dev_attr_lpfc_fips_rev,
+	&dev_attr_lpfc_dss,
 	NULL,
 };
 
@@ -4677,6 +4701,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_aer_support_init(phba, lpfc_aer_support);
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
+	phba->cfg_enable_dss = 1;
 	return;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2011-02-16 11:33:35.000000000 -0500
@@ -82,23 +82,23 @@
  *                               the HBA. X MUST also be a power of 2.
  */
 static int lpfc_debugfs_enable = 1;
-module_param(lpfc_debugfs_enable, int, 0);
+module_param(lpfc_debugfs_enable, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_debugfs_enable, "Enable debugfs services");
 
 /* This MUST be a power of 2 */
 static int lpfc_debugfs_max_disc_trc;
-module_param(lpfc_debugfs_max_disc_trc, int, 0);
+module_param(lpfc_debugfs_max_disc_trc, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_debugfs_max_disc_trc,
 	"Set debugfs discovery trace depth");
 
 /* This MUST be a power of 2 */
 static int lpfc_debugfs_max_slow_ring_trc;
-module_param(lpfc_debugfs_max_slow_ring_trc, int, 0);
+module_param(lpfc_debugfs_max_slow_ring_trc, int, S_IRUGO0);
 MODULE_PARM_DESC(lpfc_debugfs_max_slow_ring_trc,
 	"Set debugfs slow ring trace depth");
 
 static int lpfc_debugfs_mask_disc_trc;
-module_param(lpfc_debugfs_mask_disc_trc, int, 0);
+module_param(lpfc_debugfs_mask_disc_trc, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_debugfs_mask_disc_trc,
 	"Set debugfs discovery trace mask");
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-02-16 11:32:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2011-02-16 11:33:35.000000000 -0500
@@ -662,7 +662,7 @@ struct lpfc_hba {
 #define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
 #define LPFC_DELAY_INIT_LINK              1	/* layered driver hold off */
 #define LPFC_DELAY_INIT_LINK_INDEFINITELY 2	/* wait, manual intervention */
-
+	uint32_t cfg_enable_dss;
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct pci_dev *pcidev;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2011-02-16 11:32:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2011-02-16 11:33:35.000000000 -0500
@@ -3204,7 +3204,10 @@ typedef struct {
 #define IOERR_SLER_RRQ_RJT_ERR        0x4C
 #define IOERR_SLER_RRQ_RETRY_ERR      0x4D
 #define IOERR_SLER_ABTS_ERR           0x4E
-
+#define IOERR_ELXSEC_KEY_UNWRAP_ERROR		0xF0
+#define IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR	0xF1
+#define IOERR_ELXSEC_CRYPTO_ERROR		0xF2
+#define IOERR_ELXSEC_CRYPTO_COMPARE_ERROR	0xF3
 #define IOERR_DRVR_MASK               0x100
 #define IOERR_SLI_DOWN                0x101  /* ulpStatus  - Driver defined */
 #define IOERR_SLI_BRESET              0x102
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-02-16 11:32:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-02-16 11:33:35.000000000 -0500
@@ -460,7 +460,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 	    || ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_16G)
 		&& !(phba->lmt & LMT_16Gb))) {
 		/* Reset link speed to auto */
-		lpfc_printf_log(phba, KERN_WARNING, LOG_LINK_EVENT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 			"1302 Invalid speed for this board: "
 			"Reset link speed to auto: x%x\n",
 			phba->cfg_link_speed);
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2011-02-16 11:23:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2011-02-16 11:33:35.000000000 -0500
@@ -1263,7 +1263,8 @@ lpfc_config_port(struct lpfc_hba *phba, 
 	if (phba->sli_rev == LPFC_SLI_REV3 && phba->vpd.sli3Feat.cerbm) {
 		if (phba->cfg_enable_bg)
 			mb->un.varCfgPort.cbg = 1; /* configure BlockGuard */
-		mb->un.varCfgPort.cdss = 1; /* Configure Security */
+		if (phba->cfg_enable_dss)
+			mb->un.varCfgPort.cdss = 1; /* Configure Security */
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
 		mb->un.varCfgPort.ccrp = 1; /* Command Ring Polling */
 		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count();
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2011-02-16 11:25:15.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-02-16 11:33:35.000000000 -0500
@@ -2508,6 +2508,15 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			break;
 		case IOSTAT_LOCAL_REJECT:
 		case IOSTAT_REMOTE_STOP:
+			if (lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_ERROR ||
+			    lpfc_cmd->result ==
+					IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR ||
+			    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_ERROR ||
+			    lpfc_cmd->result ==
+					IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
+				cmd->result = ScsiResult(DID_NO_CONNECT, 0);
+				break;
+			}
 			if (lpfc_cmd->result == IOERR_INVALID_RPI ||
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
@@ -2515,7 +2524,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 				cmd->result = ScsiResult(DID_REQUEUE, 0);
 				break;
 			}
-
 			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
 			     lpfc_cmd->result == IOERR_TX_DMA_FAILED) &&
 			     pIocbOut->iocb.unsli3.sli3_bg.bgstat) {
@@ -2545,7 +2553,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 						lpfc_cmd->cur_iocbq.sli4_xritag,
 						0, 0);
 			}
-
 		/* else: fall through */
 		default:
 			cmd->result = ScsiResult(DID_ERROR, 0);
@@ -2556,9 +2563,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		    || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
 			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED,
 						 SAM_STAT_BUSY);
-	} else {
+	} else
 		cmd->result = ScsiResult(DID_OK, 0);
-	}
 
 	if (cmd->result || lpfc_cmd->fcp_rsp->rspSnsLen) {
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;


