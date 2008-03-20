From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/5] scsi_debug: remove unnecessary function declarations
Date: Thu, 20 Mar 2008 11:09:19 +0900
Message-ID: <1205978959-30510-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205978959-30510-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205978959-30510-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205978959-30510-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205978959-30510-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:52755 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbYCTCKJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 22:10:09 -0400
In-Reply-To: <1205978959-30510-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

This patch removes lots of function declarations with moving
scsi_debug_queuecommand. This cleans up scsi_debug_queuecommand a bit
to silence checkpatch.pl

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |  507 +++++++++++++++++++++------------------------
 1 files changed, 233 insertions(+), 274 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 681b591..4f4c5b7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -235,56 +235,11 @@ static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
 			           0, 0, 0x0, 0x0};
 
-/* function declarations */
-static int resp_inquiry(struct scsi_cmnd * SCpnt, int target,
-			struct sdebug_dev_info * devip);
-static int resp_requests(struct scsi_cmnd * SCpnt,
-			 struct sdebug_dev_info * devip);
-static int resp_start_stop(struct scsi_cmnd * scp,
-			   struct sdebug_dev_info * devip);
-static int resp_report_tgtpgs(struct scsi_cmnd * scp,
-			      struct sdebug_dev_info * devip);
-static int resp_readcap(struct scsi_cmnd * SCpnt,
-			struct sdebug_dev_info * devip);
-static int resp_readcap16(struct scsi_cmnd * SCpnt,
-			  struct sdebug_dev_info * devip);
-static int resp_mode_sense(struct scsi_cmnd * scp, int target,
-			   struct sdebug_dev_info * devip);
-static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
-			    struct sdebug_dev_info * devip);
-static int resp_log_sense(struct scsi_cmnd * scp,
-			  struct sdebug_dev_info * devip);
-static int resp_read(struct scsi_cmnd * SCpnt, unsigned long long lba,
-		     unsigned int num, struct sdebug_dev_info * devip);
-static int resp_write(struct scsi_cmnd * SCpnt, unsigned long long lba,
-		      unsigned int num, struct sdebug_dev_info * devip);
-static int resp_report_luns(struct scsi_cmnd * SCpnt,
-			    struct sdebug_dev_info * devip);
-static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
-			    unsigned int num, struct sdebug_dev_info *devip);
-static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
-                                int arr_len);
-static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
-                               int max_arr_len);
-static void timer_intr_handler(unsigned long);
 static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev);
 static void mk_sense_buffer(struct sdebug_dev_info * devip, int key,
 			    int asc, int asq);
-static int check_readiness(struct scsi_cmnd * SCpnt, int reset_only,
-			   struct sdebug_dev_info * devip);
-static int schedule_resp(struct scsi_cmnd * cmnd,
-			 struct sdebug_dev_info * devip,
-			 done_funct_t done, int scsi_result, int delta_jiff);
-static void __init sdebug_build_parts(unsigned char * ramp);
-static void __init init_all_queued(void);
 static void stop_all_queued(void);
 static int stop_queued_cmnd(struct scsi_cmnd * cmnd);
-static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
-			   int target_dev_id, int dev_id_num,
-			   const char * dev_id_str, int dev_id_str_len);
-static int inquiry_evpd_88(unsigned char * arr, int target_dev_id);
-static int do_create_driverfs_files(void);
-static void do_remove_driverfs_files(void);
 
 static int sdebug_add_adapter(void);
 static void sdebug_remove_adapter(void);
@@ -330,235 +285,6 @@ static void get_data_transfer_info(unsigned char *cmd,
 	}
 }
 
-static
-int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
-{
-	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
-	int len, k;
-	unsigned int num;
-	unsigned long long lba;
-	int errsts = 0;
-	int target = SCpnt->device->id;
-	struct sdebug_dev_info * devip = NULL;
-	int inj_recovered = 0;
-	int inj_transport = 0;
-	int delay_override = 0;
-
-	scsi_set_resid(SCpnt, 0);
-	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmd) {
-		printk(KERN_INFO "scsi_debug: cmd ");
-		for (k = 0, len = SCpnt->cmd_len; k < len; ++k)
-			printk("%02x ", (int)cmd[k]);
-		printk("\n");
-	}
-
-	if (target == SCpnt->device->host->hostt->this_id) {
-		printk(KERN_INFO "scsi_debug: initiator's id used as "
-		       "target!\n");
-		return schedule_resp(SCpnt, NULL, done,
-				     DID_NO_CONNECT << 16, 0);
-        }
-
-	if ((SCpnt->device->lun >= scsi_debug_max_luns) &&
-	    (SCpnt->device->lun != SAM2_WLUN_REPORT_LUNS))
-		return schedule_resp(SCpnt, NULL, done,
-				     DID_NO_CONNECT << 16, 0);
-	devip = devInfoReg(SCpnt->device);
-	if (NULL == devip)
-		return schedule_resp(SCpnt, NULL, done,
-				     DID_NO_CONNECT << 16, 0);
-
-        if ((scsi_debug_every_nth != 0) &&
-            (++scsi_debug_cmnd_count >= abs(scsi_debug_every_nth))) {
-                scsi_debug_cmnd_count = 0;
-		if (scsi_debug_every_nth < -1)
-			scsi_debug_every_nth = -1;
-		if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
-			return 0; /* ignore command causing timeout */
-		else if (SCSI_DEBUG_OPT_RECOVERED_ERR & scsi_debug_opts)
-			inj_recovered = 1; /* to reads and writes below */
-		else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & scsi_debug_opts)
-			inj_transport = 1; /* to reads and writes below */
-        }
-
-	if (devip->wlun) {
-		switch (*cmd) {
-		case INQUIRY:
-		case REQUEST_SENSE:
-		case TEST_UNIT_READY:
-		case REPORT_LUNS:
-			break;  /* only allowable wlun commands */
-		default:
-			if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-				printk(KERN_INFO "scsi_debug: Opcode: 0x%x "
-				       "not supported for wlun\n", *cmd);
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
-					INVALID_OPCODE, 0);
-			errsts = check_condition_result;
-			return schedule_resp(SCpnt, devip, done, errsts,
-					     0);
-		}
-	}
-
-	switch (*cmd) {
-	case INQUIRY:     /* mandatory, ignore unit attention */
-		delay_override = 1;
-		errsts = resp_inquiry(SCpnt, target, devip);
-		break;
-	case REQUEST_SENSE:	/* mandatory, ignore unit attention */
-		delay_override = 1;
-		errsts = resp_requests(SCpnt, devip);
-		break;
-	case REZERO_UNIT:	/* actually this is REWIND for SSC */
-	case START_STOP:
-		errsts = resp_start_stop(SCpnt, devip);
-		break;
-	case ALLOW_MEDIUM_REMOVAL:
-		if ((errsts = check_readiness(SCpnt, 1, devip)))
-			break;
-		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			printk(KERN_INFO "scsi_debug: Medium removal %s\n",
-			        cmd[4] ? "inhibited" : "enabled");
-		break;
-	case SEND_DIAGNOSTIC:     /* mandatory */
-		errsts = check_readiness(SCpnt, 1, devip);
-		break;
-	case TEST_UNIT_READY:     /* mandatory */
-		delay_override = 1;
-		errsts = check_readiness(SCpnt, 0, devip);
-		break;
-        case RESERVE:
-		errsts = check_readiness(SCpnt, 1, devip);
-                break;
-        case RESERVE_10:
-		errsts = check_readiness(SCpnt, 1, devip);
-                break;
-        case RELEASE:
-		errsts = check_readiness(SCpnt, 1, devip);
-                break;
-        case RELEASE_10:
-		errsts = check_readiness(SCpnt, 1, devip);
-                break;
-	case READ_CAPACITY:
-		errsts = resp_readcap(SCpnt, devip);
-		break;
-	case SERVICE_ACTION_IN:
-		if (SAI_READ_CAPACITY_16 != cmd[1]) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
-					INVALID_OPCODE, 0);
-			errsts = check_condition_result;
-			break;
-		}
-		errsts = resp_readcap16(SCpnt, devip);
-		break;
-	case MAINTENANCE_IN:
-		if (MI_REPORT_TARGET_PGS != cmd[1]) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
-					INVALID_OPCODE, 0);
-			errsts = check_condition_result;
-			break;
-		}
-		errsts = resp_report_tgtpgs(SCpnt, devip);
-		break;
-	case READ_16:
-	case READ_12:
-	case READ_10:
-	case READ_6:
-		if ((errsts = check_readiness(SCpnt, 0, devip)))
-			break;
-		if (scsi_debug_fake_rw)
-			break;
-		get_data_transfer_info(cmd, &lba, &num);
-		errsts = resp_read(SCpnt, lba, num, devip);
-		if (inj_recovered && (0 == errsts)) {
-			mk_sense_buffer(devip, RECOVERED_ERROR,
-					THRESHOLD_EXCEEDED, 0);
-			errsts = check_condition_result;
-		} else if (inj_transport && (0 == errsts)) {
-                        mk_sense_buffer(devip, ABORTED_COMMAND,
-                                        TRANSPORT_PROBLEM, ACK_NAK_TO);
-                        errsts = check_condition_result;
-                }
-		break;
-	case REPORT_LUNS:	/* mandatory, ignore unit attention */
-		delay_override = 1;
-		errsts = resp_report_luns(SCpnt, devip);
-		break;
-	case VERIFY:		/* 10 byte SBC-2 command */
-		errsts = check_readiness(SCpnt, 0, devip);
-		break;
-	case WRITE_16:
-	case WRITE_12:
-	case WRITE_10:
-	case WRITE_6:
-		if ((errsts = check_readiness(SCpnt, 0, devip)))
-			break;
-		if (scsi_debug_fake_rw)
-			break;
-		get_data_transfer_info(cmd, &lba, &num);
-		errsts = resp_write(SCpnt, lba, num, devip);
-		if (inj_recovered && (0 == errsts)) {
-			mk_sense_buffer(devip, RECOVERED_ERROR,
-					THRESHOLD_EXCEEDED, 0);
-			errsts = check_condition_result;
-		}
-		break;
-	case MODE_SENSE:
-	case MODE_SENSE_10:
-		errsts = resp_mode_sense(SCpnt, target, devip);
-		break;
-	case MODE_SELECT:
-		errsts = resp_mode_select(SCpnt, 1, devip);
-		break;
-	case MODE_SELECT_10:
-		errsts = resp_mode_select(SCpnt, 0, devip);
-		break;
-	case LOG_SENSE:
-		errsts = resp_log_sense(SCpnt, devip);
-		break;
-	case SYNCHRONIZE_CACHE:
-		delay_override = 1;
-		errsts = check_readiness(SCpnt, 0, devip);
-		break;
-	case WRITE_BUFFER:
-		errsts = check_readiness(SCpnt, 1, devip);
-		break;
-	case XDWRITEREAD_10:
-		if (!scsi_bidi_cmnd(SCpnt)) {
-			mk_sense_buffer(devip, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
-			errsts = check_condition_result;
-			break;
-		}
-
-		errsts = check_readiness(SCpnt, 0, devip);
-		if (errsts)
-			break;
-		if (scsi_debug_fake_rw)
-			break;
-		get_data_transfer_info(cmd, &lba, &num);
-		errsts = resp_read(SCpnt, lba, num, devip);
-		if (errsts)
-			break;
-		errsts = resp_write(SCpnt, lba, num, devip);
-		if (errsts)
-			break;
-		errsts = resp_xdwriteread(SCpnt, lba, num, devip);
-		break;
-	default:
-		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			printk(KERN_INFO "scsi_debug: Opcode: 0x%x not "
-			       "supported\n", *cmd);
-		if ((errsts = check_readiness(SCpnt, 1, devip)))
-			break;	/* Unit attention takes precedence */
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
-		errsts = check_condition_result;
-		break;
-	}
-	return schedule_resp(SCpnt, devip, done, errsts,
-			     (delay_override ? 0 : scsi_debug_delay));
-}
-
 static int scsi_debug_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
@@ -2999,6 +2725,239 @@ static void sdebug_remove_adapter(void)
         --scsi_debug_add_host;
 }
 
+static
+int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
+{
+	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
+	int len, k;
+	unsigned int num;
+	unsigned long long lba;
+	int errsts = 0;
+	int target = SCpnt->device->id;
+	struct sdebug_dev_info *devip = NULL;
+	int inj_recovered = 0;
+	int inj_transport = 0;
+	int delay_override = 0;
+
+	scsi_set_resid(SCpnt, 0);
+	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmd) {
+		printk(KERN_INFO "scsi_debug: cmd ");
+		for (k = 0, len = SCpnt->cmd_len; k < len; ++k)
+			printk("%02x ", (int)cmd[k]);
+		printk("\n");
+	}
+
+	if (target == SCpnt->device->host->hostt->this_id) {
+		printk(KERN_INFO "scsi_debug: initiator's id used as "
+		       "target!\n");
+		return schedule_resp(SCpnt, NULL, done,
+				     DID_NO_CONNECT << 16, 0);
+	}
+
+	if ((SCpnt->device->lun >= scsi_debug_max_luns) &&
+	    (SCpnt->device->lun != SAM2_WLUN_REPORT_LUNS))
+		return schedule_resp(SCpnt, NULL, done,
+				     DID_NO_CONNECT << 16, 0);
+	devip = devInfoReg(SCpnt->device);
+	if (NULL == devip)
+		return schedule_resp(SCpnt, NULL, done,
+				     DID_NO_CONNECT << 16, 0);
+
+	if ((scsi_debug_every_nth != 0) &&
+	    (++scsi_debug_cmnd_count >= abs(scsi_debug_every_nth))) {
+		scsi_debug_cmnd_count = 0;
+		if (scsi_debug_every_nth < -1)
+			scsi_debug_every_nth = -1;
+		if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
+			return 0; /* ignore command causing timeout */
+		else if (SCSI_DEBUG_OPT_RECOVERED_ERR & scsi_debug_opts)
+			inj_recovered = 1; /* to reads and writes below */
+		else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & scsi_debug_opts)
+			inj_transport = 1; /* to reads and writes below */
+	}
+
+	if (devip->wlun) {
+		switch (*cmd) {
+		case INQUIRY:
+		case REQUEST_SENSE:
+		case TEST_UNIT_READY:
+		case REPORT_LUNS:
+			break;  /* only allowable wlun commands */
+		default:
+			if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+				printk(KERN_INFO "scsi_debug: Opcode: 0x%x "
+				       "not supported for wlun\n", *cmd);
+			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+					INVALID_OPCODE, 0);
+			errsts = check_condition_result;
+			return schedule_resp(SCpnt, devip, done, errsts,
+					     0);
+		}
+	}
+
+	switch (*cmd) {
+	case INQUIRY:     /* mandatory, ignore unit attention */
+		delay_override = 1;
+		errsts = resp_inquiry(SCpnt, target, devip);
+		break;
+	case REQUEST_SENSE:	/* mandatory, ignore unit attention */
+		delay_override = 1;
+		errsts = resp_requests(SCpnt, devip);
+		break;
+	case REZERO_UNIT:	/* actually this is REWIND for SSC */
+	case START_STOP:
+		errsts = resp_start_stop(SCpnt, devip);
+		break;
+	case ALLOW_MEDIUM_REMOVAL:
+		errsts = check_readiness(SCpnt, 1, devip);
+		if (errsts)
+			break;
+		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+			printk(KERN_INFO "scsi_debug: Medium removal %s\n",
+			       cmd[4] ? "inhibited" : "enabled");
+		break;
+	case SEND_DIAGNOSTIC:     /* mandatory */
+		errsts = check_readiness(SCpnt, 1, devip);
+		break;
+	case TEST_UNIT_READY:     /* mandatory */
+		delay_override = 1;
+		errsts = check_readiness(SCpnt, 0, devip);
+		break;
+	case RESERVE:
+		errsts = check_readiness(SCpnt, 1, devip);
+		break;
+	case RESERVE_10:
+		errsts = check_readiness(SCpnt, 1, devip);
+		break;
+	case RELEASE:
+		errsts = check_readiness(SCpnt, 1, devip);
+		break;
+	case RELEASE_10:
+		errsts = check_readiness(SCpnt, 1, devip);
+		break;
+	case READ_CAPACITY:
+		errsts = resp_readcap(SCpnt, devip);
+		break;
+	case SERVICE_ACTION_IN:
+		if (SAI_READ_CAPACITY_16 != cmd[1]) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+					INVALID_OPCODE, 0);
+			errsts = check_condition_result;
+			break;
+		}
+		errsts = resp_readcap16(SCpnt, devip);
+		break;
+	case MAINTENANCE_IN:
+		if (MI_REPORT_TARGET_PGS != cmd[1]) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+					INVALID_OPCODE, 0);
+			errsts = check_condition_result;
+			break;
+		}
+		errsts = resp_report_tgtpgs(SCpnt, devip);
+		break;
+	case READ_16:
+	case READ_12:
+	case READ_10:
+	case READ_6:
+		errsts = check_readiness(SCpnt, 0, devip);
+		if (errsts)
+			break;
+		if (scsi_debug_fake_rw)
+			break;
+		get_data_transfer_info(cmd, &lba, &num);
+		errsts = resp_read(SCpnt, lba, num, devip);
+		if (inj_recovered && (0 == errsts)) {
+			mk_sense_buffer(devip, RECOVERED_ERROR,
+					THRESHOLD_EXCEEDED, 0);
+			errsts = check_condition_result;
+		} else if (inj_transport && (0 == errsts)) {
+			mk_sense_buffer(devip, ABORTED_COMMAND,
+					TRANSPORT_PROBLEM, ACK_NAK_TO);
+			errsts = check_condition_result;
+		}
+		break;
+	case REPORT_LUNS:	/* mandatory, ignore unit attention */
+		delay_override = 1;
+		errsts = resp_report_luns(SCpnt, devip);
+		break;
+	case VERIFY:		/* 10 byte SBC-2 command */
+		errsts = check_readiness(SCpnt, 0, devip);
+		break;
+	case WRITE_16:
+	case WRITE_12:
+	case WRITE_10:
+	case WRITE_6:
+		errsts = check_readiness(SCpnt, 0, devip);
+		if (errsts)
+			break;
+		if (scsi_debug_fake_rw)
+			break;
+		get_data_transfer_info(cmd, &lba, &num);
+		errsts = resp_write(SCpnt, lba, num, devip);
+		if (inj_recovered && (0 == errsts)) {
+			mk_sense_buffer(devip, RECOVERED_ERROR,
+					THRESHOLD_EXCEEDED, 0);
+			errsts = check_condition_result;
+		}
+		break;
+	case MODE_SENSE:
+	case MODE_SENSE_10:
+		errsts = resp_mode_sense(SCpnt, target, devip);
+		break;
+	case MODE_SELECT:
+		errsts = resp_mode_select(SCpnt, 1, devip);
+		break;
+	case MODE_SELECT_10:
+		errsts = resp_mode_select(SCpnt, 0, devip);
+		break;
+	case LOG_SENSE:
+		errsts = resp_log_sense(SCpnt, devip);
+		break;
+	case SYNCHRONIZE_CACHE:
+		delay_override = 1;
+		errsts = check_readiness(SCpnt, 0, devip);
+		break;
+	case WRITE_BUFFER:
+		errsts = check_readiness(SCpnt, 1, devip);
+		break;
+	case XDWRITEREAD_10:
+		if (!scsi_bidi_cmnd(SCpnt)) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+					INVALID_FIELD_IN_CDB, 0);
+			errsts = check_condition_result;
+			break;
+		}
+
+		errsts = check_readiness(SCpnt, 0, devip);
+		if (errsts)
+			break;
+		if (scsi_debug_fake_rw)
+			break;
+		get_data_transfer_info(cmd, &lba, &num);
+		errsts = resp_read(SCpnt, lba, num, devip);
+		if (errsts)
+			break;
+		errsts = resp_write(SCpnt, lba, num, devip);
+		if (errsts)
+			break;
+		errsts = resp_xdwriteread(SCpnt, lba, num, devip);
+		break;
+	default:
+		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+			printk(KERN_INFO "scsi_debug: Opcode: 0x%x not "
+			       "supported\n", *cmd);
+		errsts = check_readiness(SCpnt, 1, devip);
+		if (errsts)
+			break;	/* Unit attention takes precedence */
+		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
+		errsts = check_condition_result;
+		break;
+	}
+	return schedule_resp(SCpnt, devip, done, errsts,
+			     (delay_override ? 0 : scsi_debug_delay));
+}
+
 static struct scsi_host_template sdebug_driver_template = {
 	.proc_info =		scsi_debug_proc_info,
 	.proc_name =		sdebug_proc_name,
-- 
1.5.3.7

