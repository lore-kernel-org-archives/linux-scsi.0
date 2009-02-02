From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] [Target_Core_Mod]: Move core se_port_t logic to
	target_core_device.c
Date: Sun, 01 Feb 2009 22:00:00 -0800
Message-ID: <1233554400.12375.39.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:31701 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751295AbZBBGBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2009 01:01:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Zhang <blackmagic02881@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

>From 12ba78888935ebf41ee769f57aced3e3599c7a8c Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sun, 1 Feb 2009 21:29:03 -0800
Subject: [PATCH 1/4] [Target_Core_Mod]: Move core se_port_t logic to target_core_device.c

This patch adds core_alloc_port(), core_export_port() and core_release_port()
and adds their usage in dev_obj_export() and dev_obj_unexport().

Also, in core_alloc_port() the RELATIVE TARGET PORT IDENTIFER gets set to
a unique 16-bit value per se_device_t using se_device_t->dev_rpti_counter.
This value now replaces previous SCSI MIB SCSI_PORT_INDEX usage with
se_port_t->sep_rtpi for SCSI MIB se_port_t->sep_index value assignment.

Here is what it looks like with active LIO-Target v3.0 iSCSI Target ports,
the RELATIVE TARGET PORT IDENTIFER is displayed under the port_index column:

The first two rows are for a single Target_Core_Mod/IBLOCK storage object that
is exported across two different iSCSI Target Endports (TargetName+TPGT):

target:# cat /proc/scsi_target/mib/scsi_tgt_port
inst device indx name port_index in_cmds write_mbytes read_mbytes hs_in_cmds
1 1 0 iSCSIPort#0 iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0+t+1 20 0 0 0
1 1 1 iSCSIPort#1 iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd+t+1 9 0 0 0
2 2 0 iSCSIPort#0 iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0+t+1 0 0 0 0
3 3 0 iSCSIPort#0 iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0+t+1 0 0 0 0

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h   |    4 +-
 drivers/lio-core/target_core_device.c |   66 +++++++++++++++++++++++++++++++++
 drivers/lio-core/target_core_device.h |    3 +
 drivers/lio-core/target_core_mib.h    |    1 -
 drivers/lio-core/target_core_seobj.c  |   33 +++-------------
 5 files changed, 78 insertions(+), 29 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index c900517..5e979ff 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -536,7 +536,9 @@ typedef struct se_device_s {
 	u8			type;		/* Type of disk transport used for device */
 	u8			thread_active;	/* Set to 1 if thread is NOT sleeping on thread_sem */
 	u8			dev_status_timer_flags;
+	u16			dev_rpti_counter; /* RELATIVE TARGET PORT IDENTIFER Counter */
 	u32			dev_flags;
+	u32			dev_port_count;
 	u32			dev_status;
 	u32			dev_tcq_window_closed;
 	u32			queue_depth;	/* Physical device queue depth */
@@ -544,7 +546,6 @@ typedef struct se_device_s {
 	void 			*dev_ptr; 	/* Pointer to transport specific device structure */
 #ifdef SNMP_SUPPORT
 	u32			dev_index;
-	u32			dev_port_count;
 	u64			creation_time;
 	u32			num_resets;
 	u64			num_cmds;
@@ -653,6 +654,7 @@ typedef struct se_lun_s {
 #define LUN_OBJ_API(lun)	((struct se_obj_lun_type_s *)(lun)->lun_obj_api)
 
 typedef struct se_port_s {
+	u16		sep_rtpi; /* RELATIVE TARGET PORT IDENTIFER */
 #ifdef SNMP_SUPPORT
         u32             sep_index;
         scsi_port_stats_t sep_stats;
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 98334a4..53741d8 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -491,6 +491,72 @@ extern void core_clear_lun_from_tpg (se_lun_t *lun, se_portal_group_t *tpg)
         return;
 }
 
+extern se_port_t *core_alloc_port (se_device_t *dev)
+{
+	se_port_t *port, *port_tmp;
+	
+	if (!(port = kzalloc(sizeof(se_port_t), GFP_KERNEL))) {
+		printk(KERN_ERR "Unable to allocate se_port_t\n");
+		return(NULL);
+	}
+	INIT_LIST_HEAD(&port->sep_list);
+
+	spin_lock(&dev->se_port_lock);
+	if (dev->dev_port_count == 0x0000ffff) {
+		printk(KERN_WARNING "Reached dev->dev_port_count == 0x0000ffff\n");
+		spin_unlock(&dev->se_port_lock);
+		return(NULL);
+	}
+again:
+	port->sep_rtpi = dev->dev_rpti_counter++;
+	list_for_each_entry(port_tmp, &dev->dev_sep_list, sep_list) {
+		/*
+		 * Make sure RELATIVE TARGET PORT IDENTIFER is unique
+		 * for 16-bit wrap..
+		 */
+		if (port->sep_rtpi == port_tmp->sep_rtpi) 
+			goto again;
+	}
+	spin_unlock(&dev->se_port_lock);
+
+	return(port);
+}
+
+extern void core_export_port (
+	se_device_t *dev,
+	se_portal_group_t *tpg,
+	se_port_t *port,
+	se_lun_t *lun)
+{
+	spin_lock(&dev->se_port_lock);
+	spin_lock(&lun->lun_sep_lock);
+	port->sep_tpg = tpg;
+	port->sep_lun = lun;
+	lun->lun_sep = port;
+	spin_unlock(&lun->lun_sep_lock);
+
+	list_add_tail(&port->sep_list, &dev->dev_sep_list);
+	spin_unlock(&dev->se_port_lock);
+
+	dev->dev_port_count++;
+#ifdef SNMP_SUPPORT
+	port->sep_index = port->sep_rtpi; /* RELATIVE TARGET PORT IDENTIFER */
+#endif
+	return;
+}
+
+/*
+ *	Called with se_device_t->se_port_lock spinlock held.
+ */
+extern void core_release_port (se_device_t *dev, se_port_t *port)
+{
+	list_del(&port->sep_list);
+	dev->dev_port_count--;
+	kfree(port);
+
+	return;
+}
+
 extern int transport_core_report_lun_response (se_cmd_t *se_cmd)
 {
 	se_dev_entry_t *deve;
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index c2d4b12..eff0c0a 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -40,6 +40,9 @@ extern void core_dec_lacl_count (struct se_node_acl_s *, struct se_cmd_s *);
 extern void core_update_device_list_access (u32, u32, se_node_acl_t *);
 extern void core_update_device_list_for_node (se_lun_t *lun, u32, u32, se_node_acl_t *, se_portal_group_t *, int);
 extern void core_clear_lun_from_tpg (se_lun_t *, se_portal_group_t *);
+extern struct se_port_s *core_alloc_port (struct se_device_s *);
+extern void core_export_port (struct se_device_s *, struct se_portal_group_s *, struct se_port_s *, struct se_lun_s *);
+extern void core_release_port (struct se_device_s *, struct se_port_s *);
 extern int transport_core_report_lun_response (se_cmd_t *);
 extern void se_release_device_for_hba (se_device_t *);
 extern void se_release_evpd_for_dev (se_device_t *);
diff --git a/drivers/lio-core/target_core_mib.h b/drivers/lio-core/target_core_mib.h
index d4a9d31..127d113 100644
--- a/drivers/lio-core/target_core_mib.h
+++ b/drivers/lio-core/target_core_mib.h
@@ -30,7 +30,6 @@
 typedef enum {
 	SCSI_INST_INDEX,
 	SCSI_DEVICE_INDEX,
-	SCSI_PORT_INDEX,
 	SCSI_AUTH_INTR_INDEX,
 	SCSI_INDEX_TYPE_MAX
 } scsi_index_t;
diff --git a/drivers/lio-core/target_core_seobj.c b/drivers/lio-core/target_core_seobj.c
index 182a016..643659c 100644
--- a/drivers/lio-core/target_core_seobj.c
+++ b/drivers/lio-core/target_core_seobj.c
@@ -185,45 +185,28 @@ extern void dev_put_obj (void *p)
 extern int dev_obj_export (void *p, se_portal_group_t *tpg, se_lun_t *lun)
 {
 	se_device_t *dev  = (se_device_t *)p;
-	se_port_t *sep;
+	se_port_t *port;
 
-	if (!(sep = kmalloc(sizeof(se_port_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate se_port_t\n");
+	if (!(port = core_alloc_port(dev)))
 		return(-1);
-	}
-	memset(sep, 0, sizeof(se_port_t));
-	INIT_LIST_HEAD(&sep->sep_list);
 
 	lun->se_dev = dev;
 	if (DEV_OBJ_API(dev)->activate(p) < 0) {
 		lun->se_dev = NULL;
-		kfree(sep);
+		kfree(port);
 		return(-1);
 	}
 
 	DEV_OBJ_API(dev)->inc_count(&dev->dev_export_obj);
 
-	spin_lock(&dev->se_port_lock);
-	spin_lock(&lun->lun_sep_lock);
-	sep->sep_tpg = tpg;
-	sep->sep_lun = lun;
-	lun->lun_sep = sep;
-	spin_unlock(&lun->lun_sep_lock);
-
-	list_add_tail(&sep->sep_list, &dev->dev_sep_list);
-	spin_unlock(&dev->se_port_lock);
-#ifdef SNMP_SUPPORT
-	dev->dev_port_count++;
-	sep->sep_index = scsi_get_new_index(SCSI_PORT_INDEX);
-#endif
-
+	core_export_port(dev, tpg, port, lun);
 	return(0);
 }
 
 extern void dev_obj_unexport (void *p, se_portal_group_t *tpg, se_lun_t *lun)
 {
 	se_device_t *dev  = (se_device_t *)p;
-	se_port_t *sep = lun->lun_sep;
+	se_port_t *port = lun->lun_sep;
 
 	spin_lock(&dev->se_port_lock);
 	spin_lock(&lun->lun_sep_lock);
@@ -236,12 +219,8 @@ extern void dev_obj_unexport (void *p, se_portal_group_t *tpg, se_lun_t *lun)
 
 	DEV_OBJ_API(dev)->dec_count(&dev->dev_export_obj);
 
-	list_del(&sep->sep_list);
+	core_release_port(dev, port);
 	spin_unlock(&dev->se_port_lock);
-#ifdef SNMP_SUPPORT
-	dev->dev_port_count--;
-#endif  
-	kfree(sep);
 
 	DEV_OBJ_API(dev)->deactivate(p);
 	lun->se_dev = NULL;
-- 
1.5.4.1



