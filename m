From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/22] fcoe: make R_A_TOV and E_D_TOV configurable
Date: Wed,  3 Aug 2016 15:13:08 +0200
Message-ID: <1470230002-37737-9-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbcHCNNd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:33 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The user might want to modify the values for R_A_TOV and E_D_TOV,
so add new module parameters 'e_d_tov' and 'r_a_tov' for the
'fcoe' modules and allow to modify them via sysfs attributes.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c       | 12 +++++--
 drivers/scsi/fcoe/fcoe_sysfs.c | 71 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9bd41a3..c907661 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -63,6 +63,14 @@ unsigned int fcoe_debug_logging;
 module_param_named(debug_logging, fcoe_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
+unsigned int fcoe_e_d_tov = 2 * 1000;
+module_param_named(e_d_tov, fcoe_e_d_tov, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(e_d_tov, "E_D_TOV in ms, default 2000");
+
+unsigned int fcoe_r_a_tov = 2 * 2 * 1000;
+module_param_named(r_a_tov, fcoe_r_a_tov, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(r_a_tov, "R_A_TOV in ms, default 4000");
+
 static DEFINE_MUTEX(fcoe_config_mutex);
 
 static struct workqueue_struct *fcoe_wq;
@@ -633,8 +641,8 @@ static int fcoe_lport_config(struct fc_lport *lport)
 	lport->qfull = 0;
 	lport->max_retry_count = 3;
 	lport->max_rport_retry_count = 3;
-	lport->e_d_tov = 2 * 1000;	/* FC-FS default */
-	lport->r_a_tov = 2 * 2 * 1000;
+	lport->e_d_tov = fcoe_e_d_tov;
+	lport->r_a_tov = fcoe_r_a_tov;
 	lport->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
 				 FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
 	lport->does_npiv = 1;
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 0675fd1..9e6baac 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -424,6 +424,75 @@ static FCOE_DEVICE_ATTR(ctlr, fip_vlan_responder, S_IRUGO | S_IWUSR,
 			store_ctlr_fip_resp);
 
 static ssize_t
+fcoe_ctlr_var_store(u32 *var, const char *buf, size_t count)
+{
+	int err;
+	unsigned long v;
+
+	err = kstrtoul(buf, 10, &v);
+	if (err || v > UINT_MAX)
+		return -EINVAL;
+
+	*var = v;
+
+	return count;
+}
+
+static ssize_t store_ctlr_r_a_tov(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct fcoe_ctlr_device *ctlr_dev = dev_to_ctlr(dev);
+	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(ctlr_dev);
+
+	if (ctlr_dev->enabled == FCOE_CTLR_ENABLED)
+		return -EBUSY;
+	if (ctlr_dev->enabled == FCOE_CTLR_DISABLED)
+		return fcoe_ctlr_var_store(&ctlr->lp->r_a_tov, buf, count);
+	return -ENOTSUPP;
+}
+
+static ssize_t show_ctlr_r_a_tov(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct fcoe_ctlr_device *ctlr_dev = dev_to_ctlr(dev);
+	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(ctlr_dev);
+
+	return sprintf(buf, "%d\n", ctlr->lp->r_a_tov);
+}
+
+static FCOE_DEVICE_ATTR(ctlr, r_a_tov, S_IRUGO | S_IWUSR,
+			show_ctlr_r_a_tov, store_ctlr_r_a_tov);
+
+static ssize_t store_ctlr_e_d_tov(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct fcoe_ctlr_device *ctlr_dev = dev_to_ctlr(dev);
+	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(ctlr_dev);
+
+	if (ctlr_dev->enabled == FCOE_CTLR_ENABLED)
+		return -EBUSY;
+	if (ctlr_dev->enabled == FCOE_CTLR_DISABLED)
+		return fcoe_ctlr_var_store(&ctlr->lp->e_d_tov, buf, count);
+	return -ENOTSUPP;
+}
+
+static ssize_t show_ctlr_e_d_tov(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct fcoe_ctlr_device *ctlr_dev = dev_to_ctlr(dev);
+	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(ctlr_dev);
+
+	return sprintf(buf, "%d\n", ctlr->lp->e_d_tov);
+}
+
+static FCOE_DEVICE_ATTR(ctlr, e_d_tov, S_IRUGO | S_IWUSR,
+			show_ctlr_e_d_tov, store_ctlr_e_d_tov);
+
+static ssize_t
 store_private_fcoe_ctlr_fcf_dev_loss_tmo(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
@@ -507,6 +576,8 @@ static struct attribute_group fcoe_ctlr_lesb_attr_group = {
 static struct attribute *fcoe_ctlr_attrs[] = {
 	&device_attr_fcoe_ctlr_fip_vlan_responder.attr,
 	&device_attr_fcoe_ctlr_fcf_dev_loss_tmo.attr,
+	&device_attr_fcoe_ctlr_r_a_tov.attr,
+	&device_attr_fcoe_ctlr_e_d_tov.attr,
 	&device_attr_fcoe_ctlr_enabled.attr,
 	&device_attr_fcoe_ctlr_mode.attr,
 	NULL,
-- 
1.8.5.6

