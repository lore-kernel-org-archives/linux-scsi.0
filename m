From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi_dh_alua: fix stpg sense handling
Date: Tue,  5 Mar 2013 22:40:24 -0600
Message-ID: <1362544824-2350-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47016 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab3CFEke (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Mar 2013 23:40:34 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id r264eUE2021986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 5 Mar 2013 22:40:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

For the stpg_endio path we are not evaluating the sense. The bug
is that

1. The error value is set to -EIO when there is sense, so we hit the first
error check and always return SCSI_DH_IO.

2. h->senselen is set to zero in submit_stpg. It is not later set to
req->sense_len like in the synchrounous exection paths, so we must
check the req->sense_len field.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6f4d8e6..6648ffb 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -232,13 +232,13 @@ static void stpg_endio(struct request *req, int error)
 	struct scsi_sense_hdr sense_hdr;
 	unsigned err = SCSI_DH_OK;
 
-	if (error || host_byte(req->errors) != DID_OK ||
-			msg_byte(req->errors) != COMMAND_COMPLETE) {
+	if (host_byte(req->errors) != DID_OK ||
+	    msg_byte(req->errors) != COMMAND_COMPLETE) {
 		err = SCSI_DH_IO;
 		goto done;
 	}
 
-	if (h->senselen > 0) {
+	if (req->sense_len > 0) {
 		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					   &sense_hdr);
 		if (!err) {
@@ -255,7 +255,9 @@ static void stpg_endio(struct request *req, int error)
 			    ALUA_DH_NAME, sense_hdr.sense_key,
 			    sense_hdr.asc, sense_hdr.ascq);
 		err = SCSI_DH_IO;
-	}
+	} else if (error)
+		err = SCSI_DH_IO;
+
 	if (err == SCSI_DH_OK) {
 		h->state = TPGS_STATE_OPTIMIZED;
 		sdev_printk(KERN_INFO, h->sdev,
-- 
1.7.1

