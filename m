From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH] fix units/partition count in sd.c (2.4.x)
Date: Mon, 14 Feb 2005 17:40:44 -0500
Message-ID: <421128EC.6020607@adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080100030809060502040804"
Received: from magic.adaptec.com ([216.52.22.17]:47233 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261364AbVBNWks (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 17:40:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>

This is a multi-part message in MIME format.
--------------080100030809060502040804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch fixes the nr_real count in sd.c, which is also used
in genhd.c to print out the partitions/units.  The problem is that
nr_real is decremented on detach, the genhd's nr_sects is
cleared but the entry is still there and is being counted
for when displaying the partitions.  Thus when nr_real
is decremented _and_ a 0-ed partition/unit is counted,
we get to not display 1 or more entries of the tail of
the list.

The solution is to not decrement nr_real on detach, effectively
never decrementing it, and so that it doesn't grow without a bound,
to throttle it on attach, incrementing it only if it would be
smaller than nr_dev.

This was observed on a RH kernel and on the current BK kernel.
Tested and fixed on 2.4.30-pre1 (BK).  This patch is against 2.4.30-pre1.

To reproduce: assume 4 scsi disks sda, sdb, sdc, sdd.
#echo "scsi remove-single-device <sdb-HCTL>" > /proc/scsi/scsi
#cat /proc/partitions
<<sdb _and_ sdd are not listed>>

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

===== sd.c 1.31 vs edited =====
--- 1.31/drivers/scsi/sd.c      2003-06-25 19:34:08 -04:00
+++ edited/sd.c 2005-02-14 17:09:43 -05:00
@@ -1332,8 +1332,8 @@
 
        rscsi_disks[i].device = SDp;
        rscsi_disks[i].has_part_table = 0;
-       sd_template.nr_dev++;
-       SD_GENDISK(i).nr_real++;
+       if (sd_template.nr_dev++ >= SD_GENDISK(i).nr_real)
+               SD_GENDISK(i).nr_real++;
         devnum = i % SCSI_DISKS_PER_MAJOR;
         SD_GENDISK(i).de_arr[devnum] = SDp->de;
         if (SDp->removable)
@@ -1424,9 +1424,12 @@
 
        for (dpnt = rscsi_disks, i = 0; i < sd_template.dev_max; i++, dpnt++)
                if (dpnt->device == SDp) {
+                       char nbuff[6];
 
                        /* If we are disconnecting a disk driver, sync and invalidate
                         * everything */
+                       sd_devname(i, nbuff);
+
                        sdgd = &SD_GENDISK(i);
                        max_p = sd_gendisk.max_p;
                        start = i << sd_gendisk.minor_shift;
@@ -1447,7 +1450,12 @@
                        SDp->attached--;
                        sd_template.dev_noticed--;
                        sd_template.nr_dev--;
-                       SD_GENDISK(i).nr_real--;
+
+                       printk("Detached scsi %sdisk %s at scsi%d, "
+                              "channel %d, id %d, lun %d\n",
+                              SDp->removable ? "removable " : "",
+                              nbuff, SDp->host->host_no, SDp->channel,
+                              SDp->id, SDp->lun);
                        return;
                }
        return;

	Luben
P.S. Patch attached as well, for formatting.

--------------080100030809060502040804
Content-Type: octet/stream;
 name="sd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd.patch"

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

===== sd.c 1.31 vs edited =====
--- 1.31/drivers/scsi/sd.c	2003-06-25 19:34:08 -04:00
+++ edited/sd.c	2005-02-14 17:09:43 -05:00
@@ -1332,8 +1332,8 @@
 
 	rscsi_disks[i].device = SDp;
 	rscsi_disks[i].has_part_table = 0;
-	sd_template.nr_dev++;
-	SD_GENDISK(i).nr_real++;
+	if (sd_template.nr_dev++ >= SD_GENDISK(i).nr_real)
+		SD_GENDISK(i).nr_real++;
         devnum = i % SCSI_DISKS_PER_MAJOR;
         SD_GENDISK(i).de_arr[devnum] = SDp->de;
         if (SDp->removable)
@@ -1424,9 +1424,12 @@
 
 	for (dpnt = rscsi_disks, i = 0; i < sd_template.dev_max; i++, dpnt++)
 		if (dpnt->device == SDp) {
+			char nbuff[6];
 
 			/* If we are disconnecting a disk driver, sync and invalidate
 			 * everything */
+			sd_devname(i, nbuff);
+			
 			sdgd = &SD_GENDISK(i);
 			max_p = sd_gendisk.max_p;
 			start = i << sd_gendisk.minor_shift;
@@ -1447,7 +1450,12 @@
 			SDp->attached--;
 			sd_template.dev_noticed--;
 			sd_template.nr_dev--;
-			SD_GENDISK(i).nr_real--;
+
+			printk("Detached scsi %sdisk %s at scsi%d, "
+			       "channel %d, id %d, lun %d\n",
+			       SDp->removable ? "removable " : "",
+			       nbuff, SDp->host->host_no, SDp->channel,
+			       SDp->id, SDp->lun);
 			return;
 		}
 	return;

--------------080100030809060502040804--
