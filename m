From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/17] lpfc 8.3.2 : Addition of SLI4 Interface - Base
	Support - Part 4 of 6
Date: Fri, 22 May 2009 14:52:08 -0400
Message-ID: <1243018328.7729.51.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42030 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZEVSwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:52:11 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIqCwL029754
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:52:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - Base Support - Part 4 of 6

Adds new hardware and interface definitions.

Adds new interface routines - utilizing the reorganized layout of the
driver. Adds SLI-4 specific functions for attachment, initialization,
teardown, etc.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c | 1466 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 1302 insertions(+), 164 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:14:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:16:55.000000000 -0400
@@ -34,8 +34,10 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
@@ -51,9 +53,23 @@ char *_dump_buf_dif;
 unsigned long _dump_buf_dif_order;
 spinlock_t _dump_buf_lock;
 
-static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
+static int lpfc_sli4_queue_create(struct lpfc_hba *);
+static void lpfc_sli4_queue_destroy(struct lpfc_hba *);
+static int lpfc_create_bootstrap_mbox(struct lpfc_hba *);
+static int lpfc_setup_endian_order(struct lpfc_hba *);
+static int lpfc_sli4_read_config(struct lpfc_hba *);
+static void lpfc_destroy_bootstrap_mbox(struct lpfc_hba *);
+static void lpfc_free_sgl_list(struct lpfc_hba *);
+static int lpfc_init_sgl_list(struct lpfc_hba *);
+static int lpfc_init_active_sgl_array(struct lpfc_hba *);
+static void lpfc_free_active_sgl(struct lpfc_hba *);
+static int lpfc_hba_down_post_s3(struct lpfc_hba *phba);
+static int lpfc_hba_down_post_s4(struct lpfc_hba *phba);
+static int lpfc_sli4_cq_event_pool_create(struct lpfc_hba *);
+static void lpfc_sli4_cq_event_pool_destroy(struct lpfc_hba *);
+static void lpfc_sli4_cq_event_release_all(struct lpfc_hba *);
 
 static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
@@ -646,6 +662,77 @@ lpfc_hba_down_post_s3(struct lpfc_hba *p
 
 	return 0;
 }
+/**
+ * lpfc_hba_down_post_s4 - Perform lpfc uninitialization after HBA reset
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine will do uninitialization after the HBA is reset when bring
+ * down the SLI Layer.
+ *
+ * Return codes
+ *   0 - sucess.
+ *   Any other value - error.
+ **/
+static int
+lpfc_hba_down_post_s4(struct lpfc_hba *phba)
+{
+	struct lpfc_scsi_buf *psb, *psb_next;
+	LIST_HEAD(aborts);
+	int ret;
+	unsigned long iflag = 0;
+	ret = lpfc_hba_down_post_s3(phba);
+	if (ret)
+		return ret;
+	/* At this point in time the HBA is either reset or DOA. Either
+	 * way, nothing should be on lpfc_abts_els_sgl_list, it needs to be
+	 * on the lpfc_sgl_list so that it can either be freed if the
+	 * driver is unloading or reposted if the driver is restarting
+	 * the port.
+	 */
+	spin_lock_irq(&phba->hbalock);  /* required for lpfc_sgl_list and */
+					/* scsl_buf_list */
+	/* abts_sgl_list_lock required because worker thread uses this
+	 * list.
+	 */
+	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	list_splice_init(&phba->sli4_hba.lpfc_abts_els_sgl_list,
+			&phba->sli4_hba.lpfc_sgl_list);
+	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+	/* abts_scsi_buf_list_lock required because worker thread uses this
+	 * list.
+	 */
+	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	list_splice_init(&phba->sli4_hba.lpfc_abts_scsi_buf_list,
+			&aborts);
+	spin_unlock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	spin_unlock_irq(&phba->hbalock);
+
+	list_for_each_entry_safe(psb, psb_next, &aborts, list) {
+		psb->pCmd = NULL;
+		psb->status = IOSTAT_SUCCESS;
+	}
+	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
+	list_splice(&aborts, &phba->lpfc_scsi_buf_list);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
+	return 0;
+}
+
+/**
+ * lpfc_hba_down_post - Wrapper func for hba down post routine
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine wraps the actual SLI3 or SLI4 routine for performing
+ * uninitialization after the HBA is reset when bring down the SLI Layer.
+ *
+ * Return codes
+ *   0 - sucess.
+ *   Any other value - error.
+ **/
+int
+lpfc_hba_down_post(struct lpfc_hba *phba)
+{
+	return (*phba->lpfc_hba_down_post)(phba);
+}
 
 /**
  * lpfc_hb_timeout - The HBA-timer timeout handler
@@ -853,6 +940,25 @@ lpfc_offline_eratt(struct lpfc_hba *phba
 }
 
 /**
+ * lpfc_sli4_offline_eratt - Bring lpfc offline on SLI4 hardware error attention
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to bring a SLI4 HBA offline when HBA hardware error
+ * other than Port Error 6 has been detected.
+ **/
+static void
+lpfc_sli4_offline_eratt(struct lpfc_hba *phba)
+{
+	lpfc_offline_prep(phba);
+	lpfc_offline(phba);
+	lpfc_sli4_brdreset(phba);
+	lpfc_hba_down_post(phba);
+	lpfc_sli4_post_status_check(phba);
+	lpfc_unblock_mgmt_io(phba);
+	phba->link_state = LPFC_HBA_ERROR;
+}
+
+/**
  * lpfc_handle_deferred_eratt - The HBA hardware deferred error handler
  * @phba: pointer to lpfc hba data structure.
  *
@@ -1057,6 +1163,65 @@ lpfc_handle_eratt_s3(struct lpfc_hba *ph
 }
 
 /**
+ * lpfc_handle_eratt_s4 - The SLI4 HBA hardware error handler
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to handle the SLI4 HBA hardware error attention
+ * conditions.
+ **/
+static void
+lpfc_handle_eratt_s4(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+	uint32_t event_data;
+	struct Scsi_Host *shost;
+
+	/* If the pci channel is offline, ignore possible errors, since
+	 * we cannot communicate with the pci card anyway.
+	 */
+	if (pci_channel_offline(phba->pcidev))
+		return;
+	/* If resets are disabled then leave the HBA alone and return */
+	if (!phba->cfg_enable_hba_reset)
+		return;
+
+	/* Send an internal error event to mgmt application */
+	lpfc_board_errevt_to_mgmt(phba);
+
+	/* For now, the actual action for SLI4 device handling is not
+	 * specified yet, just treated it as adaptor hardware failure
+	 */
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"0143 SLI4 Adapter Hardware Error Data: x%x x%x\n",
+			phba->work_status[0], phba->work_status[1]);
+
+	event_data = FC_REG_DUMP_EVENT;
+	shost = lpfc_shost_from_vport(vport);
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+				  sizeof(event_data), (char *) &event_data,
+				  SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+
+	lpfc_sli4_offline_eratt(phba);
+}
+
+/**
+ * lpfc_handle_eratt - Wrapper func for handling hba error attention
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine wraps the actual SLI3 or SLI4 hba error attention handling
+ * routine from the API jump table function pointer from the lpfc_hba struct.
+ *
+ * Return codes
+ *   0 - sucess.
+ *   Any other value - error.
+ **/
+void
+lpfc_handle_eratt(struct lpfc_hba *phba)
+{
+	(*phba->lpfc_handle_eratt)(phba);
+}
+
+/**
  * lpfc_handle_latt - The HBA link event handler
  * @phba: pointer to lpfc hba data structure.
  *
@@ -1312,6 +1477,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	uint16_t dev_id = phba->pcidev->device;
 	int max_speed;
 	int GE = 0;
+	int oneConnect = 0; /* default is not a oneConnect */
 	struct {
 		char * name;
 		int    max_speed;
@@ -1457,6 +1623,14 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	case PCI_DEVICE_ID_PROTEUS_S:
 		m = (typeof(m)) {"LPemv12002-S", max_speed, "PCIe IOV"};
 		break;
+	case PCI_DEVICE_ID_TIGERSHARK:
+		oneConnect = 1;
+		m = (typeof(m)) {"OCe10100-F", max_speed, "PCIe"};
+		break;
+	case PCI_DEVICE_ID_TIGERSHARK_S:
+		oneConnect = 1;
+		m = (typeof(m)) {"OCe10100-F-S", max_speed, "PCIe"};
+		break;
 	default:
 		m = (typeof(m)){ NULL };
 		break;
@@ -1464,13 +1638,24 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 
 	if (mdp && mdp[0] == '\0')
 		snprintf(mdp, 79,"%s", m.name);
-	if (descp && descp[0] == '\0')
-		snprintf(descp, 255,
-			"Emulex %s %d%s %s %s",
-			m.name, m.max_speed,
-			(GE) ? "GE" : "Gb",
-			m.bus,
-			(GE) ? "FCoE Adapter" : "Fibre Channel Adapter");
+	/* oneConnect hba requires special processing, they are all initiators
+	 * and we put the port number on the end
+	 */
+	if (descp && descp[0] == '\0') {
+		if (oneConnect)
+			snprintf(descp, 255,
+				"Emulex OneConnect %s, FCoE Initiator, Port %s",
+				m.name,
+				phba->Port);
+		else
+			snprintf(descp, 255,
+				"Emulex %s %d%s %s %s",
+				m.name, m.max_speed,
+				(GE) ? "GE" : "Gb",
+				m.bus,
+				(GE) ? "FCoE Adapter" :
+					"Fibre Channel Adapter");
+	}
 }
 
 /**
@@ -1911,14 +2096,21 @@ lpfc_online(struct lpfc_hba *phba)
 		return 1;
 	}
 
-	if (lpfc_sli_hba_setup(phba)) {	/* Initialize the HBA */
-		lpfc_unblock_mgmt_io(phba);
-		return 1;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		if (lpfc_sli4_hba_setup(phba)) { /* Initialize SLI4 HBA */
+			lpfc_unblock_mgmt_io(phba);
+			return 1;
+		}
+	} else {
+		if (lpfc_sli_hba_setup(phba)) {	/* Initialize SLI2/SLI3 HBA */
+			lpfc_unblock_mgmt_io(phba);
+			return 1;
+		}
 	}
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 			shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(shost->host_lock);
@@ -1980,11 +2172,12 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	/* Issue an unreg_login to all nodes on all vports */
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL) {
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 
 			if (vports[i]->load_flag & FC_UNLOADING)
 				continue;
+			vports[i]->vfi_state &= ~LPFC_VFI_REGISTERED;
 			shost =	lpfc_shost_from_vport(vports[i]);
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
@@ -2029,11 +2222,11 @@ lpfc_offline(struct lpfc_hba *phba)
 	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
 		return;
 
-	/* stop all timers associated with this hba */
-	lpfc_stop_phba_timers(phba);
+	/* stop port and all timers associated with this hba */
+	lpfc_stop_port(phba);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++)
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
 			lpfc_stop_vport_timers(vports[i]);
 	lpfc_destroy_vport_work_array(phba, vports);
 	lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
@@ -2046,7 +2239,7 @@ lpfc_offline(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(shost->host_lock);
 			vports[i]->work_port_events = 0;
@@ -2139,6 +2332,10 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	shost->max_lun = vport->cfg_max_luns;
 	shost->this_id = -1;
 	shost->max_cmd_len = 16;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		shost->dma_boundary = LPFC_SLI4_MAX_SEGMENT_SIZE;
+		shost->sg_tablesize = phba->cfg_sg_seg_cnt;
+	}
 
 	/*
 	 * Set initial can_queue value since 0 is no longer supported and
@@ -2156,6 +2353,7 @@ lpfc_create_port(struct lpfc_hba *phba, 
 
 	/* Initialize all internally managed lists. */
 	INIT_LIST_HEAD(&vport->fc_nodes);
+	INIT_LIST_HEAD(&vport->rcv_buffer_list);
 	spin_lock_init(&vport->work_port_lock);
 
 	init_timer(&vport->fc_disctmo);
@@ -2347,192 +2545,501 @@ void lpfc_host_attrib_init(struct Scsi_H
 }
 
 /**
- * lpfc_enable_msix - Enable MSI-X interrupt mode
+ * lpfc_stop_port_s3 - Stop SLI3 device port
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to enable the MSI-X interrupt vectors. The kernel
- * function pci_enable_msix() is called to enable the MSI-X vectors. Note that
- * pci_enable_msix(), once invoked, enables either all or nothing, depending
- * on the current availability of PCI vector resources. The device driver is
- * responsible for calling the individual request_irq() to register each MSI-X
- * vector with a interrupt handler, which is done in this function. Note that
- * later when device is unloading, the driver should always call free_irq()
- * on all MSI-X vectors it has done request_irq() on before calling
- * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
- * will be left with MSI-X enabled and leaks its vectors.
- *
- * Return codes
- *   0 - sucessful
- *   other values - error
+ * This routine is invoked to stop an SLI3 device port, it stops the device
+ * from generating interrupts and stops the device driver's timers for the
+ * device.
  **/
-static int
-lpfc_enable_msix(struct lpfc_hba *phba)
+static void
+lpfc_stop_port_s3(struct lpfc_hba *phba)
 {
-	int rc, i;
-	LPFC_MBOXQ_t *pmb;
+	/* Clear all interrupt enable conditions */
+	writel(0, phba->HCregaddr);
+	readl(phba->HCregaddr); /* flush */
+	/* Clear all pending interrupts */
+	writel(0xffffffff, phba->HAregaddr);
+	readl(phba->HAregaddr); /* flush */
 
-	/* Set up MSI-X multi-message vectors */
-	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-		phba->msix_entries[i].entry = i;
+	/* Reset some HBA SLI setup states */
+	lpfc_stop_hba_timers(phba);
+	phba->pport->work_port_events = 0;
+}
 
-	/* Configure MSI-X capability structure */
-	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
-				ARRAY_SIZE(phba->msix_entries));
-	if (rc) {
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0420 PCI enable MSI-X failed (%d)\n", rc);
-		goto msi_fail_out;
-	} else
-		for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0477 MSI-X entry[%d]: vector=x%x "
-					"message=%d\n", i,
-					phba->msix_entries[i].vector,
-					phba->msix_entries[i].entry);
-	/*
-	 * Assign MSI-X vectors to interrupt handlers
-	 */
+/**
+ * lpfc_stop_port_s4 - Stop SLI4 device port
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to stop an SLI4 device port, it stops the device
+ * from generating interrupts and stops the device driver's timers for the
+ * device.
+ **/
+static void
+lpfc_stop_port_s4(struct lpfc_hba *phba)
+{
+	/* Reset some HBA SLI4 setup states */
+	lpfc_stop_hba_timers(phba);
+	phba->pport->work_port_events = 0;
+	phba->sli4_hba.intr_enable = 0;
+	/* Hard clear it for now, shall have more graceful way to wait later */
+	phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+}
 
-	/* vector-0 is associated to slow-path handler */
-	rc = request_irq(phba->msix_entries[0].vector, &lpfc_sp_intr_handler,
-			 IRQF_SHARED, LPFC_SP_DRIVER_HANDLER_NAME, phba);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"0421 MSI-X slow-path request_irq failed "
-				"(%d)\n", rc);
-		goto msi_fail_out;
-	}
+/**
+ * lpfc_stop_port - Wrapper function for stopping hba port
+ * @phba: Pointer to HBA context object.
+ *
+ * This routine wraps the actual SLI3 or SLI4 hba stop port routine from
+ * the API jump table function pointer from the lpfc_hba struct.
+ **/
+void
+lpfc_stop_port(struct lpfc_hba *phba)
+{
+	phba->lpfc_stop_port(phba);
+}
 
-	/* vector-1 is associated to fast-path handler */
-	rc = request_irq(phba->msix_entries[1].vector, &lpfc_fp_intr_handler,
-			 IRQF_SHARED, LPFC_FP_DRIVER_HANDLER_NAME, phba);
+/**
+ * lpfc_sli4_remove_dflt_fcf - Remove the driver default fcf record from the port.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to remove the driver default fcf record from
+ * the port.  This routine currently acts on FCF Index 0.
+ *
+ **/
+void
+lpfc_sli_remove_dflt_fcf(struct lpfc_hba *phba)
+{
+	int rc = 0;
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_mbx_del_fcf_tbl_entry *del_fcf_record;
+	uint32_t mbox_tmo, req_len;
+	uint32_t shdr_status, shdr_add_status;
 
-	if (rc) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"0429 MSI-X fast-path request_irq failed "
-				"(%d)\n", rc);
-		goto irq_fail_out;
+	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2020 Failed to allocate mbox for ADD_FCF cmd\n");
+		return;
 	}
 
+	req_len = sizeof(struct lpfc_mbx_del_fcf_tbl_entry) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr);
+	rc = lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
+			      LPFC_MBOX_OPCODE_FCOE_DELETE_FCF,
+			      req_len, LPFC_SLI4_MBX_EMBED);
 	/*
-	 * Configure HBA MSI-X attention conditions to messages
+	 * In phase 1, there is a single FCF index, 0.  In phase2, the driver
+	 * supports multiple FCF indices.
 	 */
-	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	del_fcf_record = &mboxq->u.mqe.un.del_fcf_entry;
+	bf_set(lpfc_mbx_del_fcf_tbl_count, del_fcf_record, 1);
+	bf_set(lpfc_mbx_del_fcf_tbl_index, del_fcf_record,
+	       phba->fcf.fcf_indx);
 
-	if (!pmb) {
-		rc = -ENOMEM;
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0474 Unable to allocate memory for issuing "
-				"MBOX_CONFIG_MSI command\n");
-		goto mem_fail_out;
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
 	}
-	rc = lpfc_config_msi(phba, pmb);
-	if (rc)
-		goto mbx_fail_out;
-	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
-	if (rc != MBX_SUCCESS) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
-				"0351 Config MSI mailbox command failed, "
-				"mbxCmd x%x, mbxStatus x%x\n",
-				pmb->mb.mbxCommand, pmb->mb.mbxStatus);
-		goto mbx_fail_out;
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr_status = bf_get(lpfc_mbox_hdr_status,
+			     &del_fcf_record->header.cfg_shdr.response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+				 &del_fcf_record->header.cfg_shdr.response);
+	if (shdr_status || shdr_add_status || rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2516 DEL FCF of default FCF Index failed "
+				"mbx status x%x, status x%x add_status x%x\n",
+				rc, shdr_status, shdr_add_status);
 	}
-
-	/* Free memory allocated for mailbox command */
-	mempool_free(pmb, phba->mbox_mem_pool);
-	return rc;
-
-mbx_fail_out:
-	/* Free memory allocated for mailbox command */
-	mempool_free(pmb, phba->mbox_mem_pool);
-
-mem_fail_out:
-	/* free the irq already requested */
-	free_irq(phba->msix_entries[1].vector, phba);
-
-irq_fail_out:
-	/* free the irq already requested */
-	free_irq(phba->msix_entries[0].vector, phba);
-
-msi_fail_out:
-	/* Unconfigure MSI-X capability structure */
-	pci_disable_msix(phba->pcidev);
-	return rc;
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mboxq, phba->mbox_mem_pool);
 }
 
 /**
- * lpfc_disable_msix - Disable MSI-X interrupt mode
+ * lpfc_sli4_parse_latt_fault - Parse sli4 link-attention link fault code
  * @phba: pointer to lpfc hba data structure.
+ * @acqe_link: pointer to the async link completion queue entry.
  *
- * This routine is invoked to release the MSI-X vectors and then disable the
- * MSI-X interrupt mode.
+ * This routine is to parse the SLI4 link-attention link fault code and
+ * translate it into the base driver's read link attention mailbox command
+ * status.
+ *
+ * Return: Link-attention status in terms of base driver's coding.
  **/
-static void
-lpfc_disable_msix(struct lpfc_hba *phba)
+static uint16_t
+lpfc_sli4_parse_latt_fault(struct lpfc_hba *phba,
+			   struct lpfc_acqe_link *acqe_link)
 {
-	int i;
+	uint16_t latt_fault;
 
-	/* Free up MSI-X multi-message vectors */
-	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
-		free_irq(phba->msix_entries[i].vector, phba);
-	/* Disable MSI-X */
-	pci_disable_msix(phba->pcidev);
+	switch (bf_get(lpfc_acqe_link_fault, acqe_link)) {
+	case LPFC_ASYNC_LINK_FAULT_NONE:
+	case LPFC_ASYNC_LINK_FAULT_LOCAL:
+	case LPFC_ASYNC_LINK_FAULT_REMOTE:
+		latt_fault = 0;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0398 Invalid link fault code: x%x\n",
+				bf_get(lpfc_acqe_link_fault, acqe_link));
+		latt_fault = MBXERR_ERROR;
+		break;
+	}
+	return latt_fault;
 }
 
 /**
- * lpfc_enable_msi - Enable MSI interrupt mode
+ * lpfc_sli4_parse_latt_type - Parse sli4 link attention type
  * @phba: pointer to lpfc hba data structure.
+ * @acqe_link: pointer to the async link completion queue entry.
  *
- * This routine is invoked to enable the MSI interrupt mode. The kernel
- * function pci_enable_msi() is called to enable the MSI vector. The
- * device driver is responsible for calling the request_irq() to register
- * MSI vector with a interrupt the handler, which is done in this function.
+ * This routine is to parse the SLI4 link attention type and translate it
+ * into the base driver's link attention type coding.
  *
- * Return codes
- * 	0 - sucessful
- * 	other values - error
- */
-static int
-lpfc_enable_msi(struct lpfc_hba *phba)
+ * Return: Link attention type in terms of base driver's coding.
+ **/
+static uint8_t
+lpfc_sli4_parse_latt_type(struct lpfc_hba *phba,
+			  struct lpfc_acqe_link *acqe_link)
 {
-	int rc;
-
-	rc = pci_enable_msi(phba->pcidev);
-	if (!rc)
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0462 PCI enable MSI mode success.\n");
-	else {
-		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0471 PCI enable MSI mode failed (%d)\n", rc);
-		return rc;
-	}
+	uint8_t att_type;
 
-	rc = request_irq(phba->pcidev->irq, lpfc_intr_handler,
-			 IRQF_SHARED, LPFC_DRIVER_NAME, phba);
-	if (rc) {
-		pci_disable_msi(phba->pcidev);
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"0478 MSI request_irq failed (%d)\n", rc);
+	switch (bf_get(lpfc_acqe_link_status, acqe_link)) {
+	case LPFC_ASYNC_LINK_STATUS_DOWN:
+	case LPFC_ASYNC_LINK_STATUS_LOGICAL_DOWN:
+		att_type = AT_LINK_DOWN;
+		break;
+	case LPFC_ASYNC_LINK_STATUS_UP:
+		/* Ignore physical link up events - wait for logical link up */
+		att_type = AT_RESERVED;
+		break;
+	case LPFC_ASYNC_LINK_STATUS_LOGICAL_UP:
+		att_type = AT_LINK_UP;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0399 Invalid link attention type: x%x\n",
+				bf_get(lpfc_acqe_link_status, acqe_link));
+		att_type = AT_RESERVED;
+		break;
 	}
-	return rc;
+	return att_type;
 }
 
 /**
- * lpfc_disable_msi - Disable MSI interrupt mode
+ * lpfc_sli4_parse_latt_link_speed - Parse sli4 link-attention link speed
  * @phba: pointer to lpfc hba data structure.
+ * @acqe_link: pointer to the async link completion queue entry.
  *
- * This routine is invoked to disable the MSI interrupt mode. The driver
- * calls free_irq() on MSI vector it has done request_irq() on before
- * calling pci_disable_msi(). Failure to do so results in a BUG_ON() and
- * a device will be left with MSI enabled and leaks its vector.
- */
-
-static void
-lpfc_disable_msi(struct lpfc_hba *phba)
+ * This routine is to parse the SLI4 link-attention link speed and translate
+ * it into the base driver's link-attention link speed coding.
+ *
+ * Return: Link-attention link speed in terms of base driver's coding.
+ **/
+static uint8_t
+lpfc_sli4_parse_latt_link_speed(struct lpfc_hba *phba,
+				struct lpfc_acqe_link *acqe_link)
 {
-	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
-	return;
+	uint8_t link_speed;
+
+	switch (bf_get(lpfc_acqe_link_speed, acqe_link)) {
+	case LPFC_ASYNC_LINK_SPEED_ZERO:
+		link_speed = LA_UNKNW_LINK;
+		break;
+	case LPFC_ASYNC_LINK_SPEED_10MBPS:
+		link_speed = LA_UNKNW_LINK;
+		break;
+	case LPFC_ASYNC_LINK_SPEED_100MBPS:
+		link_speed = LA_UNKNW_LINK;
+		break;
+	case LPFC_ASYNC_LINK_SPEED_1GBPS:
+		link_speed = LA_1GHZ_LINK;
+		break;
+	case LPFC_ASYNC_LINK_SPEED_10GBPS:
+		link_speed = LA_10GHZ_LINK;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0483 Invalid link-attention link speed: x%x\n",
+				bf_get(lpfc_acqe_link_speed, acqe_link));
+		link_speed = LA_UNKNW_LINK;
+		break;
+	}
+	return link_speed;
+}
+
+/**
+ * lpfc_sli4_async_link_evt - Process the asynchronous link event
+ * @phba: pointer to lpfc hba data structure.
+ * @acqe_link: pointer to the async link completion queue entry.
+ *
+ * This routine is to handle the SLI4 asynchronous link event.
+ **/
+static void
+lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
+			 struct lpfc_acqe_link *acqe_link)
+{
+	struct lpfc_dmabuf *mp;
+	LPFC_MBOXQ_t *pmb;
+	MAILBOX_t *mb;
+	READ_LA_VAR *la;
+	uint8_t att_type;
+
+	att_type = lpfc_sli4_parse_latt_type(phba, acqe_link);
+	if (att_type != AT_LINK_DOWN && att_type != AT_LINK_UP)
+		return;
+	pmb = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0395 The mboxq allocation failed\n");
+		return;
+	}
+	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!mp) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0396 The lpfc_dmabuf allocation failed\n");
+		goto out_free_pmb;
+	}
+	mp->virt = lpfc_mbuf_alloc(phba, 0, &mp->phys);
+	if (!mp->virt) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0397 The mbuf allocation failed\n");
+		goto out_free_dmabuf;
+	}
+
+	/* Cleanup any outstanding ELS commands */
+	lpfc_els_flush_all_cmd(phba);
+
+	/* Block ELS IOCBs until we have done process link event */
+	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
+
+	/* Update link event statistics */
+	phba->sli.slistat.link_event++;
+
+	/* Create pseudo lpfc_handle_latt mailbox command from link ACQE */
+	lpfc_read_la(phba, pmb, mp);
+	pmb->vport = phba->pport;
+
+	/* Parse and translate status field */
+	mb = &pmb->u.mb;
+	mb->mbxStatus = lpfc_sli4_parse_latt_fault(phba, acqe_link);
+
+	/* Parse and translate link attention fields */
+	la = (READ_LA_VAR *) &pmb->u.mb.un.varReadLA;
+	la->eventTag = acqe_link->event_tag;
+	la->attType = att_type;
+	la->UlnkSpeed = lpfc_sli4_parse_latt_link_speed(phba, acqe_link);
+
+	/* Fake the the following irrelvant fields */
+	la->topology = TOPOLOGY_PT_PT;
+	la->granted_AL_PA = 0;
+	la->il = 0;
+	la->pb = 0;
+	la->fa = 0;
+	la->mm = 0;
+
+	/* Keep the link status for extra SLI4 state machine reference */
+	phba->sli4_hba.link_state.speed =
+				bf_get(lpfc_acqe_link_speed, acqe_link);
+	phba->sli4_hba.link_state.duplex =
+				bf_get(lpfc_acqe_link_duplex, acqe_link);
+	phba->sli4_hba.link_state.status =
+				bf_get(lpfc_acqe_link_status, acqe_link);
+	phba->sli4_hba.link_state.physical =
+				bf_get(lpfc_acqe_link_physical, acqe_link);
+	phba->sli4_hba.link_state.fault =
+				bf_get(lpfc_acqe_link_fault, acqe_link);
+
+	/* Invoke the lpfc_handle_latt mailbox command callback function */
+	lpfc_mbx_cmpl_read_la(phba, pmb);
+
+	return;
+
+out_free_dmabuf:
+	kfree(mp);
+out_free_pmb:
+	mempool_free(pmb, phba->mbox_mem_pool);
+}
+
+/**
+ * lpfc_sli4_async_fcoe_evt - Process the asynchronous fcoe event
+ * @phba: pointer to lpfc hba data structure.
+ * @acqe_link: pointer to the async fcoe completion queue entry.
+ *
+ * This routine is to handle the SLI4 asynchronous fcoe event.
+ **/
+static void
+lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
+			 struct lpfc_acqe_fcoe *acqe_fcoe)
+{
+	uint8_t event_type = bf_get(lpfc_acqe_fcoe_event_type, acqe_fcoe);
+	int rc;
+
+	switch (event_type) {
+	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+			"2546 New FCF found index 0x%x tag 0x%x \n",
+			acqe_fcoe->fcf_index,
+			acqe_fcoe->event_tag);
+		/*
+		 * If the current FCF is in discovered state,
+		 * do nothing.
+		 */
+		spin_lock_irq(&phba->hbalock);
+		if (phba->fcf.fcf_flag & FCF_DISCOVERED) {
+			spin_unlock_irq(&phba->hbalock);
+			break;
+		}
+		spin_unlock_irq(&phba->hbalock);
+
+		/* Read the FCF table and re-discover SAN. */
+		rc = lpfc_sli4_read_fcf_record(phba,
+			LPFC_FCOE_FCF_GET_FIRST);
+		if (rc)
+			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"2547 Read FCF record failed 0x%x\n",
+				rc);
+		break;
+
+	case LPFC_FCOE_EVENT_TYPE_FCF_TABLE_FULL:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"2548 FCF Table full count 0x%x tag 0x%x \n",
+			bf_get(lpfc_acqe_fcoe_fcf_count, acqe_fcoe),
+			acqe_fcoe->event_tag);
+		break;
+
+	case LPFC_FCOE_EVENT_TYPE_FCF_DEAD:
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+			"2549 FCF disconnected fron network index 0x%x"
+			" tag 0x%x \n", acqe_fcoe->fcf_index,
+			acqe_fcoe->event_tag);
+		/* If the event is not for currently used fcf do nothing */
+		if (phba->fcf.fcf_indx != acqe_fcoe->fcf_index)
+			break;
+		/*
+		 * Currently, driver support only one FCF - so treat this as
+		 * a link down.
+		 */
+		lpfc_linkdown(phba);
+		/* Unregister FCF if no devices connected to it */
+		lpfc_unregister_unused_fcf(phba);
+		break;
+
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"0288 Unknown FCoE event type 0x%x event tag "
+			"0x%x\n", event_type, acqe_fcoe->event_tag);
+		break;
+	}
+}
+
+/**
+ * lpfc_sli4_async_dcbx_evt - Process the asynchronous dcbx event
+ * @phba: pointer to lpfc hba data structure.
+ * @acqe_link: pointer to the async dcbx completion queue entry.
+ *
+ * This routine is to handle the SLI4 asynchronous dcbx event.
+ **/
+static void
+lpfc_sli4_async_dcbx_evt(struct lpfc_hba *phba,
+			 struct lpfc_acqe_dcbx *acqe_dcbx)
+{
+	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"0290 The SLI4 DCBX asynchronous event is not "
+			"handled yet\n");
+}
+
+/**
+ * lpfc_sli4_async_event_proc - Process all the pending asynchronous event
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked by the worker thread to process all the pending
+ * SLI4 asynchronous events.
+ **/
+void lpfc_sli4_async_event_proc(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event;
+
+	/* First, declare the async event has been handled */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag &= ~ASYNC_EVENT;
+	spin_unlock_irq(&phba->hbalock);
+	/* Now, handle all the async events */
+	while (!list_empty(&phba->sli4_hba.sp_asynce_work_queue)) {
+		/* Get the first event from the head of the event queue */
+		spin_lock_irq(&phba->hbalock);
+		list_remove_head(&phba->sli4_hba.sp_asynce_work_queue,
+				 cq_event, struct lpfc_cq_event, list);
+		spin_unlock_irq(&phba->hbalock);
+		/* Process the asynchronous event */
+		switch (bf_get(lpfc_trailer_code, &cq_event->cqe.mcqe_cmpl)) {
+		case LPFC_TRAILER_CODE_LINK:
+			lpfc_sli4_async_link_evt(phba,
+						 &cq_event->cqe.acqe_link);
+			break;
+		case LPFC_TRAILER_CODE_FCOE:
+			lpfc_sli4_async_fcoe_evt(phba,
+						 &cq_event->cqe.acqe_fcoe);
+			break;
+		case LPFC_TRAILER_CODE_DCBX:
+			lpfc_sli4_async_dcbx_evt(phba,
+						 &cq_event->cqe.acqe_dcbx);
+			break;
+		default:
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"1804 Invalid asynchrous event code: "
+					"x%x\n", bf_get(lpfc_trailer_code,
+					&cq_event->cqe.mcqe_cmpl));
+			break;
+		}
+		/* Free the completion event processed to the free pool */
+		lpfc_sli4_cq_event_release(phba, cq_event);
+	}
+}
+
+/**
+ * lpfc_api_table_setup - Set up per hba pci-device group func api jump table
+ * @phba: pointer to lpfc hba data structure.
+ * @dev_grp: The HBA PCI-Device group number.
+ *
+ * This routine is invoked to set up the per HBA PCI-Device group function
+ * API jump table entries.
+ *
+ * Return: 0 if success, otherwise -ENODEV
+ **/
+int
+lpfc_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
+{
+	int rc;
+
+	/* Set up lpfc PCI-device group */
+	phba->pci_dev_grp = dev_grp;
+
+	/* The LPFC_PCI_DEV_OC uses SLI4 */
+	if (dev_grp == LPFC_PCI_DEV_OC)
+		phba->sli_rev = LPFC_SLI_REV4;
+
+	/* Set up device INIT API function jump table */
+	rc = lpfc_init_api_table_setup(phba, dev_grp);
+	if (rc)
+		return -ENODEV;
+	/* Set up SCSI API function jump table */
+	rc = lpfc_scsi_api_table_setup(phba, dev_grp);
+	if (rc)
+		return -ENODEV;
+	/* Set up SLI API function jump table */
+	rc = lpfc_sli_api_table_setup(phba, dev_grp);
+	if (rc)
+		return -ENODEV;
+	/* Set up MBOX API function jump table */
+	rc = lpfc_mbox_api_table_setup(phba, dev_grp);
+	if (rc)
+		return -ENODEV;
+
+	return 0;
 }
 
 /**
@@ -2764,6 +3271,292 @@ lpfc_sli_driver_resource_unset(struct lp
 }
 
 /**
+ * lpfc_sli4_driver_resource_setup - Setup drvr internal resources for SLI4 dev
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up the driver internal resources specific to
+ * support the SLI-4 HBA device it attached to.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ **/
+static int
+lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli;
+	int rc;
+	int i, hbq_count;
+
+	/* Before proceed, wait for POST done and device ready */
+	rc = lpfc_sli4_post_status_check(phba);
+	if (rc)
+		return -ENODEV;
+
+	/*
+	 * Initialize timers used by driver
+	 */
+
+	/* Heartbeat timer */
+	init_timer(&phba->hb_tmofunc);
+	phba->hb_tmofunc.function = lpfc_hb_timeout;
+	phba->hb_tmofunc.data = (unsigned long)phba;
+
+	psli = &phba->sli;
+	/* MBOX heartbeat timer */
+	init_timer(&psli->mbox_tmo);
+	psli->mbox_tmo.function = lpfc_mbox_timeout;
+	psli->mbox_tmo.data = (unsigned long) phba;
+	/* Fabric block timer */
+	init_timer(&phba->fabric_block_timer);
+	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
+	phba->fabric_block_timer.data = (unsigned long) phba;
+	/* EA polling mode timer */
+	init_timer(&phba->eratt_poll);
+	phba->eratt_poll.function = lpfc_poll_eratt;
+	phba->eratt_poll.data = (unsigned long) phba;
+	/*
+	 * We need to do a READ_CONFIG mailbox command here before
+	 * calling lpfc_get_cfgparam. For VFs this will report the
+	 * MAX_XRI, MAX_VPI, MAX_RPI, MAX_IOCB, and MAX_VFI settings.
+	 * All of the resources allocated
+	 * for this Port are tied to these values.
+	 */
+	/* Get all the module params for configuring this host */
+	lpfc_get_cfgparam(phba);
+	phba->max_vpi = LPFC_MAX_VPI;
+	/* This will be set to correct value after the read_config mbox */
+	phba->max_vports = 0;
+
+	/* Program the default value of vlan_id and fc_map */
+	phba->valid_vlan = 0;
+	phba->fc_map[0] = LPFC_FCOE_FCF_MAP0;
+	phba->fc_map[1] = LPFC_FCOE_FCF_MAP1;
+	phba->fc_map[2] = LPFC_FCOE_FCF_MAP2;
+
+	/*
+	 * Since the sg_tablesize is module parameter, the sg_dma_buf_size
+	 * used to create the sg_dma_buf_pool must be dynamically calculated.
+	 * 2 segments are added since the IOCB needs a command and response bde.
+	 * To insure that the scsi sgl does not cross a 4k page boundary only
+	 * sgl sizes of 1k, 2k, 4k, and 8k are supported.
+	 * Table of sgl sizes and seg_cnt:
+	 * sgl size, 	sg_seg_cnt	total seg
+	 * 1k		50		52
+	 * 2k		114		116
+	 * 4k		242		244
+	 * 8k		498		500
+	 * cmd(32) + rsp(160) + (52 * sizeof(sli4_sge)) = 1024
+	 * cmd(32) + rsp(160) + (116 * sizeof(sli4_sge)) = 2048
+	 * cmd(32) + rsp(160) + (244 * sizeof(sli4_sge)) = 4096
+	 * cmd(32) + rsp(160) + (500 * sizeof(sli4_sge)) = 8192
+	 */
+	if (phba->cfg_sg_seg_cnt <= LPFC_DEFAULT_SG_SEG_CNT)
+		phba->cfg_sg_seg_cnt = 50;
+	else if (phba->cfg_sg_seg_cnt <= 114)
+		phba->cfg_sg_seg_cnt = 114;
+	else if (phba->cfg_sg_seg_cnt <= 242)
+		phba->cfg_sg_seg_cnt = 242;
+	else
+		phba->cfg_sg_seg_cnt = 498;
+
+	phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd)
+					+ sizeof(struct fcp_rsp);
+	phba->cfg_sg_dma_buf_size +=
+		((phba->cfg_sg_seg_cnt + 2) * sizeof(struct sli4_sge));
+
+	/* Initialize buffer queue management fields */
+	hbq_count = lpfc_sli_hbq_count();
+	for (i = 0; i < hbq_count; ++i)
+		INIT_LIST_HEAD(&phba->hbqs[i].hbq_buffer_list);
+	INIT_LIST_HEAD(&phba->rb_pend_list);
+	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_sli4_rb_alloc;
+	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_sli4_rb_free;
+
+	/*
+	 * Initialize the SLI Layer to run with lpfc SLI4 HBAs.
+	 */
+	/* Initialize the Abort scsi buffer list used by driver */
+	spin_lock_init(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	/* This abort list used by worker thread */
+	spin_lock_init(&phba->sli4_hba.abts_sgl_list_lock);
+
+	/*
+	 * Initialize dirver internal slow-path work queues
+	 */
+
+	/* Driver internel slow-path CQ Event pool */
+	INIT_LIST_HEAD(&phba->sli4_hba.sp_cqe_event_pool);
+	/* Response IOCB work queue list */
+	INIT_LIST_HEAD(&phba->sli4_hba.sp_rspiocb_work_queue);
+	/* Asynchronous event CQ Event work queue list */
+	INIT_LIST_HEAD(&phba->sli4_hba.sp_asynce_work_queue);
+	/* Fast-path XRI aborted CQ Event work queue list */
+	INIT_LIST_HEAD(&phba->sli4_hba.sp_fcp_xri_aborted_work_queue);
+	/* Slow-path XRI aborted CQ Event work queue list */
+	INIT_LIST_HEAD(&phba->sli4_hba.sp_els_xri_aborted_work_queue);
+	/* Receive queue CQ Event work queue list */
+	INIT_LIST_HEAD(&phba->sli4_hba.sp_unsol_work_queue);
+
+	/* Initialize the driver internal SLI layer lists. */
+	lpfc_sli_setup(phba);
+	lpfc_sli_queue_setup(phba);
+
+	/* Allocate device driver memory */
+	rc = lpfc_mem_alloc(phba, SGL_ALIGN_SZ);
+	if (rc)
+		return -ENOMEM;
+
+	/* Create the bootstrap mailbox command */
+	rc = lpfc_create_bootstrap_mbox(phba);
+	if (unlikely(rc))
+		goto out_free_mem;
+
+	/* Set up the host's endian order with the device. */
+	rc = lpfc_setup_endian_order(phba);
+	if (unlikely(rc))
+		goto out_free_bsmbx;
+
+	/* Set up the hba's configuration parameters. */
+	rc = lpfc_sli4_read_config(phba);
+	if (unlikely(rc))
+		goto out_free_bsmbx;
+
+	/* Perform a function reset */
+	rc = lpfc_pci_function_reset(phba);
+	if (unlikely(rc))
+		goto out_free_bsmbx;
+
+	/* Create all the SLI4 queues */
+	rc = lpfc_sli4_queue_create(phba);
+	if (rc)
+		goto out_free_bsmbx;
+
+	/* Create driver internal CQE event pool */
+	rc = lpfc_sli4_cq_event_pool_create(phba);
+	if (rc)
+		goto out_destroy_queue;
+
+	/* Initialize and populate the iocb list per host */
+	rc = lpfc_init_sgl_list(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1400 Failed to initialize sgl list.\n");
+		goto out_destroy_cq_event_pool;
+	}
+	rc = lpfc_init_active_sgl_array(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1430 Failed to initialize sgl list.\n");
+		goto out_free_sgl_list;
+	}
+
+	rc = lpfc_sli4_init_rpi_hdrs(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1432 Failed to initialize rpi headers.\n");
+		goto out_free_active_sgl;
+	}
+
+	phba->sli4_hba.fcp_eq_hdl = kzalloc((sizeof(struct lpfc_fcp_eq_hdl) *
+				    phba->cfg_fcp_eq_count), GFP_KERNEL);
+	if (!phba->sli4_hba.fcp_eq_hdl) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2572 Failed allocate memory for fast-path "
+				"per-EQ handle array\n");
+		goto out_remove_rpi_hdrs;
+	}
+
+	phba->sli4_hba.msix_entries = kzalloc((sizeof(struct msix_entry) *
+				      phba->sli4_hba.cfg_eqn), GFP_KERNEL);
+	if (!phba->sli4_hba.msix_entries) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2573 Failed allocate memory for msi-x "
+				"interrupt vector entries\n");
+		goto out_free_fcp_eq_hdl;
+	}
+
+	return rc;
+
+out_free_fcp_eq_hdl:
+	kfree(phba->sli4_hba.fcp_eq_hdl);
+out_remove_rpi_hdrs:
+	lpfc_sli4_remove_rpi_hdrs(phba);
+out_free_active_sgl:
+	lpfc_free_active_sgl(phba);
+out_free_sgl_list:
+	lpfc_free_sgl_list(phba);
+out_destroy_cq_event_pool:
+	lpfc_sli4_cq_event_pool_destroy(phba);
+out_destroy_queue:
+	lpfc_sli4_queue_destroy(phba);
+out_free_bsmbx:
+	lpfc_destroy_bootstrap_mbox(phba);
+out_free_mem:
+	lpfc_mem_free(phba);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_driver_resource_unset - Unset drvr internal resources for SLI4 dev
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset the driver internal resources set up
+ * specific for supporting the SLI-4 HBA device it attached to.
+ **/
+static void
+lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
+{
+	struct lpfc_fcf_conn_entry *conn_entry, *next_conn_entry;
+
+	/* unregister default FCFI from the HBA */
+	lpfc_sli4_fcfi_unreg(phba, phba->fcf.fcfi);
+
+	/* Free the default FCR table */
+	lpfc_sli_remove_dflt_fcf(phba);
+
+	/* Free memory allocated for msi-x interrupt vector entries */
+	kfree(phba->sli4_hba.msix_entries);
+
+	/* Free memory allocated for fast-path work queue handles */
+	kfree(phba->sli4_hba.fcp_eq_hdl);
+
+	/* Free the allocated rpi headers. */
+	lpfc_sli4_remove_rpi_hdrs(phba);
+
+	/* Free the ELS sgl list */
+	lpfc_free_active_sgl(phba);
+	lpfc_free_sgl_list(phba);
+
+	/* Free the SCSI sgl management array */
+	kfree(phba->sli4_hba.lpfc_scsi_psb_array);
+
+	/* Free the SLI4 queues */
+	lpfc_sli4_queue_destroy(phba);
+
+	/* Free the completion queue EQ event pool */
+	lpfc_sli4_cq_event_release_all(phba);
+	lpfc_sli4_cq_event_pool_destroy(phba);
+
+	/* Reset SLI4 HBA FCoE function */
+	lpfc_pci_function_reset(phba);
+
+	/* Free the bsmbx region. */
+	lpfc_destroy_bootstrap_mbox(phba);
+
+	/* Free the SLI Layer memory with SLI4 HBAs */
+	lpfc_mem_free_all(phba);
+
+	/* Free the current connect table */
+	list_for_each_entry_safe(conn_entry, next_conn_entry,
+		&phba->fcf_conn_rec_list, list)
+		kfree(conn_entry);
+
+	return;
+}
+
+/**
  * lpfc_init_api_table_setup - Set up init api fucntion jump table
  * @phba: The hba struct for which this call is being executed.
  * @dev_grp: The HBA PCI-Device group number.
@@ -2782,6 +3575,11 @@ lpfc_init_api_table_setup(struct lpfc_hb
 		phba->lpfc_handle_eratt = lpfc_handle_eratt_s3;
 		phba->lpfc_stop_port = lpfc_stop_port_s3;
 		break;
+	case LPFC_PCI_DEV_OC:
+		phba->lpfc_hba_down_post = lpfc_hba_down_post_s4;
+		phba->lpfc_handle_eratt = lpfc_handle_eratt_s4;
+		phba->lpfc_stop_port = lpfc_stop_port_s4;
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1431 Invalid HBA PCI-device group: 0x%x\n",
@@ -2956,6 +3754,346 @@ out_free_iocbq:
 }
 
 /**
+ * lpfc_free_sgl_list - Free sgl list.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to free the driver's sgl list and memory.
+ **/
+static void
+lpfc_free_sgl_list(struct lpfc_hba *phba)
+{
+	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
+	LIST_HEAD(sglq_list);
+	int rc = 0;
+
+	spin_lock_irq(&phba->hbalock);
+	list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &sglq_list);
+	spin_unlock_irq(&phba->hbalock);
+
+	list_for_each_entry_safe(sglq_entry, sglq_next,
+				 &sglq_list, list) {
+		list_del(&sglq_entry->list);
+		lpfc_mbuf_free(phba, sglq_entry->virt, sglq_entry->phys);
+		kfree(sglq_entry);
+		phba->sli4_hba.total_sglq_bufs--;
+	}
+	rc = lpfc_sli4_remove_all_sgl_pages(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"2005 Unable to deregister pages from HBA: %x", rc);
+	}
+	kfree(phba->sli4_hba.lpfc_els_sgl_array);
+}
+
+/**
+ * lpfc_init_active_sgl_array - Allocate the buf to track active ELS XRIs.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to allocate the driver's active sgl memory.
+ * This array will hold the sglq_entry's for active IOs.
+ **/
+static int
+lpfc_init_active_sgl_array(struct lpfc_hba *phba)
+{
+	int size;
+	size = sizeof(struct lpfc_sglq *);
+	size *= phba->sli4_hba.max_cfg_param.max_xri;
+
+	phba->sli4_hba.lpfc_sglq_active_list =
+		kzalloc(size, GFP_KERNEL);
+	if (!phba->sli4_hba.lpfc_sglq_active_list)
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * lpfc_free_active_sgl - Free the buf that tracks active ELS XRIs.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to walk through the array of active sglq entries
+ * and free all of the resources.
+ * This is just a place holder for now.
+ **/
+static void
+lpfc_free_active_sgl(struct lpfc_hba *phba)
+{
+	kfree(phba->sli4_hba.lpfc_sglq_active_list);
+}
+
+/**
+ * lpfc_init_sgl_list - Allocate and initialize sgl list.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to allocate and initizlize the driver's sgl
+ * list and set up the sgl xritag tag array accordingly.
+ *
+ * Return codes
+ *	0 - sucessful
+ *	other values - error
+ **/
+static int
+lpfc_init_sgl_list(struct lpfc_hba *phba)
+{
+	struct lpfc_sglq *sglq_entry = NULL;
+	int i;
+	int els_xri_cnt;
+
+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"2400 lpfc_init_sgl_list els %d.\n",
+				els_xri_cnt);
+	/* Initialize and populate the sglq list per host/VF. */
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_sgl_list);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_els_sgl_list);
+
+	/* Sanity check on XRI management */
+	if (phba->sli4_hba.max_cfg_param.max_xri <= els_xri_cnt) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2562 No room left for SCSI XRI allocation: "
+				"max_xri=%d, els_xri=%d\n",
+				phba->sli4_hba.max_cfg_param.max_xri,
+				els_xri_cnt);
+		return -ENOMEM;
+	}
+
+	/* Allocate memory for the ELS XRI management array */
+	phba->sli4_hba.lpfc_els_sgl_array =
+			kzalloc((sizeof(struct lpfc_sglq *) * els_xri_cnt),
+			GFP_KERNEL);
+
+	if (!phba->sli4_hba.lpfc_els_sgl_array) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2401 Failed to allocate memory for ELS "
+				"XRI management array of size %d.\n",
+				els_xri_cnt);
+		return -ENOMEM;
+	}
+
+	/* Keep the SCSI XRI into the XRI management array */
+	phba->sli4_hba.scsi_xri_max =
+			phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
+	phba->sli4_hba.scsi_xri_cnt = 0;
+
+	phba->sli4_hba.lpfc_scsi_psb_array =
+			kzalloc((sizeof(struct lpfc_scsi_buf *) *
+			phba->sli4_hba.scsi_xri_max), GFP_KERNEL);
+
+	if (!phba->sli4_hba.lpfc_scsi_psb_array) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2563 Failed to allocate memory for SCSI "
+				"XRI management array of size %d.\n",
+				phba->sli4_hba.scsi_xri_max);
+		kfree(phba->sli4_hba.lpfc_els_sgl_array);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < els_xri_cnt; i++) {
+		sglq_entry = kzalloc(sizeof(struct lpfc_sglq), GFP_KERNEL);
+		if (sglq_entry == NULL) {
+			printk(KERN_ERR "%s: only allocated %d sgls of "
+				"expected %d count. Unloading driver.\n",
+				__func__, i, els_xri_cnt);
+			goto out_free_mem;
+		}
+
+		sglq_entry->sli4_xritag = lpfc_sli4_next_xritag(phba);
+		if (sglq_entry->sli4_xritag == NO_XRI) {
+			kfree(sglq_entry);
+			printk(KERN_ERR "%s: failed to allocate XRI.\n"
+				"Unloading driver.\n", __func__);
+			goto out_free_mem;
+		}
+		sglq_entry->buff_type = GEN_BUFF_TYPE;
+		sglq_entry->virt = lpfc_mbuf_alloc(phba, 0, &sglq_entry->phys);
+		if (sglq_entry->virt == NULL) {
+			kfree(sglq_entry);
+			printk(KERN_ERR "%s: failed to allocate mbuf.\n"
+				"Unloading driver.\n", __func__);
+			goto out_free_mem;
+		}
+		sglq_entry->sgl = sglq_entry->virt;
+		memset(sglq_entry->sgl, 0, LPFC_BPL_SIZE);
+
+		/* The list order is used by later block SGL registraton */
+		spin_lock_irq(&phba->hbalock);
+		list_add_tail(&sglq_entry->list, &phba->sli4_hba.lpfc_sgl_list);
+		phba->sli4_hba.lpfc_els_sgl_array[i] = sglq_entry;
+		phba->sli4_hba.total_sglq_bufs++;
+		spin_unlock_irq(&phba->hbalock);
+	}
+	return 0;
+
+out_free_mem:
+	kfree(phba->sli4_hba.lpfc_scsi_psb_array);
+	lpfc_free_sgl_list(phba);
+	return -ENOMEM;
+}
+
+/**
+ * lpfc_sli4_init_rpi_hdrs - Post the rpi header memory region to the port
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to post rpi header templates to the
+ * HBA consistent with the SLI-4 interface spec.  This routine
+ * posts a PAGE_SIZE memory region to the port to hold up to
+ * PAGE_SIZE modulo 64 rpi context headers.
+ * No locks are held here because this is an initialization routine
+ * called only from probe or lpfc_online when interrupts are not
+ * enabled and the driver is reinitializing the device.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	ENOMEM - No availble memory
+ *      EIO - The mailbox failed to complete successfully.
+ **/
+int
+lpfc_sli4_init_rpi_hdrs(struct lpfc_hba *phba)
+{
+	int rc = 0;
+	int longs;
+	uint16_t rpi_count;
+	struct lpfc_rpi_hdr *rpi_hdr;
+
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_rpi_hdr_list);
+
+	/*
+	 * Provision an rpi bitmask range for discovery. The total count
+	 * is the difference between max and base + 1.
+	 */
+	rpi_count = phba->sli4_hba.max_cfg_param.rpi_base +
+		    phba->sli4_hba.max_cfg_param.max_rpi - 1;
+
+	longs = ((rpi_count) + BITS_PER_LONG - 1) / BITS_PER_LONG;
+	phba->sli4_hba.rpi_bmask = kzalloc(longs * sizeof(unsigned long),
+					   GFP_KERNEL);
+	if (!phba->sli4_hba.rpi_bmask)
+		return -ENOMEM;
+
+	rpi_hdr = lpfc_sli4_create_rpi_hdr(phba);
+	if (!rpi_hdr) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0391 Error during rpi post operation\n");
+		lpfc_sli4_remove_rpis(phba);
+		rc = -ENODEV;
+	}
+
+	return rc;
+}
+
+/**
+ * lpfc_sli4_create_rpi_hdr - Allocate an rpi header memory region
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to allocate a single 4KB memory region to
+ * support rpis and stores them in the phba.  This single region
+ * provides support for up to 64 rpis.  The region is used globally
+ * by the device.
+ *
+ * Returns:
+ *   A valid rpi hdr on success.
+ *   A NULL pointer on any failure.
+ **/
+struct lpfc_rpi_hdr *
+lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
+{
+	uint16_t rpi_limit, curr_rpi_range;
+	struct lpfc_dmabuf *dmabuf;
+	struct lpfc_rpi_hdr *rpi_hdr;
+
+	rpi_limit = phba->sli4_hba.max_cfg_param.rpi_base +
+		    phba->sli4_hba.max_cfg_param.max_rpi - 1;
+
+	spin_lock_irq(&phba->hbalock);
+	curr_rpi_range = phba->sli4_hba.next_rpi;
+	spin_unlock_irq(&phba->hbalock);
+
+	/*
+	 * The port has a limited number of rpis. The increment here
+	 * is LPFC_RPI_HDR_COUNT - 1 to account for the starting value
+	 * and to allow the full max_rpi range per port.
+	 */
+	if ((curr_rpi_range + (LPFC_RPI_HDR_COUNT - 1)) > rpi_limit)
+		return NULL;
+
+	/*
+	 * First allocate the protocol header region for the port.  The
+	 * port expects a 4KB DMA-mapped memory region that is 4K aligned.
+	 */
+	dmabuf = kzalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!dmabuf)
+		return NULL;
+
+	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
+					  LPFC_HDR_TEMPLATE_SIZE,
+					  &dmabuf->phys,
+					  GFP_KERNEL);
+	if (!dmabuf->virt) {
+		rpi_hdr = NULL;
+		goto err_free_dmabuf;
+	}
+
+	memset(dmabuf->virt, 0, LPFC_HDR_TEMPLATE_SIZE);
+	if (!IS_ALIGNED(dmabuf->phys, LPFC_HDR_TEMPLATE_SIZE)) {
+		rpi_hdr = NULL;
+		goto err_free_coherent;
+	}
+
+	/* Save the rpi header data for cleanup later. */
+	rpi_hdr = kzalloc(sizeof(struct lpfc_rpi_hdr), GFP_KERNEL);
+	if (!rpi_hdr)
+		goto err_free_coherent;
+
+	rpi_hdr->dmabuf = dmabuf;
+	rpi_hdr->len = LPFC_HDR_TEMPLATE_SIZE;
+	rpi_hdr->page_count = 1;
+	spin_lock_irq(&phba->hbalock);
+	rpi_hdr->start_rpi = phba->sli4_hba.next_rpi;
+	list_add_tail(&rpi_hdr->list, &phba->sli4_hba.lpfc_rpi_hdr_list);
+
+	/*
+	 * The next_rpi stores the next module-64 rpi value to post
+	 * in any subsequent rpi memory region postings.
+	 */
+	phba->sli4_hba.next_rpi += LPFC_RPI_HDR_COUNT;
+	spin_unlock_irq(&phba->hbalock);
+	return rpi_hdr;
+
+ err_free_coherent:
+	dma_free_coherent(&phba->pcidev->dev, LPFC_HDR_TEMPLATE_SIZE,
+			  dmabuf->virt, dmabuf->phys);
+ err_free_dmabuf:
+	kfree(dmabuf);
+	return NULL;
+}
+
+/**
+ * lpfc_sli4_remove_rpi_hdrs - Remove all rpi header memory regions
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to remove all memory resources allocated
+ * to support rpis. This routine presumes the caller has released all
+ * rpis consumed by fabric or port logins and is prepared to have
+ * the header pages removed.
+ **/
+void
+lpfc_sli4_remove_rpi_hdrs(struct lpfc_hba *phba)
+{
+	struct lpfc_rpi_hdr *rpi_hdr, *next_rpi_hdr;
+
+	list_for_each_entry_safe(rpi_hdr, next_rpi_hdr,
+				 &phba->sli4_hba.lpfc_rpi_hdr_list, list) {
+		list_del(&rpi_hdr->list);
+		dma_free_coherent(&phba->pcidev->dev, rpi_hdr->len,
+				  rpi_hdr->dmabuf->virt, rpi_hdr->dmabuf->phys);
+		kfree(rpi_hdr->dmabuf);
+		kfree(rpi_hdr);
+	}
+
+	phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.rpi_base;
+	memset(phba->sli4_hba.rpi_bmask, 0, sizeof(*phba->sli4_hba.rpi_bmask));
+}
+
+/**
  * lpfc_hba_alloc - Allocate driver hba data structure for a device.
  * @pdev: pointer to pci device data structure.
  *


