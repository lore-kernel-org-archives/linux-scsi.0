From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 4/5] hpsa: prevent sending bmic commands to externals
Date: Fri, 9 Sep 2016 16:30:36 -0500
Message-ID: <147345663633.19269.11229280423377351272.stgit@brunhilda>
References: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0064.outbound.protection.outlook.com ([104.47.40.64]:63839
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752040AbcIIVaw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 17:30:52 -0400
In-Reply-To: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@microsemi.com>

Reviewed-by: Scott Benesh <scott.benest@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6a5b7df..06f5e1c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4072,7 +4072,17 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 		struct bmic_identify_physical_device *id_phys)
 {
 	int rc;
-	struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
+	struct ext_report_lun_entry *rle;
+
+	/*
+	 * external targets don't support BMIC
+	 */
+	if (dev->external) {
+		dev->queue_depth = 7;
+		return;
+	}
+
+	rle = &rlep->LUN[rle_index];
 
 	dev->ioaccel_handle = rle->ioaccel_handle;
 	if ((rle->device_flags & 0x08) && dev->ioaccel_handle)

