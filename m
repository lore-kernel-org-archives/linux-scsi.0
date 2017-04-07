From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 02/12] hpsa: do not get enclosure info for external devices
Date: Fri, 7 Apr 2017 15:05:56 -0500
Message-ID: <149159555625.15658.11807535324567306342.stgit@brunhilda>
References: <149159483812.15658.615814291766210537.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0045.outbound.protection.outlook.com ([104.47.41.45]:50589
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755935AbdDGUGE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 16:06:04 -0400
In-Reply-To: <149159483812.15658.615814291766210537.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

external shelves do not support BMICs.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 73daace..8e22aed 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3353,6 +3353,11 @@ static void hpsa_get_enclosure_info(struct ctlr_info *h,
 
 	bmic_device_index = GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]);
 
+	if (encl_dev->target == -1 || encl_dev->lun == -1) {
+		rc = IO_OK;
+		goto out;
+	}
+
 	if (bmic_device_index == 0xFF00 || MASKED_DEVICE(&rle->lunid[0])) {
 		rc = IO_OK;
 		goto out;
