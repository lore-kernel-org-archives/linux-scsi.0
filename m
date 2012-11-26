From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 11/11] IB/srp: Allow SRP disconnect through sysfs
Date: Sun, 25 Nov 2012 23:44:16 -0500
Message-ID: <d2ae51f49347286e58015c6dee11aca7c6cbb119.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
In-Reply-To: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
References: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Make it possible to disconnect the IB RC connection used by the
SRP protocol to communicate with a target.

Let the SRP transport layer create a sysfs "delete" attribute for
initiator drivers that support this functionality.

Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-transport-srp |    7 +++++++
 drivers/infiniband/ulp/srp/ib_srp.c          |   10 ++++++++++
 drivers/scsi/scsi_transport_srp.c            |   22 +++++++++++++++++++++-
 include/scsi/scsi_transport_srp.h            |    8 ++++++++
 4 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index 7b0d4a5..b36fb0d 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -1,3 +1,10 @@
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/delete
+Date:		June 1, 2012
+KernelVersion:	3.7
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Instructs an SRP initiator to disconnect from a target and to
+		remove all LUNs imported from that target.
+
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
 Date:		June 27, 2007
 KernelVersion:	2.6.24
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c0cc245..8b987bf 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -551,6 +551,13 @@ static void srp_queued_remove(struct srp_target_port *target)
 	}
 }
 
+static void srp_rport_delete(struct srp_rport *rport)
+{
+	struct srp_target_port *target = rport->lld_data;
+
+	srp_queued_remove(target);
+}
+
 static int srp_connect_target(struct srp_target_port *target)
 {
 	int retries = 3;
@@ -1955,6 +1962,8 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 		return PTR_ERR(rport);
 	}
 
+	rport->lld_data = target;
+
 	spin_lock(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
 	spin_unlock(&host->target_lock);
@@ -2516,6 +2525,7 @@ static void srp_remove_one(struct ib_device *device)
 }
 
 static struct srp_function_template ib_srp_transport_functions = {
+	.rport_delete		 = srp_rport_delete,
 };
 
 static int __init srp_init_module(void)
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
index 9c60ca1..ff0f04a 100644
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
+	void *lld_data;	/* LLD private data */
 };
 
 struct srp_function_template {
+	/* for initiator drivers */
+	void (*rport_delete)(struct srp_rport *rport);
 	/* for target drivers */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
