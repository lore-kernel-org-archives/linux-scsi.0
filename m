From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2] hpsa: remove coalescing settings for ioaccel2
Date: Mon, 30 Jan 2017 16:05:17 -0600
Message-ID: <148581391749.10289.15802474685670424837.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:37280
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752618AbdA3WVW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 17:21:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

- Setting coalescing has a significant negative
  impact on low queue-depth performance.
- Does not help high queue-depth performance.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cbc0c5f..4323ddc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9263,13 +9263,9 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 		access = SA5_ioaccel_mode1_access;
 		writel(10, &h->cfgtable->HostWrite.CoalIntDelay);
 		writel(4, &h->cfgtable->HostWrite.CoalIntCount);
-	} else {
-		if (trans_support & CFGTBL_Trans_io_accel2) {
+	} else
+		if (trans_support & CFGTBL_Trans_io_accel2)
 			access = SA5_ioaccel_mode2_access;
-			writel(10, &h->cfgtable->HostWrite.CoalIntDelay);
-			writel(4, &h->cfgtable->HostWrite.CoalIntCount);
-		}
-	}
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
 	if (hpsa_wait_for_mode_change_ack(h)) {
 		dev_err(&h->pdev->dev,

