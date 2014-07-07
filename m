From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/4] scsi: pm8001: fix update_flash
Date: Mon,  7 Jul 2014 17:19:59 +0200
Message-ID: <1404746401-25229-2-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbaGGPUZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 11:20:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, Tomas Henzl <thenzl@redhat.com>

The driver checks the return valu, but after he tries to wait_for_completion
which might never happen.
Also the ioctlbuffer is freed at the end of the function,
so the first removal is not needed.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 211ffd6..e9753bd 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -617,11 +617,11 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
 
 		pm8001_ha->nvmd_completion = &completion;
 		ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha, payload);
+		if (ret)
+			break;
 		wait_for_completion(&completion);
-		if (ret || (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS)) {
+		if (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS) {
 			ret = fwControl->retcode;
-			kfree(ioctlbuffer);
-			ioctlbuffer = NULL;
 			break;
 		}
 	}
-- 
1.8.3.1

