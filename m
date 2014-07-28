From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/5] ipr: Add support for async scanning to speed up boot
Date: Mon, 28 Jul 2014 15:28:04 -0500
Message-ID: <53D6B254.1090503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50650 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaG1U2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2014 16:28:09 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 28 Jul 2014 16:28:08 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id DE7A3C9003E
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 16:27:58 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22033.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6SKS6HZ065850
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 20:28:06 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6SKS5Rw032473
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 16:28:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>


Switch device scanning logic in the ipr driver to use
the async scan API. This speeds up boot times, particularly
on large systems.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   88 +++++++++++++++++++++++++----------------------------
 drivers/scsi/ipr.h |    4 --
 2 files changed, 44 insertions(+), 48 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_async_scanning_boot drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_async_scanning_boot	2014-06-12 10:17:39.000000000 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2014-07-23 15:52:04.056004810 -0500
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
@@ -3263,8 +3261,7 @@ static void ipr_worker_thread(struct wor
 restart:
 	do {
 		did_work = 0;
-		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds ||
-		    !ioa_cfg->allow_ml_add_del) {
+		if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds) {
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 			return;
 		}
@@ -3301,6 +3298,7 @@ restart:
 		}
 	}
 
+	ioa_cfg->scan_done = 1;
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	kobject_uevent(&ioa_cfg->host->shost_dev.kobj, KOBJ_CHANGE);
 	LEAVE;
@@ -5238,6 +5236,28 @@ static int ipr_cancel_op(struct scsi_cmn
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
@@ -6332,6 +6352,7 @@ static struct scsi_host_template driver_
 	.slave_alloc = ipr_slave_alloc,
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
+	.scan_finished = ipr_scan_finished,
 	.target_alloc = ipr_target_alloc,
 	.target_destroy = ipr_target_destroy,
 	.change_queue_depth = ipr_change_queue_depth,
@@ -6873,7 +6894,7 @@ static int ipr_ioa_reset_done(struct ipr
 	ioa_cfg->doorbell |= IPR_RUNTIME_RESET;
 
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
-		if (ioa_cfg->allow_ml_add_del && (res->add_to_ml || res->del_from_ml)) {
+		if (res->add_to_ml || res->del_from_ml) {
 			ipr_trace;
 			break;
 		}
@@ -6902,6 +6923,7 @@ static int ipr_ioa_reset_done(struct ipr
 	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds)
 		scsi_block_requests(ioa_cfg->host);
 
+	schedule_work(&ioa_cfg->work_q);
 	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
@@ -7642,6 +7664,19 @@ static int ipr_ioafp_page0_inquiry(struc
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
@@ -8829,20 +8864,6 @@ static int ipr_probe_ioa_part2(struct ip
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
@@ -9294,7 +9315,7 @@ static void ipr_init_ioa_cfg(struct ipr_
 					       * ioa_cfg->max_devs_supported)));
 	}
 
-	host->max_channel = IPR_MAX_BUS_TO_SCAN;
+	host->max_channel = IPR_VSET_BUS;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = IPR_MAX_CDB_LEN;
 	host->can_queue = ioa_cfg->max_cmds;
@@ -9793,25 +9814,6 @@ out_scsi_host_put:
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
@@ -9966,10 +9968,6 @@ static int ipr_probe(struct pci_dev *pde
 	}
 
 	scsi_scan_host(ioa_cfg->host);
-	ipr_scan_vsets(ioa_cfg);
-	scsi_add_device(ioa_cfg->host, IPR_IOA_BUS, IPR_IOA_TARGET, IPR_IOA_LUN);
-	ioa_cfg->allow_ml_add_del = 1;
-	ioa_cfg->host->max_channel = IPR_VSET_BUS;
 	ioa_cfg->iopoll_weight = ioa_cfg->chip_cfg->iopoll_weight;
 
 	if (ioa_cfg->iopoll_weight && ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
diff -puN drivers/scsi/ipr.h~ipr_async_scanning_boot drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_async_scanning_boot	2014-06-12 10:17:39.000000000 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2014-07-23 15:52:04.050004860 -0500
@@ -156,13 +156,11 @@
 
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
 
@@ -1452,7 +1450,7 @@ struct ipr_ioa_cfg {
 	u8 in_ioa_bringdown:1;
 	u8 ioa_unit_checked:1;
 	u8 dump_taken:1;
-	u8 allow_ml_add_del:1;
+	u8 scan_done:1;
 	u8 needs_hard_reset:1;
 	u8 dual_raid:1;
 	u8 needs_warm_reset:1;
_

