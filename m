From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 11/17] smartpqi: minor tweaks to update time support
Date: Fri, 26 Aug 2016 11:45:12 -0500
Message-ID: <147222991200.31214.16478440159265351246.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0050.outbound.protection.outlook.com ([104.47.36.50]:11936
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752408AbcHZRB7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:01:59 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

minor tweaks to update time support

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2759c90..a8b8671 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -588,10 +588,6 @@ static void pqi_update_time_worker(struct work_struct *work)
 	ctrl_info = container_of(to_delayed_work(work), struct pqi_ctrl_info,
 		update_time_work);
 
-	if (!ctrl_info) {
-		printk("%s: NULL controller pointer.\n", __func__);
-		return;
-	}
 	rc = pqi_write_current_time_to_host_wellness(ctrl_info);
 	if (rc)
 		dev_warn(&ctrl_info->pci_dev->dev,
@@ -602,9 +598,9 @@ static void pqi_update_time_worker(struct work_struct *work)
 }
 
 static inline void pqi_schedule_update_time_worker(
-			struct pqi_ctrl_info *ctrl_info)
+	struct pqi_ctrl_info *ctrl_info)
 {
-	schedule_delayed_work(&ctrl_info->update_time_work, 120);
+	schedule_delayed_work(&ctrl_info->update_time_work, 0);
 }
 
 static int pqi_report_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,

