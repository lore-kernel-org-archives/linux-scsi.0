From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] scsi: Remove unnecessary condition in sd_read_block_limits()
Date: Wed, 13 Sep 2017 16:29:46 +0200
Message-ID: <1505312986-14777-1-git-send-email-lczerner@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbdIMO3y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 10:29:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD6D65F7A9
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2017 14:29:53 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>

After series of changes around WRITE_SAME and UNMAP setup we ended up
with leftover unnecessary condition. Remove it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 drivers/scsi/sd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 11c1738..fb9f8b5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2915,8 +2915,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 				sd_config_discard(sdkp, SD_LBP_WS16);
 			else if (sdkp->lbpws10)
 				sd_config_discard(sdkp, SD_LBP_WS10);
-			else if (sdkp->lbpu && sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
 			else
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 		}
-- 
2.7.5
