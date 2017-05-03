From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 34/36] smartpqi: add module parameters
Date: Wed, 3 May 2017 18:55:43 -0500
Message-ID: <149385574362.11043.6247480515476827201.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0067.outbound.protection.outlook.com ([104.47.42.67]:2416
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752310AbdECXz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:55:56 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Add module parameters to disable heartbeat support and to disable
shutting down the controller when a controller is taken offline.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 21fbcf3..7bf6222 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -122,6 +122,18 @@ module_param_named(disable_device_id_wildcards,
 MODULE_PARM_DESC(disable_device_id_wildcards,
 	"Disable device ID wildcards.");
 
+static int pqi_disable_heartbeat;
+module_param_named(disable_heartbeat,
+	pqi_disable_heartbeat, int, 0644);
+MODULE_PARM_DESC(disable_heartbeat,
+	"Disable heartbeat.");
+
+static int pqi_disable_ctrl_shutdown;
+module_param_named(disable_ctrl_shutdown,
+	pqi_disable_ctrl_shutdown, int, 0644);
+MODULE_PARM_DESC(disable_ctrl_shutdown,
+	"Disable controller shutdown when controller locked up.");
+
 static char *pqi_lockup_action_param;
 module_param_named(lockup_action,
 	pqi_lockup_action_param, charp, 0644);
@@ -5962,10 +5974,16 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 
 		switch (get_unaligned_le16(&section->section_id)) {
 		case PQI_CONFIG_TABLE_SECTION_HEARTBEAT:
-			ctrl_info->heartbeat_counter = table_iomem_addr +
-				section_offset +
-				offsetof(struct pqi_config_table_heartbeat,
-					heartbeat_counter);
+			if (pqi_disable_heartbeat)
+				dev_warn(&ctrl_info->pci_dev->dev,
+				"heartbeat disabled by module parameter\n");
+			else
+				ctrl_info->heartbeat_counter =
+					table_iomem_addr +
+					section_offset +
+					offsetof(
+					struct pqi_config_table_heartbeat,
+						heartbeat_counter);
 			break;
 		}
 
@@ -6550,7 +6568,8 @@ static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->controller_online = false;
 	ctrl_info->pqi_mode_enabled = false;
 	pqi_ctrl_block_requests(ctrl_info);
-	sis_shutdown_ctrl(ctrl_info);
+	if (!pqi_disable_ctrl_shutdown)
+		sis_shutdown_ctrl(ctrl_info);
 	pci_disable_device(ctrl_info->pci_dev);
 	dev_err(&ctrl_info->pci_dev->dev, "controller offline\n");
 	schedule_work(&ctrl_info->ctrl_offline_work);
