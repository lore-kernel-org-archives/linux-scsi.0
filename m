From: John McKell <mckellj@iomega.com>
Subject: [PATCH] DVD-R capability flag set incorrectly, /proc formatting fix
Date: 09 Feb 2004 16:26:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076369160.3594.6.camel@lintest.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:63205 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265378AbUBIX0C
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 18:26:02 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

This patch for scsi/sr.c and cdrom/cdrom.c persuades 
/proc/sys/dev/cdrom/info to report that connecting a drive via USB 
rather than ATAPI in fact does not make it able to write DVD-R.

In linux-2.6.2 without this patch, when sr0 and hdd are the same type
of device connected via USB and ATAPI respectively, I see:

$ cat /proc/sys/dev/cdrom/info:
drive name:             sr1     sr0     hdd
...
Can write CD-R:         1       0       0
Can write CD-RW:        1       0       0
Can read DVD:           0       0       0
Can write DVD-R:        1       1       0
Can write DVD-RAM:      0       0       0
Can read MRW:           0               0               0
Can write MRW:          0               0               0

With this patch applied, instead I see:

$ cat /proc/sys/dev/cdrom/info:
drive name:             sr1     sr0     hdd
...
Can write CD-R:         1       0       0
Can write CD-RW:        1       0       0
Can read DVD:           0       0       0
Can write DVD-R:        0       0       0
Can write DVD-RAM:      0       0       0
Can read MRW:           0       0       0
Can write MRW:          0       0       0

The sr1 device in particular is an ordinary CD-RW that in fact cannot 
write DVD-R.

While messing with this code, I also thought to tweak the /proc 
formatting to align the tabbed columns.

---John McKell, Iomega Corp

diff -Nurp linux-2.6.2/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.2/drivers/scsi/sr.c	2004-02-03 20:43:19.000000000 -0700
+++ linux/drivers/scsi/sr.c	2004-02-09 13:59:10.000000000 -0700
@@ -795,10 +795,9 @@ static void get_capabilities(struct scsi
 	if ((buffer[n + 2] & 0x8) == 0)
 		/* not a DVD drive */
 		cd->cdi.mask |= CDC_DVD;
-	if ((buffer[n + 3] & 0x20) == 0) {
+	if ((buffer[n + 3] & 0x20) == 0) 
 		/* can't write DVD-RAM media */
 		cd->cdi.mask |= CDC_DVD_RAM;
-	} else
 	if ((buffer[n + 3] & 0x10) == 0)
 		/* can't write DVD-R media */
 		cd->cdi.mask |= CDC_DVD_R;
diff -Nurp linux-2.6.2/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.2/drivers/cdrom/cdrom.c	2004-02-05 14:30:46.000000000 -0700
+++ linux/drivers/cdrom/cdrom.c	2004-02-09 13:58:21.000000000 -0700
@@ -2740,13 +2740,13 @@ int cdrom_sysctl_info(ctl_table *ctl, in
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
-	pos += sprintf(info+pos, "\nCan read MRW:");
+	pos += sprintf(info+pos, "\nCan read MRW:\t");
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t\t%d", CDROM_CAN(CDC_MRW) != 0);
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW) != 0);
 
-	pos += sprintf(info+pos, "\nCan write MRW:");
+	pos += sprintf(info+pos, "\nCan write MRW:\t");
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t\t%d", CDROM_CAN(CDC_MRW_W) != 0);
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW_W) != 0);
 
 	strcpy(info+pos,"\n\n");
 		



