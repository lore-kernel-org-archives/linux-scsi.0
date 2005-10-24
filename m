From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 7/9] use {sdev,scmd,starget,shost}_printk in generic code
Date: Mon, 24 Oct 2005 18:04:06 -0400
Message-ID: <20051024220406.GG10567@havoc.gtf.org>
References: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:51599 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751343AbVJXWEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:04:06 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 25B211C0A7BA
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:04:06 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OM46VW010809
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:04:06 -0400
Content-Disposition: inline
In-Reply-To: <20051024220013.GA10070@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


commit 2c6e883beaa696014c02f973f02c9730b9de5d93
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Mon Oct 24 16:35:25 2005 -0400

    [SCSI] use {sdev,scmd,starget,shost}_printk in generic code
    
    Some changes from James Bottomley, some from me, some the same changes
    independently from the two of us.

 drivers/scsi/constants.c          |    6 +-----
 drivers/scsi/hosts.c              |    2 +-
 drivers/scsi/scsi.c               |   20 ++++++++------------
 drivers/scsi/scsi_debug.c         |   15 ++++++---------
 drivers/scsi/scsi_error.c         |   29 ++++++++++-------------------
 drivers/scsi/scsi_ioctl.c         |    8 ++------
 drivers/scsi/scsi_lib.c           |   31 ++++++++++++++-----------------
 drivers/scsi/scsi_scan.c          |   31 ++++++++++++++++---------------
 drivers/scsi/scsi_transport_fc.c  |    2 --
 drivers/scsi/scsi_transport_spi.c |   24 +++++++++++-------------
 drivers/scsi/sd.c                 |    9 +++------
 drivers/scsi/sg.c                 |   14 +++++---------
 drivers/scsi/sr.c                 |   15 +++++++--------
 drivers/scsi/st.c                 |   10 ++++------
 14 files changed, 88 insertions(+), 128 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index f6be2c1..8bd936b 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1389,11 +1389,7 @@ EXPORT_SYMBOL(scsi_print_msg);
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	/* Assume appended output (i.e. not at start of line) */
-	printk("scsi%d : destination target %d, lun %d\n", 
-		cmd->device->host->host_no, 
-		cmd->device->id, 
-		cmd->device->lun);
-	printk(KERN_INFO "        command: ");
+	scmd_printk(KERN_INFO, cmd, "command:\n\t");
 	scsi_print_cdb(cmd->cmnd, cmd->cmd_len, 0);
 }
 EXPORT_SYMBOL(scsi_print_command);
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 02fe371..e2f247e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -139,7 +139,7 @@ int scsi_host_set_state(struct Scsi_Host
 
  illegal:
 	SCSI_LOG_ERROR_RECOVERY(1,
-				dev_printk(KERN_ERR, &shost->shost_gendev,
+				shost_printk(KERN_ERR, shost,
 					   "Illegal host state transition"
 					   "%s->%s\n",
 					   scsi_host_state_name(oldstate),
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88aea32..c47aa6e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -410,9 +410,7 @@ void scsi_log_send(struct scsi_cmnd *cmd
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
 			sdev = cmd->device;
-			printk(KERN_INFO "scsi <%d:%d:%d:%d> send ",
-			       sdev->host->host_no, sdev->channel, sdev->id,
-			       sdev->lun);
+			sdev_printk(KERN_INFO, sdev, "send ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -456,9 +454,7 @@ void scsi_log_completion(struct scsi_cmn
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
 			sdev = cmd->device;
-			printk(KERN_INFO "scsi <%d:%d:%d:%d> done ",
-			       sdev->host->host_no, sdev->channel, sdev->id,
-			       sdev->lun);
+			sdev_printk(KERN_INFO, sdev, "done ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -810,7 +806,7 @@ static void scsi_softirq(struct softirq_
 		disposition = scsi_decide_disposition(cmd);
 		if (disposition != SUCCESS &&
 		    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
-			dev_printk(KERN_ERR, &cmd->device->sdev_gendev, 
+			scmd_printk(KERN_ERR, cmd,
 				   "timing out command, waited %lus\n",
 				   wait_for/HZ);
 			disposition = SUCCESS;
@@ -893,8 +889,9 @@ void scsi_finish_command(struct scsi_cmn
 	if (SCSI_SENSE_VALID(cmd))
 		cmd->result |= (DRIVER_SENSE << 24);
 
-	SCSI_LOG_MLCOMPLETE(4, printk("Notifying upper driver of completion "
-				"for device %d %x\n", sdev->id, cmd->result));
+	SCSI_LOG_MLCOMPLETE(4, sdev_printk(KERN_INFO, sdev,
+				"Notifying upper driver of completion "
+				"(result %x)\n", cmd->result));
 
 	/*
 	 * We can get here with use_sg=0, causing a panic in the upper level
@@ -970,10 +967,9 @@ void scsi_adjust_queue_depth(struct scsi
 			sdev->simple_tags = 1;
 			break;
 		default:
-			printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
+			sdev_printk(KERN_WARNING, sdev,
 				"scsi_adjust_queue_depth, bad queue type, "
-				"disabled\n", sdev->host->host_no,
-				sdev->channel, sdev->id, sdev->lun); 
+				"disabled\n");
 		case 0:
 			sdev->ordered_tags = sdev->simple_tags = 0;
 			sdev->queue_depth = tags;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 322b5a4..add190e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1008,8 +1008,7 @@ static void timer_intr_handler(unsigned 
 static int scsi_debug_slave_alloc(struct scsi_device * sdp)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_alloc\n");
 	return 0;
 }
 
@@ -1018,8 +1017,7 @@ static int scsi_debug_slave_configure(st
 	struct sdebug_dev_info * devip;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_configure\n");
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
 	devip = devInfoReg(sdp);
@@ -1036,8 +1034,7 @@ static void scsi_debug_slave_destroy(str
 				(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_destroy\n");
 	if (devip) {
 		/* make this slot avaliable for re-use */
 		devip->used = 0;
@@ -1326,9 +1323,9 @@ static int schedule_resp(struct scsi_cmn
 		if (scsi_result) {
 			struct scsi_device * sdp = cmnd->device;
 
-			printk(KERN_INFO "scsi_debug:    <%u %u %u %u> "
-			       "non-zero result=0x%x\n", sdp->host->host_no,
-			       sdp->channel, sdp->id, sdp->lun, scsi_result);
+			sdev_printk(KERN_INFO, sdp,
+				"non-zero result=0x%x\n",
+			       	scsi_result);
 		}
 	}
 	if (cmnd && devip) {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 52b348c..bbb65ff 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -241,11 +241,10 @@ static inline void scsi_eh_prt_fail_stat
 
 		if (cmd_cancel || cmd_failed) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				printk("%s: %d:%d:%d:%d cmds failed: %d,"
+				sdev_printk(KERN_INFO, sdev,
+				       "%s: cmds failed: %d,"
 				       " cancel: %d\n",
-				       __FUNCTION__, shost->host_no,
-				       sdev->channel, sdev->id, sdev->lun,
-				       cmd_failed, cmd_cancel));
+				       __FUNCTION__, cmd_failed, cmd_cancel));
 			cmd_cancel = 0;
 			cmd_failed = 0;
 			++devices_failed;
@@ -674,10 +673,9 @@ static int scsi_eh_get_sense(struct list
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(2, printk("%s: requesting sense"
-						  " for id: %d\n",
-						  current->comm,
-						  scmd->device->id));
+		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
+						  "%s: requesting sense\n",
+						  current->comm));
 		rtn = scsi_request_sense(scmd);
 		if (rtn != SUCCESS)
 			continue;
@@ -1174,13 +1172,9 @@ static void scsi_eh_offline_sdevs(struct
 	struct scsi_cmnd *scmd, *next;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-		printk(KERN_INFO "scsi: Device offlined - not"
-		       		" ready after error recovery: host"
-				" %d channel %d id %d lun %d\n",
-				scmd->device->host->host_no,
-				scmd->device->channel,
-				scmd->device->id,
-				scmd->device->lun);
+		scmd_printk(KERN_INFO, scmd,
+				"Device offlined - not"
+		       		" ready after error recovery\n");
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
 		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
 			/*
@@ -1342,10 +1336,7 @@ int scsi_decide_disposition(struct scsi_
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		printk(KERN_INFO "scsi: reservation conflict: host"
-                                " %d channel %d id %d lun %d\n",
-		       scmd->device->host->host_no, scmd->device->channel,
-		       scmd->device->id, scmd->device->lun);
+		scmd_printk(KERN_INFO, scmd, "reservation conflict\n");
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index de7f98c..bdb3f90 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -122,12 +122,8 @@ static int ioctl_internal_command(struct
 				break;
 			}
 		default:	/* Fall through for non-removable media */
-			printk(KERN_INFO "ioctl_internal_command: <%d %d %d "
-			       "%d> return code = %x\n",
-			       sdev->host->host_no,
-			       sdev->channel,
-			       sdev->id,
-			       sdev->lun,
+			sdev_printk(KERN_INFO, sdev,
+			       "ioctl_internal_command: return code = %x\n",
 			       result);
 			scsi_print_sense_hdr("   ", &sshdr);
 			break;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0074f28..3543a8a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -951,15 +951,13 @@ void scsi_io_completion(struct scsi_cmnd
 				return;
 			}
 			if (!(req->flags & REQ_QUIET))
-				dev_printk(KERN_INFO,
-					   &cmd->device->sdev_gendev,
+				scmd_printk(KERN_INFO, cmd,
 					   "Device not ready.\n");
 			scsi_end_request(cmd, 0, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:
 			if (!(req->flags & REQ_QUIET)) {
-				dev_printk(KERN_INFO,
-					   &cmd->device->sdev_gendev,
+				scmd_printk(KERN_INFO, cmd,
 					   "Volume overflow, CDB: ");
 				__scsi_print_command(cmd->data_cmnd);
 				scsi_print_sense("", cmd);
@@ -981,7 +979,7 @@ void scsi_io_completion(struct scsi_cmnd
 	}
 	if (result) {
 		if (!(req->flags & REQ_QUIET)) {
-			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			scmd_printk(KERN_INFO, cmd,
 				   "SCSI error: return code = 0x%x\n", result);
 
 			if (driver_byte(result) & DRIVER_SENSE)
@@ -1141,8 +1139,8 @@ static int scsi_prep_fn(struct request_q
 	 * online before trying any recovery commands
 	 */
 	if (unlikely(!scsi_device_online(sdev))) {
-		printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
-		       sdev->host->host_no, sdev->id, sdev->lun);
+		sdev_printk(KERN_ERR, sdev,
+		       "rejecting I/O to offline device\n");
 		goto kill;
 	}
 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
@@ -1151,8 +1149,8 @@ static int scsi_prep_fn(struct request_q
 		if (sdev->sdev_state == SDEV_DEL) {
 			/* Device is fully deleted, no commands
 			 * at all allowed down */
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to dead device\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			sdev_printk(KERN_ERR, sdev,
+			       "rejecting I/O to dead device\n");
 			goto kill;
 		}
 		/* OK, we only allow special commands (i.e. not
@@ -1187,8 +1185,8 @@ static int scsi_prep_fn(struct request_q
 					specials_only == SDEV_BLOCK)
 				goto defer;
 			
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			sdev_printk(KERN_ERR, sdev,
+			       "rejecting I/O to device being removed\n");
 			goto kill;
 		}
 			
@@ -1315,9 +1313,8 @@ static inline int scsi_dev_queue_ready(s
 		 */
 		if (--sdev->device_blocked == 0) {
 			SCSI_LOG_MLQUEUE(3,
-				printk("scsi%d (%d:%d) unblocking device at"
-				       " zero depth\n", sdev->host->host_no,
-				       sdev->id, sdev->lun));
+				sdev_printk(KERN_INFO, sdev,
+				       "unblocking device at zero depth\n"));
 		} else {
 			blk_plug_device(q);
 			return 0;
@@ -1436,8 +1433,8 @@ static void scsi_request_fn(struct reque
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			sdev_printk(KERN_ERR, sdev,
+			       "rejecting I/O to offline device\n");
 			scsi_kill_request(req, q);
 			continue;
 		}
@@ -1893,7 +1890,7 @@ scsi_device_set_state(struct scsi_device
 
  illegal:
 	SCSI_LOG_ERROR_RECOVERY(1, 
-				dev_printk(KERN_ERR, &sdev->sdev_gendev,
+				sdev_printk(KERN_ERR, sdev,
 					   "Illegal state transition %s->%s\n",
 					   scsi_device_state_name(oldstate),
 					   scsi_device_state_name(state))
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 205c89f..bb556d5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -462,10 +462,9 @@ static int scsi_probe_lun(struct scsi_de
 	pass = 1;
 
  next_pass:
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY pass %d "
-			"to host %d channel %d id %d lun %d, length %d\n",
-			pass, sdev->host->host_no, sdev->channel,
-			sdev->id, sdev->lun, try_inquiry_len));
+	SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+			"scsi scan: INQUIRY pass %d, length %d\n",
+			pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
 	for (count = 0; count < 3; ++count) {
@@ -1190,9 +1189,8 @@ static int scsi_report_lun_scan(struct s
 		num_luns = max_scsi_report_luns;
 	}
 
-	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUN scan of"
-			" host %d channel %d id %d\n", sdev->host->host_no,
-			sdev->channel, sdev->id));
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+		"scsi scan: REPORT LUN scan\n"));
 
 	/*
 	 * Scan the luns in lun_data. The entry at offset 0 is really
@@ -1219,9 +1217,10 @@ static int scsi_report_lun_scan(struct s
 				printk("%02x", data[i]);
 			printk(" has a LUN larger than currently supported.\n");
 		} else if (lun > sdev->host->max_lun) {
-			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
-			       " than allowed by the host adapter\n",
-			       devname, lun);
+			sdev_printk(KERN_WARNING, sdev,
+				"lun%d larger"
+			        " than allowed by the host adapter\n",
+			        lun);
 		} else {
 			int res;
 
@@ -1231,9 +1230,10 @@ static int scsi_report_lun_scan(struct s
 				/*
 				 * Got some results, but now none, abort.
 				 */
-				printk(KERN_ERR "scsi: Unexpected response"
-				       " from %s lun %d while scanning, scan"
-				       " aborted\n", devname, lun);
+				sdev_printk(KERN_ERR, sdev,
+					"Unexpected response"
+				        " from lun %d while scanning, scan"
+				        " aborted\n", lun);
 				break;
 			}
 		}
@@ -1423,8 +1423,9 @@ static void scsi_scan_channel(struct Scs
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 			    unsigned int id, unsigned int lun, int rescan)
 {
-	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%u>\n",
-		__FUNCTION__, shost->host_no, channel, id, lun));
+	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
+		"%s: <%u:%u:%u>\n",
+		__FUNCTION__, channel, id, lun));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id > shost->max_id)) ||
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 57db6d1..f67805d 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -32,8 +32,6 @@
 #include <scsi/scsi_transport_fc.h>
 #include "scsi_priv.h"
 
-#define FC_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun , ##a)
-
 /*
  * Redefine so that we can have same named attributes in the
  * sdev/starget/host objects.
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index ef577c8..718a2bc 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -33,8 +33,6 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
 
-#define SPI_PRINTK(x, l, f, a...)	dev_printk(l, &(x)->dev, f , ##a)
-
 #define SPI_NUM_ATTRS 14	/* increase this if you add attributes */
 #define SPI_OTHER_ATTRS 1	/* Increase this if you add "always
 				 * on" attributes */
@@ -618,7 +616,7 @@ spi_dv_device_echo_buffer(struct scsi_de
 				return SPI_COMPARE_SKIP_TEST;
 
 
-			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Write Buffer failure %x\n", result);
+			sdev_printk(KERN_ERR, sdev, "Write Buffer failure %x\n", result);
 			return SPI_COMPARE_FAILURE;
 		}
 
@@ -702,10 +700,10 @@ spi_dv_retrain(struct scsi_device *sdev,
 		 * IU, then QAS (if we can control them), then finally
 		 * fall down the periods */
 		if (i->f->set_iu && spi_iu(starget)) {
-			SPI_PRINTK(starget, KERN_ERR, "Domain Validation Disabing Information Units\n");
+			starget_printk(KERN_ERR, starget, "Domain Validation Disabing Information Units\n");
 			DV_SET(iu, 0);
 		} else if (i->f->set_qas && spi_qas(starget)) {
-			SPI_PRINTK(starget, KERN_ERR, "Domain Validation Disabing Quick Arbitration and Selection\n");
+			starget_printk(KERN_ERR, starget, "Domain Validation Disabing Quick Arbitration and Selection\n");
 			DV_SET(qas, 0);
 		} else {
 			newperiod = spi_period(starget);
@@ -717,11 +715,11 @@ spi_dv_retrain(struct scsi_device *sdev,
 
 			if (unlikely(period > 0xff || period == prevperiod)) {
 				/* Total failure; set to async and return */
-				SPI_PRINTK(starget, KERN_ERR, "Domain Validation Failure, dropping back to Asynchronous\n");
+				starget_printk(KERN_ERR, starget, "Domain Validation Failure, dropping back to Asynchronous\n");
 				DV_SET(offset, 0);
 				return SPI_COMPARE_FAILURE;
 			}
-			SPI_PRINTK(starget, KERN_ERR, "Domain Validation detected failure, dropping back\n");
+			starget_printk(KERN_ERR, starget, "Domain Validation detected failure, dropping back\n");
 			DV_SET(period, period);
 			prevperiod = period;
 		}
@@ -788,7 +786,7 @@ spi_dv_device_internal(struct scsi_devic
 	
 	if (spi_dv_device_compare_inquiry(sdev, buffer, buffer, DV_LOOPS)
 	    != SPI_COMPARE_SUCCESS) {
-		SPI_PRINTK(starget, KERN_ERR, "Domain Validation Initial Inquiry Failed\n");
+		starget_printk(KERN_ERR, starget, "Domain Validation Initial Inquiry Failed\n");
 		/* FIXME: should probably offline the device here? */
 		return;
 	}
@@ -802,7 +800,7 @@ spi_dv_device_internal(struct scsi_devic
 						   buffer + len,
 						   DV_LOOPS)
 		    != SPI_COMPARE_SUCCESS) {
-			SPI_PRINTK(starget, KERN_ERR, "Wide Transfers Fail\n");
+			starget_printk(KERN_ERR, starget, "Wide Transfers Fail\n");
 			i->f->set_width(starget, 0);
 		}
 	}
@@ -844,14 +842,14 @@ spi_dv_device_internal(struct scsi_devic
 	}
 
 	if (len == 0) {
-		SPI_PRINTK(starget, KERN_INFO, "Domain Validation skipping write tests\n");
+		starget_printk(KERN_INFO, starget, "Domain Validation skipping write tests\n");
 		spi_dv_retrain(sdev, buffer, buffer + len,
 			       spi_dv_device_compare_inquiry);
 		return;
 	}
 
 	if (len > SPI_MAX_ECHO_BUFFER_SIZE) {
-		SPI_PRINTK(starget, KERN_WARNING, "Echo buffer size %d is too big, trimming to %d\n", len, SPI_MAX_ECHO_BUFFER_SIZE);
+		starget_printk(KERN_WARNING, starget, "Echo buffer size %d is too big, trimming to %d\n", len, SPI_MAX_ECHO_BUFFER_SIZE);
 		len = SPI_MAX_ECHO_BUFFER_SIZE;
 	}
 
@@ -902,11 +900,11 @@ spi_dv_device(struct scsi_device *sdev)
 	spi_dv_pending(starget) = 1;
 	down(&spi_dv_sem(starget));
 
-	SPI_PRINTK(starget, KERN_INFO, "Beginning Domain Validation\n");
+	starget_printk(KERN_INFO, starget, "Beginning Domain Validation\n");
 
 	spi_dv_device_internal(sdev, buffer);
 
-	SPI_PRINTK(starget, KERN_INFO, "Ending Domain Validation\n");
+	starget_printk(KERN_INFO, starget, "Ending Domain Validation\n");
 
 	up(&spi_dv_sem(starget));
 	spi_dv_pending(starget) = 0;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9a1dc0c..d4abb09 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1535,8 +1535,7 @@ static int sd_probe(struct device *dev)
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
 		goto out;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
-			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
+	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp, "sd_attach\n"));
 
 	error = -ENOMEM;
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
@@ -1608,10 +1607,8 @@ static int sd_probe(struct device *dev)
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 
-	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
-	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
-	       gd->disk_name, sdp->host->host_no, sdp->channel,
-	       sdp->id, sdp->lun);
+	sdev_printk(KERN_NOTICE, sdp, "Attached scsi %sdisk %s\n",
+	       sdp->removable ? "removable " : "", gd->disk_name);
 
 	return 0;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ad94367..64d0812 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1497,10 +1497,9 @@ static int sg_alloc(struct gendisk *disk
 
  overflow:
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-	printk(KERN_WARNING
-	       "Unable to attach sg device <%d, %d, %d, %d> type=%d, minor "
-	       "number exceeds %d\n", scsidp->host->host_no, scsidp->channel,
-	       scsidp->id, scsidp->lun, scsidp->type, SG_MAX_DEVS - 1);
+	sdev_printk(KERN_WARNING, scsidp,
+	       "Unable to attach sg device type=%d, minor "
+	       "number exceeds %d\n", scsidp->type, SG_MAX_DEVS - 1);
 	error = -ENODEV;
 	goto out;
 }
@@ -1566,11 +1565,8 @@ sg_add(struct class_device *cl_dev)
 	} else
 		printk(KERN_WARNING "sg_add: sg_sys INvalid\n");
 
-	printk(KERN_NOTICE
-	       "Attached scsi generic sg%d at scsi%d, channel"
-	       " %d, id %d, lun %d,  type %d\n", k,
-	       scsidp->host->host_no, scsidp->channel, scsidp->id,
-	       scsidp->lun, scsidp->type);
+	sdev_printk(KERN_NOTICE, scsidp,
+	       "Attached scsi generic sg%d, type %d\n", k, scsidp->type);
 
 	return 0;
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 561901b..3bf06fb 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -360,7 +360,7 @@ static int sr_init_command(struct scsi_c
 	}
 
 	if (s_size != 512 && s_size != 1024 && s_size != 2048) {
-		printk("sr: bad sector size %d\n", s_size);
+		scmd_printk(KERN_ERR, SCpnt, "bad sector size %d\n", s_size);
 		return 0;
 	}
 
@@ -385,8 +385,9 @@ static int sr_init_command(struct scsi_c
 			size += sg[i].length;
 
 		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
-			printk(KERN_ERR "sr: mismatch count %d, bytes %d\n",
-					size, SCpnt->request_bufflen);
+			scmd_printk(KERN_ERR, SCpnt,
+				"mismatch count %d, bytes %d\n",
+				size, SCpnt->request_bufflen);
 			if (SCpnt->request_bufflen > size)
 				SCpnt->request_bufflen = SCpnt->bufflen = size;
 		}
@@ -397,7 +398,7 @@ static int sr_init_command(struct scsi_c
 	 */
 	if (((unsigned int)SCpnt->request->sector % (s_size >> 9)) ||
 	    (SCpnt->request_bufflen % s_size)) {
-		printk("sr: unaligned transfer\n");
+		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
 		return 0;
 	}
 
@@ -622,10 +623,8 @@ static int sr_probe(struct device *dev)
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
 
-	printk(KERN_DEBUG
-	    "Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
-	    cd->cdi.name, sdev->host->host_no, sdev->channel,
-	    sdev->id, sdev->lun);
+	sdev_printk(KERN_DEBUG, sdev,
+		"Attached scsi CD-ROM %s\n", cd->cdi.name);
 	return 0;
 
 fail_put:
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index d001c04..1e8ccbe 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3885,9 +3885,7 @@ static int st_probe(struct device *dev)
 	if (SDp->type != TYPE_TAPE)
 		return -ENODEV;
 	if ((stp = st_incompatible(SDp))) {
-		printk(KERN_INFO
-		       "st: Found incompatible tape at scsi%d, channel %d, id %d, lun %d\n",
-		       SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
+		sdev_printk(KERN_INFO, SDp, "Found incompatible tape\n");
 		printk(KERN_INFO "st: The suggested driver is %s.\n", stp);
 		return -ENODEV;
 	}
@@ -4075,9 +4073,9 @@ static int st_probe(struct device *dev)
 	}
 	disk->number = devfs_register_tape(SDp->devfs_name);
 
-	printk(KERN_WARNING
-	"Attached scsi tape %s at scsi%d, channel %d, id %d, lun %d\n",
-	       tape_name(tpnt), SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
+	sdev_printk(KERN_WARNING, SDp,
+		"Attached scsi tape %s\n", tape_name(tpnt));
+
 	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B), max page reachable by HBA %lu\n",
 	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
 	       queue_dma_alignment(SDp->request_queue) + 1, tpnt->max_pfn);
