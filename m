From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 28/37] smartpqi: cleanup controller branding
Date: Tue, 25 Apr 2017 14:48:43 -0500
Message-ID: <149314972330.13903.5851136803303877513.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0068.outbound.protection.outlook.com ([104.47.38.68]:41808
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1428289AbdDYTtE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:49:04 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

- Improve controller branding support.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 66f02f4..790dfc4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -58,9 +58,6 @@ MODULE_SUPPORTED_DEVICE("Microsemi Smart Family Controllers");
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-static char *hpe_branded_controller = "HPE Smart Array Controller";
-static char *microsemi_branded_controller = "Microsemi Smart Family Controller";
-
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
 static void pqi_retry_raid_bypass_requests(struct pqi_ctrl_info *ctrl_info);
@@ -6474,19 +6471,10 @@ static void pqi_print_ctrl_info(struct pci_dev *pci_dev,
 {
 	char *ctrl_description;
 
-	if (id->driver_data) {
+	if (id->driver_data)
 		ctrl_description = (char *)id->driver_data;
-	} else {
-		switch (id->subvendor) {
-		case PCI_VENDOR_ID_HP:
-			ctrl_description = hpe_branded_controller;
-			break;
-		case PCI_VENDOR_ID_ADAPTEC2:
-		default:
-			ctrl_description = microsemi_branded_controller;
-			break;
-		}
-	}
+	else
+		ctrl_description = "Microsemi Smart Family Controller";
 
 	dev_info(&pci_dev->dev, "%s found\n", ctrl_description);
 }
