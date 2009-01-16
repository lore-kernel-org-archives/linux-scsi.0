From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [Target_Core_Mod/ConfigFS]: Add T10 EVPD / WWN storage
	object attributes
Date: Thu, 15 Jan 2009 23:51:51 -0800
Message-ID: <1232092311.1274.173.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:31531 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757225AbZAPHwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 02:52:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>

>From b3d820365e0e603ea29b7264b37aafd89ce2ca80 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 15 Jan 2009 18:42:06 -0800
Subject: [PATCH 2/2] [Target_Core_Mod/ConfigFS]: Add T10 EVPD / WWN storage object attributes

This patch adds the following INQUIRY EVPD=1 protocol information to ConfigFS:

*) Protocol Identifier
*) Association
*) Identifier Type
*) Identifier Binary, ASCII, and UTF-8 encoding

The patch adds struct config_item_type target_core_dev_wwn_cit as a
default group in target_core_call_createdev().  This are defined as
READ-WRITE ConfigFS attributes, but the (*store)() function returns
-ENOSYS for now.  Some of these attributes will be able to be changed
in the near future based upon subsystem plugin.

Here is what it looks like in /sys/kernel/config/target/core using
Target_Core_Mod/IBLOCK and Target_Core_Mod/PSCSI subsystem storage objects:

/sys/kernel/config/
`-- target
    |-- core
    |   |-- iblock_0
    |   |   |-- hba_info
    |   |   `-- lvm_test0
    |   |       |-- attrib
    |   |       |   |-- hw_max_sectors
    |   |       |   |-- hw_queue_depth
    |   |       |   |-- max_sectors
    |   |       |   |-- queue_depth
    |   |       |   |-- status_thread
    |   |       |   |-- status_thread_tur
    |   |       |   `-- task_timeout
    |   |       |-- control
    |   |       |-- enable
    |   |       |-- fd
    |   |       |-- info
    |   |       `-- wwn
    |   |           |-- evpd_assoc_logical_unit
    |   |           |-- evpd_assoc_scsi_target_device
    |   |           |-- evpd_assoc_target_port
    |   |           |-- evpd_protocol_identifier
    |   |           `-- evpd_unit_serial
    |   |-- pscsi_0
    |   |   |-- hba_info
    |   |   `-- sdd
    |   |       |-- attrib
    |   |       |   |-- hw_max_sectors
    |   |       |   |-- hw_queue_depth
    |   |       |   |-- max_sectors
    |   |       |   |-- queue_depth
    |   |       |   |-- status_thread
    |   |       |   |-- status_thread_tur
    |   |       |   `-- task_timeout
    |   |       |-- control
    |   |       |-- enable
    |   |       |-- fd
    |   |       |-- info
    |   |       `-- wwn
    |   |           |-- evpd_assoc_logical_unit
    |   |           |-- evpd_assoc_scsi_target_device
    |   |           |-- evpd_assoc_target_port
    |   |           |-- evpd_protocol_identifier
    |   |           `-- evpd_unit_serial

<SNIP>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org
---
 drivers/lio-core/target_core_configfs.c |  212 ++++++++++++++++++++++++++++++-
 1 files changed, 209 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 46a84a7..04c23b6 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -509,6 +509,206 @@ static struct config_item_type target_core_dev_attrib_cit = {
 
 // End functions for struct config_item_type target_core_dev_attrib_cit
 
+//  Start functions for struct config_item_type target_core_dev_wwn_cit
+
+CONFIGFS_EATTR_STRUCT(target_core_dev_wwn, t10_wwn_s);
+#define SE_DEV_WWN_ATTR(_name, _mode)						\
+static struct target_core_dev_wwn_attribute target_core_dev_wwn_##_name =	\
+		__CONFIGFS_EATTR(_name, _mode,					\
+		target_core_dev_wwn_show_attr_##_name,				\
+		target_core_dev_wwn_store_attr_##_name);
+
+#define SE_DEV_WWN_ATTR_RO(_name);						\
+static struct target_core_dev_wwn_attribute target_core_dev_wwn_##_name =	\
+		__CONFIGFS_EATTR_RO(_name,					\
+		target_core_dev_wwn_show_attr_##_name);
+
+/*
+ * EVPD page 0x80 Unit serial
+ */
+static ssize_t target_core_dev_wwn_show_attr_evpd_unit_serial (
+	struct t10_wwn_s *t10_wwn,
+	char *page)
+{
+	se_subsystem_dev_t *se_dev = t10_wwn->t10_sub_dev;
+	se_device_t *dev;
+
+        if (!(dev = se_dev->se_dev_ptr)) 
+                return(-ENODEV);
+
+	return(sprintf(page, "T10 EVPD Unit Serial Number:: %s\n",
+		&t10_wwn->unit_serial[0]));
+}
+
+static ssize_t target_core_dev_wwn_store_attr_evpd_unit_serial (
+	struct t10_wwn_s *t10_wwn,
+	const char *page,
+	size_t count)
+{
+	return(-ENOMEM);
+}
+
+SE_DEV_WWN_ATTR(evpd_unit_serial, S_IRUGO | S_IWUSR);
+
+/*
+ * EVPD page 0x83 Protocol Identifier
+ */
+static ssize_t target_core_dev_wwn_show_attr_evpd_protocol_identifier (
+	struct t10_wwn_s *t10_wwn,
+	char *page)
+{
+	se_subsystem_dev_t *se_dev = t10_wwn->t10_sub_dev;
+	se_device_t *dev;
+	t10_evpd_t *evpd;
+	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	ssize_t len = 0;
+
+	if (!(dev = se_dev->se_dev_ptr))
+		return(-ENODEV);
+
+	memset(buf, 0, EVPD_TMP_BUF_SIZE);
+
+	spin_lock(&t10_wwn->t10_evpd_lock);
+	list_for_each_entry(evpd, &t10_wwn->t10_evpd_list, evpd_list) {
+		if (!(evpd->protocol_identifier_set))
+			continue;
+
+		transport_dump_evpd_proto_id(evpd, buf, EVPD_TMP_BUF_SIZE);
+
+		if ((len + strlen(buf) > PAGE_SIZE))
+			break;
+
+		len += sprintf(page+len, "%s", buf);
+	}
+	spin_unlock(&t10_wwn->t10_evpd_lock);
+
+	return(len);
+}
+
+static ssize_t target_core_dev_wwn_store_attr_evpd_protocol_identifier (
+	struct t10_wwn_s *t10_wwn,
+	const char *page,
+	size_t count)
+{
+	return(-ENOSYS);
+}
+
+SE_DEV_WWN_ATTR(evpd_protocol_identifier, S_IRUGO | S_IWUSR);
+
+/*
+ * Generic wrapper for dumping EVPD identifiers by assoication.
+ */
+#define DEF_DEV_WWN_ASSOC_SHOW(_name, _assoc)					\
+static ssize_t target_core_dev_wwn_show_attr_##_name (				\
+	struct t10_wwn_s *t10_wwn,						\
+	char *page)								\
+{										\
+	se_subsystem_dev_t *se_dev = t10_wwn->t10_sub_dev;			\
+	se_device_t *dev;							\
+	t10_evpd_t *evpd;							\
+	unsigned char buf[EVPD_TMP_BUF_SIZE];					\
+	ssize_t len = 0;							\
+										\
+	if (!(dev = se_dev->se_dev_ptr))					\
+		return(-ENODEV);						\
+										\
+	spin_lock(&t10_wwn->t10_evpd_lock);					\
+	list_for_each_entry(evpd, &t10_wwn->t10_evpd_list, evpd_list) {		\
+		if (evpd->association != _assoc)				\
+			continue;						\
+										\
+		memset(buf, 0, EVPD_TMP_BUF_SIZE);				\
+		transport_dump_evpd_assoc(evpd, buf, EVPD_TMP_BUF_SIZE);	\
+		if ((len + strlen(buf) > PAGE_SIZE))				\
+			break;							\
+		len += sprintf(page+len, "%s", buf);				\
+										\
+		memset(buf, 0, EVPD_TMP_BUF_SIZE);				\
+		transport_dump_evpd_ident_type(evpd, buf, EVPD_TMP_BUF_SIZE);	\
+		if ((len + strlen(buf) > PAGE_SIZE))				\
+			break;							\
+		len += sprintf(page+len, "%s", buf);				\
+										\
+		memset(buf, 0, EVPD_TMP_BUF_SIZE);				\
+		transport_dump_evpd_ident(evpd, buf, EVPD_TMP_BUF_SIZE);	\
+		if ((len + strlen(buf) > PAGE_SIZE))				\
+			break;							\
+		len += sprintf(page+len, "%s", buf);				\
+	}									\
+	spin_unlock(&t10_wwn->t10_evpd_lock);					\
+										\
+	return(len);								\
+}
+
+/*
+ * EVPD page 0x83 Assoication: Logical Unit
+ */
+DEF_DEV_WWN_ASSOC_SHOW(evpd_assoc_logical_unit, 0x00);
+
+static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_logical_unit (
+	struct t10_wwn_s *t10_wwn,
+	const char *page,
+	size_t count)
+{
+	return(-ENOSYS);
+}
+
+SE_DEV_WWN_ATTR(evpd_assoc_logical_unit, S_IRUGO | S_IWUSR);
+
+/*
+ * EVPD page 0x83 Association: Target Port
+ */
+DEF_DEV_WWN_ASSOC_SHOW(evpd_assoc_target_port, 0x10);
+
+static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_target_port (
+	struct t10_wwn_s *t10_wwn,
+	const char *page,
+	size_t count)
+{
+        return(-ENOSYS);
+}
+
+SE_DEV_WWN_ATTR(evpd_assoc_target_port, S_IRUGO | S_IWUSR);
+
+/*
+ * EVPD page 0x83 Association: SCSI Target Device
+ */
+DEF_DEV_WWN_ASSOC_SHOW(evpd_assoc_scsi_target_device, 0x20);
+
+static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_scsi_target_device (
+	struct t10_wwn_s *t10_wwn,
+	const char *page,
+	size_t count)
+{
+        return(-ENOSYS);
+}
+
+SE_DEV_WWN_ATTR(evpd_assoc_scsi_target_device, S_IRUGO | S_IWUSR);
+
+CONFIGFS_EATTR_OPS(target_core_dev_wwn, t10_wwn_s, t10_wwn_group);
+
+static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
+	&target_core_dev_wwn_evpd_unit_serial.attr,
+	&target_core_dev_wwn_evpd_protocol_identifier.attr,
+	&target_core_dev_wwn_evpd_assoc_logical_unit.attr,
+	&target_core_dev_wwn_evpd_assoc_target_port.attr,
+	&target_core_dev_wwn_evpd_assoc_scsi_target_device.attr,
+	NULL,
+};
+
+static struct configfs_item_operations target_core_dev_wwn_ops = {
+	.show_attribute		= target_core_dev_wwn_attr_show,
+	.store_attribute	= target_core_dev_wwn_attr_store,
+};
+
+static struct config_item_type target_core_dev_wwn_cit = {
+	.ct_item_ops		= &target_core_dev_wwn_ops,
+	.ct_attrs		= target_core_dev_wwn_attrs,
+	.ct_owner		= THIS_MODULE,
+};
+
+//  End functions for struct config_item_type target_core_dev_wwn_cit
+
 //  Start functions for struct config_item_type target_core_dev_cit
 
 static ssize_t target_core_show_dev_info (void *p, char *page)
@@ -598,7 +798,6 @@ static ssize_t target_core_store_dev_fd (void *p, const char *page, size_t count
 		goto out;
 
 	se_dev->se_dev_ptr = dev;
-
 	printk("Target_Core_ConfigFS: Registered %s se_dev->se_dev_ptr: %p"
 		" from fd\n", hba->transport->name, se_dev->se_dev_ptr);
 	return(count);
@@ -747,13 +946,17 @@ static struct config_group *target_core_call_createdev (
 		printk(KERN_ERR "Unable to allocate memory for se_subsystem_dev_t\n");
 		return(NULL);
 	}
+	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_evpd_list);
+	spin_lock_init(&se_dev->t10_wwn.t10_evpd_lock);
 	spin_lock_init(&se_dev->se_dev_lock);
+
+	se_dev->t10_wwn.t10_sub_dev = se_dev;
 	se_dev->se_dev_attrib.da_sub_dev = se_dev;
 
 	se_dev->se_dev_hba = hba;
 	dev_cg = &se_dev->se_dev_group;
 
-	if (!(dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+	if (!(dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 3,
 			GFP_KERNEL)))
 		goto out;
 
@@ -770,8 +973,11 @@ static struct config_group *target_core_call_createdev (
 			&target_core_dev_cit);
 	config_group_init_type_name(&se_dev->se_dev_attrib.da_group, "attrib",
 			&target_core_dev_attrib_cit);
+	config_group_init_type_name(&se_dev->t10_wwn.t10_wwn_group, "wwn",
+			&target_core_dev_wwn_cit);
 	dev_cg->default_groups[0] = &se_dev->se_dev_attrib.da_group;
-	dev_cg->default_groups[1] = NULL;
+	dev_cg->default_groups[1] = &se_dev->t10_wwn.t10_wwn_group;
+	dev_cg->default_groups[2] = NULL;
 
 	printk("Target_Core_ConfigFS: Allocated se_subsystem_dev_t: %p se_dev_su_ptr: %p\n",
 			se_dev, se_dev->se_dev_su_ptr);
-- 
1.5.4.1



