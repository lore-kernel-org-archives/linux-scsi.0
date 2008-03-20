From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/5] scsi_debug: remove unnecessary condition test in devInfoReg
Date: Thu, 20 Mar 2008 11:09:17 +0900
Message-ID: <1205978959-30510-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205978959-30510-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205978959-30510-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:52754 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbYCTCKI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 22:10:08 -0400
In-Reply-To: <1205978959-30510-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

open_devip is always non NULL.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   37 ++++++++++++++++++-------------------
 1 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 161af1d..1a91063 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2059,25 +2059,24 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 			return NULL;
 		}
 	}
-        if (open_devip) {
-		open_devip->channel = sdev->channel;
-		open_devip->target = sdev->id;
-		open_devip->lun = sdev->lun;
-		open_devip->sdbg_host = sdbg_host;
-		open_devip->reset = 1;
-		open_devip->used = 1;
-		memset(open_devip->sense_buff, 0, SDEBUG_SENSE_LEN);
-		if (scsi_debug_dsense)
-			open_devip->sense_buff[0] = 0x72;
-		else {
-			open_devip->sense_buff[0] = 0x70;
-			open_devip->sense_buff[7] = 0xa;
-		}
-		if (sdev->lun == SAM2_WLUN_REPORT_LUNS)
-			open_devip->wlun = SAM2_WLUN_REPORT_LUNS & 0xff;
-		return open_devip;
-        }
-        return NULL;
+
+	open_devip->channel = sdev->channel;
+	open_devip->target = sdev->id;
+	open_devip->lun = sdev->lun;
+	open_devip->sdbg_host = sdbg_host;
+	open_devip->reset = 1;
+	open_devip->used = 1;
+	memset(open_devip->sense_buff, 0, SDEBUG_SENSE_LEN);
+	if (scsi_debug_dsense)
+		open_devip->sense_buff[0] = 0x72;
+	else {
+		open_devip->sense_buff[0] = 0x70;
+		open_devip->sense_buff[7] = 0xa;
+	}
+	if (sdev->lun == SAM2_WLUN_REPORT_LUNS)
+		open_devip->wlun = SAM2_WLUN_REPORT_LUNS & 0xff;
+
+	return open_devip;
 }
 
 static void mk_sense_buffer(struct sdebug_dev_info * devip, int key,
-- 
1.5.3.7

