From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 1/2] scsi_debug: enable adding more WLUNs
Date: Sun,  1 Mar 2015 23:25:38 +0200
Message-ID: <1425245139-16555-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbCAV0d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Mar 2015 16:26:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Douglas Gilbert <dgilbert@interlog.com>

To add wlun during probe, call sdebug_register_w_lun(WLUN);
prior to setting max luns

hpnt->max_lun = sdebug_max_luns();

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/scsi_debug.c | 105 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 82 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0825c0a62a33..5d1bb12adc43 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -683,6 +683,51 @@ static struct sd_dif_tuple *dif_store(sector_t sector)
 	return dif_storep + sector;
 }
 
+#define  SCSI_W_LUN_MAX 10
+static u8 scsi_debug_w_luns[SCSI_W_LUN_MAX];
+static int scsi_debug_w_luns_count;
+
+static void sdebug_register_w_lun(u8 w_lun_idx)
+{
+	if (WARN_ON(scsi_debug_w_luns_count >= SCSI_W_LUN_MAX))
+		return;
+
+	scsi_debug_w_luns[scsi_debug_w_luns_count++] = w_lun_idx;
+}
+
+static int sdebug_add_w_luns(struct Scsi_Host *hpnt)
+{
+	u64 lun;
+	int i;
+	int ret = 0;
+
+	/* i = 1 skip REPORT LUNS */
+	for (i = 1; i < scsi_debug_w_luns_count; i++) {
+		lun = SCSI_W_LUN_BASE | scsi_debug_w_luns[i];
+		ret = scsi_add_device(hpnt, 0, 0, lun);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static u64 sdebug_max_luns(void)
+{
+	u64 max_w_lun;
+	int i;
+
+	max_w_lun = scsi_debug_w_luns[0];
+
+	for (i = 1; i < scsi_debug_w_luns_count; i++) {
+		if (scsi_debug_w_luns[i] > max_w_lun)
+			max_w_lun = scsi_debug_w_luns[i];
+	}
+
+	return SCSI_W_LUN_BASE + max_w_lun + 1;
+}
+
+
 static int sdebug_add_adapter(void);
 static void sdebug_remove_adapter(void);
 
@@ -699,8 +744,8 @@ static void sdebug_max_tgts_luns(void)
 			hpnt->max_id = scsi_debug_num_tgts + 1;
 		else
 			hpnt->max_id = scsi_debug_num_tgts;
-		/* scsi_debug_max_luns; */
-		hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
+
+		hpnt->max_lun = sdebug_max_luns();
 	}
 	spin_unlock(&sdebug_host_list_lock);
 }
@@ -1284,20 +1329,22 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned char * arr;
 	unsigned char *cmd = scp->cmnd;
 	int alloc_len, n, ret;
-	bool have_wlun;
+	bool is_wlun;
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
-	have_wlun = (scp->device->lun == SCSI_W_LUN_REPORT_LUNS);
-	if (have_wlun)
-		pq_pdt = 0x1e;	/* present, wlun */
+
+	is_wlun = scsi_is_wlun(scp->device->lun);
+	if (is_wlun)
+		pq_pdt = TYPE_WLUN;
 	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
-		pq_pdt = 0x7f;	/* not present, no device type */
+		pq_pdt = TYPE_NO_LUN;	/* not present, no device type */
 	else
 		pq_pdt = (scsi_debug_ptype & 0x1f);
 	arr[0] = pq_pdt;
+
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 1);
 		kfree(arr);
@@ -1311,7 +1358,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		    (devip->channel & 0x7f);
 		if (0 == scsi_debug_vpd_use_hostno)
 			host_no = 0;
-		lu_id_num = have_wlun ? -1 : (((host_no + 1) * 2000) +
+		lu_id_num = is_wlun ? -1 : (((host_no + 1) * 2000) +
 			    (devip->target * 1000) + devip->lun);
 		target_dev_id = ((host_no + 1) * 2000) +
 				 (devip->target * 1000) - 3;
@@ -3369,7 +3416,7 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 
 	/* report w_lun */
 	if (select_report == 0x01 || select_report == 0x02)
-		wlun_cnt = 1;
+		wlun_cnt = scsi_debug_w_luns_count;
 
 	rlun_cnt = lun_cnt + wlun_cnt;
 
@@ -3401,9 +3448,11 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 	for (i = 0; i < lun_cnt; i++)
 		int_to_scsilun(lun++, one_lun++);
 
-	/* report SCSI_W_LUN_REPORT_LUN */
-	if (wlun_cnt)
-		int_to_scsilun(SCSI_W_LUN_REPORT_LUNS, one_lun++);
+	/* report WLUNs*/
+	for (i = 0; i < wlun_cnt; i++) {
+		lun = SCSI_W_LUN_BASE | scsi_debug_w_luns[i];
+		int_to_scsilun(lun, one_lun++);
+	}
 
 	rlen = rlun_cnt * sizeof(struct scsi_lun);
 
@@ -5183,7 +5232,7 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 	u32 flags;
 	u16 sa;
 	u8 opcode = cmd[0];
-	bool has_wlun_rl;
+	bool is_wlun;
 	bool debug = !!(SCSI_DEBUG_OPT_NOISE & scsi_debug_opts);
 
 	scsi_set_resid(scp, 0);
@@ -5202,8 +5251,8 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 		}
 		sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name, b);
 	}
-	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
-	if ((sdp->lun >= scsi_debug_max_luns) && !has_wlun_rl)
+	is_wlun = scsi_is_wlun(sdp->lun);
+	if ((sdp->lun >= scsi_debug_max_luns) && !is_wlun)
 		return schedule_resp(scp, NULL, errsts_no_connect, 0);
 
 	sdeb_i = opcode_ind_arr[opcode];	/* fully mapped */
@@ -5248,7 +5297,7 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 		mk_sense_invalid_opcode(scp);
 		goto check_cond;
 	}
-	if (has_wlun_rl && !(F_RL_WLUN_OK & flags)) {
+	if (is_wlun && !(F_RL_WLUN_OK & flags)) {
 		if (debug)
 			sdev_printk(KERN_INFO, sdp, "scsi_debug: Opcode: "
 				    "0x%x not supported for wlun\n", opcode);
@@ -5356,7 +5405,6 @@ static int sdebug_driver_probe(struct device * dev)
 	int host_prot;
 
 	sdbg_host = to_sdebug_host(dev);
-
 	sdebug_driver_template.can_queue = scsi_debug_max_queue;
 	if (scsi_debug_clustering)
 		sdebug_driver_template.use_clustering = ENABLE_CLUSTERING;
@@ -5367,14 +5415,18 @@ static int sdebug_driver_probe(struct device * dev)
 		return error;
 	}
 
+
         sdbg_host->shost = hpnt;
 	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
 	if ((hpnt->this_id >= 0) && (scsi_debug_num_tgts > hpnt->this_id))
 		hpnt->max_id = scsi_debug_num_tgts + 1;
 	else
 		hpnt->max_id = scsi_debug_num_tgts;
-	/* = scsi_debug_max_luns; */
-	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
+
+	/* REPORT LUNS */
+	sdebug_register_w_lun(0x01);
+
+	hpnt->max_lun = sdebug_max_luns();
 
 	host_prot = 0;
 
@@ -5435,11 +5487,18 @@ static int sdebug_driver_probe(struct device * dev)
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
 		pr_err("scsi_add_host failed\n");
-                error = -ENODEV;
-		scsi_host_put(hpnt);
-        } else
-		scsi_scan_host(hpnt);
+		error = -ENODEV;
+		goto err;
+	}
+
+	scsi_scan_host(hpnt);
+
+	error = sdebug_add_w_luns(hpnt);
+	if (error)
+		scsi_remove_host(hpnt);
 
+err:
+	scsi_host_put(hpnt);
 	return error;
 }
 
-- 
1.9.3

