From: wenxiong@linux.vnet.ibm.com
Subject: [ V2 PATCH 2/2] scsi: TUR path is down after adapter gets reset with multipath
Date: Mon, 03 Nov 2014 15:28:59 -0600
Message-ID: <20141103212948.304004745@linux.vnet.ibm.com>
References: <20141103212857.791977005@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58284 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754048AbaKCVd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2014 16:33:26 -0500
Content-Disposition: inline; filename=allow_restart2
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

This patch fixes an issue with multipath ipr SAS devices which require a
start unit command to be issued following an adapter reset. Without this
patch, paths get marked failed following an adapter reset and since the
error handler never gets invoked to issue the start unit, the paths are
never recovered. Returning FAILED for this case ensures the error
handler wakes up to issue the start unit.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Teste-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- a/drivers/scsi/device_handler/scsi_dh_alua.c	2014-10-29 20:50:29.000000000 -0500
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2014-11-03 14:24:39.482078993 -0600
@@ -84,6 +84,7 @@ struct alua_dh_data {
 
 static char print_alua_state(int);
 static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
+static int alua_check_sense_handler(struct scsi_device *, struct scsi_sense_hdr *);
 
 static inline struct alua_dh_data *get_alua_data(struct scsi_device *sdev)
 {
@@ -519,6 +520,23 @@ static int alua_check_sense(struct scsi_
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
+static int alua_check_sense_handler(struct scsi_device *sdev,
+			    struct scsi_sense_hdr *sense_hdr)
+{
+	switch (sense_hdr->sense_key) {
+	case NOT_READY:
+		if (sdev->allow_restart &&
+		    sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x02)
+			/*
+			 * if the device is not started, we need to wake
+			 * the error handler to start the motor
+			 */
+			return FAILED;
+		break;
+	}
+	alua_check_sense(sdev, sense_hdr);
+}
+
 /*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
@@ -827,7 +845,7 @@ static struct scsi_device_handler alua_d
 	.attach = alua_bus_attach,
 	.detach = alua_bus_detach,
 	.prep_fn = alua_prep_fn,
-	.check_sense = alua_check_sense,
+	.check_sense = alua_check_sense_handler,
 	.activate = alua_activate,
 	.set_params = alua_set_params,
 	.match = alua_match,

-- 
