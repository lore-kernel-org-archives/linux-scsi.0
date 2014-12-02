From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH RESEND 1/5] ipr: Add support for async scanning to speed up boot
Date: Tue, 02 Dec 2014 12:47:37 -0600
Message-ID: <201412021847.sB2IlcfD026110@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:38769 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaLBSro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 13:47:44 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 2 Dec 2014 11:47:43 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id B75F819D8041
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2014 11:36:21 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB2IkjnQ20709494
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 11:46:45 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB2IlecZ026376
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 11:47:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, anton@samba.org, brking@linux.vnet.ibm.com


Switch device scanning logic in the ipr driver to use
the async scan API. This speeds up boot times, particularly
on large systems.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   88 +++++++++++++++++++++++++----------------------------
 drivers/scsi/ipr.h |    4 --
 2 files changed, 44 insertions(+), 48 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_async_scanning_boot drivers/scsi/ipr.c
--- scsi-queue/drivers/scsi/ipr.c~ipr_async_scanning_boot	2014-12-02 12:13:23.942315991 -0600
+++ scsi-queue-bjking1/drivers/scsi/ipr.c	2014-12-02 12:13:23.952315905 -0600
@@ -1426,16 +1426,14 @@ static void ipr_handle_config_change(str
 		if (res->sdev) {
 			res->del_from_ml = 1;
 			res->res_handle = IPR_INVALID_RES_HANDLE;
-			if (ioa_cfg->allow_ml_add_del)
-				schedule_work(&ioa_cfg->work_q);
+			schedule_work(&ioa_cfg->work_q);
 		} else {
 			ipr_clear_res_target(res);
 			list_move_tail(&res->queue, &ioa_cfg->free_res_q);
 		}
 	} else if (!res->sdev || res->del_from_ml) {
 		res->add_to_ml = 1;
-		if (ioa_cfg->allow_ml_add_del)
-			schedule_work(&ioa_cfg->work_q);
+		schedule_work(&ioa_cfg->work_q);
 	}
 
 	ipr_send_hcam(ioa_cfg, IPR_HCAM_CDB_OP_CODE_CONFIG_CHANGE, hostrcb);
@@ -3273,8 +3271,7 @@ static void ipr_worker_thread(struct wor
 restart:
 	do {
 		did_work = 0;
-		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds ||
-		    !ioa_cfg->allow_ml_add_del) {
+		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds) {
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 			return;
 		}
@@ -3311,6 +3308,7 @@ restart:
 		}
 	}
 
+	ioa_cfg->scan_done = 1;
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	kobject_uevent(&ioa_cfg->host->shost_dev.kobj, KOBJ_CHANGE);
 	LEAVE;
@@ -5231,6 +5229,28 @@ static int ipr_cancel_op(struct scsi_cmn
  * @scsi_cmd:	scsi command struct
  *
  * Return value:
+ *	0 if scan in progress / 1 if scan is complete
+ **/
+static int ipr_scan_finished(struct Scsi_Host *shost, unsigned long elapsed_time)
+{
+	unsigned long lock_flags;
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
+	int rc = 0;
+
+	spin_lock_irqsave(shost->host_lock, lock_flags);
+	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead || ioa_cfg->scan_done)
+		rc = 1;
+	if ((elapsed_time/HZ) > (ioa_cfg->transop_timeout * 2))
+		rc = 1;
+	spin_unlock_irqrestore(shost->host_lock, lock_flags);
+	return rc;
+}
+
+/**
+ * ipr_eh_host_reset - Reset the host adapter
+ * @scsi_cmd:	scsi command struct
+ *
+ * Return value:
  * 	SUCCESS / FAILED
  **/
 static int ipr_eh_abort(struct scsi_cmnd *scsi_cmd)
@@ -6299,6 +6319,7 @@ static struct scsi_host_template driver_
 	.slave_alloc = ipr_slave_alloc,
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
+	.scan_finished = ipr_scan_finished,
 	.target_alloc = ipr_target_alloc,
 	.target_destroy = ipr_target_destroy,
 	.change_queue_depth = ipr_change_queue_depth,
@@ -6841,7 +6862,7 @@ static int ipr_ioa_reset_done(struct ipr
 	ioa_cfg->doorbell |= IPR_RUNTIME_RESET;
 
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
-		if (ioa_cfg->allow_ml_add_del && (res->add_to_ml || res->del_from_ml)) {
+		if (res->add_to_ml || res->del_from_ml) {
 			ipr_trace;
 			break;
 		}
@@ -6870,6 +6891,7 @@ static int ipr_ioa_reset_done(struct ipr
 	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds)
 		scsi_block_requests(ioa_cfg->host);
 
+	schedule_work(&ioa_cfg->work_q);
 	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
@@ -7610,6 +7632,19 @@ static int ipr_ioafp_page0_inquiry(struc
 	type[4] = '\0';
 	ioa_cfg->type = simple_strtoul((char *)type, NULL, 16);
 
+	if (ipr_invalid_adapter(ioa_cfg)) {
+		dev_err(&ioa_cfg->pdev->dev,
+			"Adapter not supported in this hardware configuration.\n");
+
+		if (!ipr_testmode) {
+			ioa_cfg->reset_retries += IPR_NUM_RESET_RELOAD_RETRIES;
+			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+			list_add_tail(&ipr_cmd->queue,
+					&ioa_cfg->hrrq->hrrq_free_q);
+			return IPR_RC_JOB_RETURN;
+		}
+	}
+
 	ipr_cmd->job_step = ipr_ioafp_page3_inquiry;
 
 	ipr_ioafp_inquiry(ipr_cmd, 1, 0,
@@ -8797,20 +8832,6 @@ static int ipr_probe_ioa_part2(struct ip
 		_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_enable_ioa,
 					IPR_SHUTDOWN_NONE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
-	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
-
-	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
-		rc = -EIO;
-	} else if (ipr_invalid_adapter(ioa_cfg)) {
-		if (!ipr_testmode)
-			rc = -EIO;
-
-		dev_err(&ioa_cfg->pdev->dev,
-			"Adapter not supported in this hardware configuration.\n");
-	}
-
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 
 	LEAVE;
 	return rc;
@@ -9264,7 +9285,7 @@ static void ipr_init_ioa_cfg(struct ipr_
 					       * ioa_cfg->max_devs_supported)));
 	}
 
-	host->max_channel = IPR_MAX_BUS_TO_SCAN;
+	host->max_channel = IPR_VSET_BUS;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = IPR_MAX_CDB_LEN;
 	host->can_queue = ioa_cfg->max_cmds;
@@ -9764,25 +9785,6 @@ out_scsi_host_put:
 }
 
 /**
- * ipr_scan_vsets - Scans for VSET devices
- * @ioa_cfg:	ioa config struct
- *
- * Description: Since the VSET resources do not follow SAM in that we can have
- * sparse LUNs with no LUN 0, we have to scan for these ourselves.
- *
- * Return value:
- * 	none
- **/
-static void ipr_scan_vsets(struct ipr_ioa_cfg *ioa_cfg)
-{
-	int target, lun;
-
-	for (target = 0; target < IPR_MAX_NUM_TARGETS_PER_BUS; target++)
-		for (lun = 0; lun < IPR_MAX_NUM_VSET_LUNS_PER_TARGET; lun++)
-			scsi_add_device(ioa_cfg->host, IPR_VSET_BUS, target, lun);
-}
-
-/**
  * ipr_initiate_ioa_bringdown - Bring down an adapter
  * @ioa_cfg:		ioa config struct
  * @shutdown_type:	shutdown type
@@ -9937,10 +9939,6 @@ static int ipr_probe(struct pci_dev *pde
 	}
 
 	scsi_scan_host(ioa_cfg->host);
-	ipr_scan_vsets(ioa_cfg);
-	scsi_add_device(ioa_cfg->host, IPR_IOA_BUS, IPR_IOA_TARGET, IPR_IOA_LUN);
-	ioa_cfg->allow_ml_add_del = 1;
-	ioa_cfg->host->max_channel = IPR_VSET_BUS;
 	ioa_cfg->iopoll_weight = ioa_cfg->chip_cfg->iopoll_weight;
 
 	if (ioa_cfg->iopoll_weight && ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
diff -puN drivers/scsi/ipr.h~ipr_async_scanning_boot drivers/scsi/ipr.h
--- scsi-queue/drivers/scsi/ipr.h~ipr_async_scanning_boot	2014-12-02 12:13:23.945315964 -0600
+++ scsi-queue-bjking1/drivers/scsi/ipr.h	2014-12-02 12:13:23.956315869 -0600
@@ -157,13 +157,11 @@
 
 #define IPR_MAX_NUM_TARGETS_PER_BUS			256
 #define IPR_MAX_NUM_LUNS_PER_TARGET			256
-#define IPR_MAX_NUM_VSET_LUNS_PER_TARGET	8
 #define IPR_VSET_BUS					0xff
 #define IPR_IOA_BUS						0xff
 #define IPR_IOA_TARGET					0xff
 #define IPR_IOA_LUN						0xff
 #define IPR_MAX_NUM_BUSES				16
-#define IPR_MAX_BUS_TO_SCAN				IPR_MAX_NUM_BUSES
 
 #define IPR_NUM_RESET_RELOAD_RETRIES		3
 
@@ -1453,7 +1451,7 @@ struct ipr_ioa_cfg {
 	u8 in_ioa_bringdown:1;
 	u8 ioa_unit_checked:1;
 	u8 dump_taken:1;
-	u8 allow_ml_add_del:1;
+	u8 scan_done:1;
 	u8 needs_hard_reset:1;
 	u8 dual_raid:1;
 	u8 needs_warm_reset:1;
_

