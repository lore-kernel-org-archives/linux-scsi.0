From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/12] qla2xxx: Add an 'Issue LIP' device attribute.
Date: Thu, 13 Oct 2005 16:17:24 -0700 (PDT)
Message-ID: <20051013231724.27191.33356.sendpatchset@plap.qlogic.com>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:938 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932538AbVJMXRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:17:24 -0400
In-Reply-To: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Subject: Add an 'Issue LIP' device attribute.

Add a scsi_host device attribute to allow a user to initiate
a LIP.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_attr.c |   16 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    8 ++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

applies-to: a66456df428081210a3b7117c57f277e69484bce
e3f47b3b40d29beb69223d2b479d34a5bc76c518
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 49696fa..2c6bf16 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -384,6 +384,20 @@ qla2x00_zio_timer_store(struct class_dev
 	return strlen(buf);
 }
 
+static ssize_t
+qla2x00_issue_lip(struct class_device *cdev, const char *buf, size_t count)
+{
+	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
+	int val = 0;
+
+	if ((sscanf(buf, "%d", &val) != 1) || val != 1)
+		return -EINVAL;
+
+	set_bit(LOOP_RESET_NEEDED, &ha->dpc_flags);
+
+	return strlen(buf);
+}
+
 static CLASS_DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show,
 	NULL);
 static CLASS_DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
@@ -398,6 +412,7 @@ static CLASS_DEVICE_ATTR(zio, S_IRUGO | 
     qla2x00_zio_store);
 static CLASS_DEVICE_ATTR(zio_timer, S_IRUGO | S_IWUSR, qla2x00_zio_timer_show,
     qla2x00_zio_timer_store);
+static CLASS_DEVICE_ATTR(issue_lip, S_IWUSR, NULL, qla2x00_issue_lip);
 
 struct class_device_attribute *qla2x00_host_attrs[] = {
 	&class_device_attr_driver_version,
@@ -411,6 +426,7 @@ struct class_device_attribute *qla2x00_h
 	&class_device_attr_state,
 	&class_device_attr_zio,
 	&class_device_attr_zio_timer,
+	&class_device_attr_issue_lip,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d73485e..d3181bf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2074,6 +2074,13 @@ qla2x00_do_dpc(void *data)
 			    ha->host_no));
 		}
 
+		if (test_and_clear_bit(LOOP_RESET_NEEDED, &ha->dpc_flags)) {
+			DEBUG(printk("scsi(%ld): dpc: sched loop_reset()\n",
+			    ha->host_no));
+
+			qla2x00_loop_reset(ha);
+		}
+
 		if (test_and_clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) &&
 		    (!(test_and_set_bit(RESET_ACTIVE, &ha->dpc_flags)))) {
 
@@ -2375,6 +2382,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
+	    test_bit(LOOP_RESET_NEEDED, &ha->dpc_flags) ||
 	    start_dpc ||
 	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
---
0.99.8.GIT

-- 
Andrew Vasquez
