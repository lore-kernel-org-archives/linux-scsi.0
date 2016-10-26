From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 3/4] hpsa: remove coalescing settings for ioaccel2
Date: Wed, 26 Oct 2016 17:21:58 -0500
Message-ID: <147752051865.813.13621083415298379753.stgit@brunhilda>
References: <147752001094.813.10247306839794156732.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0067.outbound.protection.outlook.com ([104.47.40.67]:38080
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S941073AbcJZW1v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 18:27:51 -0400
In-Reply-To: <147752001094.813.10247306839794156732.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

- Setting coalescing has a significant negative
  impact on low queue-depth performance.
- Does not help high queue-depth performance.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9fb739c..810c300 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9277,13 +9277,9 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
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

