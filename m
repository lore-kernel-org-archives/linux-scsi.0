From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod]: Add INQUIRY EVPD response parsing
	support
Date: Thu, 15 Jan 2009 17:45:12 -0800
Message-ID: <1232070312.1274.141.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:34974 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753810AbZAPBpg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2009 20:45:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Thanks,

--nab

>From 332300358bc0528925105acd5974a304641abd79 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 15 Jan 2009 13:24:38 -0800
Subject: [PATCH] [Target_Core_Mod]: Add INQUIRY EVPD response parsing support

This patch adds the following INQUIRY EVPD=1 protocol information:

*) Protocol Identifier
*) Association
*) Identifier Type
*) Identifier Binary, ASCII, and UTF-8 encoding

and saves each of the EVPD page information in a t10_evpd_t structure attached to
the se_dev_t->t10_wwn structure, in v3.0 data structure terms.  This
naming was defined with spc3r23.pdf, and from a quick look at spc4r17.pdf the
naming is pretty much the same, with one exception: IDENTIFIER TYPE becomes
DESIGNATOR TYPE.

This patch also adds se_release_evpd_for_dev() function/usage.

Here are some examples from "real" SCSI hardware registration:

Parallel SCSI:

  Vendor: MAXTOR    Model: ATLAS15K_36SCA    Revision: DT60
  Type:   Direct-Access                      ANSI SCSI revision: 03
T10 EVPD Unit Serial Number: C40464HK
T10 EVPD Page Length: 36
T10 EVPD Identifer Length: 8
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: EUI-64 based
T10 EVPD Binary Device Identifier: 20010b9fe9f4b0200
T10 EVPD Identifer Length: 20
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: T10 Vendor ID based
T10 EVPD ASCII Device Identifier: MAXTOR  C40464HK

Serial SCSI (SAS):

  Vendor: MAXTOR    Model: ATLAS15K2_36SAS   Revision: BG3H
  Type:   Direct-Access                      ANSI SCSI revision: 02
T10 EVPD Unit Serial Number: E20HY72K
T10 EVPD Page Length: 60
T10 EVPD Identifer Length: 8
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: NAA
T10 EVPD Binary Device Identifier: 350010b90000292df
T10 EVPD Identifer Length: 8
T10 EVPD Protocol Identifier: SAS Serial SCSI Protocol
T10 EVPD Identifier Association: target port
T10 EVPD Identifier Type: NAA
T10 EVPD Binary Device Identifier: 350010b90000292de
T10 EVPD Identifer Length: 4
T10 EVPD Protocol Identifier: SAS Serial SCSI Protocol
T10 EVPD Identifier Association: target port
T10 EVPD Identifier Type: Relative target port identifier
T10 EVPD Binary Device Identifier: 400000002
T10 EVPD Identifer Length: 24
T10 EVPD Identifier Association: SCSI target device
T10 EVPD Identifier Type: SCSI name string
T10 EVPD UTF-8 Device Identifier: naa.50010B90000292DC

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |   15 ++-
 drivers/lio-core/target_core_device.c    |   17 ++
 drivers/lio-core/target_core_device.h    |    1 +
 drivers/lio-core/target_core_transport.c |  307 ++++++++++++++++++++++++++++--
 4 files changed, 317 insertions(+), 23 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 058173e..8b2807d 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -51,6 +51,8 @@
 
 #define TRANSPORT_IQN_LEN			224 /* Currently same as ISCSI_IQN_LEN */
 
+#define EVPD_TMP_BUF_SIZE			128 /* Used to parse EVPD into t10_evpd_t */
+
 /* used by PSCSI and iBlock Transport drivers */
 #define READ_BLOCK_LEN          		6
 #define READ_CAP_LEN            		8
@@ -232,13 +234,22 @@ typedef struct se_obj_s {
 	atomic_t obj_access_count;
 } ____cacheline_aligned se_obj_t;
 
+typedef struct t10_evpd_s {
+	unsigned char device_identifier[INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN];
+	u32 protocol_identifier;
+	u32 device_identifier_code_set;
+	u32 association;
+	u32 device_identifier_type;
+	struct list_head evpd_list;
+} t10_evpd_t;
+
 typedef struct t10_wwn_s {
         unsigned char vendor[8];
         unsigned char model[16];
 	unsigned char revision[4];
         unsigned char unit_serial[INQUIRY_EVPD_SERIAL_LEN];
-	u32 device_identifier_code_set;
-	unsigned char device_identifier[INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN];
+	spinlock_t t10_evpd_lock;
+	struct list_head t10_evpd_list;
 } ____cacheline_aligned t10_wwn_t;
 
 typedef struct se_queue_req_s {
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 95dd89d..f52eddc 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -592,6 +592,8 @@ extern void se_release_device_for_hba (se_device_t *dev)
 	REMOVE_ENTRY_FROM_LIST(dev, hba->device_head, hba->device_tail);
 	hba->dev_count--;
 	spin_unlock(&hba->device_lock);
+
+	se_release_evpd_for_dev(dev);
 		
 	kfree(dev->dev_status_queue_obj);
 	kfree(dev->dev_queue_obj);
@@ -600,6 +602,21 @@ extern void se_release_device_for_hba (se_device_t *dev)
 	return;
 }
 
+extern void se_release_evpd_for_dev (se_device_t *dev)
+{
+	t10_evpd_t *evpd, *evpd_tmp;
+
+	spin_lock(&dev->t10_wwn.t10_evpd_lock);
+	list_for_each_entry_safe(evpd, evpd_tmp, &dev->t10_wwn.t10_evpd_list,
+			evpd_list) {
+		list_del(&evpd->evpd_list);
+		kfree(evpd);
+	}
+	spin_unlock(&dev->t10_wwn.t10_evpd_lock);
+
+	return;
+}
+
 extern int transport_get_lun_for_cmd (
         se_cmd_t *se_cmd,
 	unsigned char *cdb,
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index ea3046b..c2d4b12 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -42,6 +42,7 @@ extern void core_update_device_list_for_node (se_lun_t *lun, u32, u32, se_node_a
 extern void core_clear_lun_from_tpg (se_lun_t *, se_portal_group_t *);
 extern int transport_core_report_lun_response (se_cmd_t *);
 extern void se_release_device_for_hba (se_device_t *);
+extern void se_release_evpd_for_dev (se_device_t *);
 extern void se_clear_dev_ports (se_device_t *);
 extern int se_free_virtual_device (se_device_t *, se_hba_t *);
 extern void se_dev_start (se_device_t *);
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index f02bf56..5060905 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -1614,7 +1614,7 @@ static int transport_get_inquiry_evpd_serial (se_obj_lun_type_t *obj_api, t10_ww
 	cdb[0] = INQUIRY;
 	cdb[1] = 0x01; /* Query EVPD */
 	cdb[2] = 0x80; /* Unit Serial Number */ 
-	cdb[3] = (INQUIRY_EVPD_SERIAL_LEN >> 8) & 0xff;;
+	cdb[3] = (INQUIRY_EVPD_SERIAL_LEN >> 8) & 0xff;
 	cdb[4] = (INQUIRY_EVPD_SERIAL_LEN & 0xff);
 
 	if (!(cmd = transport_allocate_passthrough(&cdb[0], SE_DIRECTION_READ,
@@ -1637,11 +1637,253 @@ static int transport_get_inquiry_evpd_serial (se_obj_lun_type_t *obj_api, t10_ww
 	return(0);
 }
 
+static const char hex_str[]="0123456789abcdef";
+
+extern void transport_dump_evpd_proto_id (
+	t10_evpd_t *evpd,
+	unsigned char *p_buf,
+	int p_buf_len)
+{
+	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	int len;
+
+	memset(buf, 0, EVPD_TMP_BUF_SIZE);
+	len = sprintf(buf, "T10 EVPD Protocol Identifier: ");
+
+	switch (evpd->protocol_identifier) {
+	case 0x00:
+		sprintf(buf+len, "Fibre Channel\n");
+		break;
+	case 0x10:
+		sprintf(buf+len, "Parallel SCSI\n");
+		break;
+	case 0x20:
+		sprintf(buf+len, "SSA\n");
+		break;
+	case 0x30:
+		sprintf(buf+len, "IEEE 1394\n");
+		break;
+	case 0x40:
+		sprintf(buf+len, "SCSI Remote Direct Memory Access Protocol\n");
+		break;
+	case 0x50:
+		sprintf(buf+len, "Internet SCSI (iSCSI)\n");
+		break;
+	case 0x60:
+		sprintf(buf+len, "SAS Serial SCSI Protocol\n");
+		break;
+	case 0x70:
+		sprintf(buf+len, "Automation/Drive Interface Transport Protocol\n");
+		break;
+	case 0x80:
+		sprintf(buf+len, "AT Attachment Interface ATA/ATAPI\n");
+		break;
+	default:
+		sprintf(buf+len, "Unknown 0x%02x\n", evpd->protocol_identifier);
+		break;
+	}
+
+	if (p_buf)
+		strncpy(p_buf, buf, p_buf_len);	
+	else 
+		printk("%s", buf);
+
+	return;
+}
+
+extern void transport_set_evpd_proto_id (t10_evpd_t *evpd, unsigned char *page_83)
+{
+	/*
+	 * Check if the Protocol Identifier Valid (PIV) bit is set..
+	 * 
+	 * from spc3r23.pdf section 7.5.1
+	 */
+	if (page_83[1] & 0x80) {
+		evpd->protocol_identifier = (page_83[0] & 0xf0);
+		transport_dump_evpd_proto_id(evpd, NULL, 0);	
+	}
+	
+	return;
+}
+
+extern int transport_dump_evpd_assoc (
+	t10_evpd_t *evpd,
+	unsigned char *p_buf,
+	int p_buf_len)
+{
+	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	int ret = 0, len;
+
+	memset(buf, 0, EVPD_TMP_BUF_SIZE);
+	len = sprintf(buf, "T10 EVPD Identifier Association: ");
+
+	switch (evpd->association) {
+	case 0x00:
+		sprintf(buf+len, "addressed logical unit\n");
+		break;
+	case 0x10:
+		sprintf(buf+len, "target port\n");
+		break;
+	case 0x20:
+		sprintf(buf+len, "SCSI target device\n");
+		break;
+	default:
+		sprintf(buf+len, "Unknown 0x%02x\n", evpd->association);
+		ret = -1;
+		break;
+	}
+
+	if (p_buf)
+		strncpy(p_buf, buf, p_buf_len);
+	else
+		printk("%s", buf);
+
+	return(ret);
+}	
+
+static int transport_set_evpd_assoc (t10_evpd_t *evpd, unsigned char *page_83)
+{
+	/*
+	 * The EVPD identification association..
+	 *
+	 * from spc3r23.pdf Section 7.6.3.1 Table 297
+	 */
+	evpd->association = (page_83[1] & 0x30);
+	return(transport_dump_evpd_assoc(evpd, NULL, 0));
+}
+
+extern int transport_dump_evpd_ident_type (
+	t10_evpd_t *evpd,
+        unsigned char *p_buf,
+        int p_buf_len)
+{
+	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	int ret = 0, len;
+
+	memset(buf, 0, EVPD_TMP_BUF_SIZE);
+	len = sprintf(buf, "T10 EVPD Identifier Type: ");
+
+	switch (evpd->device_identifier_type) {
+	case 0x00:
+		sprintf(buf+len, "Vendor specific\n");
+		break;
+	case 0x01:
+		sprintf(buf+len, "T10 Vendor ID based\n");
+		break;
+	case 0x02:
+		sprintf(buf+len, "EUI-64 based\n");
+		break;
+	case 0x03:
+		sprintf(buf+len, "NAA\n");
+		break;
+	case 0x04:
+		sprintf(buf+len, "Relative target port identifier\n");
+		break;
+	case 0x08:
+		sprintf(buf+len, "SCSI name string\n");
+		break;
+	default:
+		sprintf(buf+len, "Unsupported: 0x%02x\n", evpd->device_identifier_type);
+		ret = -1;
+		break;
+	}
+
+	if (p_buf)
+		strncpy(p_buf, buf, p_buf_len);
+	else
+		printk("%s", buf);
+
+	return(ret);
+}
+
+extern int transport_set_evpd_ident_type (t10_evpd_t *evpd, unsigned char *page_83)
+{
+	/*
+	 * The EVPD identifier type..
+	 *
+	 * from spc3r23.pdf Section 7.6.3.1 Table 298
+	 */
+	evpd->device_identifier_type = (page_83[1] & 0x0f);
+	return(transport_dump_evpd_ident_type(evpd, NULL, 0));
+}
+
+extern int transport_dump_evpd_ident (
+	t10_evpd_t *evpd,
+	unsigned char *p_buf,
+	int p_buf_len)
+{
+	unsigned char buf[EVPD_TMP_BUF_SIZE];
+	int ret = 0;
+	
+	memset(buf, 0, EVPD_TMP_BUF_SIZE);
+
+	switch (evpd->device_identifier_code_set) {
+	case 0x01: /* Binary */
+		sprintf(buf, "T10 EVPD Binary Device Identifier: %s\n",
+			&evpd->device_identifier[0]);			
+		break;
+	case 0x02: /* ASCII */
+		sprintf(buf, "T10 EVPD ASCII Device Identifier: %s\n",	
+			&evpd->device_identifier[0]);
+		break;
+	case 0x03: /* UTF-8 */
+		sprintf(buf, "T10 EVPD UTF-8 Device Identifier: %s\n", 
+			&evpd->device_identifier[0]);
+		break;
+	default:
+		sprintf(buf, "T10 EVPD Device Identifier encoding unsupported:"
+			" 0x%02x", evpd->device_identifier_code_set);
+		ret = -1;
+		break;
+	}
+
+	if (p_buf)
+		strncpy(p_buf, buf, p_buf_len);
+	else
+		printk("%s", buf);
+	
+	return(ret);
+}
+
+extern int transport_set_evpd_ident (t10_evpd_t *evpd, unsigned char *page_83)
+{
+	int j = 0, i = 4; /* offset to start of the identifer */
+
+	/*
+	 * The EVPD Code Set (encoding)
+	 *
+	 * from spc3r23.pdf Section 7.6.3.1 Table 296
+	 */
+	evpd->device_identifier_code_set = (page_83[0] & 0x0f);
+	switch (evpd->device_identifier_code_set) {
+	case 0x01: /* Binary */
+		evpd->device_identifier[j++] = hex_str[evpd->device_identifier_type];
+		while (i < (4 + page_83[3])) {
+			evpd->device_identifier[j++] = hex_str[(page_83[i] & 0xf0) >> 4];
+			evpd->device_identifier[j++] = hex_str[page_83[i] & 0x0f];
+			i++;
+		}
+		break;
+	case 0x02: /* ASCII */
+	case 0x03: /* UTF-8 */
+		while (i < (4 + page_83[3]))
+			evpd->device_identifier[j++] = page_83[i++];
+
+		break;
+	default:
+		break;
+	}
+
+	return(transport_dump_evpd_ident(evpd, NULL, 0));
+}
+
 static int transport_get_inquiry_evpd_device_ident (se_obj_lun_type_t *obj_api, t10_wwn_t *wwn, void *obj_ptr)
 {
-	unsigned char *buf;
+	unsigned char *buf, *page_83;
 	se_cmd_t *cmd;
+	t10_evpd_t *evpd;
 	unsigned char cdb[SCSI_CDB_SIZE];
+	int ident_len, page_len, off = 4, ret = 0;
 
 	memset(cdb, 0, SCSI_CDB_SIZE);
 	cdb[0] = INQUIRY;
@@ -1662,27 +1904,46 @@ static int transport_get_inquiry_evpd_device_ident (se_obj_lun_type_t *obj_api,
 	}
 
 	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-	wwn->device_identifier_code_set = (buf[4] & 0x0f);
+	page_len = (buf[2] << 8) | buf[3];
+	printk("T10 EVPD Page Length: %d\n", page_len);
 
-//#warning FIXME v2.8: Finish up EVPD Device Identifier support for Binary + UTF-8 encodings
-	switch (wwn->device_identifier_code_set) {
-#if 0
-	case 0x01: /* Binary */
-		break;
-#endif
-	case 0x02: /* ASCII */
-		PYXPRINT("T10 EVPD Device Identifier: %s\n", &buf[8]);
-		snprintf(&wwn->device_identifier[0], INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN, "%s", &buf[8]);
-		break;
-#if 0
-	case 0x03: /* UTF-8 */
-		break;
-#endif
-	default:
-		PYXPRINT("T10 EVPD Device Identifier encoding unsupported: %02x\n", buf[4]);
-		break;
-	}
+	while (page_len > 0) {
+		page_83 = &buf[off]; /* Grab a pointer to the Identification descriptor */
+		if (!(ident_len = page_83[3])) {
+			printk(KERN_ERR "page_83[3]: identifier length zero!\n");
+			break;
+		}
+		printk("T10 EVPD Identifer Length: %d\n", ident_len);
 
+		if (!(evpd = kzalloc(sizeof(t10_evpd_t), GFP_KERNEL))) {
+			printk("Unable to allocate memory for t10_evpd_t\n");
+			ret = -1;
+			goto out;
+		}
+		INIT_LIST_HEAD(&evpd->evpd_list);
+
+		transport_set_evpd_proto_id(evpd, page_83);
+		transport_set_evpd_assoc(evpd, page_83);
+
+		if (transport_set_evpd_ident_type(evpd, page_83) < 0) {
+			off += (ident_len + 4);
+			page_len -= (ident_len + 4);
+			kfree(evpd);
+			continue;
+		}
+		if (transport_set_evpd_ident(evpd, page_83) < 0) {
+			off += (ident_len + 4);
+			page_len -= (ident_len + 4);
+			kfree(evpd);
+			continue;	
+		}
+			
+		list_add_tail(&evpd->evpd_list, &wwn->t10_evpd_list);
+		off += (ident_len + 4);
+		page_len -= (ident_len + 4);
+	}
+	
+out:
 	transport_passthrough_release(cmd);
 
 	return(0);
@@ -1801,6 +2062,7 @@ extern se_device_t *transport_add_device_to_core_hba (
 	dev->transport		= transport;
 	atomic_set(&dev->active_cmds, 0);
 	INIT_LIST_HEAD(&dev->dev_sep_list);
+	INIT_LIST_HEAD(&dev->t10_wwn.t10_evpd_list);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_create_sem);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_done_sem);
 	init_MUTEX_LOCKED(&dev->dev_queue_obj->thread_sem);
@@ -1810,6 +2072,7 @@ extern se_device_t *transport_add_device_to_core_hba (
 	spin_lock_init(&dev->dev_status_thr_lock);
 	spin_lock_init(&dev->se_port_lock);
 	spin_lock_init(&dev->dev_queue_obj->cmd_queue_lock);
+	spin_lock_init(&dev->t10_wwn.t10_evpd_lock);
 	
 	dev->queue_depth	= TRANSPORT(dev)->get_queue_depth(dev);
 	atomic_set(&dev->depth_left, dev->queue_depth);
@@ -1888,6 +2151,8 @@ out:
 	REMOVE_ENTRY_FROM_LIST(dev, hba->device_head, hba->device_tail);
 	hba->dev_count--;
 	spin_unlock(&hba->device_lock);
+	
+	se_release_evpd_for_dev(dev);
 
 	kfree(dev->dev_status_queue_obj);
 	kfree(dev->dev_queue_obj);
-- 
1.5.4.1



