From: Andries.Brouwer@cwi.nl
Subject: [PATCH] Re: 2.4.21-pre7, disk size, display wrong or serious bug?
Date: Sun, 6 Apr 2003 14:39:38 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <UTC200304061239.h36Cdcw23647.aeb@smtp.cwi.nl>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: abehn@gmx.net, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, marcelo@conectiva.com.br
List-Id: linux-scsi@vger.kernel.org

	From: Andreas Behnert <abehn@gmx.net>

	Yesterday I installed an external RAID system, machine
	was running kernel 2.2.20 and everything worked ok:
	~snip~
	  SCSI device sdb: hdwr sector= 512 bytes. Sectors=1278558208
	  [624296 MB] [624.3 GB]
	~snip~

	Then I compiled 2.4.21-pre7:
	~snip~
	  SCSI device sdb: 1278558208 512-byte hdwr sectors (-444889 MB)
	~snip~

	The system *seems* to work ok but I don't know if it really
	*does* - I didn't want to experiment very much because the
	RAID array contains sensitive data

Yes, this is a frequent complaint.
Nothing is wrong, only the message.
It is fixed by the patch below.

Andries

diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sat Apr  5 10:19:53 2003
+++ b/drivers/scsi/sd.c	Sun Apr  6 14:22:35 2003
@@ -1003,7 +1003,7 @@
 			 */
 			int m;
 			int hard_sector = sector_size;
-			int sz = rscsi_disks[i].capacity * (hard_sector/256);
+			unsigned int sz = (rscsi_disks[i].capacity/2) * (hard_sector/256);
 
 			/* There are 16 minors allocated for each major device */
 			for (m = i << 4; m < ((i + 1) << 4); m++) {
@@ -1011,9 +1011,9 @@
 			}
 
 			printk("SCSI device %s: "
-			       "%d %d-byte hdwr sectors (%d MB)\n",
+			       "%u %d-byte hdwr sectors (%u MB)\n",
 			       nbuff, rscsi_disks[i].capacity,
-			       hard_sector, (sz/2 - sz/1250 + 974)/1950);
+			       hard_sector, (sz - sz/625 + 974)/1950);
 		}
 
 		/* Rescale capacity to 512-byte units */
