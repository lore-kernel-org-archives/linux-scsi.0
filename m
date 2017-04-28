From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 08/12] hpsa: correct queue depth for externals
Date: Fri, 28 Apr 2017 13:20:34 -0500
Message-ID: <149340363433.4102.8194749712108601498.stgit@brunhilda>
References: <149340349509.4102.15752249884898695693.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0045.outbound.protection.outlook.com ([104.47.38.45]:5376
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753543AbdD1SUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 14:20:48 -0400
In-Reply-To: <149340349509.4102.15752249884898695693.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

 - queue depth assignment not in correct place, had no effect.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   22 ++++++++++------------
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 71f32e9..b2827be 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2069,10 +2069,13 @@ static int hpsa_slave_configure(struct scsi_device *sdev)
 	sd = sdev->hostdata;
 	sdev->no_uld_attach = !sd || !sd->expose_device;
 
-	if (sd)
-		queue_depth = sd->queue_depth != 0 ?
-			sd->queue_depth : sdev->host->can_queue;
-	else
+	if (sd) {
+		if (sd->external)
+			queue_depth = EXTERNAL_QD;
+		else
+			queue_depth = sd->queue_depth != 0 ?
+					sd->queue_depth : sdev->host->can_queue;
+	} else
 		queue_depth = sdev->host->can_queue;
 
 	scsi_change_queue_depth(sdev, queue_depth);
@@ -3915,6 +3918,9 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		this_device->queue_depth = h->nr_cmds;
 	}
 
+	if (this_device->external)
+		this_device->queue_depth = EXTERNAL_QD;
+
 	if (is_OBDR_device) {
 		/* See if this is a One-Button-Disaster-Recovery device
 		 * by looking for "$DR-10" at offset 43 in inquiry data.
@@ -4123,14 +4129,6 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 	int rc;
 	struct ext_report_lun_entry *rle;
 
-	/*
-	 * external targets don't support BMIC
-	 */
-	if (dev->external) {
-		dev->queue_depth = 7;
-		return;
-	}
-
 	rle = &rlep->LUN[rle_index];
 
 	dev->ioaccel_handle = rle->ioaccel_handle;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 5352664..61dd54a 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -57,6 +57,7 @@ struct hpsa_sas_phy {
 	bool added_to_port;
 };
 
+#define EXTERNAL_QD 7
 struct hpsa_scsi_dev_t {
 	unsigned int devtype;
 	int bus, target, lun;		/* as presented to the OS */
