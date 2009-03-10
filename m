From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [PATCH]scsi_dh_rdac: Retry for NOT_READY check condition (0x02A102,
 0x020401, 0x020404 and  0x020407) in rdac_check_sense
Date: Tue, 10 Mar 2009 18:30:36 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C140E25CA0C@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:46123 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZCJNAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2009 09:00:46 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'sekharan@us.ibm.com'" <'sekharan@us.ibm.com'>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "'dm-devel@redhat.com'" <'dm-devel@redhat.com'>

This patch adds retry for NOT_READY check conditions(02/A1/02, 02/04/01, 02/04/04,
02/04/07) in rdac_check_sense.

Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>

---
--- linux-2.6.29-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-03-10 17:42:27.000000000 +0530
+++ linux-2.6.29-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-03-10 18:05:35.000000000 +0530
@@ -562,6 +562,30 @@ static int rdac_check_sense(struct scsi_
 			 * Just retry and wait.
 			 */
 			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0xA1  && sense_hdr->ascq == 0x02)
+			/* LUN Not Ready - Quiescense in progress
+			 * or has been achieved
+			 * Just retry.
+			 */
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
+			/* LUN Not Ready - Logical Unit Not Ready and is in
+			 * the process of becoming ready
+			 * Just retry.
+			 */
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x04)
+			/* LUN Not Ready - Format In Progress
+			 *
+			 * Just retry.
+			 */
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x04  && sense_hdr->ascq == 0x07)
+			/* LUN Not Ready - Storage controller cannot respond
+			 * immediately to a PRIN or PROUT command.
+			 * Just retry.
+			 */
+			return ADD_TO_MLQUEUE;
 		break;
 	case ILLEGAL_REQUEST:
 		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
