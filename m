From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [Patch] set data direction in sd_synchronize_cache in sd.c
Date: Mon, 28 Apr 2003 13:19:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304281319.34050.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d06lmsgate.uk.ibm.com ([195.212.29.1]:49383 "EHLO
	d06lmsgate.uk.ibm.com") by vger.kernel.org with ESMTP
	id S263220AbTD1LKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2003 07:10:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

Hi,

the following patch sets the data direction in sd_synchronize_cache
to SCSI_DATA_NONE. Otherwise the data direction would be
SCSI_DATA_UNKNOWN, which is at least a problem for the zfcp
lldd, since it expects a value differently from unknown.
Please apply, thanks.

Heiko

diff -urN linux-2.5.68/drivers/scsi/sd.c linux-2.5.68-sd/drivers/scsi/sd.c
--- linux-2.5.68/drivers/scsi/sd.c	Sun Apr 20 04:50:34 2003
+++ linux-2.5.68-sd/drivers/scsi/sd.c	Fri Apr 25 12:51:41 2003
@@ -1502,7 +1502,8 @@
 			printk("FAILED\n  No memory for request\n");
 		return 0;
 	}
-		
+
+	SRpnt->sr_data_direction = SCSI_DATA_NONE;
 
 	for(retries = 3; retries > 0; --retries) {
 		unsigned char cmd[10] = { 0 };

