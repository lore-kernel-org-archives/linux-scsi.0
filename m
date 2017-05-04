From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V4 03/12] hpsa: update reset handler
Date: Thu, 4 May 2017 17:50:58 -0500
Message-ID: <149393825811.19382.15903364061757806286.stgit@brunhilda>
References: <149393820493.19382.11709906672864416473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0045.outbound.protection.outlook.com ([104.47.38.45]:10558
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752666AbdEDWvI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 18:51:08 -0400
In-Reply-To: <149393820493.19382.11709906672864416473.stgit@brunhilda>
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
