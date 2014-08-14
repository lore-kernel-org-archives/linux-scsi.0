From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH/RFC V2 07/16] scsi: support well known logical units
Date: Thu, 14 Aug 2014 16:30:58 +0300
Message-ID: <1408023067-26103-8-git-send-email-draviv@codeaurora.org>
References: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:35393 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaHNNbj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2014 09:31:39 -0400
In-Reply-To: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Subhash Jadavani <subhashj@codeaurora.org>

REPORT LUNS command has "SELECT REPORT" field which controls what type of
logical units to be reported by device server. According to UFS device
standard, if this field is set to 0, REPORT LUNS would report only report
standard logical units. If it's set to 1 then it would report only well
known logical unit and if it's set to 2 then device would report both
standard and well known logical units.
Some well-known logical units might not have scsi upper-layer drivers. In
such cases, the runtime PM reference count increased during device
enumeration will not be decreased, causing the parent device (host) to
always be on even during idle.

This change allows the SCSI LLD (Low Level Driver) to choose which type
of logical units should be detected.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4a6e4ba..5a0e164 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -802,6 +802,14 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	} else {
 		sdev->type = (inq_result[0] & 0x1f);
 		sdev->removable = (inq_result[1] & 0x80) >> 7;
+
+		/*
+		 * some devices may respond with wrong type for
+		 * well-known logical units. Force well-known type
+		 * to enumerate them correctly.
+		 */
+		if (scsi_is_wlun(sdev->lun) && (sdev->type != TYPE_WLUN))
+			sdev->type = TYPE_WLUN;
 	}
 
 	switch (sdev->type) {
@@ -817,6 +825,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	case TYPE_COMM:
 	case TYPE_RAID:
 	case TYPE_OSD:
+	case TYPE_WLUN:
 		sdev->writeable = 1;
 		break;
 	case TYPE_ROM:
@@ -1412,6 +1421,13 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	 */
 	memset(&scsi_cmd[1], 0, 5);
 
+	if (shost->report_wlus)
+		/*
+		 * Set "SELECT REPORT" field to 0x2 which will make device to
+		 * report well known logical units along with standard LUs.
+		 */
+		scsi_cmd[2] = 0x2;
+
 	/*
 	 * bytes 6 - 9: length of the command.
 	 */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5f36788..ba9d0f0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1060,6 +1060,13 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+	/*
+	 * put runtime pm reference for well-known logical units,
+	 * drivers are expected to _get_* again during probe.
+	 */
+	if (scsi_is_wlun(sdev->lun))
+		scsi_autopm_put_device(sdev);
+
 	return error;
 }
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 91e2e42..6a9b102 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -332,6 +332,7 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RBC	    0x0e
 #define TYPE_OSD            0x11
+#define TYPE_WLUN           0x1e    /* well-known logical unit */
 #define TYPE_NO_LUN         0x7f
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b2bc519..05664c4 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -675,6 +675,11 @@ struct Scsi_Host {
 	unsigned no_write_same:1;
 
 	/*
+	 * Set "SELECT REPORT" field to allow detection of well known logical
+	 * units along with standard LUs.
+	 */
+	unsigned report_wlus:1;
+	/*
 	 * Optional work queue to be utilized by the transport
 	 */
 	char work_q_name[20];
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

