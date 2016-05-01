From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2.5 1/6] scsi_debug: use pdt constants
Date: Sat, 30 Apr 2016 22:44:42 -0400
Message-ID: <1462070687-12689-2-git-send-email-dgilbert@interlog.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53638 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbcEACo5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Apr 2016 22:44:57 -0400
In-Reply-To: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Use TYPE_* constants for SCSI peripheral device types instead
of numbers. Further cleanups requested by checkpatch.pl .

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 86 +++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6b2d006..fc0246c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -59,8 +59,8 @@
 #include "scsi_logging.h"
 
 /* make sure inq_product_rev string corresponds to this version */
-#define SCSI_DEBUG_VERSION "1.86"
-static const char *sdebug_version_date = "20160422";
+#define SDEBUG_VERSION "1.86"
+static const char *sdebug_version_date = "20160430";
 
 #define MY_NAME "scsi_debug"
 
@@ -123,7 +123,7 @@ static const char *sdebug_version_date = "20160422";
 #define DEF_OPTS   0
 #define DEF_OPT_BLKS 1024
 #define DEF_PHYSBLK_EXP 0
-#define DEF_PTYPE   0
+#define DEF_PTYPE   TYPE_DISK
 #define DEF_REMOVABLE false
 #define DEF_SCSI_LEVEL   6    /* INQUIRY, byte2 [6->SPC-4] */
 #define DEF_SECTOR_SIZE 512
@@ -137,6 +137,8 @@ static const char *sdebug_version_date = "20160422";
 #define DEF_STRICT 0
 #define JDELAY_OVERRIDDEN -9999
 
+#define SDEBUG_LUN_0_VAL 0
+
 /* bit mask values for sdebug_opts */
 #define SDEBUG_OPT_NOISE		1
 #define SDEBUG_OPT_MEDIUM_ERR		2
@@ -232,7 +234,7 @@ static const char *sdebug_version_date = "20160422";
 
 #define SDEBUG_MAX_PARTS 4
 
-#define SCSI_DEBUG_MAX_CMD_LEN 32
+#define SDEBUG_MAX_CMD_LEN 32
 
 
 struct sdebug_dev_info {
@@ -278,8 +280,8 @@ struct sdebug_scmd_extra_t {
 };
 
 struct opcode_info_t {
-	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff
-				 * for terminating element */
+	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff */
+				/* for terminating element */
 	u8 opcode;		/* if num_attached > 0, preferred */
 	u16 sa;			/* service action */
 	u32 flags;		/* OR-ed set of SDEB_F_* */
@@ -571,7 +573,7 @@ static int sdebug_num_tgts = DEF_NUM_TGTS; /* targets per host */
 static int sdebug_opt_blks = DEF_OPT_BLKS;
 static int sdebug_opts = DEF_OPTS;
 static int sdebug_physblk_exp = DEF_PHYSBLK_EXP;
-static int sdebug_ptype = DEF_PTYPE; /* SCSI peripheral type (0==disk) */
+static int sdebug_ptype = DEF_PTYPE; /* SCSI peripheral device type */
 static int sdebug_scsi_level = DEF_SCSI_LEVEL;
 static int sdebug_sector_size = DEF_SECTOR_SIZE;
 static int sdebug_virtual_gb = DEF_VIRTUAL_GB;
@@ -649,7 +651,7 @@ static const int device_qfull_result =
 	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
 
 
-static unsigned int scsi_debug_lbp(void)
+static inline unsigned int scsi_debug_lbp(void)
 {
 	return 0 == sdebug_fake_rw &&
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
@@ -825,7 +827,8 @@ static int make_ua(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			break;
 		case SDEBUG_UA_MICROCODE_CHANGED:
 			mk_sense_buffer(scp, UNIT_ATTENTION,
-				TARGET_CHANGED_ASC, MICROCODE_CHANGED_ASCQ);
+					TARGET_CHANGED_ASC,
+					MICROCODE_CHANGED_ASCQ);
 			if (sdebug_verbose)
 				cp = "microcode has been changed";
 			break;
@@ -1225,11 +1228,11 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
-	have_wlun = (scp->device->lun == SCSI_W_LUN_REPORT_LUNS);
+	have_wlun = scsi_is_wlun(scp->device->lun);
 	if (have_wlun)
-		pq_pdt = 0x1e;	/* present, wlun */
-	else if (sdebug_no_lun_0 && (0 == devip->lun))
-		pq_pdt = 0x7f;	/* not present, no device type */
+		pq_pdt = TYPE_WLUN;	/* present, wlun */
+	else if (sdebug_no_lun_0 && (devip->lun == SDEBUG_LUN_0_VAL))
+		pq_pdt = 0x7f;	/* not present, PQ=3, PDT=0x1f */
 	else
 		pq_pdt = (sdebug_ptype & 0x1f);
 	arr[0] = pq_pdt;
@@ -1244,7 +1247,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		
 		port_group_id = (((host_no + 1) & 0x7f) << 8) +
 		    (devip->channel & 0x7f);
-		if (0 == sdebug_vpd_use_hostno)
+		if (sdebug_vpd_use_hostno == 0)
 			host_no = 0;
 		lu_id_num = have_wlun ? -1 : (((host_no + 1) * 2000) +
 			    (devip->target * 1000) + devip->lun);
@@ -1333,7 +1336,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
 	arr[5] = (int)have_dif_prot;	/* PROTECT bit */
-	if (0 == sdebug_vpd_use_hostno)
+	if (sdebug_vpd_use_hostno == 0)
 		arr[5] = 0x10; /* claim: implicit TGPS */
 	arr[6] = 0x10; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
@@ -1345,9 +1348,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[58] = 0x0; arr[59] = 0xa2;  /* SAM-5 rev 4 */
 	arr[60] = 0x4; arr[61] = 0x68;  /* SPC-4 rev 37 */
 	n = 62;
-	if (sdebug_ptype == 0) {
+	if (sdebug_ptype == TYPE_DISK) {
 		arr[n++] = 0x4; arr[n++] = 0xc5; /* SBC-4 rev 36 */
-	} else if (sdebug_ptype == 1) {
+	} else if (sdebug_ptype == TYPE_TAPE) {
 		arr[n++] = 0x5; arr[n++] = 0x25; /* SSC-4 rev 3 */
 	}
 	arr[n++] = 0x20; arr[n++] = 0xe6;  /* SPL-3 rev 7 */
@@ -1534,7 +1537,7 @@ static int resp_report_tgtpgs(struct scsi_cmnd * scp,
 	 * The asymmetric access state is cycled according to the host_id.
 	 */
 	n = 4;
-	if (0 == sdebug_vpd_use_hostno) {
+	if (sdebug_vpd_use_hostno == 0) {
 		arr[n++] = host_no % 3; /* Asymm access state */
 		arr[n++] = 0x0F; /* claim: all states are supported */
 	} else {
@@ -1938,7 +1941,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	subpcode = cmd[3];
 	msense_6 = (MODE_SENSE == cmd[0]);
 	llbaa = msense_6 ? 0 : !!(cmd[1] & 0x10);
-	if ((0 == sdebug_ptype) && (0 == dbd))
+	if ((sdebug_ptype == TYPE_DISK) && (dbd == 0))
 		bd_len = llbaa ? 16 : 8;
 	else
 		bd_len = 0;
@@ -1950,9 +1953,9 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	}
 	target_dev_id = ((devip->sdbg_host->shost->host_no + 1) * 2000) +
 			(devip->target * 1000) - 3;
-	/* set DPOFUA bit for disks */
-	if (0 == sdebug_ptype)
-		dev_spec = 0x10;	/* would be 0x90 if read-only */
+	/* for disks set DPOFUA bit and clear write protect (WP) bit */
+	if (sdebug_ptype == TYPE_DISK)
+		dev_spec = 0x10;	/* =0x90 if WP=1 implies read-only */
 	else
 		dev_spec = 0x0;
 	if (msense_6) {
@@ -3345,7 +3348,7 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 	spin_lock_irqsave(&queued_arr_lock, iflags);
 	sqcp = &queued_arr[qa_indx];
 	scp = sqcp->a_cmnd;
-	if (unlikely(NULL == scp)) {
+	if (unlikely(scp == NULL)) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		pr_err("scp is NULL\n");
 		return;
@@ -3470,11 +3473,11 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	if (sdebug_verbose)
 		pr_info("slave_configure <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
-	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
-		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
-	if (NULL == devip) {
+	if (sdp->host->max_cmd_len != SDEBUG_MAX_CMD_LEN)
+		sdp->host->max_cmd_len = SDEBUG_MAX_CMD_LEN;
+	if (devip == NULL) {
 		devip = find_build_dev_info(sdp);
-		if (NULL == devip)
+		if (devip == NULL)
 			return 1;  /* no resources, will be marked offline */
 	}
 	sdp->hostdata = devip;
@@ -3528,7 +3531,7 @@ static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
 			sd_dp = sqcp->sd_dp;
 			spin_unlock_irqrestore(&queued_arr_lock,
 					       iflags);
-			if ((sdebug_jdelay > 0) || (sdebug_ndelay > 0)) {
+			if (sdebug_jdelay > 0 || sdebug_ndelay > 0) {
 				if (sd_dp)
 					hrtimer_cancel(&sd_dp->hrt);
 			} else if (sdebug_jdelay < 0) {
@@ -3565,7 +3568,7 @@ static void stop_all_queued(void)
 			sqcp->a_cmnd = NULL;
 			sd_dp = sqcp->sd_dp;
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
-			if ((sdebug_jdelay > 0) || (sdebug_ndelay > 0)) {
+			if (sdebug_jdelay > 0 || sdebug_ndelay > 0) {
 				if (sd_dp)
 					hrtimer_cancel(&sd_dp->hrt);
 			} else if (sdebug_jdelay < 0) {
@@ -3779,8 +3782,8 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	if (unlikely(WARN_ON(!cmnd)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	if (unlikely(NULL == devip)) {
-		if (0 == scsi_result)
+	if (unlikely(devip == NULL)) {
+		if (scsi_result == 0)
 			scsi_result = DID_NO_CONNECT << 16;
 		goto respond_in_thread;
 	}
@@ -3841,7 +3844,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	cmnd->result = scsi_result;
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 	sd_dp = sqcp->sd_dp;
-	if ((delta_jiff > 0) || (sdebug_ndelay > 0)) {
+	if (delta_jiff > 0 || sdebug_ndelay > 0) {
 		ktime_t kt;
 
 		if (delta_jiff > 0) {
@@ -3938,7 +3941,7 @@ module_param_named(write_same_length, sdebug_write_same_length, int,
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(SCSI_DEBUG_VERSION);
+MODULE_VERSION(SDEBUG_VERSION);
 
 MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
@@ -3984,9 +3987,10 @@ static char sdebug_info[256];
 
 static const char * scsi_debug_info(struct Scsi_Host * shp)
 {
-	sprintf(sdebug_info, "scsi_debug, version %s [%s], "
-		"dev_size_mb=%d, opts=0x%x", SCSI_DEBUG_VERSION,
-		sdebug_version_date, sdebug_dev_size_mb, sdebug_opts);
+	sprintf(sdebug_info,
+		"scsi_debug, version %s [%s], dev_size_mb=%d, opts=0x%x",
+		SDEBUG_VERSION, sdebug_version_date, sdebug_dev_size_mb,
+		sdebug_opts);
 	return sdebug_info;
 }
 
@@ -4036,7 +4040,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 		"command aborts=%d; RESETs: device=%d, target=%d, bus=%d, "
 		"host=%d\ndix_reads=%d dix_writes=%d dif_errors=%d "
 		"usec_in_jiffy=%lu\n",
-		SCSI_DEBUG_VERSION, sdebug_version_date,
+		SDEBUG_VERSION, sdebug_version_date,
 		sdebug_num_tgts, sdebug_dev_size_mb, sdebug_opts,
 		sdebug_every_nth, b, sdebug_jdelay, sdebug_ndelay,
 		sdebug_max_luns, atomic_read(&sdebug_completions),
@@ -4064,7 +4068,7 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 {
 	int jdelay, res;
 
-	if ((count > 0) && (1 == sscanf(buf, "%d", &jdelay))) {
+	if (count > 0 && sscanf(buf, "%d", &jdelay) == 1) {
 		res = count;
 		if (sdebug_jdelay != jdelay) {
 			unsigned long iflags;
@@ -4672,7 +4676,7 @@ static int __init scsi_debug_init(void)
 			       (sdebug_sectors_per * sdebug_heads);
 	}
 
-	if (0 == sdebug_fake_rw) {
+	if (sdebug_fake_rw == 0) {
 		fake_storep = vmalloc(sz);
 		if (NULL == fake_storep) {
 			pr_err("out of memory, 1\n");
@@ -5044,8 +5048,8 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		}
 	}
 	if (unlikely(!(F_SKIP_UA & flags) &&
-		     SDEBUG_NUM_UAS != find_first_bit(devip->uas_bm,
-						      SDEBUG_NUM_UAS))) {
+		     find_first_bit(devip->uas_bm,
+				    SDEBUG_NUM_UAS) != SDEBUG_NUM_UAS)) {
 		errsts = make_ua(scp, devip);
 		if (errsts)
 			goto check_cond;
-- 
2.7.4

