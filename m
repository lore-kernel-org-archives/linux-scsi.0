From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 1/3] hpsa: update check for logical volume status
Date: Mon, 6 Mar 2017 15:24:39 -0600
Message-ID: <148883547906.14177.13051264449897042914.stgit@brunhilda>
References: <148883542370.14177.274248778005931414.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0085.outbound.protection.outlook.com ([104.47.34.85]:10720
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754304AbdCFVYu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Mar 2017 16:24:50 -0500
In-Reply-To: <148883542370.14177.274248778005931414.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

 - Add in a new case for volume offline. Resolves internal
   testing bug for multilun array management.
 - Return correct status for failed TURs.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c     |   26 +++++++++++++-------------
 drivers/scsi/hpsa_cmd.h |    2 ++
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 524a0c7..1adc4ec 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3735,7 +3735,7 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 					DEFAULT_TIMEOUT);
 	if (rc) {
 		cmd_free(h, c);
-		return 0;
+		return 0xff;
 	}
 	sense = c->err_info->SenseInfo;
 	if (c->err_info->SenseLen > sizeof(c->err_info->SenseInfo))
@@ -3746,19 +3746,13 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 	cmd_status = c->err_info->CommandStatus;
 	scsi_status = c->err_info->ScsiStatus;
 	cmd_free(h, c);
-	/* Is the volume 'not ready'? */
-	if (cmd_status != CMD_TARGET_STATUS ||
-		scsi_status != SAM_STAT_CHECK_CONDITION ||
-		sense_key != NOT_READY ||
-		asc != ASC_LUN_NOT_READY)  {
-		return 0;
-	}
 
 	/* Determine the reason for not ready state */
 	ldstat = hpsa_get_volume_status(h, scsi3addr);
 
 	/* Keep volume offline in certain cases: */
 	switch (ldstat) {
+	case HPSA_LV_FAILED:
 	case HPSA_LV_UNDERGOING_ERASE:
 	case HPSA_LV_NOT_AVAILABLE:
 	case HPSA_LV_UNDERGOING_RPI:
@@ -3853,10 +3847,10 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	/* Do an inquiry to the device to see what it is. */
 	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
 		(unsigned char) OBDR_TAPE_INQ_SIZE) != 0) {
-		/* Inquiry failed (msg printed already) */
 		dev_err(&h->pdev->dev,
-			"hpsa_update_device_info: inquiry failed\n");
-		rc = -EIO;
+			"%s: inquiry failed, device will be skipped.\n",
+			__func__);
+		rc = HPSA_INQUIRY_FAILED;
 		goto bail_out;
 	}
 
@@ -3894,6 +3888,13 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		if (volume_offline < 0 || volume_offline > 0xff)
 			volume_offline = HPSA_VPD_LV_STATUS_UNSUPPORTED;
 		this_device->volume_offline = volume_offline & 0xff;
+		if (volume_offline == HPSA_LV_FAILED) {
+			rc = HPSA_LV_FAILED;
+			dev_err(&h->pdev->dev,
+				"%s: LV failed, device will be skipped.\n",
+				__func__);
+			goto bail_out;
+		}
 	} else {
 		this_device->raid_level = RAID_UNKNOWN;
 		this_device->offload_config = 0;
@@ -4379,8 +4380,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 			goto out;
 		}
 		if (rc) {
-			dev_warn(&h->pdev->dev,
-				"Inquiry failed, skipping device.\n");
+			h->drv_req_rescan = 1;
 			continue;
 		}
 
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index a584cdf..5961705 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -156,6 +156,7 @@
 #define CFGTBL_BusType_Fibre2G  0x00000200l
 
 /* VPD Inquiry types */
+#define HPSA_INQUIRY_FAILED		0x02
 #define HPSA_VPD_SUPPORTED_PAGES        0x00
 #define HPSA_VPD_LV_DEVICE_ID           0x83
 #define HPSA_VPD_LV_DEVICE_GEOMETRY     0xC1
@@ -166,6 +167,7 @@
 /* Logical volume states */
 #define HPSA_VPD_LV_STATUS_UNSUPPORTED			0xff
 #define HPSA_LV_OK                                      0x0
+#define HPSA_LV_FAILED					0x01
 #define HPSA_LV_NOT_AVAILABLE				0x0b
 #define HPSA_LV_UNDERGOING_ERASE			0x0F
 #define HPSA_LV_UNDERGOING_RPI				0x12
