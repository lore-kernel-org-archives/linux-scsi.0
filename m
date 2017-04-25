From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 05/37] smartpqi: ensure controller is in SIS mode at init
Date: Tue, 25 Apr 2017 14:46:22 -0500
Message-ID: <149314958226.13903.4820392053805213524.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0049.outbound.protection.outlook.com ([104.47.32.49]:39717
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1046320AbdDYTq1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:46:27 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

put in SIS mode during initialization.
support kexec/kdump

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 +
 drivers/scsi/smartpqi/smartpqi_init.c |   60 +++++++++++++++++++--------------
 drivers/scsi/smartpqi/smartpqi_sis.c  |   15 ++++++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |    1 +
 4 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 73754ca..62045c1 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -964,7 +964,7 @@ struct pqi_ctrl_info {
 };
 
 enum pqi_ctrl_mode {
-	UNKNOWN,
+	SIS_MODE = 0,
 	PQI_MODE
 };
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8a9b48a..d28e694 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5245,38 +5245,50 @@ static int pqi_get_ctrl_firmware_version(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
-static int pqi_kdump_init(struct pqi_ctrl_info *ctrl_info)
+/* Switches the controller from PQI mode back into SIS mode. */
+
+static int pqi_revert_to_sis_mode(struct pqi_ctrl_info *ctrl_info)
+{
+	int rc;
+
+	sis_disable_msix(ctrl_info);
+	rc = pqi_reset(ctrl_info);
+	if (rc)
+		return rc;
+	sis_reenable_sis_mode(ctrl_info);
+	pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
+
+	return 0;
+}
+
+/*
+ * If the controller isn't already in SIS mode, this function forces it into
+ * SIS mode.
+ */
+
+static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 {
 	if (!sis_is_firmware_running(ctrl_info))
 		return -ENXIO;
 
-	if (pqi_get_ctrl_mode(ctrl_info) == PQI_MODE) {
-		sis_disable_msix(ctrl_info);
-		if (pqi_reset(ctrl_info) == 0)
-			sis_reenable_sis_mode(ctrl_info);
+	if (pqi_get_ctrl_mode(ctrl_info) == SIS_MODE)
+		return 0;
+
+	if (sis_is_kernel_up(ctrl_info)) {
+		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
+		return 0;
 	}
 
-	return 0;
+	return pqi_revert_to_sis_mode(ctrl_info);
 }
 
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
 
-	if (reset_devices) {
-		rc = pqi_kdump_init(ctrl_info);
-		if (rc)
-			return rc;
-	}
-
-	/*
-	 * When the controller comes out of reset, it is always running
-	 * in legacy SIS mode.  This is so that it can be compatible
-	 * with legacy drivers shipped with OSes.  So we have to talk
-	 * to it using SIS commands at first.  Once we are satisified
-	 * that the controller supports PQI, we transition it into PQI
-	 * mode.
-	 */
+	rc = pqi_force_sis_mode(ctrl_info);
+	if (rc)
+		return rc;
 
 	/*
 	 * Wait until the controller is ready to start accepting SIS
@@ -5594,12 +5606,8 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 	cancel_delayed_work_sync(&ctrl_info->update_time_work);
 	pqi_remove_all_scsi_devices(ctrl_info);
 	pqi_unregister_scsi(ctrl_info);
-
-	if (ctrl_info->pqi_mode_enabled) {
-		sis_disable_msix(ctrl_info);
-		if (pqi_reset(ctrl_info) == 0)
-			sis_reenable_sis_mode(ctrl_info);
-	}
+	if (ctrl_info->pqi_mode_enabled)
+		pqi_revert_to_sis_mode(ctrl_info);
 	pqi_free_ctrl_resources(ctrl_info);
 }
 
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index c7d9ea1..af59998 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -127,6 +127,21 @@ bool sis_is_firmware_running(struct pqi_ctrl_info *ctrl_info)
 	return running;
 }
 
+bool sis_is_kernel_up(struct pqi_ctrl_info *ctrl_info)
+{
+	u32 status;
+	bool kernel_up;
+
+	status = readl(&ctrl_info->registers->sis_firmware_status);
+
+	if (status & SIS_CTRL_KERNEL_UP)
+		kernel_up = true;
+	else
+		kernel_up = false;
+
+	return kernel_up;
+}
+
 /* used for passing command parameters/results when issuing SIS commands */
 struct sis_sync_cmd_params {
 	u32	mailbox[6];	/* mailboxes 0-5 */
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 7f7b68c..157768d 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -21,6 +21,7 @@
 
 int sis_wait_for_ctrl_ready(struct pqi_ctrl_info *ctrl_info);
 bool sis_is_firmware_running(struct pqi_ctrl_info *ctrl_info);
+bool sis_is_kernel_up(struct pqi_ctrl_info *ctrl_info);
 int sis_get_ctrl_properties(struct pqi_ctrl_info *ctrl_info);
 int sis_get_pqi_capabilities(struct pqi_ctrl_info *ctrl_info);
 int sis_init_base_struct_addr(struct pqi_ctrl_info *ctrl_info);
