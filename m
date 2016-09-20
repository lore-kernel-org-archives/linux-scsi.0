From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH] hpsa: correct call to hpsa_do_reset
Date: Tue, 20 Sep 2016 15:42:30 -0500
Message-ID: <147440415020.3922.8978668557368877094.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0080.outbound.protection.outlook.com ([104.47.32.80]:55264
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751729AbcITUmp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Sep 2016 16:42:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

calling fill_cmd() using a MACRO definition not handled in
switch statement causes BUG() to be called.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 drivers/scsi/hpsa.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 030d002..94be51c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5935,7 +5935,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 			"Reset as abort: Resetting physical device at scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 			psa[0], psa[1], psa[2], psa[3],
 			psa[4], psa[5], psa[6], psa[7]);
-	rc = hpsa_do_reset(h, dev, psa, HPSA_RESET_TYPE_TARGET, reply_queue);
+	rc = hpsa_do_reset(h, dev, psa, HPSA_PHYS_TARGET_RESET, reply_queue);
 	if (rc != 0) {
 		dev_warn(&h->pdev->dev,
 			"Reset as abort: Failed on physical device at scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index a1487e6..82cdfad 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -312,7 +312,6 @@ struct offline_device_entry {
 #define HPSA_DEVICE_RESET_MSG 1
 #define HPSA_RESET_TYPE_CONTROLLER 0x00
 #define HPSA_RESET_TYPE_BUS 0x01
-#define HPSA_RESET_TYPE_TARGET 0x03
 #define HPSA_RESET_TYPE_LUN 0x04
 #define HPSA_PHYS_TARGET_RESET 0x99 /* not defined by cciss spec */
 #define HPSA_MSG_SEND_RETRY_LIMIT 10

