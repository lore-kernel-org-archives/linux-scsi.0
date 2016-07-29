From: Heitor Ricardo Alves de Siqueira <halves@linux.vnet.ibm.com>
Subject: [PATCH] ipr: Add asynchronous error notification
Date: Fri, 29 Jul 2016 09:39:37 -0300
Message-ID: <1469795977-6345-1-git-send-email-halves@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41853 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751168AbcG2Mjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2016 08:39:45 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6TCdWjk019953
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2016 08:39:44 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
	by mx0b-001b2d01.pphosted.com with ESMTP id 24g15s7xxh-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2016 08:39:44 -0400
Received: from localhost
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <halves@linux.vnet.ibm.com>;
	Fri, 29 Jul 2016 09:39:41 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 147D83520076
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2016 08:39:19 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6TCdc9h6750532
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2016 09:39:38 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6TCdbYQ023131
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2016 09:39:38 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Heitor Ricardo Alves de Siqueira <hrasiq@gmail.com>, Brian King <brking@linux.vnet.ibm.com>, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

This patch implements functions for pushing HCAM (host controlled
asynchronous messages) error buffers to userspace through sysfs attributes.
Reads to the "async_err_log" attribute will result in a single HCAM buffer
being copied to userspace; one can process the next HCAM buffer by writing
any string to the same attribute.

A new list was added to the ioa_cfg structure to store the HCAM buffers for
later reporting. We also send a KOBJ_CHANGE event whenever a new HCAM
buffer is made available to userspace.

Signed-off-by: Heitor Ricardo Alves de Siqueira <halves@linux.vnet.ibm.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ipr.h |   7 ++-
 2 files changed, 116 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d6803a9e5ab8..ce713aa14960 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1472,7 +1472,7 @@ static void ipr_process_ccn(struct ipr_cmnd *ipr_cmd)
 	struct ipr_hostrcb *hostrcb = ipr_cmd->u.hostrcb;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 
-	list_del(&hostrcb->queue);
+	list_del_init(&hostrcb->queue);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 
 	if (ioasc) {
@@ -2551,6 +2551,23 @@ static void ipr_handle_log_data(struct ipr_ioa_cfg *ioa_cfg,
 	}
 }
 
+static struct ipr_hostrcb *ipr_get_free_hostrcb(struct ipr_ioa_cfg *ioa)
+{
+	struct ipr_hostrcb *hostrcb;
+
+	hostrcb = list_first_entry_or_null(&ioa->hostrcb_free_q,
+					struct ipr_hostrcb, queue);
+
+	if (unlikely(!hostrcb)) {
+		dev_info(&ioa->pdev->dev, "Reclaiming async error buffers.");
+		hostrcb = list_first_entry_or_null(&ioa->hostrcb_report_q,
+						struct ipr_hostrcb, queue);
+	}
+
+	list_del_init(&hostrcb->queue);
+	return hostrcb;
+}
+
 /**
  * ipr_process_error - Op done function for an adapter error log.
  * @ipr_cmd:	ipr command struct
@@ -2568,13 +2585,14 @@ static void ipr_process_error(struct ipr_cmnd *ipr_cmd)
 	struct ipr_hostrcb *hostrcb = ipr_cmd->u.hostrcb;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 	u32 fd_ioasc;
+	char *envp[] = { "ASYNC_ERR_LOG=1", NULL};
 
 	if (ioa_cfg->sis64)
 		fd_ioasc = be32_to_cpu(hostrcb->hcam.u.error64.fd_ioasc);
 	else
 		fd_ioasc = be32_to_cpu(hostrcb->hcam.u.error.fd_ioasc);
 
-	list_del(&hostrcb->queue);
+	list_del_init(&hostrcb->queue);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 
 	if (!ioasc) {
@@ -2587,6 +2605,10 @@ static void ipr_process_error(struct ipr_cmnd *ipr_cmd)
 			"Host RCB failed with IOASC: 0x%08X\n", ioasc);
 	}
 
+	list_add_tail(&hostrcb->queue, &ioa_cfg->hostrcb_report_q);
+	hostrcb = ipr_get_free_hostrcb(ioa_cfg);
+	kobject_uevent_env(&ioa_cfg->host->shost_dev.kobj, KOBJ_CHANGE, envp);
+
 	ipr_send_hcam(ioa_cfg, IPR_HCAM_CDB_OP_CODE_LOG_DATA, hostrcb);
 }
 
@@ -4089,6 +4111,64 @@ static struct device_attribute ipr_ioa_fw_type_attr = {
 	.show = ipr_show_fw_type
 };
 
+static ssize_t ipr_read_async_err_log(struct file *filep, struct kobject *kobj,
+				struct bin_attribute *bin_attr, char *buf,
+				loff_t off, size_t count)
+{
+	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
+	struct ipr_hostrcb *hostrcb;
+	unsigned long lock_flags = 0;
+	int ret;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	hostrcb = list_first_entry_or_null(&ioa_cfg->hostrcb_report_q,
+					struct ipr_hostrcb, queue);
+	if (!hostrcb) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		return 0;
+	}
+	ret = memory_read_from_buffer(buf, count, &off, &hostrcb->hcam,
+				sizeof(hostrcb->hcam));
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return ret;
+}
+
+static ssize_t ipr_next_async_err_log(struct file *filep, struct kobject *kobj,
+				struct bin_attribute *bin_attr, char *buf,
+				loff_t off, size_t count)
+{
+	struct device *cdev = container_of(kobj, struct device, kobj);
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
+	struct ipr_hostrcb *hostrcb;
+	unsigned long lock_flags = 0;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	hostrcb = list_first_entry_or_null(&ioa_cfg->hostrcb_report_q,
+					struct ipr_hostrcb, queue);
+	if (!hostrcb) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		return count;
+	}
+
+	/* Reclaim hostrcb before exit */
+	list_move_tail(&hostrcb->queue, &ioa_cfg->hostrcb_free_q);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return count;
+}
+
+static struct bin_attribute ipr_ioa_async_err_log = {
+	.attr = {
+		.name =		"async_err_log",
+		.mode =		S_IRUGO | S_IWUSR,
+	},
+	.size = 0,
+	.read = ipr_read_async_err_log,
+	.write = ipr_next_async_err_log
+};
+
 static struct device_attribute *ipr_ioa_attrs[] = {
 	&ipr_fw_version_attr,
 	&ipr_log_level_attr,
@@ -7020,8 +7100,7 @@ static int ipr_ioa_reset_done(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_resource_entry *res;
-	struct ipr_hostrcb *hostrcb, *temp;
-	int i = 0, j;
+	int j;
 
 	ENTER;
 	ioa_cfg->in_reset_reload = 0;
@@ -7042,12 +7121,16 @@ static int ipr_ioa_reset_done(struct ipr_cmnd *ipr_cmd)
 	}
 	schedule_work(&ioa_cfg->work_q);
 
-	list_for_each_entry_safe(hostrcb, temp, &ioa_cfg->hostrcb_free_q, queue) {
-		list_del(&hostrcb->queue);
-		if (i++ < IPR_NUM_LOG_HCAMS)
-			ipr_send_hcam(ioa_cfg, IPR_HCAM_CDB_OP_CODE_LOG_DATA, hostrcb);
+	for (j = 0; j < IPR_NUM_HCAMS; j++) {
+		list_del_init(&ioa_cfg->hostrcb[j]->queue);
+		if (j < IPR_NUM_LOG_HCAMS)
+			ipr_send_hcam(ioa_cfg,
+				IPR_HCAM_CDB_OP_CODE_LOG_DATA,
+				ioa_cfg->hostrcb[j]);
 		else
-			ipr_send_hcam(ioa_cfg, IPR_HCAM_CDB_OP_CODE_CONFIG_CHANGE, hostrcb);
+			ipr_send_hcam(ioa_cfg,
+				IPR_HCAM_CDB_OP_CODE_CONFIG_CHANGE,
+				ioa_cfg->hostrcb[j]);
 	}
 
 	scsi_report_bus_reset(ioa_cfg->host, IPR_VSET_BUS);
@@ -8329,7 +8412,7 @@ static void ipr_get_unit_check_buffer(struct ipr_ioa_cfg *ioa_cfg)
 
 	hostrcb = list_entry(ioa_cfg->hostrcb_free_q.next,
 			     struct ipr_hostrcb, queue);
-	list_del(&hostrcb->queue);
+	list_del_init(&hostrcb->queue);
 	memset(&hostrcb->hcam, 0, sizeof(hostrcb->hcam));
 
 	rc = ipr_get_ldump_data_section(ioa_cfg,
@@ -9326,7 +9409,7 @@ static void ipr_free_mem(struct ipr_ioa_cfg *ioa_cfg)
 	dma_free_coherent(&ioa_cfg->pdev->dev, ioa_cfg->cfg_table_size,
 			  ioa_cfg->u.cfg_table, ioa_cfg->cfg_table_dma);
 
-	for (i = 0; i < IPR_NUM_HCAMS; i++) {
+	for (i = 0; i < IPR_MAX_HCAMS; i++) {
 		dma_free_coherent(&ioa_cfg->pdev->dev,
 				  sizeof(struct ipr_hostrcb),
 				  ioa_cfg->hostrcb[i],
@@ -9566,7 +9649,7 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 	if (!ioa_cfg->u.cfg_table)
 		goto out_free_host_rrq;
 
-	for (i = 0; i < IPR_NUM_HCAMS; i++) {
+	for (i = 0; i < IPR_MAX_HCAMS; i++) {
 		ioa_cfg->hostrcb[i] = dma_alloc_coherent(&pdev->dev,
 							 sizeof(struct ipr_hostrcb),
 							 &ioa_cfg->hostrcb_dma[i],
@@ -9708,6 +9791,7 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 
 	INIT_LIST_HEAD(&ioa_cfg->hostrcb_free_q);
 	INIT_LIST_HEAD(&ioa_cfg->hostrcb_pending_q);
+	INIT_LIST_HEAD(&ioa_cfg->hostrcb_report_q);
 	INIT_LIST_HEAD(&ioa_cfg->free_res_q);
 	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
 	INIT_WORK(&ioa_cfg->work_q, ipr_worker_thread);
@@ -10345,6 +10429,8 @@ static void ipr_remove(struct pci_dev *pdev)
 			      &ipr_trace_attr);
 	ipr_remove_dump_file(&ioa_cfg->host->shost_dev.kobj,
 			     &ipr_dump_attr);
+	sysfs_remove_bin_file(&ioa_cfg->host->shost_dev.kobj,
+			&ipr_ioa_async_err_log);
 	scsi_remove_host(ioa_cfg->host);
 
 	__ipr_remove(pdev);
@@ -10403,6 +10489,19 @@ static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 		return rc;
 	}
 
+	rc = sysfs_create_bin_file(&ioa_cfg->host->shost_dev.kobj,
+			&ipr_ioa_async_err_log);
+
+	if (rc) {
+		ipr_remove_dump_file(&ioa_cfg->host->shost_dev.kobj,
+				&ipr_dump_attr);
+		ipr_remove_trace_file(&ioa_cfg->host->shost_dev.kobj,
+				&ipr_trace_attr);
+		scsi_remove_host(ioa_cfg->host);
+		__ipr_remove(pdev);
+		return rc;
+	}
+
 	scsi_scan_host(ioa_cfg->host);
 	ioa_cfg->iopoll_weight = ioa_cfg->chip_cfg->iopoll_weight;
 
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 56c57068300a..4c3c56b4b3c7 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -151,7 +151,9 @@
 #define IPR_DEFAULT_MAX_ERROR_DUMP			984
 #define IPR_NUM_LOG_HCAMS				2
 #define IPR_NUM_CFG_CHG_HCAMS				2
+#define IPR_NUM_HCAM_QUEUE				12
 #define IPR_NUM_HCAMS	(IPR_NUM_LOG_HCAMS + IPR_NUM_CFG_CHG_HCAMS)
+#define IPR_MAX_HCAMS	(IPR_NUM_HCAMS + IPR_NUM_HCAM_QUEUE)
 
 #define IPR_MAX_SIS64_TARGETS_PER_BUS			1024
 #define IPR_MAX_SIS64_LUNS_PER_TARGET			0xffffffff
@@ -1528,10 +1530,11 @@ struct ipr_ioa_cfg {
 
 	char ipr_hcam_label[8];
 #define IPR_HCAM_LABEL			"hcams"
-	struct ipr_hostrcb *hostrcb[IPR_NUM_HCAMS];
-	dma_addr_t hostrcb_dma[IPR_NUM_HCAMS];
+	struct ipr_hostrcb *hostrcb[IPR_MAX_HCAMS];
+	dma_addr_t hostrcb_dma[IPR_MAX_HCAMS];
 	struct list_head hostrcb_free_q;
 	struct list_head hostrcb_pending_q;
+	struct list_head hostrcb_report_q;
 
 	struct ipr_hrr_queue hrrq[IPR_MAX_HRRQ_NUM];
 	u32 hrrq_num;
-- 
2.4.11

