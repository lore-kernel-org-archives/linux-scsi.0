From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH 2.4] rewritable USB DVD-RAM vs. mode sense op choice
Date: 23 Aug 2004 16:45:03 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093301103.3626.5.camel@patlinux.iomegacorp.com>
References: <1092673789.4297.7.camel@patlinux.iomegacorp.com><2004082315485
	0.GC2301@suse.de><F631591B-F523-11D8-BFA2-00039398BB5E@ieee.org><2004082317
	1253.GD24089@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:65219 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S267989AbUHWWqd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 18:46:33 -0400
In-Reply-To: <20040823171253.GD24089@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org, Paul Smith <paulhsmith@sisna.com>

> add a fallback to issue MODE_SENSE_10 when _6 fails, ...
> should be golden.

Jens A:

This 2.4 patch, as you suggested, makes sr_mod try op x5A MODE_SENSE_10
if op x1A MODE_SENSE fails in any way.

As you know, the 2.4.27 sr_mod without this patch complains "scsi-1
drive", rather than discovering "scsi3-mmc drive: ... dvd-ram ...", if
plugged into a USB DVD-RAM drive that implements only SFF/ MMC x5A and
not SPC x1A.

Do you like this patch?

Want people to run any tests in particular?

Already, with rewritable DVD-RAM discs, in dd of= rewritability and USB
CDB traces, I see this makes the USB DVD-RAM "HL-DT-ST" "DVDRAM" "A100"
rewritable and has no effect on the USB DVD-RAM "MATSHITA" "DVD-RAM"
"A111".

Pat LaVarre

--- linux-2.4.27/drivers/scsi/sr.c	2003-06-13 08:51:36.000000000 -0600
+++ linux-2.4.27-pel/drivers/scsi/sr.c	2004-08-23 14:07:49.000000000 -0600
@@ -689,9 +689,42 @@ void get_sectorsize(int i)
 	scsi_free(buffer, 512);
 }
 
-void get_capabilities(int i)
+static int sr_mode_sense_10(int * n,
+	int i, unsigned char * buffer, unsigned buflength,
+	int quiet, int readwrite, struct request_sense * sense)
+{
+	unsigned char cmd[16];
+	int rc;
+	memset(cmd, '\0', sizeof cmd);
+	cmd[0] = MODE_SENSE_10;
+	cmd[1] = (scsi_CDs[i].device->scsi_level <= SCSI_2) ?
+		 ((scsi_CDs[i].device->lun << 5) & 0xe0) : 0;
+	cmd[2] = 0x2a;
+	cmd[8] = 128;
+	rc = sr_do_ioctl(i, cmd, buffer, buflength, quiet, readwrite, sense);
+	*n = 8 + ((buffer[6] << 8) | buffer[7]);
+	return rc;
+}
+
+static int sr_mode_sense_6(int * n,
+	int i, unsigned char * buffer, unsigned buflength,
+	int quiet, int readwrite, struct request_sense * sense)
 {
 	unsigned char cmd[6];
+	int rc;
+	cmd[0] = MODE_SENSE;
+	cmd[1] = (scsi_CDs[i].device->scsi_level <= SCSI_2) ?
+		 ((scsi_CDs[i].device->lun << 5) & 0xe0) : 0;
+	cmd[2] = 0x2a;
+	cmd[4] = 128;
+	cmd[3] = cmd[5] = 0;
+	rc = sr_do_ioctl(i, cmd, buffer, buflength, quiet, readwrite, sense);
+	*n = buffer[3] + 4;
+	return rc;
+}
+
+void get_capabilities(int i)
+{
 	unsigned char *buffer;
 	int rc, n;
 
@@ -713,13 +746,18 @@ void get_capabilities(int i)
 		printk(KERN_ERR "sr: out of memory.\n");
 		return;
 	}
-	cmd[0] = MODE_SENSE;
-	cmd[1] = (scsi_CDs[i].device->scsi_level <= SCSI_2) ?
-		 ((scsi_CDs[i].device->lun << 5) & 0xe0) : 0;
-	cmd[2] = 0x2a;
-	cmd[4] = 128;
-	cmd[3] = cmd[5] = 0;
-	rc = sr_do_ioctl(i, cmd, buffer, 128, 1, SCSI_DATA_READ, NULL);
+
+	/* SFF/ MMC op x5A MODE_SENSE_10 should work,
+	 * and SPC op x1A MODE_SENSE might work,
+	 * so we try both except we try x1A first to match Linux 2.4.27.
+	 */
+
+	rc = sr_mode_sense_6(&n,
+		i, buffer, 128, 1, SCSI_DATA_READ, NULL);
+	if (rc) {
+		rc = sr_mode_sense_10(&n,
+			i, buffer, 128, 1, SCSI_DATA_READ, NULL);
+	}
 
 	if (rc) {
 		/* failed, drive doesn't have capabilities mode page */
@@ -731,7 +769,6 @@ void get_capabilities(int i)
 		printk("sr%i: scsi-1 drive\n", i);
 		return;
 	}
-	n = buffer[3] + 4;
 	scsi_CDs[i].cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	scsi_CDs[i].readcd_known = 1;
 	scsi_CDs[i].readcd_cdda = buffer[n + 5] & 0x01;


