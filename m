From: Vincent Minet <v.minet@criteo.com>
Subject: [PATCH] scsi: smartpqi: put controller in SIS mode at shutdown
Date: Mon, 20 Nov 2017 19:25:05 +0100
Message-ID: <20171120182505.12947-1-v.minet@criteo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx08-00287e01.pphosted.com ([62.209.51.156]:52080 "EHLO
        mx07-00287e01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751902AbdKTSqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 13:46:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: esc.storagedev@microsemi.com, Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Since commit 162d7753fce9 ("scsi: smartpqi: ensure controller is in SIS
mode at init"), the driver is able to work even if the controller is in
PQI mode at startup. This made it possible to keep using the controller
across a kexec.

But kernels built before that patch still expect the controller to be in
SIS mode at startup. They will fail when kexec'd. To handle that case,
this patch reverts the controller to SIS mode during the ->shutdown()
callback.

Signed-off-by: Vincent Minet <v.minet@criteo.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b2880c7709e6..5e898dd9ae2b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6699,7 +6699,12 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 	 * storage.
 	 */
 	rc = pqi_flush_cache(ctrl_info, SHUTDOWN);
-	pqi_reset(ctrl_info);
+
+	if (ctrl_info->pqi_mode_enabled)
+		pqi_revert_to_sis_mode(ctrl_info);
+	else
+		pqi_reset(ctrl_info);
+
 	if (rc == 0)
 		return;
 
-- 
2.15.0
