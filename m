From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V4 02/12] hpsa: do not get enclosure info for external
 devices
Date: Thu, 4 May 2017 17:50:50 -0500
Message-ID: <149393825045.19382.1499323455847186656.stgit@brunhilda>
References: <149393820493.19382.11709906672864416473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0079.outbound.protection.outlook.com ([104.47.36.79]:22150
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752666AbdEDWvB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 18:51:01 -0400
In-Reply-To: <149393820493.19382.11709906672864416473.stgit@brunhilda>
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
