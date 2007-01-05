From: Jes Sorensen <jes@sgi.com>
Subject: [patch] qla1280 set residual correctly
Date: 05 Jan 2007 12:05:37 -0500
Message-ID: <yq0hcv5s8ta.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:47989 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422635AbXAERX4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jan 2007 12:23:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>, Michael Reed <mdr@sgi.com>

Hi,

Jeremy caught a bug in the qla1280 driver where it didn't set the
residual value correctly.

Please apply,
Jes

Set residual correctly in qla1280 driver.

Signed-off-by: Jeremy Higdon <jeremy@sgi.com>
Signed-off-by: Jes Sorensen <jes@sgi.com>

---
 drivers/scsi/qla1280.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c
+++ linux-2.6/drivers/scsi/qla1280.c
@@ -1341,7 +1341,7 @@ qla1280_return_status(struct response * 
 	int host_status = DID_ERROR;
 	uint16_t comp_status = le16_to_cpu(sts->comp_status);
 	uint16_t state_flags = le16_to_cpu(sts->state_flags);
-	uint16_t residual_length = le32_to_cpu(sts->residual_length);
+	uint32_t residual_length = le32_to_cpu(sts->residual_length);
 	uint16_t scsi_status = le16_to_cpu(sts->scsi_status);
 #if DEBUG_QLA1280_INTR
 	static char *reason[] = {
@@ -1413,8 +1413,10 @@ qla1280_return_status(struct response * 
 			       "scsi: Underflow detected - retrying "
 			       "command.\n");
 			host_status = DID_ERROR;
-		} else
+		} else {
+			cp->resid = residual_length;
 			host_status = DID_OK;
+		}
 		break;
 
 	default:
