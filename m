From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Device flags: use_10_for_rw and use_10_for_ms
Date: Wed, 30 Nov 2005 10:46:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511301018110.12186-100000@iolanthe.rowland.org>
References: <20051129224835.GA7505@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36029 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751364AbVK3Pqe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 10:46:34 -0500
In-Reply-To: <20051129224835.GA7505@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 29 Nov 2005, Patrick Mansfield wrote:

> On Tue, Nov 29, 2005 at 04:23:16PM -0500, Alan Stern wrote:
> 
> Alan -
> 
> Looking at the full log (with no patches) and your earlier patch, I'm
> confused by two things.
> 
> First, the READ_10 command being sent after we get the ILLEGAL REQUEST.
> 
> Do you know how that READ_10 is sent? Is the upper layer add_disk() check
> partition code retrying? Then I'd expect a READ_6. If it were already
> prepped, I guess we can get another READ_10, but I thought that the
> partition read/check code only issued one read at a time.

I didn't try to track it down in detail, but I think you're right that the
upper layer partition code is doing the retry.  In the log it appeared as
another READ_10 because the sector number was too large to fit in a READ_6
(sd automatically uses the larger command in that situation).  If you look
farther down in the log you'll see an attempt to read sector 0 using
READ_6.

> The scsi_check_sense() should not be allowing the retry, we have a "return
> SUCCESS" there. If we did want to retry via scmd->retries, we might be
> able to add code into scis_check_sense().

Maybe that would be a better way of doing it.  There are more levels of 
retrying in the SCSI core than I fully understand.  :-(

> And:
> 
> How can the current scsi_lib.c scsi_io_completion() *ever* requeue after
> an sd.c read/write has turned off use_10_for_rw in sd_rw_intr()?
> 
> That is, sd.c sd_rw_intr() gets ILLEGAL REQUEST, and clears use_10_for_rw,
> this snippet:
> 
> 		case ILLEGAL_REQUEST:
> 			if (SCpnt->device->use_10_for_rw &&
> 			    (SCpnt->cmnd[0] == READ_10 ||
> 			     SCpnt->cmnd[0] == WRITE_10))
> 				SCpnt->device->use_10_for_rw = 0;
> 
> Then it calls scsi_io_completion(), where we only requeue if use_10_for_rw
> is still set, so we never requeue via this code path. That is why without
> your patch we get an error output. Correct?!

Partly orrect.  That's why this command gives an error output.  But then
later commands use READ_6, which has no hope of succeeding.

> So with the patch you posted earlier, all it does (in scsi_io_completion())
> is set use_10_for_rw back to 1, and then requeue the IO.

Yes.  That was a preliminary, see-if-this-fixes-your-problem sort of 
patch.  I never intended it to go into the kernel.  It did kinda work; if 
you look at the second log posted on that web site you'll see where the 
core did switch to READ_6 for one command and then switched back to 
READ_10.

> If you remove (or move) that sd.c code, it seems you'll hit this, and
> figure that you do not want to switch from 6 to 10 byte commands (and
> perhaps back) at all.
> 
> Then we need a method so we don't switch: another bit or state set after
> a successful read or write command (and I guess one for succesful mode
> sense command). 
> 
> We need only check the do-not-switch flag if we get an ILLEGAL REQUEST. We
> already have to check use_10_for_rw before every read or write request.

To put it another way, we need two flags.  One to indicate when we
definitely know which sort of commands the device will accept, and one to
indicate which type to use.  This sounds like a very good idea.  (And yes,
we should assume that some devices will want MODE_SENSE_6 along with 
READ_10!)

Another factor is important here.  The use_10_for_rw flag is used only in 
sd.c, not in sr.c.  (I haven't checked up on use_10_for_ms.)  Given that 
most of the flaky behavior seems to be associated with disk drives, should 
we keep this switching behavior only in sd.c or should it move to 
scsi_io_completion?  Or somewhere else?


On Wed, 30 Nov 2005, Jens Axboe wrote:

> Oh well, so much for expecting than even the most basic SCSI behaviour
> is always implemented correctly. A device must only return
> 0x05/0x20/0x00 for an illegal opcode. It's a little suspicious I'd say,
> are you sure it isn't something else affecting this? Even though there 
> are crappy devices out there, this seems a little too odd to me.

I'm quite sure there was nothing else affecting it.  This is just a rather 
strange device.


On Wed, 30 Nov 2005, James Bottomley wrote:

> And anyway, just because it doesn't actually work in the failing case
> doesn't mean this isn't a good patch ... it's certainly unsafe to switch
> back to 6 byte commands without checking for the correct illegal opcode 
> sense, so we should put it in anyway.

Below is an updated version of the patch.  I'm not sure it's really the 
right approach, but at least it's a starting point for further discussion.
>From testing I know that it _will_ cause an infinite retry loop under 
certain conditions, so it should not be accepted as is.  It also doesn't 
check the ASC and ASCQ -- but even if it did, it still wouldn't be good.

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -894,6 +894,36 @@ void scsi_io_completion(struct scsi_cmnd
 				 */
 				scsi_requeue_command(q, cmd);
 				result = 0;
+			} else if (!cmd->device->use_10_for_rw &&
+			    (cmd->cmnd[0] == READ_6 ||
+			     cmd->cmnd[0] == WRITE_6)) {
+				cmd->device->use_10_for_rw = 1;
+				/*
+				 * This will cause a retry with a 10-byte
+				 * command.
+				 */
+				scsi_requeue_command(q, cmd);
+				result = 0;
+			} else if (cmd->device->use_10_for_ms &&
+			    (cmd->cmnd[0] == MODE_SENSE_10 ||
+			     cmd->cmnd[0] == MODE_SELECT_10)) {
+				cmd->device->use_10_for_ms = 0;
+				/*
+				 * This will cause a retry with a 6-byte
+				 * command.
+				 */
+				scsi_requeue_command(q, cmd);
+				result = 0;
+			} else if (!cmd->device->use_10_for_ms &&
+			    (cmd->cmnd[0] == MODE_SENSE ||
+			     cmd->cmnd[0] == MODE_SELECT)) {
+				cmd->device->use_10_for_ms = 1;
+				/*
+				 * This will cause a retry with a 10-byte
+				 * command.
+				 */
+				scsi_requeue_command(q, cmd);
+				result = 0;
 			} else {
 				scsi_end_request(cmd, 0, this_count, 1);
 				return;
Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -944,17 +944,6 @@ static void sd_rw_intr(struct scsi_cmnd 
 			good_bytes = this_count;
 			break;
 
-		case ILLEGAL_REQUEST:
-			if (SCpnt->device->use_10_for_rw &&
-			    (SCpnt->cmnd[0] == READ_10 ||
-			     SCpnt->cmnd[0] == WRITE_10))
-				SCpnt->device->use_10_for_rw = 0;
-			if (SCpnt->device->use_10_for_ms &&
-			    (SCpnt->cmnd[0] == MODE_SENSE_10 ||
-			     SCpnt->cmnd[0] == MODE_SELECT_10))
-				SCpnt->device->use_10_for_ms = 0;
-			break;
-
 		default:
 			break;
 		}

