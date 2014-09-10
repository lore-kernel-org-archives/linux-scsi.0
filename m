From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V3 01/16] scsi: support well known logical units
Date: Wed, 10 Sep 2014 14:54:08 +0300
Message-ID: <1410350063-23267-2-git-send-email-draviv@codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

REPORT LUNS command has "SELECT REPORT" field which controls what type of
logical units to be reported by device server. According to UFS device
standard, if this field is set to 0, REPORT LUNS would report only report
standard logical units. If it's set to 1 then it would report only well
known logical unit and if it's set to 2 then device would report both
standard and well known logical units.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 56675db..d7f0df8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -805,6 +805,14 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	} else {
 		sdev->type = (inq_result[0] & 0x1f);
 		sdev->removable = (inq_result[1] & 0x80) >> 7;
+
+		/*
+		 * some devices may respond with wrong type for
+		 * well-known logical units. Force well-known type
+		 * to enumerate them correctly.
+		 */
+		if (scsi_is_wlun(sdev->lun))
+			sdev->type = TYPE_WLUN;
 	}
 
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
@@ -1400,6 +1408,12 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	memset(&scsi_cmd[1], 0, 5);
 
 	/*
+	 * Set "SELECT REPORT" field to 0x2 which will make device to
+	 * report well known logical units along with standard LUs.
+	 */
+	scsi_cmd[2] = 0x2;
+
+	/*
 	 * bytes 6 - 9: length of the command.
 	 */
 	scsi_cmd[6] = (unsigned char) (length >> 24) & 0xff;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 261e708..d17178e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -333,6 +333,7 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_RBC	    0x0e
 #define TYPE_OSD            0x11
 #define TYPE_ZBC            0x14
+#define TYPE_WLUN           0x1e    /* well-known logical unit */
 #define TYPE_NO_LUN         0x7f
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
