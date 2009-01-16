From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod]: Move 10_wwn_t to
	se_subsystem_dev_t->t10_wwn
Date: Thu, 15 Jan 2009 23:51:47 -0800
Message-ID: <1232092307.1274.172.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45766 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756356AbZAPHwM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 02:52:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>

>From ec3803b64955f2195ee6ec67c264431dea1e7a26 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 15 Jan 2009 18:37:15 -0800
Subject: [PATCH 1/2] [Target_Core_Mod]: Move 10_wwn_t to se_subsystem_dev_t->t10_wwn

This patch moves se_device_t->t10_wwn to se_subsystem_dev_t->t10_wwn in order to hang
a struct config_group for /sys/kernel/config/target/core/$HBA/$STORAGE_OBJECT/wwn.
It adds the macro target_core_base.h:DEV_T10_WWN(), and converts usage in
target_core_device,c, target_core_mib.c, target_core_mib_seobj.c and
target_core_transport.c

This patch also adds t10_evpd_t>protocol_identifier_set usage in
transport_set_evpd_proto_id(), and adds the function prototypes for
transport_dump_evpd_*()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |    6 +++++-
 drivers/lio-core/target_core_device.c    |    8 ++++----
 drivers/lio-core/target_core_mib.c       |   30 +++++++++++++++---------------
 drivers/lio-core/target_core_seobj.c     |    2 +-
 drivers/lio-core/target_core_transport.c |   19 +++++++++++++------
 drivers/lio-core/target_core_transport.h |    4 ++++
 6 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index fe4ff8b..8b0bfcd 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -236,6 +236,7 @@ typedef struct se_obj_s {
 
 typedef struct t10_evpd_s {
 	unsigned char device_identifier[INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN];
+	int protocol_identifier_set;
 	u32 protocol_identifier;
 	u32 device_identifier_code_set;
 	u32 association;
@@ -249,6 +250,8 @@ typedef struct t10_wwn_s {
 	unsigned char revision[4];
         unsigned char unit_serial[INQUIRY_EVPD_SERIAL_LEN];
 	spinlock_t t10_evpd_lock;
+	struct se_subsystem_dev_s *t10_sub_dev;
+	struct config_group t10_wwn_group;
 	struct list_head t10_evpd_list;
 } ____cacheline_aligned t10_wwn_t;
 
@@ -530,6 +533,7 @@ typedef struct se_subsystem_dev_s {
         struct se_hba_s *se_dev_hba;
         struct se_device_s *se_dev_ptr;
         se_dev_attrib_t se_dev_attrib;
+	t10_wwn_t	t10_wwn;        /* T10 Inquiry and EVPD WWN Information */
         spinlock_t      se_dev_lock;
         void            *se_dev_su_ptr;
         struct config_group se_dev_group;
@@ -577,7 +581,6 @@ typedef struct se_device_s {
 	struct task_struct		*process_thread; /* Pointer to descriptor for processing thread */
         pid_t                   process_thread_pid;
 	struct task_struct		*dev_mgmt_thread;
-	t10_wwn_t		t10_wwn;	/* T10 Inquiry and EVPD WWN Information */
 	int (*write_pending)(struct se_task_s *);
 	void (*dev_generate_cdb)(unsigned long long, u32 *, unsigned char *, int);
 	struct se_obj_lun_type_s *dev_obj_api;
@@ -594,6 +597,7 @@ typedef struct se_device_s {
 
 #define ISCSI_DEV(cmd)		((se_device_t *)(cmd)->se_lun->se_dev)
 #define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
+#define DEV_T10_WWN(dev)	(&(dev)->se_sub_dev->t10_wwn)
 #define DEV_OBJ_API(dev)	((struct se_obj_lun_type_s *)(dev)->dev_obj_api)
 
 typedef struct se_hba_s {
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index f52eddc..16e7766 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -606,13 +606,13 @@ extern void se_release_evpd_for_dev (se_device_t *dev)
 {
 	t10_evpd_t *evpd, *evpd_tmp;
 
-	spin_lock(&dev->t10_wwn.t10_evpd_lock);
-	list_for_each_entry_safe(evpd, evpd_tmp, &dev->t10_wwn.t10_evpd_list,
-			evpd_list) {
+	spin_lock(&DEV_T10_WWN(dev)->t10_evpd_lock);
+	list_for_each_entry_safe(evpd, evpd_tmp,
+			&DEV_T10_WWN(dev)->t10_evpd_list, evpd_list) {
 		list_del(&evpd->evpd_list);
 		kfree(evpd);
 	}
-	spin_unlock(&dev->t10_wwn.t10_evpd_lock);
+	spin_unlock(&DEV_T10_WWN(dev)->t10_evpd_lock);
 
 	return;
 }
diff --git a/drivers/lio-core/target_core_mib.c b/drivers/lio-core/target_core_mib.c
index 8b31a03..819fc2f 100644
--- a/drivers/lio-core/target_core_mib.c
+++ b/drivers/lio-core/target_core_mib.c
@@ -286,18 +286,18 @@ static int scsi_dev_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%u %u %s %u\n", hba->hba_index,
 			   dev->dev_index, "Target", dev->dev_port_count);
 		
-		memcpy(&str[0], (void *)&dev->t10_wwn, 28);
+		memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
 
 		/* vendor */
 		for (k = 0; k < 8; k++)
-			str[k] = ISPRINT(dev->t10_wwn.vendor[k]) ?
-					dev->t10_wwn.vendor[k]:0x20;
+			str[k] = ISPRINT(DEV_T10_WWN(dev)->vendor[k]) ?
+					DEV_T10_WWN(dev)->vendor[k]:0x20;
 		str[k] = 0x20;
 
 		/* model */
 		for (k = 0; k < 16; k++)
-			str[k+9] = ISPRINT(dev->t10_wwn.model[k]) ?
-					dev->t10_wwn.model[k]:0x20;
+			str[k+9] = ISPRINT(DEV_T10_WWN(dev)->model[k]) ?
+					DEV_T10_WWN(dev)->model[k]:0x20;
 		str[k + 9] = 0;
 
 		seq_printf(seq, "dev_alias: %s\n", str);
@@ -440,7 +440,7 @@ static int scsi_transport_seq_show(struct seq_file *seq, void *v)
 
 	spin_lock(&hba->device_lock);
 	if ((dev = (se_device_t *)iterp->ti_ptr)) {
-		wwn = &dev->t10_wwn;
+		wwn = DEV_T10_WWN(dev);
 
 		spin_lock(&dev->se_port_lock);
 		list_for_each_entry_safe(se, se_tmp, &dev->dev_sep_list, sep_list) {
@@ -847,29 +847,29 @@ static int scsi_lu_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "%u %u %u %llu %s", hba->hba_index,
                                 dev->dev_index, SCSI_LU_INDEX,
 				(unsigned long long)0, /* scsiLuDefaultLun */
-				(strlen(dev->t10_wwn.unit_serial)) ?
-				(char *)&dev->t10_wwn.unit_serial[0] : "None"); /* scsiLuWwnName */
+				(strlen(DEV_T10_WWN(dev)->unit_serial)) ?
+				(char *)&DEV_T10_WWN(dev)->unit_serial[0] : "None"); /* scsiLuWwnName */
 
-		memcpy(&str[0], (void *)&dev->t10_wwn, 28);
+		memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
 
 		/* scsiLuVendorId */
 		for (j = 0; j < 8; j++)
-                        str[j] = ISPRINT(dev->t10_wwn.vendor[j]) ?
-                                dev->t10_wwn.vendor[j]:0x20;
+                        str[j] = ISPRINT(DEV_T10_WWN(dev)->vendor[j]) ?
+                                DEV_T10_WWN(dev)->vendor[j]:0x20;
                 str[8] = 0;
                 seq_printf(seq, " %s", str);
 
 		/* scsiLuProductId */
 		for (j = 0; j < 16; j++)
-			str[j] = ISPRINT(dev->t10_wwn.model[j]) ?
-		               dev->t10_wwn.model[j]:0x20;
+			str[j] = ISPRINT(DEV_T10_WWN(dev)->model[j]) ?
+		               DEV_T10_WWN(dev)->model[j]:0x20;
 		str[16] = 0;
                 seq_printf(seq, " %s", str);
 
 		/* scsiLuRevisionId */
 		for (j = 0; j < 4; j++)
-                         str[j] = ISPRINT(dev->t10_wwn.revision[j]) ?
-	                       dev->t10_wwn.revision[j]:0x20;
+                         str[j] = ISPRINT(DEV_T10_WWN(dev)->revision[j]) ?
+	                       DEV_T10_WWN(dev)->revision[j]:0x20;
 	        str[4] = 0;
 	        seq_printf(seq, " %s", str);
 
diff --git a/drivers/lio-core/target_core_seobj.c b/drivers/lio-core/target_core_seobj.c
index eff0b0e..182a016 100644
--- a/drivers/lio-core/target_core_seobj.c
+++ b/drivers/lio-core/target_core_seobj.c
@@ -619,7 +619,7 @@ extern t10_wwn_t *dev_obj_get_t10_wwn (void *p)
 {
 	se_device_t *dev = (se_device_t *)p;
 
-	return(&dev->t10_wwn);
+	return(DEV_T10_WWN(dev));
 }
 
 extern int dev_obj_check_tur_bit (void *p)
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 5060905..2a69429 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -1700,6 +1700,7 @@ extern void transport_set_evpd_proto_id (t10_evpd_t *evpd, unsigned char *page_8
 	 */
 	if (page_83[1] & 0x80) {
 		evpd->protocol_identifier = (page_83[0] & 0xf0);
+		evpd->protocol_identifier_set = 1;
 		transport_dump_evpd_proto_id(evpd, NULL, 0);	
 	}
 	
@@ -2062,7 +2063,6 @@ extern se_device_t *transport_add_device_to_core_hba (
 	dev->transport		= transport;
 	atomic_set(&dev->active_cmds, 0);
 	INIT_LIST_HEAD(&dev->dev_sep_list);
-	INIT_LIST_HEAD(&dev->t10_wwn.t10_evpd_list);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_create_sem);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_done_sem);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_sem);
@@ -2072,7 +2072,6 @@ extern se_device_t *transport_add_device_to_core_hba (
 	spin_lock_init(&dev->dev_status_thr_lock);
 	spin_lock_init(&dev->se_port_lock);
 	spin_lock_init(&dev->dev_queue_obj->cmd_queue_lock);
-	spin_lock_init(&dev->t10_wwn.t10_evpd_lock);
 	
 	dev->queue_depth	= TRANSPORT(dev)->get_queue_depth(dev);
 	atomic_set(&dev->depth_left, dev->queue_depth);
@@ -2112,13 +2111,21 @@ extern se_device_t *transport_add_device_to_core_hba (
 		return(dev);
 	}
 
-	if ((ret = transport_get_inquiry(DEV_OBJ_API(dev), &dev->t10_wwn, (void *)dev)) < 0)
+	if ((ret = transport_get_inquiry(DEV_OBJ_API(dev),
+			DEV_T10_WWN(dev), (void *)dev)) < 0)
 		goto out;
 	/*
-	 * Locate EVPD WWN Information used for various purposes within the Storage Engine.
+	 * Locate EVPD WWN Information used for various purposes within
+	 * the Storage Engine.
 	 */
-	if (!(transport_get_inquiry_evpd_serial(DEV_OBJ_API(dev), &dev->t10_wwn, (void *)dev))) {
-		transport_get_inquiry_evpd_device_ident(DEV_OBJ_API(dev), &dev->t10_wwn, (void *)dev);		
+	if (!(transport_get_inquiry_evpd_serial(DEV_OBJ_API(dev),
+			DEV_T10_WWN(dev), (void *)dev))) {
+		/*
+		 * If EVPD Unit Serial returned GOOD status, try
+		 * EVPD Device Identification page (0x83).
+		 */
+		transport_get_inquiry_evpd_device_ident(DEV_OBJ_API(dev),
+			DEV_T10_WWN(dev), (void *)dev);		
 	}
 
 	/*
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index b9fd482..3aea1e6 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -127,6 +127,10 @@ extern se_queue_req_t *transport_get_qr_from_queue (struct se_queue_obj_s *);
 extern int transport_check_device_tcq (se_device_t *, u32, u32);
 extern void transport_dump_dev_state (struct se_device_s *, char *, int *);
 extern void transport_dump_dev_info (struct se_device_s *, struct se_lun_s *, unsigned long long, char *, int *);
+extern void transport_dump_evpd_proto_id (struct t10_evpd_s *, unsigned char *, int);
+extern int transport_dump_evpd_assoc (struct t10_evpd_s *, unsigned char *, int);
+extern int transport_dump_evpd_ident_type (struct t10_evpd_s *, unsigned char *, int);
+extern int transport_dump_evpd_ident (struct t10_evpd_s *, unsigned char *, int);
 extern se_device_t *transport_add_device_to_core_hba (se_hba_t *, struct se_subsystem_api_s *, struct se_subsystem_dev_s *, u32, void *);
 extern void transport_generic_activate_device (se_device_t *);
 extern void transport_generic_deactivate_device (se_device_t *);
-- 
1.5.4.1



