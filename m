From: wenxiong@linux.vnet.ibm.com
Subject: [ V3 PATCH 2/2] scsi: TUR path is down after adapter gets reset with multipath
Date: Thu, 06 Nov 2014 15:11:23 -0600
Message-ID: <20141106211336.369139152@linux.vnet.ibm.com>
References: <20141106211121.526781033@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58326 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751325AbaKFVRQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 16:17:16 -0500
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
 drivers/scsi/device_handler/scsi_dh_alua.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- a/drivers/scsi/device_handler/scsi_dh_alua.c	2014-11-06 14:01:37.682079047 -0600
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2014-11-06 14:04:08.772079175 -0600
@@ -474,6 +474,13 @@ static int alua_check_sense(struct scsi_
 			 * LUN Not Ready -- Offline
 			 */
 			return SUCCESS;
+		if (sdev->allow_restart &&
+		    sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x02)
+			/*
+			 * if the device is not started, we need to wake
+			 * the error handler to start the motor
+			 */
+			return FAILED;
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)

-- 
