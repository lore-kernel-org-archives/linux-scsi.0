From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 06/15] qedf: Add fka_period SCSI host attribute to show fip keep alive period.
Date: Wed, 31 May 2017 06:33:53 -0700
Message-ID: <20170531133402.16629-7-chad.dupuis@cavium.com>
References: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0076.outbound.protection.outlook.com ([104.47.42.76]:11284
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751022AbdEaNeb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:34:31 -0400
In-Reply-To: <20170531133402.16629-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Expose this information for interested applications.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qedf/qedf_attr.c | 57 ++++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.c
index 1349f8a..fa67276 100644
--- a/drivers/scsi/qedf/qedf_attr.c
+++ b/drivers/scsi/qedf/qedf_attr.c
@@ -8,6 +8,25 @@
  */
 #include "qedf.h"
 
+inline bool qedf_is_vport(struct qedf_ctx *qedf)
+{
+	return qedf->lport->vport != NULL;
+}
+
+/* Get base qedf for physical port from vport */
+static struct qedf_ctx *qedf_get_base_qedf(struct qedf_ctx *qedf)
+{
+	struct fc_lport *lport;
+	struct fc_lport *base_lport;
+
+	if (!(qedf_is_vport(qedf)))
+		return NULL;
+
+	lport = qedf->lport;
+	base_lport = shost_priv(vport_to_shost(lport->vport));
+	return lport_priv(base_lport);
+}
+
 static ssize_t
 qedf_fcoe_mac_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
@@ -26,34 +45,34 @@
 	return scnprintf(buf, PAGE_SIZE, "%pM\n", fcoe_mac);
 }
 
+static ssize_t
+qedf_fka_period_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct fc_lport *lport = shost_priv(class_to_shost(dev));
+	struct qedf_ctx *qedf = lport_priv(lport);
+	int fka_period = -1;
+
+	if (qedf_is_vport(qedf))
+		qedf = qedf_get_base_qedf(qedf);
+
+	if (qedf->ctlr.sel_fcf)
+		fka_period = qedf->ctlr.sel_fcf->fka_period;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", fka_period);
+}
+
 static DEVICE_ATTR(fcoe_mac, S_IRUGO, qedf_fcoe_mac_show, NULL);
+static DEVICE_ATTR(fka_period, S_IRUGO, qedf_fka_period_show, NULL);
 
 struct device_attribute *qedf_host_attrs[] = {
 	&dev_attr_fcoe_mac,
+	&dev_attr_fka_period,
 	NULL,
 };
 
 extern const struct qed_fcoe_ops *qed_ops;
 
-inline bool qedf_is_vport(struct qedf_ctx *qedf)
-{
-	return (!(qedf->lport->vport == NULL));
-}
-
-/* Get base qedf for physical port from vport */
-static struct qedf_ctx *qedf_get_base_qedf(struct qedf_ctx *qedf)
-{
-	struct fc_lport *lport;
-	struct fc_lport *base_lport;
-
-	if (!(qedf_is_vport(qedf)))
-		return NULL;
-
-	lport = qedf->lport;
-	base_lport = shost_priv(vport_to_shost(lport->vport));
-	return (struct qedf_ctx *)(lport_priv(base_lport));
-}
-
 void qedf_capture_grc_dump(struct qedf_ctx *qedf)
 {
 	struct qedf_ctx *base_qedf;
-- 
1.8.5.6
