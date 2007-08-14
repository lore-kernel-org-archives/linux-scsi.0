From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 1/1] cciss: fix error reporting for SG_IO
Date: Tue, 14 Aug 2007 14:53:38 -0500
Message-ID: <20070814195338.GA10828@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935402AbXHNUJJ@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, james.bottomley@steeleye.com, hch@infradead.org, steve.cameron@hp.com
List-Id: linux-scsi@vger.kernel.org

Patch 1/1
Steve has been trying to send this out but it doesn't seem to be getting
anywhere. Please review this patch for accuracy. There's a couple of things
not clear to us.

Thanks,
mikem

--------------------------------------------------------------------------------
We found a problem with the way cciss was filling out rq->errors.
Previously, it just put a 1 or a 0 in there and used the negation
of this as the uptodate parameter to one of the functions in the
block layer, being a block device.

For the SG_IO support, this is not sufficient, and we noticed
that for example, sg_turs from sg3_utils does not correctly
detect problems due to cciss filling out rq->errors incorrectly.

So, below is my attempt at fixing this, but I'm not completely
sure I did it all right.  It is better than before, in that
now sg_turs seems to detect when things go wrong (e.g.:
when a disk is inaccessible due to cables being yanked, it
notices.)

There is some stuff in scsi.h:

> /*
>  *  Use these to separate status msg and our bytes
>  *
>  *  These are set by:
>  *
>  *      status byte = set from target device
>  *      msg_byte    = return status from host adapter itself.
>  *      host_byte   = set by low-level driver to indicate status.
>  *      driver_byte = set by mid-level.
>  */
> #define status_byte(result) (((result) >> 1) & 0x7f)
> #define msg_byte(result)    (((result) >> 8) & 0xff)
> #define host_byte(result)   (((result) >> 16) & 0xff)
> #define driver_byte(result) (((result) >> 24) & 0xff)

I'm unsure about the msg_byte (sg_turs appears not to 
look at it.)  I used a device specific code (cciss 
notion of CommandStatus) here.  Not sure if that's correct, 
but not sure what else I would use.  Any clarification on 
that would be helpful.  And of course, let me know if you 
notice anything else I might have screwed up.

-- steve

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>

---

 drivers/block/cciss.c |   81 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 63 insertions(+), 18 deletions(-)

diff -puN drivers/block/cciss.c~sg_io_fix_error_reporting drivers/block/cciss.c
--- linux-2.6.23-rc2/drivers/block/cciss.c~sg_io_fix_error_reporting	2007-08-13 09:44:58.000000000 -0500
+++ linux-2.6.23-rc2-scameron/drivers/block/cciss.c	2007-08-13 09:44:58.000000000 -0500
@@ -2366,30 +2366,57 @@ static inline void resend_cciss_cmd(ctlr
 	start_io(h);
 }
 
+/* inverse of macros in scsi.h */
+
+#define shift_status_byte(x) ((x) & 0xff)
+#define shift_msg_byte(x) (((x) & 0xff) << 8)
+#define shift_host_byte(x) (((x) & 0xff) << 16)
+#define shift_driver_byte(x) (((x) & 0xff) << 24)
+
+#define make_status_bytes(s, m, h, d) \
+	shift_status_byte((s)) |\
+	shift_msg_byte((m)) |\
+	shift_host_byte((h)) |\
+	 shift_driver_byte((d))
+
 static inline int evaluate_target_status(CommandList_struct *cmd)
 {
 	unsigned char sense_key;
-	int error_count = 1;
+	unsigned char status_byte, msg_byte, host_byte, driver_byte;
+	int error_value;
+
+	/* If we get in here, it means we got "target status", that is, scsi status */
+	status_byte = cmd->err_info->ScsiStatus;
+	driver_byte = DRIVER_OK;
+	msg_byte = cmd->err_info->CommandStatus; /* correct?  seems too device specific */
+
+	if (blk_pc_request(cmd->rq))
+		host_byte = DID_PASSTHROUGH;
+	else
+		host_byte = DID_OK;
+
+	error_value = make_status_bytes(status_byte, msg_byte,
+		host_byte, driver_byte);
 
-	if (cmd->err_info->ScsiStatus != 0x02) { /* not check condition? */
+	if (cmd->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION) {
 		if (!blk_pc_request(cmd->rq))
 			printk(KERN_WARNING "cciss: cmd %p "
 			       "has SCSI Status 0x%x\n",
 			       cmd, cmd->err_info->ScsiStatus);
-		return error_count;
+		return error_value;
 	}
 
 	/* check the sense key */
 	sense_key = 0xf & cmd->err_info->SenseInfo[2];
 	/* no status or recovered error */
-	if ((sense_key == 0x0) || (sense_key == 0x1))
-		error_count = 0;
+	if (((sense_key == 0x0) || (sense_key == 0x1)) && !blk_pc_request(cmd->rq))
+		error_value = 0;
 
 	if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
-		if (error_count != 0)
+		if (error_value != 0)
 			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
 			       " sense key = 0x%x\n", cmd, sense_key);
-		return error_count;
+		return error_value;
 	}
 
 	/* SG_IO or similar, copy sense data back */
@@ -2401,7 +2428,7 @@ static inline int evaluate_target_status
 	} else
 		cmd->rq->sense_len = 0;
 
-	return error_count;
+	return error_value;
 }
 
 /* checks the status of the job and calls complete buffers to mark all
@@ -2417,7 +2444,7 @@ static inline void complete_command(ctlr
 	rq->errors = 0;
 
 	if (timeout)
-		rq->errors = 1;
+		rq->errors = make_status_bytes(0, 0, 0, DRIVER_TIMEOUT);
 
 	if (cmd->err_info->CommandStatus == 0)	/* no error has occurred */
 		goto after_error_processing;
@@ -2443,32 +2470,44 @@ static inline void complete_command(ctlr
 	case CMD_INVALID:
 		printk(KERN_WARNING "cciss: cmd %p is "
 		       "reported invalid\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_PROTOCOL_ERR:
 		printk(KERN_WARNING "cciss: cmd %p has "
 		       "protocol error \n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_HARDWARE_ERR:
 		printk(KERN_WARNING "cciss: cmd %p had "
 		       " hardware error\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_CONNECTION_LOST:
 		printk(KERN_WARNING "cciss: cmd %p had "
 		       "connection lost\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_ABORTED:
 		printk(KERN_WARNING "cciss: cmd %p was "
 		       "aborted\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_ABORT_FAILED:
 		printk(KERN_WARNING "cciss: cmd %p reports "
 		       "abort failed\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_UNSOLICITED_ABORT:
 		printk(KERN_WARNING "cciss%d: unsolicited "
@@ -2482,17 +2521,23 @@ static inline void complete_command(ctlr
 			printk(KERN_WARNING
 			       "cciss%d: %p retried too "
 			       "many times\n", h->ctlr, cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_TIMEOUT:
 		printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	default:
 		printk(KERN_WARNING "cciss: cmd %p returned "
 		       "unknown status %x\n", cmd,
 		       cmd->err_info->CommandStatus);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 	}
 
 after_error_processing:
_

----- End forwarded message -----
