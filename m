From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/8] lpfc 8.2.2 : Miscellaneous management and logging mods
Date: Tue, 31 Jul 2007 21:28:01 +0000 (UTC)
Message-ID: <1186067421.14374.22.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50152 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762984AbXGaV06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 17:26:58 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l6VLQnim028958
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 14:26:57 -0700 (PDT)
Date: Thu, 02 Aug 2007 11:10:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous management and logging mods:
 - Remove the "management_version" sysfs parameter (was unused)
 - Add HBQ information to lpfc debugfs
 - Change lpfc_npiv_enable name back to lpfc_enable_npiv (internal stds)
 - Remove "issue_lip" attribute from the vports transport template


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 06:55:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 07:12:04.000000000 -0400
@@ -68,12 +68,6 @@ lpfc_drvr_version_show(struct class_devi
 }
 
 static ssize_t
-management_version_show(struct class_device *cdev, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, DFC_API_VERSION "\n");
-}
-
-static ssize_t
 lpfc_info_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -904,8 +898,6 @@ static CLASS_DEVICE_ATTR(num_discovered_
 static CLASS_DEVICE_ATTR(nport_evt_cnt, S_IRUGO, lpfc_nport_evt_cnt_show, NULL);
 static CLASS_DEVICE_ATTR(lpfc_drvr_version, S_IRUGO, lpfc_drvr_version_show,
 			 NULL);
-static CLASS_DEVICE_ATTR(management_version, S_IRUGO, management_version_show,
-			 NULL);
 static CLASS_DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
 			 lpfc_board_mode_show, lpfc_board_mode_store);
 static CLASS_DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
@@ -1110,7 +1102,7 @@ MODULE_PARM_DESC(lpfc_sli_mode, "SLI mod
 		 " 2 - select SLI-2 even on SLI-3 capable HBAs,"
 		 " 3 - select SLI-3");
 
-LPFC_ATTR_R(npiv_enable, 0, 0, 1, "Enable NPIV functionality");
+LPFC_ATTR_R(enable_npiv, 0, 0, 1, "Enable NPIV functionality");
 
 /*
 # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
@@ -1530,9 +1522,8 @@ struct class_device_attribute *lpfc_hba_
 	&class_device_attr_lpfc_multi_ring_type,
 	&class_device_attr_lpfc_fdmi_on,
 	&class_device_attr_lpfc_max_luns,
-	&class_device_attr_lpfc_npiv_enable,
+	&class_device_attr_lpfc_enable_npiv,
 	&class_device_attr_nport_evt_cnt,
-	&class_device_attr_management_version,
 	&class_device_attr_board_mode,
 	&class_device_attr_max_vpi,
 	&class_device_attr_used_vpi,
@@ -1569,7 +1560,6 @@ struct class_device_attribute *lpfc_vpor
 	&class_device_attr_lpfc_fdmi_on,
 	&class_device_attr_lpfc_max_luns,
 	&class_device_attr_nport_evt_cnt,
-	&class_device_attr_management_version,
 	&class_device_attr_npiv_info,
 	NULL,
 };
@@ -2413,7 +2403,6 @@ struct fc_function_template lpfc_vport_t
 	.get_starget_port_name = lpfc_get_starget_port_name,
 	.show_starget_port_name = 1,
 
-	.issue_fc_host_lip = lpfc_issue_lip,
 	.dev_loss_tmo_callbk = lpfc_dev_loss_tmo_callbk,
 	.terminate_rport_io = lpfc_terminate_rport_io,
 
@@ -2432,7 +2421,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_topology_init(phba, lpfc_topology);
 	lpfc_link_speed_init(phba, lpfc_link_speed);
 	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
-	lpfc_npiv_enable_init(phba, lpfc_npiv_enable);
+	lpfc_enable_npiv_init(phba, lpfc_enable_npiv);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
 	phba->cfg_poll = lpfc_poll;
 	phba->cfg_soft_wwnn = 0L;
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 07:08:04.000000000 -0400
@@ -101,14 +101,20 @@ MODULE_PARM_DESC(lpfc_debugfs_mask_disc_
 #define LPFC_NODELIST_SIZE 8192
 #define LPFC_NODELIST_ENTRY_SIZE 120
 
-/* dump_slim output buffer size */
+/* dumpslim output buffer size */
 #define LPFC_DUMPSLIM_SIZE 4096
 
+/* hbqinfo output buffer size */
+#define LPFC_HBQINFO_SIZE 8192
+
 struct lpfc_debug {
 	char *buffer;
 	int  len;
 };
 
+extern struct lpfc_hbq_init *lpfc_hbq_defs[];
+extern int lpfc_sli_hbq_count(void);
+
 atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 unsigned long lpfc_debugfs_start_time = 0L;
 
@@ -196,6 +202,105 @@ lpfc_debugfs_slow_ring_trc_data(struct l
 	return len;
 }
 
+int lpfc_debugfs_last_hbq = -1;
+
+static int
+lpfc_debugfs_hbqinfo_data(struct lpfc_hba *phba, char *buf, int size)
+{
+	int len = 0;
+	int cnt, i, j, found, posted, low;
+	uint32_t phys, raw_index, getidx;
+	struct lpfc_hbq_init *hip;
+	struct hbq_s *hbqs;
+	struct lpfc_hbq_entry *hbqe;
+	struct lpfc_dmabuf *d_buf;
+	struct hbq_dmabuf *hbq_buf;
+
+	cnt = LPFC_HBQINFO_SIZE;
+	spin_lock_irq(&phba->hbalock);
+
+	/* toggle between multiple hbqs, if any */
+	i = lpfc_sli_hbq_count();
+	if (i > 1) {
+		 lpfc_debugfs_last_hbq++;
+		 if (lpfc_debugfs_last_hbq >= i)
+			lpfc_debugfs_last_hbq = 0;
+	}
+	else
+		lpfc_debugfs_last_hbq = 0;
+
+	i = lpfc_debugfs_last_hbq;
+
+	len +=  snprintf(buf+len, size-len, "HBQ %d Info\n", i);
+
+	posted = 0;
+	list_for_each_entry(d_buf, &phba->hbq_buffer_list, list)
+		posted++;
+
+	hip =  lpfc_hbq_defs[i];
+	len +=  snprintf(buf+len, size-len,
+		"idx:%d prof:%d rn:%d bufcnt:%d icnt:%d acnt:%d posted %d\n",
+		hip->hbq_index, hip->profile, hip->rn,
+		hip->buffer_count, hip->init_count, hip->add_count, posted);
+
+	hbqs =  &phba->hbqs[i];
+	raw_index = phba->hbq_get[i];
+	getidx = le32_to_cpu(raw_index);
+	len +=  snprintf(buf+len, size-len,
+		"entrys:%d Put:%d nPut:%d localGet:%d hbaGet:%d\n",
+		hbqs->entry_count, hbqs->hbqPutIdx, hbqs->next_hbqPutIdx,
+		hbqs->local_hbqGetIdx, getidx);
+
+	hbqe = (struct lpfc_hbq_entry *) phba->hbqslimp.virt;
+	for (j=0; j<hbqs->entry_count; j++) {
+		len +=  snprintf(buf+len, size-len,
+			"%03d: %08x %04x %05x ", j,
+			hbqe->bde.addrLow, hbqe->bde.tus.w, hbqe->buffer_tag);
+
+		i = 0;
+		found = 0;
+
+		/* First calculate if slot has an associated posted buffer */
+		low = hbqs->hbqPutIdx - posted;
+		if (low >= 0) {
+			if ((j >= hbqs->hbqPutIdx) || (j < low)) {
+				len +=  snprintf(buf+len, size-len, "Unused\n");
+				goto skipit;
+			}
+		}
+		else {
+			if ((j >= hbqs->hbqPutIdx) &&
+				(j < (hbqs->entry_count+low))) {
+				len +=  snprintf(buf+len, size-len, "Unused\n");
+				goto skipit;
+			}
+		}
+
+		/* Get the Buffer info for the posted buffer */
+		list_for_each_entry(d_buf, &phba->hbq_buffer_list, list) {
+			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
+			phys = ((uint64_t)hbq_buf->dbuf.phys & 0xffffffff);
+			if (phys == hbqe->bde.addrLow) {
+				len +=  snprintf(buf+len, size-len,
+					"Buf%d: %p %06x\n", i,
+					hbq_buf->dbuf.virt, hbq_buf->tag);
+				found = 1;
+				break;
+			}
+			i++;
+		}
+		if (!found) {
+			len +=  snprintf(buf+len, size-len, "No DMAinfo?\n");
+		}
+skipit:
+		hbqe++;
+		if (len > LPFC_HBQINFO_SIZE - 54)
+			break;
+	}
+	spin_unlock_irq(&phba->hbalock);
+	return len;
+}
+
 static int
 lpfc_debugfs_dumpslim_data(struct lpfc_hba *phba, char *buf, int size)
 {
@@ -492,6 +597,33 @@ out:
 }
 
 static int
+lpfc_debugfs_hbqinfo_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_hba *phba = inode->i_private;
+	struct lpfc_debug *debug;
+	int rc = -ENOMEM;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	/* Round to page boundry */
+	debug->buffer = kmalloc(LPFC_HBQINFO_SIZE, GFP_KERNEL);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = lpfc_debugfs_hbqinfo_data(phba, debug->buffer,
+		LPFC_HBQINFO_SIZE);
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static int
 lpfc_debugfs_dumpslim_open(struct inode *inode, struct file *file)
 {
 	struct lpfc_hba *phba = inode->i_private;
@@ -604,6 +736,15 @@ static struct file_operations lpfc_debug
 	.release =      lpfc_debugfs_release,
 };
 
+#undef lpfc_debugfs_op_hbqinfo
+static struct file_operations lpfc_debugfs_op_hbqinfo = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_hbqinfo_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.release =      lpfc_debugfs_release,
+};
+
 #undef lpfc_debugfs_op_dumpslim
 static struct file_operations lpfc_debugfs_op_dumpslim = {
 	.owner =        THIS_MODULE,
@@ -663,6 +804,18 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		atomic_inc(&lpfc_debugfs_hba_count);
 		atomic_set(&phba->debugfs_vport_count, 0);
 
+		/* Setup hbqinfo */
+		snprintf(name, sizeof(name), "hbqinfo");
+		phba->debug_hbqinfo =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				 phba->hba_debugfs_root,
+				 phba, &lpfc_debugfs_op_hbqinfo);
+		if (!phba->debug_hbqinfo) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				"0409 Cannot create debugfs hbqinfo\n");
+			goto debug_failed;
+		}
+
 		/* Setup dumpslim */
 		snprintf(name, sizeof(name), "dumpslim");
 		phba->debug_dumpslim =
@@ -819,6 +972,10 @@ lpfc_debugfs_terminate(struct lpfc_vport
 	}
 	if (atomic_read(&phba->debugfs_vport_count) == 0) {
 
+		if (phba->debug_hbqinfo) {
+			debugfs_remove(phba->debug_hbqinfo); /* hbqinfo */
+			phba->debug_hbqinfo = NULL;
+		}
 		if (phba->debug_dumpslim) {
 			debugfs_remove(phba->debug_dumpslim); /* dumpslim */
 			phba->debug_dumpslim = NULL;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-08-02 07:08:19.000000000 -0400
@@ -430,7 +430,7 @@ struct lpfc_hba {
 
 	/* HBA Config Parameters */
 	uint32_t cfg_ack0;
-	uint32_t cfg_npiv_enable;
+	uint32_t cfg_enable_npiv;
 	uint32_t cfg_topology;
 	uint32_t cfg_link_speed;
 	uint32_t cfg_cr_delay;
@@ -551,6 +551,7 @@ struct lpfc_hba {
 #ifdef CONFIG_LPFC_DEBUG_FS
 	struct dentry *hba_debugfs_root;
 	atomic_t debugfs_vport_count;
+	struct dentry *debug_hbqinfo;
 	struct dentry *debug_dumpslim;
 	struct dentry *debug_slow_ring_trc;
 	struct lpfc_debugfs_trc *slow_ring_trc;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 07:08:19.000000000 -0400
@@ -990,7 +990,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		}
 	} else {
 		if (!(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)) {
-			if (phba->max_vpi && phba->cfg_npiv_enable &&
+			if (phba->max_vpi && phba->cfg_enable_npiv &&
 			   (phba->sli_rev == 3))
 				phba->sli3_options |= LPFC_SLI3_NPIV_ENABLED;
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2007-08-02 07:11:24.000000000 -0400
@@ -688,7 +688,7 @@ lpfc_config_port(struct lpfc_hba *phba, 
 	if (phba->sli_rev == 3 && phba->vpd.sli3Feat.cerbm) {
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
 		mb->un.varCfgPort.max_hbq = 1; /* Requesting 2 HBQs */
-		if (phba->max_vpi && phba->cfg_npiv_enable &&
+		if (phba->max_vpi && phba->cfg_enable_npiv &&
 		    phba->vpd.sli3Feat.cmv) {
 			mb->un.varCfgPort.max_vpi = phba->max_vpi;
 			mb->un.varCfgPort.cmv = 1;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 07:08:19.000000000 -0400
@@ -602,7 +602,7 @@ static struct lpfc_hbq_init lpfc_els_hbq
 	.add_count = 5,
 };
 
-static struct lpfc_hbq_init *lpfc_hbq_defs[] = {
+struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 	&lpfc_els_hbq,
 };
 
@@ -2136,7 +2136,7 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 	return 0;
 }
 
-static int
+int
 lpfc_sli_hbq_count(void)
 {
 	return ARRAY_SIZE(lpfc_hbq_defs);
@@ -2309,7 +2309,7 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 
 	switch (lpfc_sli_mode) {
 	case 2:
-		if (phba->cfg_npiv_enable) {
+		if (phba->cfg_enable_npiv) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
 				"1824 NPIV enabled: Override lpfc_sli_mode "
 				"parameter (%d) to auto (0).\n",
diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2007-08-02 07:07:46.000000000 -0400
@@ -25,5 +25,3 @@
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
 #define LPFC_COPYRIGHT "Copyright(c) 2004-2007 Emulex.  All rights reserved."
-
-#define DFC_API_VERSION "0.0.0"


