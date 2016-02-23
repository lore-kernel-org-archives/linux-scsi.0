From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 4/7] hpsa: correct abort tmf for hba devices
Date: Tue, 23 Feb 2016 15:16:28 -0600
Message-ID: <20160223211628.5968.7606.stgit@brunhilda>
References: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:50238 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbcBWVQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 16:16:30 -0500
In-Reply-To: <20160223210957.5968.6998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Aborts were not being sent down to HBA devices

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Reviewed-by: Justin Lindley <justin.lindley@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 671ad57..589b44e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5846,7 +5846,7 @@ static int hpsa_send_abort_ioaccel2(struct ctlr_info *h,
 }
 
 static int hpsa_send_abort_both_ways(struct ctlr_info *h,
-	unsigned char *scsi3addr, struct CommandList *abort, int reply_queue)
+	struct hpsa_scsi_dev_t *dev, struct CommandList *abort, int reply_queue)
 {
 	/*
 	 * ioccelerator mode 2 commands should be aborted via the
@@ -5855,14 +5855,16 @@ static int hpsa_send_abort_both_ways(struct ctlr_info *h,
 	 * Change abort to physical device reset when abort TMF is unsupported.
 	 */
 	if (abort->cmd_type == CMD_IOACCEL2) {
-		if (HPSATMF_IOACCEL_ENABLED & h->TMFSupportFlags)
+		if ((HPSATMF_IOACCEL_ENABLED & h->TMFSupportFlags) ||
+			dev->physical_device)
 			return hpsa_send_abort_ioaccel2(h, abort,
 						reply_queue);
 		else
-			return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr,
+			return hpsa_send_reset_as_abort_ioaccel2(h,
+							dev->scsi3addr,
 							abort, reply_queue);
 	}
-	return hpsa_send_abort(h, scsi3addr, abort, reply_queue);
+	return hpsa_send_abort(h, dev->scsi3addr, abort, reply_queue);
 }
 
 /* Find out which reply queue a command was meant to return on */
@@ -6000,7 +6002,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		cmd_free(h, abort);
 		return FAILED;
 	}
-	rc = hpsa_send_abort_both_ways(h, dev->scsi3addr, abort, reply_queue);
+	rc = hpsa_send_abort_both_ways(h, dev, abort, reply_queue);
 	atomic_inc(&h->abort_cmds_available);
 	wake_up_all(&h->abort_cmd_wait_queue);
 	if (rc != 0) {

