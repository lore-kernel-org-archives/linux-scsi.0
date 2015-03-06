From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 20/41] hpsa: add more ioaccel2 error handling,
 including underrun statuses.
Date: Fri, 06 Mar 2015 17:47:33 -0600
Message-ID: <20150306234733.29973.81818.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:50518 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbbCFXtD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:49:03 -0500
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 6C4B566E47
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2015 23:49:03 +0000 (UTC)
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Joe Handzik <joseph.t.handzik@hp.com>

improve ioaccel2 error handling, including better handling of
underrun statuses

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |   33 ++++++++++++++++++++++++++++-----
 drivers/scsi/hpsa_cmd.h |    6 ++++++
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 70f1b04..aebd9d1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1901,6 +1901,7 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 {
 	int data_len;
 	int retry = 0;
+	u32 ioaccel2_resid = 0;
 
 	switch (c2->error_data.serv_response) {
 	case IOACCEL2_SERV_RESPONSE_COMPLETE:
@@ -1959,11 +1960,33 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 		}
 		break;
 	case IOACCEL2_SERV_RESPONSE_FAILURE:
-		/* don't expect to get here. */
-		dev_warn(&h->pdev->dev,
-			"unexpected delivery or target failure, status = 0x%02x\n",
-			c2->error_data.status);
-		retry = 1;
+		switch (c2->error_data.status) {
+		case IOACCEL2_STATUS_SR_IO_ERROR:
+		case IOACCEL2_STATUS_SR_IO_ABORTED:
+		case IOACCEL2_STATUS_SR_OVERRUN:
+			retry = 1;
+			break;
+		case IOACCEL2_STATUS_SR_UNDERRUN:
+			cmd->result = (DID_OK << 16);		/* host byte */
+			cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
+			ioaccel2_resid = c2->error_data.resid_cnt[3] << 24;
+			ioaccel2_resid |= c2->error_data.resid_cnt[2] << 16;
+			ioaccel2_resid |= c2->error_data.resid_cnt[1] << 8;
+			ioaccel2_resid |= c2->error_data.resid_cnt[0];
+			scsi_set_resid(cmd, ioaccel2_resid);
+			break;
+		case IOACCEL2_STATUS_SR_NO_PATH_TO_DEVICE:
+		case IOACCEL2_STATUS_SR_INVALID_DEVICE:
+		case IOACCEL2_STATUS_SR_IOACCEL_DISABLED:
+			/* We will get an event from ctlr to trigger rescan */
+			retry = 1;
+			break;
+		default:
+			retry = 1;
+			dev_warn(&h->pdev->dev,
+				"unexpected delivery or target failure, status = 0x%02x\n",
+				c2->error_data.status);
+		}
 		break;
 	case IOACCEL2_SERV_RESPONSE_TMF_COMPLETE:
 		break;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 0efb6f2b..cecb62b 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -532,6 +532,12 @@ struct io_accel2_scsi_response {
 #define IOACCEL2_STATUS_SR_TASK_COMP_SET_FULL	0x28
 #define IOACCEL2_STATUS_SR_TASK_COMP_ABORTED	0x40
 #define IOACCEL2_STATUS_SR_IOACCEL_DISABLED	0x0E
+#define IOACCEL2_STATUS_SR_IO_ERROR		0x01
+#define IOACCEL2_STATUS_SR_IO_ABORTED		0x02
+#define IOACCEL2_STATUS_SR_NO_PATH_TO_DEVICE	0x03
+#define IOACCEL2_STATUS_SR_INVALID_DEVICE	0x04
+#define IOACCEL2_STATUS_SR_UNDERRUN		0x51
+#define IOACCEL2_STATUS_SR_OVERRUN		0x75
 	u8 data_present;		/* low 2 bits */
 #define IOACCEL2_NO_DATAPRESENT		0x000
 #define IOACCEL2_RESPONSE_DATAPRESENT	0x001

