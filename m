From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: [PATCH 2/3] pm8001: Fix erratic calculation in update_flash
Date: Wed, 30 Jul 2014 18:44:24 +0530
Message-ID: <1406726064-5875-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:47780 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbaG3NPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 09:15:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, thenzl@redhat.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, pmchba@pmcs.com

From: Tomas Henzl <thenzl@redhat.com>

The loopcount is calculated by using some weird magic.
Use instead a boring macro

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 69aedea..7abbf28 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -585,11 +585,8 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
 		partitionSizeTmp =
 			*(u32 *)((u8 *)&image_hdr->image_length + sizeRead);
 		partitionSize = be32_to_cpu(partitionSizeTmp);
-		loopcount = (partitionSize + HEADER_LEN)/IOCTL_BUF_SIZE;
-		if (loopcount % IOCTL_BUF_SIZE)
-			loopcount++;
-		if (loopcount == 0)
-			loopcount++;
+		loopcount = DIV_ROUND_UP(partitionSize + HEADER_LEN,
+					IOCTL_BUF_SIZE);
 		for (loopNumber = 0; loopNumber < loopcount; loopNumber++) {
 			payload = (struct pm8001_ioctl_payload *)ioctlbuffer;
 			payload->length = 1024*16;
-- 
1.7.1

