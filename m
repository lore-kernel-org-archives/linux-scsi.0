From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/36] scsi_dh_alua: use standard logging functions
Date: Tue, 29 Sep 2015 12:47:09 +0200
Message-ID: <1443523658-87622-8-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934661AbbI2Kry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:54 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Use standard logging functions instead of hand-crafted ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5334bba..018faf0 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
 
@@ -194,19 +195,14 @@ static void stpg_endio(struct request *req, int error)
 
 	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 				 &sense_hdr)) {
-		if (!err) {
-			err = SCSI_DH_IO;
-			goto done;
-		}
 		err = alua_check_sense(h->sdev, &sense_hdr);
 		if (err == ADD_TO_MLQUEUE) {
 			err = SCSI_DH_RETRY;
 			goto done;
 		}
-		sdev_printk(KERN_INFO, h->sdev,
-			    "%s: stpg sense code: %02x/%02x/%02x\n",
-			    ALUA_DH_NAME, sense_hdr.sense_key,
-			    sense_hdr.asc, sense_hdr.ascq);
+		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
+			    ALUA_DH_NAME);
+		scsi_print_sense_hdr(h->sdev, ALUA_DH_NAME, &sense_hdr);
 		err = SCSI_DH_IO;
 	} else if (error)
 		err = SCSI_DH_IO;
@@ -526,13 +522,16 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		}
 
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
+		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
+			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
+				    ALUA_DH_NAME);
+			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
 			goto retry;
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg sense code %02x/%02x/%02x\n",
-			    ALUA_DH_NAME, sense_hdr.sense_key,
-			    sense_hdr.asc, sense_hdr.ascq);
-		err = SCSI_DH_IO;
+		}
+		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
+			    ALUA_DH_NAME);
+		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
+		return SCSI_DH_IO;
 	}
 	if (err != SCSI_DH_OK)
 		return err;
-- 
1.8.5.6

