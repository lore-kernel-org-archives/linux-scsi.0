From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/5] scsi: Disable DIF on Hitachi Ultrastar 15K300
Date: Tue, 28 Aug 2012 14:29:35 -0400
Message-ID: <1346178577-28628-3-git-send-email-martin.petersen@oracle.com>
References: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30828 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2H1SaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 14:30:07 -0400
In-Reply-To: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, "Martin K. Petersen" <martin.petersen@oracle.com>

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
index 56a9379..0a224e2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -911,6 +911,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_RETRY_HWERROR)
 		sdev->retry_hwerror = 1;
 
+	if (*bflags & BLIST_NO_DIF)
+		sdev->no_dif = 1;
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9895f69..88fae8d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -156,6 +156,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
@@ -476,6 +477,9 @@ static inline int scsi_device_enclosure(struct scsi_device *sdev)
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
 {
+	if (sdev->no_dif)
+		return 0;
+
 	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index b4ddd3b..cc1f3e7 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -30,4 +30,5 @@
 #define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
 #define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
+#define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #endif
-- 
1.7.7.6

