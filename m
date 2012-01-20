From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: GET LBA STATUS response length correction
Date: Thu, 19 Jan 2012 19:30:00 -0500
Message-ID: <4F18B588.3090106@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030204090907020803060902"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51905 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab2ATAaI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 19:30:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

This is a multi-part message in MIME format.
--------------030204090907020803060902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The SCSI GET LBA STATUS command was introduced in SBC-3 revision
20 in September 2009. At that time the Parameter Data Length
field in the response had an associated byte offset of 8.

Then in SBC-3 revision 25 (October 2010) that byte offset was
changed to 4. The sg_get_lba_status utility in sg3_utils version
1.33 (released earlier today) has been changed to calculate
the newer response length. However the implementation of
GET LBA STATUS command in the scsi_debug driver still uses the
original byte offset.

Changelog:
   - modify the Parameter Data Length field value in the GET LBA
     STATUS command response to comply with the change in SBC-3
     revision 25

Doug Gilbert

--------------030204090907020803060902
Content-Type: text/x-patch;
 name="sdebug32_getlba.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug32_getlba.patch"

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6888b2c..d2fd0ef 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2220,7 +2220,7 @@ static int resp_get_lba_status(struct scsi_cmnd * scmd,
 	mapped = map_state(lba, &num);
 
 	memset(arr, 0, SDEBUG_GET_LBA_STATUS_LEN);
-	put_unaligned_be32(16, &arr[0]);	/* Parameter Data Length */
+	put_unaligned_be32(20, &arr[0]);	/* Parameter Data Length */
 	put_unaligned_be64(lba, &arr[8]);	/* LBA */
 	put_unaligned_be32(num, &arr[16]);	/* Number of blocks */
 	arr[20] = !mapped;			/* mapped = 0, unmapped = 1 */

--------------030204090907020803060902--
