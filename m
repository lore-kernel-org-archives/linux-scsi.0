From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH fix for 3.17] uas: Add no-report-opcodes quirk
Date: Tue, 16 Sep 2014 18:36:52 +0200
Message-ID: <1410885412-8626-2-git-send-email-hdegoede@redhat.com>
References: <1410885412-8626-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbaIPQhC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2014 12:37:02 -0400
In-Reply-To: <1410885412-8626-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Claudio Bizzarri <claudio.bizzarri@gmail.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Besides the ASM1051 (*) needing sdev->no_report_opcodes = 1, it turns out that
the JMicron JMS567 also needs it to work properly with uas (usb-storage always
sets it). Since some of the scsi devs were not to keen on the idea to
outrightly set sdev->no_report_opcodes = 1 for all uas devices, so add a quirk
for this, and set it for the JMS567.

*) Which has become a non-issue since we've completely blacklisted uas on
the ASM1051 for other reasons

Cc: stable@vger.kernel.org
Reported-and-tested-by: Claudio Bizzarri <claudio.bizzarri@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 Documentation/kernel-parameters.txt | 2 ++
 drivers/usb/storage/uas.c           | 4 ++++
 drivers/usb/storage/unusual_uas.h   | 7 +++++++
 drivers/usb/storage/usb.c           | 5 ++++-
 include/linux/usb_usual.h           | 2 ++
 5 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index dd4fe98..1edd5fd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3522,6 +3522,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					READ_DISC_INFO command);
 				e = NO_READ_CAPACITY_16 (don't use
 					READ_CAPACITY_16 command);
+				f = NO_REPORT_OPCODES (don't use report opcodes
+					command, uas only);
 				h = CAPACITY_HEURISTICS (decrease the
 					reported device capacity by one
 					sector if the number is odd);
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 75d2ccd..2713693 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -961,6 +961,10 @@ static int uas_slave_alloc(struct scsi_device *sdev)
 static int uas_slave_configure(struct scsi_device *sdev)
 {
 	struct uas_dev_info *devinfo = sdev->hostdata;
+
+	if (devinfo->flags & US_FL_NO_REPORT_OPCODES)
+		sdev->no_report_opcodes = 1;
+
 	scsi_set_tag_type(sdev, MSG_ORDERED_TAG);
 	scsi_activate_tcq(sdev, devinfo->qdepth - 2);
 	return 0;
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 3ff2dd4..3e62437 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -53,3 +53,10 @@ UNUSUAL_DEV(0x0bc2, 0x3312, 0x0000, 0x9999,
 		"Expansion Desk",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
+
+/* Reported-by: Claudio Bizzarri <claudio.bizzarri@gmail.com> */
+UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
+		"JMicron",
+		"JMS567",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index b9d1b93..f60e7d4 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -479,7 +479,7 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 			US_FL_SINGLE_LUN | US_FL_NO_WP_DETECT |
 			US_FL_NO_READ_DISC_INFO | US_FL_NO_READ_CAPACITY_16 |
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
-			US_FL_NO_ATA_1X);
+			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES);
 
 	p = quirks;
 	while (*p) {
@@ -517,6 +517,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 		case 'e':
 			f |= US_FL_NO_READ_CAPACITY_16;
 			break;
+		case 'f':
+			f |= US_FL_NO_REPORT_OPCODES;
+			break;
 		case 'h':
 			f |= US_FL_CAPACITY_HEURISTICS;
 			break;
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index d271f88..a7f2604 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -75,6 +75,8 @@
 		/* Cannot handle FUA in WRITE or READ CDBs */	\
 	US_FLAG(NO_ATA_1X,	0x02000000)			\
 		/* Cannot handle ATA_12 or ATA_16 CDBs */	\
+	US_FLAG(NO_REPORT_OPCODES,	0x04000000)		\
+		/* Cannot handle MI_REPORT_SUPPORTED_OPERATION_CODES */	\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
2.1.0

