From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 04/36] smartpqi: add in controller checkpoint for
 controller lockups.
Date: Wed, 3 May 2017 18:52:40 -0500
Message-ID: <149385556077.11043.2690345216645272598.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0045.outbound.protection.outlook.com ([104.47.32.45]:58112
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751961AbdECXwv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:52:51 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

tell smartpqi controller to generate a checkpoint for rare lockup
conditions.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
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
index 735cef5..14d74e1 100644
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
