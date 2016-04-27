From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 2/7] hpsa: add sas_address to sysfs device attibute
Date: Wed, 27 Apr 2016 17:13:33 -0500
Message-ID: <146179521345.31195.14282979983859682916.stgit@brunhilda>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0081.outbound.protection.outlook.com ([157.56.111.81]:41284
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752365AbcD0W3j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 18:29:39 -0400
In-Reply-To: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Joseph T Handzik <joseph.t.handzik@hpe.com>

There have been companies requesting a sysfs entry
to obtain the sas address of device.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5763f43..035117a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -728,6 +728,29 @@ static ssize_t unique_id_show(struct device *dev,
 			sn[12], sn[13], sn[14], sn[15]);
 }
 
+static ssize_t sas_address_show(struct device *dev,
+	      struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct scsi_device *sdev;
+	struct hpsa_scsi_dev_t *hdev;
+	unsigned long flags;
+	u64 sas_address;
+
+	sdev = to_scsi_device(dev);
+	h = sdev_to_hba(sdev);
+	spin_lock_irqsave(&h->lock, flags);
+	hdev = sdev->hostdata;
+	if (!hdev || is_logical_device(hdev) || !hdev->expose_device) {
+		spin_unlock_irqrestore(&h->lock, flags);
+		return -ENODEV;
+	}
+	sas_address = hdev->sas_address;
+	spin_unlock_irqrestore(&h->lock, flags);
+
+	return snprintf(buf, PAGE_SIZE, "0x%016llx\n", sas_address);
+}
+
 static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
@@ -840,6 +863,7 @@ static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
 static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
+static DEVICE_ATTR(sas_address, S_IRUGO, sas_address_show, NULL);
 static DEVICE_ATTR(hp_ssd_smart_path_enabled, S_IRUGO,
 			host_show_hp_ssd_smart_path_enabled, NULL);
 static DEVICE_ATTR(path_info, S_IRUGO, path_info_show, NULL);
@@ -865,6 +889,7 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_unique_id,
 	&dev_attr_hp_ssd_smart_path_enabled,
 	&dev_attr_path_info,
+	&dev_attr_sas_address,
 	NULL,
 };
 

