From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 9/n] sfoo_printk stuff merges
Date: Mon, 24 Oct 2005 01:14:37 -0400
Message-ID: <20051024051437.GA31756@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:44013 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750983AbVJXFOk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 01:14:40 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>


Went ahead and merged your (James's) sfoo_printk patch into my
working repo.

Since referencing cmd->device is a hugely common idiom, I made two new
wrappers:  scmd_printk() and scmd_id().



 drivers/scsi/constants.c          |    2 +-
 drivers/scsi/hosts.c              |    2 +-
 drivers/scsi/scsi.c               |    6 +++---
 drivers/scsi/scsi_error.c         |    5 ++---
 drivers/scsi/scsi_lib.c           |    6 +++---
 drivers/scsi/scsi_transport_fc.c  |    2 --
 drivers/scsi/scsi_transport_spi.c |   22 ++++++++++------------
 drivers/scsi/sd.c                 |    3 +--
 drivers/scsi/sr.c                 |   11 ++++++-----
 drivers/scsi/st.c                 |    7 +++----
 include/scsi/scsi_device.h        |   14 +++++++++++---
 include/scsi/scsi_host.h          |    4 ++++
 12 files changed, 45 insertions(+), 39 deletions(-)

2ce012dc6c227831bdf4ab0da0d70807ec8a2ef5
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 553fb00..8bd936b 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1389,7 +1389,7 @@ EXPORT_SYMBOL(scsi_print_msg);
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	/* Assume appended output (i.e. not at start of line) */
-	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "command: ");
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
index f710de0..6d29f3c 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -410,7 +410,7 @@ void scsi_log_send(struct scsi_cmnd *cmd
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
 			sdev = cmd->device;
-			sdev_printk(KERN_INFO, sdev, "scsi send ");
+			sdev_printk(KERN_INFO, sdev, "send ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -454,7 +454,7 @@ void scsi_log_completion(struct scsi_cmn
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
 			sdev = cmd->device;
-			sdev_printk(KERN_INFO, sdev, "scsi done ");
+			sdev_printk(KERN_INFO, sdev, "done ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -808,7 +808,7 @@ static void scsi_softirq(struct softirq_
 		disposition = scsi_decide_disposition(cmd);
 		if (disposition != SUCCESS &&
 		    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
-			sdev_printk(KERN_ERR, cmd->device,
+			scmd_printk(KERN_ERR, cmd,
 				   "timing out command, waited %lus\n",
 				   wait_for/HZ);
 			disposition = SUCCESS;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 867cc84..59e0f38 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1177,7 +1177,7 @@ static void scsi_eh_offline_sdevs(struct
 	struct scsi_cmnd *scmd, *next;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-		sdev_printk(KERN_INFO, scmd->device,
+		scmd_printk(KERN_INFO, scmd,
 				"Device offlined - not"
 		       		" ready after error recovery\n");
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
@@ -1341,8 +1341,7 @@ int scsi_decide_disposition(struct scsi_
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		sdev_printk(KERN_INFO, scmd->device,
-				"reservation conflict\n");
+		scmd_printk(KERN_INFO, scmd, "reservation conflict\n");
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a8ccffa..3543a8a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -951,13 +951,13 @@ void scsi_io_completion(struct scsi_cmnd
 				return;
 			}
 			if (!(req->flags & REQ_QUIET))
-				sdev_printk(KERN_INFO, cmd->device,
+				scmd_printk(KERN_INFO, cmd,
 					   "Device not ready.\n");
 			scsi_end_request(cmd, 0, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:
 			if (!(req->flags & REQ_QUIET)) {
-				sdev_printk(KERN_INFO, cmd->device,
+				scmd_printk(KERN_INFO, cmd,
 					   "Volume overflow, CDB: ");
 				__scsi_print_command(cmd->data_cmnd);
 				scsi_print_sense("", cmd);
@@ -979,7 +979,7 @@ void scsi_io_completion(struct scsi_cmnd
 	}
 	if (result) {
 		if (!(req->flags & REQ_QUIET)) {
-			sdev_printk(KERN_INFO, cmd->device,
+			scmd_printk(KERN_INFO, cmd,
 				   "SCSI error: return code = 0x%x\n", result);
 
 			if (driver_byte(result) & DRIVER_SENSE)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index f811ecf..cd4d987 100644
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
index 2d83310..718a2bc 100644
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
index 7c83923..d4abb09 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1608,8 +1608,7 @@ static int sd_probe(struct device *dev)
 	add_disk(gd);
 
 	sdev_printk(KERN_NOTICE, sdp, "Attached scsi %sdisk %s\n",
-	       sdp->removable ? "removable " : "",
-	       gd->disk_name);
+	       sdp->removable ? "removable " : "", gd->disk_name);
 
 	return 0;
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index eb56d79..3bf06fb 100644
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
 
@@ -623,7 +624,7 @@ static int sr_probe(struct device *dev)
 	add_disk(disk);
 
 	sdev_printk(KERN_DEBUG, sdev,
-	    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+		"Attached scsi CD-ROM %s\n", cd->cdi.name);
 	return 0;
 
 fail_put:
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f2807cc..1e8ccbe 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3885,8 +3885,7 @@ static int st_probe(struct device *dev)
 	if (SDp->type != TYPE_TAPE)
 		return -ENODEV;
 	if ((stp = st_incompatible(SDp))) {
-		sdev_printk(KERN_INFO, SDp,
-		       "st: Found incompatible tape\n");
+		sdev_printk(KERN_INFO, SDp, "Found incompatible tape\n");
 		printk(KERN_INFO "st: The suggested driver is %s.\n", stp);
 		return -ENODEV;
 	}
@@ -4074,8 +4073,8 @@ static int st_probe(struct device *dev)
 	}
 	disk->number = devfs_register_tape(SDp->devfs_name);
 
-	sdev_printk(KERN_WARNING, SDp, "Attached scsi tape %s\n",
-		tape_name(tpnt));
+	sdev_printk(KERN_WARNING, SDp,
+		"Attached scsi tape %s\n", tape_name(tpnt));
 
 	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B), max page reachable by HBA %lu\n",
 	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 986a59d..140e27b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -149,6 +149,12 @@ struct scsi_device {
 #define transport_class_to_sdev(class_dev) \
 	to_scsi_device(class_dev->dev)
 
+#define sdev_printk(prefix, sdev, fmt, a...)	\
+	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
+
+#define scmd_printk(prefix, scmd, fmt, a...)	\
+	dev_printk(prefix, &(scmd)->device->sdev_gendev, fmt, ##a)
+
 /*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
@@ -178,6 +184,9 @@ static inline struct scsi_target *scsi_t
 #define transport_class_to_starget(class_dev) \
 	to_scsi_target(class_dev->dev)
 
+#define starget_printk(prefix, starget, fmt, a...)	\
+	dev_printk(prefix, &(starget)->dev, fmt, ##a)
+
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, const struct scsi_lun *, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
@@ -268,9 +277,6 @@ extern int scsi_execute_req(struct scsi_
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
 
-#define sdev_printk(loglevel, scsidev, fmt, args...) \
-	dev_printk(loglevel, &(scsidev)->sdev_gendev, fmt, ## args)
-
 static inline unsigned int sdev_channel(struct scsi_device *sdev)
 {
 	return sdev->sdev_target->channel;
@@ -281,6 +287,8 @@ static inline unsigned int sdev_id(struc
 	return sdev->sdev_target->id;
 }
 
+#define scmd_id(scmd) sdev_id((scmd)->device)
+
 static inline char *scsilun_to_str(const struct scsi_lun *lun, char *s)
 {
 	sprintf(s, "%d", scsilun_to_int(lun));
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e5a276c..35691ee 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -614,6 +614,10 @@ struct Scsi_Host {
 #define		class_to_shost(d)	\
 	container_of(d, struct Scsi_Host, shost_classdev)
 
+#define shost_printk(prefix, shost, fmt, a...)	\
+	dev_printk(prefix, &(shost)->shost_gendev, fmt, ##a)
+
+
 int scsi_is_host_device(const struct device *);
 
 static inline struct Scsi_Host *dev_to_shost(struct device *dev)
