From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 3/5] hpsa: check for vpd support before sending
Date: Fri, 9 Sep 2016 16:30:29 -0500
Message-ID: <147345662985.19269.15459802044850867924.stgit@brunhilda>
References: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0056.outbound.protection.outlook.com ([104.47.37.56]:23392
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754877AbcIIVpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 17:45:13 -0400
In-Reply-To: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@microsemi.com>

Before using vendor-specific VPD pages for getting
raid_level and device_id, check for page support.
If page isn't supported, don't try to use it.
Also, pay attention to return status on
hpsa_get_device_id.

Reviewed-by: Scott Benesh <scott.benest@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c     |   44 ++++++++++++++++++++++++++++++++++----------
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 97f50c7..6a5b7df 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -293,6 +293,8 @@ static int detect_controller_lockup(struct ctlr_info *h);
 static void hpsa_disable_rld_caching(struct ctlr_info *h);
 static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
 	struct ReportExtendedLUNdata *buf, int bufsize);
+static bool hpsa_vpd_page_supported(struct ctlr_info *h,
+	unsigned char scsi3addr[], u8 page);
 static int hpsa_luns_changed(struct ctlr_info *h);
 static bool hpsa_cmd_dev_match(struct ctlr_info *h, struct CommandList *c,
 			       struct hpsa_scsi_dev_t *dev,
@@ -3088,11 +3090,19 @@ static void hpsa_get_raid_level(struct ctlr_info *h,
 	buf = kzalloc(64, GFP_KERNEL);
 	if (!buf)
 		return;
-	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0xC1, buf, 64);
+
+	if (!hpsa_vpd_page_supported(h, scsi3addr,
+		HPSA_VPD_LV_DEVICE_GEOMETRY))
+		goto exit;
+
+	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE |
+		HPSA_VPD_LV_DEVICE_GEOMETRY, buf, 64);
+
 	if (rc == 0)
 		*raid_level = buf[8];
 	if (*raid_level > RAID_UNKNOWN)
 		*raid_level = RAID_UNKNOWN;
+exit:
 	kfree(buf);
 	return;
 }
@@ -3450,7 +3460,7 @@ static void hpsa_get_sas_address(struct ctlr_info *h, unsigned char *scsi3addr,
 }
 
 /* Get a device id from inquiry page 0x83 */
-static int hpsa_vpd_page_supported(struct ctlr_info *h,
+static bool hpsa_vpd_page_supported(struct ctlr_info *h,
 	unsigned char scsi3addr[], u8 page)
 {
 	int rc;
@@ -3539,18 +3549,25 @@ static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
 	int rc;
 	unsigned char *buf;
 
-	if (buflen > 16)
-		buflen = 16;
+	/* Does controller have VPD for device id? */
+	if (!hpsa_vpd_page_supported(h, scsi3addr, HPSA_VPD_LV_DEVICE_ID))
+		return 1; /* not supported */
+
 	buf = kzalloc(64, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0x83, buf, 64);
-	if (rc == 0)
-		memcpy(device_id, &buf[index], buflen);
+
+	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE |
+					HPSA_VPD_LV_DEVICE_ID, buf, 64);
+	if (rc == 0) {
+		if (buflen > 16)
+			buflen = 16;
+		memcpy(device_id, &buf[8], buflen);
+	}
 
 	kfree(buf);
 
-	return rc != 0;
+	return rc; /*0 - got id,  otherwise, didn't */
 }
 
 static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
@@ -3821,8 +3838,15 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		sizeof(this_device->model));
 	memset(this_device->device_id, 0,
 		sizeof(this_device->device_id));
-	hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
-		sizeof(this_device->device_id));
+	if (hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
+		sizeof(this_device->device_id)))
+		dev_err(&h->pdev->dev,
+			"hpsa%d: %s: can't get device id for host %d:C0:T%d:L%d\t%s\t%.16s\n",
+			h->ctlr, __func__,
+			h->scsi_host->host_no,
+			this_device->target, this_device->lun,
+			scsi_device_type(this_device->devtype),
+			this_device->model);
 
 	if ((this_device->devtype == TYPE_DISK ||
 		this_device->devtype == TYPE_ZBC) &&
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index a5be153..a584cdf 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -157,6 +157,7 @@
 
 /* VPD Inquiry types */
 #define HPSA_VPD_SUPPORTED_PAGES        0x00
+#define HPSA_VPD_LV_DEVICE_ID           0x83
 #define HPSA_VPD_LV_DEVICE_GEOMETRY     0xC1
 #define HPSA_VPD_LV_IOACCEL_STATUS      0xC2
 #define HPSA_VPD_LV_STATUS		0xC3

