From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Tue, 15 Jun 2004 02:10:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615091042.GA168267@sgi.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <20040615081704.GA15795@infradead.org> <20040615084807.GB177665@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:58445 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S265387AbUFOJLt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 05:11:49 -0400
Content-Disposition: inline
In-Reply-To: <20040615084807.GB177665@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

One more comment from hch via IRC.  When we have to guess direction,
print a suggestion to use SG v3 interface.

I also removed the vendor unique commands from the switch.

jeremy

===== drivers/scsi/sg.c 1.90 vs edited =====
--- 1.90/drivers/scsi/sg.c	Sat May 29 10:57:23 2004
+++ edited/drivers/scsi/sg.c	Tue Jun 15 02:08:51 2004
@@ -480,6 +480,59 @@
 	return (0 == err) ? count : err;
 }
 
+
+static int
+sg_direction(char *cmnd)
+{
+	switch (cmnd[0]) {
+	/*  _DATA_OUT commands	*/
+	case WRITE_6:		case WRITE_10:		case WRITE_12:
+	case WRITE_16:
+	case WRITE_LONG:	case WRITE_SAME:	case WRITE_BUFFER:
+	case WRITE_VERIFY:	case WRITE_VERIFY_12:
+	case COMPARE:		case COPY:		case COPY_VERIFY:
+	case SEARCH_EQUAL:	case SEARCH_HIGH:	case SEARCH_LOW:
+	case SEARCH_EQUAL_12:	case SEARCH_HIGH_12:	case SEARCH_LOW_12:
+	case MODE_SELECT:	case MODE_SELECT_10:	case LOG_SELECT:
+	case SEND_DIAGNOSTIC:	case CHANGE_DEFINITION: case UPDATE_BLOCK:
+	case SET_WINDOW:	case MEDIUM_SCAN:	case SEND_VOLUME_TAG:
+	case REASSIGN_BLOCKS:
+	case PERSISTENT_RESERVE_OUT:
+		return SG_DXFER_TO_DEV;
+
+	/*  No data transfer commands  */
+	case SEEK_6:		case SEEK_10:
+	case RESERVE:		case RELEASE:
+	case TEST_UNIT_READY:
+	case START_STOP:
+	case ALLOW_MEDIUM_REMOVAL:
+		return SG_DXFER_NONE;
+
+	/*  Conditional data transfer commands	*/
+	case FORMAT_UNIT:
+		if (cmnd[1] & 0x10)	/* FmtData (data out phase)? */
+			return SG_DXFER_TO_DEV;
+		else
+			return SG_DXFER_NONE;
+
+	case VERIFY:
+		if (cmnd[1] & 0x02)	/* VERIFY:BYTCHK (data out phase)? */
+			return SG_DXFER_TO_DEV;
+		else
+			return SG_DXFER_NONE;
+
+	case RESERVE_10:
+		if (cmnd[1] & 0x03)  /* RESERVE:{LongID|Extent} (data out phase)? */
+			return SG_DXFER_TO_DEV;
+		else
+			return SG_DXFER_NONE;
+
+	/*  Must be data _IN!  */
+	default:
+		return SG_DXFER_FROM_DEV;
+	}
+}
+
 static ssize_t
 sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 {
@@ -552,11 +605,6 @@
 	hp->cmd_len = (unsigned char) cmd_size;
 	hp->iovec_count = 0;
 	hp->mx_sb_len = 0;
-	if (input_size > 0)
-		hp->dxfer_direction = (old_hdr.reply_len > SZ_SG_HEADER) ?
-		    SG_DXFER_TO_FROM_DEV : SG_DXFER_TO_DEV;
-	else
-		hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
 	hp->dxfer_len = mxsize;
 	hp->dxferp = (char __user *)buf + cmd_size;
 	hp->sbp = NULL;
@@ -566,6 +614,23 @@
 	hp->usr_ptr = NULL;
 	if (__copy_from_user(cmnd, buf, cmd_size))
 		return -EFAULT;
+	/*
+	 * If data direction is indeterminate because both input and output size
+	 * are greater than 0, use command bytes to determine direction.
+	 */
+	if (input_size == 0 && mxsize > 0)
+		hp->dxfer_direction = SG_DXFER_FROM_DEV;
+	else if (input_size > 0 && mxsize == 0)
+		hp->dxfer_direction = SG_DXFER_TO_DEV;
+	else if (input_size == 0 && mxsize == 0)
+		hp->dxfer_direction = SG_DXFER_NONE;
+	else {
+		hp->dxfer_direction = sg_direction(cmnd);
+		printk("sg_write: cannot infer direction from count %ld "
+		       "and reply_len %d; inferring from command 0x%x.  Please "
+		       "fix the application to use the sg version 3 interface\n",
+		       count, old_hdr.reply_len, (unsigned int) cmnd[0]);
+	}
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
