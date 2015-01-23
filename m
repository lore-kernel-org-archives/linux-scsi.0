From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 38/48] hpsa: return failed from device reset/abort
 handlers
Date: Fri, 23 Jan 2015 16:44:24 -0600
Message-ID: <20150123224424.14919.69470.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:37100 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbAWWpS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:45:18 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Returning failed from the device reset handler will get the device
kicked offline, which is fine if the controller is locked up anyhow.

Cannot abort a command from a failed controller.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 834ac78..a02ea7f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4343,6 +4343,10 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	h = sdev_to_hba(scsicmd->device);
 	if (h == NULL) /* paranoia */
 		return FAILED;
+
+	if (lockup_detected(h))
+		return FAILED;
+
 	dev = scsicmd->device->hostdata;
 	if (!dev) {
 		dev_err(&h->pdev->dev, "hpsa_eh_device_reset_handler: "
@@ -4566,6 +4570,9 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 			"ABORT REQUEST FAILED, Controller lookup failed.\n"))
 		return FAILED;
 
+	if (lockup_detected(h))
+		return FAILED;
+
 	/* Check that controller supports some kind of task abort */
 	if (!(HPSATMF_PHYS_TASK_ABORT & h->TMFSupportFlags) &&
 		!(HPSATMF_LOG_TASK_ABORT & h->TMFSupportFlags))

