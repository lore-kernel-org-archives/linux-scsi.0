From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 08/12] hpsa: update queue depth for externals
Date: Fri, 20 Oct 2017 16:51:51 -0500
Message-ID: <150853631117.28275.7043249295857386555.stgit@brunhilda>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0047.outbound.protection.outlook.com ([104.47.40.47]:19424
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753410AbdJTVw3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 17:52:29 -0400
In-Reply-To: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

- preserve external device queue depth during a
  scan operation.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6a998b0..27a1aca 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1765,8 +1765,12 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 		 * way too high for partial stripe writes
 		 */
 		logical_drive->queue_depth = qdepth;
-	else
-		logical_drive->queue_depth = h->nr_cmds;
+	else {
+		if (logical_drive->external)
+			logical_drive->queue_depth = EXTERNAL_QD;
+		else
+			logical_drive->queue_depth = h->nr_cmds;
+	}
 }
 
 static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
