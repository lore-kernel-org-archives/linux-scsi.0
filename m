From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [PATCH]scsi_dh_rdac: Retry mode select for NO_SENSE,
 ABORTED_COMMAND, UNIT_ATTENTION, NOT_READY(02/04/01)
Date: Mon, 2 Mar 2009 11:26:36 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C140E25C334@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:49525 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZCBF4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 00:56:52 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>

This patch is to add retry for mode select if mode select command is returned with sense key NO_SENSE, 
ABORTED_COMMAND, UNIT_ATTENTION or NOT_READY(02/04/01). This patch reorganise the sense from 
if-else to switch-case format in scsi_dh_rdac.c for better maintainability.

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
---

--- linux-2.6.29-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-02-24 12:08:43.000000000 +0530
+++ linux-2.6.29-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-02-28 18:18:41.000000000 +0530
@@ -449,28 +449,40 @@ static int mode_select_handle_sense(stru
 				    unsigned char *sensebuf)
 {
 	struct scsi_sense_hdr sense_hdr;
-	int sense, err = SCSI_DH_IO, ret;
+	int err = SCSI_DH_IO, ret;
 
 	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 	if (!ret)
 		goto done;
 
 	err = SCSI_DH_OK;
-	sense = (sense_hdr.sense_key << 16) | (sense_hdr.asc << 8) |
-			sense_hdr.ascq;
-	/* If it is retryable failure, submit the c9 inquiry again */
-	if (sense == 0x59136 || sense == 0x68b02 || sense == 0xb8b02 ||
-			    sense == 0x62900) {
-		/* 0x59136    - Command lock contention
-		 * 0x[6b]8b02 - Quiesense in progress or achieved
-		 * 0x62900    - Power On, Reset, or Bus Device Reset
-		 */
+
+	switch (sense_hdr.sense_key) {
+	case NO_SENSE:
+	case ABORTED_COMMAND:
+	case UNIT_ATTENTION:
+		err = SCSI_DH_RETRY;
+		break;
+	case NOT_READY:
+		if (sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x01)
+			/* LUN Not Ready and is in the Process
+			 * of becoming ready
+			 */
+		err = SCSI_DH_RETRY;
+		break;
+	case ILLEGAL_REQUEST:
+		if (sense_hdr.asc == 0x91 && sense_hdr.ascq == 0x36)
+			/*
+			 * Command Lock contention
+			 */
 		err = SCSI_DH_RETRY;
+		break;
+	default:
+		sdev_printk(KERN_INFO, sdev,
+			"MODE_SELECT failed with sense %02x/%02x/%02x.\n",
+			sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
 	}
 
-	if (sense)
-		sdev_printk(KERN_INFO, sdev,
-			"MODE_SELECT failed with sense 0x%x.\n", sense);
 done:
 	return err;
 }

