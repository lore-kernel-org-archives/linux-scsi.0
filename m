From: scameron@beardog.cca.cpqcorp.net
Subject: [PATCH 2/2] cciss: Fix SCSI device reset handler
Date: Wed, 27 May 2009 15:30:07 -0500
Message-ID: <20090527203007.GA30160@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755058AbZE0UaA@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
Cc: mikem@beardog.cca.cpqcorp.net, scameron@beardog.cca.cpqcorp.net
List-Id: linux-scsi@vger.kernel.org



Fix the SCSI reset error handler to send a working, properly
addressed reset message to the target device and add code to
wait for the target device to become ready by polling it with
Test Unit Ready.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
---

The existing reset code was broken in that it didn't bother to
set the 8-byte LUN address to anything besides zero, so the
command was addressed to the controller, which pretended to 
the driver that the command succeeded, while doing nothing.
Ages ago I tested this code, but unbeknownst to me, my test
was flawed, and what I thought was a tape drive getting reset
was actually nothing of the sort.  Unfortunately, there is 
still lots of Smartarray firmware that doesn't handle doing
target resets right, and this code won't help in those cases,
but it also shouldn't make things worse in those cases than
they already are.

diff -puN drivers/block/cciss.c~cciss_fix_lun_reset drivers/block/cciss.c
--- lx2630-6/drivers/block/cciss.c~cciss_fix_lun_reset	2009-05-27 14:22:12.000000000 -0500
+++ lx2630-6-scameron/drivers/block/cciss.c	2009-05-27 14:22:12.000000000 -0500
@@ -1979,6 +1979,13 @@ static int fill_cmd(CommandList_struct *
 			c->Request.CDB[0] = BMIC_WRITE;
 			c->Request.CDB[6] = BMIC_CACHE_FLUSH;
 			break;
+		case TEST_UNIT_READY:
+			memcpy(c->Header. LUN.LunAddrBytes, scsi3addr, 8);
+			c->Request.CDBLen = 6;
+			c->Request.Type.Attribute = ATTR_SIMPLE;
+			c->Request.Type.Direction = XFER_NONE;
+			c->Request.Timeout = 0;
+			break;
 		default:
 			printk(KERN_WARNING
 			       "cciss%d:  Unknown Command 0x%c\n", ctlr, cmd);
@@ -1997,13 +2004,14 @@ static int fill_cmd(CommandList_struct *
 			memcpy(&c->Request.CDB[4], buff, 8);
 			break;
 		case 1:	/* RESET message */
-			c->Request.CDBLen = 12;
+			memcpy(c->Header.LUN.LunAddrBytes, scsi3addr, 8);
+			c->Request.CDBLen = 16;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
-			c->Request.Type.Direction = XFER_WRITE;
+			c->Request.Type.Direction = XFER_NONE;
 			c->Request.Timeout = 0;
 			memset(&c->Request.CDB[0], 0, sizeof(c->Request.CDB));
 			c->Request.CDB[0] = cmd;	/* reset */
-			c->Request.CDB[1] = 0x04;	/* reset a LUN */
+			c->Request.CDB[1] = 0x03;	/* reset a target */
 			break;
 		case 3:	/* No-Op message */
 			c->Request.CDBLen = 1;
diff -puN drivers/block/cciss_scsi.c~cciss_fix_lun_reset drivers/block/cciss_scsi.c
--- lx2630-6/drivers/block/cciss_scsi.c~cciss_fix_lun_reset	2009-05-27 14:22:12.000000000 -0500
+++ lx2630-6-scameron/drivers/block/cciss_scsi.c	2009-05-27 14:22:12.000000000 -0500
@@ -58,6 +58,18 @@ static int sendcmd(
 	unsigned char *scsi3addr,
 	int cmd_type);
 
+static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
+	size_t size,
+	unsigned int use_unit_num, /* 0: address the controller,
+				      1: address logical volume log_unit,
+				      2: periph device address is scsi3addr */
+	unsigned int log_unit, __u8 page_code, unsigned char *scsi3addr,
+	int cmd_type);
+
+static int sendcmd_core(ctlr_info_t *h, CommandList_struct *c);
+
+static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool);
+static void cmd_free(ctlr_info_t *h, CommandList_struct *c, int got_from_pool);
 
 static int cciss_scsi_proc_info(
 		struct Scsi_Host *sh,
@@ -1575,6 +1587,68 @@ cciss_seq_tape_report(struct seq_file *s
 	CPQ_TAPE_UNLOCK(ctlr, flags);
 }
 
+static int wait_for_device_to_become_ready(ctlr_info_t *h,
+	unsigned char lunaddr[])
+{
+	int rc;
+	int count = 0;
+	int waittime = HZ;
+	CommandList_struct *c;
+
+	c = cmd_alloc(h, 1);
+	if (!c) {
+		printk(KERN_WARNING "cciss%d: out of memory in "
+			"wait_for_device_to_become_ready.\n", h->ctlr);
+		return IO_ERROR;
+	}
+
+	/* Send test unit ready until device ready, or give up. */
+	while (count < 20) {
+
+		/* Wait for a bit.  do this first, because if we send
+		 * the TUR right away, the reset will just abort it.
+		 */
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(waittime);
+		count++;
+
+		/* Increase wait time with each try, up to a point. */
+		if (waittime < (HZ * 30))
+			waittime = waittime * 2;
+
+		/* Send the Test Unit Ready */
+		rc = fill_cmd(c, TEST_UNIT_READY, h->ctlr, NULL, 0, 0, 0, 0,
+			lunaddr, TYPE_CMD);
+		if (rc == 0) {
+			rc = sendcmd_core(h, c);
+			/* sendcmd turned off interrupts, turn 'em back on. */
+			h->access.set_intr_mask(h, CCISS_INTR_ON);
+		}
+
+		if (rc == 0 && c->err_info->CommandStatus == CMD_SUCCESS)
+			break;
+
+		if (rc == 0 &&
+			c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
+			(c->err_info->SenseInfo[2] == NO_SENSE ||
+			c->err_info->SenseInfo[2] == UNIT_ATTENTION))
+			break;
+
+		printk(KERN_WARNING "cciss%d: Waiting %d secs "
+			"for device to become ready.\n",
+			h->ctlr, waittime / HZ);
+		rc = 1; /* device not ready. */
+	}
+
+	if (rc)
+		printk("cciss%d: giving up on device.\n", h->ctlr);
+	else
+		printk(KERN_WARNING "cciss%d: device is ready.\n", h->ctlr);
+
+	cmd_free(h, c, 1);
+	return rc;
+}
 
 /* Need at least one of these error handlers to keep ../scsi/hosts.c from 
  * complaining.  Doing a host- or bus-reset can't do anything good here. 
@@ -1591,6 +1665,7 @@ static int cciss_eh_device_reset_handler
 {
 	int rc;
 	CommandList_struct *cmd_in_trouble;
+	unsigned char lunaddr[8];
 	ctlr_info_t **c;
 	int ctlr;
 
@@ -1600,19 +1675,17 @@ static int cciss_eh_device_reset_handler
 		return FAILED;
 	ctlr = (*c)->ctlr;
 	printk(KERN_WARNING "cciss%d: resetting tape drive or medium changer.\n", ctlr);
-
 	/* find the command that's giving us trouble */
 	cmd_in_trouble = (CommandList_struct *) scsicmd->host_scribble;
-	if (cmd_in_trouble == NULL) { /* paranoia */
+	if (cmd_in_trouble == NULL) /* paranoia */
 		return FAILED;
-	}
+	memcpy(lunaddr, &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 8);
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 2, 0, 0, 
-		(unsigned char *) &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 
+	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 2, 0, 0, lunaddr,
 		TYPE_MSG);
 	/* sendcmd turned off interrupts on the board, turn 'em back on. */
 	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
-	if (rc == 0)
+	if (rc == 0 && wait_for_device_to_become_ready(*c, lunaddr) == 0)
 		return SUCCESS;
 	printk(KERN_WARNING "cciss%d: resetting device failed.\n", ctlr);
 	return FAILED;
diff -puN drivers/block/cciss.h~cciss_fix_lun_reset drivers/block/cciss.h
_
