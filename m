From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod]: Change all 'evpd' code references to
	'vpd'
Date: Thu, 02 Apr 2009 19:54:28 -0700
Message-ID: <1238727268.4250.423.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36461 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752258AbZDCCzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 22:55:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>

Greetings all,

This patch converts all usage of the term 'evpd' and 'EVPD' to
'vpd' and 'VPD' respectively in target_core_mod code.  This change was made
because spc4 documents explictly list the device identification page (0x83)
as 'vital product data', and not 'extended vital product data'.

This patch includes changes to evpd_* prefixed ConfigFS attributes in
/sys/kernel/config/target/core/$HBA/$DEV/wwn/, as well as t10_evpd_t
structure and a number of other function names, defines, and printk() output.

Thanks to Doug Gilbert for recommending this change!

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29 x86 32-bit HVM.  The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |   26 ++--
 drivers/lio-core/target_core_configfs.c  |  134 ++++++++++----------
 drivers/lio-core/target_core_device.c    |   18 ++--
 drivers/lio-core/target_core_device.h    |    2 +-
 drivers/lio-core/target_core_transport.c |  198 +++++++++++++++---------------
 drivers/lio-core/target_core_transport.h |   20 +--
 6 files changed, 195 insertions(+), 203 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 5935d9b..0e9cb82 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -62,10 +62,10 @@
 #define TRANSPORT_IQN_LEN			224
 #define LU_GROUP_NAME_BUF			256
 #define TG_PT_GROUP_NAME_BUF			256
-/* Used to parse EVPD into t10_evpd_t */
-#define EVPD_TMP_BUF_SIZE			128
+/* Used to parse VPD into t10_vpd_t */
+#define VPD_TMP_BUF_SIZE			128
 /* Used for target_core-pscsi.c:pscsi_transport_complete() */
-#define EVPD_BUF_LEN                    256
+#define VPD_BUF_LEN                    256
 
 
 /* used by PSCSI and iBlock Transport drivers */
@@ -73,8 +73,8 @@
 #define READ_CAP_LEN            		8
 #define READ_POSITION_LEN       		20
 #define INQUIRY_LEN				36
-#define INQUIRY_EVPD_SERIAL_LEN			254
-#define INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN	254
+#define INQUIRY_VPD_SERIAL_LEN			254
+#define INQUIRY_VPD_DEVICE_IDENTIFIER_LEN	254
 
 /* se_cmd_t->data_direction */
 #define SE_DIRECTION_NONE			0
@@ -252,25 +252,25 @@ typedef struct t10_alua_tg_pt_gp_member_s {
 	struct list_head tg_pt_gp_mem_list;
 } ____cacheline_aligned t10_alua_tg_pt_gp_member_t;
 
-typedef struct t10_evpd_s {
-	unsigned char device_identifier[INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN];
+typedef struct t10_vpd_s {
+	unsigned char device_identifier[INQUIRY_VPD_DEVICE_IDENTIFIER_LEN];
 	int protocol_identifier_set;
 	u32 protocol_identifier;
 	u32 device_identifier_code_set;
 	u32 association;
 	u32 device_identifier_type;
-	struct list_head evpd_list;
-} ____cacheline_aligned t10_evpd_t;
+	struct list_head vpd_list;
+} ____cacheline_aligned t10_vpd_t;
 
 typedef struct t10_wwn_s {
 	unsigned char vendor[8];
 	unsigned char model[16];
 	unsigned char revision[4];
-	unsigned char unit_serial[INQUIRY_EVPD_SERIAL_LEN];
-	spinlock_t t10_evpd_lock;
+	unsigned char unit_serial[INQUIRY_VPD_SERIAL_LEN];
+	spinlock_t t10_vpd_lock;
 	struct se_subsystem_dev_s *t10_sub_dev;
 	struct config_group t10_wwn_group;
-	struct list_head t10_evpd_list;
+	struct list_head t10_vpd_list;
 } ____cacheline_aligned t10_wwn_t;
 
 typedef enum {
@@ -645,7 +645,7 @@ typedef struct se_subsystem_dev_s {
 	se_dev_attrib_t se_dev_attrib;
 	/* T10 Asymmetric Logical Unit Assignment Information */
 	t10_alua_t	t10_alua;
-	/* T10 Inquiry and EVPD WWN Information */
+	/* T10 Inquiry and VPD WWN Information */
 	t10_wwn_t	t10_wwn;
 	/* T10 SPC-2 + SPC-3 Reservations */
 	t10_reservation_template_t t10_reservation;
diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 975ecb8..84fe836 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -550,9 +550,9 @@ static struct target_core_dev_wwn_attribute target_core_dev_wwn_##_name = \
 		target_core_dev_wwn_show_attr_##_name);
 
 /*
- * EVPD page 0x80 Unit serial
+ * VPD page 0x80 Unit serial
  */
-static ssize_t target_core_dev_wwn_show_attr_evpd_unit_serial(
+static ssize_t target_core_dev_wwn_show_attr_vpd_unit_serial(
 	struct t10_wwn_s *t10_wwn,
 	char *page)
 {
@@ -563,38 +563,38 @@ static ssize_t target_core_dev_wwn_show_attr_evpd_unit_serial(
 	if (!(dev))
 		return -ENODEV;
 
-	return sprintf(page, "T10 EVPD Unit Serial Number: %s\n",
+	return sprintf(page, "T10 VPD Unit Serial Number: %s\n",
 		&t10_wwn->unit_serial[0]);
 }
 
-static ssize_t target_core_dev_wwn_store_attr_evpd_unit_serial(
+static ssize_t target_core_dev_wwn_store_attr_vpd_unit_serial(
 	struct t10_wwn_s *t10_wwn,
 	const char *page,
 	size_t count)
 {
 	se_subsystem_dev_t *su_dev = t10_wwn->t10_sub_dev;
 	se_device_t *dev;
-	unsigned char buf[INQUIRY_EVPD_SERIAL_LEN];
+	unsigned char buf[INQUIRY_VPD_SERIAL_LEN];
 
 	/*
-	 * If Linux/SCSI subsystem_api_t plugin got a EVPD Unit Serial
+	 * If Linux/SCSI subsystem_api_t plugin got a VPD Unit Serial
 	 * from the struct scsi_device level firmware, do not allow
-	 * EVPD Unit Serial to be emulated.
+	 * VPD Unit Serial to be emulated.
 	 *
-	 * Note this struct scsi_device could also be emulating EVPD
+	 * Note this struct scsi_device could also be emulating VPD
 	 * information from its drivers/scsi LLD.  But for now we assume
 	 * it is doing 'the right thing' wrt a world wide unique
-	 * EVPD Unit Serial Number that OS dependent multipath can depend on.
+	 * VPD Unit Serial Number that OS dependent multipath can depend on.
 	 */
-	if (su_dev->su_dev_flags & SDF_FIRMWARE_EVPD_UNIT_SERIAL) {
-		printk(KERN_ERR "Underlying SCSI device firmware provided EVPD"
+	if (su_dev->su_dev_flags & SDF_FIRMWARE_VPD_UNIT_SERIAL) {
+		printk(KERN_ERR "Underlying SCSI device firmware provided VPD"
 			" Unit Serial, ignoring request\n");
 		return -EOPNOTSUPP;
 	}
 
-	if ((strlen(page) + 1) > INQUIRY_EVPD_SERIAL_LEN) {
-		printk(KERN_ERR "Emulated EVPD Unit Serial exceeds"
-		" INQUIRY_EVPD_SERIAL_LEN: %d\n", INQUIRY_EVPD_SERIAL_LEN);
+	if ((strlen(page) + 1) > INQUIRY_VPD_SERIAL_LEN) {
+		printk(KERN_ERR "Emulated VPD Unit Serial exceeds"
+		" INQUIRY_VPD_SERIAL_LEN: %d\n", INQUIRY_VPD_SERIAL_LEN);
 		return -EOVERFLOW;
 	}
 	/*
@@ -606,7 +606,7 @@ static ssize_t target_core_dev_wwn_store_attr_evpd_unit_serial(
 	dev = su_dev->se_dev_ptr;
 	if ((dev)) {
 		if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
-			printk(KERN_ERR "Unable to set EVPD Unit Serial while"
+			printk(KERN_ERR "Unable to set VPD Unit Serial while"
 				" active %d $FABRIC_MOD exports exist\n",
 				DEV_OBJ_API(dev)->check_count(
 					&dev->dev_export_obj));
@@ -614,61 +614,61 @@ static ssize_t target_core_dev_wwn_store_attr_evpd_unit_serial(
 		}
 	}
 	/*
-	 * This currently assumes ASCII encoding for emulated EVPD Unit Serial.
+	 * This currently assumes ASCII encoding for emulated VPD Unit Serial.
 	 *
 	 * Also, strip any newline added from the userspace
-	 * echo $UUID > $TARGET/$HBA/$STORAGE_OBJECT/wwn/evpd_unit_serial
+	 * echo $UUID > $TARGET/$HBA/$STORAGE_OBJECT/wwn/vpd_unit_serial
 	 */
-	memset(buf, 0, INQUIRY_EVPD_SERIAL_LEN);
-	snprintf(buf, INQUIRY_EVPD_SERIAL_LEN, "%s", page);
-	snprintf(su_dev->t10_wwn.unit_serial, INQUIRY_EVPD_SERIAL_LEN,
+	memset(buf, 0, INQUIRY_VPD_SERIAL_LEN);
+	snprintf(buf, INQUIRY_VPD_SERIAL_LEN, "%s", page);
+	snprintf(su_dev->t10_wwn.unit_serial, INQUIRY_VPD_SERIAL_LEN,
 			"%s", strstrip(buf));
-	su_dev->su_dev_flags |= SDF_EMULATED_EVPD_UNIT_SERIAL;
+	su_dev->su_dev_flags |= SDF_EMULATED_VPD_UNIT_SERIAL;
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Set emulated EVPD Unit Serial:"
+	printk(KERN_INFO "Target_Core_ConfigFS: Set emulated VPD Unit Serial:"
 			" %s\n", su_dev->t10_wwn.unit_serial);
 	return count;
 }
 
-SE_DEV_WWN_ATTR(evpd_unit_serial, S_IRUGO | S_IWUSR);
+SE_DEV_WWN_ATTR(vpd_unit_serial, S_IRUGO | S_IWUSR);
 
 /*
- * EVPD page 0x83 Protocol Identifier
+ * VPD page 0x83 Protocol Identifier
  */
-static ssize_t target_core_dev_wwn_show_attr_evpd_protocol_identifier(
+static ssize_t target_core_dev_wwn_show_attr_vpd_protocol_identifier(
 	struct t10_wwn_s *t10_wwn,
 	char *page)
 {
 	se_subsystem_dev_t *se_dev = t10_wwn->t10_sub_dev;
 	se_device_t *dev;
-	t10_evpd_t *evpd;
-	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	t10_vpd_t *vpd;
+	unsigned char buf[VPD_TMP_BUF_SIZE];
 	ssize_t len = 0;
 
 	dev = se_dev->se_dev_ptr;
 	if (!(dev))
 		return -ENODEV;
 
-	memset(buf, 0, EVPD_TMP_BUF_SIZE);
+	memset(buf, 0, VPD_TMP_BUF_SIZE);
 
-	spin_lock(&t10_wwn->t10_evpd_lock);
-	list_for_each_entry(evpd, &t10_wwn->t10_evpd_list, evpd_list) {
-		if (!(evpd->protocol_identifier_set))
+	spin_lock(&t10_wwn->t10_vpd_lock);
+	list_for_each_entry(vpd, &t10_wwn->t10_vpd_list, vpd_list) {
+		if (!(vpd->protocol_identifier_set))
 			continue;
 
-		transport_dump_evpd_proto_id(evpd, buf, EVPD_TMP_BUF_SIZE);
+		transport_dump_vpd_proto_id(vpd, buf, VPD_TMP_BUF_SIZE);
 
 		if ((len + strlen(buf) > PAGE_SIZE))
 			break;
 
 		len += sprintf(page+len, "%s", buf);
 	}
-	spin_unlock(&t10_wwn->t10_evpd_lock);
+	spin_unlock(&t10_wwn->t10_vpd_lock);
 
 	return len;
 }
 
-static ssize_t target_core_dev_wwn_store_attr_evpd_protocol_identifier(
+static ssize_t target_core_dev_wwn_store_attr_vpd_protocol_identifier(
 	struct t10_wwn_s *t10_wwn,
 	const char *page,
 	size_t count)
@@ -676,10 +676,10 @@ static ssize_t target_core_dev_wwn_store_attr_evpd_protocol_identifier(
 	return -ENOSYS;
 }
 
-SE_DEV_WWN_ATTR(evpd_protocol_identifier, S_IRUGO | S_IWUSR);
+SE_DEV_WWN_ATTR(vpd_protocol_identifier, S_IRUGO | S_IWUSR);
 
 /*
- * Generic wrapper for dumping EVPD identifiers by association.
+ * Generic wrapper for dumping VPD identifiers by association.
  */
 #define DEF_DEV_WWN_ASSOC_SHOW(_name, _assoc)				\
 static ssize_t target_core_dev_wwn_show_attr_##_name(			\
@@ -688,48 +688,48 @@ static ssize_t target_core_dev_wwn_show_attr_##_name(			\
 {									\
 	se_subsystem_dev_t *se_dev = t10_wwn->t10_sub_dev;		\
 	se_device_t *dev;						\
-	t10_evpd_t *evpd;						\
-	unsigned char buf[EVPD_TMP_BUF_SIZE];				\
+	t10_vpd_t *vpd;							\
+	unsigned char buf[VPD_TMP_BUF_SIZE];				\
 	ssize_t len = 0;						\
 									\
 	dev = se_dev->se_dev_ptr;					\
 	if (!(dev))							\
 		return -ENODEV;						\
 									\
-	spin_lock(&t10_wwn->t10_evpd_lock);				\
-	list_for_each_entry(evpd, &t10_wwn->t10_evpd_list, evpd_list) {	\
-		if (evpd->association != _assoc)			\
+	spin_lock(&t10_wwn->t10_vpd_lock);				\
+	list_for_each_entry(vpd, &t10_wwn->t10_vpd_list, vpd_list) {	\
+		if (vpd->association != _assoc)				\
 			continue;					\
 									\
-		memset(buf, 0, EVPD_TMP_BUF_SIZE);			\
-		transport_dump_evpd_assoc(evpd, buf, EVPD_TMP_BUF_SIZE); \
+		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
+		transport_dump_vpd_assoc(vpd, buf, VPD_TMP_BUF_SIZE);	\
 		if ((len + strlen(buf) > PAGE_SIZE))			\
 			break;						\
 		len += sprintf(page+len, "%s", buf);			\
 									\
-		memset(buf, 0, EVPD_TMP_BUF_SIZE);			\
-		transport_dump_evpd_ident_type(evpd, buf, EVPD_TMP_BUF_SIZE); \
+		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
+		transport_dump_vpd_ident_type(vpd, buf, VPD_TMP_BUF_SIZE); \
 		if ((len + strlen(buf) > PAGE_SIZE))			\
 			break;						\
 		len += sprintf(page+len, "%s", buf);			\
 									\
-		memset(buf, 0, EVPD_TMP_BUF_SIZE);			\
-		transport_dump_evpd_ident(evpd, buf, EVPD_TMP_BUF_SIZE); \
+		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
+		transport_dump_vpd_ident(vpd, buf, VPD_TMP_BUF_SIZE); \
 		if ((len + strlen(buf) > PAGE_SIZE))			\
 			break;						\
 		len += sprintf(page+len, "%s", buf);			\
 	}								\
-	spin_unlock(&t10_wwn->t10_evpd_lock);				\
+	spin_unlock(&t10_wwn->t10_vpd_lock);				\
 									\
 	return len;							\
 }
 
 /*
- * EVPD page 0x83 Assoication: Logical Unit
+ * VPD page 0x83 Assoication: Logical Unit
  */
-DEF_DEV_WWN_ASSOC_SHOW(evpd_assoc_logical_unit, 0x00);
+DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_logical_unit, 0x00);
 
-static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_logical_unit(
+static ssize_t target_core_dev_wwn_store_attr_vpd_assoc_logical_unit(
 	struct t10_wwn_s *t10_wwn,
 	const char *page,
 	size_t count)
@@ -737,14 +737,14 @@ static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_logical_unit(
 	return -ENOSYS;
 }
 
-SE_DEV_WWN_ATTR(evpd_assoc_logical_unit, S_IRUGO | S_IWUSR);
+SE_DEV_WWN_ATTR(vpd_assoc_logical_unit, S_IRUGO | S_IWUSR);
 
 /*
- * EVPD page 0x83 Association: Target Port
+ * VPD page 0x83 Association: Target Port
  */
-DEF_DEV_WWN_ASSOC_SHOW(evpd_assoc_target_port, 0x10);
+DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_target_port, 0x10);
 
-static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_target_port(
+static ssize_t target_core_dev_wwn_store_attr_vpd_assoc_target_port(
 	struct t10_wwn_s *t10_wwn,
 	const char *page,
 	size_t count)
@@ -752,14 +752,14 @@ static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_target_port(
 	return -ENOSYS;
 }
 
-SE_DEV_WWN_ATTR(evpd_assoc_target_port, S_IRUGO | S_IWUSR);
+SE_DEV_WWN_ATTR(vpd_assoc_target_port, S_IRUGO | S_IWUSR);
 
 /*
- * EVPD page 0x83 Association: SCSI Target Device
+ * VPD page 0x83 Association: SCSI Target Device
  */
-DEF_DEV_WWN_ASSOC_SHOW(evpd_assoc_scsi_target_device, 0x20);
+DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_scsi_target_device, 0x20);
 
-static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_scsi_target_device(
+static ssize_t target_core_dev_wwn_store_attr_vpd_assoc_scsi_target_device(
 	struct t10_wwn_s *t10_wwn,
 	const char *page,
 	size_t count)
@@ -767,16 +767,16 @@ static ssize_t target_core_dev_wwn_store_attr_evpd_assoc_scsi_target_device(
 	return -ENOSYS;
 }
 
-SE_DEV_WWN_ATTR(evpd_assoc_scsi_target_device, S_IRUGO | S_IWUSR);
+SE_DEV_WWN_ATTR(vpd_assoc_scsi_target_device, S_IRUGO | S_IWUSR);
 
 CONFIGFS_EATTR_OPS(target_core_dev_wwn, t10_wwn_s, t10_wwn_group);
 
 static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
-	&target_core_dev_wwn_evpd_unit_serial.attr,
-	&target_core_dev_wwn_evpd_protocol_identifier.attr,
-	&target_core_dev_wwn_evpd_assoc_logical_unit.attr,
-	&target_core_dev_wwn_evpd_assoc_target_port.attr,
-	&target_core_dev_wwn_evpd_assoc_scsi_target_device.attr,
+	&target_core_dev_wwn_vpd_unit_serial.attr,
+	&target_core_dev_wwn_vpd_protocol_identifier.attr,
+	&target_core_dev_wwn_vpd_assoc_logical_unit.attr,
+	&target_core_dev_wwn_vpd_assoc_target_port.attr,
+	&target_core_dev_wwn_vpd_assoc_scsi_target_device.attr,
 	NULL,
 };
 
@@ -1860,8 +1860,8 @@ static struct config_group *target_core_call_createdev(
 				" se_subsystem_dev_t\n");
 		return NULL;
 	}
-	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_evpd_list);
-	spin_lock_init(&se_dev->t10_wwn.t10_evpd_lock);
+	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_vpd_list);
+	spin_lock_init(&se_dev->t10_wwn.t10_vpd_lock);
 	INIT_LIST_HEAD(&se_dev->t10_reservation.registration_list);
 	spin_lock_init(&se_dev->t10_reservation.registration_lock);
 	spin_lock_init(&se_dev->se_dev_lock);
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index a3db481..d391ee6 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -742,7 +742,7 @@ void se_release_device_for_hba(se_device_t *dev)
 	spin_unlock(&hba->device_lock);
 
 	core_scsi3_free_all_registrations(dev);
-	se_release_evpd_for_dev(dev);
+	se_release_vpd_for_dev(dev);
 
 	kfree(dev->dev_status_queue_obj);
 	kfree(dev->dev_queue_obj);
@@ -751,17 +751,17 @@ void se_release_device_for_hba(se_device_t *dev)
 	return;
 }
 
-void se_release_evpd_for_dev(se_device_t *dev)
+void se_release_vpd_for_dev(se_device_t *dev)
 {
-	t10_evpd_t *evpd, *evpd_tmp;
+	t10_vpd_t *vpd, *vpd_tmp;
 
-	spin_lock(&DEV_T10_WWN(dev)->t10_evpd_lock);
-	list_for_each_entry_safe(evpd, evpd_tmp,
-			&DEV_T10_WWN(dev)->t10_evpd_list, evpd_list) {
-		list_del(&evpd->evpd_list);
-		kfree(evpd);
+	spin_lock(&DEV_T10_WWN(dev)->t10_vpd_lock);
+	list_for_each_entry_safe(vpd, vpd_tmp,
+			&DEV_T10_WWN(dev)->t10_vpd_list, vpd_list) {
+		list_del(&vpd->vpd_list);
+		kfree(vpd);
 	}
-	spin_unlock(&DEV_T10_WWN(dev)->t10_evpd_lock);
+	spin_unlock(&DEV_T10_WWN(dev)->t10_vpd_lock);
 
 	return;
 }
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index 2877d01..0d2a9a3 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -53,7 +53,7 @@ extern void core_export_port(struct se_device_s *, struct se_portal_group_s *,
 extern void core_release_port(struct se_device_s *, struct se_port_s *);
 extern int transport_core_report_lun_response(se_cmd_t *);
 extern void se_release_device_for_hba(se_device_t *);
-extern void se_release_evpd_for_dev(se_device_t *);
+extern void se_release_vpd_for_dev(se_device_t *);
 extern void se_clear_dev_ports(se_device_t *);
 extern int se_free_virtual_device(se_device_t *, se_hba_t *);
 extern void se_dev_start(se_device_t *);
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 1027634..0cea678 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -1558,7 +1558,7 @@ static int transport_get_inquiry(
 	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	/*
 	 * Save the basic Vendor, Model and Revision in passed t10_wwn_t.
-	 * We will obtain the EVPD in a seperate passthrough operation.
+	 * We will obtain the VPD in a seperate passthrough operation.
 	 */
 	memcpy((void *)&wwn->vendor[0], (void *)&buf[8],
 			sizeof(wwn->vendor));
@@ -1604,7 +1604,7 @@ static int transport_get_inquiry(
 	return 0;
 }
 
-static int transport_get_inquiry_evpd_serial(
+static int transport_get_inquiry_vpd_serial(
 	se_obj_lun_type_t *obj_api,
 	t10_wwn_t *wwn,
 	void *obj_ptr)
@@ -1615,13 +1615,13 @@ static int transport_get_inquiry_evpd_serial(
 
 	memset(cdb, 0, SCSI_CDB_SIZE);
 	cdb[0] = INQUIRY;
-	cdb[1] = 0x01; /* Query EVPD */
+	cdb[1] = 0x01; /* Query VPD */
 	cdb[2] = 0x80; /* Unit Serial Number */
-	cdb[3] = (INQUIRY_EVPD_SERIAL_LEN >> 8) & 0xff;
-	cdb[4] = (INQUIRY_EVPD_SERIAL_LEN & 0xff);
+	cdb[3] = (INQUIRY_VPD_SERIAL_LEN >> 8) & 0xff;
+	cdb[4] = (INQUIRY_VPD_SERIAL_LEN & 0xff);
 
 	cmd = transport_allocate_passthrough(&cdb[0], SE_DIRECTION_READ,
-			0, NULL, 0, INQUIRY_EVPD_SERIAL_LEN, obj_api, obj_ptr);
+			0, NULL, 0, INQUIRY_VPD_SERIAL_LEN, obj_api, obj_ptr);
 	if (!(cmd))
 		return -1;
 
@@ -1632,8 +1632,8 @@ static int transport_get_inquiry_evpd_serial(
 
 	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 
-	printk(KERN_INFO "T10 EVPD Unit Serial Number: %s\n", &buf[4]);
-	snprintf(&wwn->unit_serial[0], INQUIRY_EVPD_SERIAL_LEN, "%s", &buf[4]);
+	printk(KERN_INFO "T10 VPD Unit Serial Number: %s\n", &buf[4]);
+	snprintf(&wwn->unit_serial[0], INQUIRY_VPD_SERIAL_LEN, "%s", &buf[4]);
 
 	transport_passthrough_release(cmd);
 	return 0;
@@ -1641,18 +1641,18 @@ static int transport_get_inquiry_evpd_serial(
 
 static const char hex_str[] = "0123456789abcdef";
 
-void transport_dump_evpd_proto_id(
-	t10_evpd_t *evpd,
+void transport_dump_vpd_proto_id(
+	t10_vpd_t *vpd,
 	unsigned char *p_buf,
 	int p_buf_len)
 {
-	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	unsigned char buf[VPD_TMP_BUF_SIZE];
 	int len;
 
-	memset(buf, 0, EVPD_TMP_BUF_SIZE);
-	len = sprintf(buf, "T10 EVPD Protocol Identifier: ");
+	memset(buf, 0, VPD_TMP_BUF_SIZE);
+	len = sprintf(buf, "T10 VPD Protocol Identifier: ");
 
-	switch (evpd->protocol_identifier) {
+	switch (vpd->protocol_identifier) {
 	case 0x00:
 		sprintf(buf+len, "Fibre Channel\n");
 		break;
@@ -1684,7 +1684,7 @@ void transport_dump_evpd_proto_id(
 		break;
 	default:
 		sprintf(buf+len, "Unknown 0x%02x\n",
-				evpd->protocol_identifier);
+				vpd->protocol_identifier);
 		break;
 	}
 
@@ -1694,7 +1694,7 @@ void transport_dump_evpd_proto_id(
 		printk(KERN_INFO "%s", buf);
 }
 
-void transport_set_evpd_proto_id(t10_evpd_t *evpd, unsigned char *page_83)
+void transport_set_vpd_proto_id(t10_vpd_t *vpd, unsigned char *page_83)
 {
 	/*
 	 * Check if the Protocol Identifier Valid (PIV) bit is set..
@@ -1702,24 +1702,24 @@ void transport_set_evpd_proto_id(t10_evpd_t *evpd, unsigned char *page_83)
 	 * from spc3r23.pdf section 7.5.1
 	 */
 	if (page_83[1] & 0x80) {
-		evpd->protocol_identifier = (page_83[0] & 0xf0);
-		evpd->protocol_identifier_set = 1;
-		transport_dump_evpd_proto_id(evpd, NULL, 0);
+		vpd->protocol_identifier = (page_83[0] & 0xf0);
+		vpd->protocol_identifier_set = 1;
+		transport_dump_vpd_proto_id(vpd, NULL, 0);
 	}
 }
 
-int transport_dump_evpd_assoc(
-	t10_evpd_t *evpd,
+int transport_dump_vpd_assoc(
+	t10_vpd_t *vpd,
 	unsigned char *p_buf,
 	int p_buf_len)
 {
-	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	unsigned char buf[VPD_TMP_BUF_SIZE];
 	int ret = 0, len;
 
-	memset(buf, 0, EVPD_TMP_BUF_SIZE);
-	len = sprintf(buf, "T10 EVPD Identifier Association: ");
+	memset(buf, 0, VPD_TMP_BUF_SIZE);
+	len = sprintf(buf, "T10 VPD Identifier Association: ");
 
-	switch (evpd->association) {
+	switch (vpd->association) {
 	case 0x00:
 		sprintf(buf+len, "addressed logical unit\n");
 		break;
@@ -1730,7 +1730,7 @@ int transport_dump_evpd_assoc(
 		sprintf(buf+len, "SCSI target device\n");
 		break;
 	default:
-		sprintf(buf+len, "Unknown 0x%02x\n", evpd->association);
+		sprintf(buf+len, "Unknown 0x%02x\n", vpd->association);
 		ret = -1;
 		break;
 	}
@@ -1743,29 +1743,29 @@ int transport_dump_evpd_assoc(
 	return ret;
 }
 
-static int transport_set_evpd_assoc(t10_evpd_t *evpd, unsigned char *page_83)
+static int transport_set_vpd_assoc(t10_vpd_t *vpd, unsigned char *page_83)
 {
 	/*
-	 * The EVPD identification association..
+	 * The VPD identification association..
 	 *
 	 * from spc3r23.pdf Section 7.6.3.1 Table 297
 	 */
-	evpd->association = (page_83[1] & 0x30);
-	return transport_dump_evpd_assoc(evpd, NULL, 0);
+	vpd->association = (page_83[1] & 0x30);
+	return transport_dump_vpd_assoc(vpd, NULL, 0);
 }
 
-int transport_dump_evpd_ident_type(
-	t10_evpd_t *evpd,
+int transport_dump_vpd_ident_type(
+	t10_vpd_t *vpd,
 	unsigned char *p_buf,
 	int p_buf_len)
 {
-	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	unsigned char buf[VPD_TMP_BUF_SIZE];
 	int ret = 0, len;
 
-	memset(buf, 0, EVPD_TMP_BUF_SIZE);
-	len = sprintf(buf, "T10 EVPD Identifier Type: ");
+	memset(buf, 0, VPD_TMP_BUF_SIZE);
+	len = sprintf(buf, "T10 VPD Identifier Type: ");
 
-	switch (evpd->device_identifier_type) {
+	switch (vpd->device_identifier_type) {
 	case 0x00:
 		sprintf(buf+len, "Vendor specific\n");
 		break;
@@ -1786,7 +1786,7 @@ int transport_dump_evpd_ident_type(
 		break;
 	default:
 		sprintf(buf+len, "Unsupported: 0x%02x\n",
-				evpd->device_identifier_type);
+				vpd->device_identifier_type);
 		ret = -1;
 		break;
 	}
@@ -1799,43 +1799,43 @@ int transport_dump_evpd_ident_type(
 	return ret;
 }
 
-int transport_set_evpd_ident_type(t10_evpd_t *evpd, unsigned char *page_83)
+int transport_set_vpd_ident_type(t10_vpd_t *vpd, unsigned char *page_83)
 {
 	/*
-	 * The EVPD identifier type..
+	 * The VPD identifier type..
 	 *
 	 * from spc3r23.pdf Section 7.6.3.1 Table 298
 	 */
-	evpd->device_identifier_type = (page_83[1] & 0x0f);
-	return transport_dump_evpd_ident_type(evpd, NULL, 0);
+	vpd->device_identifier_type = (page_83[1] & 0x0f);
+	return transport_dump_vpd_ident_type(vpd, NULL, 0);
 }
 
-int transport_dump_evpd_ident(
-	t10_evpd_t *evpd,
+int transport_dump_vpd_ident(
+	t10_vpd_t *vpd,
 	unsigned char *p_buf,
 	int p_buf_len)
 {
-	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	unsigned char buf[VPD_TMP_BUF_SIZE];
 	int ret = 0;
 
-	memset(buf, 0, EVPD_TMP_BUF_SIZE);
+	memset(buf, 0, VPD_TMP_BUF_SIZE);
 
-	switch (evpd->device_identifier_code_set) {
+	switch (vpd->device_identifier_code_set) {
 	case 0x01: /* Binary */
-		sprintf(buf, "T10 EVPD Binary Device Identifier: %s\n",
-			&evpd->device_identifier[0]);
+		sprintf(buf, "T10 VPD Binary Device Identifier: %s\n",
+			&vpd->device_identifier[0]);
 		break;
 	case 0x02: /* ASCII */
-		sprintf(buf, "T10 EVPD ASCII Device Identifier: %s\n",
-			&evpd->device_identifier[0]);
+		sprintf(buf, "T10 VPD ASCII Device Identifier: %s\n",
+			&vpd->device_identifier[0]);
 		break;
 	case 0x03: /* UTF-8 */
-		sprintf(buf, "T10 EVPD UTF-8 Device Identifier: %s\n",
-			&evpd->device_identifier[0]);
+		sprintf(buf, "T10 VPD UTF-8 Device Identifier: %s\n",
+			&vpd->device_identifier[0]);
 		break;
 	default:
-		sprintf(buf, "T10 EVPD Device Identifier encoding unsupported:"
-			" 0x%02x", evpd->device_identifier_code_set);
+		sprintf(buf, "T10 VPD Device Identifier encoding unsupported:"
+			" 0x%02x", vpd->device_identifier_code_set);
 		ret = -1;
 		break;
 	}
@@ -1848,24 +1848,24 @@ int transport_dump_evpd_ident(
 	return ret;
 }
 
-int transport_set_evpd_ident(t10_evpd_t *evpd, unsigned char *page_83)
+int transport_set_vpd_ident(t10_vpd_t *vpd, unsigned char *page_83)
 {
 	int j = 0, i = 4; /* offset to start of the identifer */
 
 	/*
-	 * The EVPD Code Set (encoding)
+	 * The VPD Code Set (encoding)
 	 *
 	 * from spc3r23.pdf Section 7.6.3.1 Table 296
 	 */
-	evpd->device_identifier_code_set = (page_83[0] & 0x0f);
-	switch (evpd->device_identifier_code_set) {
+	vpd->device_identifier_code_set = (page_83[0] & 0x0f);
+	switch (vpd->device_identifier_code_set) {
 	case 0x01: /* Binary */
-		evpd->device_identifier[j++] =
-				hex_str[evpd->device_identifier_type];
+		vpd->device_identifier[j++] =
+				hex_str[vpd->device_identifier_type];
 		while (i < (4 + page_83[3])) {
-			evpd->device_identifier[j++] =
+			vpd->device_identifier[j++] =
 				hex_str[(page_83[i] & 0xf0) >> 4];
-			evpd->device_identifier[j++] =
+			vpd->device_identifier[j++] =
 				hex_str[page_83[i] & 0x0f];
 			i++;
 		}
@@ -1873,36 +1873,36 @@ int transport_set_evpd_ident(t10_evpd_t *evpd, unsigned char *page_83)
 	case 0x02: /* ASCII */
 	case 0x03: /* UTF-8 */
 		while (i < (4 + page_83[3]))
-			evpd->device_identifier[j++] = page_83[i++];
+			vpd->device_identifier[j++] = page_83[i++];
 
 		break;
 	default:
 		break;
 	}
 
-	return transport_dump_evpd_ident(evpd, NULL, 0);
+	return transport_dump_vpd_ident(vpd, NULL, 0);
 }
 
-static int transport_get_inquiry_evpd_device_ident(
+static int transport_get_inquiry_vpd_device_ident(
 	se_obj_lun_type_t *obj_api,
 	t10_wwn_t *wwn,
 	void *obj_ptr)
 {
 	unsigned char *buf, *page_83;
 	se_cmd_t *cmd;
-	t10_evpd_t *evpd;
+	t10_vpd_t *vpd;
 	unsigned char cdb[SCSI_CDB_SIZE];
 	int ident_len, page_len, off = 4, ret = 0;
 
 	memset(cdb, 0, SCSI_CDB_SIZE);
 	cdb[0] = INQUIRY;
-	cdb[1] = 0x01; /* Query EVPD */
+	cdb[1] = 0x01; /* Query VPD */
 	cdb[2] = 0x83; /* Device Identifier */
-	cdb[3] = (INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN >> 8) & 0xff;
-	cdb[4] = (INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN & 0xff);
+	cdb[3] = (INQUIRY_VPD_DEVICE_IDENTIFIER_LEN >> 8) & 0xff;
+	cdb[4] = (INQUIRY_VPD_DEVICE_IDENTIFIER_LEN & 0xff);
 
 	cmd = transport_allocate_passthrough(&cdb[0], SE_DIRECTION_READ,
-			0, NULL, 0, INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN,
+			0, NULL, 0, INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
 			obj_api, obj_ptr);
 	if (!(cmd))
 		return -1;
@@ -1914,7 +1914,7 @@ static int transport_get_inquiry_evpd_device_ident(
 
 	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	page_len = (buf[2] << 8) | buf[3];
-	printk("T10 EVPD Page Length: %d\n", page_len);
+	printk("T10 VPD Page Length: %d\n", page_len);
 
 	while (page_len > 0) {
 		/* Grab a pointer to the Identification descriptor */
@@ -1925,34 +1925,34 @@ static int transport_get_inquiry_evpd_device_ident(
 					" length zero!\n");
 			break;
 		}
-		printk(KERN_INFO "T10 EVPD Identifer Length: %d\n", ident_len);
+		printk(KERN_INFO "T10 VPD Identifer Length: %d\n", ident_len);
 
-		evpd = kzalloc(sizeof(t10_evpd_t), GFP_KERNEL);
-		if (!(evpd)) {
+		vpd = kzalloc(sizeof(t10_vpd_t), GFP_KERNEL);
+		if (!(vpd)) {
 			printk(KERN_ERR "Unable to allocate memory for"
-					" t10_evpd_t\n");
+					" t10_vpd_t\n");
 			ret = -1;
 			goto out;
 		}
-		INIT_LIST_HEAD(&evpd->evpd_list);
+		INIT_LIST_HEAD(&vpd->vpd_list);
 
-		transport_set_evpd_proto_id(evpd, page_83);
-		transport_set_evpd_assoc(evpd, page_83);
+		transport_set_vpd_proto_id(vpd, page_83);
+		transport_set_vpd_assoc(vpd, page_83);
 
-		if (transport_set_evpd_ident_type(evpd, page_83) < 0) {
+		if (transport_set_vpd_ident_type(vpd, page_83) < 0) {
 			off += (ident_len + 4);
 			page_len -= (ident_len + 4);
-			kfree(evpd);
+			kfree(vpd);
 			continue;
 		}
-		if (transport_set_evpd_ident(evpd, page_83) < 0) {
+		if (transport_set_vpd_ident(vpd, page_83) < 0) {
 			off += (ident_len + 4);
 			page_len -= (ident_len + 4);
-			kfree(evpd);
+			kfree(vpd);
 			continue;
 		}
 
-		list_add_tail(&evpd->evpd_list, &wwn->t10_evpd_list);
+		list_add_tail(&vpd->vpd_list, &wwn->t10_vpd_list);
 		off += (ident_len + 4);
 		page_len -= (ident_len + 4);
 	}
@@ -2142,16 +2142,16 @@ se_device_t *transport_add_device_to_core_hba(
 	if (ret < 0)
 		goto out;
 	/*
-	 * Locate EVPD WWN Information used for various purposes within
+	 * Locate VPD WWN Information used for various purposes within
 	 * the Storage Engine.
 	 */
-	if (!(transport_get_inquiry_evpd_serial(DEV_OBJ_API(dev),
+	if (!(transport_get_inquiry_vpd_serial(DEV_OBJ_API(dev),
 			DEV_T10_WWN(dev), (void *)dev))) {
 		/*
-		 * If EVPD Unit Serial returned GOOD status, try
-		 * EVPD Device Identification page (0x83).
+		 * If VPD Unit Serial returned GOOD status, try
+		 * VPD Device Identification page (0x83).
 		 */
-		transport_get_inquiry_evpd_device_ident(DEV_OBJ_API(dev),
+		transport_get_inquiry_vpd_device_ident(DEV_OBJ_API(dev),
 			DEV_T10_WWN(dev), (void *)dev);
 	}
 
@@ -2187,7 +2187,7 @@ out:
 	hba->dev_count--;
 	spin_unlock(&hba->device_lock);
 
-	se_release_evpd_for_dev(dev);
+	se_release_vpd_for_dev(dev);
 
 	kfree(dev->dev_status_queue_obj);
 	kfree(dev->dev_queue_obj);
@@ -2984,7 +2984,7 @@ int transport_failure_tasks_generic(se_cmd_t *cmd)
 {
 	unsigned long flags;
 	/*
-	 * This causes problems when EVPD INQUIRY fails, disable this
+	 * This causes problems when VPD INQUIRY fails, disable this
 	 * functionality for now.
 	 */
 	se_task_t *task;
@@ -4267,7 +4267,7 @@ extern int transport_generic_emulate_inquiry(
 	case 0x80: /* unit serial number */
 		buf[1] = 0x80;
 		if (dev->se_sub_dev->su_dev_flags &
-					SDF_EMULATED_EVPD_UNIT_SERIAL) {
+					SDF_EMULATED_VPD_UNIT_SERIAL) {
 			unit_serial_len =
 				strlen(&DEV_T10_WWN(dev)->unit_serial[0]);
 			unit_serial_len++; /* For NULL Terminator */
@@ -4298,7 +4298,7 @@ extern int transport_generic_emulate_inquiry(
 		break;
 	case 0x83:
 		/*
-		 * Device identification EVPD, for a complete list of
+		 * Device identification VPD, for a complete list of
 		 * DESIGNATOR TYPEs see spc4r17 Table 459.
 		 */
 		buf[1] = 0x83;
@@ -4308,11 +4308,11 @@ extern int transport_generic_emulate_inquiry(
 		 * see spc4r17 section 7.7.3.6.5
 		 *
 		 * We depend upon a target_core_mod/ConfigFS provided
-		 * /sys/kernel/config/target/core/$HBA/$DEV/wwn/evpd_unit_serial
+		 * /sys/kernel/config/target/core/$HBA/$DEV/wwn/vpd_unit_serial
 		 * value in order to return the NAA id.
 		 */
 		if (!(dev->se_sub_dev->su_dev_flags &
-					SDF_EMULATED_EVPD_UNIT_SERIAL))
+					SDF_EMULATED_VPD_UNIT_SERIAL))
 			goto check_t10_vend_desc;
 		if ((off + 20) > cmd->data_length)
 			goto check_t10_vend_desc;
@@ -4357,13 +4357,13 @@ check_t10_vend_desc:
 		 * T10 Vendor Identifier Page, see spc4r17 section 7.7.3.4
 		 */
 		id_len = 8; /* For Vendor field */
-		prod_len = 4; /* For EVPD Header */
+		prod_len = 4; /* For VPD Header */
 		prod_len += 8; /* For Vendor field */
 		prod_len += strlen(prod);
 		prod_len++; /* For : */
 
 		if (dev->se_sub_dev->su_dev_flags &
-					SDF_EMULATED_EVPD_UNIT_SERIAL) {
+					SDF_EMULATED_VPD_UNIT_SERIAL) {
 			unit_serial_len =
 				strlen(&DEV_T10_WWN(dev)->unit_serial[0]);
 			unit_serial_len++; /* For NULL Terminator */
@@ -4405,7 +4405,7 @@ check_t10_vend_desc:
 		len += (id_len + 4);
 		off += (id_len + 4);
 		/*
-		 * se_port_t is only set for INQUIRY EVPD=1 through $FABRIC_MOD
+		 * se_port_t is only set for INQUIRY VPD=1 through $FABRIC_MOD
 		 */
 check_port:
 		port = lun->lun_sep;
@@ -4577,10 +4577,10 @@ check_scsi_name:
 		}
 set_len:
 		buf[2] = ((len >> 8) & 0xff);
-		buf[3] = (len & 0xff); /* Page Length for EVPD 0x83 */
+		buf[3] = (len & 0xff); /* Page Length for VPD 0x83 */
 		break;
 	default:
-		printk(KERN_ERR "Unknown EVPD Code: 0x%02x\n", cdb[2]);
+		printk(KERN_ERR "Unknown VPD Code: 0x%02x\n", cdb[2]);
 		return -1;
 	}
 
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 52dd23f..485fb8e 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -78,8 +78,8 @@
 /*
  * se_subsystem_dev_t->su_dev_flags
 */
-#define SDF_FIRMWARE_EVPD_UNIT_SERIAL		0x00000001
-#define SDF_EMULATED_EVPD_UNIT_SERIAL		0x00000002
+#define SDF_FIRMWARE_VPD_UNIT_SERIAL		0x00000001
+#define SDF_EMULATED_VPD_UNIT_SERIAL		0x00000002
 
 /*
  * se_device_t->dev_flags
@@ -164,13 +164,13 @@ unsigned char *transport_dump_cmd_direction (struct se_cmd_s *);
 extern void transport_dump_dev_state(struct se_device_s *, char *, int *);
 extern void transport_dump_dev_info(struct se_device_s *, struct se_lun_s *,
 					unsigned long long, char *, int *);
-extern void transport_dump_evpd_proto_id(struct t10_evpd_s *,
+extern void transport_dump_vpd_proto_id(struct t10_vpd_s *,
 					unsigned char *, int);
-extern int transport_dump_evpd_assoc(struct t10_evpd_s *,
+extern int transport_dump_vpd_assoc(struct t10_vpd_s *,
 					unsigned char *, int);
-extern int transport_dump_evpd_ident_type(struct t10_evpd_s *,
+extern int transport_dump_vpd_ident_type(struct t10_vpd_s *,
 					unsigned char *, int);
-extern int transport_dump_evpd_ident(struct t10_evpd_s *,
+extern int transport_dump_vpd_ident(struct t10_vpd_s *,
 					unsigned char *, int);
 extern se_device_t *transport_add_device_to_core_hba(se_hba_t *,
 					struct se_subsystem_api_s *,
@@ -482,14 +482,6 @@ typedef struct se_subsystem_api_s {
 	 */
 	u32 (*get_dma_length)(u32, se_device_t *);
 	/*
-	 * get_evpd_prod():
-	 */
-	void (*get_evpd_prod)(unsigned char *, u32, se_device_t *);
-	/*
-	 * get_evpd_sn():
-	 */
-	void (*get_evpd_sn)(unsigned char *, u32, se_device_t *);
-	/*
 	 * get_max_cdbs():
 	 */
 	u32 (*get_max_cdbs)(se_device_t *);
-- 
1.5.4.1



