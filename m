From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/8] [SCSI] scst: Remove [key] marker from sysfs files
Date: Mon, 27 Dec 2010 14:38:31 +0100
Message-ID: <201012271438.31926.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:52027 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0L0Niu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 08:38:50 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

While the '[key]' marker on the second line of sysfs files is convenient
for user-space tools that save the SCST state (e.g. scstadmin) to find
out whether or not a value is a default value, remove this marker to make
the contents of sysfs files created by SCST uniform with other sysfs
files.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
---
 .../ABI/stable/sysfs-devices-scst_tgt_dev          |    1 -
 Documentation/scst/SysfsRules                      |  160 --------------------
 drivers/scst/dev_handlers/scst_vdisk.c             |   62 ++------
 drivers/scst/scst_local/scst_local.c               |   10 +-
 drivers/scst/scst_sysfs.c                          |   66 +++------
 include/scst/scst_const.h                          |    2 -
 6 files changed, 34 insertions(+), 267 deletions(-)
 delete mode 100644 Documentation/scst/SysfsRules

diff --git a/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
index a7d5070..2048875 100644
--- a/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
+++ b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
@@ -24,7 +24,6 @@ Description:
 
 		# cat /sys/devices/disk01/filename
 		/dev/sdc
-		[key]
 
 What:		/sys/bus/scst_tgt_dev/device/*/nv_cache
 Date:		December 2010
diff --git a/Documentation/scst/SysfsRules b/Documentation/scst/SysfsRules
deleted file mode 100644
index 5790511..0000000
--- a/Documentation/scst/SysfsRules
+++ /dev/null
@@ -1,160 +0,0 @@
-		SCST SYSFS interface rules
-		==========================
-
-This document explains the rules SCST target drivers, device handlers and
-management utilities must adhere to. These rules make it possible for a
-user space tool like scstadmin to save and restore the entire state of the
-SCST core, target drivers and device handlers.
-
-If the last line of a modifiable sysfs attribute contains the text "[key]",
-this means the value of that attribute is not the default value of that
-attribute. That text is added by SCST when such an attribute is read but
-must not be added when modifying an SCST sysfs attribute.
-
-I. Rules for target drivers
-===========================
-
-The SCST core creates a directory for each target driver (struct
-scst_tgt_template) in /sys/bus/scst_target. And for each SCSI target (struct
-scst_tgt) the SCST core creates a directory in /sys/bus/scst_target/devices/.
-
-There are two types of SCSI targets, namely hardware and virtual.  Hardware
-targets are targets corresponding to a hardware entity, e.g. a port of a Fibre
-Channel adapter or an InfiniBand HCA. Virtual targets can be added and removed
-dynamically and do not have a one-to-one correspondence to hardware. As an
-example, iSCSI targets and NPIV Fibre Channel targets are virtual targets.
-
-Virtual targets are created and removed via the commands "add_target" and
-"del_target" respectively.
-
-A target driver that supports both hardware targets and virtual targets
-(e.g. an FC adapter that supports NPIV) must mark each hardware target with
-"hw_target" (see further).
-
-Querying the current state
---------------------------
-
-Querying the current state is possible by reading individual sysfs attributes.
-As an example, querying the state of the SCST core, all device drivers and
-target drivers is possible as follows:
-
-# find /sys/devices/scst /sys/bus/scst_target /sys/bus/scst_tgt_dev -type f -perm -u+r | xargs head
-
-Modifying the current state
----------------------------
-
-If a sysfs attribute has write permission, it can be modified by writing a new
-value into that attribute. Many management actions though happen via the
-"mgmt" attribute of the SCST device itself. The documentation of the syntax of
-the management commands can be revealed by reading that attribute. An example:
-
-# cd /sys/devices/scst
-# cat mgmt
-[ ... ]
-# cat /sys/devices/disk01/threads_num
-6
-[key]
-# echo "in device/disk01 set_threads_num 1" >mgmt
-# cat /sys/devices/disk01/threads_num
-1
-[key]
-
-
-II. Rules for device handlers
-=============================
-
-There are two types of device handlers: parent device handlers and child
-device handlers. The child device handlers depend on their parent device
-handler.
-
-The SCST core creates a directory for each parent device handler (struct
-scst_dev_type where the parent member equals NULL) in
-/sys/bus/scst_tgt_dev/driver. Parent device handlers can have one or more
-subdirectories for child device handlers.
-
-Only one level is allowed in the parent/child hierarchy. Parent device
-handlers that support child device handlers must not handle devices themselves.
-
-In this document child device handlers and parent device handlers without
-child device handlers will be called "end level device handlers".
-
-For each device (struct scst_device) the SCST core creates a directory in
-/sys/bus/scst_tgt_dev.
-
-Device handler attributes
--------------------------
-
-The following attributes may be supported for a device handler:
-
-1. "trace_level" - Allows to query and/or modify the log level for a device
-handler.
-
-2. "add_device_parameters" - Parameters supported by the add_device command.
-
-3. "driver_attributes" - Attributes supported by the add_attribute and
-del_attribute commands.
-
-4. "device_attributes" - Attributes supported by the add_device_attribute and
-del_device_attribute commands.
-
-5. "type" - SCSI device type. A number followed by a description, e.g.:
-
-# cat /sys/bus/scst_tgt_dev/drivers/vcdrom/type
-5 - CD-ROM device
-
-
-Device attributes
------------------
-
-The following attributes may be supported for a device:
-
-1. blocksize - Native SCSI block size of this device.
-
-2. filename - For virtual devices, the path of the associated file or device.
-An example:
-
-# cat /sys/devices/disk01/filename
-/dev/sdc
-[key]
-
-3. nv_cache - Whether or not the device has a non-volatile cache. SCST uses
-this information to decide whether or not it is safe to acknowledge writes
-early to the initiator. Setting this attribute to 1 for a device that neither
-has a non-volatile cache nor an UPS will decrease I/O latency but may result
-in data loss in case of a power failure.
-
-4. o_direct - For virtual devices that use file I/O, whether to use
-non-buffered (direct) I/O or buffered (asynchronous) I/O. In direct I/O mode
-both read and write caching is disabled.
-
-5. read_only - For virtual devices, whether or not to deny write commands.
-
-6. removable - For virtual devices, whether or not the underlying storage
-medium is removable.
-
-7. resync_size - For virtual devices, writing to this attribute will update
-the internally cached device size.
-
-8. size_mb - For virtual devices, the internally cached size in MB of the
-underlying storage device.
-
-9. t10_dev_id - SCSI device ID associated with the virtual device. This is the
-ID reported via the Device Identification page (0x83) of the INQUIRY command.
-
-10. thin_provisioned - Whether or not the virtual device supports thin
-provisioning.
-
-11. threads_num - Number of threads that exist in the thread pool that is
-used for processing SCSI commands for this device.
-
-12. threads_pool_type - Whether to use a distinct thread pool per initiator
-("per_initiator") or one thread pool for all initiators accessing this device
-("shared").
-
-13. type - SCSI type of this device.
-
-14. usn - Unique serial number as reported in the SCSI INQUIRY response.
-
-15. write_through - Allows to disable write-back caching for virtual devices.
-
-See also the SCST core README for more information about those attributes.
diff --git a/drivers/scst/dev_handlers/scst_vdisk.c b/drivers/scst/dev_handlers/scst_vdisk.c
index 0700c60..cb41962 100644
--- a/drivers/scst/dev_handlers/scst_vdisk.c
+++ b/drivers/scst/dev_handlers/scst_vdisk.c
@@ -532,7 +532,7 @@ static char *__vdev_get_filename(struct scst_vdisk_dev *virt_dev)
 	if (virt_dev->filename != NULL)
 		return virt_dev->filename;
 	else
-		return "none";
+		return "";
 }
 
 static void vdev_set_filename(struct scst_vdisk_dev *virt_dev, char *n)
@@ -3788,115 +3788,80 @@ static ssize_t vdev_sysfs_size_show(struct device *device,
 static ssize_t vdisk_sysfs_blocksize_show(struct device *device,
 				struct device_attribute *attr, char *buf)
 {
-	int pos = 0;
 	struct scst_device *dev;
 	struct scst_vdisk_dev *virt_dev;
 
 	dev = scst_dev_to_dev(device);
 	virt_dev = dev->dh_priv;
-
-	pos = sprintf(buf, "%d\n%s", (int)virt_dev->block_size,
-		(virt_dev->block_size == DEF_DISK_BLOCKSIZE) ? "" :
-			SCST_SYSFS_KEY_MARK "\n");
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)virt_dev->block_size);
 }
 
 static ssize_t vdisk_sysfs_rd_only_show(struct device *device,
 				struct device_attribute *attr, char *buf)
 {
-	int pos = 0;
 	struct scst_device *dev;
 	struct scst_vdisk_dev *virt_dev;
 
 	dev = scst_dev_to_dev(device);
 	virt_dev = dev->dh_priv;
-
-	pos = sprintf(buf, "%d\n%s", virt_dev->rd_only ? 1 : 0,
-		(virt_dev->rd_only == DEF_RD_ONLY) ? "" :
-			SCST_SYSFS_KEY_MARK "");
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", virt_dev->rd_only ? 1 : 0);
 }
 
 static ssize_t vdisk_sysfs_wt_show(struct device *device,
 				   struct device_attribute *attr, char *buf)
 {
-	int pos = 0;
 	struct scst_device *dev;
 	struct scst_vdisk_dev *virt_dev;
 
 	dev = scst_dev_to_dev(device);
 	virt_dev = dev->dh_priv;
-
-	pos = sprintf(buf, "%d\n%s", virt_dev->wt_flag ? 1 : 0,
-		(virt_dev->wt_flag == DEF_WRITE_THROUGH) ? "" :
-			SCST_SYSFS_KEY_MARK "");
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", virt_dev->wt_flag ? 1 : 0);
 }
 
 static ssize_t vdisk_sysfs_tp_show(struct device *device,
 				   struct device_attribute *attr, char *buf)
 {
-	int pos = 0;
 	struct scst_device *dev;
 	struct scst_vdisk_dev *virt_dev;
 
 	dev = scst_dev_to_dev(device);
 	virt_dev = dev->dh_priv;
-
-	pos = sprintf(buf, "%d\n%s", virt_dev->thin_provisioned ? 1 : 0,
-		(virt_dev->thin_provisioned == DEF_THIN_PROVISIONED) ? "" :
-			SCST_SYSFS_KEY_MARK "");
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
+			 virt_dev->thin_provisioned ? 1 : 0);
 }
 
 static ssize_t vdisk_sysfs_nv_cache_show(struct device *device,
 	struct device_attribute *attr, char *buf)
 {
-	int pos = 0;
 	struct scst_device *dev;
 	struct scst_vdisk_dev *virt_dev;
 
 	dev = scst_dev_to_dev(device);
 	virt_dev = dev->dh_priv;
-
-	pos = sprintf(buf, "%d\n%s", virt_dev->nv_cache ? 1 : 0,
-		(virt_dev->nv_cache == DEF_NV_CACHE) ? "" :
-			SCST_SYSFS_KEY_MARK "");
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", virt_dev->nv_cache ? 1 : 0);
 }
 
 static ssize_t vdisk_sysfs_o_direct_show(struct device *device,
 	struct device_attribute *attr, char *buf)
 {
-	int pos = 0;
 	struct scst_device *dev;
 	struct scst_vdisk_dev *virt_dev;
 
 	dev = scst_dev_to_dev(device);
 	virt_dev = dev->dh_priv;
-
-	pos = sprintf(buf, "%d\n%s", virt_dev->o_direct_flag ? 1 : 0,
-		(virt_dev->o_direct_flag == DEF_O_DIRECT) ? "" :
-			SCST_SYSFS_KEY_MARK "");
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
+			 virt_dev->o_direct_flag ? 1 : 0);
 }
 
 static ssize_t vdisk_sysfs_removable_show(struct device *device,
 				struct device_attribute *attr, char *buf)
 {
-	int pos;
 	struct scst_device *dev;
 	struct scst_vdisk_dev *virt_dev;
 
 	dev = scst_dev_to_dev(device);
 	virt_dev = dev->dh_priv;
-
-	pos = sprintf(buf, "%d\n", virt_dev->removable ? 1 : 0);
-
-	if ((virt_dev->dev->type != TYPE_ROM) &&
-	    (virt_dev->removable != DEF_REMOVABLE))
-		pos += sprintf(&buf[pos], "%s\n", SCST_SYSFS_KEY_MARK);
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", virt_dev->removable ? 1 : 0);
 }
 
 static ssize_t vdev_sysfs_filename_show(struct device *device,
@@ -3912,9 +3877,7 @@ static ssize_t vdev_sysfs_filename_show(struct device *device,
 	res = mutex_lock_interruptible(&virt_dev->filename_mutex);
 	if (res)
 		goto out;
-	res = snprintf(buf, SCST_SYSFS_BLOCK_SIZE, "%s\n%s",
-		       __vdev_get_filename(virt_dev),
-		       virt_dev->filename ? SCST_SYSFS_KEY_MARK "\n" : "");
+	res = scnprintf(buf, PAGE_SIZE, "%s\n", __vdev_get_filename(virt_dev));
 	mutex_unlock(&virt_dev->filename_mutex);
 
 out:
@@ -4003,8 +3966,7 @@ static ssize_t vdev_sysfs_t10_dev_id_show(struct device *device,
 	virt_dev = dev->dh_priv;
 
 	read_lock_bh(&vdisk_t10_dev_id_rwlock);
-	pos = sprintf(buf, "%s\n%s", virt_dev->t10_dev_id,
-		virt_dev->t10_dev_id_set ? SCST_SYSFS_KEY_MARK "\n" : "");
+	pos = scnprintf(buf, PAGE_SIZE, "%s\n", virt_dev->t10_dev_id);
 	read_unlock_bh(&vdisk_t10_dev_id_rwlock);
 	return pos;
 }
diff --git a/drivers/scst/scst_local/scst_local.c b/drivers/scst/scst_local/scst_local.c
index b0c989a..a3804cb 100644
--- a/drivers/scst/scst_local/scst_local.c
+++ b/drivers/scst/scst_local/scst_local.c
@@ -285,10 +285,10 @@ static ssize_t scst_local_scsi_transport_version_show(struct device *dev,
 		goto out_up;
 
 	if (tgt->scsi_transport_version != 0)
-		res = sprintf(buf, "0x%x\n%s", tgt->scsi_transport_version,
-			SCST_SYSFS_KEY_MARK "\n");
+		res = scnprintf(buf, PAGE_SIZE, "0x%x\n",
+				tgt->scsi_transport_version);
 	else
-		res = sprintf(buf, "0x%x\n", 0x0BE0); /* SAS */
+		res = scnprintf(buf, PAGE_SIZE, "0x%x\n", 0x0BE0); /* SAS */
 
 out_up:
 	up_read(&scst_local_exit_rwsem);
@@ -350,9 +350,7 @@ static ssize_t scst_local_phys_transport_version_show(struct device *dev,
 	if (!tgt)
 		goto out_up;
 
-	res = sprintf(buf, "0x%x\n%s", tgt->phys_transport_version,
-			(tgt->phys_transport_version != 0) ?
-				SCST_SYSFS_KEY_MARK "\n" : "");
+	res = scnprintf(buf, PAGE_SIZE, "0x%x\n", tgt->phys_transport_version);
 
 out_up:
 	up_read(&scst_local_exit_rwsem);
diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index 05344cc..da325f5 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -500,9 +500,6 @@ static ssize_t __scst_acg_addr_method_show(struct scst_acg *acg, char *buf)
 		break;
 	}
 
-	if (acg->addr_method != acg->tgt->tgtt->preferred_addr_method)
-		res += sprintf(&buf[res], "%s\n", SCST_SYSFS_KEY_MARK);
-
 	return res;
 }
 
@@ -568,17 +565,16 @@ static ssize_t __scst_acg_io_grouping_type_show(struct scst_acg *acg, char *buf)
 		res = sprintf(buf, "%s\n", SCST_IO_GROUPING_AUTO_STR);
 		break;
 	case SCST_IO_GROUPING_THIS_GROUP_ONLY:
-		res = sprintf(buf, "%s\n%s\n",
-			SCST_IO_GROUPING_THIS_GROUP_ONLY_STR,
-			SCST_SYSFS_KEY_MARK);
+		res = scnprintf(buf, PAGE_SIZE, "%s\n",
+				SCST_IO_GROUPING_THIS_GROUP_ONLY_STR);
 		break;
 	case SCST_IO_GROUPING_NEVER:
-		res = sprintf(buf, "%s\n%s\n", SCST_IO_GROUPING_NEVER_STR,
-			SCST_SYSFS_KEY_MARK);
+		res = scnprintf(buf, PAGE_SIZE, "%s\n",
+				SCST_IO_GROUPING_NEVER_STR);
 		break;
 	default:
-		res = sprintf(buf, "%d\n%s\n", acg->acg_io_grouping_type,
-			SCST_SYSFS_KEY_MARK);
+		res = scnprintf(buf, PAGE_SIZE, "%d\n",
+				acg->acg_io_grouping_type);
 		break;
 	}
 
@@ -698,10 +694,6 @@ static ssize_t __scst_acg_cpu_mask_show(struct scst_acg *acg, char *buf)
 
 	res = cpumask_scnprintf(buf, PAGE_SIZE, &acg->acg_cpu_mask);
 	res += scnprintf(buf + res, PAGE_SIZE - res, "\n");
-	if (!cpus_equal(acg->acg_cpu_mask, default_cpu_mask))
-		res += scnprintf(buf + res, PAGE_SIZE - res, "%s",
-				 SCST_SYSFS_KEY_MARK "\n");
-
 	return res;
 }
 
@@ -839,13 +831,9 @@ static ssize_t scst_rel_tgt_id_show(struct device *device,
 				    struct device_attribute *attr, char *buf)
 {
 	struct scst_tgt *tgt;
-	int res;
 
 	tgt = scst_dev_to_tgt(device);
-
-	res = sprintf(buf, "%d\n%s", tgt->rel_tgt_id,
-		(tgt->rel_tgt_id != 0) ? SCST_SYSFS_KEY_MARK "\n" : "");
-	return res;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", tgt->rel_tgt_id);
 }
 
 static int scst_process_rel_tgt_id_store(struct scst_tgt *tgt,
@@ -1176,15 +1164,10 @@ out:
 static ssize_t scst_dev_sysfs_threads_num_show(struct device *device,
 					struct device_attribute *attr, char *buf)
 {
-	int pos;
 	struct scst_device *dev;
 
 	dev = scst_dev_to_dev(device);
-
-	pos = sprintf(buf, "%d\n%s", dev->threads_num,
-		(dev->threads_num != dev->handler->threads_num) ?
-			SCST_SYSFS_KEY_MARK "\n" : "");
-	return pos;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", dev->threads_num);
 }
 
 static ssize_t scst_dev_set_threads_num(struct scst_device *dev, long newtn)
@@ -1224,17 +1207,15 @@ static ssize_t scst_dev_sysfs_threads_pool_type_show(struct device *device,
 
 	switch (dev->threads_pool_type) {
 	case SCST_THREADS_POOL_PER_INITIATOR:
-		pos = sprintf(buf, "%s\n%s", SCST_THREADS_POOL_PER_INITIATOR_STR,
-			(dev->threads_pool_type != dev->handler->threads_pool_type) ?
-				SCST_SYSFS_KEY_MARK "\n" : "");
+		pos = scnprintf(buf, PAGE_SIZE, "%s\n",
+				SCST_THREADS_POOL_PER_INITIATOR_STR);
 		break;
 	case SCST_THREADS_POOL_SHARED:
-		pos = sprintf(buf, "%s\n%s", SCST_THREADS_POOL_SHARED_STR,
-			(dev->threads_pool_type != dev->handler->threads_pool_type) ?
-				SCST_SYSFS_KEY_MARK "\n" : "");
+		pos = scnprintf(buf, PAGE_SIZE, "%s\n",
+				SCST_THREADS_POOL_SHARED_STR);
 		break;
 	default:
-		pos = sprintf(buf, "Unknown\n");
+		pos = scnprintf(buf, PAGE_SIZE, "Unknown\n");
 		break;
 	}
 
@@ -2051,11 +2032,8 @@ static ssize_t scst_lun_rd_only_show(struct kobject *kobj,
 	struct scst_acg_dev *acg_dev;
 
 	acg_dev = scst_kobj_to_acg_dev(kobj);
-
-	if (acg_dev->rd_only || acg_dev->dev->rd_only)
-		return sprintf(buf, "%d\n%s\n", 1, SCST_SYSFS_KEY_MARK);
-	else
-		return sprintf(buf, "%d\n", 0);
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
+			 acg_dev->rd_only || acg_dev->dev->rd_only);
 }
 
 static struct kobj_attribute lun_options_attr =
@@ -3514,12 +3492,8 @@ out:
 static ssize_t scst_threads_show(struct device *device,
 				 struct device_attribute *attr, char *buf)
 {
-	int count;
-
-	count = sprintf(buf, "%d\n%s", scst_main_cmd_threads.nr_threads,
-		(scst_main_cmd_threads.nr_threads != scst_threads) ?
-			SCST_SYSFS_KEY_MARK "\n" : "");
-	return count;
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
+			 scst_main_cmd_threads.nr_threads);
 }
 
 static int scst_process_threads_store(int newtn)
@@ -3580,11 +3554,7 @@ out:
 static ssize_t scst_setup_id_show(struct device *device,
 				  struct device_attribute *attr, char *buf)
 {
-	int count;
-
-	count = sprintf(buf, "0x%x\n%s\n", scst_setup_id,
-		(scst_setup_id == 0) ? "" : SCST_SYSFS_KEY_MARK);
-	return count;
+	return scnprintf(buf, PAGE_SIZE, "0x%x\n", scst_setup_id);
 }
 
 static ssize_t scst_setup_id_store(struct device *device,
diff --git a/include/scst/scst_const.h b/include/scst/scst_const.h
index b7b06ea..d1dadfa 100644
--- a/include/scst/scst_const.h
+++ b/include/scst/scst_const.h
@@ -385,8 +385,6 @@ enum scst_cdb_flags {
 
 #define TID_COMMON_SIZE				24
 
-#define SCST_SYSFS_KEY_MARK			"[key]"
-
 #define SCST_MIN_REL_TGT_ID			1
 #define SCST_MAX_REL_TGT_ID			65535
 
-- 
1.7.1

