From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 16/17] lpfc 8.3.2 : Persistent Vport Support
Date: Fri, 22 May 2009 14:53:21 -0400
Message-ID: <1243018401.7729.69.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42287 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbZEVSxX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:53:23 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIrOKZ000014
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:53:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Add support for persistent vport definitions at creation at boot time

Also includes a few misc fixes for:
- conversion to vpi name from vport slang name
- couple of small mailbox references
- some additional discovery mods


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c    |   31 +++++++++
 lpfc_hbadisc.c |  180 ++++++++++++++++++++++++++++++++++++++++++++-------------
 lpfc_init.c    |    1 
 lpfc_mbox.c    |   38 ++++++++++++
 lpfc_scsi.c    |    6 -
 lpfc_vport.c   |   37 ++++++-----
 6 files changed, 236 insertions(+), 57 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 14:11:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 14:12:18.000000000 -0400
@@ -2277,6 +2277,36 @@ lpfc_param_init(topology, 0, 0, 6)
 static DEVICE_ATTR(lpfc_topology, S_IRUGO | S_IWUSR,
 		lpfc_topology_show, lpfc_topology_store);
 
+/**
+ * lpfc_static_vport_show: Read callback function for
+ *   lpfc_static_vport sysfs file.
+ * @dev: Pointer to class device object.
+ * @attr: device attribute structure.
+ * @buf: Data buffer.
+ *
+ * This function is the read call back function for
+ * lpfc_static_vport sysfs file. The lpfc_static_vport
+ * sysfs file report the mageability of the vport.
+ **/
+static ssize_t
+lpfc_static_vport_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	if (vport->vport_flag & STATIC_VPORT)
+		sprintf(buf, "1\n");
+	else
+		sprintf(buf, "0\n");
+
+	return strlen(buf);
+}
+
+/*
+ * Sysfs attribute to control the statistical data collection.
+ */
+static DEVICE_ATTR(lpfc_static_vport, S_IRUGO,
+		   lpfc_static_vport_show, NULL);
 
 /**
  * lpfc_stat_data_ctrl_store - write call back for lpfc_stat_data_ctrl sysfs file
@@ -3051,6 +3081,7 @@ struct device_attribute *lpfc_vport_attr
 	&dev_attr_lpfc_enable_da_id,
 	&dev_attr_lpfc_max_scsicmpl_time,
 	&dev_attr_lpfc_stat_data_ctrl,
+	&dev_attr_lpfc_static_vport,
 	NULL,
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 14:11:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 14:12:18.000000000 -0400
@@ -2079,6 +2079,128 @@ out:
 	return;
 }
 
+/**
+ * lpfc_create_static_vport - Read HBA config region to create static vports.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine issue a DUMP mailbox command for config region 22 to get
+ * the list of static vports to be created. The function create vports
+ * based on the information returned from the HBA.
+ **/
+void
+lpfc_create_static_vport(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *pmb = NULL;
+	MAILBOX_t *mb;
+	struct static_vport_info *vport_info;
+	int rc, i;
+	struct fc_vport_identifiers vport_id;
+	struct fc_vport *new_fc_vport;
+	struct Scsi_Host *shost;
+	struct lpfc_vport *vport;
+	uint16_t offset = 0;
+	uint8_t *vport_buff;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0542 lpfc_create_static_vport failed to"
+				" allocate mailbox memory\n");
+		return;
+	}
+
+	mb = &pmb->u.mb;
+
+	vport_info = kzalloc(sizeof(struct static_vport_info), GFP_KERNEL);
+	if (!vport_info) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0543 lpfc_create_static_vport failed to"
+				" allocate vport_info\n");
+		mempool_free(pmb, phba->mbox_mem_pool);
+		return;
+	}
+
+	vport_buff = (uint8_t *) vport_info;
+	do {
+		lpfc_dump_static_vport(phba, pmb, offset);
+		pmb->vport = phba->pport;
+		rc = lpfc_sli_issue_mbox_wait(phba, pmb, LPFC_MBOX_TMO);
+
+		if ((rc != MBX_SUCCESS) || mb->mbxStatus) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0544 lpfc_create_static_vport failed to"
+				" issue dump mailbox command ret 0x%x "
+				"status 0x%x\n",
+				rc, mb->mbxStatus);
+			goto out;
+		}
+
+		if (mb->un.varDmp.word_cnt >
+			sizeof(struct static_vport_info) - offset)
+			mb->un.varDmp.word_cnt =
+			sizeof(struct static_vport_info) - offset;
+
+		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
+			vport_buff + offset,
+			mb->un.varDmp.word_cnt);
+		offset += mb->un.varDmp.word_cnt;
+
+	} while (mb->un.varDmp.word_cnt &&
+		offset < sizeof(struct static_vport_info));
+
+
+	if ((le32_to_cpu(vport_info->signature) != VPORT_INFO_SIG) ||
+		((le32_to_cpu(vport_info->rev) & VPORT_INFO_REV_MASK)
+			!= VPORT_INFO_REV)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"0545 lpfc_create_static_vport bad"
+			" information header 0x%x 0x%x\n",
+			le32_to_cpu(vport_info->signature),
+			le32_to_cpu(vport_info->rev) & VPORT_INFO_REV_MASK);
+
+		goto out;
+	}
+
+	shost = lpfc_shost_from_vport(phba->pport);
+
+	for (i = 0; i < MAX_STATIC_VPORT_COUNT; i++) {
+		memset(&vport_id, 0, sizeof(vport_id));
+		vport_id.port_name = wwn_to_u64(vport_info->vport_list[i].wwpn);
+		vport_id.node_name = wwn_to_u64(vport_info->vport_list[i].wwnn);
+		if (!vport_id.port_name || !vport_id.node_name)
+			continue;
+
+		vport_id.roles = FC_PORT_ROLE_FCP_INITIATOR;
+		vport_id.vport_type = FC_PORTTYPE_NPIV;
+		vport_id.disable = false;
+		new_fc_vport = fc_vport_create(shost, 0, &vport_id);
+
+		if (!new_fc_vport) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0546 lpfc_create_static_vport failed to"
+				" create vport \n");
+			continue;
+		}
+
+		vport = *(struct lpfc_vport **)new_fc_vport->dd_data;
+		vport->vport_flag |= STATIC_VPORT;
+	}
+
+out:
+	/*
+	 * If this is timed out command, setting NULL to context2 tell SLI
+	 * layer not to use this buffer.
+	 */
+	spin_lock_irq(&phba->hbalock);
+	pmb->context2 = NULL;
+	spin_unlock_irq(&phba->hbalock);
+	kfree(vport_info);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(pmb, phba->mbox_mem_pool);
+
+	return;
+}
+
 /*
  * This routine handles processing a Fabric REG_LOGIN mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
@@ -2089,16 +2211,17 @@ void
 lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 	struct lpfc_nodelist *ndlp;
-	struct lpfc_vport **vports;
-	int i;
 
 	ndlp = (struct lpfc_nodelist *) pmb->context2;
 	pmb->context1 = NULL;
 	pmb->context2 = NULL;
 	if (mb->mbxStatus) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
+				 "0258 Register Fabric login error: 0x%x\n",
+				 mb->mbxStatus);
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
 		mempool_free(pmb, phba->mbox_mem_pool);
@@ -2117,9 +2240,6 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		}
 
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
-				 "0258 Register Fabric login error: 0x%x\n",
-				 mb->mbxStatus);
 		/* Decrement the reference count to ndlp after the reference
 		 * to the ndlp are done.
 		 */
@@ -2128,34 +2248,12 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	}
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
+	ndlp->nlp_flag |= NLP_RPI_VALID;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
-		vports = lpfc_create_vport_work_array(phba);
-		if (vports != NULL)
-			for(i = 0;
-			    i <= phba->max_vpi && vports[i] != NULL;
-			    i++) {
-				if (vports[i]->port_type == LPFC_PHYSICAL_PORT)
-					continue;
-				if (phba->fc_topology == TOPOLOGY_LOOP) {
-					lpfc_vport_set_state(vports[i],
-							FC_VPORT_LINKDOWN);
-					continue;
-				}
-				if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
-					lpfc_initial_fdisc(vports[i]);
-				else {
-					lpfc_vport_set_state(vports[i],
-						FC_VPORT_NO_FABRIC_SUPP);
-					lpfc_printf_vlog(vport, KERN_ERR,
-							 LOG_ELS,
-							"0259 No NPIV "
-							"Fabric support\n");
-				}
-			}
-		lpfc_destroy_vport_work_array(phba, vports);
+		lpfc_start_fdiscs(phba);
 		lpfc_do_scr_ns_plogi(phba, vport);
 	}
 
@@ -2179,13 +2277,16 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 void
 lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
-	MAILBOX_t *mb = &pmb->mb;
+	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
 	struct lpfc_vport *vport = pmb->vport;
 
 	if (mb->mbxStatus) {
 out:
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "0260 Register NameServer error: 0x%x\n",
+				 mb->mbxStatus);
 		/* decrement the node reference count held for this
 		 * callback function.
 		 */
@@ -2209,15 +2310,13 @@ out:
 			return;
 		}
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "0260 Register NameServer error: 0x%x\n",
-				 mb->mbxStatus);
 		return;
 	}
 
 	pmb->context1 = NULL;
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
+	ndlp->nlp_flag |= NLP_RPI_VALID;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
@@ -2718,7 +2817,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phb
 	if (pring->ringno == LPFC_ELS_RING) {
 		switch (icmd->ulpCommand) {
 		case CMD_GEN_REQUEST64_CR:
-			if (icmd->ulpContext == (volatile ushort)ndlp->nlp_rpi)
+			if (iocb->context_un.ndlp == ndlp)
 				return 1;
 		case CMD_ELS_REQUEST64_CR:
 			if (icmd->un.elsreq64.remoteID == ndlp->nlp_DID)
@@ -2765,7 +2864,7 @@ lpfc_no_rpi(struct lpfc_hba *phba, struc
 	 */
 	psli = &phba->sli;
 	rpi = ndlp->nlp_rpi;
-	if (rpi) {
+	if (ndlp->nlp_flag & NLP_RPI_VALID) {
 		/* Now process each ring */
 		for (i = 0; i < psli->num_rings; i++) {
 			pring = &psli->ring[i];
@@ -2813,7 +2912,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 	LPFC_MBOXQ_t    *mbox;
 	int rc;
 
-	if (ndlp->nlp_rpi) {
+	if (ndlp->nlp_flag & NLP_RPI_VALID) {
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (mbox) {
 			lpfc_unreg_login(phba, vport->vpi, ndlp->nlp_rpi, mbox);
@@ -2825,6 +2924,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 		}
 		lpfc_no_rpi(phba, ndlp);
 		ndlp->nlp_rpi = 0;
+		ndlp->nlp_flag &= ~NLP_RPI_VALID;
 		return 1;
 	}
 	return 0;
@@ -2972,13 +3072,14 @@ lpfc_nlp_remove(struct lpfc_vport *vport
 	int rc;
 
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
-	if (ndlp->nlp_flag & NLP_DEFER_RM && !ndlp->nlp_rpi) {
+	if ((ndlp->nlp_flag & NLP_DEFER_RM) &&
+	    !(ndlp->nlp_flag & NLP_RPI_VALID)) {
 		/* For this case we need to cleanup the default rpi
 		 * allocated by the firmware.
 		 */
 		if ((mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))
 			!= NULL) {
-			rc = lpfc_reg_login(phba, vport->vpi, ndlp->nlp_DID,
+			rc = lpfc_reg_rpi(phba, vport->vpi, ndlp->nlp_DID,
 			    (uint8_t *) &vport->fc_sparam, mbox, 0);
 			if (rc) {
 				mempool_free(mbox, phba->mbox_mem_pool);
@@ -3713,6 +3814,7 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 	pmb->context1 = NULL;
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
+	ndlp->nlp_flag |= NLP_RPI_VALID;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 14:11:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 14:12:18.000000000 -0400
@@ -385,6 +385,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 	/* Update the fc_host data structures with new wwn. */
 	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
 	fc_host_port_name(shost) = wwn_to_u64(vport->fc_portname.u.wwn);
+	fc_host_max_npiv_vports(shost) = phba->max_vpi;
 
 	/* If no serial number in VPD data, use low 6 bytes of WWNN */
 	/* This should be consolidated into parse_vpd ? - mr */
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2009-05-22 14:11:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2009-05-22 14:12:18.000000000 -0400
@@ -41,6 +41,44 @@
 #include "lpfc_compat.h"
 
 /**
+ * lpfc_dump_static_vport - Dump HBA's static vport information.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * @offset: offset for dumping vport info.
+ *
+ * The dump mailbox command provides a method for the device driver to obtain
+ * various types of information from the HBA device.
+ *
+ * This routine prepares the mailbox command for dumping list of static
+ * vports to be created.
+ **/
+void
+lpfc_dump_static_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb,
+		uint16_t offset)
+{
+	MAILBOX_t *mb;
+	void *ctx;
+
+	mb = &pmb->u.mb;
+	ctx = pmb->context2;
+
+	/* Setup to dump vport info region */
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+	mb->mbxCommand = MBX_DUMP_MEMORY;
+	mb->un.varDmp.cv = 1;
+	mb->un.varDmp.type = DMP_NV_PARAMS;
+	mb->un.varDmp.entry_index = offset;
+	mb->un.varDmp.region_id = DMP_REGION_VPORT;
+	mb->un.varDmp.word_cnt = DMP_RSP_SIZE/sizeof(uint32_t);
+	mb->un.varDmp.co = 0;
+	mb->un.varDmp.resp_offset = 0;
+	pmb->context2 = ctx;
+	mb->mbxOwner = OWN_HOST;
+
+	return;
+}
+
+/**
  * lpfc_dump_mem - Prepare a mailbox command for retrieving HBA's VPD memory
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-05-22 14:11:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-05-22 14:12:18.000000000 -0400
@@ -329,7 +329,7 @@ lpfc_ramp_down_queue_handler(struct lpfc
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			shost_for_each_device(sdev, shost) {
 				new_queue_depth =
@@ -383,7 +383,7 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			shost_for_each_device(sdev, shost) {
 				if (vports[i]->cfg_lun_queue_depth <=
@@ -431,7 +431,7 @@ lpfc_scsi_dev_block(struct lpfc_hba *phb
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			shost_for_each_device(sdev, shost) {
 				rport = starget_to_rport(scsi_target(sdev));
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2009-05-22 14:11:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2009-05-22 14:12:18.000000000 -0400
@@ -251,23 +251,22 @@ static void lpfc_discovery_wait(struct l
 		    (vport->fc_flag & wait_flags)  ||
 		    ((vport->port_state > LPFC_VPORT_FAILED) &&
 		     (vport->port_state < LPFC_VPORT_READY))) {
-			lpfc_printf_log(phba, KERN_INFO, LOG_VPORT,
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_VPORT,
 					"1833 Vport discovery quiesce Wait:"
-					" vpi x%x state x%x fc_flags x%x"
+					" state x%x fc_flags x%x"
 					" num_nodes x%x, waiting 1000 msecs"
 					" total wait msecs x%x\n",
-					vport->vpi, vport->port_state,
-					vport->fc_flag, vport->num_disc_nodes,
+					vport->port_state, vport->fc_flag,
+					vport->num_disc_nodes,
 					jiffies_to_msecs(jiffies - start_time));
 			msleep(1000);
 		} else {
 			/* Base case.  Wait variants satisfied.  Break out */
-			lpfc_printf_log(phba, KERN_INFO, LOG_VPORT,
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_VPORT,
 					 "1834 Vport discovery quiesced:"
-					 " vpi x%x state x%x fc_flags x%x"
+					 " state x%x fc_flags x%x"
 					 " wait msecs x%x\n",
-					 vport->vpi, vport->port_state,
-					 vport->fc_flag,
+					 vport->port_state, vport->fc_flag,
 					 jiffies_to_msecs(jiffies
 						- start_time));
 			break;
@@ -275,12 +274,10 @@ static void lpfc_discovery_wait(struct l
 	}
 
 	if (time_after(jiffies, wait_time_max))
-		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
 				"1835 Vport discovery quiesce failed:"
-				" vpi x%x state x%x fc_flags x%x"
-				" wait msecs x%x\n",
-				vport->vpi, vport->port_state,
-				vport->fc_flag,
+				" state x%x fc_flags x%x wait msecs x%x\n",
+				vport->port_state, vport->fc_flag,
 				jiffies_to_msecs(jiffies - start_time));
 }
 
@@ -558,6 +555,16 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 				 "physical host\n");
 		return VPORT_ERROR;
 	}
+
+	/* If the vport is a static vport fail the deletion. */
+	if ((vport->vport_flag & STATIC_VPORT) &&
+		!(phba->pport->load_flag & FC_UNLOADING)) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+				 "1837 vport_delete failed: Cannot delete "
+				 "static vport.\n");
+		return VPORT_ERROR;
+	}
+
 	/*
 	 * If we are not unloading the driver then prevent the vport_delete
 	 * from happening until after this vport's discovery is finished.
@@ -733,7 +740,7 @@ lpfc_create_vport_work_array(struct lpfc
 	struct lpfc_vport *port_iterator;
 	struct lpfc_vport **vports;
 	int index = 0;
-	vports = kzalloc((phba->max_vpi + 1) * sizeof(struct lpfc_vport *),
+	vports = kzalloc((phba->max_vports + 1) * sizeof(struct lpfc_vport *),
 			 GFP_KERNEL);
 	if (vports == NULL)
 		return NULL;
@@ -757,7 +764,7 @@ lpfc_destroy_vport_work_array(struct lpf
 	int i;
 	if (vports == NULL)
 		return;
-	for (i=0; vports[i] != NULL && i <= phba->max_vpi; i++)
+	for (i = 0; vports[i] != NULL && i <= phba->max_vports; i++)
 		scsi_host_put(lpfc_shost_from_vport(vports[i]));
 	kfree(vports);
 }


