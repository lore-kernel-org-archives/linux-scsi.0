From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 01/37] smartpqi: correct remove scsi devices
Date: Tue, 25 Apr 2017 14:45:57 -0500
Message-ID: <149314955787.13903.7010111927127310826.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0077.outbound.protection.outlook.com ([104.47.41.77]:54149
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031978AbdDYTqJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:46:09 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

correct a problem caused by holding a spinlock during device deletion.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 657ad15..dd00c69 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1823,19 +1823,25 @@ static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned long flags;
 	struct pqi_scsi_dev *device;
-	struct pqi_scsi_dev *next;
 
-	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+	while (1) {
+		spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+		device = list_first_entry_or_null(&ctrl_info->scsi_device_list,
+			struct pqi_scsi_dev, scsi_device_list_entry);
+		if (device)
+			list_del(&device->scsi_device_list_entry);
+
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock,
+			flags);
+
+		if (!device)
+			break;
 
-	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry) {
 		if (device->sdev)
 			pqi_remove_device(ctrl_info, device);
-		list_del(&device->scsi_device_list_entry);
 		pqi_free_device(device);
 	}
-
-	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 }
 
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
