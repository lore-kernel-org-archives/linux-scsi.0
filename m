From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 2/2] scsi: TUR path is down after adapter gets reset in multipath configuration(scsi_dh_alus.c)
Date: Mon, 27 Oct 2014 13:01:49 -0500
Message-ID: <20141027180347.045407862@linux.vnet.ibm.com>
References: <20141027180147.030955587@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58163 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752133AbaJ0SHZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2014 14:07:25 -0400
Content-Disposition: inline; filename=allow_restart2
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

This patch also fixes the 02/04/02 K/C/Q check in alua_check_sense
handler.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Teste-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- a/drivers/scsi/device_handler/scsi_dh_alua.c	2014-10-23 13:00:45.000000000 -0500
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2014-10-23 13:04:16.152079004 -0500
@@ -474,6 +474,13 @@ static int alua_check_sense(struct scsi_
 			 * LUN Not Ready -- Offline
 			 */
 			return SUCCESS;
+		if (sdev->allow_restart &&
+		    (sense_hdr->asc == 0x04) && (sense_hdr->ascq == 0x02))
+			/*
+			 * if the device is not started, we need to wake
+			 * the error handler to start the motor
+			 */
+			return FAILED;
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)

-- 
