From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 14/14] ib_srp: Allow SRP disconnect through sysfs
Date: Thu, 1 Dec 2011 20:13:33 +0100
Message-ID: <201112012013.33246.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:50040 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab1LATNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 14:13:36 -0500
In-Reply-To: <201112011954.25811.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, David Dillow <dillowda@ornl.gov>, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

Make it possible to disconnect via sysfs the IB RC connection used by the
SRP protocol to communicate with a target.

Let the SRP transport layer create a sysfs "delete" attribute for
initiator drivers that support this functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@purestorage.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 Documentation/ABI/stable/sysfs-transport-srp |    7 ++++
 drivers/infiniband/ulp/srp/ib_srp.c          |   44 +++++++++++++++----------
 drivers/scsi/scsi_transport_srp.c            |   20 +++++++++++-
 include/scsi/scsi_transport_srp.h            |    1 +
 4 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index d8a9048..b1c8acd 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -1,3 +1,10 @@
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/delete
+Date:		November 1, 2011
+KernelVersion:	3.3
+Contact:	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
+Description:	Instructs an SRP initiator to disconnect from a target and to
+		remove all LUNs imported from that target.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/ping_interval
 Date:		November 1, 2011
 KernelVersion:	3.3
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 82057f2..f7e0224 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -579,6 +579,28 @@ static void srp_remove_work(struct work_struct *work)
 	srp_remove_target(target);
 }
 
+static void srp_rport_delete(struct srp_rport *rport)
+{
+	struct srp_target_port *target = rport->lld_data;
+	struct srp_host *host = target->srp_host;
+	bool remove = false;
+
+	/*
+	 * Schedule our work inside the lock to avoid a race with
+	 * the flush_work_sync() call in srp_remove_one().
+	 */
+	spin_lock(&host->target_lock);
+	spin_lock_irq(&target->lock);
+	if (target->state != SRP_TARGET_REMOVED) {
+		target->state = SRP_TARGET_REMOVED;
+		remove = true;
+	}
+	spin_unlock_irq(&target->lock);
+	if (remove)
+		queue_work(system_long_wq, &target->remove_work);
+	spin_unlock(&host->target_lock);
+}
+
 static void srp_ping_timedout(struct srp_rport *rport)
 {
 	struct srp_target_port *target = rport->lld_data;
@@ -1879,9 +1901,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 static int srp_reset_host(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
-	struct srp_host *host = target->srp_host;
 	int ret = FAILED;
-	bool remove = false;
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
 
@@ -1893,23 +1913,10 @@ static int srp_reset_host(struct scsi_cmnd *scmnd)
 		 * However, we have to defer the real removal because we
 		 * are in the context of the SCSI error handler now, which
 		 * will deadlock if we call scsi_remove_host().
-		 *
-		 * Schedule our work inside the lock to avoid a race with
-		 * the flush_work_sync() call in srp_remove_one().
 		 */
-		spin_lock(&host->target_lock);
-		spin_lock_irq(&target->lock);
-		if (target->state != SRP_TARGET_REMOVED) {
-			target->state = SRP_TARGET_REMOVED;
-			remove = true;
-		}
-		spin_unlock_irq(&target->lock);
-		if (remove) {
-			shost_printk(KERN_ERR, target->scsi_host, PFX "recon"
-				     "nect failed, removing target port.\n");
-			queue_work(system_long_wq, &target->remove_work);
-		}
-		spin_unlock(&host->target_lock);
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "reconnect failed, removing target port.\n");
+		srp_rport_delete(target->rport);
 	}
 
 	return ret;
@@ -2131,6 +2138,7 @@ static struct scsi_host_template srp_template = {
 };
 
 static struct srp_function_template ib_srp_transport_functions = {
+	.rport_delete		 = srp_rport_delete,
 	.rport_ping_timedout	 = srp_ping_timedout,
 	.rport_recovery_timedout = srp_recovery_timedout,
 };
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 135a870..e0359b4 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -40,7 +40,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 5
+#define SRP_RPORT_ATTRS 6
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -118,6 +118,22 @@ show_srp_rport_roles(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(roles, S_IRUGO, show_srp_rport_roles, NULL);
 
+static ssize_t store_srp_rport_delete(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	if (rport->ft->rport_delete) {
+		rport->ft->rport_delete(rport);
+		return count;
+	} else {
+		return -ENOSYS;
+	}
+}
+
+static DEVICE_ATTR(delete, S_IWUSR, NULL, store_srp_rport_delete);
+
 static ssize_t show_srp_rport_ping_interval(struct device *dev,
 					   struct device_attribute *attr,
 					   char *buf)
@@ -635,6 +651,8 @@ srp_attach_transport(struct srp_function_template *ft)
 	}
 	if (ft->rport_recovery_timedout)
 		i->rport_attrs[count++] = &dev_attr_recovery_tmo;
+	if (ft->rport_delete)
+		i->rport_attrs[count++] = &dev_attr_delete;
 	i->rport_attrs[count++] = NULL;
 	WARN_ON(count > ARRAY_SIZE(i->rport_attrs));
 
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 565cb79..8782d6a 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -51,6 +51,7 @@ struct srp_rport {
 
 struct srp_function_template {
 	/* for initiator drivers */
+	void (*rport_delete)(struct srp_rport *rport);
 	void (*rport_ping_timedout) (struct srp_rport *rport);
 	void (*rport_recovery_timedout) (struct srp_rport *rport);
 	/* for target drivers */
-- 
1.7.3.4

