From: akpm@linux-foundation.org
Subject: [patch 18/18] drivers/scsi/device_handler/scsi_dh_emc.c: suppress warning
Date: Wed, 20 Aug 2008 16:55:36 -0700
Message-ID: <200808202355.m7KNtbXM006237@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756378AbYHUAED (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2008 20:04:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, hare@suse.de, schwidefsky@de.ibm.com

From: Andrew Morton <akpm@linux-foundation.org>

s390:

drivers/scsi/device_handler/scsi_dh_emc.c: In function 'parse_sp_info_reply':
drivers/scsi/device_handler/scsi_dh_emc.c:179: warning: comparison is always false due to limited range of data type

because chars are unsigned, I assume.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/device_handler/scsi_dh_emc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/device_handler/scsi_dh_emc.c~drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning drivers/scsi/device_handler/scsi_dh_emc.c
--- a/drivers/scsi/device_handler/scsi_dh_emc.c~drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning
+++ a/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -176,7 +176,7 @@ static int parse_sp_info_reply(struct sc
 		err = SCSI_DH_DEV_TEMP_BUSY;
 		goto out;
 	}
-	if (csdev->buffer[4] < 0 || csdev->buffer[4] > 2) {
+	if (csdev->buffer[4] & ~3) {
 		/* Invalid buffer format */
 		sdev_printk(KERN_NOTICE, sdev,
 			    "%s: invalid VPD page 0xC0 format\n",
_
