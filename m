From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 04/37] smartpqi: add in controller checkpoint for controller
 lockups.
Date: Tue, 25 Apr 2017 14:46:16 -0500
Message-ID: <149314957619.13903.3452880307653768769.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0045.outbound.protection.outlook.com ([104.47.40.45]:61115
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1046320AbdDYTqW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:46:22 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

tell smartpqi controller to generate a checkpoint for rare lockup
conditions.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 +-
 drivers/scsi/smartpqi/smartpqi_init.c |    1 +
 drivers/scsi/smartpqi/smartpqi_sis.c  |    7 +++++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |    1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index b673825..73754ca 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -933,10 +933,10 @@ struct pqi_ctrl_info {
 	struct Scsi_Host *scsi_host;
 
 	struct mutex	scan_mutex;
+	bool		controller_online : 1;
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
-	u8		controller_online : 1;
 	u8		heartbeat_timer_started : 1;
 
 	struct list_head scsi_device_list;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7a09fdb..8a9b48a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2697,6 +2697,7 @@ static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
 
 	ctrl_info->controller_online = false;
 	dev_err(&ctrl_info->pci_dev->dev, "controller offline\n");
+	sis_shutdown_ctrl(ctrl_info);
 
 	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
 		queue_group = &ctrl_info->queue_groups[i];
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 71408f9..c7d9ea1 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -34,6 +34,7 @@
 #define SIS_REENABLE_SIS_MODE			0x1
 #define SIS_ENABLE_MSIX				0x40
 #define SIS_SOFT_RESET				0x100
+#define SIS_TRIGGER_SHUTDOWN			0x800000
 #define SIS_CMD_READY				0x200
 #define SIS_CMD_COMPLETE			0x1000
 #define SIS_CLEAR_CTRL_TO_HOST_DOORBELL		0x1000
@@ -342,6 +343,12 @@ void sis_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
 }
 
+void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info)
+{
+	writel(SIS_TRIGGER_SHUTDOWN,
+		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
+}
+
 #define SIS_MODE_READY_TIMEOUT_SECS	30
 
 int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info)
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index bd6e7b0..7f7b68c 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -27,6 +27,7 @@ int sis_init_base_struct_addr(struct pqi_ctrl_info *ctrl_info);
 void sis_enable_msix(struct pqi_ctrl_info *ctrl_info);
 void sis_disable_msix(struct pqi_ctrl_info *ctrl_info);
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
+void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info);
 int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info);
 void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
 u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info);
