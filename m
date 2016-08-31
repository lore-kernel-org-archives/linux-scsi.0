From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 10/15] smartpqi: minor tweaks to update time support
Date: Wed, 31 Aug 2016 14:55:05 -0500
Message-ID: <147267330536.22907.4800801964426044453.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0070.outbound.protection.outlook.com ([104.47.36.70]:27963
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753708AbcHaTzN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 15:55:13 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

minor tweaks to update time support

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index bfd2d75..db248c1 100644
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

