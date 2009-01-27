From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.29-rc2
Date: Tue, 27 Jan 2009 19:40:13 +0000
Message-ID: <1233085213.3231.99.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37792 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbZA0TkQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 14:40:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a large swathe of qla2xxx bug fixes and a few assorted smaller
ones.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (8):
      qla2xxx: Update version number to 8.03.00-k2.
      qla2xxx: Correct regression in DMA-mask setting prior to allocations.
      qla2xxx: Correct regression in EH abort handling.
      qla2xxx: Correct endianness issue during flash manipulation.
      qla2xxx: Modify firmware-load order precedence for ISP81XX parts.
      qla2xxx: Always serialize mailbox command execution.
      qla2xxx: Ensure RISC-interrupt-enabled consistency for IS_NOPOLLING_TYPE()
      qla2xxx: Simplify sector-mask calculation in preparation for larger flash 

Anirban Chakraborty (1):
      qla2xxx: Fix memory leak in error path

Brian King (1):
      ibmvfc: Fix DMA mapping leak on memory allocation failure

Joe Carnuccio (1):
      qla2xxx: Correct descriptions in flash manipulation routines.

Lalit Chandivade (1):
      qla2xxx: Correct MSI-X vector allocation for single queue mode.

Mike Christie (2):
      qla4xxx: do not reuse session when connecting to different target port
      libiscsi: fix iscsi pool leak

Seokmann Ju (1):
      qla2xxx: Add checks for a valid fcport in dev-loss-tmo/terminate_rport_io 

and the diffstat:

 drivers/scsi/ibmvscsi/ibmvfc.c     |    4 ++
 drivers/scsi/libiscsi.c            |    1 
 drivers/scsi/qla2xxx/qla_attr.c    |    6 ++++
 drivers/scsi/qla2xxx/qla_gbl.h     |    1 
 drivers/scsi/qla2xxx/qla_init.c    |   53 ++++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_isr.c     |    5 +++
 drivers/scsi/qla2xxx/qla_mbx.c     |   16 ++++-------
 drivers/scsi/qla2xxx/qla_os.c      |   22 ++++++++-------
 drivers/scsi/qla2xxx/qla_sup.c     |   23 ++++++----------
 drivers/scsi/qla2xxx/qla_version.h |    2 -
 drivers/scsi/qla4xxx/ql4_def.h     |    1 
 drivers/scsi/qla4xxx/ql4_init.c    |   10 +++++-
 12 files changed, 100 insertions(+), 44 deletions(-)

The full diff is below.

James

---

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 91ef669..a1a511b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1322,7 +1322,9 @@ static int ibmvfc_map_sg_data(struct scsi_cmnd *scmd,
 					       &evt->ext_list_token);
 
 		if (!evt->ext_list) {
-			scmd_printk(KERN_ERR, scmd, "Can't allocate memory for scatterlist\n");
+			scsi_dma_unmap(scmd);
+			if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
+				scmd_printk(KERN_ERR, scmd, "Can't allocate memory for scatterlist\n");
 			return -ENOMEM;
 		}
 	}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7225b6e..257c241 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1981,6 +1981,7 @@ void iscsi_pool_free(struct iscsi_pool *q)
 		kfree(q->pool[i]);
 	if (q->pool)
 		kfree(q->pool);
+	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index c7acef5..33a3c13 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1016,6 +1016,9 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct Scsi_Host *host = rport_to_shost(rport);
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 
+	if (!fcport)
+		return;
+
 	qla2x00_abort_fcport_cmds(fcport);
 
 	/*
@@ -1033,6 +1036,9 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 {
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 
+	if (!fcport)
+		return;
+
 	/*
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ba49133..a336b4b 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -34,6 +34,7 @@ extern void qla24xx_update_fw_options(scsi_qla_host_t *);
 extern void qla81xx_update_fw_options(scsi_qla_host_t *);
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
+extern int qla81xx_load_risc(scsi_qla_host_t *, uint32_t *);
 
 extern int qla2x00_loop_resync(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9ad4d09..f6368a1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3562,6 +3562,9 @@ qla24xx_reset_adapter(scsi_qla_host_t *vha)
 	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
 	RD_REG_DWORD(&reg->hccr);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (IS_NOPOLLING_TYPE(ha))
+		ha->isp_ops->enable_intrs(ha);
 }
 
 /* On sparc systems, obtain port and node WWN from firmware
@@ -3847,6 +3850,10 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	uint32_t i;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
+
+	qla_printk(KERN_INFO, ha,
+	    "FW: Loading from flash (%x)...\n", ha->flt_region_fw);
+
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
@@ -4022,8 +4029,8 @@ fail_fw_integrity:
 	return QLA_FUNCTION_FAILED;
 }
 
-int
-qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+static int
+qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int	rval;
 	int	segments, fragment;
@@ -4043,12 +4050,12 @@ qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 		qla_printk(KERN_ERR, ha, "Firmware images can be retrieved "
 		    "from: " QLA_FW_URL ".\n");
 
-		/* Try to load RISC code from flash. */
-		qla_printk(KERN_ERR, ha, "Attempting to load (potentially "
-		    "outdated) firmware from flash.\n");
-		return qla24xx_load_risc_flash(vha, srisc_addr);
+		return QLA_FUNCTION_FAILED;
 	}
 
+	qla_printk(KERN_INFO, ha,
+	    "FW: Loading via request-firmware...\n");
+
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
@@ -4133,6 +4140,40 @@ fail_fw_integrity:
 	return QLA_FUNCTION_FAILED;
 }
 
+int
+qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+{
+	int rval;
+
+	/*
+	 * FW Load priority:
+	 * 1) Firmware via request-firmware interface (.bin file).
+	 * 2) Firmware residing in flash.
+	 */
+	rval = qla24xx_load_risc_blob(vha, srisc_addr);
+	if (rval == QLA_SUCCESS)
+		return rval;
+
+	return qla24xx_load_risc_flash(vha, srisc_addr);
+}
+
+int
+qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+{
+	int rval;
+
+	/*
+	 * FW Load priority:
+	 * 1) Firmware residing in flash.
+	 * 2) Firmware via request-firmware interface (.bin file).
+	 */
+	rval = qla24xx_load_risc_flash(vha, srisc_addr);
+	if (rval == QLA_SUCCESS)
+		return rval;
+
+	return qla24xx_load_risc_blob(vha, srisc_addr);
+}
+
 void
 qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 789fc57..e28ad81 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1868,6 +1868,7 @@ qla24xx_disable_msix(struct qla_hw_data *ha)
 static int
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
+#define MIN_MSIX_COUNT	2
 	int i, ret;
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
@@ -1883,12 +1884,16 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 
 	ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
 	if (ret) {
+		if (ret < MIN_MSIX_COUNT)
+			goto msix_failed;
+
 		qla_printk(KERN_WARNING, ha,
 			"MSI-X: Failed to enable support -- %d/%d\n"
 			" Retry with %d vectors\n", ha->msix_count, ret, ret);
 		ha->msix_count = ret;
 		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
 		if (ret) {
+msix_failed:
 			qla_printk(KERN_WARNING, ha, "MSI-X: Failed to enable"
 				" support, giving up -- %d/%d\n",
 				ha->msix_count, ret);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index db4df45..f94ffbb 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -58,14 +58,11 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	 * seconds. This is to serialize actual issuing of mailbox cmds during
 	 * non ISP abort time.
 	 */
-	if (!abort_active) {
-		if (!wait_for_completion_timeout(&ha->mbx_cmd_comp,
-		    mcp->tov * HZ)) {
-			/* Timeout occurred. Return error. */
-			DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
-			    "Exiting.\n", __func__, base_vha->host_no));
-			return QLA_FUNCTION_TIMEOUT;
-		}
+	if (!wait_for_completion_timeout(&ha->mbx_cmd_comp, mcp->tov * HZ)) {
+		/* Timeout occurred. Return error. */
+		DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
+		    "Exiting.\n", __func__, base_vha->host_no));
+		return QLA_FUNCTION_TIMEOUT;
 	}
 
 	ha->flags.mbox_busy = 1;
@@ -265,8 +262,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	}
 
 	/* Allow next mbx cmd to come in. */
-	if (!abort_active)
-		complete(&ha->mbx_cmd_comp);
+	complete(&ha->mbx_cmd_comp);
 
 	if (rval) {
 		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index cf32653..c11f872 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -65,8 +65,6 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 
 static void qla2x00_free_device(scsi_qla_host_t *);
 
-static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
-
 int ql2xfdmienable=1;
 module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
@@ -800,6 +798,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		if (ha->isp_ops->abort_command(vha, sp, req)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			"mbx failed.\n", __func__, vha->host_no));
+			ret = FAILED;
 		} else {
 			DEBUG3(printk("%s(%ld): abort_command "
 			"mbx success.\n", __func__, vha->host_no));
@@ -1241,9 +1240,8 @@ qla2x00_change_queue_type(struct scsi_device *sdev, int tag_type)
  * supported addressing method.
  */
 static void
-qla2x00_config_dma_addressing(scsi_qla_host_t *vha)
+qla2x00_config_dma_addressing(struct qla_hw_data *ha)
 {
-	struct qla_hw_data *ha = vha->hw;
 	/* Assume a 32bit DMA mask. */
 	ha->flags.enable_64bit_addressing = 0;
 
@@ -1480,7 +1478,7 @@ static struct isp_operations qla81xx_isp_ops = {
 	.reset_adapter		= qla24xx_reset_adapter,
 	.nvram_config		= qla81xx_nvram_config,
 	.update_fw_options	= qla81xx_update_fw_options,
-	.load_risc		= qla24xx_load_risc,
+	.load_risc		= qla81xx_load_risc,
 	.pci_info_str		= qla24xx_pci_info_str,
 	.fw_version_str		= qla24xx_fw_version_str,
 	.intr_handler		= qla24xx_intr_handler,
@@ -1869,6 +1867,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	set_bit(0, (unsigned long *) ha->vp_idx_map);
 
+	qla2x00_config_dma_addressing(ha);
 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
 	if (!ret) {
 		qla_printk(KERN_WARNING, ha,
@@ -1888,13 +1887,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		    "[ERROR] Failed to allocate memory for scsi_host\n");
 
 		ret = -ENOMEM;
+		qla2x00_mem_free(ha);
+		qla2x00_free_que(ha, req, rsp);
 		goto probe_hw_failed;
 	}
 
 	pci_set_drvdata(pdev, base_vha);
 
-	qla2x00_config_dma_addressing(base_vha);
-
 	host = base_vha->host;
 	base_vha->req_ques[0] = req->id;
 	host->can_queue = req->length + 128;
@@ -1917,14 +1916,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
-		goto probe_failed;
-
+		goto probe_init_failed;
 	/* Alloc arrays of request and response ring ptrs */
 	if (!qla2x00_alloc_queues(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		"[ERROR] Failed to allocate memory for queue"
 		" pointers\n");
-		goto probe_failed;
+		goto probe_init_failed;
 	}
 	ha->rsp_q_map[0] = rsp;
 	ha->req_q_map[0] = req;
@@ -1997,6 +1995,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+probe_init_failed:
+	qla2x00_free_que(ha, req, rsp);
+	ha->max_queues = 0;
+
 probe_failed:
 	qla2x00_free_device(base_vha);
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 303f8ee..9c3b694 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -944,9 +944,9 @@ qla24xx_unprotect_flash(struct qla_hw_data *ha)
 	if (!ha->fdt_wrt_disable)
 		return;
 
-	/* Disable flash write-protection. */
+	/* Disable flash write-protection, first clear SR protection bit */
 	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101), 0);
-	/* Some flash parts need an additional zero-write to clear bits.*/
+	/* Then write zero again to clear remaining SR bits.*/
 	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101), 0);
 }
 
@@ -980,12 +980,11 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	int ret;
-	uint32_t liter, miter;
+	uint32_t liter;
 	uint32_t sec_mask, rest_addr;
-	uint32_t fdata, findex;
+	uint32_t fdata;
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
-	uint32_t *s, *d;
 	struct qla_hw_data *ha = vha->hw;
 
 	ret = QLA_SUCCESS;
@@ -1003,17 +1002,15 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	}
 
 	rest_addr = (ha->fdt_block_size >> 2) - 1;
-	sec_mask = (ha->optrom_size >> 2) - (ha->fdt_block_size >> 2);
+	sec_mask = ~rest_addr;
 
 	qla24xx_unprotect_flash(ha);
 
 	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
-
-		findex = faddr;
-		fdata = (findex & sec_mask) << 2;
+		fdata = (faddr & sec_mask) << 2;
 
 		/* Are we at the beginning of a sector? */
-		if ((findex & rest_addr) == 0) {
+		if ((faddr & rest_addr) == 0) {
 			/* Do sector unprotect. */
 			if (ha->fdt_unprotect_sec_cmd)
 				qla24xx_write_flash_dword(ha,
@@ -1024,7 +1021,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 			    (fdata & 0xff00) |((fdata << 16) &
 			    0xff0000) | ((fdata >> 16) & 0xff));
 			if (ret != QLA_SUCCESS) {
-				DEBUG9(qla_printk("Unable to flash sector: "
+				DEBUG9(qla_printk("Unable to erase sector: "
 				    "address=%x.\n", faddr));
 				break;
 			}
@@ -1033,9 +1030,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		/* Go with burst-write. */
 		if (optrom && (liter + OPTROM_BURST_DWORDS) <= dwords) {
 			/* Copy data to DMA'ble buffer. */
-			for (miter = 0, s = optrom, d = dwptr;
-			    miter < OPTROM_BURST_DWORDS; miter++, s++, d++)
-				*s = cpu_to_le32(*d);
+			memcpy(optrom, dwptr, OPTROM_BURST_SIZE);
 
 			ret = qla2x00_load_ram(vha, optrom_dma,
 			    flash_data_addr(ha, faddr),
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 808bab6..cfa4c11 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.00-k1"
+#define QLA2XXX_VERSION      "8.03.00-k2"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index d6be076..b586f27 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -244,6 +244,7 @@ struct ddb_entry {
 	uint8_t ip_addr[ISCSI_IPADDR_SIZE];
 	uint8_t iscsi_name[ISCSI_NAME_SIZE];	/* 72 x48 */
 	uint8_t iscsi_alias[0x20];
+	uint8_t isid[6];
 };
 
 /*
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 109c5f5..af8c323 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -342,8 +342,12 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
 	DEBUG2(printk("scsi%ld: %s: Looking for ddb[%d]\n", ha->host_no,
 		      __func__, fw_ddb_index));
 	list_for_each_entry(ddb_entry, &ha->ddb_list, list) {
-		if (memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsi_name,
-			   ISCSI_NAME_SIZE) == 0) {
+		if ((memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsi_name,
+			   ISCSI_NAME_SIZE) == 0) &&
+			(ddb_entry->tpgt ==
+				le32_to_cpu(fw_ddb_entry->tgt_portal_grp)) &&
+			(memcmp(ddb_entry->isid, fw_ddb_entry->isid,
+				sizeof(ddb_entry->isid)) == 0)) {
 			found++;
 			break;
 		}
@@ -430,6 +434,8 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 
 	ddb_entry->port = le16_to_cpu(fw_ddb_entry->port);
 	ddb_entry->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+	memcpy(ddb_entry->isid, fw_ddb_entry->isid, sizeof(ddb_entry->isid));
+
 	memcpy(&ddb_entry->iscsi_name[0], &fw_ddb_entry->iscsi_name[0],
 	       min(sizeof(ddb_entry->iscsi_name),
 		   sizeof(fw_ddb_entry->iscsi_name)));


