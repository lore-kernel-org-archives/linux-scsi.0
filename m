From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 08/17] smartpqi: correct controller offline issue
Date: Fri, 26 Aug 2016 11:44:54 -0500
Message-ID: <147222989409.31214.3810017071620268818.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0042.outbound.protection.outlook.com ([104.47.36.42]:11040
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754438AbcHZRAK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:00:10 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Fixed a bug where the driver would not free all of the
controller resources if the controller ever went offline.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 67661de..6dda9f5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5609,19 +5609,14 @@ static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 {
-	int rc;
+	cancel_delayed_work_sync(&ctrl_info->rescan_work);
+	cancel_delayed_work_sync(&ctrl_info->update_time_work);
+	pqi_remove_all_scsi_devices(ctrl_info);
+	pqi_unregister_scsi(ctrl_info);
 
-	if (ctrl_info->controller_online) {
-		cancel_delayed_work_sync(&ctrl_info->rescan_work);
-		cancel_delayed_work_sync(&ctrl_info->update_time_work);
-		pqi_remove_all_scsi_devices(ctrl_info);
-		pqi_unregister_scsi(ctrl_info);
-		ctrl_info->controller_online = false;
-	}
 	if (ctrl_info->pqi_mode_enabled) {
 		sis_disable_msix(ctrl_info);
-		rc = pqi_reset(ctrl_info);
-		if (rc == 0)
+		if (pqi_reset(ctrl_info) == 0)
 			sis_reenable_sis_mode(ctrl_info);
 	}
 	pqi_free_ctrl_resources(ctrl_info);

