From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.5.73 add mode sense 10 byte to aacraid driver
Date: 25 Jun 2003 12:49:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056570550.740.15.camel@markh1.pdx.osdl.net>
References: <1056561660.747.7.camel@markh1.pdx.osdl.net>
	 <20030625181609.GA1804@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:9927 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264975AbTFYTfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2003 15:35:16 -0400
In-Reply-To: <20030625181609.GA1804@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2003-06-25 at 11:16, Jeff Garzik wrote:
> On Wed, Jun 25, 2003 at 10:21:00AM -0700, Mark Haverkamp wrote:
> > The aacraid driver didn't have a case for the 10 byte mode sense
> > command.  This was causing the driver to fail.  I added a case in
> > aac_scsi_cmd for the 10 byte mode sense.  I also replaced the aacraid
> > definitions for scsi commands with the ones from scsi.h.  I have tested
> > this on my aacraid hardware here at osdl.
> > 
> > ===== drivers/scsi/aacraid/aachba.c 1.17 vs edited =====
> > --- 1.17/drivers/scsi/aacraid/aachba.c	Thu Jun 19 17:06:21 2003
> > +++ edited/drivers/scsi/aacraid/aachba.c	Wed Jun 25 08:24:48 2003
> 
> In addition to James's comments...
> 
> Please separate the cleanup (private -> scsi.h constants)
> from the MODE SENSE 10 stuff, into two separate patches.
> 
> That way we can apply the cleanup, while discussioning the other stuff.
> 
> 	Jeff

OK, Here is the cleanup part of the code.  I'll look into the other code
based on James's comments.

Mark.


===== drivers/scsi/aacraid/aachba.c 1.17 vs edited =====
--- 1.17/drivers/scsi/aacraid/aachba.c	Thu Jun 19 17:06:21 2003
+++ edited/drivers/scsi/aacraid/aachba.c	Wed Jun 25 11:36:54 2003
@@ -39,25 +39,6 @@
 
 #include "aacraid.h"
 
-/*	SCSI Commands */
-/* TODO dmb - use the ones defined in include/scsi/scsi.h*/
-#define	SS_TEST			0x00	/* Test unit ready */
-#define SS_REZERO		0x01	/* Rezero unit */
-#define	SS_REQSEN		0x03	/* Request Sense */
-#define SS_REASGN		0x07	/* Reassign blocks */
-#define	SS_READ			0x08	/* Read 6   */
-#define	SS_WRITE		0x0A	/* Write 6  */
-#define	SS_INQUIR		0x12	/* inquiry */
-#define	SS_ST_SP		0x1B	/* Start/Stop unit */
-#define	SS_LOCK			0x1E	/* prevent/allow medium removal */
-#define SS_RESERV		0x16	/* Reserve */
-#define SS_RELES		0x17	/* Release */
-#define SS_MODESEN		0x1A	/* Mode Sense 6 */
-#define	SS_RDCAP		0x25	/* Read Capacity */
-#define	SM_READ			0x28	/* Read 10  */
-#define	SM_WRITE		0x2A	/* Write 10 */
-#define SS_SEEK			0x2B	/* Seek */
-
 /* values for inqd_pdt: Peripheral device type in plain English */
 #define	INQD_PDT_DA	0x00	/* Direct-access (DISK) device */
 #define	INQD_PDT_PROC	0x03	/* Processor device */
@@ -658,7 +639,7 @@
 	/*
 	 *	Get block address and transfer length
 	 */
-	if (scsicmd->cmnd[0] == SS_READ)	/* 6 byte command */
+	if (scsicmd->cmnd[0] == READ_6)	/* 6 byte command */
 	{
 		dprintk((KERN_DEBUG "aachba: received a read(6) command on target %d.\n", cid));
 
@@ -768,7 +749,7 @@
 	/*
 	 *	Get block address and transfer length
 	 */
-	if (scsicmd->cmnd[0] == SS_WRITE)	/* 6 byte command */
+	if (scsicmd->cmnd[0] == WRITE_6)	/* 6 byte command */
 	{
 		lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
 		count = scsicmd->cmnd[4];
@@ -905,9 +886,9 @@
 			 */
 			if (fsa_dev_ptr->valid[cid] == 0) {
 				switch (scsicmd->cmnd[0]) {
-				case SS_INQUIR:
-				case SS_RDCAP:
-				case SS_TEST:
+				case INQUIRY:
+				case READ_CAPACITY:
+				case TEST_UNIT_READY:
 					spin_unlock_irq(host->host_lock);
 					probe_container(dev, cid);
 					spin_lock_irq(host->host_lock);
@@ -942,8 +923,8 @@
 	/*
 	 * else Command for the controller itself
 	 */
-	else if ((scsicmd->cmnd[0] != SS_INQUIR) &&	/* only INQUIRY & TUR cmnd supported for controller */
-		(scsicmd->cmnd[0] != SS_TEST)) 
+	else if ((scsicmd->cmnd[0] != INQUIRY) &&	/* only INQUIRY & TUR cmnd supported for controller */
+		(scsicmd->cmnd[0] != TEST_UNIT_READY)) 
 	{
 		dprintk((KERN_WARNING "Only INQUIRY & TUR command supported for controller, rcvd = 0x%x.\n", scsicmd->cmnd[0]));
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | CHECK_CONDITION;
@@ -958,7 +939,7 @@
 
 	/* Handle commands here that don't really require going out to the adapter */
 	switch (scsicmd->cmnd[0]) {
-	case SS_INQUIR:
+	case INQUIRY:
 	{
 		struct inquiry_data *inq_data_ptr;
 
@@ -985,7 +966,7 @@
 		__aac_io_done(scsicmd);
 		return 0;
 	}
-	case SS_RDCAP:
+	case READ_CAPACITY:
 	{
 		int capacity;
 		char *cp;
@@ -1008,7 +989,7 @@
 		return 0;
 	}
 
-	case SS_MODESEN:
+	case MODE_SENSE:
 	{
 		char *mode_buf;
 
@@ -1028,7 +1009,7 @@
 
 		return 0;
 	}
-	case SS_REQSEN:
+	case REQUEST_SENSE:
 		dprintk((KERN_DEBUG "REQUEST SENSE command.\n"));
 		memcpy(scsicmd->sense_buffer, &sense_data[cid], sizeof (struct sense_data));
 		memset(&sense_data[cid], 0, sizeof (struct sense_data));
@@ -1036,7 +1017,7 @@
 		__aac_io_done(scsicmd);
 		return (0);
 
-	case SS_LOCK:
+	case ALLOW_MEDIUM_REMOVAL:
 		dprintk((KERN_DEBUG "LOCK command.\n"));
 		if (scsicmd->cmnd[4])
 			fsa_dev_ptr->locked[cid] = 1;
@@ -1049,13 +1030,13 @@
 	/*
 	 *	These commands are all No-Ops
 	 */
-	case SS_TEST:
-	case SS_RESERV:
-	case SS_RELES:
-	case SS_REZERO:
-	case SS_REASGN:
-	case SS_SEEK:
-	case SS_ST_SP:
+	case TEST_UNIT_READY:
+	case RESERVE:
+	case RELEASE:
+	case REZERO_UNIT:
+	case REASSIGN_BLOCKS:
+	case SEEK_10:
+	case START_STOP:
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | GOOD;
 		__aac_io_done(scsicmd);
 		return (0);
@@ -1063,8 +1044,8 @@
 
 	switch (scsicmd->cmnd[0]) 
 	{
-		case SS_READ:
-		case SM_READ:
+		case READ_6:
+		case READ_10:
 			/*
 			 *	Hack to keep track of ordinal number of the device that
 			 *	corresponds to a container. Needed to convert
@@ -1081,8 +1062,8 @@
 			spin_lock_irq(host->host_lock);
 			return ret;
 
-		case SS_WRITE:
-		case SM_WRITE:
+		case WRITE_6:
+		case WRITE_10:
 			spin_unlock_irq(host->host_lock);
 			ret = aac_write(scsicmd, cid);
 			spin_lock_irq(host->host_lock);

-- 
Mark Haverkamp <markh@osdl.org>

