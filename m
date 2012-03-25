From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 13/15] ib_srp: Allow SRP disconnect through sysfs
Date: Sun, 25 Mar 2012 15:01:40 +0000
Message-ID: <12137079.5Hhh1ukOmv@asus>
References: <5207288.nSt5MkVMpO@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:47597 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab2CYPBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Mar 2012 11:01:44 -0400
In-Reply-To: <5207288.nSt5MkVMpO@asus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: dillowda@ornl.gov, roland@purestorage.com, fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com

Make it possible to disconnect the IB RC connection used by the
SRP protocol to communicate with a target.

Let the SRP transport layer create a sysfs "delete" attribute for
initiator drivers that support this functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@purestorage.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 Documentation/ABI/stable/sysfs-transport-srp |    7 +++++++
 drivers/infiniband/ulp/srp/ib_srp.c          |   24 +++++++++++++++++++++---
 drivers/scsi/scsi_transport_srp.c            |   22 +++++++++++++++++++++-
 include/scsi/scsi_transport_srp.h            |    8 ++++++++
 4 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index 7b0d4a5..9fbc703 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -1,3 +1,10 @@
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/delete
+Date:		January 1, 2012
+KernelVersion:	3.4
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	Instructs an SRP initiator to disconnect from a target and to
+		remove all LUNs imported from that target.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
 Date:		June 27, 2007
 KernelVersion:	2.6.24
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 564ff08..9f940a5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -612,6 +612,21 @@ static void srp_remove_work(struct work_struct *work)
 	srp_remove_target(target);
 }
 
+/*
+ * Note: it is up to the caller to ensure that invoking srp_rport_delete()
+ * does not trigger a race against target port removal in srp_remove_target().
+ * As an example, invoking srp_rport_delete() from the SCSI EH is not safe.
+ */
+static void srp_rport_delete(struct srp_rport *rport)
+{
+	struct srp_target_port *target = rport->lld_data;
+
+	BUG_ON(!target);
+
+	if (srp_change_state_to_removed(target))
+		queue_work(system_long_wq, &target->remove_work);
+}
+
 static int srp_connect_target(struct srp_target_port *target)
 {
 	int retries = 3;
@@ -1982,6 +1997,10 @@ static struct scsi_host_template srp_template = {
 	.shost_attrs			= srp_host_attrs
 };
 
+static struct srp_function_template ib_srp_transport_functions = {
+	.rport_delete		 = srp_rport_delete,
+};
+
 static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 {
 	struct srp_rport_identifiers ids;
@@ -2002,6 +2021,8 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 		return PTR_ERR(rport);
 	}
 
+	rport->lld_data = target;
+
 	spin_lock(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
 	spin_unlock(&host->target_lock);
@@ -2576,9 +2597,6 @@ static void srp_remove_one(struct ib_device *device)
 	kfree(srp_dev);
 }
 
-static struct srp_function_template ib_srp_transport_functions = {
-};
-
 static int __init srp_init_module(void)
 {
 	int ret;
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 0d85f79..f379c7f 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -38,7 +38,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 2
+#define SRP_RPORT_ATTRS 3
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -116,6 +116,24 @@ show_srp_rport_roles(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(roles, S_IRUGO, show_srp_rport_roles, NULL);
 
+static ssize_t store_srp_rport_delete(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+
+	if (i->f->rport_delete) {
+		i->f->rport_delete(rport);
+		return count;
+	} else {
+		return -ENOSYS;
+	}
+}
+
+static DEVICE_ATTR(delete, S_IWUSR, NULL, store_srp_rport_delete);
+
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
@@ -309,6 +327,8 @@ srp_attach_transport(struct srp_function_template *ft)
 	count = 0;
 	i->rport_attrs[count++] = &dev_attr_port_id;
 	i->rport_attrs[count++] = &dev_attr_roles;
+	if (ft->rport_delete)
+		i->rport_attrs[count++] = &dev_attr_delete;
 	i->rport_attrs[count++] = NULL;
 	BUG_ON(count > ARRAY_SIZE(i->rport_attrs));
 
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 9c60ca1..f47549f 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -14,13 +14,21 @@ struct srp_rport_identifiers {
 };
 
 struct srp_rport {
+	/* for initiator and target drivers */
+
 	struct device dev;
 
 	u8 port_id[16];
 	u8 roles;
+
+	/* for initiator drivers */
+
+	void			*lld_data;	/* LLD private data */
 };
 
 struct srp_function_template {
+	/* for initiator drivers */
+	void (*rport_delete)(struct srp_rport *rport);
 	/* for target drivers */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
-- 
1.7.7


