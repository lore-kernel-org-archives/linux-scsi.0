From: Heloise <os@iscas.ac.cn>
Subject: [PATCH] drivers/scsi:fix memory leak
Date: Sun, 15 May 2016 23:31:46 -0700
Message-ID: <1463380306-5939-1-git-send-email-os@iscas.ac.cn>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:52703 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbcEPGqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2016 02:46:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, os@iscas.ac.cn

In function ahc_handle_en_lun, variable lstate has not been
freed before return, which can cause memory leak, fix it.

Signed-off-by: Heloise <os@iscas.ac.cn>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 64ab9ea..e8fbdb5 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -7684,6 +7684,7 @@ ahc_handle_en_lun(struct ahc_softc *ahc, struct cam_sim *sim, union ccb *ccb)
 
 		if (ccb->ccb_h.status != CAM_REQ_CMP) {
 			ahc_unlock(ahc, &s);
+			kfree(lstate);
 			return;
 		}
 
-- 
2.1.0


