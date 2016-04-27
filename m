From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 4/7] hpsa: correct ioaccel state change operation
Date: Wed, 27 Apr 2016 17:13:59 -0500
Message-ID: <146179523934.31195.13118329992038553938.stgit@brunhilda>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0077.outbound.protection.outlook.com ([157.56.111.77]:9872
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752365AbcD0W2r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 18:28:47 -0400
In-Reply-To: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

offload_to_be_enabled also needs to be set to 0 during a state
change.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fa4ba34..e7406ef 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8283,8 +8283,10 @@ static void hpsa_ack_ctlr_events(struct ctlr_info *h)
 			event_type = "configuration change";
 		/* Stop sending new RAID offload reqs via the IO accelerator */
 		scsi_block_requests(h->scsi_host);
-		for (i = 0; i < h->ndevices; i++)
+		for (i = 0; i < h->ndevices; i++) {
 			h->dev[i]->offload_enabled = 0;
+			h->dev[i]->offload_to_be_enabled = 0;
+		}
 		hpsa_drain_accel_commands(h);
 		/* Set 'accelerator path config change' bit */
 		dev_warn(&h->pdev->dev,

