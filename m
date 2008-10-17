From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Added CONFIGFS_SYSFS_SYMLINKS
	support
Date: Fri, 17 Oct 2008 00:02:37 -0700
Message-ID: <1224226957.5556.287.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yCYQdYa3sv5jBRRLeAf0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:39848 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751589AbYJQHCl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 03:02:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <joel.becker@oracle.com>, Greg KH <greg@kroah.com>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@osdl.org>


--=-yCYQdYa3sv5jBRRLeAf0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Added allow_link_kobject() and drop_link_kobject() calls to
/sys/kernel/config/target/core/$HBA_$ID/$STORAGE_OBJECT

Then means the following code now works for accessing struct block_device
and struct scsi_device through Linux/BLOCK and Linux/SCSI subsystems
respectively.

export TARGET=/sys/kernel/config/target/core/
export FABRIC=/sys/kernel/config/target/iscsi/

mkdir -p $TARGET/iblock_0/lvm_test0
ln -s /sys/block/dm-2 $TARGET/iblock_0/lvm_test0/dm-2

mkdir -p $TARGET/pscsi_0/sdd
ln -s /sys/block/sdd/device $TARGET/pscsi_0/sdd/passthrough

export DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"

<SNIP..>

mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_west_port"
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
ln -s $TARGET/pscsi_0/sdd "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"

Signed-off-by: Nicholas A. Bellinger
---
 drivers/lio-core/MCONFIG_TARGET          |    1 +
 drivers/lio-core/Makefile                |    3 +
 drivers/lio-core/target_core_configfs.c  |   95 +++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_iblock.c    |   18 ++++++
 drivers/lio-core/target_core_iblock.h    |    2 +
 drivers/lio-core/target_core_plugin.c    |    2 +-
 drivers/lio-core/target_core_pscsi.c     |   20 ++++++
 drivers/lio-core/target_core_pscsi.h     |    2 +
 drivers/lio-core/target_core_transport.h |    4 +
 9 files changed, 145 insertions(+), 2 deletions(-)

The commit can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=7549c55a99139de114852f0e0b356f7ec0739b35

The commit that enables kobject symlinks in configfs can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=317aefe74354c0140dc8aebff1ef9467b6f0c9ba


Comments Folks..?

--nab


--=-yCYQdYa3sv5jBRRLeAf0
Content-Disposition: attachment; filename=0002-Target_Core_Mod-ConfigFS-Added-CONFIGFS_SYSFS_SYM.patch
Content-Type: application/mbox; name=0002-Target_Core_Mod-ConfigFS-Added-CONFIGFS_SYSFS_SYM.patch
Content-Transfer-Encoding: 7bit

>From 7549c55a99139de114852f0e0b356f7ec0739b35 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 16 Oct 2008 22:53:01 -0700
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Added CONFIGFS_SYSFS_SYMLINKS support

Added allow_link_kobject() and drop_link_kobject() calls to
/sys/kernel/config/target/core/$HBA_$ID/$STORAGE_OBJECT

Then means the following code now works for accessing struct block_device
and struct scsi_device through Linux/BLOCK and Linux/SCSI subsystems
respectively.

export TARGET=/sys/kernel/config/target/core/
export FABRIC=/sys/kernel/config/target/iscsi/

mkdir -p $TARGET/iblock_0/lvm_test0
ln -s /sys/block/dm-2 $TARGET/iblock_0/lvm_test0/dm-2

mkdir -p $TARGET/pscsi_0/sdd
ln -s /sys/block/sdd/device $TARGET/pscsi_0/sdd/passthrough

export DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"

<SNIP..>

mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_west_port"
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
ln -s $TARGET/pscsi_0/sdd "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"

Signed-off-by: Nicholas A. Bellinger
---
 drivers/lio-core/MCONFIG_TARGET          |    1 +
 drivers/lio-core/Makefile                |    3 +
 drivers/lio-core/target_core_configfs.c  |   95 +++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_iblock.c    |   18 ++++++
 drivers/lio-core/target_core_iblock.h    |    2 +
 drivers/lio-core/target_core_plugin.c    |    2 +-
 drivers/lio-core/target_core_pscsi.c     |   20 ++++++
 drivers/lio-core/target_core_pscsi.h     |    2 +
 drivers/lio-core/target_core_transport.h |    4 +
 9 files changed, 145 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/MCONFIG_TARGET b/drivers/lio-core/MCONFIG_TARGET
index 4b6a6f7..f923db6 100644
--- a/drivers/lio-core/MCONFIG_TARGET
+++ b/drivers/lio-core/MCONFIG_TARGET
@@ -24,3 +24,4 @@ LINUX_MEDIA_CHANGER ?= 0
 LINUX_EVPD_PAGE_CHECK?=1
 
 LIO_TARGET_CONFIGFS?=1
+CONFIGFS_SYSFS_SYMLINKS?=1
diff --git a/drivers/lio-core/Makefile b/drivers/lio-core/Makefile
index 12df454..128a2d7 100644
--- a/drivers/lio-core/Makefile
+++ b/drivers/lio-core/Makefile
@@ -109,6 +109,9 @@ ifeq ($(LIO_TARGET_CONFIGFS), 1)
 iscsi_target_mod-objs		+=	iscsi_target_configfs.o
 EXTRA_CFLAGS			+=	-DLIO_TARGET_CONFIGFS
 endif
+ifeq ($(CONFIGFS_SYSFS_SYMLINKS), 1)
+EXTRA_CFLAGS			+=	-DCONFIGFS_SYSFS_SYMLINKS
+endif
 ifeq ($(ERLTWO), 1)
 EXTRA_CFLAGS += -DERLONE -DERLTWO
 else
diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index ef9de22..c73d934 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -586,6 +586,10 @@ static ssize_t target_core_store_dev_enable (void *p, const char *page, size_t c
 		printk(KERN_ERR "For dev_enable ops, only valid value is \"1\"\n");
 		return(-EINVAL);
 	}
+	if ((se_dev->se_dev_ptr)) {
+		printk(KERN_ERR "se_dev->se_dev_ptr already set for storage object\n");
+		return(-EEXIST);
+	}	
 
 	t = (se_subsystem_api_t *)plugin_get_obj(PLUGIN_TYPE_TRANSPORT, hba->type, &ret);
 	if (!t || (ret != 0)) 
@@ -646,10 +650,99 @@ static ssize_t target_core_dev_store (struct config_item *item,
 	return(tc_attr->store((void *)se_dev, page, count));
 }
 
+#ifdef CONFIGFS_SYSFS_SYMLINKS
+
+static int target_core_dev_link_kobject (struct config_item *item,
+					 struct kobject *kobj)
+{
+	se_subsystem_dev_t *se_dev = container_of(
+			to_config_group(item), se_subsystem_dev_t, se_dev_group);
+	se_hba_t *hba, *hba_p = se_dev->se_dev_hba;
+	se_subsystem_api_t *t;
+	int ret = 0;
+
+	if (!(hba = core_get_hba_from_id(hba_p->hba_id, 0)))
+		return(-EINVAL);
+
+	if ((se_dev->se_dev_ptr)) {
+		printk(KERN_ERR "se_dev->se_dev_ptr already set for this storage object\n");
+		ret = -EEXIST;
+		goto out;
+	}
+	
+	t = (se_subsystem_api_t *)plugin_get_obj(PLUGIN_TYPE_TRANSPORT, hba->type, &ret);
+	if (!t || (ret != 0))
+		goto out;
+
+	if (!(t->kobject_link)) {	
+		printk(KERN_ERR "Missing se_subsystem_api_t->kobject_link()\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!(se_dev->se_dev_ptr = t->kobject_link(se_dev, item, kobj))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	printk("Target_Core_ConfigFS: Linking %s -> %s\n",
+		config_item_name(item), kobject_name(kobj));
+
+	core_put_hba(hba);
+	return(0);
+out:
+	core_put_hba(hba);
+	return(ret);
+}
+
+static int target_core_dev_unlink_kobject (struct config_item *item,
+					   struct kobject *kobj)
+{
+	se_subsystem_dev_t *se_dev = container_of(
+		to_config_group(item), se_subsystem_dev_t, se_dev_group);
+	se_hba_t *hba, *hba_p = se_dev->se_dev_hba;
+	int ret = 0;
+
+	if (!(hba = core_get_hba_from_id(hba_p->hba_id, 0)))
+		return(-EINVAL);
+
+	if (!(se_dev->se_dev_su_ptr)) {
+		printk(KERN_ERR "Unable to locate se_subsystem_dev_t>se_dev_su_ptr\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	printk("Target_Core_ConfigFS: Calling se_free_virtual_device() for"
+			" se_dev_ptr: %p\n", se_dev->se_dev_ptr);
+
+	if ((ret = se_free_virtual_device(se_dev->se_dev_ptr, hba)) < 0)
+		goto out;
+	/*
+	 * Clear released se_subsystem_dev_t pointers so target_core_call_freedev()
+	 * below plays nice..
+	 */
+	se_dev->se_dev_ptr = NULL;
+	se_dev->se_dev_su_ptr = NULL;
+	printk("Target_Core_ConfigFS: Unlinking %s from %s\n",
+		config_item_name(item), kobject_name(kobj));
+
+	core_put_hba(hba);
+	return(0);
+out:
+	core_put_hba(hba);
+	return(ret);
+}
+
+#endif /* CONFIGFS_SYSFS_SYMLINKS */
+
 static struct configfs_item_operations target_core_dev_item_ops = {
 	.release		= NULL,
 	.show_attribute		= target_core_dev_show,
 	.store_attribute	= target_core_dev_store,
+#ifdef CONFIGFS_SYSFS_SYMLINKS
+	.allow_link_kobject	= target_core_dev_link_kobject,
+	.drop_link_kobject	= target_core_dev_unlink_kobject,
+#endif
 };
 
 static struct config_item_type target_core_dev_cit = {
@@ -756,7 +849,7 @@ static void target_core_call_freedev (
 
 		if ((ret = se_free_virtual_device(se_dev->se_dev_ptr, hba)) < 0)
 			goto hba_out;
-	} else {
+	} else if (se_dev->se_dev_su_ptr) {
 		/*
 		 * Release se_subsystem_dev_t->se_dev_su_ptr..
 		 */
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 8303786..c84ec21 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -636,6 +636,24 @@ extern ssize_t iblock_show_configfs_dev_params (se_hba_t *hba, se_subsystem_dev_
 	return((ssize_t)bl);
 }
 
+extern se_device_t *iblock_kobject_link (
+	se_subsystem_dev_t *se_dev,
+	struct config_item *item,
+	struct kobject *kobj)
+{
+	iblock_dev_t *ibd = (iblock_dev_t *)se_dev->se_dev_su_ptr;
+	se_hba_t *se_hba = se_dev->se_dev_hba;
+	struct device *d = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(d);
+
+	ibd->ibd_major = gd->major;	
+	ibd->ibd_flags |= IBDF_HAS_MAJOR;
+	ibd->ibd_minor = gd->first_minor;
+	ibd->ibd_flags |= IBDF_HAS_MINOR;
+
+	return(iblock_create_virtdevice(se_hba, (void *)ibd));
+}
+
 extern int iblock_check_dev_params (se_hba_t *hba, struct iscsi_target *t, se_dev_transport_info_t *dti)
 {
 	if (!(t->hba_params_set & PARAM_HBA_IBLOCK_MAJOR) ||
diff --git a/drivers/lio-core/target_core_iblock.h b/drivers/lio-core/target_core_iblock.h
index 2c793b7..e5e5492 100644
--- a/drivers/lio-core/target_core_iblock.h
+++ b/drivers/lio-core/target_core_iblock.h
@@ -66,6 +66,7 @@ extern int iblock_check_hba_params (se_hbainfo_t *, struct iscsi_target *, int);
 extern ssize_t iblock_set_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *, const char *, ssize_t);
 extern ssize_t iblock_check_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *);
 extern ssize_t iblock_show_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *, char *);
+extern se_device_t *iblock_kobject_link (se_subsystem_dev_t *, struct config_item *, struct kobject *);
 extern int iblock_check_dev_params (se_hba_t *, struct iscsi_target *, se_dev_transport_info_t *);
 extern int iblock_check_virtdev_params (se_devinfo_t *di, struct iscsi_target *);
 extern void iblock_get_plugin_info (void *, char *, int *);
@@ -160,6 +161,7 @@ se_subsystem_spc_t iblock_template_spc = ISCSI_IBLOCK_SPC;
 	check_configfs_dev_params: iblock_check_configfs_dev_params, \
 	set_configfs_dev_params: iblock_set_configfs_dev_params, \
 	show_configfs_dev_params: iblock_show_configfs_dev_params, \
+	kobject_link:		iblock_kobject_link,		\
 	check_virtdev_params:	iblock_check_virtdev_params,	\
 	check_dev_params:	iblock_check_dev_params,	\
 	get_plugin_info:	iblock_get_plugin_info,		\
diff --git a/drivers/lio-core/target_core_plugin.c b/drivers/lio-core/target_core_plugin.c
index 3fcb83f..4f72452 100644
--- a/drivers/lio-core/target_core_plugin.c
+++ b/drivers/lio-core/target_core_plugin.c
@@ -220,7 +220,7 @@ extern void *plugin_get_obj (
 	*ret = 0;
 	return(p->plugin_obj);
 out:
-	*ret = -1;
+	*ret = -EINVAL;
 	spin_unlock(&pc->plugin_lock);
 	return(NULL);
 }
diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
index f8fd2d5..f0b1bed 100644
--- a/drivers/lio-core/target_core_pscsi.c
+++ b/drivers/lio-core/target_core_pscsi.c
@@ -1011,6 +1011,26 @@ extern ssize_t pscsi_show_configfs_dev_params (se_hba_t *hba, se_subsystem_dev_t
 	return((ssize_t)bl);
 }
 
+extern se_device_t *pscsi_kobject_link (
+	se_subsystem_dev_t *se_dev,
+	struct config_item *item,
+	struct kobject *kobj)
+{
+	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) se_dev->se_dev_su_ptr;
+	se_hba_t *se_hba = se_dev->se_dev_hba;
+	struct device *d = kobj_to_dev(kobj);
+	struct scsi_device *sd = to_scsi_device(d);
+
+	pdv->pdv_channel_id = sd->channel;	
+	pdv->pdv_flags |= PDF_HAS_CHANNEL_ID;
+	pdv->pdv_target_id = sd->id;
+	pdv->pdv_flags |= PDF_HAS_TARGET_ID;
+	pdv->pdv_lun_id = sd->lun;
+	pdv->pdv_flags |= PDF_HAS_LUN_ID;
+
+	return(pscsi_create_virtdevice(se_hba, (void *)pdv));
+}
+
 extern int pscsi_check_dev_params (se_hba_t *hba, struct iscsi_target *t, se_dev_transport_info_t *dti)
 {
 	if (!(t->hba_params_set & PARAM_HBA_SCSI_CHANNEL_ID)) {
diff --git a/drivers/lio-core/target_core_pscsi.h b/drivers/lio-core/target_core_pscsi.h
index 74d444b..aa5e339 100644
--- a/drivers/lio-core/target_core_pscsi.h
+++ b/drivers/lio-core/target_core_pscsi.h
@@ -75,6 +75,7 @@ extern int pscsi_check_hba_params (se_hbainfo_t *, struct iscsi_target *, int);
 extern ssize_t pscsi_set_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *, const char *, ssize_t);
 extern ssize_t pscsi_check_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *);
 extern ssize_t pscsi_show_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *, char *);
+extern se_device_t *pscsi_kobject_link (se_subsystem_dev_t *, struct config_item *, struct kobject *);
 extern int pscsi_check_dev_params (se_hba_t *, struct iscsi_target *, se_dev_transport_info_t *);
 extern void pscsi_get_plugin_info (void *, char *, int *);
 extern void pscsi_get_hba_info (se_hba_t *, char *, int *);
@@ -166,6 +167,7 @@ se_subsystem_spc_t pscsi_template_spc = ISCSI_PSCSI_SPC;
 	check_configfs_dev_params: pscsi_check_configfs_dev_params, \
 	set_configfs_dev_params: pscsi_set_configfs_dev_params, \
 	show_configfs_dev_params: pscsi_show_configfs_dev_params, \
+	kobject_link:		pscsi_kobject_link,		\
 	check_dev_params:	pscsi_check_dev_params,		\
 	get_plugin_info:	pscsi_get_plugin_info,		\
 	get_hba_info:		pscsi_get_hba_info,		\
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 7f96176..28b20d0 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -427,6 +427,10 @@ typedef struct se_subsystem_api_s {
 	 */	
 	ssize_t (*show_configfs_dev_params)(se_hba_t *, se_subsystem_dev_t *, char *);
 	/*
+	 * kobject_link():
+	 */
+	se_device_t *(*kobject_link)(se_subsystem_dev_t *, struct config_item *, struct kobject *);
+	/*
 	 * check_dev_params():
 	 */
 	int (*check_dev_params)(se_hba_t *, struct iscsi_target *, se_dev_transport_info_t *);
-- 
1.5.4.1


--=-yCYQdYa3sv5jBRRLeAf0--

