From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH] fs: configfs: don't return anything from drop_link
Date: Mon, 28 Nov 2016 13:22:42 +0100
Message-ID: <1480335762-26408-1-git-send-email-andrzej.p@samsung.com>
References: <CGME20161128122258eucas1p2c3543f6795fe54c07175a5f5fbae0765@eucas1p2.samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36235 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754818AbcK1MXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2016 07:23:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Joel Becker <jlbec@evilplan.org>, linux-doc@vger.kernel.org, b.zolnierkie@samsung.com

Documentation/filesystems/configfs/configfs.txt says:

"When unlink(2) is called on the symbolic link, the source item is
notified via the ->drop_link() method.  Like the ->drop_item() method,
this is a void function and cannot return failure."

The ->drop_item() is indeed a void function, the ->drop_link() is
actually not. This, together with the fact that the value of ->drop_link()
is silently ignored suggests, that it is the ->drop_link() return
type that should be corrected and changed to void.

This patch changes drop_link() signature and all its users.

Compile-tested only! It needs Tested-by from respective subsystems.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 Documentation/filesystems/configfs/configfs.txt |  2 +-
 drivers/nvme/target/configfs.c                  | 46 ++++++++++---------------
 drivers/target/target_core_fabric_configfs.c    |  7 ++--
 drivers/usb/gadget/configfs.c                   |  8 ++---
 drivers/usb/gadget/function/uvc_configfs.c      | 25 +++-----------
 include/linux/configfs.h                        |  2 +-
 6 files changed, 31 insertions(+), 59 deletions(-)

diff --git a/Documentation/filesystems/configfs/configfs.txt b/Documentation/filesystems/configfs/configfs.txt
index 8ec9136..3828e85 100644
--- a/Documentation/filesystems/configfs/configfs.txt
+++ b/Documentation/filesystems/configfs/configfs.txt
@@ -174,7 +174,7 @@ among other things.  For that, it needs a type.
 		void (*release)(struct config_item *);
 		int (*allow_link)(struct config_item *src,
 				  struct config_item *target);
-		int (*drop_link)(struct config_item *src,
+		void (*drop_link)(struct config_item *src,
 				 struct config_item *target);
 	};
 
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index af5e2dc..9ee1490 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -466,7 +466,7 @@ static int nvmet_port_subsys_allow_link(struct config_item *parent,
 	return ret;
 }
 
-static int nvmet_port_subsys_drop_link(struct config_item *parent,
+static void nvmet_port_subsys_drop_link(struct config_item *parent,
 		struct config_item *target)
 {
 	struct nvmet_port *port = to_nvmet_port(parent->ci_parent);
@@ -474,21 +474,16 @@ static int nvmet_port_subsys_drop_link(struct config_item *parent,
 	struct nvmet_subsys_link *p;
 
 	down_write(&nvmet_config_sem);
-	list_for_each_entry(p, &port->subsystems, entry) {
-		if (p->subsys == subsys)
-			goto found;
-	}
-	up_write(&nvmet_config_sem);
-	return -EINVAL;
-
-found:
-	list_del(&p->entry);
-	nvmet_genctr++;
-	if (list_empty(&port->subsystems))
-		nvmet_disable_port(port);
+	list_for_each_entry(p, &port->subsystems, entry)
+		if (p->subsys == subsys) {
+			list_del(&p->entry);
+			nvmet_genctr++;
+			if (list_empty(&port->subsystems))
+				nvmet_disable_port(port);
+			kfree(p);
+			break;
+		}
 	up_write(&nvmet_config_sem);
-	kfree(p);
-	return 0;
 }
 
 static struct configfs_item_operations nvmet_port_subsys_item_ops = {
@@ -542,7 +537,7 @@ static int nvmet_allowed_hosts_allow_link(struct config_item *parent,
 	return ret;
 }
 
-static int nvmet_allowed_hosts_drop_link(struct config_item *parent,
+static void nvmet_allowed_hosts_drop_link(struct config_item *parent,
 		struct config_item *target)
 {
 	struct nvmet_subsys *subsys = to_subsys(parent->ci_parent);
@@ -550,19 +545,14 @@ static int nvmet_allowed_hosts_drop_link(struct config_item *parent,
 	struct nvmet_host_link *p;
 
 	down_write(&nvmet_config_sem);
-	list_for_each_entry(p, &subsys->hosts, entry) {
-		if (!strcmp(nvmet_host_name(p->host), nvmet_host_name(host)))
-			goto found;
-	}
-	up_write(&nvmet_config_sem);
-	return -EINVAL;
-
-found:
-	list_del(&p->entry);
-	nvmet_genctr++;
+	list_for_each_entry(p, &subsys->hosts, entry)
+		if (!strcmp(nvmet_host_name(p->host), nvmet_host_name(host))) {
+			list_del(&p->entry);
+			nvmet_genctr++;
+			kfree(p);
+			break;
+		}
 	up_write(&nvmet_config_sem);
-	kfree(p);
-	return 0;
 }
 
 static struct configfs_item_operations nvmet_allowed_hosts_item_ops = {
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 31a096a..d8a16ca 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -137,7 +137,7 @@ static int target_fabric_mappedlun_link(
 	return core_dev_add_initiator_node_lun_acl(se_tpg, lacl, lun, lun_access_ro);
 }
 
-static int target_fabric_mappedlun_unlink(
+static void target_fabric_mappedlun_unlink(
 	struct config_item *lun_acl_ci,
 	struct config_item *lun_ci)
 {
@@ -146,7 +146,7 @@ static int target_fabric_mappedlun_unlink(
 	struct se_lun *lun = container_of(to_config_group(lun_ci),
 			struct se_lun, lun_group);
 
-	return core_dev_del_initiator_node_lun_acl(lun, lacl);
+	core_dev_del_initiator_node_lun_acl(lun, lacl);
 }
 
 static struct se_lun_acl *item_to_lun_acl(struct config_item *item)
@@ -669,7 +669,7 @@ static int target_fabric_port_link(
 	return ret;
 }
 
-static int target_fabric_port_unlink(
+static void target_fabric_port_unlink(
 	struct config_item *lun_ci,
 	struct config_item *se_dev_ci)
 {
@@ -688,7 +688,6 @@ static int target_fabric_port_unlink(
 	}
 
 	core_dev_del_lun(se_tpg, lun);
-	return 0;
 }
 
 static void target_fabric_port_release(struct config_item *item)
diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 3984787..78c4497 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -408,7 +408,7 @@ static int config_usb_cfg_link(
 	return ret;
 }
 
-static int config_usb_cfg_unlink(
+static void config_usb_cfg_unlink(
 	struct config_item *usb_cfg_ci,
 	struct config_item *usb_func_ci)
 {
@@ -437,12 +437,11 @@ static int config_usb_cfg_unlink(
 			list_del(&f->list);
 			usb_put_function(f);
 			mutex_unlock(&gi->lock);
-			return 0;
+			return;
 		}
 	}
 	mutex_unlock(&gi->lock);
 	WARN(1, "Unable to locate function to unbind\n");
-	return 0;
 }
 
 static struct configfs_item_operations gadget_config_item_ops = {
@@ -865,7 +864,7 @@ static int os_desc_link(struct config_item *os_desc_ci,
 	return ret;
 }
 
-static int os_desc_unlink(struct config_item *os_desc_ci,
+static void os_desc_unlink(struct config_item *os_desc_ci,
 			  struct config_item *usb_cfg_ci)
 {
 	struct gadget_info *gi = container_of(to_config_group(os_desc_ci),
@@ -878,7 +877,6 @@ static int os_desc_unlink(struct config_item *os_desc_ci,
 	cdev->os_desc_config = NULL;
 	WARN_ON(gi->composite.gadget_driver.udc_name);
 	mutex_unlock(&gi->lock);
-	return 0;
 }
 
 static struct configfs_item_operations os_desc_ops = {
diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 31125a4..4e037d2 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -547,7 +547,7 @@ static int uvcg_control_class_allow_link(struct config_item *src,
 	return ret;
 }
 
-static int uvcg_control_class_drop_link(struct config_item *src,
+static void uvcg_control_class_drop_link(struct config_item *src,
 					struct config_item *target)
 {
 	struct config_item *control, *header;
@@ -555,7 +555,6 @@ static int uvcg_control_class_drop_link(struct config_item *src,
 	struct mutex *su_mutex = &src->ci_group->cg_subsys->su_mutex;
 	struct uvc_descriptor_header **class_array;
 	struct uvcg_control_header *target_hdr;
-	int ret = -EINVAL;
 
 	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
 
@@ -569,23 +568,17 @@ static int uvcg_control_class_drop_link(struct config_item *src,
 	mutex_lock(&opts->lock);
 
 	class_array = uvcg_get_ctl_class_arr(src, opts);
-	if (!class_array)
-		goto unlock;
-	if (opts->refcnt) {
-		ret = -EBUSY;
+	if (!class_array || opts->refcnt)
 		goto unlock;
-	}
 
 	target_hdr = to_uvcg_control_header(target);
 	--target_hdr->linked;
 	class_array[0] = NULL;
-	ret = 0;
 
 unlock:
 	mutex_unlock(&opts->lock);
 out:
 	mutex_unlock(su_mutex);
-	return ret;
 }
 
 static struct configfs_item_operations uvcg_control_class_item_ops = {
@@ -777,7 +770,7 @@ static int uvcg_streaming_header_allow_link(struct config_item *src,
 	return ret;
 }
 
-static int uvcg_streaming_header_drop_link(struct config_item *src,
+static void uvcg_streaming_header_drop_link(struct config_item *src,
 					   struct config_item *target)
 {
 	struct mutex *su_mutex = &src->ci_group->cg_subsys->su_mutex;
@@ -786,7 +779,6 @@ static int uvcg_streaming_header_drop_link(struct config_item *src,
 	struct uvcg_streaming_header *src_hdr;
 	struct uvcg_format *target_fmt = NULL;
 	struct uvcg_format_ptr *format_ptr, *tmp;
-	int ret = -EINVAL;
 
 	src_hdr = to_uvcg_streaming_header(src);
 	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
@@ -811,8 +803,6 @@ static int uvcg_streaming_header_drop_link(struct config_item *src,
 out:
 	mutex_unlock(&opts->lock);
 	mutex_unlock(su_mutex);
-	return ret;
-
 }
 
 static struct configfs_item_operations uvcg_streaming_header_item_ops = {
@@ -2051,7 +2041,7 @@ static int uvcg_streaming_class_allow_link(struct config_item *src,
 	return ret;
 }
 
-static int uvcg_streaming_class_drop_link(struct config_item *src,
+static void uvcg_streaming_class_drop_link(struct config_item *src,
 					  struct config_item *target)
 {
 	struct config_item *streaming, *header;
@@ -2059,7 +2049,6 @@ static int uvcg_streaming_class_drop_link(struct config_item *src,
 	struct mutex *su_mutex = &src->ci_group->cg_subsys->su_mutex;
 	struct uvc_descriptor_header ***class_array;
 	struct uvcg_streaming_header *target_hdr;
-	int ret = -EINVAL;
 
 	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
 
@@ -2076,23 +2065,19 @@ static int uvcg_streaming_class_drop_link(struct config_item *src,
 	if (!class_array || !*class_array)
 		goto unlock;
 
-	if (opts->refcnt) {
-		ret = -EBUSY;
+	if (opts->refcnt)
 		goto unlock;
-	}
 
 	target_hdr = to_uvcg_streaming_header(target);
 	--target_hdr->linked;
 	kfree(**class_array);
 	kfree(*class_array);
 	*class_array = NULL;
-	ret = 0;
 
 unlock:
 	mutex_unlock(&opts->lock);
 out:
 	mutex_unlock(su_mutex);
-	return ret;
 }
 
 static struct configfs_item_operations uvcg_streaming_class_item_ops = {
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index d9d6a9d..9a30b92 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -228,7 +228,7 @@ struct configfs_bin_attribute {
 struct configfs_item_operations {
 	void (*release)(struct config_item *);
 	int (*allow_link)(struct config_item *src, struct config_item *target);
-	int (*drop_link)(struct config_item *src, struct config_item *target);
+	void (*drop_link)(struct config_item *src, struct config_item *target);
 };
 
 struct configfs_group_operations {
-- 
1.9.1

