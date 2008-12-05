From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/14] lpfc 8.3.0 :  Fix multiple NPIV issues
Date: Thu, 4 Dec 2008 22:39:13 -0500
Message-ID: <1228448353.19053.43.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45900 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYLEOn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:29 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5EhSMQ004211
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Fix multiple NPIV issues

- Fix lock up on rmmod with vports defined by having
  lpfc_pci_remove_one() invoke fc_vport_terminate() to remove all the
  vports before invoking fc_remove_host() for the physical port

- Fix echotest failure when NPIV is enabled

- Add the vport_disable function to the physical port's transport
  template to make the vport disable attribute visible

- Set the vport state to DISABLE on create if the disable flag is
  true

- Call lpfc_alloc_sysfs_attr() for vports so that statistical data
  collection works on them

- Support setting a vport's symbolic name via sysfs by writing to
  /sys/class/fc_vport/vportX/symbolic_name

- Fix create vport fails when link is down or in loop mode.  Should be
  able to be create vports any time NPIV is enabled

- Fix slow vport deletes when deleting multiple vports at once


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h       |    2 --
 drivers/scsi/lpfc/lpfc_attr.c  |   47 +++++++++++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_ct.c    |   17 ++++++++++++--
 drivers/scsi/lpfc/lpfc_els.c   |    6 ++++-
 drivers/scsi/lpfc/lpfc_init.c  |   13 +++++++++--
 drivers/scsi/lpfc/lpfc_vport.c |   28 +++++++++---------------
 6 files changed, 78 insertions(+), 35 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -354,8 +354,6 @@ struct lpfc_vport {
 	uint8_t load_flag;
 #define FC_LOADING		0x1	/* HBA in process of loading drvr */
 #define FC_UNLOADING		0x2	/* HBA in process of unloading drvr */
-	char  *vname;		        /* Application assigned name */
-
 	/* Vport Config Parameters */
 	uint32_t cfg_scan_down;
 	uint32_t cfg_lun_queue_depth;
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3282,25 +3282,28 @@ lpfc_alloc_sysfs_attr(struct lpfc_vport *vport)
 	int error;
 
 	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
-				      &sysfs_ctlreg_attr);
-	if (error)
+				      &sysfs_drvr_stat_data_attr);
+
+	/* Virtual ports do not need ctrl_reg and mbox */
+	if (error || vport->port_type == LPFC_NPIV_PORT)
 		goto out;
 
 	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
-				      &sysfs_mbox_attr);
+				      &sysfs_ctlreg_attr);
 	if (error)
-		goto out_remove_ctlreg_attr;
+		goto out_remove_stat_attr;
 
 	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
-				      &sysfs_drvr_stat_data_attr);
+				      &sysfs_mbox_attr);
 	if (error)
-		goto out_remove_mbox_attr;
+		goto out_remove_ctlreg_attr;
 
 	return 0;
-out_remove_mbox_attr:
-	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_mbox_attr);
 out_remove_ctlreg_attr:
 	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_ctlreg_attr);
+out_remove_stat_attr:
+	sysfs_remove_bin_file(&shost->shost_dev.kobj,
+			&sysfs_drvr_stat_data_attr);
 out:
 	return error;
 }
@@ -3315,6 +3318,9 @@ lpfc_free_sysfs_attr(struct lpfc_vport *vport)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	sysfs_remove_bin_file(&shost->shost_dev.kobj,
 		&sysfs_drvr_stat_data_attr);
+	/* Virtual ports do not need ctrl_reg and mbox */
+	if (vport->port_type == LPFC_NPIV_PORT)
+		return;
 	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_mbox_attr);
 	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_ctlreg_attr);
 }
@@ -3792,6 +3798,23 @@ lpfc_show_rport_##field (struct device *dev,				\
 	lpfc_rport_show_function(field, format_string, sz, )		\
 static FC_RPORT_ATTR(field, S_IRUGO, lpfc_show_rport_##field, NULL)
 
+/**
+ * lpfc_set_vport_symbolic_name: Set the vport's symbolic name.
+ * @fc_vport: The fc_vport who's symbolic name has been changed.
+ *
+ * Description:
+ * This function is called by the transport after the @fc_vport's symbolic name
+ * has been changed. This function re-registers the symbolic name with the
+ * switch to propogate the change into the fabric if the vport is active.
+ **/
+static void
+lpfc_set_vport_symbolic_name(struct fc_vport *fc_vport)
+{
+	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
+
+	if (vport->port_state == LPFC_VPORT_READY)
+		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
+}
 
 struct fc_function_template lpfc_transport_functions = {
 	/* fixed attributes the driver supports */
@@ -3801,6 +3824,7 @@ struct fc_function_template lpfc_transport_functions = {
 	.show_host_supported_fc4s = 1,
 	.show_host_supported_speeds = 1,
 	.show_host_maxframe_size = 1,
+	.show_host_symbolic_name = 1,
 
 	/* dynamic attributes the driver supports */
 	.get_host_port_id = lpfc_get_host_port_id,
@@ -3850,6 +3874,10 @@ struct fc_function_template lpfc_transport_functions = {
 	.terminate_rport_io = lpfc_terminate_rport_io,
 
 	.dd_fcvport_size = sizeof(struct lpfc_vport *),
+
+	.vport_disable = lpfc_vport_disable,
+
+	.set_vport_symbolic_name = lpfc_set_vport_symbolic_name,
 };
 
 struct fc_function_template lpfc_vport_transport_functions = {
@@ -3860,6 +3888,7 @@ struct fc_function_template lpfc_vport_transport_functions = {
 	.show_host_supported_fc4s = 1,
 	.show_host_supported_speeds = 1,
 	.show_host_maxframe_size = 1,
+	.show_host_symbolic_name = 1,
 
 	/* dynamic attributes the driver supports */
 	.get_host_port_id = lpfc_get_host_port_id,
@@ -3908,6 +3937,8 @@ struct fc_function_template lpfc_vport_transport_functions = {
 	.terminate_rport_io = lpfc_terminate_rport_io,
 
 	.vport_disable = lpfc_vport_disable,
+
+	.set_vport_symbolic_name = lpfc_set_vport_symbolic_name,
 };
 
 /**
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -560,18 +560,25 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		irsp->ulpStatus, irsp->un.ulpWord[4], vport->fc_ns_retry);
 
 	/* Don't bother processing response if vport is being torn down. */
-	if (vport->load_flag & FC_UNLOADING)
+	if (vport->load_flag & FC_UNLOADING) {
+		if (vport->fc_flag & FC_RSCN_MODE)
+			lpfc_els_flush_rscn(vport);
 		goto out;
+	}
 
 	if (lpfc_els_chk_latt(vport)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0216 Link event during NS query\n");
+		if (vport->fc_flag & FC_RSCN_MODE)
+			lpfc_els_flush_rscn(vport);
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		goto out;
 	}
 	if (lpfc_error_lost_link(irsp)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0226 NS query failed due to link event\n");
+		if (vport->fc_flag & FC_RSCN_MODE)
+			lpfc_els_flush_rscn(vport);
 		goto out;
 	}
 	if (irsp->ulpStatus) {
@@ -587,6 +594,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if (rc == 0)
 				goto out;
 		}
+		if (vport->fc_flag & FC_RSCN_MODE)
+			lpfc_els_flush_rscn(vport);
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "0257 GID_FT Query error: 0x%x 0x%x\n",
@@ -1008,8 +1017,10 @@ lpfc_vport_symbolic_port_name(struct lpfc_vport *vport, char *symbol,
 	if (n < size)
 		n += snprintf(symbol + n, size - n, " VPort-%d", vport->vpi);
 
-	if (n < size && vport->vname)
-		n += snprintf(symbol + n, size - n, " VName-%s", vport->vname);
+	if (n < size &&
+	    strlen(vport->fc_vport->symbolic_name))
+		n += snprintf(symbol + n, size - n, " VName-%s",
+			      vport->fc_vport->symbolic_name);
 	return n;
 }
 
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -221,7 +221,11 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 		/* For ELS_REQUEST64_CR, use the VPI by default */
 		icmd->ulpContext = vport->vpi;
 		icmd->ulpCt_h = 0;
-		icmd->ulpCt_l = 1;
+		/* The CT field must be 0=INVALID_RPI for the ECHO cmd */
+		if (elscmd == ELS_CMD_ECHO)
+			icmd->ulpCt_l = 0; /* context = invalid RPI */
+		else
+			icmd->ulpCt_l = 1; /* context = VPI */
 	}
 
 	bpl = (struct ulp_bde64 *) pbuflist->virt;
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2041,8 +2041,6 @@ destroy_port(struct lpfc_vport *vport)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 
-	kfree(vport->vname);
-
 	lpfc_debugfs_terminate(vport);
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
@@ -2716,18 +2714,27 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host  *shost = pci_get_drvdata(pdev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_vport **vports;
 	struct lpfc_hba   *phba = vport->phba;
+	int i;
 	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 
 	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(&phba->hbalock);
 
-	kfree(vport->vname);
 	lpfc_free_sysfs_attr(vport);
 
 	kthread_stop(phba->worker_thread);
 
+	/* Release all the vports against this physical port */
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for (i = 1; i <= phba->max_vpi && vports[i] != NULL; i++)
+			fc_vport_terminate(vports[i]->fc_vport);
+	lpfc_destroy_vport_work_array(phba, vports);
+
+	/* Remove FC host and then SCSI host with the physical port */
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
 	lpfc_cleanup(vport);
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -288,10 +288,8 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	int vpi;
 	int rc = VPORT_ERROR;
 	int status;
-	int size;
 
-	if ((phba->sli_rev < 3) ||
-		!(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)) {
+	if ((phba->sli_rev < 3) || !(phba->cfg_enable_npiv)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
 				"1808 Create VPORT failed: "
 				"NPIV is not enabled: SLImode:%d\n",
@@ -351,20 +349,6 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	memcpy(vport->fc_portname.u.wwn, vport->fc_sparam.portName.u.wwn, 8);
 	memcpy(vport->fc_nodename.u.wwn, vport->fc_sparam.nodeName.u.wwn, 8);
-	size = strnlen(fc_vport->symbolic_name, LPFC_VNAME_LEN);
-	if (size) {
-		vport->vname = kzalloc(size+1, GFP_KERNEL);
-		if (!vport->vname) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
-					 "1814 Create VPORT failed. "
-					 "vname allocation failed.\n");
-			rc = VPORT_ERROR;
-			lpfc_free_vpi(phba, vpi);
-			destroy_port(vport);
-			goto error_out;
-		}
-		memcpy(vport->vname, fc_vport->symbolic_name, size+1);
-	}
 	if (fc_vport->node_name != 0)
 		u64_to_wwn(fc_vport->node_name, vport->fc_nodename.u.wwn);
 	if (fc_vport->port_name != 0)
@@ -394,6 +378,9 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 		goto error_out;
 	}
 
+	/* Create binary sysfs attribute for vport */
+	lpfc_alloc_sysfs_attr(vport);
+
 	*(struct lpfc_vport **)fc_vport->dd_data = vport;
 	vport->fc_vport = fc_vport;
 
@@ -405,6 +392,7 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	}
 
 	if (disable) {
+		lpfc_vport_set_state(vport, FC_VPORT_DISABLED);
 		rc = VPORT_OK;
 		goto out;
 	}
@@ -587,8 +575,12 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(&phba->hbalock);
-	kfree(vport->vname);
+
+	lpfc_free_sysfs_attr(vport);
+
 	lpfc_debugfs_terminate(vport);
+
+	/* Remove FC host and then SCSI host with the vport */
 	fc_remove_host(lpfc_shost_from_vport(vport));
 	scsi_remove_host(lpfc_shost_from_vport(vport));
 


