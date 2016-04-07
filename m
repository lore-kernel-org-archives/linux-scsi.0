From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH v2 1/5] bnx2fc: Add driver tunables.
Date: Thu, 7 Apr 2016 09:07:56 -0400
Message-ID: <1460034480-28512-2-git-send-email-chad.dupuis@qlogic.com>
References: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:44600 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751089AbcDGNtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 09:49:23 -0400
In-Reply-To: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chad.dupuis@qlogic.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Per customer request, add the following driver tunables:

o devloss_tmo
o max_luns
o queue_depth
o tm_timeout

tm_timeout is set per scsi_host in /sys/class/scsi_host/hostX/tm_timeout.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |  1 +
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 79 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  2 +-
 3 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 499e369..106788f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -261,6 +261,7 @@ struct bnx2fc_interface {
 	u8 vlan_enabled;
 	int vlan_id;
 	bool enabled;
+	u8 tm_timeout;
 };
 
 #define bnx2fc_from_ctlr(x)			\
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index d7029ea..b0305b0 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -107,6 +107,21 @@ MODULE_PARM_DESC(debug_logging,
 		"\t\t0x10 - fcoe L2 fame related logs.\n"
 		"\t\t0xff - LOG all messages.");
 
+uint bnx2fc_devloss_tmo;
+module_param_named(devloss_tmo, bnx2fc_devloss_tmo, uint, S_IRUGO);
+MODULE_PARM_DESC(devloss_tmo, " Change devloss_tmo for the remote ports "
+	"attached via bnx2fc.");
+
+uint bnx2fc_max_luns = BNX2FC_MAX_LUN;
+module_param_named(max_luns, bnx2fc_max_luns, uint, S_IRUGO);
+MODULE_PARM_DESC(max_luns, " Change the default max_lun per SCSI host. Default "
+	"0xffff.");
+
+uint bnx2fc_queue_depth;
+module_param_named(queue_depth, bnx2fc_queue_depth, uint, S_IRUGO);
+MODULE_PARM_DESC(queue_depth, " Change the default queue depth of SCSI devices "
+	"attached via bnx2fc.");
+
 static int bnx2fc_cpu_callback(struct notifier_block *nfb,
 			     unsigned long action, void *hcpu);
 /* notification function for CPU hotplug events */
@@ -692,7 +707,7 @@ static int bnx2fc_shost_config(struct fc_lport *lport, struct device *dev)
 	int rc = 0;
 
 	shost->max_cmd_len = BNX2FC_MAX_CMD_LEN;
-	shost->max_lun = BNX2FC_MAX_LUN;
+	shost->max_lun = bnx2fc_max_luns;
 	shost->max_id = BNX2FC_MAX_FCP_TGT;
 	shost->max_channel = 0;
 	if (lport->vport)
@@ -1102,6 +1117,9 @@ static int bnx2fc_vport_create(struct fc_vport *vport, bool disabled)
 		return -EIO;
 	}
 
+	if (bnx2fc_devloss_tmo)
+		fc_host_dev_loss_tmo(vn_port->host) = bnx2fc_devloss_tmo;
+
 	if (disabled) {
 		fc_vport_set_state(vport, FC_VPORT_DISABLED);
 	} else {
@@ -1495,6 +1513,9 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 	}
 	fc_host_port_type(lport->host) = FC_PORTTYPE_UNKNOWN;
 
+	if (bnx2fc_devloss_tmo)
+		fc_host_dev_loss_tmo(shost) = bnx2fc_devloss_tmo;
+
 	/* Allocate exchange manager */
 	if (!npiv)
 		rc = bnx2fc_em_config(lport, hba);
@@ -2293,6 +2314,7 @@ static int _bnx2fc_create(struct net_device *netdev,
 	ctlr = bnx2fc_to_ctlr(interface);
 	cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
 	interface->vlan_id = vlan_id;
+	interface->tm_timeout = BNX2FC_TM_TIMEOUT;
 
 	interface->timer_work_queue =
 			create_singlethread_workqueue("bnx2fc_timer_wq");
@@ -2612,6 +2634,15 @@ static int bnx2fc_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
+static int bnx2fc_slave_configure(struct scsi_device *sdev)
+{
+	if (!bnx2fc_queue_depth)
+		return 0;
+
+	scsi_change_queue_depth(sdev, bnx2fc_queue_depth);
+	return 0;
+}
+
 /**
  * bnx2fc_mod_init - module init entry point
  *
@@ -2858,6 +2889,50 @@ static struct fc_function_template bnx2fc_vport_xport_function = {
 	.bsg_request = fc_lport_bsg_request,
 };
 
+/*
+ * Additional scsi_host attributes.
+ */
+static ssize_t
+bnx2fc_tm_timeout_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct fc_lport *lport = shost_priv(shost);
+	struct fcoe_port *port = lport_priv(lport);
+	struct bnx2fc_interface *interface = port->priv;
+
+	sprintf(buf, "%u\n", interface->tm_timeout);
+	return strlen(buf);
+}
+
+static ssize_t
+bnx2fc_tm_timeout_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct fc_lport *lport = shost_priv(shost);
+	struct fcoe_port *port = lport_priv(lport);
+	struct bnx2fc_interface *interface = port->priv;
+	int rval, val;
+
+	rval = kstrtouint(buf, 10, &val);
+	if (rval)
+		return rval;
+	if (val > 255)
+		return -ERANGE;
+
+	interface->tm_timeout = (u8)val;
+	return strlen(buf);
+}
+
+static DEVICE_ATTR(tm_timeout, S_IRUGO|S_IWUSR, bnx2fc_tm_timeout_show,
+	bnx2fc_tm_timeout_store);
+
+static struct device_attribute *bnx2fc_host_attrs[] = {
+	&dev_attr_tm_timeout,
+	NULL,
+};
+
 /**
  * scsi_host_template structure used while registering with SCSI-ml
  */
@@ -2877,6 +2952,8 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
 	.max_sectors		= 1024,
 	.track_queue_depth	= 1,
+	.slave_configure	= bnx2fc_slave_configure,
+	.shost_attrs		= bnx2fc_host_attrs,
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 0002caf..ac8fb2a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -770,7 +770,7 @@ retry_tmf:
 	spin_unlock_bh(&tgt->tgt_lock);
 
 	rc = wait_for_completion_timeout(&io_req->tm_done,
-					 BNX2FC_TM_TIMEOUT * HZ);
+					 interface->tm_timeout * HZ);
 	spin_lock_bh(&tgt->tgt_lock);
 
 	io_req->wait_for_comp = 0;
-- 
2.0.0.rc0.26.g779792a

