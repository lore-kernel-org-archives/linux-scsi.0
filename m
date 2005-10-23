From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC] kill scsi_device::{channel,id} in generic code
Date: Sat, 22 Oct 2005 22:41:04 -0400
Message-ID: <20051023024104.GA20128@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:19679 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751392AbVJWClI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 22:41:08 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id EB4921C0960B
	for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2005 22:41:04 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N2f4bN020239
	for linux-scsi@vger.kernel.org; Sat, 22 Oct 2005 22:41:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


As a thought experiment, I deleted 'channel' and 'id' members from
struct scsi_device, and took a look at what broke.  This patch is the
result.

DO NOT APPLY.  For discussion only.

Changes:

* it appears that a bunch of messages could be converted to
  calling dev_printk(), completely eliminating references to
  sdev->{id,channel}

* for references that could not be eliminated by dev_printk(),
  wrapped them using new wrappers sdev_id(), sdev_channel()
  for easy grepping later on.

* Defined sdev_id() as referring to sdev->sdev_target->id

* Defined sdev_channel() as referring to sdev->sdev_target->channel

* I converted all drivers/scsi/scsi*.c code that broke,
  but didn't touch any drivers (another likely heap o breakage).


diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index f6be2c1..553fb00 100644
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
+	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "command: ");
 	scsi_print_cdb(cmd->cmnd, cmd->cmd_len, 0);
 }
 EXPORT_SYMBOL(scsi_print_command);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1f0ebab..0cb69a5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -410,9 +410,8 @@ void scsi_log_send(struct scsi_cmnd *cmd
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
 			sdev = cmd->device;
-			printk(KERN_INFO "scsi <%d:%d:%d:%d> send ",
-			       sdev->host->host_no, sdev->channel, sdev->id,
-			       sdev->lun);
+			dev_printk(KERN_INFO, &sdev->sdev_gendev,
+				   "scsi send ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -456,9 +455,8 @@ void scsi_log_completion(struct scsi_cmn
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
 			sdev = cmd->device;
-			printk(KERN_INFO "scsi <%d:%d:%d:%d> done ",
-			       sdev->host->host_no, sdev->channel, sdev->id,
-			       sdev->lun);
+			dev_printk(KERN_INFO, &sdev->sdev_gendev,
+				   "scsi done ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -893,8 +891,9 @@ void scsi_finish_command(struct scsi_cmn
 	if (SCSI_SENSE_VALID(cmd))
 		cmd->result |= (DRIVER_SENSE << 24);
 
-	SCSI_LOG_MLCOMPLETE(4, printk("Notifying upper driver of completion "
-				"for device %d %x\n", sdev->id, cmd->result));
+	SCSI_LOG_MLCOMPLETE(4, dev_printk(KERN_INFO, &sdev->sdev_gendev,
+				"Notifying upper driver of completion "
+				"(result %x)\n", cmd->result));
 
 	/*
 	 * We can get here with use_sg=0, causing a panic in the upper level
@@ -970,10 +969,9 @@ void scsi_adjust_queue_depth(struct scsi
 			sdev->simple_tags = 1;
 			break;
 		default:
-			printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
+			dev_printk(KERN_WARNING, &sdev->sdev_gendev,
 				"scsi_adjust_queue_depth, bad queue type, "
-				"disabled\n", sdev->host->host_no,
-				sdev->channel, sdev->id, sdev->lun); 
+				"disabled\n");
 		case 0:
 			sdev->ordered_tags = sdev->simple_tags = 0;
 			sdev->queue_depth = tags;
@@ -1112,8 +1110,8 @@ void starget_for_each_device(struct scsi
 	struct scsi_device *sdev;
 
 	shost_for_each_device(sdev, shost) {
-		if ((sdev->channel == starget->channel) &&
-		    (sdev->id == starget->id))
+		if ((sdev_channel(sdev) == starget->channel) &&
+		    (sdev_id(sdev) == starget->id))
 			fn(sdev, data);
 	}
 }
@@ -1195,8 +1193,9 @@ struct scsi_device *__scsi_device_lookup
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
-		if (sdev->channel == channel && sdev->id == id &&
-				sdev->lun ==lun)
+		if (sdev_channel(sdev) == channel &&
+		    sdev_id(sdev) == id &&
+		    sdev->lun ==lun)
 			return sdev;
 	}
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 52b348c..fe5b9b9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -241,11 +241,10 @@ static inline void scsi_eh_prt_fail_stat
 
 		if (cmd_cancel || cmd_failed) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				printk("%s: %d:%d:%d:%d cmds failed: %d,"
+				dev_printk(KERN_INFO, &sdev->sdev_gendev,
+				       "%s: cmds failed: %d,"
 				       " cancel: %d\n",
-				       __FUNCTION__, shost->host_no,
-				       sdev->channel, sdev->id, sdev->lun,
-				       cmd_failed, cmd_cancel));
+				       __FUNCTION__, cmd_failed, cmd_cancel));
 			cmd_cancel = 0;
 			cmd_failed = 0;
 			++devices_failed;
@@ -674,10 +673,10 @@ static int scsi_eh_get_sense(struct list
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(2, printk("%s: requesting sense"
-						  " for id: %d\n",
-						  current->comm,
-						  scmd->device->id));
+		SCSI_LOG_ERROR_RECOVERY(2, dev_printk(KERN_INFO,
+						  &scmd->device->sdev_gendev,
+						  "%s: requesting sense\n",
+						  current->comm));
 		rtn = scsi_request_sense(scmd);
 		if (rtn != SUCCESS)
 			continue;
@@ -1035,7 +1034,8 @@ static int scsi_try_bus_reset(struct scs
 		if (!scmd->device->host->hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
+		scsi_report_bus_reset(scmd->device->host,
+				      sdev_channel(scmd->device));
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 	}
 
@@ -1063,7 +1063,8 @@ static int scsi_try_host_reset(struct sc
 		if (!scmd->device->host->hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
+		scsi_report_bus_reset(scmd->device->host,
+				      sdev_channel(scmd->device));
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 	}
 
@@ -1093,7 +1094,7 @@ static int scsi_eh_bus_reset(struct Scsi
 	for (channel = 0; channel <= shost->max_channel; channel++) {
 		chan_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry) {
-			if (channel == scmd->device->channel) {
+			if (channel == sdev_channel(scmd->device)) {
 				chan_scmd = scmd;
 				break;
 				/*
@@ -1111,7 +1112,7 @@ static int scsi_eh_bus_reset(struct Scsi
 		rtn = scsi_try_bus_reset(chan_scmd);
 		if (rtn == SUCCESS) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-				if (channel == scmd->device->channel)
+				if (channel == sdev_channel(scmd->device))
 					if (!scsi_device_online(scmd->device) ||
 					    !scsi_eh_tur(scmd))
 						scsi_eh_finish_cmd(scmd,
@@ -1174,13 +1175,9 @@ static void scsi_eh_offline_sdevs(struct
 	struct scsi_cmnd *scmd, *next;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-		printk(KERN_INFO "scsi: Device offlined - not"
-		       		" ready after error recovery: host"
-				" %d channel %d id %d lun %d\n",
-				scmd->device->host->host_no,
-				scmd->device->channel,
-				scmd->device->id,
-				scmd->device->lun);
+		dev_printk(KERN_INFO, &scmd->device->sdev_gendev,
+				"Device offlined - not"
+		       		" ready after error recovery\n");
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
 		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
 			/*
@@ -1342,10 +1339,8 @@ int scsi_decide_disposition(struct scsi_
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		printk(KERN_INFO "scsi: reservation conflict: host"
-                                " %d channel %d id %d lun %d\n",
-		       scmd->device->host->host_no, scmd->device->channel,
-		       scmd->device->id, scmd->device->lun);
+		dev_printk(KERN_INFO, &scmd->device->sdev_gendev,
+				"reservation conflict\n");
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
@@ -1683,7 +1678,7 @@ void scsi_report_bus_reset(struct Scsi_H
 	struct scsi_device *sdev;
 
 	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev->channel) {
+		if (channel == sdev_channel(sdev)) {
 			sdev->was_reset = 1;
 			sdev->expecting_cc_ua = 1;
 		}
@@ -1718,8 +1713,8 @@ void scsi_report_device_reset(struct Scs
 	struct scsi_device *sdev;
 
 	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev->channel &&
-		    target == sdev->id) {
+		if (channel == sdev_channel(sdev) &&
+		    target == sdev_id(sdev)) {
 			sdev->was_reset = 1;
 			sdev->expecting_cc_ua = 1;
 		}
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index de7f98c..43cb1f1 100644
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
+			dev_printk(KERN_INFO, &sdev->sdev_gendev,
+			       "ioctl_internal_command: return code = %x\n",
 			       result);
 			scsi_print_sense_hdr("   ", &sshdr);
 			break;
@@ -398,9 +394,9 @@ int scsi_ioctl(struct scsi_device *sdev,
 		if (!access_ok(VERIFY_WRITE, arg, sizeof(struct scsi_idlun)))
 			return -EFAULT;
 
-		__put_user((sdev->id & 0xff)
+		__put_user((sdev_id(sdev) & 0xff)
 			 + ((sdev->lun & 0xff) << 8)
-			 + ((sdev->channel & 0xff) << 16)
+			 + ((sdev_channel(sdev) & 0xff) << 16)
 			 + ((sdev->host->host_no & 0xff) << 24),
 			 &((struct scsi_idlun __user *)arg)->dev_id);
 		__put_user(sdev->host->unique_id,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dc9c772..5a38708 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1140,8 +1140,8 @@ static int scsi_prep_fn(struct request_q
 	 * online before trying any recovery commands
 	 */
 	if (unlikely(!scsi_device_online(sdev))) {
-		printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
-		       sdev->host->host_no, sdev->id, sdev->lun);
+		dev_printk(KERN_ERR, &sdev->sdev_gendev,
+		       "rejecting I/O to offline device\n");
 		goto kill;
 	}
 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
@@ -1150,8 +1150,8 @@ static int scsi_prep_fn(struct request_q
 		if (sdev->sdev_state == SDEV_DEL) {
 			/* Device is fully deleted, no commands
 			 * at all allowed down */
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to dead device\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			       "rejecting I/O to dead device\n");
 			goto kill;
 		}
 		/* OK, we only allow special commands (i.e. not
@@ -1186,8 +1186,8 @@ static int scsi_prep_fn(struct request_q
 					specials_only == SDEV_BLOCK)
 				goto defer;
 			
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			       "rejecting I/O to device being removed\n");
 			goto kill;
 		}
 			
@@ -1314,9 +1314,8 @@ static inline int scsi_dev_queue_ready(s
 		 */
 		if (--sdev->device_blocked == 0) {
 			SCSI_LOG_MLQUEUE(3,
-				printk("scsi%d (%d:%d) unblocking device at"
-				       " zero depth\n", sdev->host->host_no,
-				       sdev->id, sdev->lun));
+				dev_printk(KERN_INFO, &sdev->sdev_gendev,
+				       "unblocking device at zero depth\n"));
 		} else {
 			blk_plug_device(q);
 			return 0;
@@ -1435,8 +1434,8 @@ static void scsi_request_fn(struct reque
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
-			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
-			       sdev->host->host_no, sdev->id, sdev->lun);
+			dev_printk(KERN_ERR, &sdev->sdev_gendev,
+			       "rejecting I/O to offline device\n");
 			scsi_kill_request(req, q);
 			continue;
 		}
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index a50958b..43a9ec2 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -150,7 +150,9 @@ static int proc_print_scsidevice(struct 
 
 	seq_printf(s,
 		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+		sdev->host->host_no, sdev_channel(sdev), sdev_id(sdev),
+		sdev->lun);
+
 	for (i = 0; i < 8; i++) {
 		if (sdev->vendor[i] >= 0x20)
 			seq_printf(s, "%c", sdev->vendor[i]);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 327c5d7..cf6f8bc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -215,9 +215,7 @@ static struct scsi_device *scsi_alloc_sd
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
 	sdev->host = shost;
-	sdev->id = starget->id;
 	sdev->lun = lun;
-	sdev->channel = starget->channel;
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
@@ -462,10 +460,9 @@ static int scsi_probe_lun(struct scsi_de
 	pass = 1;
 
  next_pass:
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY pass %d "
-			"to host %d channel %d id %d lun %d, length %d\n",
-			pass, sdev->host->host_no, sdev->channel,
-			sdev->id, sdev->lun, try_inquiry_len));
+	SCSI_LOG_SCAN_BUS(3, dev_printk(KERN_INFO, &sdev->sdev_gendev,
+			"scsi scan: INQUIRY pass %d, length %d\n",
+			pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
 	for (count = 0; count < 3; ++count) {
@@ -696,8 +693,8 @@ static int scsi_add_lun(struct scsi_devi
 		sdev->sdtr = 1;
 
 	sprintf(sdev->devfs_name, "scsi/host%d/bus%d/target%d/lun%d",
-				sdev->host->host_no, sdev->channel,
-				sdev->id, sdev->lun);
+				sdev->host->host_no, sdev_channel(sdev),
+				sdev_id(sdev), sdev->lun);
 
 	/*
 	 * End driverfs/devfs code.
@@ -1098,7 +1095,7 @@ static int scsi_report_lun_scan(struct s
 	}
 
 	sprintf(devname, "host %d channel %d id %d",
-		shost->host_no, sdev->channel, sdev->id);
+		shost->host_no, sdev_channel(sdev), sdev_id(sdev));
 
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
@@ -1190,9 +1187,8 @@ static int scsi_report_lun_scan(struct s
 		num_luns = max_scsi_report_luns;
 	}
 
-	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUN scan of"
-			" host %d channel %d id %d\n", sdev->host->host_no,
-			sdev->channel, sdev->id));
+	SCSI_LOG_SCAN_BUS(3, dev_printk (KERN_INFO, &sdev->sdev_gendev,
+			"scsi scan: REPORT LUN scan\n"));
 
 	/*
 	 * Scan the luns in lun_data. The entry at offset 0 is really
@@ -1541,7 +1537,7 @@ EXPORT_SYMBOL(scsi_get_host_dev);
  */
 void scsi_free_host_dev(struct scsi_device *sdev)
 {
-	BUG_ON(sdev->id != sdev->host->this_id);
+	BUG_ON(sdev_id(sdev) != sdev->host->this_id);
 
 	scsi_destroy_sdev(sdev);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 72a6550..3a914cf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -727,9 +727,7 @@ void __scsi_remove_target(struct scsi_ta
 	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
-		if (sdev->channel != starget->channel ||
-		    sdev->id != starget->id ||
-		    sdev->sdev_state == SDEV_DEL)
+		if (sdev->sdev_state == SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
@@ -866,7 +864,7 @@ void scsi_sysfs_device_initialize(struct
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.release = scsi_device_dev_release;
 	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
-		sdev->host->host_no, sdev->channel, sdev->id,
+		sdev->host->host_no, sdev_channel(sdev), sdev_id(sdev),
 		sdev->lun);
 	
 	class_device_initialize(&sdev->sdev_classdev);
@@ -874,7 +872,7 @@ void scsi_sysfs_device_initialize(struct
 	sdev->sdev_classdev.class = &sdev_class;
 	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
 		 "%d:%d:%d:%d", sdev->host->host_no,
-		 sdev->channel, sdev->id, sdev->lun);
+		 sdev_channel(sdev), sdev_id(sdev), sdev->lun);
 	sdev->scsi_level = SCSI_2;
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9a1dc0c..b6cbb4f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1535,8 +1535,8 @@ static int sd_probe(struct device *dev)
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
 		goto out;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
-			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
+	SCSI_LOG_HLQUEUE(3, dev_printk(KERN_INFO, &sdp->sdev_gendev,
+			"sd_attach\n"));
 
 	error = -ENOMEM;
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
@@ -1608,10 +1608,10 @@ static int sd_probe(struct device *dev)
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 
-	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
-	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
-	       gd->disk_name, sdp->host->host_no, sdp->channel,
-	       sdp->id, sdp->lun);
+	dev_printk(KERN_NOTICE, &sdp->sdev_gendev,
+		"Attached scsi %sdisk %s\n",
+	       sdp->removable ? "removable " : "",
+	       gd->disk_name);
 
 	return 0;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ad94367..b03e2fd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -885,9 +885,9 @@ sg_ioctl(struct inode *inode, struct fil
 				return -ENODEV;
 			__put_user((int) sdp->device->host->host_no,
 				   &sg_idp->host_no);
-			__put_user((int) sdp->device->channel,
+			__put_user((int) sdev_channel(sdp->device),
 				   &sg_idp->channel);
-			__put_user((int) sdp->device->id, &sg_idp->scsi_id);
+			__put_user((int) sdev_id(sdp->device), &sg_idp->scsi_id);
 			__put_user((int) sdp->device->lun, &sg_idp->lun);
 			__put_user((int) sdp->device->type, &sg_idp->scsi_type);
 			__put_user((short) sdp->device->host->cmd_per_lun,
@@ -1497,10 +1497,9 @@ static int sg_alloc(struct gendisk *disk
 
  overflow:
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-	printk(KERN_WARNING
-	       "Unable to attach sg device <%d, %d, %d, %d> type=%d, minor "
-	       "number exceeds %d\n", scsidp->host->host_no, scsidp->channel,
-	       scsidp->id, scsidp->lun, scsidp->type, SG_MAX_DEVS - 1);
+	dev_printk(KERN_WARNING, &scsidp->sdev_gendev,
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
+	dev_printk(KERN_NOTICE, &scsidp->sdev_gendev,
+	       "Attached scsi generic sg%d, type %d\n", k, scsidp->type);
 
 	return 0;
 
@@ -3009,8 +3005,8 @@ static int sg_proc_seq_show_dev(struct s
 	sdp = it ? sg_get_dev(it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
 		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
-			      scsidp->host->host_no, scsidp->channel,
-			      scsidp->id, scsidp->lun, (int) scsidp->type,
+			      scsidp->host->host_no, sdev_channel(scsidp),
+			      sdev_id(scsidp), scsidp->lun, (int) scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
 			      (int) scsidp->device_busy,
@@ -3135,7 +3131,7 @@ static int sg_proc_seq_show_debug(struct
 				seq_printf
 				    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
 				     scsidp->host->host_no,
-				     scsidp->channel, scsidp->id,
+				     sdev_channel(scsidp), sdev_id(scsidp),
 				     scsidp->lun,
 				     scsidp->host->hostt->emulated);
 			seq_printf(s, " sg_tablesize=%d excl=%d\n",
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 561901b..b5bd5cf 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -622,10 +622,8 @@ static int sr_probe(struct device *dev)
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
 
-	printk(KERN_DEBUG
-	    "Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
-	    cd->cdi.name, sdev->host->host_no, sdev->channel,
-	    sdev->id, sdev->lun);
+	dev_printk(KERN_DEBUG, &sdev->sdev_gendev,
+	    "Attached scsi CD-ROM %s\n", cd->cdi.name);
 	return 0;
 
 fail_put:
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7ece056..8fdd70b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -66,7 +66,7 @@ struct scsi_device {
 					   jiffie count on our counter, they
 					   could all be from the same event. */
 
-	unsigned int id, lun, channel;
+	unsigned int lun;
 
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
@@ -266,6 +266,16 @@ extern int scsi_execute_req(struct scsi_
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
 
+static inline unsigned int sdev_channel(struct scsi_device *sdev)
+{
+	return sdev->sdev_target->channel;
+}
+
+static inline unsigned int sdev_id(struct scsi_device *sdev)
+{
+	return sdev->sdev_target->id;
+}
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
