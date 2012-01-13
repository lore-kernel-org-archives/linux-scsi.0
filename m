From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6/6] scsi: Disable DIF on Hitachi Ultrastar 15K300
Date: Fri, 13 Jan 2012 17:43:06 -0500
Message-ID: <1326494586-17360-7-git-send-email-martin.petersen@oracle.com>
References: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24435 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400Ab2AMWne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2012 17:43:34 -0500
In-Reply-To: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Hitachi Ultrastar 15K300 is quirky. Disable T10 PI (DIF).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_devinfo.c |    1 +
 drivers/scsi/scsi_scan.c    |    3 +++
 include/scsi/scsi_device.h  |    4 ++++
 include/scsi/scsi_devinfo.h |    1 +
 4 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index cf8dfab..43fca91 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -172,6 +172,7 @@ static struct {
 	{"HITACHI", "DF400", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "HUS1530", "*", BLIST_NO_DIF},
 	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b3c6d95..5019f18 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -923,6 +923,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_RETRY_HWERROR)
 		sdev->retry_hwerror = 1;
 
+	if (*bflags & BLIST_NO_DIF)
+		sdev->no_dif = 1;
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 77273f2..f48d94e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -151,6 +151,7 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
+	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
@@ -468,6 +469,9 @@ static inline int scsi_device_enclosure(struct scsi_device *sdev)
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
 {
+	if (sdev->no_dif)
+		return 0;
+
 	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index b4ddd3b..b10d2c0 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -30,4 +30,5 @@
 #define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
 #define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
+#define BLIST_NO_DIF		0x2000000 /* Disable PI */
 #endif
-- 
1.7.8.3.21.gab8a7

