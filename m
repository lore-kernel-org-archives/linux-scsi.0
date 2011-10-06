From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] scsi_dh_alua: Add one more check-condition for alua handler
Date: Thu, 6 Oct 2011 13:22:07 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD91000D356@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:23568 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251Ab1JFRWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2011 13:22:11 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>

This patch adds one more check-condition  for scsi_dh_alua handler. Without this,
the handler attach fails sometimes during the discovery. I have noticed this with
NetApp E-Series storage with alua mode. Also removed some unnecessary brackets {}
for consistency.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---

--- linux-3.1-rc4/drivers/scsi/device_handler/scsi_dh_alua.c.orig	2011-10-05 16:52:41.000000000 -0500
+++ linux-3.1-rc4/drivers/scsi/device_handler/scsi_dh_alua.c	2011-10-05 17:00:33.000000000 -0500
@@ -508,27 +508,28 @@ static int alua_check_sense(struct scsi_
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
+		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
 			/*
 			 * ALUA state changed
 			 */
 			return ADD_TO_MLQUEUE;
-		}
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
+		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07)
 			/*
 			 * Implicit ALUA state transition failed
 			 */
 			return ADD_TO_MLQUEUE;
-		}
-		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e) {
+		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
+			/*
+			 * Inquiry data has changed
+			 */
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
 			/*
 			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
 			 * when switching controllers on targets like
 			 * Intel Multi-Flex. We can just retry.
 			 */
 			return ADD_TO_MLQUEUE;
-		}
-
 		break;
 	}
 


