From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 12:55:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309221250470.1673-100000@home.osdl.org>
References: <1064253312.15409.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:20452 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263304AbTIVTz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 15:55:56 -0400
In-Reply-To: <1064253312.15409.19.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl


On 22 Sep 2003, James Bottomley wrote:
> 
> I think we could try 4 bytes for this (even to avoid wide residue
> problems) and see how it goes.

How about just trusting the size (and as far as I can tell from the SCSI 
specs, the size is the size _without_ the header and block descriptors), 
and capping it at 20?

If the device reports a size that is smaller than the required one (3), we 
just fail the request - instead of doing a small read and then making 
decisions on data that isn't even there, like we used to do!

(The old code would use the "size" as the read length argument, which
really looks fundamentally wrong. At the very least it should add in the
header length etc).

Can people try this attached patch? It looks bigger than it is - in order 
to do sane error handling for the "size is too small" case I re-organized 
the thing a bit. The real change is just

 - capping size at 20 (real value) instead of 128 (random crud)
 - properly add in the header and block descriptor sizes

Comments?

			Linus

-----
===== drivers/scsi/sd.c 1.134 vs edited =====
--- 1.134/drivers/scsi/sd.c	Wed Jun 25 04:47:26 2003
+++ edited/drivers/scsi/sd.c	Mon Sep 22 12:42:32 2003
@@ -1108,14 +1108,26 @@
 	/* cautiously ask */
 	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
 
-	if (scsi_status_is_good(res)) {
-		/* that went OK, now ask for the proper length */
-		len = data.length;
-		if (len > 128)
-			len = 128;
-		res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer,
-				       len, &data);
-	}
+	if (!scsi_status_is_good(res))
+		goto bad_sense;
+
+	/* that went OK, now ask for the proper length */
+	len = data.length;
+
+	/*
+	 * We're only interested in the first three bytes, actually.
+	 * But the data cache page is defined for the first 20.
+	 */
+	if (len < 3)
+		goto bad_sense;
+	if (len > 20)
+		len = 20;
+
+	/* Take headers and block descriptors into account */
+	len += data.header_length + data.block_descriptor_length;
+
+	/* Get the data */
+	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len, &data);
 
 	if (scsi_status_is_good(res)) {
 		const char *types[] = {
@@ -1133,23 +1145,26 @@
 
 		printk(KERN_NOTICE "SCSI device %s: drive cache: %s\n",
 		       diskname, types[ct]);
+
+		return;
+	}
+
+bad_sense:
+	if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
+	     && (SRpnt->sr_sense_buffer[2] & 0x0f) == ILLEGAL_REQUEST
+	     /* ASC 0x24 ASCQ 0x00: Invalid field in CDB */
+	     && SRpnt->sr_sense_buffer[12] == 0x24
+	     && SRpnt->sr_sense_buffer[13] == 0x00) {
+		printk(KERN_NOTICE "%s: cache data unavailable\n",
+		       diskname);
 	} else {
-		if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
-		     && (SRpnt->sr_sense_buffer[2] & 0x0f) == ILLEGAL_REQUEST
-		     /* ASC 0x24 ASCQ 0x00: Invalid field in CDB */
-		     && SRpnt->sr_sense_buffer[12] == 0x24
-		     && SRpnt->sr_sense_buffer[13] == 0x00) {
-			printk(KERN_NOTICE "%s: cache data unavailable\n",
-			       diskname);
-		} else {
-			printk(KERN_ERR "%s: asking for cache data failed\n",
-			       diskname);
-		}
-		printk(KERN_ERR "%s: assuming drive cache: write through\n",
+		printk(KERN_ERR "%s: asking for cache data failed\n",
 		       diskname);
-		sdkp->WCE = 0;
-		sdkp->RCD = 0;
 	}
+	printk(KERN_ERR "%s: assuming drive cache: write through\n",
+	       diskname);
+	sdkp->WCE = 0;
+	sdkp->RCD = 0;
 }
 
 /**

