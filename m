From: Andrew Morton <akpm@osdl.org>
Subject: many-disk support
Date: Mon, 29 Dec 2003 02:25:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229022549.50bae6d7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:59537 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263178AbTL2KZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 05:25:44 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Badari Pulavarty <pbadari@us.ibm.com>, "viro@parcelfarce.linux.theplanet.co.uk" <viro@parcelfarce.linux.theplanet.co.uk>


Guys, I've had this patch for ages.  Badari seemed to say that it wasn't
the "right" way to do it.

Can we get this nailed down please?




From: Badari Pulavarty <pbadari@us.ibm.com>

Here is the patch to support large number of SCSI disks.  The patch is not
fully cooked yet.  I was hoping to use this generate discussion.  I have
not tested it fully on 2.6.0-test6-mm1.

As I mentioned earlier, it maintains backward compatibility with existing
sd major/minors - by attached all the new disks to last sd major.  And
also, I made the number of disks to support as configurable - to avoid
dependency on how many minor bits.



 drivers/scsi/Kconfig |    8 ++++++++
 drivers/scsi/sd.c    |   25 +++++++++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/Kconfig~support-zillions-of-scsi-disks drivers/scsi/Kconfig
--- 25/drivers/scsi/Kconfig~support-zillions-of-scsi-disks	2003-10-23 22:01:19.000000000 -0700
+++ 25-akpm/drivers/scsi/Kconfig	2003-10-23 22:01:19.000000000 -0700
@@ -55,6 +55,14 @@ config BLK_DEV_SD
 	  In this case, do not compile the driver for your SCSI host adapter
 	  (below) as a module either.
 
+config MAX_SD_DISKS
+	int "Maximum number of SCSI disks to support (256-8192)"
+	depends on BLK_DEV_SD
+	default "256"
+	help
+	The maximum number SCSI disks to support. Default is 256.
+	Change this value if you want kernel to support lots of SCSI devices.
+
 config CHR_DEV_ST
 	tristate "SCSI tape support"
 	depends on SCSI
diff -puN drivers/scsi/sd.c~support-zillions-of-scsi-disks drivers/scsi/sd.c
--- 25/drivers/scsi/sd.c~support-zillions-of-scsi-disks	2003-10-23 22:01:19.000000000 -0700
+++ 25-akpm/drivers/scsi/sd.c	2003-10-23 22:01:19.000000000 -0700
@@ -62,6 +62,7 @@
  */
 #define SD_MAJORS	16
 #define SD_DISKS	(SD_MAJORS << 4)
+#define TOTAL_SD_DISKS	CONFIG_MAX_SD_DISKS
 
 /*
  * Time out in seconds for disks and Magneto-opticals (which are slower).
@@ -95,7 +96,7 @@ struct scsi_disk {
 };
 
 
-static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
+static unsigned long sd_index_bits[TOTAL_SD_DISKS / BITS_PER_LONG];
 static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
 
 static int sd_revalidate_disk(struct gendisk *disk);
@@ -130,6 +131,9 @@ static int sd_major(int major_idx)
 		return SCSI_DISK1_MAJOR + major_idx - 1;
 	case 8 ... 15:
 		return SCSI_DISK8_MAJOR + major_idx - 8;
+#define MAX_IDX        (TOTAL_SD_DISKS >> 4)
+	case 16 ... MAX_IDX:
+		return SCSI_DISK15_MAJOR;
 	default:
 		BUG();
 		return 0;	/* shut up gcc */
@@ -1318,8 +1322,8 @@ static int sd_probe(struct device *dev)
 		goto out_free;
 
 	spin_lock(&sd_index_lock);
-	index = find_first_zero_bit(sd_index_bits, SD_DISKS);
-	if (index == SD_DISKS) {
+	index = find_first_zero_bit(sd_index_bits, TOTAL_SD_DISKS);
+	if (index == TOTAL_SD_DISKS) {
 		spin_unlock(&sd_index_lock);
 		error = -EBUSY;
 		goto out_put;
@@ -1334,15 +1338,24 @@ static int sd_probe(struct device *dev)
 	sdkp->openers = 0;
 
 	gd->major = sd_major(index >> 4);
-	gd->first_minor = (index & 15) << 4;
+	if (index > SD_DISKS)
+		gd->first_minor = ((index - SD_DISKS) & 15) << 4;
+	else
+		gd->first_minor = (index & 15) << 4;
 	gd->minors = 16;
 	gd->fops = &sd_fops;
 
-	if (index >= 26) {
+	if (index < 26) {
+		sprintf(gd->disk_name, "sd%c", 'a' + index % 26);
+	} else if (index < (26*27)) {
 		sprintf(gd->disk_name, "sd%c%c",
 			'a' + index/26-1,'a' + index % 26);
 	} else {
-		sprintf(gd->disk_name, "sd%c", 'a' + index % 26);
+		const unsigned int m1 = (index/ 26 - 1) / 26 - 1;
+		const unsigned int m2 = (index / 26 - 1) % 26;
+		const unsigned int m3 = index % 26;
+		sprintf(gd->disk_name, "sd%c%c%c",
+			'a' + m1, 'a' + m2, 'a' + m3);
 	}
 
 	strcpy(gd->devfs_name, sdp->devfs_name);

_

