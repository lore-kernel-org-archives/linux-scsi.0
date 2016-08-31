From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 07/15] smartpqi: correct controller offline issue
Date: Wed, 31 Aug 2016 14:54:47 -0500
Message-ID: <147267328730.22907.11787626618906251459.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:51936
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932200AbcHaUKj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 16:10:39 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Fixes: 6c223761e 'smartpqi: initial commit of Microsemi smartpqi driver'

Fixed a bug where the driver would not free all of the
controller resources if the controller ever went offline.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 43bfeac..d759703 100644
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

