From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 06/12] hpsa: correct resets on retried commands
Date: Fri, 7 Apr 2017 15:06:21 -0500
Message-ID: <149159558142.15658.17018729491369229360.stgit@brunhilda>
References: <149159483812.15658.615814291766210537.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0048.outbound.protection.outlook.com ([104.47.41.48]:26208
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932199AbdDGUG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 16:06:28 -0400
In-Reply-To: <149159483812.15658.615814291766210537.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

 - call scsi_done when the command completes.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 53a4f34..a2852da 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5465,7 +5465,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		return hpsa_cmd_free_and_done(c->h, c, cmd);
 	}
 	if (c->reset_pending)
-		return hpsa_cmd_resolve_and_free(c->h, c);
+		return hpsa_cmd_free_and_done(c->h, c, cmd);
 	if (c->abort_pending)
 		return hpsa_cmd_abort_and_free(c->h, c, cmd);
 	if (c->cmd_type == CMD_IOACCEL2) {
