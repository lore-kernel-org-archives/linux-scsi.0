From: tom.ty89@gmail.com
Subject: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Wed,  9 Mar 2016 11:26:16 +0800
Message-ID: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34264 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbcCID0a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2016 22:26:30 -0500
Received: by mail-pf0-f193.google.com with SMTP id 184so2516041pff.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Mar 2016 19:26:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Some devices have details of their support on unmapping on the
Block Limits and/or Logical Block Provisioning VPDs while they
do not set the LBPME bit to 1. Though this is required by the
SCSI standards, the VPDs are giving even more concrete details
about the support, so they should be used even when the bit
is set to 0.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d749da7..a0d7c73 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2670,9 +2670,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
 
-		if (!sdkp->lbpme)
-			goto out;
-
 		lba_count = get_unaligned_be32(&buffer[20]);
 		desc_count = get_unaligned_be32(&buffer[24]);
 
@@ -2747,9 +2744,6 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 	unsigned char *buffer;
 	const int vpd_len = 8;
 
-	if (sdkp->lbpme == 0)
-		return;
-
 	buffer = kmalloc(vpd_len, GFP_KERNEL);
 
 	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb2, buffer, vpd_len))
-- 
2.7.2

