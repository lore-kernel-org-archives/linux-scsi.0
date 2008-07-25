From: Denis ChengRq <crquan@gmail.com>
Subject: [PATCH 3/5] drivers/scsi/libsas/: replace __FUNCTION__ with __func__
Date: Fri, 25 Jul 2008 10:47:15 +0800
Message-ID: <1216954035-31897-2-git-send-email-crquan@gmail.com>
References: <1216954035-31897-1-git-send-email-crquan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:27698 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYGYCrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 22:47:41 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1612905tic.23
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2008 19:47:39 -0700 (PDT)
In-Reply-To: <1216954035-31897-1-git-send-email-crquan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 drivers/scsi/libsas/sas_ata.c       |   16 ++++++++--------
 drivers/scsi/libsas/sas_expander.c  |   13 +++++++------
 drivers/scsi/libsas/sas_port.c      |    4 ++--
 drivers/scsi/libsas/sas_scsi_host.c |   30 +++++++++++++++---------------
 4 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 744f06d..48ee8c7 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -74,7 +74,7 @@ static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 		case SAS_OPEN_TO:
 		case SAS_OPEN_REJECT:
 			SAS_DPRINTK("%s: Saw error %d.  What to do?\n",
-				    __FUNCTION__, ts->stat);
+				    __func__, ts->stat);
 			return AC_ERR_OTHER;
 
 		case SAS_ABORTED_TASK:
@@ -115,7 +115,7 @@ static void sas_ata_task_done(struct sas_task *task)
 	} else if (stat->stat != SAM_STAT_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
-			SAS_DPRINTK("%s: SAS error %x\n", __FUNCTION__,
+			SAS_DPRINTK("%s: SAS error %x\n", __func__,
 				    stat->stat);
 			/* We saw a SAS error. Send a vague error. */
 			qc->err_mask = ac;
@@ -244,20 +244,20 @@ static void sas_ata_phy_reset(struct ata_port *ap)
 		res = i->dft->lldd_I_T_nexus_reset(dev);
 
 	if (res != TMF_RESP_FUNC_COMPLETE)
-		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __FUNCTION__);
+		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __func__);
 
 	switch (dev->sata_dev.command_set) {
 		case ATA_COMMAND_SET:
-			SAS_DPRINTK("%s: Found ATA device.\n", __FUNCTION__);
+			SAS_DPRINTK("%s: Found ATA device.\n", __func__);
 			ap->link.device[0].class = ATA_DEV_ATA;
 			break;
 		case ATAPI_COMMAND_SET:
-			SAS_DPRINTK("%s: Found ATAPI device.\n", __FUNCTION__);
+			SAS_DPRINTK("%s: Found ATAPI device.\n", __func__);
 			ap->link.device[0].class = ATA_DEV_ATAPI;
 			break;
 		default:
 			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
-				    __FUNCTION__,
+				    __func__,
 				    dev->sata_dev.command_set);
 			ap->link.device[0].class = ATA_DEV_UNKNOWN;
 			break;
@@ -299,7 +299,7 @@ static int sas_ata_scr_write(struct ata_port *ap, unsigned int sc_reg_in,
 {
 	struct domain_device *dev = ap->private_data;
 
-	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
+	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
 		case SCR_STATUS:
 			dev->sata_dev.sstatus = val;
@@ -324,7 +324,7 @@ static int sas_ata_scr_read(struct ata_port *ap, unsigned int sc_reg_in,
 {
 	struct domain_device *dev = ap->private_data;
 
-	SAS_DPRINTK("STUB %s\n", __FUNCTION__);
+	SAS_DPRINTK("STUB %s\n", __func__);
 	switch (sc_reg_in) {
 		case SCR_STATUS:
 			*val = dev->sata_dev.sstatus;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index aefd865..996a581 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -121,7 +121,7 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 			break;
 		} else {
 			SAS_DPRINTK("%s: task to dev %016llx response: 0x%x "
-				    "status 0x%x\n", __FUNCTION__,
+				    "status 0x%x\n", __func__,
 				    SAS_ADDR(dev->sas_addr),
 				    task->task_status.resp,
 				    task->task_status.stat);
@@ -1279,7 +1279,7 @@ static int sas_configure_present(struct domain_device *dev, int phy_id,
 			goto out;
 		} else if (res != SMP_RESP_FUNC_ACC) {
 			SAS_DPRINTK("%s: dev %016llx phy 0x%x index 0x%x "
-				    "result 0x%x\n", __FUNCTION__,
+				    "result 0x%x\n", __func__,
 				    SAS_ADDR(dev->sas_addr), phy_id, i, res);
 			goto out;
 		}
@@ -1901,7 +1901,7 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	if (!rsp) {
 		printk("%s: space for a smp response is missing\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EINVAL;
 	}
 
@@ -1914,20 +1914,21 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	if (type != SAS_EDGE_EXPANDER_DEVICE &&
 	    type != SAS_FANOUT_EXPANDER_DEVICE) {
 		printk("%s: can we send a smp request to a device?\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EINVAL;
 	}
 
 	dev = sas_find_dev_by_rphy(rphy);
 	if (!dev) {
-		printk("%s: fail to find a domain_device?\n", __FUNCTION__);
+		printk(KERN_ERR "%s: fail to find a domain_device?\n",
+				__func__);
 		return -EINVAL;
 	}
 
 	/* do we need to support multiple segments? */
 	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
 		printk("%s: multiple segments req %u %u, rsp %u %u\n",
-		       __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		       __func__, req->bio->bi_vcnt, req->data_len,
 		       rsp->bio->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 39ae68a..139935a 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -50,7 +50,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 			sas_deform_port(phy);
 		else {
 			SAS_DPRINTK("%s: phy%d belongs to port%d already(%d)!\n",
-				    __FUNCTION__, phy->id, phy->port->id,
+				    __func__, phy->id, phy->port->id,
 				    phy->port->num_phys);
 			return;
 		}
@@ -78,7 +78,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 
 	if (i >= sas_ha->num_phys) {
 		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",
-		       __FUNCTION__);
+		       __func__);
 		spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 		return;
 	}
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 601ec5b..87dfb60 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -343,7 +343,7 @@ static enum task_disposition sas_scsi_find_task(struct sas_task *task)
 						       flags);
 				SAS_DPRINTK("%s: task 0x%p aborted from "
 					    "task_queue\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_ABORTED;
 			}
 		}
@@ -351,13 +351,13 @@ static enum task_disposition sas_scsi_find_task(struct sas_task *task)
 	}
 
 	for (i = 0; i < 5; i++) {
-		SAS_DPRINTK("%s: aborting task 0x%p\n", __FUNCTION__, task);
+		SAS_DPRINTK("%s: aborting task 0x%p\n", __func__, task);
 		res = si->dft->lldd_abort_task(task);
 
 		spin_lock_irqsave(&task->task_state_lock, flags);
 		if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 			spin_unlock_irqrestore(&task->task_state_lock, flags);
-			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
+			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
 			return TASK_IS_DONE;
 		}
@@ -365,24 +365,24 @@ static enum task_disposition sas_scsi_find_task(struct sas_task *task)
 
 		if (res == TMF_RESP_FUNC_COMPLETE) {
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			return TASK_IS_ABORTED;
 		} else if (si->dft->lldd_query_task) {
 			SAS_DPRINTK("%s: querying task 0x%p\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			res = si->dft->lldd_query_task(task);
 			switch (res) {
 			case TMF_RESP_FUNC_SUCC:
 				SAS_DPRINTK("%s: task 0x%p at LU\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_AT_LU;
 			case TMF_RESP_FUNC_COMPLETE:
 				SAS_DPRINTK("%s: task 0x%p not at LU\n",
-					    __FUNCTION__, task);
+					    __func__, task);
 				return TASK_IS_NOT_AT_LU;
 			case TMF_RESP_FUNC_FAILED:
                                 SAS_DPRINTK("%s: task 0x%p failed to abort\n",
-                                                __FUNCTION__, task);
+						__func__, task);
                                 return TASK_ABORT_FAILED;
                         }
 
@@ -545,7 +545,7 @@ Again:
 
 		if (need_reset) {
 			SAS_DPRINTK("%s: task 0x%p requests reset\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			goto reset;
 		}
 
@@ -556,13 +556,13 @@ Again:
 
 		switch (res) {
 		case TASK_IS_DONE:
-			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
+			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
 				    task);
 			sas_eh_finish_cmd(cmd);
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
-				    __FUNCTION__, task);
+				    __func__, task);
 			sas_eh_finish_cmd(cmd);
 			continue;
 		case TASK_IS_AT_LU:
@@ -633,7 +633,7 @@ Again:
 	}
 	return list_empty(work_q);
 clear_q:
-	SAS_DPRINTK("--- Exit %s -- clear_q\n", __FUNCTION__);
+	SAS_DPRINTK("--- Exit %s -- clear_q\n", __func__);
 	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
 		sas_eh_finish_cmd(cmd);
 
@@ -650,7 +650,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	SAS_DPRINTK("Enter %s\n", __FUNCTION__);
+	SAS_DPRINTK("Enter %s\n", __func__);
 	/*
 	 * Deal with commands that still have SAS tasks (i.e. they didn't
 	 * complete via the normal sas_task completion mechanism)
@@ -669,7 +669,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 
 out:
 	scsi_eh_flush_done_q(&ha->eh_done_q);
-	SAS_DPRINTK("--- Exit %s\n", __FUNCTION__);
+	SAS_DPRINTK("--- Exit %s\n", __func__);
 	return;
 }
 
@@ -990,7 +990,7 @@ int __sas_task_abort(struct sas_task *task)
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED ||
 	    task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		SAS_DPRINTK("%s: Task %p already finished.\n", __FUNCTION__,
+		SAS_DPRINTK("%s: Task %p already finished.\n", __func__,
 			    task);
 		return 0;
 	}
-- 
1.5.6.3

