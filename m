From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] target-pscsi: get inquiry data using scsi_execute_req
Date: Thu, 25 Nov 2010 23:14:31 -0800
Message-ID: <1290755672-19819-4-git-send-email-nab@linux-iscsi.org>
References: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm14.bullet.mail.ne1.yahoo.com ([98.138.90.77]:41398 "HELO
	nm14.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753125Ab0KZHPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2010 02:15:10 -0500
In-Reply-To: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Christoph Hellwig <hch@lst.de>

For virtual devices we have all inquiry data already in struct t10_wwn, so
remove the passthrough inquiry from common code.  Instead use Linux SCSI
command execution to fill the inquiry data for physical devices.

Tested backend registerion with emulated EVPD 0x83 from IBLOCK -> TCM_Loop ->
pSCSI on .37-rc2.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |    2 -
 drivers/target/target_core_pscsi.c     |  140 +++++++++++++++++
 drivers/target/target_core_transport.c |  266 ++++++--------------------------
 include/target/target_core_transport.h |    5 +-
 4 files changed, 192 insertions(+), 221 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 8ba7835..dc4573f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -895,8 +895,6 @@ static ssize_t target_core_dev_wwn_store_attr_vpd_unit_serial(
 
 	printk(KERN_INFO "Target_Core_ConfigFS: Set emulated VPD Unit Serial:"
 			" %s\n", su_dev->t10_wwn.unit_serial);
-	if (dev)
-		transport_rescan_evpd_device_ident(dev);
 
 	return count;
 }
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 5e63581..9cc6bc4 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -208,6 +208,129 @@ out_free:
 	kfree(buf);
 }
 
+static void
+pscsi_set_inquiry_info(struct scsi_device *sdev, struct t10_wwn *wwn)
+{
+	unsigned char *buf;
+
+	if (sdev->inquiry_len < INQUIRY_LEN)
+		return;
+
+	buf = sdev->inquiry;
+	if (!buf)
+		return;
+	/*
+	 * Use sdev->inquiry from drivers/scsi/scsi_scan.c:scsi_alloc_sdev()
+	 */
+	memcpy(&wwn->vendor[0], &buf[8], sizeof(wwn->vendor));
+	memcpy(&wwn->model[0], &buf[16], sizeof(wwn->model));
+	memcpy(&wwn->revision[0], &buf[32], sizeof(wwn->revision));
+}
+
+static int
+pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
+{
+	unsigned char cdb[MAX_COMMAND_SIZE], *buf;
+	int ret;
+
+	buf = kzalloc(INQUIRY_VPD_SERIAL_LEN, GFP_KERNEL);
+	if (!buf)
+		return -1;
+
+	memset(cdb, 0, MAX_COMMAND_SIZE);
+	cdb[0] = INQUIRY;
+	cdb[1] = 0x01; /* Query VPD */
+	cdb[2] = 0x80; /* Unit Serial Number */
+	cdb[3] = (INQUIRY_VPD_SERIAL_LEN >> 8) & 0xff;
+	cdb[4] = (INQUIRY_VPD_SERIAL_LEN & 0xff);
+
+	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
+			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+	if (ret)
+		goto out_free;
+
+	snprintf(&wwn->unit_serial[0], INQUIRY_VPD_SERIAL_LEN, "%s", &buf[4]);
+
+	wwn->t10_sub_dev->su_dev_flags |= SDF_FIRMWARE_VPD_UNIT_SERIAL;
+
+	kfree(buf);
+	return 0;
+
+out_free:
+	kfree(buf);
+	return -1;
+}
+
+static void
+pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
+		struct t10_wwn *wwn)
+{
+	unsigned char cdb[MAX_COMMAND_SIZE], *buf, *page_83;
+	int ident_len, page_len, off = 4, ret;
+	struct t10_vpd *vpd;
+
+	buf = kzalloc(INQUIRY_VPD_SERIAL_LEN, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	memset(cdb, 0, MAX_COMMAND_SIZE);
+	cdb[0] = INQUIRY;
+	cdb[1] = 0x01; /* Query VPD */
+	cdb[2] = 0x83; /* Device Identifier */
+	cdb[3] = (INQUIRY_VPD_DEVICE_IDENTIFIER_LEN >> 8) & 0xff;
+	cdb[4] = (INQUIRY_VPD_DEVICE_IDENTIFIER_LEN & 0xff);
+
+	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
+			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
+			      NULL, HZ, 1, NULL);
+	if (ret)
+		goto out;
+
+	page_len = (buf[2] << 8) | buf[3];
+	while (page_len > 0) {
+		/* Grab a pointer to the Identification descriptor */
+		page_83 = &buf[off];
+		ident_len = page_83[3];
+		if (!ident_len) {
+			printk(KERN_ERR "page_83[3]: identifier"
+					" length zero!\n");
+			break;
+		}
+		printk(KERN_INFO "T10 VPD Identifer Length: %d\n", ident_len);
+
+		vpd = kzalloc(sizeof(struct t10_vpd), GFP_KERNEL);
+		if (!vpd) {
+			printk(KERN_ERR "Unable to allocate memory for"
+					" struct t10_vpd\n");
+			goto out;
+		}
+		INIT_LIST_HEAD(&vpd->vpd_list);
+
+		transport_set_vpd_proto_id(vpd, page_83);
+		transport_set_vpd_assoc(vpd, page_83);
+
+		if (transport_set_vpd_ident_type(vpd, page_83) < 0) {
+			off += (ident_len + 4);
+			page_len -= (ident_len + 4);
+			kfree(vpd);
+			continue;
+		}
+		if (transport_set_vpd_ident(vpd, page_83) < 0) {
+			off += (ident_len + 4);
+			page_len -= (ident_len + 4);
+			kfree(vpd);
+			continue;
+		}
+
+		list_add_tail(&vpd->vpd_list, &wwn->t10_vpd_list);
+		off += (ident_len + 4);
+		page_len -= (ident_len + 4);
+	}
+
+out:
+	kfree(buf);
+}
+
 /*	pscsi_add_device_to_list():
  *
  *
@@ -247,6 +370,11 @@ static struct se_device *pscsi_add_device_to_list(
 	dev_limits.hw_queue_depth = sd->queue_depth;
 	dev_limits.queue_depth = sd->queue_depth;
 	/*
+	 * Setup our standard INQUIRY info into se_dev->t10_wwn
+	 */
+	pscsi_set_inquiry_info(sd, &se_dev->t10_wwn);
+
+	/*
 	 * Set the pointer pdv->pdv_sd to from passed struct scsi_device,
 	 * which has already been referenced with Linux SCSI code with
 	 * scsi_device_get() in this file's pscsi_create_virtdevice().
@@ -270,6 +398,18 @@ static struct se_device *pscsi_add_device_to_list(
 	}
 
 	/*
+	 * Locate VPD WWN Information used for various purposes within
+	 * the Storage Engine.
+	 */
+	if (!pscsi_get_inquiry_vpd_serial(sd, &se_dev->t10_wwn)) {
+		/*
+		 * If VPD Unit Serial returned GOOD status, try
+		 * VPD Device Identification page (0x83).
+		 */
+		pscsi_get_inquiry_vpd_device_ident(sd, &se_dev->t10_wwn);
+	}
+
+	/*
 	 * For TYPE_TAPE, attempt to determine blocksize with MODE_SENSE.
 	 */
 	if (sd->type == TYPE_TAPE)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 12a2fae..9004ab6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1341,115 +1341,6 @@ static void transport_release_all_cmds(struct se_device *dev)
 #endif
 }
 
-static int transport_get_inquiry(
-	struct t10_wwn *wwn,
-	void *obj_ptr)
-{
-	struct se_cmd *cmd;
-	unsigned char *buf;
-	int i;
-	unsigned char cdb[MAX_COMMAND_SIZE];
-
-	memset(cdb, 0, MAX_COMMAND_SIZE);
-	cdb[0] = INQUIRY;
-	cdb[3] = (INQUIRY_LEN >> 8) & 0xff;
-	cdb[4] = (INQUIRY_LEN & 0xff);
-
-	cmd = transport_allocate_passthrough(&cdb[0],  DMA_FROM_DEVICE,
-			0, NULL, 0, INQUIRY_LEN, obj_ptr);
-	if (!(cmd))
-		return -1;
-
-	if (transport_generic_passthrough(cmd) < 0) {
-		transport_passthrough_release(cmd);
-		return -1;
-	}
-
-	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-	/*
-	 * Save the basic Vendor, Model and Revision in passed struct t10_wwn.
-	 * We will obtain the VPD in a seperate passthrough operation.
-	 */
-	memcpy((void *)&wwn->vendor[0], (void *)&buf[8],
-			sizeof(wwn->vendor));
-	memcpy((void *)&wwn->model[0], (void *)&buf[16],
-			sizeof(wwn->model));
-	memcpy((void *)&wwn->revision[0], (void *)&buf[32],
-			sizeof(wwn->revision));
-
-	printk("  Vendor: ");
-	for (i = 8; i < 16; i++)
-		if (buf[i] >= 0x20 && i < buf[4] + 5)
-			printk("%c", buf[i]);
-		else
-			printk(" ");
-
-	printk("  Model: ");
-	for (i = 16; i < 32; i++)
-		if (buf[i] >= 0x20 && i < buf[4] + 5)
-			printk("%c", buf[i]);
-		else
-			printk(" ");
-
-	printk("  Revision: ");
-	for (i = 32; i < 36; i++)
-		if (buf[i] >= 0x20 && i < buf[4] + 5)
-			printk("%c", buf[i]);
-		else
-			printk(" ");
-
-	printk("\n");
-
-	i = buf[0] & 0x1f;
-
-	printk("  Type:   %s ", scsi_device_type(i));
-	printk("                 ANSI SCSI revision: %02x",
-				buf[2] & 0x07);
-	if ((buf[2] & 0x07) == 1 && (buf[3] & 0x0f) == 1)
-		printk(" CCS\n");
-	else
-		printk("\n");
-
-	transport_passthrough_release(cmd);
-	return 0;
-}
-
-static int transport_get_inquiry_vpd_serial(
-	struct t10_wwn *wwn,
-	void *obj_ptr)
-{
-	unsigned char *buf;
-	struct se_cmd *cmd;
-	unsigned char cdb[MAX_COMMAND_SIZE];
-
-	memset(cdb, 0, MAX_COMMAND_SIZE);
-	cdb[0] = INQUIRY;
-	cdb[1] = 0x01; /* Query VPD */
-	cdb[2] = 0x80; /* Unit Serial Number */
-	cdb[3] = (INQUIRY_VPD_SERIAL_LEN >> 8) & 0xff;
-	cdb[4] = (INQUIRY_VPD_SERIAL_LEN & 0xff);
-
-	cmd = transport_allocate_passthrough(&cdb[0], DMA_FROM_DEVICE,
-			0, NULL, 0, INQUIRY_VPD_SERIAL_LEN, obj_ptr);
-	if (!(cmd))
-		return -1;
-
-	if (transport_generic_passthrough(cmd) < 0) {
-		transport_passthrough_release(cmd);
-		return -1;
-	}
-
-	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-
-	printk(KERN_INFO "T10 VPD Unit Serial Number: %s\n", &buf[4]);
-	snprintf(&wwn->unit_serial[0], INQUIRY_VPD_SERIAL_LEN, "%s", &buf[4]);
-
-	transport_passthrough_release(cmd);
-	return 0;
-}
-
-static const char hex_str[] = "0123456789abcdef";
-
 void transport_dump_vpd_proto_id(
 	struct t10_vpd *vpd,
 	unsigned char *p_buf,
@@ -1503,7 +1394,7 @@ void transport_dump_vpd_proto_id(
 		printk(KERN_INFO "%s", buf);
 }
 
-static void
+void
 transport_set_vpd_proto_id(struct t10_vpd *vpd, unsigned char *page_83)
 {
 	/*
@@ -1511,12 +1402,13 @@ transport_set_vpd_proto_id(struct t10_vpd *vpd, unsigned char *page_83)
 	 *
 	 * from spc3r23.pdf section 7.5.1
 	 */
-	if (page_83[1] & 0x80) {
+	 if (page_83[1] & 0x80) {
 		vpd->protocol_identifier = (page_83[0] & 0xf0);
 		vpd->protocol_identifier_set = 1;
 		transport_dump_vpd_proto_id(vpd, NULL, 0);
 	}
 }
+EXPORT_SYMBOL(transport_set_vpd_proto_id);
 
 int transport_dump_vpd_assoc(
 	struct t10_vpd *vpd,
@@ -1553,7 +1445,7 @@ int transport_dump_vpd_assoc(
 	return ret;
 }
 
-static int transport_set_vpd_assoc(struct t10_vpd *vpd, unsigned char *page_83)
+int transport_set_vpd_assoc(struct t10_vpd *vpd, unsigned char *page_83)
 {
 	/*
 	 * The VPD identification association..
@@ -1563,6 +1455,7 @@ static int transport_set_vpd_assoc(struct t10_vpd *vpd, unsigned char *page_83)
 	vpd->association = (page_83[1] & 0x30);
 	return transport_dump_vpd_assoc(vpd, NULL, 0);
 }
+EXPORT_SYMBOL(transport_set_vpd_assoc);
 
 int transport_dump_vpd_ident_type(
 	struct t10_vpd *vpd,
@@ -1609,8 +1502,7 @@ int transport_dump_vpd_ident_type(
 	return ret;
 }
 
-static int
-transport_set_vpd_ident_type(struct t10_vpd *vpd, unsigned char *page_83)
+int transport_set_vpd_ident_type(struct t10_vpd *vpd, unsigned char *page_83)
 {
 	/*
 	 * The VPD identifier type..
@@ -1620,6 +1512,7 @@ transport_set_vpd_ident_type(struct t10_vpd *vpd, unsigned char *page_83)
 	vpd->device_identifier_type = (page_83[1] & 0x0f);
 	return transport_dump_vpd_ident_type(vpd, NULL, 0);
 }
+EXPORT_SYMBOL(transport_set_vpd_ident_type);
 
 int transport_dump_vpd_ident(
 	struct t10_vpd *vpd,
@@ -1659,9 +1552,10 @@ int transport_dump_vpd_ident(
 	return ret;
 }
 
-static int
+int
 transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
 {
+	static const char hex_str[] = "0123456789abcdef";
 	int j = 0, i = 4; /* offset to start of the identifer */
 
 	/*
@@ -1686,7 +1580,6 @@ transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
 	case 0x03: /* UTF-8 */
 		while (i < (4 + page_83[3]))
 			vpd->device_identifier[j++] = page_83[i++];
-
 		break;
 	default:
 		break;
@@ -1694,91 +1587,7 @@ transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
 
 	return transport_dump_vpd_ident(vpd, NULL, 0);
 }
-
-static int transport_get_inquiry_vpd_device_ident(
-	struct t10_wwn *wwn,
-	void *obj_ptr)
-{
-	unsigned char *buf, *page_83;
-	struct se_cmd *cmd;
-	struct t10_vpd *vpd;
-	unsigned char cdb[MAX_COMMAND_SIZE];
-	int ident_len, page_len, off = 4, ret = 0;
-
-	memset(cdb, 0, MAX_COMMAND_SIZE);
-	cdb[0] = INQUIRY;
-	cdb[1] = 0x01; /* Query VPD */
-	cdb[2] = 0x83; /* Device Identifier */
-	cdb[3] = (INQUIRY_VPD_DEVICE_IDENTIFIER_LEN >> 8) & 0xff;
-	cdb[4] = (INQUIRY_VPD_DEVICE_IDENTIFIER_LEN & 0xff);
-
-	cmd = transport_allocate_passthrough(&cdb[0], DMA_FROM_DEVICE,
-			0, NULL, 0, INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			obj_ptr);
-	if (!(cmd))
-		return -1;
-
-	if (transport_generic_passthrough(cmd) < 0) {
-		transport_passthrough_release(cmd);
-		return -1;
-	}
-
-	buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-	page_len = (buf[2] << 8) | buf[3];
-	printk("T10 VPD Page Length: %d\n", page_len);
-
-	while (page_len > 0) {
-		/* Grab a pointer to the Identification descriptor */
-		page_83 = &buf[off];
-		ident_len = page_83[3];
-		if (!(ident_len)) {
-			printk(KERN_ERR "page_83[3]: identifier"
-					" length zero!\n");
-			break;
-		}
-		printk(KERN_INFO "T10 VPD Identifer Length: %d\n", ident_len);
-
-		vpd = kzalloc(sizeof(struct t10_vpd), GFP_KERNEL);
-		if (!(vpd)) {
-			printk(KERN_ERR "Unable to allocate memory for"
-					" struct t10_vpd\n");
-			ret = -1;
-			goto out;
-		}
-		INIT_LIST_HEAD(&vpd->vpd_list);
-
-		transport_set_vpd_proto_id(vpd, page_83);
-		transport_set_vpd_assoc(vpd, page_83);
-
-		if (transport_set_vpd_ident_type(vpd, page_83) < 0) {
-			off += (ident_len + 4);
-			page_len -= (ident_len + 4);
-			kfree(vpd);
-			continue;
-		}
-		if (transport_set_vpd_ident(vpd, page_83) < 0) {
-			off += (ident_len + 4);
-			page_len -= (ident_len + 4);
-			kfree(vpd);
-			continue;
-		}
-
-		list_add_tail(&vpd->vpd_list, &wwn->t10_vpd_list);
-		off += (ident_len + 4);
-		page_len -= (ident_len + 4);
-	}
-out:
-	transport_passthrough_release(cmd);
-	return 0;
-}
-
-int transport_rescan_evpd_device_ident(
-	struct se_device *dev)
-{
-	se_release_vpd_for_dev(dev);
-	transport_get_inquiry_vpd_device_ident(DEV_T10_WWN(dev), (void *)dev);
-	return 0;
-}
+EXPORT_SYMBOL(transport_set_vpd_ident);
 
 static void core_setup_task_attr_emulation(struct se_device *dev)
 {
@@ -1800,6 +1609,42 @@ static void core_setup_task_attr_emulation(struct se_device *dev)
 		TRANSPORT(dev)->get_device_rev(dev));
 }
 
+static void scsi_dump_inquiry(struct se_device *dev)
+{
+	struct t10_wwn *wwn = DEV_T10_WWN(dev);
+	int i, device_type;
+	/*
+	 * Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
+	 */
+	printk("  Vendor: ");
+	for (i = 0; i < 8; i++)
+		if (wwn->vendor[i] >= 0x20)
+			printk("%c", wwn->vendor[i]);
+		else
+			printk(" ");
+
+	printk("  Model: ");
+	for (i = 0; i < 16; i++)
+		if (wwn->model[i] >= 0x20)
+			printk("%c", wwn->model[i]);
+		else
+			printk(" ");
+
+	printk("  Revision: ");
+	for (i = 0; i < 4; i++)
+		if (wwn->revision[i] >= 0x20)	
+			printk("%c", wwn->revision[i]);
+		else
+			printk(" ");
+
+	printk("\n");
+
+	device_type = TRANSPORT(dev)->get_device_type(dev);
+	printk("  Type:   %s ", scsi_device_type(device_type));
+	printk("                 ANSI SCSI revision: %02x\n",
+				TRANSPORT(dev)->get_device_rev(dev));
+}
+
 struct se_device *transport_add_device_to_core_hba(
 	struct se_hba *hba,
 	struct se_subsystem_api *transport,
@@ -1921,26 +1766,11 @@ struct se_device *transport_add_device_to_core_hba(
 			goto out;
 		}
 
+		strncpy(&DEV_T10_WWN(dev)->vendor[0], "LIO-ORG", 8);
 		strncpy(&DEV_T10_WWN(dev)->model[0], inquiry_prod, 16);
 		strncpy(&DEV_T10_WWN(dev)->revision[0], inquiry_rev, 4);
 	}
-
-	ret = transport_get_inquiry(DEV_T10_WWN(dev), (void *)dev);
-	if (ret < 0)
-		goto out;
-	/*
-	 * Locate VPD WWN Information used for various purposes within
-	 * the Storage Engine.
-	 */
-	if (!(transport_get_inquiry_vpd_serial(DEV_T10_WWN(dev),
-				(void *)dev))) {
-		/*
-		 * If VPD Unit Serial returned GOOD status, try
-		 * VPD Device Identification page (0x83).
-		 */
-		transport_get_inquiry_vpd_device_ident(DEV_T10_WWN(dev),
-					(void *)dev);
-	}
+	scsi_dump_inquiry(dev);
 
 	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_DISK)
 		dev->dev_sectors_total = dev->transport->get_blocks(dev);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index b7228f6..7b7df8f 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -153,13 +153,16 @@ extern void transport_dump_dev_info(struct se_device *, struct se_lun *,
 					unsigned long long, char *, int *);
 extern void transport_dump_vpd_proto_id(struct t10_vpd *,
 					unsigned char *, int);
+extern void transport_set_vpd_proto_id(struct t10_vpd *, unsigned char *);
 extern int transport_dump_vpd_assoc(struct t10_vpd *,
 					unsigned char *, int);
+extern int transport_set_vpd_assoc(struct t10_vpd *, unsigned char *);
 extern int transport_dump_vpd_ident_type(struct t10_vpd *,
 					unsigned char *, int);
+extern int transport_set_vpd_ident_type(struct t10_vpd *, unsigned char *);
 extern int transport_dump_vpd_ident(struct t10_vpd *,
 					unsigned char *, int);
-extern int transport_rescan_evpd_device_ident(struct se_device *);
+extern int transport_set_vpd_ident(struct t10_vpd *, unsigned char *);
 extern struct se_device *transport_add_device_to_core_hba(struct se_hba *,
 					struct se_subsystem_api *,
 					struct se_subsystem_dev *, u32,
-- 
1.5.6.5

