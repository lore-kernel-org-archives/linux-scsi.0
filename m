From: Andrew Morton <akpm@osdl.org>
Subject: lots and lots of disks again
Date: Wed, 4 Feb 2004 02:45:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040204024512.5bf68428.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:52434 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266320AbUBDKng (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2004 05:43:36 -0500
Received: from mnm (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with ESMTP id i14AhYB04419
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2004 02:43:34 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


You can't hide from me you know ;)

What to do about this?



Last time it was discussed we had:

Christoph Hellwig <hch@infradead.org> wrote:
>
> 
>  - I think the bitmap overhead was killing us on big x86 machines, right?
>    so that might need some swork.
>  - a config option definitly is the wrong way to go.
>  - I don't think assigning more numbers to the last major is a bad idea,
>    better assign them to the first one, maybe with a hole for what we're
>    using the other majors currently for, so when udev gets more mature
>    we can kill the additional majors.

Matthew Wilcox <willy@debian.org> wrote:
>
> LWN were kind enough to archive my previous thoughts on this at
> http://lwn.net/Articles/54840/
> 
> I'd've worked on some code for this if anyone had been interested ...

badari <pbadari@us.ibm.com> wrote:
>
> I am not sorry for not replying for so long. I have been on vacation.
> 
> 1) I am not really concerned about bitmap overhead. Bitmap of one
> page (4k) - should be enough to support 32K disks. That should be
> good enough for most of the machines.
> 
> 2) I used config option for 2 reasons
>         - to minimize impact on machines this is not needed.
>         - didn't want to depend on <major, minor> split to decide on
>            how many disks we can support.
> 
> 3) The reason, I assigned all the disks to last major is to maintain backward
> compatibility with current major, minor assignments. Hopefully "udev"
> will cleanup all these.
> 
> My question is, what do we do for current 2.6 ? Hoping to address these
> before distros start making 2.6 distros and adding their own stuff to support
> this.
> 
> And also, is there a plan to support more partitions per disk ?

And nothing happened.





From: Badari Pulavarty <pbadari@us.ibm.com>

Here is the patch to support large number of SCSI disks.  The patch is not
fully cooked yet.  I was hoping to use this generate discussion.  I have
not tested it fully on 2.6.0-test6-mm1.

As I mentioned earlier, it maintains backward compatibility with existing
sd major/minors - by attached all the new disks to last sd major.  And
also, I made the number of disks to support as configurable - to avoid
dependency on how many minor bits.



---

 drivers/scsi/Kconfig |    8 ++++++++
 drivers/scsi/sd.c    |   25 +++++++++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/Kconfig~support-zillions-of-scsi-disks drivers/scsi/Kconfig
--- 25/drivers/scsi/Kconfig~support-zillions-of-scsi-disks	2004-01-07 19:10:47.000000000 -0800
+++ 25-akpm/drivers/scsi/Kconfig	2004-01-07 19:10:47.000000000 -0800
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
--- 25/drivers/scsi/sd.c~support-zillions-of-scsi-disks	2004-01-07 19:10:47.000000000 -0800
+++ 25-akpm/drivers/scsi/sd.c	2004-01-07 19:10:47.000000000 -0800
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
@@ -1320,8 +1324,8 @@ static int sd_probe(struct device *dev)
 		goto out_free;
 
 	spin_lock(&sd_index_lock);
-	index = find_first_zero_bit(sd_index_bits, SD_DISKS);
-	if (index == SD_DISKS) {
+	index = find_first_zero_bit(sd_index_bits, TOTAL_SD_DISKS);
+	if (index == TOTAL_SD_DISKS) {
 		spin_unlock(&sd_index_lock);
 		error = -EBUSY;
 		goto out_put;
@@ -1336,15 +1340,24 @@ static int sd_probe(struct device *dev)
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

