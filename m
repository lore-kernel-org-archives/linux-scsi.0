From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 07/12] scsi_debug: use likely hints on fast path
Date: Mon, 25 Apr 2016 12:16:34 -0400
Message-ID: <1461600999-28893-8-git-send-email-dgilbert@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36984 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbcDYQRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:17:02 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

The most common commands in normal use are the READ and WRITE SCSI
commands. Use likely and unlikely hints along the path taken by
these commands. Rename check_readiness() to make_ua() and remove
associated dead code. Rename devInfoReg() to find_build_dev_info().

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 219 ++++++++++++++++++++++------------------------
 1 file changed, 105 insertions(+), 114 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 349eaeb..cf44ab0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -190,10 +190,6 @@ static const char *sdebug_version_date = "20160422";
 #define SDEBUG_UA_MICROCODE_CHANGED_WO_RESET 6
 #define SDEBUG_NUM_UAS 7
 
-/* for check_readiness() */
-#define UAS_ONLY 1	/* check for UAs only */
-#define UAS_TUR 0	/* if no UAs then check if media access possible */
-
 /* when 1==SDEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
  * sector on read commands: */
 #define OPT_MEDIUM_ERR_ADDR   0x1234 /* that's sector 4660 in decimal */
@@ -595,6 +591,7 @@ static bool sdebug_host_lock = DEF_HOST_LOCK;
 static bool sdebug_strict = DEF_STRICT;
 static bool sdebug_any_injecting_opt;
 static bool sdebug_verbose;
+static bool have_dif_prot;
 
 static atomic_t sdebug_cmnd_count;
 static atomic_t sdebug_completions;
@@ -793,8 +790,7 @@ static void clear_luns_changed_on_target(struct sdebug_dev_info *devip)
 	spin_unlock(&sdebug_host_list_lock);
 }
 
-static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
-			   struct sdebug_dev_info * devip)
+static int make_ua(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	int k;
 
@@ -804,37 +800,37 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 
 		switch (k) {
 		case SDEBUG_UA_POR:
-			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
-					UA_RESET_ASC, POWER_ON_RESET_ASCQ);
+			mk_sense_buffer(scp, UNIT_ATTENTION, UA_RESET_ASC,
+					POWER_ON_RESET_ASCQ);
 			if (sdebug_verbose)
 				cp = "power on reset";
 			break;
 		case SDEBUG_UA_BUS_RESET:
-			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
-					UA_RESET_ASC, BUS_RESET_ASCQ);
+			mk_sense_buffer(scp, UNIT_ATTENTION, UA_RESET_ASC,
+					BUS_RESET_ASCQ);
 			if (sdebug_verbose)
 				cp = "bus reset";
 			break;
 		case SDEBUG_UA_MODE_CHANGED:
-			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
-					UA_CHANGED_ASC, MODE_CHANGED_ASCQ);
+			mk_sense_buffer(scp, UNIT_ATTENTION, UA_CHANGED_ASC,
+					MODE_CHANGED_ASCQ);
 			if (sdebug_verbose)
 				cp = "mode parameters changed";
 			break;
 		case SDEBUG_UA_CAPACITY_CHANGED:
-			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
-					UA_CHANGED_ASC, CAPACITY_CHANGED_ASCQ);
+			mk_sense_buffer(scp, UNIT_ATTENTION, UA_CHANGED_ASC,
+					CAPACITY_CHANGED_ASCQ);
 			if (sdebug_verbose)
 				cp = "capacity data changed";
 			break;
 		case SDEBUG_UA_MICROCODE_CHANGED:
-			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
-				 TARGET_CHANGED_ASC, MICROCODE_CHANGED_ASCQ);
+			mk_sense_buffer(scp, UNIT_ATTENTION,
+				TARGET_CHANGED_ASC, MICROCODE_CHANGED_ASCQ);
 			if (sdebug_verbose)
 				cp = "microcode has been changed";
 			break;
 		case SDEBUG_UA_MICROCODE_CHANGED_WO_RESET:
-			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+			mk_sense_buffer(scp, UNIT_ATTENTION,
 					TARGET_CHANGED_ASC,
 					MICROCODE_CHANGED_WO_RESET_ASCQ);
 			if (sdebug_verbose)
@@ -851,7 +847,7 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 			 */
 			if (sdebug_scsi_level >= 6)	/* SPC-4 and above */
 				clear_luns_changed_on_target(devip);
-			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+			mk_sense_buffer(scp, UNIT_ATTENTION,
 					TARGET_CHANGED_ASC,
 					LUNS_CHANGED_ASCQ);
 			if (sdebug_verbose)
@@ -865,20 +861,11 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 		}
 		clear_bit(k, devip->uas_bm);
 		if (sdebug_verbose)
-			sdev_printk(KERN_INFO, SCpnt->device,
+			sdev_printk(KERN_INFO, scp->device,
 				   "%s reports: Unit attention: %s\n",
 				   my_name, cp);
 		return check_condition_result;
 	}
-	if ((UAS_TUR == uas_only) && devip->stopped) {
-		mk_sense_buffer(SCpnt, NOT_READY, LOGICAL_UNIT_NOT_READY,
-				0x2);
-		if (sdebug_verbose)
-			sdev_printk(KERN_INFO, SCpnt->device,
-				    "%s reports: Not ready: %s\n", my_name,
-				    "initializing command required");
-		return check_condition_result;
-	}
 	return 0;
 }
 
@@ -1345,7 +1332,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[2] = sdebug_scsi_level;
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
-	arr[5] = sdebug_dif ? 1 : 0; /* PROTECT bit */
+	arr[5] = (int)have_dif_prot;	/* PROTECT bit */
 	if (0 == sdebug_vpd_use_hostno)
 		arr[5] = 0x10; /* claim: implicit TGPS */
 	arr[6] = 0x10; /* claim: MultiP */
@@ -2506,7 +2493,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		check_prot = false;
 		break;
 	}
-	if (check_prot) {
+	if (unlikely(have_dif_prot && check_prot)) {
 		if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
 		    (cmd[1] & 0xe0)) {
 			mk_sense_invalid_opcode(scp);
@@ -2518,7 +2505,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected RD "
 				    "to DIF device\n");
 	}
-	if (sdebug_any_injecting_opt) {
+	if (unlikely(sdebug_any_injecting_opt)) {
 		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
 
 		if (ep->inj_short)
@@ -2526,20 +2513,20 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 
 	/* inline check_device_access_params() */
-	if (lba + num > sdebug_capacity) {
+	if (unlikely(lba + num > sdebug_capacity)) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		return check_condition_result;
 	}
 	/* transfer length excessive (tie in to block limits VPD page) */
-	if (num > sdebug_store_sectors) {
+	if (unlikely(num > sdebug_store_sectors)) {
 		/* needs work to find which cdb byte 'num' comes from */
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
 	}
 
-	if ((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
-	    (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
-	    ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
+	if (unlikely((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
+		     (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
+		     ((lba + num) > OPT_MEDIUM_ERR_ADDR))) {
 		/* claim unrecoverable read error */
 		mk_sense_buffer(scp, MEDIUM_ERROR, UNRECOVERED_READ_ERR, 0);
 		/* set info field and valid bit for fixed descriptor */
@@ -2556,7 +2543,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	read_lock_irqsave(&atomic_rw, iflags);
 
 	/* DIX + T10 DIF */
-	if (sdebug_dix && scsi_prot_sg_count(scp)) {
+	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
@@ -2568,12 +2555,12 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	ret = do_device_access(scp, lba, num, false);
 	read_unlock_irqrestore(&atomic_rw, iflags);
-	if (ret == -1)
+	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
 	scsi_in(scp)->resid = scsi_bufflen(scp) - ret;
 
-	if (sdebug_any_injecting_opt) {
+	if (unlikely(sdebug_any_injecting_opt)) {
 		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
 
 		if (ep->inj_recovered) {
@@ -2817,7 +2804,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		check_prot = false;
 		break;
 	}
-	if (check_prot) {
+	if (unlikely(have_dif_prot && check_prot)) {
 		if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
 		    (cmd[1] & 0xe0)) {
 			mk_sense_invalid_opcode(scp);
@@ -2831,12 +2818,12 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 
 	/* inline check_device_access_params() */
-	if (lba + num > sdebug_capacity) {
+	if (unlikely(lba + num > sdebug_capacity)) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		return check_condition_result;
 	}
 	/* transfer length excessive (tie in to block limits VPD page) */
-	if (num > sdebug_store_sectors) {
+	if (unlikely(num > sdebug_store_sectors)) {
 		/* needs work to find which cdb byte 'num' comes from */
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
@@ -2845,7 +2832,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	write_lock_irqsave(&atomic_rw, iflags);
 
 	/* DIX + T10 DIF */
-	if (sdebug_dix && scsi_prot_sg_count(scp)) {
+	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
@@ -2856,17 +2843,17 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 
 	ret = do_device_access(scp, lba, num, true);
-	if (scsi_debug_lbp())
+	if (unlikely(scsi_debug_lbp()))
 		map_region(lba, num);
 	write_unlock_irqrestore(&atomic_rw, iflags);
-	if (-1 == ret)
+	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (sdebug_verbose && (ret < (num * sdebug_sector_size)))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num * sdebug_sector_size, ret);
 
-	if (sdebug_any_injecting_opt) {
+	if (unlikely(sdebug_any_injecting_opt)) {
 		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
 
 		if (ep->inj_recovered) {
@@ -3351,28 +3338,28 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 
 	atomic_inc(&sdebug_completions);
 	qa_indx = sd_dp->qa_indx;
-	if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
+	if (unlikely((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE))) {
 		pr_err("wild qa_indx=%d\n", qa_indx);
 		return;
 	}
 	spin_lock_irqsave(&queued_arr_lock, iflags);
 	sqcp = &queued_arr[qa_indx];
 	scp = sqcp->a_cmnd;
-	if (NULL == scp) {
+	if (unlikely(NULL == scp)) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		pr_err("scp is NULL\n");
 		return;
 	}
 	devip = (struct sdebug_dev_info *)scp->device->hostdata;
-	if (devip)
+	if (likely(devip))
 		atomic_dec(&devip->num_in_q);
 	else
 		pr_err("devip=NULL\n");
-	if (atomic_read(&retired_max_queue) > 0)
+	if (unlikely(atomic_read(&retired_max_queue) > 0))
 		retiring = 1;
 
 	sqcp->a_cmnd = NULL;
-	if (!test_and_clear_bit(qa_indx, queued_in_use_bm)) {
+	if (unlikely(!test_and_clear_bit(qa_indx, queued_in_use_bm))) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		pr_err("Unexpected completion\n");
 		return;
@@ -3427,15 +3414,12 @@ static struct sdebug_dev_info *sdebug_device_create(
 	return devip;
 }
 
-static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
+static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
 {
-	struct sdebug_host_info * sdbg_host;
-	struct sdebug_dev_info * open_devip = NULL;
-	struct sdebug_dev_info * devip =
-			(struct sdebug_dev_info *)sdev->hostdata;
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *open_devip = NULL;
+	struct sdebug_dev_info *devip;
 
-	if (devip)
-		return devip;
 	sdbg_host = *(struct sdebug_host_info **)shost_priv(sdev->host);
 	if (!sdbg_host) {
 		pr_err("Host info NULL\n");
@@ -3480,16 +3464,19 @@ static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 
 static int scsi_debug_slave_configure(struct scsi_device *sdp)
 {
-	struct sdebug_dev_info *devip;
+	struct sdebug_dev_info *devip =
+			(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (sdebug_verbose)
 		pr_info("slave_configure <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
-	devip = devInfoReg(sdp);
-	if (NULL == devip)
-		return 1;	/* no resources, will be marked offline */
+	if (NULL == devip) {
+		devip = find_build_dev_info(sdp);
+		if (NULL == devip)
+			return 1;  /* no resources, will be marked offline */
+	}
 	sdp->hostdata = devip;
 	blk_queue_max_segment_size(sdp->request_queue, -1U);
 	if (sdebug_no_uld)
@@ -3622,15 +3609,14 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 
 static int scsi_debug_device_reset(struct scsi_cmnd * SCpnt)
 {
-	struct sdebug_dev_info * devip;
-
 	++num_dev_resets;
 	if (SCpnt && SCpnt->device) {
 		struct scsi_device *sdp = SCpnt->device;
+		struct sdebug_dev_info *devip =
+				(struct sdebug_dev_info *)sdp->hostdata;
 
 		if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
 			sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
-		devip = devInfoReg(sdp);
 		if (devip)
 			set_bit(SDEBUG_UA_POR, devip->uas_bm);
 	}
@@ -3790,19 +3776,18 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	struct scsi_device *sdp;
 	struct sdebug_defer *sd_dp;
 
-	/* this should never happen */
-	if (WARN_ON(!cmnd))
+	if (unlikely(WARN_ON(!cmnd)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	if (NULL == devip) {
-		pr_warn("called devip == NULL\n");
-		/* no particularly good error to report back */
-		return SCSI_MLQUEUE_HOST_BUSY;
+	if (unlikely(NULL == devip)) {
+		if (0 == scsi_result)
+			scsi_result = DID_NO_CONNECT << 16;
+		goto respond_in_thread;
 	}
 
 	sdp = cmnd->device;
 
-	if (sdebug_verbose && scsi_result)
+	if (unlikely(sdebug_verbose && scsi_result))
 		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
 			    __func__, scsi_result);
 	if (delta_jiff == 0)
@@ -3813,15 +3798,15 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	num_in_q = atomic_read(&devip->num_in_q);
 	qdepth = cmnd->device->queue_depth;
 	inject = 0;
-	if ((qdepth > 0) && (num_in_q >= qdepth)) {
+	if (unlikely((qdepth > 0) && (num_in_q >= qdepth))) {
 		if (scsi_result) {
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
 			goto respond_in_thread;
 		} else
 			scsi_result = device_qfull_result;
-	} else if ((sdebug_every_nth != 0) &&
-		   (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
-		   (scsi_result == 0)) {
+	} else if (unlikely((sdebug_every_nth != 0) &&
+			    (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
+			    (scsi_result == 0))) {
 		if ((num_in_q == (qdepth - 1)) &&
 		    (atomic_inc_return(&sdebug_a_tsf) >=
 		     abs(sdebug_every_nth))) {
@@ -3832,7 +3817,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	}
 
 	k = find_first_zero_bit(queued_in_use_bm, sdebug_max_queue);
-	if (k >= sdebug_max_queue) {
+	if (unlikely(k >= sdebug_max_queue)) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		if (scsi_result)
 			goto respond_in_thread;
@@ -3888,8 +3873,8 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		}
 		schedule_work(&sd_dp->ew.work);
 	}
-	if ((SDEBUG_OPT_Q_NOISE & sdebug_opts) &&
-	    (scsi_result == device_qfull_result))
+	if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) &&
+		     (scsi_result == device_qfull_result)))
 		sdev_printk(KERN_INFO, sdp,
 			    "%s: num_in_q=%d +1, %s%s\n", __func__,
 			    num_in_q, (inject ? "<inject> " : ""),
@@ -4632,9 +4617,11 @@ static int __init scsi_debug_init(void)
 	switch (sdebug_dif) {
 
 	case SD_DIF_TYPE0_PROTECTION:
+		break;
 	case SD_DIF_TYPE1_PROTECTION:
 	case SD_DIF_TYPE2_PROTECTION:
 	case SD_DIF_TYPE3_PROTECTION:
+		have_dif_prot = true;
 		break;
 
 	default:
@@ -4971,7 +4958,8 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	bool has_wlun_rl;
 
 	scsi_set_resid(scp, 0);
-	if (sdebug_verbose && !(SDEBUG_OPT_NO_CDB_NOISE & sdebug_opts)) {
+	if (unlikely(sdebug_verbose &&
+		     !(SDEBUG_OPT_NO_CDB_NOISE & sdebug_opts))) {
 		char b[120];
 		int n, len, sb;
 
@@ -4987,17 +4975,16 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name, b);
 	}
 	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
-	if ((sdp->lun >= sdebug_max_luns) && !has_wlun_rl)
-		return schedule_resp(scp, NULL, DID_NO_CONNECT << 16, 0);
+	if (unlikely((sdp->lun >= sdebug_max_luns) && !has_wlun_rl))
+		goto err_out;
 
 	sdeb_i = opcode_ind_arr[opcode];	/* fully mapped */
 	oip = &opcode_info_arr[sdeb_i];		/* safe if table consistent */
 	devip = (struct sdebug_dev_info *)sdp->hostdata;
-	if (!devip) {
-		devip = devInfoReg(sdp);
+	if (unlikely(!devip)) {
+		devip = find_build_dev_info(sdp);
 		if (NULL == devip)
-			return schedule_resp(scp, NULL, DID_NO_CONNECT << 16,
-					     0);
+			goto err_out;
 	}
 	na = oip->num_attached;
 	r_pfp = oip->pfp;
@@ -5029,18 +5016,18 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		}
 	}	/* else (when na==0) we assume the oip is a match */
 	flags = oip->flags;
-	if (F_INV_OP & flags) {
+	if (unlikely(F_INV_OP & flags)) {
 		mk_sense_invalid_opcode(scp);
 		goto check_cond;
 	}
-	if (has_wlun_rl && !(F_RL_WLUN_OK & flags)) {
+	if (unlikely(has_wlun_rl && !(F_RL_WLUN_OK & flags))) {
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, sdp, "%s: Opcode 0x%x not%s\n",
 				    my_name, opcode, " supported for wlun");
 		mk_sense_invalid_opcode(scp);
 		goto check_cond;
 	}
-	if (sdebug_strict) {	/* check cdb against mask */
+	if (unlikely(sdebug_strict)) {	/* check cdb against mask */
 		u8 rem;
 		int j;
 
@@ -5056,13 +5043,14 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 			}
 		}
 	}
-	if (!(F_SKIP_UA & flags) &&
-	    SDEBUG_NUM_UAS != find_first_bit(devip->uas_bm, SDEBUG_NUM_UAS)) {
-		errsts = check_readiness(scp, UAS_ONLY, devip);
+	if (unlikely(!(F_SKIP_UA & flags) &&
+		     SDEBUG_NUM_UAS != find_first_bit(devip->uas_bm,
+						      SDEBUG_NUM_UAS))) {
+		errsts = make_ua(scp, devip);
 		if (errsts)
 			goto check_cond;
 	}
-	if ((F_M_ACCESS & flags) && devip->stopped) {
+	if (unlikely((F_M_ACCESS & flags) && devip->stopped)) {
 		mk_sense_buffer(scp, NOT_READY, LOGICAL_UNIT_NOT_READY, 0x2);
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, sdp, "%s reports: Not ready: "
@@ -5073,12 +5061,12 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	}
 	if (sdebug_fake_rw && (F_FAKE_RW & flags))
 		goto fini;
-	if (sdebug_every_nth) {
+	if (unlikely(sdebug_every_nth)) {
 		if (check_inject(scp))
 			return 0;	/* ignore command: make trouble */
 	}
-	if (oip->pfp)	/* if this command has a resp_* function, call it */
-		errsts = oip->pfp(scp, devip);
+	if (likely(oip->pfp))
+		errsts = oip->pfp(scp, devip);	/* calls a resp_* function */
 	else if (r_pfp)	/* if leaf function ptr NULL, try the root's */
 		errsts = r_pfp(scp, devip);
 
@@ -5087,6 +5075,8 @@ fini:
 			     ((F_DELAY_OVERR & flags) ? 0 : sdebug_jdelay));
 check_cond:
 	return schedule_resp(scp, devip, check_condition_result, 0);
+err_out:
+	return schedule_resp(scp, NULL, DID_NO_CONNECT << 16, 0);
 }
 
 static struct scsi_host_template sdebug_driver_template = {
@@ -5122,7 +5112,7 @@ static int sdebug_driver_probe(struct device * dev)
 	int error = 0;
 	struct sdebug_host_info *sdbg_host;
 	struct Scsi_Host *hpnt;
-	int host_prot;
+	int hprot;
 
 	sdbg_host = to_sdebug_host(dev);
 
@@ -5145,44 +5135,45 @@ static int sdebug_driver_probe(struct device * dev)
 	/* = sdebug_max_luns; */
 	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
 
-	host_prot = 0;
+	hprot = 0;
 
 	switch (sdebug_dif) {
 
 	case SD_DIF_TYPE1_PROTECTION:
-		host_prot = SHOST_DIF_TYPE1_PROTECTION;
+		hprot = SHOST_DIF_TYPE1_PROTECTION;
 		if (sdebug_dix)
-			host_prot |= SHOST_DIX_TYPE1_PROTECTION;
+			hprot |= SHOST_DIX_TYPE1_PROTECTION;
 		break;
 
 	case SD_DIF_TYPE2_PROTECTION:
-		host_prot = SHOST_DIF_TYPE2_PROTECTION;
+		hprot = SHOST_DIF_TYPE2_PROTECTION;
 		if (sdebug_dix)
-			host_prot |= SHOST_DIX_TYPE2_PROTECTION;
+			hprot |= SHOST_DIX_TYPE2_PROTECTION;
 		break;
 
 	case SD_DIF_TYPE3_PROTECTION:
-		host_prot = SHOST_DIF_TYPE3_PROTECTION;
+		hprot = SHOST_DIF_TYPE3_PROTECTION;
 		if (sdebug_dix)
-			host_prot |= SHOST_DIX_TYPE3_PROTECTION;
+			hprot |= SHOST_DIX_TYPE3_PROTECTION;
 		break;
 
 	default:
 		if (sdebug_dix)
-			host_prot |= SHOST_DIX_TYPE0_PROTECTION;
+			hprot |= SHOST_DIX_TYPE0_PROTECTION;
 		break;
 	}
 
-	scsi_host_set_prot(hpnt, host_prot);
+	scsi_host_set_prot(hpnt, hprot);
 
-	pr_info("host protection%s%s%s%s%s%s%s\n",
-	       (host_prot & SHOST_DIF_TYPE1_PROTECTION) ? " DIF1" : "",
-	       (host_prot & SHOST_DIF_TYPE2_PROTECTION) ? " DIF2" : "",
-	       (host_prot & SHOST_DIF_TYPE3_PROTECTION) ? " DIF3" : "",
-	       (host_prot & SHOST_DIX_TYPE0_PROTECTION) ? " DIX0" : "",
-	       (host_prot & SHOST_DIX_TYPE1_PROTECTION) ? " DIX1" : "",
-	       (host_prot & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
-	       (host_prot & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
+	if (have_dif_prot || sdebug_dix)
+		pr_info("host protection%s%s%s%s%s%s%s\n",
+			(hprot & SHOST_DIF_TYPE1_PROTECTION) ? " DIF1" : "",
+			(hprot & SHOST_DIF_TYPE2_PROTECTION) ? " DIF2" : "",
+			(hprot & SHOST_DIF_TYPE3_PROTECTION) ? " DIF3" : "",
+			(hprot & SHOST_DIX_TYPE0_PROTECTION) ? " DIX0" : "",
+			(hprot & SHOST_DIX_TYPE1_PROTECTION) ? " DIX1" : "",
+			(hprot & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
+			(hprot & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
 
 	if (sdebug_guard == 1)
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_IP);
-- 
2.7.4

