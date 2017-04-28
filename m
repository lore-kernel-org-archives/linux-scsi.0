From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 03/12] hpsa: update reset handler
Date: Fri, 28 Apr 2017 13:20:04 -0500
Message-ID: <149340360408.4102.12061579365201280003.stgit@brunhilda>
References: <149340349509.4102.15752249884898695693.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0070.outbound.protection.outlook.com ([104.47.37.70]:48608
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1426521AbdD1SUU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 14:20:20 -0400
In-Reply-To: <149340349509.4102.15752249884898695693.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

Use the return from TUR as a check for the
device state.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.tell@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8e22aed..9fb30c4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3090,7 +3090,7 @@ static int hpsa_do_reset(struct ctlr_info *h, struct hpsa_scsi_dev_t *dev,
 	if (unlikely(rc))
 		atomic_set(&dev->reset_cmds_out, 0);
 	else
-		wait_for_device_to_become_ready(h, scsi3addr, 0);
+		rc = wait_for_device_to_become_ready(h, scsi3addr, 0);
 
 	mutex_unlock(&h->reset_mutex);
 	return rc;
