From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: pm8001: pm8001_hwi.c:  Fix to remove null pointer checks that could never happen
Date: Fri, 30 May 2014 01:10:24 +0200
Message-ID: <1401405024-11221-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60248 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaE2XJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 19:09:29 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so169227wiw.4
        for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 16:09:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xjtuwjp@gmail.com, lindar_liu@usish.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Removal of null pointer checks that could never happen

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index a97be01..721d059 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4398,7 +4398,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 
 	/* Check for read log for failed drive and return */
 	if (sata_cmd.sata_fis.command == 0x2f) {
-		if (pm8001_ha_dev && ((pm8001_ha_dev->id & NCQ_READ_LOG_FLAG) ||
+		if (((pm8001_ha_dev->id & NCQ_READ_LOG_FLAG) ||
 			(pm8001_ha_dev->id & NCQ_ABORT_ALL_FLAG) ||
 			(pm8001_ha_dev->id & NCQ_2ND_RLE_FLAG))) {
 			struct task_status_struct *ts;
-- 
1.7.10.4

