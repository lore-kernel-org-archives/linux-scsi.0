From: tom.ty89@gmail.com
Subject: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Thu, 10 Mar 2016 16:16:18 +0800
Message-ID: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35147 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691AbcCJIQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 03:16:25 -0500
Received: by mail-pf0-f193.google.com with SMTP id u190so2076526pfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 00:16:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

According to its own comment, the discard granularity should
fixed to the logical block size. However, the actual code has
it hardcoded as 1 byte. Changing it to logical_block_size.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d749da7..5a5457a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -648,7 +648,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	 */
 	if (sdkp->lbprz) {
 		q->limits.discard_alignment = 0;
-		q->limits.discard_granularity = 1;
+		q->limits.discard_granularity = logical_block_size;
 	} else {
 		q->limits.discard_alignment = sdkp->unmap_alignment *
 			logical_block_size;
-- 
2.7.2

