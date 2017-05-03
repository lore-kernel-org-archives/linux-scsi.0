From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 27/36] smartpqi: cleanup controller branding
Date: Wed, 3 May 2017 18:55:01 -0500
Message-ID: <149385570130.11043.15340117339376991761.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0067.outbound.protection.outlook.com ([104.47.32.67]:1280
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751817AbdECXzL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:55:11 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
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
index 338ba03..8f71e17 100644
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
@@ -6467,19 +6464,10 @@ static void pqi_print_ctrl_info(struct pci_dev *pci_dev,
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
