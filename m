From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 11/22] lpfc 8.1.2: Correct use of the hostdata field in scsi_host
Date: Tue, 28 Feb 2006 19:25:24 -0500
Message-ID: <20060301002524.GA15471@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:45990 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932737AbWCAAZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:27 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210POQX015477
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:24 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210POqD015476
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct use of the hostdata field in scsi_host

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -743,7 +743,7 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 const char *
 lpfc_info(struct Scsi_Host *host)
 {
-	struct lpfc_hba    *phba = (struct lpfc_hba *) host->hostdata[0];
+	struct lpfc_hba    *phba = (struct lpfc_hba *) host->hostdata;
 	int len;
 	static char  lpfcinfobuf[384];
 
@@ -803,7 +803,7 @@ static int
 lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 {
 	struct lpfc_hba *phba =
-		(struct lpfc_hba *) cmnd->device->host->hostdata[0];
+		(struct lpfc_hba *) cmnd->device->host->hostdata;
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
@@ -877,7 +877,7 @@ static int
 lpfc_abort_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
-	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[phba->sli.fcp_ring];
 	struct lpfc_iocbq *iocb;
 	struct lpfc_iocbq *abtsiocb;
@@ -981,7 +981,7 @@ static int
 lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
-	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
 	struct lpfc_scsi_buf *lpfc_cmd;
 	struct lpfc_iocbq *iocbq, *iocbqrsp;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
@@ -1094,7 +1094,7 @@ static int
 lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
-	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
 	struct lpfc_nodelist *ndlp = NULL;
 	int match;
 	int ret = FAILED, i, err_count = 0;
@@ -1195,7 +1195,7 @@ out:
 static int
 lpfc_slave_alloc(struct scsi_device *sdev)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba *)sdev->host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *)sdev->host->hostdata;
 	struct lpfc_scsi_buf *scsi_buf = NULL;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	uint32_t total = 0, i;
@@ -1251,7 +1251,7 @@ lpfc_slave_alloc(struct scsi_device *sde
 static int
 lpfc_slave_configure(struct scsi_device *sdev)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba *) sdev->host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *) sdev->host->hostdata;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
 
 	if (sdev->tagged_supported)
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1553,7 +1553,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list);
 
 	host->transportt = lpfc_transport_template;
-	host->hostdata[0] = (unsigned long)phba;
 	pci_set_drvdata(pdev, host);
 	error = scsi_add_host(host, &pdev->dev);
 	if (error)
@@ -1675,7 +1674,7 @@ static void __devexit
 lpfc_pci_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host   *host = pci_get_drvdata(pdev);
-	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata[0];
+	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata;
 	unsigned long iflag;
 
 	lpfc_free_sysfs_attr(phba);
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -79,7 +79,7 @@ static ssize_t
 lpfc_serialnum_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->SerialNumber);
 }
 
@@ -87,7 +87,7 @@ static ssize_t
 lpfc_modeldesc_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ModelDesc);
 }
 
@@ -95,7 +95,7 @@ static ssize_t
 lpfc_modelname_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ModelName);
 }
 
@@ -103,7 +103,7 @@ static ssize_t
 lpfc_programtype_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ProgramType);
 }
 
@@ -111,7 +111,7 @@ static ssize_t
 lpfc_portnum_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	return snprintf(buf, PAGE_SIZE, "%s\n",phba->Port);
 }
 
@@ -119,7 +119,7 @@ static ssize_t
 lpfc_fwrev_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	char fwrev[32];
 	lpfc_decode_firmware_rev(phba, fwrev, 1);
 	return snprintf(buf, PAGE_SIZE, "%s\n",fwrev);
@@ -130,7 +130,7 @@ lpfc_hdw_show(struct class_device *cdev,
 {
 	char hdw[9];
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	lpfc_vpd_t *vp = &phba->vpd;
 	lpfc_jedec_to_ascii(vp->rev.biuRev, hdw);
 	return snprintf(buf, PAGE_SIZE, "%s\n", hdw);
@@ -139,14 +139,14 @@ static ssize_t
 lpfc_option_rom_version_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	return snprintf(buf, PAGE_SIZE, "%s\n", phba->OptionROMVersion);
 }
 static ssize_t
 lpfc_state_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	int len = 0;
 	switch (phba->hba_state) {
 	case LPFC_INIT_START:
@@ -194,7 +194,7 @@ static ssize_t
 lpfc_num_discovered_ports_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	return snprintf(buf, PAGE_SIZE, "%d\n", phba->fc_map_cnt +
 							phba->fc_unmap_cnt);
 }
@@ -203,7 +203,7 @@ lpfc_num_discovered_ports_show(struct cl
 static int
 lpfc_issue_lip(struct Scsi_Host *host)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba *) host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *) host->hostdata;
 	LPFC_MBOXQ_t *pmboxq;
 	int mbxstatus = MBXERR_ERROR;
 
@@ -235,7 +235,7 @@ static ssize_t
 lpfc_nport_evt_cnt_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	return snprintf(buf, PAGE_SIZE, "%d\n", phba->nport_event_cnt);
 }
 
@@ -243,7 +243,7 @@ static ssize_t
 lpfc_board_online_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 
 	if (phba->fc_flag & FC_OFFLINE_MODE)
 		return snprintf(buf, PAGE_SIZE, "0\n");
@@ -256,7 +256,7 @@ lpfc_board_online_store(struct class_dev
 								size_t count)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	struct completion online_compl;
 	int val=0, status=0;
 
@@ -282,7 +282,7 @@ static ssize_t
 lpfc_poll_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 
 	return snprintf(buf, PAGE_SIZE, "%#x\n", phba->cfg_poll);
 }
@@ -292,7 +292,7 @@ lpfc_poll_store(struct class_device *cde
 		size_t count)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	uint32_t creg_val;
 	uint32_t old_val;
 	int val=0;
@@ -349,7 +349,7 @@ static ssize_t \
 lpfc_##attr##_show(struct class_device *cdev, char *buf) \
 { \
 	struct Scsi_Host *host = class_to_shost(cdev);\
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];\
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;\
 	int val = 0;\
 	val = phba->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%d\n",\
@@ -361,7 +361,7 @@ static ssize_t \
 lpfc_##attr##_show(struct class_device *cdev, char *buf) \
 { \
 	struct Scsi_Host *host = class_to_shost(cdev);\
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];\
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;\
 	int val = 0;\
 	val = phba->cfg_##attr;\
 	return snprintf(buf, PAGE_SIZE, "%#x\n",\
@@ -404,7 +404,7 @@ static ssize_t \
 lpfc_##attr##_store(struct class_device *cdev, const char *buf, size_t count) \
 { \
 	struct Scsi_Host *host = class_to_shost(cdev);\
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];\
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;\
 	int val=0;\
 	if (!isdigit(buf[0]))\
 		return -EINVAL;\
@@ -685,7 +685,7 @@ sysfs_ctlreg_write(struct kobject *kobj,
 	size_t buf_off;
 	struct Scsi_Host *host = class_to_shost(container_of(kobj,
 					     struct class_device, kobj));
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 
 	if ((off + count) > FF_REG_AREA_SIZE)
 		return -ERANGE;
@@ -718,7 +718,7 @@ sysfs_ctlreg_read(struct kobject *kobj, 
 	uint32_t * tmp_ptr;
 	struct Scsi_Host *host = class_to_shost(container_of(kobj,
 					     struct class_device, kobj));
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 
 	if (off > FF_REG_AREA_SIZE)
 		return -ERANGE;
@@ -773,7 +773,7 @@ sysfs_mbox_write(struct kobject *kobj, c
 {
 	struct Scsi_Host * host =
 		class_to_shost(container_of(kobj, struct class_device, kobj));
-	struct lpfc_hba * phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba * phba = (struct lpfc_hba*)host->hostdata;
 	struct lpfcMboxq * mbox = NULL;
 
 	if ((count + off) > MAILBOX_CMD_SIZE)
@@ -826,7 +826,7 @@ sysfs_mbox_read(struct kobject *kobj, ch
 	struct Scsi_Host *host =
 		class_to_shost(container_of(kobj, struct class_device,
 					    kobj));
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	int rc;
 
 	if (off > sizeof(MAILBOX_t))
@@ -1001,7 +1001,7 @@ lpfc_free_sysfs_attr(struct lpfc_hba *ph
 static void
 lpfc_get_host_port_id(struct Scsi_Host *shost)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata;
 	/* note: fc_myDID already in cpu endianness */
 	fc_host_port_id(shost) = phba->fc_myDID;
 }
@@ -1009,7 +1009,7 @@ lpfc_get_host_port_id(struct Scsi_Host *
 static void
 lpfc_get_host_port_type(struct Scsi_Host *shost)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata;
 
 	spin_lock_irq(shost->host_lock);
 
@@ -1034,7 +1034,7 @@ lpfc_get_host_port_type(struct Scsi_Host
 static void
 lpfc_get_host_port_state(struct Scsi_Host *shost)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata;
 
 	spin_lock_irq(shost->host_lock);
 
@@ -1075,7 +1075,7 @@ lpfc_get_host_port_state(struct Scsi_Hos
 static void
 lpfc_get_host_speed(struct Scsi_Host *shost)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata;
 
 	spin_lock_irq(shost->host_lock);
 
@@ -1102,7 +1102,7 @@ lpfc_get_host_speed(struct Scsi_Host *sh
 static void
 lpfc_get_host_fabric_name (struct Scsi_Host *shost)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata;
 	u64 node_name;
 
 	spin_lock_irq(shost->host_lock);
@@ -1124,7 +1124,7 @@ lpfc_get_host_fabric_name (struct Scsi_H
 static struct fc_host_statistics *
 lpfc_get_stats(struct Scsi_Host *shost)
 {
-	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
 	struct lpfc_sli *psli = &phba->sli;
 	struct fc_host_statistics *hs = &phba->link_stats;
 	LPFC_MBOXQ_t *pmboxq;
@@ -1214,7 +1214,7 @@ static void
 lpfc_get_starget_port_id(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata;
 	uint32_t did = -1;
 	struct lpfc_nodelist *ndlp = NULL;
 
@@ -1235,7 +1235,7 @@ static void
 lpfc_get_starget_node_name(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata;
 	u64 node_name = 0;
 	struct lpfc_nodelist *ndlp = NULL;
 
@@ -1256,7 +1256,7 @@ static void
 lpfc_get_starget_port_name(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata[0];
+	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata;
 	u64 port_name = 0;
 	struct lpfc_nodelist *ndlp = NULL;
 
