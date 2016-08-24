From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2] ipr: Add asynchronous error notification
Date: Wed, 24 Aug 2016 12:56:51 -0500
Message-ID: <a7eec861-46e1-4d82-1361-ae9b9a04cf3d@linux.vnet.ibm.com>
References: <1469795977-6345-1-git-send-email-halves@linux.vnet.ibm.com>
 <yq1twehh3ty.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753148AbcHXR45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Aug 2016 13:56:57 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7OHsbIc130888
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 13:56:57 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 250qp4vtr3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 13:56:56 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 24 Aug 2016 11:56:56 -0600
In-Reply-To: <yq1twehh3ty.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Heitor Ricardo Alves de Siqueira <halves@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Heitor Ricardo Alves de Siqueira <hrasiq@gmail.com>, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Looks pretty good. I noticed one issue in an error path where you
weren't removing the new sysfs file. Here is a fixed version.

8<

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
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ipr.h |    7 ++
 2 files changed, 118 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_async_err_notify drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_async_err_notify	2016-08-23 12:13:59.265295961 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2016-08-24 12:44:07.769414624 -0500
@@ -1473,7 +1473,7 @@ static void ipr_process_ccn(struct ipr_c
 	struct ipr_hostrcb *hostrcb = ipr_cmd->u.hostrcb;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 
-	list_del(&hostrcb->queue);
+	list_del_init(&hostrcb->queue);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 
 	if (ioasc) {
@@ -2552,6 +2552,23 @@ static void ipr_handle_log_data(struct i
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
@@ -2569,13 +2586,14 @@ static void ipr_process_error(struct ipr
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
@@ -2588,6 +2606,10 @@ static void ipr_process_error(struct ipr
 			"Host RCB failed with IOASC: 0x%08X\n", ioasc);
 	}
 
+	list_add_tail(&hostrcb->queue, &ioa_cfg->hostrcb_report_q);
+	hostrcb = ipr_get_free_hostrcb(ioa_cfg);
+	kobject_uevent_env(&ioa_cfg->host->shost_dev.kobj, KOBJ_CHANGE, envp);
+
 	ipr_send_hcam(ioa_cfg, IPR_HCAM_CDB_OP_CODE_LOG_DATA, hostrcb);
 }
 
@@ -4095,6 +4117,64 @@ static struct device_attribute ipr_ioa_f
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
@@ -7026,8 +7106,7 @@ static int ipr_ioa_reset_done(struct ipr
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_resource_entry *res;
-	struct ipr_hostrcb *hostrcb, *temp;
-	int i = 0, j;
+	int j;
 
 	ENTER;
 	ioa_cfg->in_reset_reload = 0;
@@ -7048,12 +7127,16 @@ static int ipr_ioa_reset_done(struct ipr
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
@@ -8335,7 +8418,7 @@ static void ipr_get_unit_check_buffer(st
 
 	hostrcb = list_entry(ioa_cfg->hostrcb_free_q.next,
 			     struct ipr_hostrcb, queue);
-	list_del(&hostrcb->queue);
+	list_del_init(&hostrcb->queue);
 	memset(&hostrcb->hcam, 0, sizeof(hostrcb->hcam));
 
 	rc = ipr_get_ldump_data_section(ioa_cfg,
@@ -9332,7 +9415,7 @@ static void ipr_free_mem(struct ipr_ioa_
 	dma_free_coherent(&ioa_cfg->pdev->dev, ioa_cfg->cfg_table_size,
 			  ioa_cfg->u.cfg_table, ioa_cfg->cfg_table_dma);
 
-	for (i = 0; i < IPR_NUM_HCAMS; i++) {
+	for (i = 0; i < IPR_MAX_HCAMS; i++) {
 		dma_free_coherent(&ioa_cfg->pdev->dev,
 				  sizeof(struct ipr_hostrcb),
 				  ioa_cfg->hostrcb[i],
@@ -9572,7 +9655,7 @@ static int ipr_alloc_mem(struct ipr_ioa_
 	if (!ioa_cfg->u.cfg_table)
 		goto out_free_host_rrq;
 
-	for (i = 0; i < IPR_NUM_HCAMS; i++) {
+	for (i = 0; i < IPR_MAX_HCAMS; i++) {
 		ioa_cfg->hostrcb[i] = dma_alloc_coherent(&pdev->dev,
 							 sizeof(struct ipr_hostrcb),
 							 &ioa_cfg->hostrcb_dma[i],
@@ -9714,6 +9797,7 @@ static void ipr_init_ioa_cfg(struct ipr_
 
 	INIT_LIST_HEAD(&ioa_cfg->hostrcb_free_q);
 	INIT_LIST_HEAD(&ioa_cfg->hostrcb_pending_q);
+	INIT_LIST_HEAD(&ioa_cfg->hostrcb_report_q);
 	INIT_LIST_HEAD(&ioa_cfg->free_res_q);
 	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
 	INIT_WORK(&ioa_cfg->work_q, ipr_worker_thread);
@@ -10352,6 +10436,8 @@ static void ipr_remove(struct pci_dev *p
 			      &ipr_trace_attr);
 	ipr_remove_dump_file(&ioa_cfg->host->shost_dev.kobj,
 			     &ipr_dump_attr);
+	sysfs_remove_bin_file(&ioa_cfg->host->shost_dev.kobj,
+			&ipr_ioa_async_err_log);
 	scsi_remove_host(ioa_cfg->host);
 
 	__ipr_remove(pdev);
@@ -10400,10 +10486,25 @@ static int ipr_probe(struct pci_dev *pde
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
 	rc = ipr_create_dump_file(&ioa_cfg->host->shost_dev.kobj,
 				   &ipr_dump_attr);
 
 	if (rc) {
+		sysfs_remove_bin_file(&ioa_cfg->host->shost_dev.kobj,
+				      &ipr_ioa_async_err_log);
 		ipr_remove_trace_file(&ioa_cfg->host->shost_dev.kobj,
 				      &ipr_trace_attr);
 		scsi_remove_host(ioa_cfg->host);
diff -puN drivers/scsi/ipr.h~ipr_async_err_notify drivers/scsi/ipr.h
--- linux-2.6.git/drivers/scsi/ipr.h~ipr_async_err_notify	2016-08-23 12:13:59.269295927 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.h	2016-08-24 12:42:36.377726203 -0500
@@ -154,7 +154,9 @@
 #define IPR_DEFAULT_MAX_ERROR_DUMP			984
 #define IPR_NUM_LOG_HCAMS				2
 #define IPR_NUM_CFG_CHG_HCAMS				2
+#define IPR_NUM_HCAM_QUEUE				12
 #define IPR_NUM_HCAMS	(IPR_NUM_LOG_HCAMS + IPR_NUM_CFG_CHG_HCAMS)
+#define IPR_MAX_HCAMS	(IPR_NUM_HCAMS + IPR_NUM_HCAM_QUEUE)
 
 #define IPR_MAX_SIS64_TARGETS_PER_BUS			1024
 #define IPR_MAX_SIS64_LUNS_PER_TARGET			0xffffffff
@@ -1532,10 +1534,11 @@ struct ipr_ioa_cfg {
 
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
_

