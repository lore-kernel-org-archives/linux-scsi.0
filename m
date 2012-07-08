From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 2/3] usb: storage: add support for write cache quirk
Date: Sat,  7 Jul 2012 23:05:28 -0400
Message-ID: <1341716728-6699-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org, akpm@linux-foundation.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add support for write cache quirk on usb hdd. scsi driver will be set to wce
by detecting write cache quirk in quirk list when plugging usb hdd.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 Documentation/kernel-parameters.txt |    2 ++
 drivers/usb/storage/scsiglue.c      |    5 +++++
 drivers/usb/storage/usb.c           |    5 ++++-
 include/linux/usb_usual.h           |    4 +++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index de8d60c..7e7f3af 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2939,6 +2939,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					initial READ(10) command);
 				o = CAPACITY_OK (accept the capacity
 					reported by the device);
+				p = WRITE_CACHE (the device cache is ON
+					by default);
 				r = IGNORE_RESIDUE (the device reports
 					bogus residue values);
 				s = SINGLE_LUN (the device has only one
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 11418da..a3d5436 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -236,6 +236,11 @@ static int slave_configure(struct scsi_device *sdev)
 					US_FL_SCM_MULT_TARG)) &&
 				us->protocol == USB_PR_BULK)
 			us->use_last_sector_hacks = 1;
+
+		/* Check if write cache default on flag is set or not */
+		if (us->fflags & US_FL_WRITE_CACHE)
+			sdev->wce_default_on = 1;
+
 	} else {
 
 		/* Non-disk-type devices don't need to blacklist any pages
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index e23c30a..d012fe4 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -473,7 +473,7 @@ static void adjust_quirks(struct us_data *us)
 			US_FL_CAPACITY_OK | US_FL_IGNORE_RESIDUE |
 			US_FL_SINGLE_LUN | US_FL_NO_WP_DETECT |
 			US_FL_NO_READ_DISC_INFO | US_FL_NO_READ_CAPACITY_16 |
-			US_FL_INITIAL_READ10);
+			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE);
 
 	p = quirks;
 	while (*p) {
@@ -529,6 +529,9 @@ static void adjust_quirks(struct us_data *us)
 		case 'o':
 			f |= US_FL_CAPACITY_OK;
 			break;
+		case 'p':
+			f |= US_FL_WRITE_CACHE;
+			break;
 		case 'r':
 			f |= US_FL_IGNORE_RESIDUE;
 			break;
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 17df360..e84e769 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -64,7 +64,9 @@
 	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
 		/* cannot handle READ_CAPACITY_16 */		\
 	US_FLAG(INITIAL_READ10,	0x00100000)			\
-		/* Initial READ(10) (and others) must be retried */
+		/* Initial READ(10) (and others) must be retried */	\
+	US_FLAG(WRITE_CACHE,	0x00200000)			\
+		/* Write Cache status is not available */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
1.7.9.5
