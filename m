From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Patch for 256 disks in 2.4
Date: Sat, 20 Jul 2002 19:57:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020720195729.C20953@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: zaitcev@redhat.com

For those who do not follow, John Cagle allocated 8 more SCSI
disk majors. Here's a patch to make use of them. I am not sure
if we want a 2.5 version; it's going to be all devicefs anyhow...

It really is strange how many places know major assignments.
I hope I found all of them which matter. Also, I think nobody
uses min_major/max_major, do you guys know if that's right?
More comments?

-- Pete

diff -ur -X dontdiff linux-2.4.19-rc1/drivers/char/sysrq.c linux-2.4.19-rc1-p3/drivers/char/sysrq.c
--- linux-2.4.19-rc1/drivers/char/sysrq.c	Mon Jul  1 12:58:54 2002
+++ linux-2.4.19-rc1-p3/drivers/char/sysrq.c	Sat Jul 20 16:55:25 2002
@@ -107,6 +107,8 @@
 	unsigned int major;
 	major = MAJOR(dev);
 
+	if (SCSI_DISK_MAJOR(major))
+		return 1;
 	switch (major) {
 	case IDE0_MAJOR:
 	case IDE1_MAJOR:
@@ -118,14 +120,6 @@
 	case IDE7_MAJOR:
 	case IDE8_MAJOR:
 	case IDE9_MAJOR:
-	case SCSI_DISK0_MAJOR:
-	case SCSI_DISK1_MAJOR:
-	case SCSI_DISK2_MAJOR:
-	case SCSI_DISK3_MAJOR:
-	case SCSI_DISK4_MAJOR:
-	case SCSI_DISK5_MAJOR:
-	case SCSI_DISK6_MAJOR:
-	case SCSI_DISK7_MAJOR:
 	case XT_DISK_MAJOR:
 		return 1;
 	default:
diff -ur -X dontdiff linux-2.4.19-rc1/drivers/scsi/hosts.h linux-2.4.19-rc1-p3/drivers/scsi/hosts.h
--- linux-2.4.19-rc1/drivers/scsi/hosts.h	Thu Jul 18 14:40:14 2002
+++ linux-2.4.19-rc1-p3/drivers/scsi/hosts.h	Sat Jul 20 16:55:25 2002
@@ -507,8 +507,8 @@
     struct module * module;	  /* Used for loadable modules */
     unsigned char scsi_type;
     unsigned int major;
-    unsigned int min_major;      /* Minimum major in range. */ 
-    unsigned int max_major;      /* Maximum major in range. */
+    unsigned int _min_major_dontuse;
+    unsigned int _max_major_dontuse;
     unsigned int nr_dev;	  /* Number currently attached */
     unsigned int dev_noticed;	  /* Number of devices detected. */
     unsigned int dev_max;	  /* Current size of arrays */
diff -ur -X dontdiff linux-2.4.19-rc1/drivers/scsi/scsi_lib.c linux-2.4.19-rc1-p3/drivers/scsi/scsi_lib.c
--- linux-2.4.19-rc1/drivers/scsi/scsi_lib.c	Mon Jul  1 12:59:15 2002
+++ linux-2.4.19-rc1-p3/drivers/scsi/scsi_lib.c	Sat Jul 20 16:55:25 2002
@@ -776,8 +776,9 @@
  *
  * Lock status: No locks assumed to be held, but as it happens the
  *              io_request_lock is held when this is called.
+ *              We traverse scis_devicelist, so protect that.
  *
- * Returns:     Nothing
+ * Returns:     Pointer to a Scsi_Device_Template.
  *
  * Notes:       The requests in the request queue may have originated
  *              from any block device driver.  We need to find out which
@@ -791,6 +792,9 @@
 
 	ASSERT_LOCK(&io_request_lock, 1);
 
+	if (SCSI_DISK_MAJOR(major))
+		major = SCSI_DISK0_MAJOR;
+
 	for (spnt = scsi_devicelist; spnt; spnt = spnt->next) {
 		/*
 		 * Search for a block device driver that supports this
@@ -799,22 +803,6 @@
 		if (spnt->blk && spnt->major == major) {
 			return spnt;
 		}
-		/*
-		 * I am still not entirely satisfied with this solution,
-		 * but it is good enough for now.  Disks have a number of
-		 * major numbers associated with them, the primary
-		 * 8, which we test above, and a secondary range of 7
-		 * different consecutive major numbers.   If this ever
-		 * becomes insufficient, then we could add another function
-		 * to the structure, and generalize this completely.
-		 */
-		if( spnt->min_major != 0 
-		    && spnt->max_major != 0
-		    && major >= spnt->min_major
-		    && major <= spnt->max_major )
-		{
-			return spnt;
-		}
 	}
 	return NULL;
 }
diff -ur -X dontdiff linux-2.4.19-rc1/drivers/scsi/sd.c linux-2.4.19-rc1-p3/drivers/scsi/sd.c
--- linux-2.4.19-rc1/drivers/scsi/sd.c	Mon Jul  1 12:59:15 2002
+++ linux-2.4.19-rc1-p3/drivers/scsi/sd.c	Sat Jul 20 16:55:25 2002
@@ -65,10 +65,10 @@
  *  static const char RCSid[] = "$Header:";
  */
 
-/* system major --> sd_gendisks index */
-#define SD_MAJOR_IDX(i)		(MAJOR(i) & SD_MAJOR_MASK)
+/* device number --> sd_gendisks index */
+#define SD_MAJOR_IDX(i)		( ((MAJOR(i) & 0x80) >> 4) + (MAJOR(i) & 7) )
 /* sd_gendisks index --> system major */
-#define SD_MAJOR(i) (!(i) ? SCSI_DISK0_MAJOR : SCSI_DISK1_MAJOR-1+(i))
+#define SD_MAJOR(i)		(sd_major[i])
 
 #define SD_PARTITION(dev)	((SD_MAJOR_IDX(dev) << 8) | (MINOR(dev) & 255))
 
@@ -96,6 +96,25 @@
 static int *sd_hardsizes;	/* Hardware sector size */
 static int *sd_max_sectors;
 
+static const unsigned int sd_major[N_SD_MAJORS] = {
+	SCSI_DISK0_MAJOR,	/* 0x08 */
+	SCSI_DISK1_MAJOR,	/* 0x41 */
+	SCSI_DISK2_MAJOR,	/* 0x42 */
+	SCSI_DISK3_MAJOR,	/* 0x43 */
+	SCSI_DISK4_MAJOR,	/* 0x44 */
+	SCSI_DISK5_MAJOR,	/* 0x45 */
+	SCSI_DISK6_MAJOR,	/* 0x46 */
+	SCSI_DISK7_MAJOR,	/* 0x47 */
+	SCSI_DISK10_MAJOR,	/* 0x80 */
+	SCSI_DISK11_MAJOR,	/* 0x81 */
+	SCSI_DISK12_MAJOR,	/* 0x82 */
+	SCSI_DISK13_MAJOR,	/* 0x83 */
+	SCSI_DISK14_MAJOR,	/* 0x84 */
+	SCSI_DISK15_MAJOR,	/* 0x85 */
+	SCSI_DISK16_MAJOR,	/* 0x86 */
+	SCSI_DISK17_MAJOR,	/* 0x87 */
+};
+
 static int check_scsidisk_media_change(kdev_t);
 static int fop_revalidate_scsidisk(kdev_t);
 
@@ -114,11 +133,6 @@
 	tag:"sd",
 	scsi_type:TYPE_DISK,
 	major:SCSI_DISK0_MAJOR,
-        /*
-         * Secondary range of majors that this driver handles.
-         */
-	min_major:SCSI_DISK1_MAJOR,
-	max_major:SCSI_DISK7_MAJOR,
 	blk:1,
 	detect:sd_detect,
 	init:sd_init,
diff -ur -X dontdiff linux-2.4.19-rc1/drivers/scsi/sd.h linux-2.4.19-rc1-p3/drivers/scsi/sd.h
--- linux-2.4.19-rc1/drivers/scsi/sd.h	Mon Jul  1 12:59:15 2002
+++ linux-2.4.19-rc1-p3/drivers/scsi/sd.h	Sat Jul 20 16:55:25 2002
@@ -40,9 +40,7 @@
  */
 extern kdev_t sd_find_target(void *host, int tgt);
 
-#define N_SD_MAJORS	8
-
-#define SD_MAJOR_MASK	(N_SD_MAJORS - 1)
+#define N_SD_MAJORS	16
 
 #endif
 
diff -ur -X dontdiff linux-2.4.19-rc1/fs/partitions/check.c linux-2.4.19-rc1-p3/fs/partitions/check.c
--- linux-2.4.19-rc1/fs/partitions/check.c	Mon Jul  1 12:59:29 2002
+++ linux-2.4.19-rc1-p3/fs/partitions/check.c	Sat Jul 20 16:55:25 2002
@@ -97,6 +97,10 @@
  * a pointer to that same buffer (for convenience).
  */
 
+/* The major calculation part duplicates SD_MAJOR_INDEX verbatim. */
+#define SCSI_DEVICE_NR(M,m)	\
+    (( ( (((M) & 0x80) >> 4) + ((M) & 7) ) << (8 - 4)) + ((m) >> 4))
+
 char *disk_name (struct gendisk *hd, int minor, char *buf)
 {
 	const char *maj = hd->major_name;
@@ -147,8 +151,8 @@
 			sprintf(buf, "%s%d", maj, unit);
 			return buf;
 	}
-	if (hd->major >= SCSI_DISK1_MAJOR && hd->major <= SCSI_DISK7_MAJOR) {
-		unit = unit + (hd->major - SCSI_DISK1_MAJOR + 1) * 16;
+	if (SCSI_DISK_MAJOR(hd->major)) {
+		unit = SCSI_DEVICE_NR(hd->major, minor);
 		if (unit+'a' > 'z') {
 			unit -= 26;
 			sprintf(buf, "sd%c%c", 'a' + unit / 26, 'a' + unit % 26);
diff -ur -X dontdiff linux-2.4.19-rc1/include/linux/blk.h linux-2.4.19-rc1-p3/include/linux/blk.h
--- linux-2.4.19-rc1/include/linux/blk.h	Mon Jul  1 12:59:39 2002
+++ linux-2.4.19-rc1-p3/include/linux/blk.h	Sat Jul 20 16:55:26 2002
@@ -143,7 +143,10 @@
 
 #define DEVICE_NAME "scsidisk"
 #define TIMEOUT_VALUE (2*HZ)
-#define DEVICE_NR(device) (((MAJOR(device) & SD_MAJOR_MASK) << (8 - 4)) + (MINOR(device) >> 4))
+/* The major calculation part duplicates SD_MAJOR_INDEX verbatim. */
+#define DEVICE_NR(device)	\
+    (( ( ((MAJOR(device) & 0x80) >> 4) + (MAJOR(device) & 7) ) << (8 - 4)) + \
+     (MINOR(device) >> 4))
 
 /* Kludge to use the same number for both char and block major numbers */
 #elif  (MAJOR_NR == MD_MAJOR) && defined(MD_DRIVER)
diff -ur -X dontdiff linux-2.4.19-rc1/include/linux/major.h linux-2.4.19-rc1-p3/include/linux/major.h
--- linux-2.4.19-rc1/include/linux/major.h	Mon Jul  1 12:59:40 2002
+++ linux-2.4.19-rc1-p3/include/linux/major.h	Sat Jul 20 16:55:26 2002
@@ -119,6 +119,15 @@
 
 #define ATARAID_MAJOR		114
 
+#define SCSI_DISK10_MAJOR	128
+#define SCSI_DISK11_MAJOR	129
+#define SCSI_DISK12_MAJOR	130
+#define SCSI_DISK13_MAJOR	131
+#define SCSI_DISK14_MAJOR	132
+#define SCSI_DISK15_MAJOR	133
+#define SCSI_DISK16_MAJOR	134
+#define SCSI_DISK17_MAJOR	135
+
 #define DASD_MAJOR      94	/* Official assignations from Peter */
 
 #define MDISK_MAJOR     95	/* Official assignations from Peter */
@@ -170,7 +179,8 @@
  */
 
 #define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
-  ((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR))
+  ((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR) || \
+  ((M) >= SCSI_DISK10_MAJOR && (M) <= SCSI_DISK17_MAJOR))
   
 #define SCSI_BLK_MAJOR(M) \
   (SCSI_DISK_MAJOR(M)	\
