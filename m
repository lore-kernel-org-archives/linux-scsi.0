From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 3/3] hpsa: do not timeout reset operations
Date: Mon, 6 Mar 2017 15:24:51 -0600
Message-ID: <148883549163.14177.17863155040436147975.stgit@brunhilda>
References: <148883542370.14177.274248778005931414.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0062.outbound.protection.outlook.com ([104.47.37.62]:55665
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754358AbdCFVY4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Mar 2017 16:24:56 -0500
In-Reply-To: <148883542370.14177.274248778005931414.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

resets can take longer than DEFAULT_TIMEOUT

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a36d3a6..30164b7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2956,7 +2956,7 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 	/* fill_cmd can't fail here, no data buffer to map. */
 	(void) fill_cmd(c, reset_type, h, NULL, 0, 0,
 			scsi3addr, TYPE_MSG);
-	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, DEFAULT_TIMEOUT);
+	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
 	if (rc) {
 		dev_warn(&h->pdev->dev, "Failed to send reset command\n");
 		goto out;
