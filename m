From: brking@us.ibm.com
Subject: [PATCH 08/15] ipr: Use change queue type API
Date: Mon, 21 Feb 2005 15:09:16 -0600
Message-ID: <200502212109.j1LL9H5H023544@d03av01.boulder.ibm.com>
Received: from e32.co.us.ibm.com ([32.97.110.130]:41612 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262125AbVBUVJU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:20 -0500
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.195.12])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1LL9I5j731662
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:18 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay03.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL9IUK021242
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:18 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9HZs023572
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Use new change_queue_type API.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |   42 ++++++++++++++++++++++++
 1 files changed, 42 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_change_queue_type drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_change_queue_type	2005-02-21 13:15:19.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:15:19.000000000 -0600
@@ -2688,6 +2688,47 @@ static int ipr_change_queue_depth(struct
 }
 
 /**
+ * ipr_change_queue_type - Change the device's queue type
+ * @dsev:		scsi device struct
+ * @tag_type:	type of tags to use
+ *
+ * Return value:
+ * 	actual queue type set
+ **/
+static int ipr_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
+	struct ipr_resource_entry *res;
+	unsigned long lock_flags = 0;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	res = (struct ipr_resource_entry *)sdev->hostdata;
+
+	if (res) {
+		if (ipr_is_gscsi(res) && sdev->tagged_supported) {
+			/*
+			 * We don't bother quiescing the device here since the
+			 * adapter firmware does it for us.
+			 */
+			scsi_set_tag_type(sdev, tag_type);
+
+			if (tag_type) {
+				res->tcq_active = 1;
+				scsi_activate_tcq(sdev, res->qdepth);
+			} else {
+				res->tcq_active = 0;
+				scsi_deactivate_tcq(sdev, res->qdepth);
+			}
+		} else
+			tag_type = 0;
+	} else
+		tag_type = 0;
+
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	return tag_type;
+}
+
+/**
  * ipr_show_tcq_enable - Show if the device is enabled for tcqing
  * @dev:	device struct
  * @buf:	buffer
@@ -3998,6 +4039,7 @@ static struct scsi_host_template driver_
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
 	.change_queue_depth = ipr_change_queue_depth,
+	.change_queue_type = ipr_change_queue_type,
 	.bios_param = ipr_biosparam,
 	.can_queue = IPR_MAX_COMMANDS,
 	.this_id = -1,
_
