From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 13/18] ib_srp: Allow SRP disconnect through sysfs
Date: Sat, 14 Jan 2012 12:52:10 +0000
Message-ID: <2116892.gZCKSBP7SJ@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Make it possible to disconnect the IB RC connection used by the
SRP protocol to communicate with a target.

Let the SRP transport layer create a sysfs "delete" attribute for
initiator drivers that support this functionality.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-transport-srp |    7 +++++++
 drivers/infiniband/ulp/srp/ib_srp.c          |   26 +++++++++++++++++++++++---
 drivers/infiniband/ulp/srp/ib_srp.h          |    1 +
 drivers/scsi/scsi_transport_srp.c            |   20 +++++++++++++++++++-
 include/scsi/scsi_transport_srp.h            |   10 ++++++++++
 5 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index 7b0d4a5..9b78ace 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -1,3 +1,10 @@
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/delete
+Date:		January 1, 2012
+KernelVersion:	3.3
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Instructs an SRP initiator to disconnect from a target and to
+		remove all LUNs imported from that target.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
 Date:		June 27, 2007
 KernelVersion:	2.6.24
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 67932aa..e8b699b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -600,6 +600,21 @@ static void srp_remove_work(struct work_struct *work)
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
@@ -2002,6 +2021,10 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 		return PTR_ERR(rport);
 	}
 
+	rport->ft = &ib_srp_transport_functions;
+	rport->lld_data = target;
+	target->rport = rport;
+
 	spin_lock(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
 	spin_unlock(&host->target_lock);
@@ -2575,9 +2598,6 @@ static void srp_remove_one(struct ib_device *device)
 	kfree(srp_dev);
 }
 
-static struct srp_function_template ib_srp_transport_functions = {
-};
-
 static int __init srp_init_module(void)
 {
 	int ret;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 3882adf..22e0c5d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -154,6 +154,7 @@ struct srp_target_port {
 	u16			io_class;
 	struct srp_host	       *srp_host;
 	struct Scsi_Host       *scsi_host;
+	struct srp_rport       *rport;
 	char			target_name[32];
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 0d85f79..35f85bc 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -38,7 +38,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 2
+#define SRP_RPORT_ATTRS 3
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -116,6 +116,22 @@ show_srp_rport_roles(struct device *dev, struct device_attribute *attr,
 
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
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
@@ -309,6 +325,8 @@ srp_attach_transport(struct srp_function_template *ft)
 	count = 0;
 	i->rport_attrs[count++] = &dev_attr_port_id;
 	i->rport_attrs[count++] = &dev_attr_roles;
+	if (ft->rport_delete)
+		i->rport_attrs[count++] = &dev_attr_delete;
 	i->rport_attrs[count++] = NULL;
 	BUG_ON(count > ARRAY_SIZE(i->rport_attrs));
 
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 9c60ca1..1a109ff 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -14,13 +14,23 @@ struct srp_rport_identifiers {
 };
 
 struct srp_rport {
+	/* for initiator and target drivers */
+
+	struct srp_function_template *ft;
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


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
