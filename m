From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 5/n] HCIL drivers update
Date: Sun, 23 Oct 2005 20:13:03 -0400
Message-ID: <20051024001303.GA21626@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:9962 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750834AbVJXANH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 20:13:07 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id D08CA1C09605
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 20:13:03 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9O0D3wn021678
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 20:13:03 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Use sdev_printk() in generic scsi code.

DO NOT APPLY.

 drivers/scsi/scsi.c               |   12 +++++-------
 drivers/scsi/scsi_error.c         |   10 +++++-----
 drivers/scsi/scsi_ioctl.c         |    2 +-
 drivers/scsi/scsi_lib.c           |   20 +++++++++-----------
 drivers/scsi/scsi_scan.c          |    8 ++++----
 drivers/scsi/scsi_transport_spi.c |    2 +-
 drivers/scsi/sd.c                 |    6 ++----
 drivers/scsi/sg.c                 |    4 ++--
 drivers/scsi/sr.c                 |    2 +-
 9 files changed, 30 insertions(+), 36 deletions(-)


4c4fae1f2630faf898f844143ac7c33718a37d4a
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e6269f0..f710de0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -410,8 +410,7 @@ void scsi_log_send(struct scsi_cmnd *cmd
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
 			sdev = cmd->device;
-			dev_printk(KERN_INFO, &sdev->sdev_gendev,
-				   "scsi send ");
+			sdev_printk(KERN_INFO, sdev, "scsi send ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -455,8 +454,7 @@ void scsi_log_completion(struct scsi_cmn
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
 			sdev = cmd->device;
-			dev_printk(KERN_INFO, &sdev->sdev_gendev,
-				   "scsi done ");
+			sdev_printk(KERN_INFO, sdev, "scsi done ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -810,7 +808,7 @@ static void scsi_softirq(struct softirq_
 		disposition = scsi_decide_disposition(cmd);
 		if (disposition != SUCCESS &&
 		    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
-			dev_printk(KERN_ERR, &cmd->device->sdev_gendev, 
+			sdev_printk(KERN_ERR, cmd->device,
 				   "timing out command, waited %lus\n",
 				   wait_for/HZ);
 			disposition = SUCCESS;
@@ -893,7 +891,7 @@ void scsi_finish_command(struct scsi_cmn
 	if (SCSI_SENSE_VALID(cmd))
 		cmd->result |= (DRIVER_SENSE << 24);
 
-	SCSI_LOG_MLCOMPLETE(4, dev_printk(KERN_INFO, &sdev->sdev_gendev,
+	SCSI_LOG_MLCOMPLETE(4, sdev_printk(KERN_INFO, sdev,
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
@@ -971,7 +969,7 @@ void scsi_adjust_queue_depth(struct scsi
 			sdev->simple_tags = 1;
 			break;
 		default:
-			dev_printk(KERN_WARNING, &sdev->sdev_gendev,
+			sdev_printk(KERN_WARNING, sdev,
 				"scsi_adjust_queue_depth, bad queue type, "
 				"disabled\n");
 		case 0:
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 29b0e2b..867cc84 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -241,7 +241,7 @@ static inline void scsi_eh_prt_fail_stat
 
 		if (cmd_cancel || cmd_failed) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				dev_printk(KERN_INFO, &sdev->sdev_gendev,
+				sdev_printk(KERN_INFO, sdev,
 				       "%s: cmds failed: %d,"
 				       " cancel: %d\n",
 				       __FUNCTION__, cmd_failed, cmd_cancel));
@@ -675,8 +675,8 @@ static int scsi_eh_get_sense(struct list
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(2, dev_printk(KERN_INFO,
-						  &scmd->device->sdev_gendev,
+		SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO,
+						  scmd->device,
 						  "%s: requesting sense\n",
 						  current->comm));
 		rtn = scsi_request_sense(scmd);
@@ -1177,7 +1177,7 @@ static void scsi_eh_offline_sdevs(struct
 	struct scsi_cmnd *scmd, *next;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-		dev_printk(KERN_INFO, &scmd->device->sdev_gendev,
+		sdev_printk(KERN_INFO, scmd->device,
 				"Device offlined - not"
 		       		" ready after error recovery\n");
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
@@ -1341,7 +1341,7 @@ int scsi_decide_disposition(struct scsi_
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		dev_printk(KERN_INFO, &scmd->device->sdev_gendev,
+		sdev_printk(KERN_INFO, scmd->device,
 				"reservation conflict\n");
 		return SUCCESS; /* causes immediate i/o error */
 	default:
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 884cb06..0bdb2ec 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -122,7 +122,7 @@ static int ioctl_internal_command(struct
 				break;
 			}
 		default:	/* Fall through for non-removable media */
-			dev_printk(KERN_INFO, &sdev->sdev_gendev,
+			sdev_printk(KERN_INFO, sdev,
 			       "ioctl_internal_command: return code = %x\n",
 			       result);
 			scsi_print_sense_hdr("   ", &sshdr);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5a38708..0559449 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -952,15 +952,13 @@ void scsi_io_completion(struct scsi_cmnd
 				return;
 			}
 			if (!(req->flags & REQ_QUIET))
-				dev_printk(KERN_INFO,
-					   &cmd->device->sdev_gendev,
+				sdev_printk(KERN_INFO, cmd->device,
 					   "Device not ready.\n");
 			scsi_end_request(cmd, 0, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:
 			if (!(req->flags & REQ_QUIET)) {
-				dev_printk(KERN_INFO,
-					   &cmd->device->sdev_gendev,
+				sdev_printk(KERN_INFO, cmd->device,
 					   "Volume overflow, CDB: ");
 				__scsi_print_command(cmd->data_cmnd);
 				scsi_print_sense("", cmd);
@@ -982,7 +980,7 @@ void scsi_io_completion(struct scsi_cmnd
 	}
 	if (result) {
 		if (!(req->flags & REQ_QUIET)) {
-			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			sdev_printk(KERN_INFO, cmd->device,
 				   "SCSI error: return code = 0x%x\n", result);
 
 			if (driver_byte(result) & DRIVER_SENSE)
@@ -1140,7 +1138,7 @@ static int scsi_prep_fn(struct request_q
 	 * online before trying any recovery commands
 	 */
 	if (unlikely(!scsi_device_online(sdev))) {
-		dev_printk(KERN_ERR, &sdev->sdev_gendev,
+		sdev_printk(KERN_ERR, sdev,
 		       "rejecting I/O to offline device\n");
 		goto kill;
 	}
@@ -1150,7 +1148,7 @@ static int scsi_prep_fn(struct request_q
 		if (sdev->sdev_state == SDEV_DEL) {
 			/* Device is fully deleted, no commands
 			 * at all allowed down */
-			dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			sdev_printk(KERN_ERR, sdev,
 			       "rejecting I/O to dead device\n");
 			goto kill;
 		}
@@ -1186,7 +1184,7 @@ static int scsi_prep_fn(struct request_q
 					specials_only == SDEV_BLOCK)
 				goto defer;
 			
-			dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			sdev_printk(KERN_ERR, sdev,
 			       "rejecting I/O to device being removed\n");
 			goto kill;
 		}
@@ -1314,7 +1312,7 @@ static inline int scsi_dev_queue_ready(s
 		 */
 		if (--sdev->device_blocked == 0) {
 			SCSI_LOG_MLQUEUE(3,
-				dev_printk(KERN_INFO, &sdev->sdev_gendev,
+				sdev_printk(KERN_INFO, sdev,
 				       "unblocking device at zero depth\n"));
 		} else {
 			blk_plug_device(q);
@@ -1434,7 +1432,7 @@ static void scsi_request_fn(struct reque
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
-			dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			sdev_printk(KERN_ERR, sdev,
 			       "rejecting I/O to offline device\n");
 			scsi_kill_request(req, q);
 			continue;
@@ -1891,7 +1889,7 @@ scsi_device_set_state(struct scsi_device
 
  illegal:
 	SCSI_LOG_ERROR_RECOVERY(1, 
-				dev_printk(KERN_ERR, &sdev->sdev_gendev,
+				sdev_printk(KERN_ERR, sdev,
 					   "Illegal state transition %s->%s\n",
 					   scsi_device_state_name(oldstate),
 					   scsi_device_state_name(state))
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index df9fa91..a3c546a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -460,7 +460,7 @@ static int scsi_probe_lun(struct scsi_de
 	pass = 1;
 
  next_pass:
-	SCSI_LOG_SCAN_BUS(3, dev_printk(KERN_INFO, &sdev->sdev_gendev,
+	SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 			"scsi scan: INQUIRY pass %d, length %d\n",
 			pass, try_inquiry_len));
 
@@ -1193,7 +1193,7 @@ static int scsi_report_lun_scan(struct s
 		num_luns = max_scsi_report_luns;
 	}
 
-	SCSI_LOG_SCAN_BUS(3, dev_printk (KERN_INFO, &sdev->sdev_gendev,
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 			"scsi scan: REPORT LUN scan\n"));
 
 	/*
@@ -1207,7 +1207,7 @@ static int scsi_report_lun_scan(struct s
 		lun = scsilun_to_int(lunp);
 
 		if ((!shost->unlimited_luns) && (lun > sdev->host->max_lun)) {
-			dev_printk(KERN_WARNING, &sdev->sdev_gendev,
+			sdev_printk(KERN_WARNING, sdev,
 				"lun %s larger"
 				" than allowed by the host adapter\n",
 				scsilun_to_str(lunp, lunstr));
@@ -1220,7 +1220,7 @@ static int scsi_report_lun_scan(struct s
 				/*
 				 * Got some results, but now none, abort.
 				 */
-				dev_printk(KERN_ERR, &sdev->sdev_gendev,
+				sdev_printk(KERN_ERR, sdev,
 					"Unexpected response"
 					" from lun %s while scanning, scan"
 					" aborted\n",
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index ef577c8..2d83310 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -618,7 +618,7 @@ spi_dv_device_echo_buffer(struct scsi_de
 				return SPI_COMPARE_SKIP_TEST;
 
 
-			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Write Buffer failure %x\n", result);
+			sdev_printk(KERN_ERR, sdev, "Write Buffer failure %x\n", result);
 			return SPI_COMPARE_FAILURE;
 		}
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b6cbb4f..7c83923 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1535,8 +1535,7 @@ static int sd_probe(struct device *dev)
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
 		goto out;
 
-	SCSI_LOG_HLQUEUE(3, dev_printk(KERN_INFO, &sdp->sdev_gendev,
-			"sd_attach\n"));
+	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp, "sd_attach\n"));
 
 	error = -ENOMEM;
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
@@ -1608,8 +1607,7 @@ static int sd_probe(struct device *dev)
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 
-	dev_printk(KERN_NOTICE, &sdp->sdev_gendev,
-		"Attached scsi %sdisk %s\n",
+	sdev_printk(KERN_NOTICE, sdp, "Attached scsi %sdisk %s\n",
 	       sdp->removable ? "removable " : "",
 	       gd->disk_name);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1c2ca07..04c383e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1499,7 +1499,7 @@ static int sg_alloc(struct gendisk *disk
 
  overflow:
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-	dev_printk(KERN_WARNING, &scsidp->sdev_gendev,
+	sdev_printk(KERN_WARNING, scsidp,
 	       "Unable to attach sg device type=%d, minor "
 	       "number exceeds %d\n", scsidp->type, SG_MAX_DEVS - 1);
 	error = -ENODEV;
@@ -1567,7 +1567,7 @@ sg_add(struct class_device *cl_dev)
 	} else
 		printk(KERN_WARNING "sg_add: sg_sys INvalid\n");
 
-	dev_printk(KERN_NOTICE, &scsidp->sdev_gendev,
+	sdev_printk(KERN_NOTICE, scsidp,
 	       "Attached scsi generic sg%d, type %d\n", k, scsidp->type);
 
 	return 0;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index b5bd5cf..eb56d79 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -622,7 +622,7 @@ static int sr_probe(struct device *dev)
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
 
-	dev_printk(KERN_DEBUG, &sdev->sdev_gendev,
+	sdev_printk(KERN_DEBUG, sdev,
 	    "Attached scsi CD-ROM %s\n", cd->cdi.name);
 	return 0;
 
