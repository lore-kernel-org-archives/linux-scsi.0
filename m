From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/3 V2] pm8001: Fix erratic calculation in update_flash
Date: Wed, 30 Jul 2014 16:40:51 +0200
Message-ID: <53D903F3.3040805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbaG3Ok6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 10:40:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>, James Bottomley <jbottomley@parallels.com>, Viswas G <Viswas.G@pmcs.com>, pmchba@pmcs.com

V2 - 'from' string removed (as it comes from me now)  and changed a signed-off to acked-by (Suresh is the maintainer)
Tomas

The loopcount is calculated by using some weird magic.
Use instead a boring macro

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
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
-- 1.7.1



