From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.5.73 add mode sense 10 byte to aacraid driver
Date: 26 Jun 2003 09:13:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056644006.9648.87.camel@markh1.pdx.osdl.net>
References: <1056561660.747.7.camel@markh1.pdx.osdl.net>
	 <1056563910.2786.36.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:191 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261970AbTFZP7C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2003 11:59:02 -0400
In-Reply-To: <1056563910.2786.36.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2003-06-25 at 10:58, James Bottomley wrote:
> On Wed, 2003-06-25 at 12:21, Mark Haverkamp wrote:
> > The aacraid driver didn't have a case for the 10 byte mode sense
> > command.  This was causing the driver to fail.  I added a case in
> > aac_scsi_cmd for the 10 byte mode sense.  I also replaced the aacraid
> > definitions for scsi commands with the ones from scsi.h.  I have tested
> > this on my aacraid hardware here at osdl.
> 
> This:
> 
> > +	case MODE_SENSE_10:
> > +	{
> > +		char *mode_buf;
> > +
> > +		dprintk((KERN_DEBUG "MODE SENSE 10 command.\n"));
> > +		mode_buf = scsicmd->request_buffer;
> > +		mode_buf[0] = 0;	/* Mode data length (MSB) */
> > +		mode_buf[1] = 10;	/* Mode data length (LSB) */
> > +		mode_buf[2] = 0;	/* Medium type - default */
> > +		mode_buf[3] = 0;	/* Device-specific param, bit 8: 0/1 = write enabled/protected */
> > +		mode_buf[4] = 0;	/* reserved */
> > +		mode_buf[5] = 0;	/* reserved */
> > +		mode_buf[6] = 0;	/* Block descriptor length (MSB) */
> > +		mode_buf[7] = 0;	/* Block descriptor length (LSB) */
> > +
> > +		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
> > +		__aac_io_done(scsicmd);
> > +
> > +		return 0;
> > +	}
> 
> Looks incorrect.  MODE_SENSE is supposed to return page code data.  If
> none is provided, the commands which use this data are going to do wrong
> things (since most of them assume a successful command execution means
> that the data was returned).
> 
> Also, the header length is wrong.  Traditionally, the length field in
> SCSI commands counts from the first byte after the length field, so the
> length field of the MODE SENSE(6) for just returning the 4 byte header
> should be 3; Likewise for MODE SENSE(10) which has an eight byte header,
> it should be 6.
> 
> GOOD is also one of those infernal old status codes that need to be
> shifted one bit to the right (fortunately, it's actually zero so in this
> one instance it doesn't matter).  You should probably use SAM_STAT_GOOD
> instead (the SAM_STAT_ codes don't need shifting).
> 
> I also reluctantly noticed that the current MODE_SENSE case is, in fact,
> actually returning a MODE SENSE(10) header...
> 
> Now I notice it's returning unshifted CHECK_CONDIDIONTS too..

I have an updated patch that I think address most of your concerns.  I
didn't address the mode sense returned data content.  I wasn't sure
exactly what should be returned here.  The disk attributes seem to be
detected the same as before though:  

2.5.69
SCSI device sdc: 71091456 512-byte hdwr sectors (36399 MB)
sdc: Write Protect is off
sdc: cache data unavailable
sdc: assuming drive cache: write through

2.5.73 + patch 
SCSI device sdc: 71091456 512-byte hdwr sectors (36399 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 06 00 00
sdc: cache data unavailable
sdc: assuming drive cache: write through

One thing I did notice though, is that do_mode_sense in sd.c can send
either a 6 or 10 byte mode sense but the callers of that routine seem to
assume data from a 6 byte mode sense.

The enclosed patch assumes my previous patch yesterday replacing the
local defines for the scsi commands with the ones from scsi.h

Mark.

--- linux-2.5.73/drivers/scsi/aacraid/aachba-1.c	2003-06-26 08:27:24.000000000 -0700
+++ linux-2.5.73/drivers/scsi/aacraid/aachba.c	2003-06-25 14:18:56.000000000 -0700
@@ -564,10 +564,10 @@
 				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
 	if (le32_to_cpu(readreply->status) == ST_OK)
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 	else {
 		printk(KERN_WARNING "read_callback: read failed, status = %d\n", readreply->status);
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 		set_sense((u8 *) &sense_data[cid],
 				    SENKEY_HW_ERR,
 				    SENCODE_INTERNAL_TARGET_FAILURE,
@@ -609,10 +609,10 @@
 
 	writereply = (struct aac_write_reply *) fib_data(fibptr);
 	if (le32_to_cpu(writereply->status) == ST_OK)
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 	else {
 		printk(KERN_WARNING "write_callback: write failed, status = %d\n", writereply->status);
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 		set_sense((u8 *) &sense_data[cid],
 				    SENKEY_HW_ERR,
 				    SENCODE_INTERNAL_TARGET_FAILURE,
@@ -729,7 +729,7 @@
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | QUEUE_FULL;
+	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
 	aac_io_done(scsicmd);
 	fib_complete(cmd_fibcontext);
 	fib_free(cmd_fibcontext);
@@ -835,7 +835,7 @@
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | QUEUE_FULL;
+	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
 	aac_io_done(scsicmd);
 
 	fib_complete(cmd_fibcontext);
@@ -927,7 +927,7 @@
 		(scsicmd->cmnd[0] != TEST_UNIT_READY)) 
 	{
 		dprintk((KERN_WARNING "Only INQUIRY & TUR command supported for controller, rcvd = 0x%x.\n", scsicmd->cmnd[0]));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 		set_sense((u8 *) &sense_data[cid],
 			    SENKEY_ILLEGAL,
 			    SENCODE_INVALID_COMMAND,
@@ -962,7 +962,7 @@
 			inq_data_ptr->inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 		else
 			inq_data_ptr->inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
 		return 0;
 	}
@@ -983,7 +983,7 @@
 		cp[6] = 2;
 		cp[7] = 0;
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
 
 		return 0;
@@ -995,6 +995,22 @@
 
 		dprintk((KERN_DEBUG "MODE SENSE command.\n"));
 		mode_buf = scsicmd->request_buffer;
+		mode_buf[0] = 3;	/* Mode data length */
+		mode_buf[1] = 0;	/* Medium type - default */
+		mode_buf[2] = 0;	/* Device-specific param, bit 8: 0/1 = write enabled/protected */
+		mode_buf[3] = 0;	/* Block descriptor length */
+
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+		__aac_io_done(scsicmd);
+
+		return 0;
+	}
+	case MODE_SENSE_10:
+	{
+		char *mode_buf;
+
+		dprintk((KERN_DEBUG "MODE SENSE 10 byte command.\n"));
+		mode_buf = scsicmd->request_buffer;
 		mode_buf[0] = 0;	/* Mode data length (MSB) */
 		mode_buf[1] = 6;	/* Mode data length (LSB) */
 		mode_buf[2] = 0;	/* Medium type - default */
@@ -1004,7 +1020,7 @@
 		mode_buf[6] = 0;	/* Block descriptor length (MSB) */
 		mode_buf[7] = 0;	/* Block descriptor length (LSB) */
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
 
 		return 0;
@@ -1013,7 +1029,7 @@
 		dprintk((KERN_DEBUG "REQUEST SENSE command.\n"));
 		memcpy(scsicmd->sense_buffer, &sense_data[cid], sizeof (struct sense_data));
 		memset(&sense_data[cid], 0, sizeof (struct sense_data));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
 		return (0);
 
@@ -1024,7 +1040,7 @@
 		else
 			fsa_dev_ptr->locked[cid] = 0;
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
 		return 0;
 	/*
@@ -1037,7 +1053,7 @@
 	case REASSIGN_BLOCKS:
 	case SEEK_10:
 	case START_STOP:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
 		return (0);
 	}
@@ -1073,7 +1089,7 @@
 			 *	Unhandled commands
 			 */
 			printk(KERN_WARNING "Unhandled SCSI Command: 0x%x.\n", scsicmd->cmnd[0]);
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | CHECK_CONDITION;
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 			set_sense((u8 *) &sense_data[cid],
 				SENKEY_ILLEGAL, SENCODE_INVALID_COMMAND,
 			ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
@@ -1231,7 +1247,7 @@
 		printk(KERN_WARNING "aac_srb_callback: srb failed, status = %d\n", le32_to_cpu(srbreply->status));
 		len = (srbreply->sense_data_size > sizeof(scsicmd->sense_buffer))?
 				sizeof(scsicmd->sense_buffer):srbreply->sense_data_size;
-		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8 | CHECK_CONDITION;
+		scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
 		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
 	}
 
@@ -1354,7 +1370,7 @@
 	}
 	if (le32_to_cpu(srbreply->scsi_status) == 0x02 ){  // Check Condition
 		int len;
-		scsicmd->result |= CHECK_CONDITION;
+		scsicmd->result |= SAM_STAT_CHECK_CONDITION;
 		len = (srbreply->sense_data_size > sizeof(scsicmd->sense_buffer))?
 				sizeof(scsicmd->sense_buffer):srbreply->sense_data_size;
 		printk(KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n", le32_to_cpu(srbreply->status), len);
@@ -1482,7 +1498,7 @@
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
-	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | QUEUE_FULL;
+	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
 	__aac_io_done(scsicmd);
 
 	fib_complete(cmd_fibcontext);


-- 
Mark Haverkamp <markh@osdl.org>

