From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 4/5] scsi_dh: Update EMC handler
Date: Fri, 09 May 2008 11:39:55 +0200
Message-ID: <20080509093955.2E50110B5DF@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:54339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565AbYEIJj4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 May 2008 05:39:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


This patch converts the EMC device handler to use a proper
state machine. It also adds checking at init time to
refuse to attach to devices not supporting the EMC-specific
VPD pages.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |  354 ++++++++++++++++++-----------
 1 files changed, 217 insertions(+), 137 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6b81ee5..8846b8b 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -25,13 +25,25 @@
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_device.h>
 
-#define CLARIION_NAME			"emc_clariion"
+#define CLARIION_NAME			"emc"
 
 #define CLARIION_TRESPASS_PAGE		0x22
 #define CLARIION_BUFFER_SIZE		0x80
 #define CLARIION_TIMEOUT		(60 * HZ)
 #define CLARIION_RETRIES		3
 #define CLARIION_UNBOUND_LU		-1
+#define CLARIION_SP_A			0
+#define CLARIION_SP_B			1
+
+/* Flags */
+#define CLARIION_SHORT_TRESPASS		1
+#define CLARIION_HONOR_RESERVATIONS	2
+
+/* LUN states */
+#define CLARIION_LUN_UNINITIALIZED	-1
+#define CLARIION_LUN_UNBOUND		0
+#define CLARIION_LUN_BOUND		1
+#define CLARIION_LUN_OWNED		2
 
 static unsigned char long_trespass[] = {
 	0, 0, 0, 0,
@@ -67,27 +79,47 @@ static unsigned char short_trespass_hr[] = {
 	0xff,			/* Trespass target */
 };
 
+static const char * lun_state[] =
+{
+    "not bound",
+    "bound",
+    "owned",
+};
+
 struct clariion_dh_data {
 	/*
+	 * Flags:
+	 *  CLARIION_SHORT_TRESPASS
 	 * Use short trespass command (FC-series) or the long version
 	 * (default for AX/CX CLARiiON arrays).
-	 */
-	unsigned short_trespass;
-	/*
+	 *
+	 *  CLARIION_HONOR_RESERVATIONS
 	 * Whether or not (default) to honor SCSI reservations when
 	 * initiating a switch-over.
 	 */
-	unsigned hr;
-	/* I/O buffer for both MODE_SELECT and INQUIRY commands. */
+	unsigned flags;
+	/*
+	 * I/O buffer for both MODE_SELECT and INQUIRY commands.
+	 */
 	char buffer[CLARIION_BUFFER_SIZE];
 	/*
 	 * SCSI sense buffer for commands -- assumes serial issuance
 	 * and completion sequence of all commands for same multipath.
 	 */
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
-	/* which SP (A=0,B=1,UNBOUND=-1) is dflt SP for path's mapped dev */
+	/*
+	 * LUN state
+	 */
+	int lun_state;
+	/*
+	 * which SP (A=0,B=1,UNBOUND=-1) is the default SP for this
+	 * path's mapped LUN
+	 */
 	int default_sp;
-	/* which SP (A=0,B=1,UNBOUND=-1) is active for path's mapped dev */
+	/*
+	 * which SP (A=0,B=1,UNBOUND=-1) is the active SP for this
+	 * path's mapped LUN
+	 */
 	int current_sp;
 };
 
@@ -102,19 +134,18 @@ static inline struct clariion_dh_data
 /*
  * Parse MODE_SELECT cmd reply.
  */
-static int trespass_endio(struct scsi_device *sdev, int result)
+static int trespass_endio(struct scsi_device *sdev)
 {
-	int err = SCSI_DH_OK;
+	int err = SCSI_DH_IO;
 	struct scsi_sense_hdr sshdr;
 	struct clariion_dh_data *csdev = get_clariion_data(sdev);
 	char *sense = csdev->sense;
 
-	if (status_byte(result) == CHECK_CONDITION &&
-	    scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
-		sdev_printk(KERN_ERR, sdev, "Found valid sense data 0x%2x, "
+	if (scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
+		sdev_printk(KERN_ERR, sdev, "%s: Found valid sense data 0x%2x, "
 			    "0x%2x, 0x%2x while sending CLARiiON trespass "
-			    "command.\n", sshdr.sense_key, sshdr.asc,
-			     sshdr.ascq);
+			    "command.\n", CLARIION_NAME, sshdr.sense_key,
+			    sshdr.asc, sshdr.ascq);
 
 		if ((sshdr.sense_key == 0x05) && (sshdr.asc == 0x04) &&
 		     (sshdr.ascq == 0x00)) {
@@ -122,9 +153,9 @@ static int trespass_endio(struct scsi_device *sdev, int result)
 			 * Array based copy in progress -- do not send
 			 * mode_select or copy will be aborted mid-stream.
 			 */
-			sdev_printk(KERN_INFO, sdev, "Array Based Copy in "
+			sdev_printk(KERN_INFO, sdev, "%s: Array Based Copy in "
 				    "progress while sending CLARiiON trespass "
-				    "command.\n");
+				    "command.\n", CLARIION_NAME);
 			err = SCSI_DH_DEV_TEMP_BUSY;
 		} else if ((sshdr.sense_key == 0x02) && (sshdr.asc == 0x04) &&
 			    (sshdr.ascq == 0x03)) {
@@ -132,109 +163,66 @@ static int trespass_endio(struct scsi_device *sdev, int result)
 			 * LUN Not Ready - Manual Intervention Required
 			 * indicates in-progress ucode upgrade (NDU).
 			 */
-			sdev_printk(KERN_INFO, sdev, "Detected in-progress "
+			sdev_printk(KERN_INFO, sdev, "%s: Detected in-progress "
 				    "ucode upgrade NDU operation while sending "
-				    "CLARiiON trespass command.\n");
+				    "CLARiiON trespass command.\n", CLARIION_NAME);
 			err = SCSI_DH_DEV_TEMP_BUSY;
 		} else
 			err = SCSI_DH_DEV_FAILED;
-	} else if (result) {
-		sdev_printk(KERN_ERR, sdev, "Error 0x%x while sending "
-			    "CLARiiON trespass command.\n", result);
-		err = SCSI_DH_IO;
 	}
 
 	return err;
 }
 
-static int parse_sp_info_reply(struct scsi_device *sdev, int result,
-		int *default_sp, int *current_sp, int *new_current_sp)
+static int parse_sp_info_reply(struct scsi_device *sdev,
+			       struct clariion_dh_data *csdev)
 {
 	int err = SCSI_DH_OK;
-	struct clariion_dh_data *csdev = get_clariion_data(sdev);
-
-	if (result == 0) {
-		/* check for in-progress ucode upgrade (NDU) */
-		if (csdev->buffer[48] != 0) {
-			sdev_printk(KERN_NOTICE, sdev, "Detected in-progress "
-			       "ucode upgrade NDU operation while finding "
-			       "current active SP.");
-			err = SCSI_DH_DEV_TEMP_BUSY;
-		} else {
-			*default_sp = csdev->buffer[5];
-
-			if (csdev->buffer[4] == 2)
-				/* SP for path is current */
-				*current_sp = csdev->buffer[8];
-			else {
-				if (csdev->buffer[4] == 1)
-					/* SP for this path is NOT current */
-					if (csdev->buffer[8] == 0)
-						*current_sp = 1;
-					else
-						*current_sp = 0;
-				else
-					/* unbound LU or LUNZ */
-					*current_sp = CLARIION_UNBOUND_LU;
-			}
-			*new_current_sp =  csdev->buffer[8];
-		}
-	} else {
-		struct scsi_sense_hdr sshdr;
-
-		err = SCSI_DH_IO;
 
-		if (scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
-							   &sshdr))
-			sdev_printk(KERN_ERR, sdev, "Found valid sense data "
-			      "0x%2x, 0x%2x, 0x%2x while finding current "
-			      "active SP.", sshdr.sense_key, sshdr.asc,
-			      sshdr.ascq);
-		else
-			sdev_printk(KERN_ERR, sdev, "Error 0x%x finding "
-			      "current active SP.", result);
+	/* check for in-progress ucode upgrade (NDU) */
+	if (csdev->buffer[48] != 0) {
+		sdev_printk(KERN_NOTICE, sdev, "%s: Detected in-progress "
+			    "ucode upgrade NDU operation while finding "
+			    "current active SP.", CLARIION_NAME);
+		err = SCSI_DH_DEV_TEMP_BUSY;
+		goto out;
+	}
+	if (csdev->buffer[4] < 0 || csdev->buffer[4] > 2) {
+		/* Invalid buffer format */
+		sdev_printk(KERN_NOTICE, sdev,
+			    "%s: invalid VPD page 0xC0 format\n",
+			    CLARIION_NAME);
+		err = SCSI_DH_NOSYS;
+		goto out;
+	}
+	switch (csdev->buffer[28] & 0x0f) {
+	case 6:
+		sdev_printk(KERN_NOTICE, sdev,
+			    "%s: ALUA failover mode detected\n",
+			    CLARIION_NAME);
+		break;
+	case 4:
+		/* Linux failover */
+		break;
+	default:
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: Invalid failover mode %d\n",
+			    CLARIION_NAME, csdev->buffer[28] & 0x0f);
+		err = SCSI_DH_NOSYS;
+		goto out;
 	}
 
-	return err;
-}
-
-static int sp_info_endio(struct scsi_device *sdev, int result,
-					int mode_select_sent, int *done)
-{
-	struct clariion_dh_data *csdev = get_clariion_data(sdev);
-	int err_flags, default_sp, current_sp, new_current_sp;
-
-	err_flags = parse_sp_info_reply(sdev, result, &default_sp,
-					     &current_sp, &new_current_sp);
+	csdev->default_sp = csdev->buffer[5];
+	csdev->lun_state = csdev->buffer[4];
+	csdev->current_sp = csdev->buffer[8];
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: LUN %s, dflt SP %c, curr SP %c, Port %d\n",
+		    CLARIION_NAME, lun_state[csdev->lun_state],
+		    csdev->default_sp + 'A', csdev->current_sp + 'A',
+		    csdev->buffer[7]);
 
-	if (err_flags != SCSI_DH_OK)
-		goto done;
-
-	if (mode_select_sent) {
-		csdev->default_sp = default_sp;
-		csdev->current_sp = current_sp;
-	} else {
-		/*
-		 * Issue the actual module_selec request IFF either
-		 * (1) we do not know the identity of the current SP OR
-		 * (2) what we think we know is actually correct.
-		 */
-		if ((current_sp != CLARIION_UNBOUND_LU) &&
-		    (new_current_sp != current_sp)) {
-
-			csdev->default_sp = default_sp;
-			csdev->current_sp = current_sp;
-
-			sdev_printk(KERN_INFO, sdev, "Ignoring path group "
-			       "switch-over command for CLARiiON SP%s since "
-			       " mapped device is already initialized.",
-			       current_sp ? "B" : "A");
-			if (done)
-				*done = 1; /* as good as doing it */
-		}
-	}
-done:
-	return err_flags;
+out:
+	return err;
 }
 
 /*
@@ -264,11 +252,13 @@ static struct request *get_req(struct scsi_device *sdev, int cmd)
 
 	switch (cmd) {
 	case MODE_SELECT:
-		if (csdev->short_trespass) {
-			page22 = csdev->hr ? short_trespass_hr : short_trespass;
+		if (csdev->flags & CLARIION_SHORT_TRESPASS) {
+			page22 = csdev->flags & CLARIION_HONOR_RESERVATIONS ?
+				short_trespass_hr : short_trespass;
 			len = sizeof(short_trespass);
 		} else {
-			page22 = csdev->hr ? long_trespass_hr : long_trespass;
+			page22 = csdev->flags & CLARIION_HONOR_RESERVATIONS ?
+				long_trespass_hr : long_trespass;
 			len = sizeof(long_trespass);
 		}
 		/*
@@ -302,9 +292,8 @@ static struct request *get_req(struct scsi_device *sdev, int cmd)
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
 
-	if (blk_rq_map_kern(sdev->request_queue, rq, csdev->buffer,
-							len, GFP_ATOMIC)) {
-		__blk_put_request(rq->q, rq);
+	if (blk_rq_map_kern(rq->q, rq, csdev->buffer, len, GFP_ATOMIC)) {
+		blk_put_request(rq);
 		return NULL;
 	}
 
@@ -314,31 +303,23 @@ static struct request *get_req(struct scsi_device *sdev, int cmd)
 static int send_cmd(struct scsi_device *sdev, int cmd)
 {
 	struct request *rq = get_req(sdev, cmd);
+	int err;
 
 	if (!rq)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
-	return blk_execute_rq(sdev->request_queue, NULL, rq, 1);
-}
-
-static int clariion_activate(struct scsi_device *sdev)
-{
-	int result, done = 0;
-
-	result = send_cmd(sdev, INQUIRY);
-	result = sp_info_endio(sdev, result, 0, &done);
-	if (result || done)
-		goto done;
-
-	result = send_cmd(sdev, MODE_SELECT);
-	result = trespass_endio(sdev, result);
-	if (result)
-		goto done;
+	err = blk_execute_rq(sdev->request_queue, NULL, rq, 1);
+	if (err == -EIO) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: failed to send %s: %x\n",
+			    CLARIION_NAME,
+			    cmd == INQUIRY?"INQUIRY":"MODE SELECT",
+			    rq->errors);
+		err = SCSI_DH_IO;
+	}
+	blk_put_request(rq);
 
-	result = send_cmd(sdev, INQUIRY);
-	result = sp_info_endio(sdev, result, 1, NULL);
-done:
-	return result;
+	return err;
 }
 
 static int clariion_check_sense(struct scsi_device *sdev,
@@ -363,6 +344,14 @@ static int clariion_check_sense(struct scsi_device *sdev,
 			return SUCCESS;
 		break;
 	case ILLEGAL_REQUEST:
+		if (sense_hdr->asc == 0x24 && sense_hdr->ascq == 0x00)
+			/*
+			 * Invalid field in CDB. Most likely long
+			 * trespass is not supported.
+			 *
+			 * Signal back an error.
+			 */
+			return SOFT_ERROR;
 		if (sense_hdr->asc == 0x25 && sense_hdr->ascq == 0x01)
 			/*
 			 * An array based copy is in progress. Do not
@@ -386,13 +375,87 @@ static int clariion_check_sense(struct scsi_device *sdev,
 		break;
 	}
 
-	/* success just means we do not care what scsi-ml does */
-	return SUCCESS;
+	return SCSI_RETURN_NOT_HANDLED;
+}
+
+static int clariion_prep_fn(struct scsi_device *sdev, struct request *req)
+{
+	struct clariion_dh_data *h = get_clariion_data(sdev);
+	int ret = BLKPREP_OK;
+
+	if (h->lun_state != CLARIION_LUN_OWNED) {
+		ret = BLKPREP_KILL;
+		req->cmd_flags |= REQ_QUIET;
+	}
+	return ret;
+
+}
+
+static int clariion_send_inquiry(struct scsi_device *sdev)
+{
+	int err, retry = CLARIION_RETRIES;
+	struct clariion_dh_data *csdev = get_clariion_data(sdev);
+
+retry:
+	err = send_cmd(sdev, INQUIRY);
+	if (err != SCSI_DH_OK) {
+		struct scsi_sense_hdr sshdr;
+
+		err = scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
+					   &sshdr);
+		if (!err)
+			return SCSI_DH_IO;
+
+		err = clariion_check_sense(sdev, &sshdr);
+		if (err == SOFT_ERROR) {
+			if (!(csdev->flags & CLARIION_SHORT_TRESPASS)) {
+				sdev_printk(KERN_INFO, sdev,
+					    "%s: using short trespass\n",
+					    CLARIION_NAME);
+				csdev->flags |= CLARIION_SHORT_TRESPASS;
+				err = NEEDS_RETRY;
+			} else {
+				err = SUCCESS;
+			}
+		}
+		if (retry > 0 && err == NEEDS_RETRY) {
+			retry--;
+			goto retry;
+		}
+		sdev_printk(KERN_ERR, sdev, "%s: INQUIRY sense code "
+			    "%02x/%02x/%02x\n", CLARIION_NAME,
+			      sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		err = SCSI_DH_IO;
+	} else {
+		err = parse_sp_info_reply(sdev, csdev);
+	}
+	return err;
+}
+
+static int clariion_activate(struct scsi_device *sdev)
+{
+	struct clariion_dh_data *csdev = get_clariion_data(sdev);
+	int result;
+
+	result = clariion_send_inquiry(sdev);
+	if (result != SCSI_DH_OK)
+		goto done;
+
+	if (csdev->lun_state == CLARIION_LUN_OWNED)
+		goto done;
+
+	result = send_cmd(sdev, MODE_SELECT);
+	if (result != SCSI_DH_OK)
+		result = trespass_endio(sdev);
+
+done:
+	return result;
 }
 
 const struct scsi_dh_devlist clariion_dev_list[] = {
 	{"DGC", "RAID"},
 	{"DGC", "DISK"},
+	{"DGC", "VRAID"},
 	{NULL, NULL},
 };
 
@@ -407,6 +470,7 @@ static struct scsi_device_handler clariion_dh = {
 	.detach		= clariion_bus_detach,
 	.check_sense	= clariion_check_sense,
 	.activate	= clariion_activate,
+	.prep_fn	= clariion_prep_fn,
 };
 
 /*
@@ -417,6 +481,7 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 	struct scsi_dh_data *scsi_dh_data;
 	struct clariion_dh_data *h;
 	unsigned long flags;
+	int err;
 
 	if (sdev->scsi_dh_data)
 		return -EBUSY;
@@ -424,13 +489,14 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
 			       + sizeof(*h) , GFP_KERNEL);
 	if (!scsi_dh_data) {
-		sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
+		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
 			    CLARIION_NAME);
 		return -ENOMEM;
 	}
 
 	scsi_dh_data->scsi_dh = &clariion_dh;
 	h = (struct clariion_dh_data *) scsi_dh_data->buf;
+	h->lun_state = CLARIION_LUN_UNINITIALIZED;
 	h->default_sp = CLARIION_UNBOUND_LU;
 	h->current_sp = CLARIION_UNBOUND_LU;
 
@@ -438,10 +504,23 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
+	err = clariion_send_inquiry(sdev);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
+	sdev_printk(KERN_NOTICE, sdev, "%s: Attached\n", CLARIION_NAME);
 	try_module_get(THIS_MODULE);
 
 	return 0;
+
+failed:
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	sdev->scsi_dh_data = NULL;
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	kfree(scsi_dh_data);
+	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
+		    CLARIION_NAME);
+	return -EINVAL;
 }
 
 static void clariion_bus_detach(struct scsi_device *sdev)
@@ -458,7 +537,7 @@ static void clariion_bus_detach(struct scsi_device *sdev)
 	sdev->scsi_dh_data = NULL;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-	sdev_printk(KERN_NOTICE, sdev, "Detached %s.\n",
+	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n",
 		    CLARIION_NAME);
 
 	kfree(scsi_dh_data);
@@ -471,7 +550,8 @@ static int __init clariion_init(void)
 
 	r = scsi_register_device_handler(&clariion_dh);
 	if (r != 0)
-		printk(KERN_ERR "Failed to register scsi device handler.");
+		printk(KERN_ERR "%s: Failed to register scsi device handler.",
+			CLARIION_NAME);
 	return r;
 }
 
-- 
1.5.2.4

