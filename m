From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH 2.4] rewritable USB DVD-RAM vs. mode sense op choice
Date: 16 Aug 2004 10:29:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092673789.4297.7.camel@patlinux.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:55507 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S267763AbUHPQa7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 12:30:59 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

2.4.26 and 2.4.27 strace of dd of=, mount -w, etc. chokes via EROFS for
USB DVD-RAM.  2.4.25 I have not tried.

This small patch substitutes the MMC op x5A "MODE SENSE (10)" for the op
x1A that in t10.org PDT x05 is vendor-specific.  Such consideration
persuades a standard DVD-RAM drive to admit it rewrites DVD-RAM discs.

Revising the CDB alone of course does not suffice: we also have to step
past a different size of data in header.

Pat LaVarre

diff -urp linux-2.4.27/drivers/scsi/sr.c linux-2.4.27-pel/drivers/scsi/sr.c
--- linux-2.4.27/drivers/scsi/sr.c	2003-06-13 08:51:36.000000000 -0600
+++ linux-2.4.27-pel/drivers/scsi/sr.c	2004-08-16 10:08:37.000000000 -0600
@@ -691,7 +691,7 @@ void get_sectorsize(int i)
 
 void get_capabilities(int i)
 {
-	unsigned char cmd[6];
+	unsigned char cmd[16];
 	unsigned char *buffer;
 	int rc, n;
 
@@ -713,12 +713,12 @@ void get_capabilities(int i)
 		printk(KERN_ERR "sr: out of memory.\n");
 		return;
 	}
-	cmd[0] = MODE_SENSE;
+	memset(cmd, '\0', sizeof cmd);
+	cmd[0] = MODE_SENSE_10;
 	cmd[1] = (scsi_CDs[i].device->scsi_level <= SCSI_2) ?
 		 ((scsi_CDs[i].device->lun << 5) & 0xe0) : 0;
 	cmd[2] = 0x2a;
-	cmd[4] = 128;
-	cmd[3] = cmd[5] = 0;
+	cmd[8] = 128;
 	rc = sr_do_ioctl(i, cmd, buffer, 128, 1, SCSI_DATA_READ, NULL);
 
 	if (rc) {
@@ -731,7 +731,7 @@ void get_capabilities(int i)
 		printk("sr%i: scsi-1 drive\n", i);
 		return;
 	}
-	n = buffer[3] + 4;
+	n = 8 + ((buffer[6] << 8) | buffer[7]); /* 8 = sizeof MODE_SENSE_10 header */
 	scsi_CDs[i].cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	scsi_CDs[i].readcd_known = 1;
 	scsi_CDs[i].readcd_cdda = buffer[n + 5] & 0x01;


