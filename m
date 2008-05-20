From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 4/7] scsi_dh: Update EMC handler
Date: Tue, 20 May 2008 16:05:40 +0200
Message-ID: <20080520140540.1AF9B10B5DF@craiglockhart-ipmi.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This patch converts the EMC device handler to use a proper
state machine. We now also parse the extended INQUIRY
information to determine if long trespass commands are
supported. And we're now using the long trespass command
correctly. And finally there's now an check at init time
to refuse to attach to devices not supporting EMC-specific
VPD pages.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |  545 +++++++++++++++++++----------
 1 files changed, 368 insertions(+), 177 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6b81ee5..f68a4d1 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -25,28 +25,31 @@
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_device.h>
 
-#define CLARIION_NAME			"emc_clariion"
+#define CLARIION_NAME			"emc"
 
 #define CLARIION_TRESPASS_PAGE		0x22
-#define CLARIION_BUFFER_SIZE		0x80
+#define CLARIION_BUFFER_SIZE		0xFC
 #define CLARIION_TIMEOUT		(60 * HZ)
 #define CLARIION_RETRIES		3
 #define CLARIION_UNBOUND_LU		-1
+#define CLARIION_SP_A			0
+#define CLARIION_SP_B			1
 
-static unsigned char long_trespass[] = {
-	0, 0, 0, 0,
-	CLARIION_TRESPASS_PAGE,	/* Page code */
-	0x09,			/* Page length - 2 */
-	0x81,			/* Trespass code + Honor reservation bit */
-	0xff, 0xff,		/* Trespass target */
-	0, 0, 0, 0, 0, 0	/* Reserved bytes / unknown */
-};
+/* Flags */
+#define CLARIION_SHORT_TRESPASS		1
+#define CLARIION_HONOR_RESERVATIONS	2
 
-static unsigned char long_trespass_hr[] = {
-	0, 0, 0, 0,
+/* LUN states */
+#define CLARIION_LUN_UNINITIALIZED	-1
+#define CLARIION_LUN_UNBOUND		0
+#define CLARIION_LUN_BOUND		1
+#define CLARIION_LUN_OWNED		2
+
+static unsigned char long_trespass[] = {
+	0, 0, 0, 0, 0, 0, 0, 0,
 	CLARIION_TRESPASS_PAGE,	/* Page code */
 	0x09,			/* Page length - 2 */
-	0x01,			/* Trespass code + Honor reservation bit */
+	0x01,			/* Trespass code */
 	0xff, 0xff,		/* Trespass target */
 	0, 0, 0, 0, 0, 0	/* Reserved bytes / unknown */
 };
@@ -55,39 +58,56 @@ static unsigned char short_trespass[] = {
 	0, 0, 0, 0,
 	CLARIION_TRESPASS_PAGE,	/* Page code */
 	0x02,			/* Page length - 2 */
-	0x81,			/* Trespass code + Honor reservation bit */
+	0x01,			/* Trespass code */
 	0xff,			/* Trespass target */
 };
 
-static unsigned char short_trespass_hr[] = {
-	0, 0, 0, 0,
-	CLARIION_TRESPASS_PAGE,	/* Page code */
-	0x02,			/* Page length - 2 */
-	0x01,			/* Trespass code + Honor reservation bit */
-	0xff,			/* Trespass target */
+static const char * lun_state[] =
+{
+    "not bound",
+    "bound",
+    "owned",
 };
 
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
+	unsigned int senselen;
+	/*
+	 * LUN state
+	 */
+	int lun_state;
+	/*
+	 * SP Port number
+	 */
+	int port;
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
 
@@ -102,19 +122,16 @@ static inline struct clariion_dh_data
 /*
  * Parse MODE_SELECT cmd reply.
  */
-static int trespass_endio(struct scsi_device *sdev, int result)
+static int trespass_endio(struct scsi_device *sdev, char *sense)
 {
-	int err = SCSI_DH_OK;
+	int err = SCSI_DH_IO;
 	struct scsi_sense_hdr sshdr;
-	struct clariion_dh_data *csdev = get_clariion_data(sdev);
-	char *sense = csdev->sense;
 
-	if (status_byte(result) == CHECK_CONDITION &&
-	    scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
-		sdev_printk(KERN_ERR, sdev, "Found valid sense data 0x%2x, "
+	if (!scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
+		sdev_printk(KERN_ERR, sdev, "%s: Found valid sense data 0x%2x, "
 			    "0x%2x, 0x%2x while sending CLARiiON trespass "
-			    "command.\n", sshdr.sense_key, sshdr.asc,
-			     sshdr.ascq);
+			    "command.\n", CLARIION_NAME, sshdr.sense_key,
+			    sshdr.asc, sshdr.ascq);
 
 		if ((sshdr.sense_key == 0x05) && (sshdr.asc == 0x04) &&
 		     (sshdr.ascq == 0x00)) {
@@ -122,9 +139,9 @@ static int trespass_endio(struct scsi_device *sdev, int result)
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
@@ -132,109 +149,113 @@ static int trespass_endio(struct scsi_device *sdev, int result)
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
+	} else {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: failed to send MODE SELECT, no sense available\n",
+			    CLARIION_NAME);
 	}
-
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
 
-		err = SCSI_DH_IO;
-
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
 
+	csdev->default_sp = csdev->buffer[5];
+	csdev->lun_state = csdev->buffer[4];
+	csdev->current_sp = csdev->buffer[8];
+	csdev->port = csdev->buffer[7];
+
+out:
 	return err;
 }
 
-static int sp_info_endio(struct scsi_device *sdev, int result,
-					int mode_select_sent, int *done)
+#define emc_default_str "FC (Legacy)"
+
+static char * parse_sp_model(struct scsi_device *sdev, unsigned char *buffer)
 {
-	struct clariion_dh_data *csdev = get_clariion_data(sdev);
-	int err_flags, default_sp, current_sp, new_current_sp;
+	unsigned char len = buffer[4] + 5;
+	char *sp_model = NULL;
+	unsigned char sp_len, serial_len;
+
+	if (len < 160) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: Invalid information section length %d\n",
+			    CLARIION_NAME, len);
+		/* Check for old FC arrays */
+		if (!strncmp(buffer + 8, "DGC", 3)) {
+			/* Old FC array, not supporting extended information */
+			sp_model = emc_default_str;
+		}
+		goto out;
+	}
 
-	err_flags = parse_sp_info_reply(sdev, result, &default_sp,
-					     &current_sp, &new_current_sp);
+	/*
+	 * Parse extended information for SP model number
+	 */
+	serial_len = buffer[160];
+	if (serial_len == 0 || serial_len + 161 > len) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: Invalid array serial number length %d\n",
+			    CLARIION_NAME, serial_len);
+		goto out;
+	}
+	sp_len = buffer[99];
+	if (sp_len == 0 || serial_len + sp_len + 161 > len) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: Invalid model number length %d\n",
+			    CLARIION_NAME, sp_len);
+		goto out;
+	}
+	sp_model = &buffer[serial_len + 161];
+	/* Strip whitespace at the end */
+	while (sp_len > 1 && sp_model[sp_len - 1] == ' ')
+		sp_len--;
 
-	if (err_flags != SCSI_DH_OK)
-		goto done;
+	sp_model[sp_len] = '\0';
 
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
+	return sp_model;
 }
 
 /*
@@ -244,11 +265,10 @@ done:
 * Uses data and sense buffers in hardware handler context structure and
 * assumes serial servicing of commands, both issuance and completion.
 */
-static struct request *get_req(struct scsi_device *sdev, int cmd)
+static struct request *get_req(struct scsi_device *sdev, int cmd,
+			       unsigned char *buffer)
 {
-	struct clariion_dh_data *csdev = get_clariion_data(sdev);
 	struct request *rq;
-	unsigned char *page22;
 	int len = 0;
 
 	rq = blk_get_request(sdev->request_queue,
@@ -258,34 +278,23 @@ static struct request *get_req(struct scsi_device *sdev, int cmd)
 		return NULL;
 	}
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	memset(rq->cmd, 0, BLK_MAX_CDB);
+	rq->cmd_len = COMMAND_SIZE(cmd);
 	rq->cmd[0] = cmd;
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
 
 	switch (cmd) {
 	case MODE_SELECT:
-		if (csdev->short_trespass) {
-			page22 = csdev->hr ? short_trespass_hr : short_trespass;
-			len = sizeof(short_trespass);
-		} else {
-			page22 = csdev->hr ? long_trespass_hr : long_trespass;
-			len = sizeof(long_trespass);
-		}
-		/*
-		 * Can't DMA from kernel BSS -- must copy selected trespass
-		 * command mode page contents to context buffer which is
-		 * allocated by kmalloc.
-		 */
-		BUG_ON((len > CLARIION_BUFFER_SIZE));
-		memcpy(csdev->buffer, page22, len);
+		len = sizeof(short_trespass);
+		rq->cmd_flags |= REQ_RW;
+		rq->cmd[1] = 0x10;
+	case MODE_SELECT_10:
+		len = sizeof(long_trespass);
 		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		break;
 	case INQUIRY:
-		rq->cmd[1] = 0x1;
-		rq->cmd[2] = 0xC0;
 		len = CLARIION_BUFFER_SIZE;
-		memset(csdev->buffer, 0, CLARIION_BUFFER_SIZE);
+		memset(buffer, 0, len);
 		break;
 	default:
 		BUG_ON(1);
@@ -298,47 +307,94 @@ static struct request *get_req(struct scsi_device *sdev, int cmd)
 	rq->timeout = CLARIION_TIMEOUT;
 	rq->retries = CLARIION_RETRIES;
 
-	rq->sense = csdev->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
-
-	if (blk_rq_map_kern(sdev->request_queue, rq, csdev->buffer,
-							len, GFP_ATOMIC)) {
-		__blk_put_request(rq->q, rq);
+	if (blk_rq_map_kern(rq->q, rq, buffer, len, GFP_ATOMIC)) {
+		blk_put_request(rq);
 		return NULL;
 	}
 
 	return rq;
 }
 
-static int send_cmd(struct scsi_device *sdev, int cmd)
+static int send_inquiry_cmd(struct scsi_device *sdev, int page,
+			    struct clariion_dh_data *csdev)
 {
-	struct request *rq = get_req(sdev, cmd);
+	struct request *rq = get_req(sdev, INQUIRY, csdev->buffer);
+	int err;
 
 	if (!rq)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
-	return blk_execute_rq(sdev->request_queue, NULL, rq, 1);
+	rq->sense = csdev->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = csdev->senselen = 0;
+
+	rq->cmd[0] = INQUIRY;
+	if (page != 0) {
+		rq->cmd[1] = 1;
+		rq->cmd[2] = page;
+	}
+	err = blk_execute_rq(sdev->request_queue, NULL, rq, 1);
+	if (err == -EIO) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: failed to send %s INQUIRY: %x\n",
+			    CLARIION_NAME, page?"EVPD":"standard",
+			    rq->errors);
+		csdev->senselen = rq->sense_len;
+		err = SCSI_DH_IO;
+	}
+
+	blk_put_request(rq);
+
+	return err;
 }
 
-static int clariion_activate(struct scsi_device *sdev)
+static int send_trespass_cmd(struct scsi_device *sdev,
+			    struct clariion_dh_data *csdev)
 {
-	int result, done = 0;
+	struct request *rq;
+	unsigned char *page22;
+	int err, len, cmd;
+
+	if (csdev->flags & CLARIION_SHORT_TRESPASS) {
+		page22 = short_trespass;
+		if (!(csdev->flags & CLARIION_HONOR_RESERVATIONS))
+			/* Set Honor Reservations bit */
+			page22[6] |= 0x80;
+		len = sizeof(short_trespass);
+		cmd = MODE_SELECT;
+	} else {
+		page22 = long_trespass;
+		if (!(csdev->flags & CLARIION_HONOR_RESERVATIONS))
+			/* Set Honor Reservations bit */
+			page22[10] |= 0x80;
+		len = sizeof(long_trespass);
+		cmd = MODE_SELECT_10;
+	}
+	BUG_ON((len > CLARIION_BUFFER_SIZE));
+	memcpy(csdev->buffer, page22, len);
 
-	result = send_cmd(sdev, INQUIRY);
-	result = sp_info_endio(sdev, result, 0, &done);
-	if (result || done)
-		goto done;
+	rq = get_req(sdev, cmd, csdev->buffer);
+	if (!rq)
+		return SCSI_DH_RES_TEMP_UNAVAIL;
 
-	result = send_cmd(sdev, MODE_SELECT);
-	result = trespass_endio(sdev, result);
-	if (result)
-		goto done;
+	rq->sense = csdev->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = csdev->senselen = 0;
 
-	result = send_cmd(sdev, INQUIRY);
-	result = sp_info_endio(sdev, result, 1, NULL);
-done:
-	return result;
+	err = blk_execute_rq(sdev->request_queue, NULL, rq, 1);
+	if (err == -EIO) {
+		if (rq->sense_len) {
+			err = trespass_endio(sdev, csdev->sense);
+		} else {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: failed to send MODE SELECT: %x\n",
+				    CLARIION_NAME, rq->errors);
+		}
+	}
+
+	blk_put_request(rq);
+
+	return err;
 }
 
 static int clariion_check_sense(struct scsi_device *sdev,
@@ -386,13 +442,129 @@ static int clariion_check_sense(struct scsi_device *sdev,
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
+static int clariion_std_inquiry(struct scsi_device *sdev,
+				struct clariion_dh_data *csdev)
+{
+	int err;
+	char *sp_model;
+
+	err = send_inquiry_cmd(sdev, 0, csdev);
+	if (err != SCSI_DH_OK && csdev->senselen) {
+		struct scsi_sense_hdr sshdr;
+
+		if (scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
+					 &sshdr)) {
+			sdev_printk(KERN_ERR, sdev, "%s: INQUIRY sense code "
+				    "%02x/%02x/%02x\n", CLARIION_NAME,
+				    sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		}
+		err = SCSI_DH_IO;
+		goto out;
+	}
+
+	sp_model = parse_sp_model(sdev, csdev->buffer);
+	if (!sp_model) {
+		err = SCSI_DH_DEV_UNSUPP;
+		goto out;
+	}
+
+	/*
+	 * FC Series arrays do not support long trespass
+	 */
+	if (!strlen(sp_model) || !strncmp(sp_model, "FC",2))
+		csdev->flags |= CLARIION_SHORT_TRESPASS;
+
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: detected Clariion %s, flags %x\n",
+		    CLARIION_NAME, sp_model, csdev->flags);
+out:
+	return err;
+}
+
+static int clariion_send_inquiry(struct scsi_device *sdev,
+				 struct clariion_dh_data *csdev)
+{
+	int err, retry = CLARIION_RETRIES;
+
+retry:
+	err = send_inquiry_cmd(sdev, 0xC0, csdev);
+	if (err != SCSI_DH_OK && csdev->senselen) {
+		struct scsi_sense_hdr sshdr;
+
+		err = scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
+					   &sshdr);
+		if (!err)
+			return SCSI_DH_IO;
+
+		err = clariion_check_sense(sdev, &sshdr);
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
+	result = clariion_send_inquiry(sdev, csdev);
+	if (result != SCSI_DH_OK)
+		goto done;
+
+	if (csdev->lun_state == CLARIION_LUN_OWNED)
+		goto done;
+
+	result = send_trespass_cmd(sdev, csdev);
+	if (result != SCSI_DH_OK)
+		goto done;
+	sdev_printk(KERN_INFO, sdev,"%s: %s trespass command sent\n",
+		    CLARIION_NAME,
+		    csdev->flags&CLARIION_SHORT_TRESPASS?"short":"long" );
+
+	/* Update status */
+	result = clariion_send_inquiry(sdev, csdev);
+	if (result != SCSI_DH_OK)
+		goto done;
+
+done:
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: at SP %c Port %d (%s, default SP %c)\n",
+		    CLARIION_NAME, csdev->current_sp + 'A',
+		    csdev->port, lun_state[csdev->lun_state],
+		    csdev->default_sp + 'A');
+
+	return result;
 }
 
 const struct scsi_dh_devlist clariion_dev_list[] = {
 	{"DGC", "RAID"},
 	{"DGC", "DISK"},
+	{"DGC", "VRAID"},
 	{NULL, NULL},
 };
 
@@ -407,6 +579,7 @@ static struct scsi_device_handler clariion_dh = {
 	.detach		= clariion_bus_detach,
 	.check_sense	= clariion_check_sense,
 	.activate	= clariion_activate,
+	.prep_fn	= clariion_prep_fn,
 };
 
 /*
@@ -417,6 +590,7 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 	struct scsi_dh_data *scsi_dh_data;
 	struct clariion_dh_data *h;
 	unsigned long flags;
+	int err;
 
 	if (sdev->scsi_dh_data)
 		return -EBUSY;
@@ -424,24 +598,44 @@ static int clariion_bus_attach(struct scsi_device *sdev)
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
 
+	err = clariion_std_inquiry(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
+	err = clariion_send_inquiry(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", CLARIION_NAME);
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: connected to SP %c Port %d (%s, default SP %c)\n",
+		    CLARIION_NAME, h->current_sp + 'A',
+		    h->port, lun_state[h->lun_state],
+		    h->default_sp + 'A');
+
 	try_module_get(THIS_MODULE);
 
 	return 0;
+
+failed:
+	kfree(scsi_dh_data);
+	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
+		    CLARIION_NAME);
+	return -EINVAL;
 }
 
 static void clariion_bus_detach(struct scsi_device *sdev)
@@ -449,16 +643,12 @@ static void clariion_bus_detach(struct scsi_device *sdev)
 	struct scsi_dh_data *scsi_dh_data;
 	unsigned long flags;
 
-	if (sdev->scsi_dh_data == NULL ||
-	    sdev->scsi_dh_data->scsi_dh != &clariion_dh)
-		return;
-
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	scsi_dh_data = sdev->scsi_dh_data;
 	sdev->scsi_dh_data = NULL;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-	sdev_printk(KERN_NOTICE, sdev, "Detached %s.\n",
+	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n",
 		    CLARIION_NAME);
 
 	kfree(scsi_dh_data);
@@ -471,7 +661,8 @@ static int __init clariion_init(void)
 
 	r = scsi_register_device_handler(&clariion_dh);
 	if (r != 0)
-		printk(KERN_ERR "Failed to register scsi device handler.");
+		printk(KERN_ERR "%s: Failed to register scsi device handler.",
+			CLARIION_NAME);
 	return r;
 }
 
-- 
1.5.2.4
