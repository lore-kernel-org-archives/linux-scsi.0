From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] fix scsi_mode_data length result
Date: Mon, 7 Jul 2003 17:28:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030707172856.A26196@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:21953 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S265024AbTGHAOT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2003 20:14:19 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi -

I have some Seagate drives that apparently return to much data when asked
for 31 bytes for a MODE SENSE cache page, resulting in buffer overruns.
Requests for 4 bytes work fine.

Changing __scsi_mode_sense to correctly set the scsi_mode_data length
per the following patch fixed the problem for me.

diff -purN -X /home/patman/dontdiff bleed-2.5/drivers/scsi/scsi_lib.c ms-bl-2.5/drivers/scsi/scsi_lib.c
--- bleed-2.5/drivers/scsi/scsi_lib.c	Wed Jul  2 18:33:55 2003
+++ ms-bl-2.5/drivers/scsi/scsi_lib.c	Mon Jul  7 17:05:05 2003
@@ -1426,14 +1426,14 @@ __scsi_mode_sense(struct scsi_request *s
 	if(scsi_status_is_good(sreq->sr_result)) {
 		data->header_length = header_length;
 		if(use_10_for_ms) {
-			data->length = buffer[0]*256 + buffer[1];
+			data->length = buffer[0]*256 + buffer[1] + 2;
 			data->medium_type = buffer[2];
 			data->device_specific = buffer[3];
 			data->longlba = buffer[4] & 0x01;
 			data->block_descriptor_length = buffer[6]*256
 				+ buffer[7];
 		} else {
-			data->length = buffer[0];
+			data->length = buffer[0] + 1;
 			data->medium_type = buffer[1];
 			data->device_specific = buffer[3];
 			data->block_descriptor_length = buffer[4];
diff -purN -X /home/patman/dontdiff bleed-2.5/include/scsi/scsi_request.h ms-bl-2.5/include/scsi/scsi_request.h
--- bleed-2.5/include/scsi/scsi_request.h	Wed Jul  2 18:33:56 2003
+++ ms-bl-2.5/include/scsi/scsi_request.h	Mon Jul  7 17:05:27 2003
@@ -56,7 +56,7 @@ extern void scsi_do_req(struct scsi_requ
 			int timeout, int retries);
 
 struct scsi_mode_data {
-	__u16	length;
+	__u32	length;
 	__u16	block_descriptor_length;
 	__u8	medium_type;
 	__u8	device_specific;

-- Patrick Mansfield
