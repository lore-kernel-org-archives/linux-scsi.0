From: Kenn Humborg <kenn@linux.ie>
Subject: AUTOSENSE bug in NCR5380.c
Date: Sat, 14 Aug 2004 00:54:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040813235408.GA3547@excalibur.research.wombat.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.mail.iol.ie ([193.120.142.151]:8918 "EHLO
	mail1.mail.iol.ie") by vger.kernel.org with ESMTP id S267784AbUHMXyO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Aug 2004 19:54:14 -0400
Received: from dialup0184.ts005.bmt.esat.net ([212.2.172.184] helo=excalibur.research.wombat.ie)
	by mail1.mail.iol.ie with esmtp (Exim 3.36 #9)
	id 1BvlsB-00029Z-00
	for linux-scsi@vger.kernel.org; Sat, 14 Aug 2004 00:54:13 +0100
Received: from excalibur.research.wombat.ie (IDENT:jmPJy27Mb0oeVup+8C3P0bm/xAzKg16H@excalibur [127.0.0.1])
	by excalibur.research.wombat.ie (8.12.10/8.12.10) with ESMTP id i7DNs9QR004320
	for <linux-scsi@vger.kernel.org>; Sat, 14 Aug 2004 00:54:09 +0100
Received: (from kenn@localhost)
	by excalibur.research.wombat.ie (8.12.10/8.12.10/Submit) id i7DNs8HL004319
	for linux-scsi@vger.kernel.org; Sat, 14 Aug 2004 00:54:08 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Around line 2470 in NCR5380.c, if a command fails, and AUTOSENSE is on,
the current command is converted into a REQUEST_SENSE command and
put at the top of the request queue.  Part of this setup, is setting
up cmd->SCp to point at the sense_buffer, so that the received sense
data goes straight into the sense buffer.

Around line 1730, NCR5380_select() calls initialize_SCp() which ends
up clobbering cmd->SCp, and the sense data get written into the 
original request buffer.

This is what happens if cmd->use_sg = 0.  I haven't looked at what
happens if use_sg is non-zero, but I expect the effect will be the same.

The attached patch works around the problem for me.  Is there a better
way to deal with this?

Later,
Kenn

RCS file: /cvsroot/linux-vax/kernel-2.5/drivers/scsi/NCR5380.c,v
retrieving revision 1.2
retrieving revision 1.3
diff -u -d -r1.2 -r1.3
--- NCR5380.c	8 Aug 2004 23:32:34 -0000	1.2
+++ NCR5380.c	13 Aug 2004 23:44:24 -0000	1.3
@@ -1734,8 +1737,9 @@
 	hostdata->connected = cmd;
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
 
-	initialize_SCp(cmd);
-
+	if (cmd->SCp.ptr != (char *)cmd->sense_buffer) {
+		initialize_SCp(cmd);
+	}
 
 	return 0;
