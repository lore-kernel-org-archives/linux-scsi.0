From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] fc class: add fc host dev loss sysfs file
Date: Wed, 15 Sep 2010 16:52:32 -0500
Message-ID: <1284587552-7617-6-git-send-email-michaelc@cs.wisc.edu>
References: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0IOVrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 17:47:09 -0400
In-Reply-To: <1284587552-7617-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This adds a fc host dev loss sysfs file. Instead of
calling into the driver using the get_host_def_dev_loss_tmo
callback, we allow drivers to init the dev loss like is done
for other fc host params, and then the fc class will handle
updating the value if the user writes to the new sysfs file.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |  124 +++++++++++++++++++++++++++-----------
 include/scsi/scsi_transport_fc.h |    7 +-
 2 files changed, 91 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 78486d5..998c01b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -53,6 +53,25 @@ static void fc_bsg_remove(struct request_queue *);
 static void fc_bsg_goose_queue(struct fc_rport *);
 
 /*
+ * Module Parameters
+ */
+
+/*
+ * dev_loss_tmo: the default number of seconds that the FC transport
+ *   should insulate the loss of a remote port.
+ *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
+ */
+static unsigned int fc_dev_loss_tmo = 60;		/* seconds */
+
+module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(dev_loss_tmo,
+		 "Maximum number of seconds that the FC transport should"
+		 " insulate the loss of a remote port. Once this value is"
+		 " exceeded, the scsi target is removed. Value should be"
+		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT if"
+		 " fast_io_fail_tmo is not set.");
+
+/*
  * Redefine so that we can have same named attributes in the
  * sdev/starget/host objects.
  */
@@ -408,6 +427,7 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 	if (!fc_host->work_q)
 		return -ENOMEM;
 
+	fc_host->dev_loss_tmo = fc_dev_loss_tmo;
 	snprintf(fc_host->devloss_work_q_name,
 		 sizeof(fc_host->devloss_work_q_name),
 		 "fc_dl_%d", shost->host_no);
@@ -462,25 +482,6 @@ static DECLARE_TRANSPORT_CLASS(fc_vport_class,
 			       NULL);
 
 /*
- * Module Parameters
- */
-
-/*
- * dev_loss_tmo: the default number of seconds that the FC transport
- *   should insulate the loss of a remote port.
- *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
- */
-static unsigned int fc_dev_loss_tmo = 60;		/* seconds */
-
-module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(dev_loss_tmo,
-		 "Maximum number of seconds that the FC transport should"
-		 " insulate the loss of a remote port. Once this value is"
-		 " exceeded, the scsi target is removed. Value should be"
-		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT if"
-		 " fast_io_fail_tmo is not set.");
-
-/*
  * Netlink Infrastructure
  */
 
@@ -830,24 +831,32 @@ static FC_DEVICE_ATTR(rport, supported_classes, S_IRUGO,
 /*
  * dev_loss_tmo attribute
  */
-fc_rport_show_function(dev_loss_tmo, "%d\n", 20, )
-static ssize_t
-store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
+static int fc_str_to_dev_loss(const char *buf, unsigned long *val)
+{
+	char *cp;
+
+	*val = simple_strtoul(buf, &cp, 0);
+	if ((*cp && (*cp != '\n')) || (*val < 0))
+		return -EINVAL;
+	/*
+	 * Check for overflow; dev_loss_tmo is u32
+	 */
+	if (*val > UINT_MAX)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int fc_rport_set_dev_loss_tmo(struct fc_rport *rport,
+				     unsigned long val)
 {
-	unsigned long val;
-	struct fc_rport *rport = transport_class_to_rport(dev);
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
-	char *cp;
+
 	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
 	    (rport->port_state == FC_PORTSTATE_DELETED) ||
 	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
 		return -EBUSY;
-	val = simple_strtoul(buf, &cp, 0);
-	if ((*cp && (*cp != '\n')) || (val < 0))
-		return -EINVAL;
-
 	/*
 	 * Check for overflow; dev_loss_tmo is u32
 	 */
@@ -863,6 +872,25 @@ store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	i->f->set_rport_dev_loss_tmo(rport, val);
+	return 0;
+}
+
+fc_rport_show_function(dev_loss_tmo, "%d\n", 20, )
+static ssize_t
+store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	unsigned long val;
+	int rc;
+
+	rc = fc_str_to_dev_loss(buf, &val);
+	if (rc)
+		return rc;
+
+	rc = fc_rport_set_dev_loss_tmo(rport, val);
+	if (rc)
+		return rc;
 	return count;
 }
 static FC_DEVICE_ATTR(rport, dev_loss_tmo, S_IRUGO | S_IWUSR,
@@ -1608,8 +1636,35 @@ store_fc_private_host_issue_lip(struct device *dev,
 static FC_DEVICE_ATTR(host, issue_lip, S_IWUSR, NULL,
 			store_fc_private_host_issue_lip);
 
-fc_private_host_rd_attr(npiv_vports_inuse, "%u\n", 20);
+static ssize_t
+store_fc_private_host_dev_loss_tmo(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(dev);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_rport *rport;
+	unsigned long val, flags;
+	int rc;
+
+	rc = fc_str_to_dev_loss(buf, &val);
+	if (rc)
+		return rc;
+
+	fc_host_dev_loss_tmo(shost) = val;
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(rport, &fc_host->rports, peers)
+		fc_rport_set_dev_loss_tmo(rport, val);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return count;
+}
 
+fc_private_host_show_function(dev_loss_tmo, "%d\n", 20, );
+static FC_DEVICE_ATTR(host, dev_loss_tmo, S_IRUGO | S_IWUSR,
+		      show_fc_host_dev_loss_tmo,
+		      store_fc_private_host_dev_loss_tmo);
+
+fc_private_host_rd_attr(npiv_vports_inuse, "%u\n", 20);
 
 /*
  * Host Statistics Management
@@ -2165,6 +2220,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_HOST_ATTRIBUTE_RW(system_hostname);
 
 	/* Transport-managed attributes */
+	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(dev_loss_tmo);
 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
 	if (ft->issue_fc_host_lip)
 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
@@ -2525,11 +2581,7 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 
 	rport->maxframe_size = -1;
 	rport->supported_classes = FC_COS_UNSPECIFIED;
-	if (fci->f->get_host_def_dev_loss_tmo) {
-		fci->f->get_host_def_dev_loss_tmo(shost);
-		rport->dev_loss_tmo = fc_host_def_dev_loss_tmo(shost);
-	} else
-		rport->dev_loss_tmo = fc_dev_loss_tmo;
+	rport->dev_loss_tmo = fc_host->dev_loss_tmo;
 	memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
 	memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
 	rport->port_id = ids->port_id;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 9f98fca..59816fe 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -496,7 +496,7 @@ struct fc_host_attrs {
 	u64 fabric_name;
 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
 	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
-	u32 def_dev_loss_tmo;
+	u32 dev_loss_tmo;
 
 	/* Private (Transport-managed) Attributes */
 	enum fc_tgtid_binding_type  tgtid_bind_type;
@@ -581,8 +581,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q_name)
 #define fc_host_devloss_work_q(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
-#define fc_host_def_dev_loss_tmo(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->def_dev_loss_tmo)
+#define fc_host_dev_loss_tmo(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->dev_loss_tmo)
 
 
 struct fc_bsg_buffer {
@@ -643,7 +643,6 @@ struct fc_function_template {
 	void	(*get_host_fabric_name)(struct Scsi_Host *);
 	void	(*get_host_symbolic_name)(struct Scsi_Host *);
 	void	(*set_host_system_hostname)(struct Scsi_Host *);
-	void	(*get_host_def_dev_loss_tmo)(struct Scsi_Host *);
 
 	struct fc_host_statistics * (*get_fc_host_stats)(struct Scsi_Host *);
 	void	(*reset_fc_host_stats)(struct Scsi_Host *);
-- 
1.7.2.2

