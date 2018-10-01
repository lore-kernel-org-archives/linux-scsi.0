From: Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH] driver core: device: add BUS_ATTR_WO macro
Date: Mon,  1 Oct 2018 18:32:52 +0300
Message-ID: <1538407972-9340-1-git-send-email-ioana.ciornei@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, idryomov@gmail.com, sage@redhat.com, elder@kernel.org, jth@kernel.org, benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
List-Id: linux-scsi@vger.kernel.org

Add BUS_ATTR_WO macro to make it easier to add attributes without
auditing the mode settings. Also, use the newly added macro where
appropriate.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 arch/powerpc/platforms/pseries/ibmebus.c | 12 ++++----
 drivers/block/rbd.c                      | 48 ++++++++++++++++----------------
 drivers/scsi/fcoe/fcoe_sysfs.c           |  4 +--
 drivers/scsi/fcoe/fcoe_transport.c       | 10 +++----
 include/linux/device.h                   |  2 ++
 include/scsi/libfcoe.h                   |  8 +++---
 6 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/ibmebus.c b/arch/powerpc/platforms/pseries/ibmebus.c
index c7c1140..c75006c 100644
--- a/arch/powerpc/platforms/pseries/ibmebus.c
+++ b/arch/powerpc/platforms/pseries/ibmebus.c
@@ -261,8 +261,8 @@ static char *ibmebus_chomp(const char *in, size_t count)
 	return out;
 }
 
-static ssize_t ibmebus_store_probe(struct bus_type *bus,
-				   const char *buf, size_t count)
+static ssize_t probe_store(struct bus_type *bus,
+			   const char *buf, size_t count)
 {
 	struct device_node *dn = NULL;
 	struct device *dev;
@@ -298,10 +298,10 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
 		return rc;
 	return count;
 }
-static BUS_ATTR(probe, 0200, NULL, ibmebus_store_probe);
+static BUS_ATTR_WO(probe);
 
-static ssize_t ibmebus_store_remove(struct bus_type *bus,
-				    const char *buf, size_t count)
+static ssize_t remove_store(struct bus_type *bus,
+			    const char *buf, size_t count)
 {
 	struct device *dev;
 	char *path;
@@ -325,7 +325,7 @@ static ssize_t ibmebus_store_remove(struct bus_type *bus,
 		return -ENODEV;
 	}
 }
-static BUS_ATTR(remove, 0200, NULL, ibmebus_store_remove);
+static BUS_ATTR_WO(remove);
 
 static struct attribute *ibmbus_bus_attrs[] = {
 	&bus_attr_probe.attr,
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 73ed5f3..703d875 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -428,14 +428,14 @@ enum rbd_dev_flags {
 module_param(single_major, bool, 0444);
 MODULE_PARM_DESC(single_major, "Use a single major number for all rbd devices (default: true)");
 
-static ssize_t rbd_add(struct bus_type *bus, const char *buf,
-		       size_t count);
-static ssize_t rbd_remove(struct bus_type *bus, const char *buf,
-			  size_t count);
-static ssize_t rbd_add_single_major(struct bus_type *bus, const char *buf,
-				    size_t count);
-static ssize_t rbd_remove_single_major(struct bus_type *bus, const char *buf,
-				       size_t count);
+static ssize_t add_store(struct bus_type *bus, const char *buf,
+			 size_t count);
+static ssize_t remove_store(struct bus_type *bus, const char *buf,
+			    size_t count);
+static ssize_t add_single_major_store(struct bus_type *bus, const char *buf,
+				      size_t count);
+static ssize_t remove_single_major_store(struct bus_type *bus, const char *buf,
+					 size_t count);
 static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth);
 
 static int rbd_dev_id_to_minor(int dev_id)
@@ -469,10 +469,10 @@ static ssize_t rbd_supported_features_show(struct bus_type *bus, char *buf)
 	return sprintf(buf, "0x%llx\n", RBD_FEATURES_SUPPORTED);
 }
 
-static BUS_ATTR(add, 0200, NULL, rbd_add);
-static BUS_ATTR(remove, 0200, NULL, rbd_remove);
-static BUS_ATTR(add_single_major, 0200, NULL, rbd_add_single_major);
-static BUS_ATTR(remove_single_major, 0200, NULL, rbd_remove_single_major);
+static BUS_ATTR_WO(add);
+static BUS_ATTR_WO(remove);
+static BUS_ATTR_WO(add_single_major);
+static BUS_ATTR_WO(remove_single_major);
 static BUS_ATTR(supported_features, 0444, rbd_supported_features_show, NULL);
 
 static struct attribute *rbd_bus_attrs[] = {
@@ -5930,9 +5930,9 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 	goto out;
 }
 
-static ssize_t rbd_add(struct bus_type *bus,
-		       const char *buf,
-		       size_t count)
+static ssize_t add_store(struct bus_type *bus,
+			 const char *buf,
+			 size_t count)
 {
 	if (single_major)
 		return -EINVAL;
@@ -5940,9 +5940,9 @@ static ssize_t rbd_add(struct bus_type *bus,
 	return do_rbd_add(bus, buf, count);
 }
 
-static ssize_t rbd_add_single_major(struct bus_type *bus,
-				    const char *buf,
-				    size_t count)
+static ssize_t add_single_major_store(struct bus_type *bus,
+				      const char *buf,
+				      size_t count)
 {
 	return do_rbd_add(bus, buf, count);
 }
@@ -6046,9 +6046,9 @@ static ssize_t do_rbd_remove(struct bus_type *bus,
 	return count;
 }
 
-static ssize_t rbd_remove(struct bus_type *bus,
-			  const char *buf,
-			  size_t count)
+static ssize_t remove_store(struct bus_type *bus,
+			    const char *buf,
+			    size_t count)
 {
 	if (single_major)
 		return -EINVAL;
@@ -6056,9 +6056,9 @@ static ssize_t rbd_remove(struct bus_type *bus,
 	return do_rbd_remove(bus, buf, count);
 }
 
-static ssize_t rbd_remove_single_major(struct bus_type *bus,
-				       const char *buf,
-				       size_t count)
+static ssize_t remove_single_major_store(struct bus_type *bus,
+					 const char *buf,
+					 size_t count)
 {
 	return do_rbd_remove(bus, buf, count);
 }
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 5c8310b..3c23b26 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -671,8 +671,8 @@ static void fcoe_fcf_device_release(struct device *dev)
 	.release = fcoe_fcf_device_release,
 };
 
-static BUS_ATTR(ctlr_create, S_IWUSR, NULL, fcoe_ctlr_create_store);
-static BUS_ATTR(ctlr_destroy, S_IWUSR, NULL, fcoe_ctlr_destroy_store);
+static BUS_ATTR_WO(ctlr_create);
+static BUS_ATTR_WO(ctlr_destroy);
 
 static struct attribute *fcoe_bus_attrs[] = {
 	&bus_attr_ctlr_create.attr,
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index f4909cd..7789141 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -754,8 +754,8 @@ static int libfcoe_device_notification(struct notifier_block *notifier,
 	return NOTIFY_OK;
 }
 
-ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
-			       const char *buf, size_t count)
+ssize_t ctlr_create_store(struct bus_type *bus,
+			  const char *buf, size_t count)
 {
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
@@ -817,8 +817,8 @@ ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
 	return count;
 }
 
-ssize_t fcoe_ctlr_destroy_store(struct bus_type *bus,
-				const char *buf, size_t count)
+ssize_t ctlr_destroy_store(struct bus_type *bus,
+			   const char *buf, size_t count)
 {
 	int rc = -ENODEV;
 	struct net_device *netdev = NULL;
@@ -855,7 +855,7 @@ ssize_t fcoe_ctlr_destroy_store(struct bus_type *bus,
 	mutex_unlock(&ft_mutex);
 	return rc;
 }
-EXPORT_SYMBOL(fcoe_ctlr_destroy_store);
+EXPORT_SYMBOL(ctlr_destroy_store);
 
 /**
  * fcoe_transport_create() - Create a fcoe interface
diff --git a/include/linux/device.h b/include/linux/device.h
index 8f88254..767cf19 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -55,6 +55,8 @@ struct bus_attribute {
 	struct bus_attribute bus_attr_##_name = __ATTR_RW(_name)
 #define BUS_ATTR_RO(_name) \
 	struct bus_attribute bus_attr_##_name = __ATTR_RO(_name)
+#define BUS_ATTR_WO(_name) \
+	struct bus_attribute bus_attr_##_name = __ATTR_WO(_name)
 
 extern int __must_check bus_create_file(struct bus_type *,
 					struct bus_attribute *);
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index cb8a273..f58388c 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -405,10 +405,10 @@ struct fcoe_netdev_mapping {
 int fcoe_transport_detach(struct fcoe_transport *ft);
 
 /* sysfs store handler for ctrl_control interface */
-ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
-			       const char *buf, size_t count);
-ssize_t fcoe_ctlr_destroy_store(struct bus_type *bus,
-				const char *buf, size_t count);
+ssize_t ctlr_create_store(struct bus_type *bus,
+			  const char *buf, size_t count);
+ssize_t ctlr_destroy_store(struct bus_type *bus,
+			   const char *buf, size_t count);
 
 #endif /* _LIBFCOE_H */
 
-- 
1.9.1
