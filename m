From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V3 3/3] hpsa: do not timeout reset operations
Date: Fri, 10 Mar 2017 14:35:23 -0600
Message-ID: <148917812348.17050.13860231271785865369.stgit@brunhilda>
References: <148917802486.17050.17178463722401202189.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0079.outbound.protection.outlook.com ([104.47.36.79]:7616
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933056AbdCJUfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Mar 2017 15:35:47 -0500
In-Reply-To: <148917802486.17050.17178463722401202189.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

resets can take longer than DEFAULT_TIMEOUT

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com> review
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0a8ac68..0d0be77 100644
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
