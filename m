From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Tue, 3 Jun 2008 11:02:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806031047380.2363-100000@iolanthe.rowland.org>
References: <48328E81.2080504@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60946 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752263AbYFCPCH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2008 11:02:07 -0400
In-Reply-To: <48328E81.2080504@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 20 May 2008, Boaz Harrosh wrote:

> Alan Stern wrote:
> 
> > MODE SENSE is just one example of a command for which a device might
> > return less data than the host expected.  In principle the same thing
> > could happen with _any_ command.  The host should be prepared for this
> > and should be able to handle it correctly.  And the host shouldn't
> > blindly assume that devices will slavishly follow the letter of the
> > SCSI spec.

...

> > We need something much more thorough than just fiddling with
> > scsi_mode_sense().  One possibility would be to pass a
> > minimum-response-length argument to scsi_execute_req().  But even that
> > wouldn't catch all the code paths where this sort of thing could  
> > happen (although it probably would catch most of them).

What do you think of a patch like this?

Index: usb-2.6/include/linux/blkdev.h
===================================================================
--- usb-2.6.orig/include/linux/blkdev.h
+++ usb-2.6/include/linux/blkdev.h
@@ -221,6 +221,7 @@ struct request {
 
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
+	unsigned int min_data_len;
 	unsigned int sense_len;
 	void *data;
 	void *sense;
Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -1125,6 +1125,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 		ret = scsi_init_io(cmd, GFP_ATOMIC);
 		if (unlikely(ret))
 			return ret;
+		cmd->underflow = req->min_data_len;
 	} else {
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);

Combined with an extra minimum-data-length argument to scsi_execute()
and scsi_execute_req(), this ought to solve the problem.

(To refresh your memory: The problem is that a weird device responds to 
MODE SENSE with Residue equal to the data length -- so none of the 
returned data is valid -- and Okay status.)

Alan Stern

P.S.: Maybe a safer approach would be to add a new flag bit in struct
request.  Normally the flag would be clear, indicating that for
BLOCK_PC requests, scmd->underflow should be set to 0.  But when the
flag is set, scmd->underflow would be set to req->data_len.

