From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 1/5]  arcmsr: Re-name the HBA Type
Date: Tue, 4 Dec 2012 19:58:41 +0800
Message-ID: <BFDCAA3F8AA84D99BAEFB83817557682@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0000_01CDD259.C55D22B0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54133 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2LDL6i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2012 06:58:38 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so2984330iay.19
        for <linux-scsi@vger.kernel.org>; Tue, 04 Dec 2012 03:58:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0000_01CDD259.C55D22B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Replace the nameing, hba, hbb and hbc, with hbaA, hbaB abd hbaC respectively
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0000_01CDD259.C55D22B0
Content-Type: application/octet-stream;
	name="patch1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch1"

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c =
b/drivers/scsi/arcmsr/arcmsr_attr.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_attr.c	2012-12-04 19:09:42.471089955 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c	2012-12-04 19:12:25.983088365 =
+0800=0A=
@@ -59,15 +59,17 @@=0A=
 =0A=
 struct device_attribute *arcmsr_host_attrs[];=0A=
 =0A=
-static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,=0A=
-					     struct kobject *kobj,=0A=
-					     struct bin_attribute *bin,=0A=
-					     char *buf, loff_t off,=0A=
-					     size_t count)=0A=
+static ssize_t=0A=
+arcmsr_sysfs_iop_message_read(struct file *filp,=0A=
+				struct kobject *kobj,=0A=
+				struct bin_attribute *bin,=0A=
+				char *buf, loff_t off,=0A=
+				size_t count)=0A=
 {=0A=
-	struct device *dev =3D container_of(kobj,struct device,kobj);=0A=
+	struct device *dev =3D container_of(kobj, struct device, kobj);=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	uint8_t *pQbuffer,*ptmpQbuffer;=0A=
 	int32_t allxfer_len =3D 0;=0A=
 =0A=
@@ -95,7 +97,8 @@ static ssize_t arcmsr_sysfs_iop_message_=0A=
 		iop_data =3D prbuffer->data;=0A=
 		iop_len =3D readl(&prbuffer->data_len);=0A=
 		while (iop_len > 0) {=0A=
-			acb->rqbuffer[acb->rqbuf_lastindex] =3D readb(iop_data);=0A=
+			acb->rqbuffer[acb->rqbuf_lastindex] =3D=0A=
+				readb(iop_data);=0A=
 			acb->rqbuf_lastindex++;=0A=
 			acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
 			iop_data++;=0A=
@@ -106,15 +109,17 @@ static ssize_t arcmsr_sysfs_iop_message_=0A=
 	return (allxfer_len);=0A=
 }=0A=
 =0A=
-static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,=0A=
-					      struct kobject *kobj,=0A=
-					      struct bin_attribute *bin,=0A=
-					      char *buf, loff_t off,=0A=
-					      size_t count)=0A=
+static ssize_t=0A=
+arcmsr_sysfs_iop_message_write(struct file *filp,=0A=
+				      struct kobject *kobj,=0A=
+				      struct bin_attribute *bin,=0A=
+				      char *buf, loff_t off,=0A=
+				      size_t count)=0A=
 {=0A=
-	struct device *dev =3D container_of(kobj,struct device,kobj);=0A=
+	struct device *dev =3D container_of(kobj, struct device, kobj);=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;=0A=
 	uint8_t *pQbuffer, *ptmpuserbuffer;=0A=
 =0A=
@@ -139,11 +144,13 @@ static ssize_t arcmsr_sysfs_iop_message_=0A=
 				&acb->wqbuffer[acb->wqbuf_lastindex];=0A=
 				memcpy(pQbuffer, ptmpuserbuffer, 1);=0A=
 				acb->wqbuf_lastindex++;=0A=
-				acb->wqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+				acb->wqbuf_lastindex %=3D=0A=
+					ARCMSR_MAX_QBUFFER;=0A=
 				ptmpuserbuffer++;=0A=
 				user_len--;=0A=
 			}=0A=
-			if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
+			if (acb->acb_flags &=0A=
+				ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
 				acb->acb_flags &=3D=0A=
 					~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
 				arcmsr_post_ioctldata2iop(acb);=0A=
@@ -155,15 +162,17 @@ static ssize_t arcmsr_sysfs_iop_message_=0A=
 	}=0A=
 }=0A=
 =0A=
-static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,=0A=
-					      struct kobject *kobj,=0A=
-					      struct bin_attribute *bin,=0A=
-					      char *buf, loff_t off,=0A=
-					      size_t count)=0A=
+static ssize_t=0A=
+arcmsr_sysfs_iop_message_clear(struct file *filp,=0A=
+				      struct kobject *kobj,=0A=
+				      struct bin_attribute *bin,=0A=
+				      char *buf, loff_t off,=0A=
+				      size_t count)=0A=
 {=0A=
-	struct device *dev =3D container_of(kobj,struct device,kobj);=0A=
+	struct device *dev =3D container_of(kobj, struct device, kobj);=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	uint8_t *pQbuffer;=0A=
 =0A=
 	if (!capable(CAP_SYS_ADMIN))=0A=
@@ -215,31 +224,37 @@ static struct bin_attribute arcmsr_sysfs=0A=
 	.write =3D arcmsr_sysfs_iop_message_clear,=0A=
 };=0A=
 =0A=
-int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)=0A=
+int=0A=
+arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct Scsi_Host *host =3D acb->host;=0A=
 	int error;=0A=
 =0A=
-	error =3D sysfs_create_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_read_attr);=0A=
+	error =3D sysfs_create_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_read_attr);=0A=
 	if (error) {=0A=
-		printk(KERN_ERR "arcmsr: alloc sysfs mu_read failed\n");=0A=
+		pr_err("arcmsr: alloc sysfs mu_read failed\n");=0A=
 		goto error_bin_file_message_read;=0A=
 	}=0A=
-	error =3D sysfs_create_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_write_attr);=0A=
+	error =3D sysfs_create_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_write_attr);=0A=
 	if (error) {=0A=
-		printk(KERN_ERR "arcmsr: alloc sysfs mu_write failed\n");=0A=
+		pr_err("arcmsr: alloc sysfs mu_write failed\n");=0A=
 		goto error_bin_file_message_write;=0A=
 	}=0A=
-	error =3D sysfs_create_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_clear_attr);=0A=
+	error =3D sysfs_create_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_clear_attr);=0A=
 	if (error) {=0A=
-		printk(KERN_ERR "arcmsr: alloc sysfs mu_clear failed\n");=0A=
+		pr_err("arcmsr: alloc sysfs mu_clear failed\n");=0A=
 		goto error_bin_file_message_clear;=0A=
 	}=0A=
 	return 0;=0A=
 error_bin_file_message_clear:=0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_write_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_write_attr);=0A=
 error_bin_file_message_write:=0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_read_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_read_attr);=0A=
 error_bin_file_message_read:=0A=
 	return error;=0A=
 }=0A=
@@ -248,15 +263,17 @@ void arcmsr_free_sysfs_attr(struct Adapt=0A=
 {=0A=
 	struct Scsi_Host *host =3D acb->host;=0A=
 =0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_clear_attr);=0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_write_attr);=0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_read_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_clear_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_write_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_read_attr);=0A=
 }=0A=
 =0A=
-=0A=
 static ssize_t=0A=
 arcmsr_attr_host_driver_version(struct device *dev,=0A=
-				struct device_attribute *attr, char *buf)=0A=
+			struct device_attribute *attr, char *buf)=0A=
 {=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%s\n",=0A=
@@ -265,11 +282,11 @@ arcmsr_attr_host_driver_version(struct d=0A=
 =0A=
 static ssize_t=0A=
 arcmsr_attr_host_driver_posted_cmd(struct device *dev,=0A=
-				   struct device_attribute *attr, char *buf)=0A=
+			struct device_attribute *attr, char *buf)=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
 			atomic_read(&acb->ccboutstandingcount));=0A=
@@ -281,7 +298,7 @@ arcmsr_attr_host_driver_reset(struct dev=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
 			acb->num_resets);=0A=
@@ -293,19 +310,19 @@ arcmsr_attr_host_driver_abort(struct dev=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
 			acb->num_aborts);=0A=
 }=0A=
 =0A=
 static ssize_t=0A=
-arcmsr_attr_host_fw_model(struct device *dev, struct device_attribute =
*attr,=0A=
-			  char *buf)=0A=
+arcmsr_attr_host_fw_model(struct device *dev,=0A=
+			struct device_attribute *attr, char *buf)=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%s\n",=0A=
 			acb->firm_model);=0A=
@@ -317,8 +334,7 @@ arcmsr_attr_host_fw_version(struct devic=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-			(struct AdapterControlBlock *) host->hostdata;=0A=
-=0A=
+			(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%s\n",=0A=
 			acb->firm_version);=0A=
@@ -330,7 +346,7 @@ arcmsr_attr_host_fw_request_len(struct d=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
@@ -343,7 +359,7 @@ arcmsr_attr_host_fw_numbers_queue(struct=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
@@ -356,7 +372,7 @@ arcmsr_attr_host_fw_sdram_size(struct de=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
@@ -369,23 +385,33 @@ arcmsr_attr_host_fw_hd_channels(struct d=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
 			acb->firm_hd_channels);=0A=
 }=0A=
 =0A=
-static DEVICE_ATTR(host_driver_version, S_IRUGO, =
arcmsr_attr_host_driver_version, NULL);=0A=
-static DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO, =
arcmsr_attr_host_driver_posted_cmd, NULL);=0A=
-static DEVICE_ATTR(host_driver_reset, S_IRUGO, =
arcmsr_attr_host_driver_reset, NULL);=0A=
-static DEVICE_ATTR(host_driver_abort, S_IRUGO, =
arcmsr_attr_host_driver_abort, NULL);=0A=
-static DEVICE_ATTR(host_fw_model, S_IRUGO, arcmsr_attr_host_fw_model, =
NULL);=0A=
-static DEVICE_ATTR(host_fw_version, S_IRUGO, =
arcmsr_attr_host_fw_version, NULL);=0A=
-static DEVICE_ATTR(host_fw_request_len, S_IRUGO, =
arcmsr_attr_host_fw_request_len, NULL);=0A=
-static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO, =
arcmsr_attr_host_fw_numbers_queue, NULL);=0A=
-static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO, =
arcmsr_attr_host_fw_sdram_size, NULL);=0A=
-static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO, =
arcmsr_attr_host_fw_hd_channels, NULL);=0A=
+static DEVICE_ATTR(host_driver_version, S_IRUGO,=0A=
+	arcmsr_attr_host_driver_version, NULL);=0A=
+static DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO,=0A=
+	arcmsr_attr_host_driver_posted_cmd, NULL);=0A=
+static DEVICE_ATTR(host_driver_reset, S_IRUGO,=0A=
+	arcmsr_attr_host_driver_reset, NULL);=0A=
+static DEVICE_ATTR(host_driver_abort, S_IRUGO,=0A=
+	arcmsr_attr_host_driver_abort, NULL);=0A=
+static DEVICE_ATTR(host_fw_model, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_model, NULL);=0A=
+static DEVICE_ATTR(host_fw_version, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_version, NULL);=0A=
+static DEVICE_ATTR(host_fw_request_len, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_request_len, NULL);=0A=
+static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_numbers_queue, NULL);=0A=
+static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_sdram_size, NULL);=0A=
+static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_hd_channels, NULL);=0A=
 =0A=
 struct device_attribute *arcmsr_host_attrs[] =3D {=0A=
 	&dev_attr_host_driver_version,=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2012-12-04 19:09:42.471089955 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2012-12-04 19:12:25.991088366 +0800=0A=
@@ -45,42 +45,42 @@=0A=
 #include <linux/interrupt.h>=0A=
 struct device_attribute;=0A=
 /*The limit of outstanding scsi command that firmware can handle*/=0A=
-#define ARCMSR_MAX_OUTSTANDING_CMD						256=0A=
+#define ARCMSR_MAX_OUTSTANDING_CMD		256=0A=
 #ifdef CONFIG_XEN=0A=
 	#define ARCMSR_MAX_FREECCB_NUM	160=0A=
 #else=0A=
 	#define ARCMSR_MAX_FREECCB_NUM	320=0A=
 #endif=0A=
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2010/08/05"=0A=
-#define ARCMSR_SCSI_INITIATOR_ID						255=0A=
-#define ARCMSR_MAX_XFER_SECTORS							512=0A=
-#define ARCMSR_MAX_XFER_SECTORS_B						4096=0A=
-#define ARCMSR_MAX_XFER_SECTORS_C						304=0A=
-#define ARCMSR_MAX_TARGETID							17=0A=
-#define ARCMSR_MAX_TARGETLUN							8=0A=
-#define ARCMSR_MAX_CMD_PERLUN		                 =
ARCMSR_MAX_OUTSTANDING_CMD=0A=
-#define ARCMSR_MAX_QBUFFER							4096=0A=
-#define ARCMSR_DEFAULT_SG_ENTRIES						38=0A=
-#define ARCMSR_MAX_HBB_POSTQUEUE						264=0A=
-#define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */=0A=
-#define ARCMSR_CDB_SG_PAGE_LENGTH						256 =0A=
+#define ARCMSR_DRIVER_VERSION		"Driver Version 1.20.00.15 2012/09/30"=0A=
+#define ARCMSR_SCSI_INITIATOR_ID		255=0A=
+#define ARCMSR_MAX_XFER_SECTORS		512=0A=
+#define ARCMSR_MAX_XFER_SECTORS_B		4096=0A=
+#define ARCMSR_MAX_XFER_SECTORS_C		304=0A=
+#define ARCMSR_MAX_TARGETID			17=0A=
+#define ARCMSR_MAX_TARGETLUN			8=0A=
+#define ARCMSR_MAX_CMD_PERLUN			ARCMSR_MAX_OUTSTANDING_CMD=0A=
+#define ARCMSR_MAX_QBUFFER			4096=0A=
+#define ARCMSR_DEFAULT_SG_ENTRIES		38=0A=
+#define ARCMSR_MAX_HBB_POSTQUEUE		264=0A=
+#define ARCMSR_MAX_XFER_LEN			0x26000=0A=
+#define ARCMSR_CDB_SG_PAGE_LENGTH		256=0A=
 #ifndef PCI_DEVICE_ID_ARECA_1880=0A=
-#define PCI_DEVICE_ID_ARECA_1880 0x1880=0A=
+	#define PCI_DEVICE_ID_ARECA_1880	0x1880=0A=
  #endif=0A=
 /*=0A=
 =
*************************************************************************=
*********=0A=
 **=0A=
 =
*************************************************************************=
*********=0A=
 */=0A=
-#define ARC_SUCCESS                                                     =
  0=0A=
-#define ARC_FAILURE                                                     =
  1=0A=
+#define ARC_SUCCESS				0=0A=
+#define ARC_FAILURE				1=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **        split 64bits dma addressing=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
-#define dma_addr_hi32(addr)               (uint32_t) ((addr>>16)>>16)=0A=
-#define dma_addr_lo32(addr)               (uint32_t) (addr & 0xffffffff)=0A=
+#define dma_addr_hi32(addr)	(uint32_t)((addr >> 16) >> 16)=0A=
+#define dma_addr_lo32(addr)	(uint32_t)(addr & 0xffffffff)=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **        MESSAGE CONTROL CODE=0A=
@@ -88,12 +88,12 @@ struct device_attribute;=0A=
 */=0A=
 struct CMD_MESSAGE=0A=
 {=0A=
-      uint32_t HeaderLength;=0A=
-      uint8_t  Signature[8];=0A=
-      uint32_t Timeout;=0A=
-      uint32_t ControlCode;=0A=
-      uint32_t ReturnCode;=0A=
-      uint32_t Length;=0A=
+	uint32_t HeaderLength;=0A=
+	uint8_t Signature[8];=0A=
+	uint32_t Timeout;=0A=
+	uint32_t ControlCode;=0A=
+	uint32_t ReturnCode;=0A=
+	uint32_t Length;=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -102,8 +102,8 @@ struct CMD_MESSAGE=0A=
 */=0A=
 struct CMD_MESSAGE_FIELD=0A=
 {=0A=
-    struct CMD_MESSAGE			cmdmessage;=0A=
-    uint8_t				messagedatabuffer[1032];=0A=
+	struct CMD_MESSAGE cmdmessage;=0A=
+	uint8_t messagedatabuffer[1032];=0A=
 };=0A=
 /* IOP message transfer */=0A=
 #define ARCMSR_MESSAGE_FAIL			0x0001=0A=
@@ -111,57 +111,57 @@ struct CMD_MESSAGE_FIELD=0A=
 #define ARECA_SATA_RAID				0x90000000=0A=
 /* FunctionCode */=0A=
 #define FUNCTION_READ_RQBUFFER			0x0801=0A=
-#define FUNCTION_WRITE_WQBUFFER			0x0802=0A=
-#define FUNCTION_CLEAR_RQBUFFER			0x0803=0A=
-#define FUNCTION_CLEAR_WQBUFFER			0x0804=0A=
+#define FUNCTION_WRITE_WQBUFFER		0x0802=0A=
+#define FUNCTION_CLEAR_RQBUFFER		0x0803=0A=
+#define FUNCTION_CLEAR_WQBUFFER		0x0804=0A=
 #define FUNCTION_CLEAR_ALLQBUFFER		0x0805=0A=
-#define FUNCTION_RETURN_CODE_3F			0x0806=0A=
+#define FUNCTION_RETURN_CODE_3F		0x0806=0A=
 #define FUNCTION_SAY_HELLO			0x0807=0A=
 #define FUNCTION_SAY_GOODBYE			0x0808=0A=
 #define FUNCTION_FLUSH_ADAPTER_CACHE		0x0809=0A=
-#define FUNCTION_GET_FIRMWARE_STATUS			0x080A=0A=
-#define FUNCTION_HARDWARE_RESET			0x080B=0A=
+#define FUNCTION_GET_FIRMWARE_STATUS		0x080A=0A=
+#define FUNCTION_HARDWARE_RESET		0x080B=0A=
 /* ARECA IO CONTROL CODE*/=0A=
-#define ARCMSR_MESSAGE_READ_RQBUFFER       \=0A=
-	ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER=0A=
-#define ARCMSR_MESSAGE_WRITE_WQBUFFER      \=0A=
-	ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER=0A=
-#define ARCMSR_MESSAGE_CLEAR_RQBUFFER      \=0A=
-	ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER=0A=
-#define ARCMSR_MESSAGE_CLEAR_WQBUFFER      \=0A=
-	ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER=0A=
-#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER    \=0A=
-	ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER=0A=
-#define ARCMSR_MESSAGE_RETURN_CODE_3F      \=0A=
-	ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F=0A=
-#define ARCMSR_MESSAGE_SAY_HELLO           \=0A=
-	ARECA_SATA_RAID | FUNCTION_SAY_HELLO=0A=
-#define ARCMSR_MESSAGE_SAY_GOODBYE         \=0A=
-	ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE=0A=
-#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE \=0A=
-	ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE=0A=
+#define ARCMSR_MESSAGE_READ_RQBUFFER		\=0A=
+	(ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER)=0A=
+#define ARCMSR_MESSAGE_WRITE_WQBUFFER	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER)=0A=
+#define ARCMSR_MESSAGE_CLEAR_RQBUFFER	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER)=0A=
+#define ARCMSR_MESSAGE_CLEAR_WQBUFFER	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER)=0A=
+#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER)=0A=
+#define ARCMSR_MESSAGE_RETURN_CODE_3F	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F)=0A=
+#define ARCMSR_MESSAGE_SAY_HELLO		\=0A=
+	(ARECA_SATA_RAID | FUNCTION_SAY_HELLO)=0A=
+#define ARCMSR_MESSAGE_SAY_GOODBYE		\=0A=
+	(ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE)=0A=
+#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE)=0A=
 /* ARECA IOCTL ReturnCode */=0A=
-#define ARCMSR_MESSAGE_RETURNCODE_OK		0x00000001=0A=
+#define ARCMSR_MESSAGE_RETURNCODE_OK			0x00000001=0A=
 #define ARCMSR_MESSAGE_RETURNCODE_ERROR		0x00000006=0A=
-#define ARCMSR_MESSAGE_RETURNCODE_3F		0x0000003F=0A=
+#define ARCMSR_MESSAGE_RETURNCODE_3F			0x0000003F=0A=
 #define ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON	0x00000088=0A=
 /*=0A=
 *************************************************************=0A=
 **   structure for holding DMA address data=0A=
 *************************************************************=0A=
 */=0A=
-#define IS_DMA64			(sizeof(dma_addr_t) =3D=3D 8)=0A=
-#define IS_SG64_ADDR                0x01000000 /* bit24 */=0A=
+#define IS_DMA64		(sizeof(dma_addr_t) =3D=3D 8)=0A=
+#define IS_SG64_ADDR	0x01000000 /* bit24 */=0A=
 struct  SG32ENTRY=0A=
 {=0A=
-	__le32					length;=0A=
-	__le32					address;=0A=
+	__le32 length;=0A=
+	__le32 address;=0A=
 }__attribute__ ((packed));=0A=
 struct  SG64ENTRY=0A=
 {=0A=
-	__le32					length;=0A=
-	__le32					address;=0A=
-	__le32					addresshigh;=0A=
+	__le32 length;=0A=
+	__le32 address;=0A=
+	__le32 addresshigh;=0A=
 }__attribute__ ((packed));=0A=
 /*=0A=
 ********************************************************************=0A=
@@ -170,8 +170,8 @@ struct  SG64ENTRY=0A=
 */=0A=
 struct QBUFFER=0A=
 {=0A=
-	uint32_t      data_len;=0A=
-	uint8_t       data[124];=0A=
+	uint32_t data_len;=0A=
+	uint8_t data[124];=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -180,50 +180,50 @@ struct QBUFFER=0A=
 */=0A=
 struct FIRMWARE_INFO=0A=
 {=0A=
-	uint32_t      signature;		/*0, 00-03*/=0A=
-	uint32_t      request_len;		/*1, 04-07*/=0A=
-	uint32_t      numbers_queue;		/*2, 08-11*/=0A=
-	uint32_t      sdram_size;               /*3, 12-15*/=0A=
-	uint32_t      ide_channels;		/*4, 16-19*/=0A=
-	char          vendor[40];		/*5, 20-59*/=0A=
-	char          model[8];			/*15, 60-67*/=0A=
-	char          firmware_ver[16];     	/*17, 68-83*/=0A=
-	char          device_map[16];		/*21, 84-99*/=0A=
-	uint32_t		cfgVersion;               	/*25,100-103 Added for checking =
of new firmware capability*/=0A=
-	uint8_t		cfgSerial[16];           	/*26,104-119*/=0A=
-	uint32_t		cfgPicStatus;            	/*30,120-123*/	=0A=
+	uint32_t signature;	/*0, 00-03*/=0A=
+	uint32_t request_len;	/*1, 04-07*/=0A=
+	uint32_t numbers_queue;	/*2, 08-11*/=0A=
+	uint32_t sdram_size;	/*3, 12-15*/=0A=
+	uint32_t ide_channels;	/*4, 16-19*/=0A=
+	char vendor[40];		/*5, 20-59*/=0A=
+	char model[8];		/*15, 60-67*/=0A=
+	char firmware_ver[16];	/*17, 68-83*/=0A=
+	char device_map[16];	/*21, 84-99*/=0A=
+	uint32_t cfgVersion;	/*25, 100-103*/=0A=
+	uint8_t cfgSerial[16];	/*26, 104-119*/=0A=
+	uint32_t cfgPicStatus;	/*30, 120-123*/=0A=
 };=0A=
 /* signature of set and get firmware config */=0A=
-#define ARCMSR_SIGNATURE_GET_CONFIG		      0x87974060=0A=
-#define ARCMSR_SIGNATURE_SET_CONFIG		      0x87974063=0A=
+#define ARCMSR_SIGNATURE_GET_CONFIG		0x87974060=0A=
+#define ARCMSR_SIGNATURE_SET_CONFIG		0x87974063=0A=
 /* message code of inbound message register */=0A=
-#define ARCMSR_INBOUND_MESG0_NOP		      0x00000000=0A=
-#define ARCMSR_INBOUND_MESG0_GET_CONFIG		      0x00000001=0A=
-#define ARCMSR_INBOUND_MESG0_SET_CONFIG               0x00000002=0A=
-#define ARCMSR_INBOUND_MESG0_ABORT_CMD                0x00000003=0A=
-#define ARCMSR_INBOUND_MESG0_STOP_BGRB                0x00000004=0A=
-#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE              0x00000005=0A=
-#define ARCMSR_INBOUND_MESG0_START_BGRB               0x00000006=0A=
-#define ARCMSR_INBOUND_MESG0_CHK331PENDING            0x00000007=0A=
-#define ARCMSR_INBOUND_MESG0_SYNC_TIMER               0x00000008=0A=
+#define ARCMSR_INBOUND_MESG0_NOP		0x00000000=0A=
+#define ARCMSR_INBOUND_MESG0_GET_CONFIG	0x00000001=0A=
+#define ARCMSR_INBOUND_MESG0_SET_CONFIG	0x00000002=0A=
+#define ARCMSR_INBOUND_MESG0_ABORT_CMD	0x00000003=0A=
+#define ARCMSR_INBOUND_MESG0_STOP_BGRB	0x00000004=0A=
+#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE	0x00000005=0A=
+#define ARCMSR_INBOUND_MESG0_START_BGRB	0x00000006=0A=
+#define ARCMSR_INBOUND_MESG0_CHK331PENDING	0x00000007=0A=
+#define ARCMSR_INBOUND_MESG0_SYNC_TIMER	0x00000008=0A=
 /* doorbell interrupt generator */=0A=
-#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK           0x00000001=0A=
-#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK            0x00000002=0A=
-#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK          0x00000001=0A=
-#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK           0x00000002=0A=
+#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK	0x00000001=0A=
+#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK	0x00000002=0A=
+#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK	0x00000001=0A=
+#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK	0x00000002=0A=
 /* ccb areca cdb flag */=0A=
-#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE                 0x80000000=0A=
-#define ARCMSR_CCBPOST_FLAG_IAM_BIOS                  0x40000000=0A=
-#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS                 0x40000000=0A=
-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0              0x10000000=0A=
-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1              0x00000001=0A=
+#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE		0x80000000=0A=
+#define ARCMSR_CCBPOST_FLAG_IAM_BIOS		0x40000000=0A=
+#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS		0x40000000=0A=
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0	0x10000000=0A=
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1	0x00000001=0A=
 /* outbound firmware ok */=0A=
-#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000=0A=
+#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK	0x80000000=0A=
 /* ARC-1680 Bus Reset*/=0A=
-#define ARCMSR_ARC1680_BUS_RESET				0x00000003=0A=
+#define ARCMSR_ARC1680_BUS_RESET		0x00000003=0A=
 /* ARC-1880 Bus Reset*/=0A=
-#define ARCMSR_ARC1880_RESET_ADAPTER				0x00000024=0A=
-#define ARCMSR_ARC1880_DiagWrite_ENABLE			0x00000080=0A=
+#define ARCMSR_ARC1880_RESET_ADAPTER		0x00000024=0A=
+#define ARCMSR_ARC1880_DiagWrite_ENABLE	0x00000080=0A=
 =0A=
 /*=0A=
 ************************************************************************=0A=
@@ -232,98 +232,101 @@ struct FIRMWARE_INFO=0A=
 */=0A=
 /* ARECA HBB COMMAND for its FIRMWARE */=0A=
 /* window of "instruction flags" from driver to iop */=0A=
-#define ARCMSR_DRV2IOP_DOORBELL                       0x00020400=0A=
-#define ARCMSR_DRV2IOP_DOORBELL_MASK                  0x00020404=0A=
+#define ARCMSR_DRV2IOP_DOORBELL		0x00020400=0A=
+#define ARCMSR_DRV2IOP_DOORBELL_MASK		0x00020404=0A=
 /* window of "instruction flags" from iop to driver */=0A=
-#define ARCMSR_IOP2DRV_DOORBELL                       0x00020408=0A=
-#define ARCMSR_IOP2DRV_DOORBELL_MASK                  0x0002040C=0A=
+#define ARCMSR_IOP2DRV_DOORBELL		0x00020408=0A=
+#define ARCMSR_IOP2DRV_DOORBELL_MASK		0x0002040C=0A=
 /* ARECA FLAG LANGUAGE */=0A=
 /* ioctl transfer */=0A=
-#define ARCMSR_IOP2DRV_DATA_WRITE_OK                  0x00000001=0A=
+#define ARCMSR_IOP2DRV_DATA_WRITE_OK		0x00000001=0A=
 /* ioctl transfer */=0A=
-#define ARCMSR_IOP2DRV_DATA_READ_OK                   0x00000002=0A=
-#define ARCMSR_IOP2DRV_CDB_DONE                       0x00000004=0A=
-#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE               0x00000008=0A=
+#define ARCMSR_IOP2DRV_DATA_READ_OK		0x00000002=0A=
+#define ARCMSR_IOP2DRV_CDB_DONE		0x00000004=0A=
+#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE	0x00000008=0A=
 =0A=
-#define ARCMSR_DOORBELL_HANDLE_INT		      0x0000000F=0A=
-#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN   	      0xFF00FFF0=0A=
-#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN	      0xFF00FFF7=0A=
+#define ARCMSR_DOORBELL_HANDLE_INT		0x0000000F=0A=
+#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN	0xFF00FFF0=0A=
+#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN	0xFF00FFF7=0A=
 /* =
(ARCMSR_INBOUND_MESG0_GET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_GET_CONFIG		      0x00010008=0A=
+#define ARCMSR_MESSAGE_GET_CONFIG		0x00010008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_SET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_SET_CONFIG		      0x00020008=0A=
+#define ARCMSR_MESSAGE_SET_CONFIG		0x00020008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_ABORT_CMD<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_ABORT_CMD		      0x00030008=0A=
+#define ARCMSR_MESSAGE_ABORT_CMD		0x00030008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_STOP_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_STOP_BGRB		      0x00040008=0A=
+#define ARCMSR_MESSAGE_STOP_BGRB		0x00040008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_FLUSH_CACHE<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED)=
 */=0A=
-#define ARCMSR_MESSAGE_FLUSH_CACHE                    0x00050008=0A=
+#define ARCMSR_MESSAGE_FLUSH_CACHE		0x00050008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_START_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_START_BGRB		      0x00060008=0A=
-#define ARCMSR_MESSAGE_START_DRIVER_MODE	      0x000E0008=0A=
-#define ARCMSR_MESSAGE_SET_POST_WINDOW		      0x000F0008=0A=
-#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE		    0x00100008=0A=
+#define ARCMSR_MESSAGE_START_BGRB		0x00060008=0A=
+#define ARCMSR_MESSAGE_START_DRIVER_MODE	0x000E0008=0A=
+#define ARCMSR_MESSAGE_SET_POST_WINDOW	0x000F0008=0A=
+#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE	0x00100008=0A=
 /* ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK */=0A=
-#define ARCMSR_MESSAGE_FIRMWARE_OK		      0x80000000=0A=
+#define ARCMSR_MESSAGE_FIRMWARE_OK		0x80000000=0A=
 /* ioctl transfer */=0A=
-#define ARCMSR_DRV2IOP_DATA_WRITE_OK                  0x00000001=0A=
+#define ARCMSR_DRV2IOP_DATA_WRITE_OK		0x00000001=0A=
 /* ioctl transfer */=0A=
-#define ARCMSR_DRV2IOP_DATA_READ_OK                   0x00000002=0A=
-#define ARCMSR_DRV2IOP_CDB_POSTED                     0x00000004=0A=
-#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED             0x00000008=0A=
-#define ARCMSR_DRV2IOP_END_OF_INTERRUPT		0x00000010=0A=
+#define ARCMSR_DRV2IOP_DATA_READ_OK		0x00000002=0A=
+#define ARCMSR_DRV2IOP_CDB_POSTED		0x00000004=0A=
+#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED	0x00000008=0A=
+#define ARCMSR_DRV2IOP_END_OF_INTERRUPT	0x00000010=0A=
 =0A=
 /* data tunnel buffer between user space program and its firmware */=0A=
 /* user space data to iop 128bytes */=0A=
-#define ARCMSR_MESSAGE_WBUFFER			      0x0000fe00=0A=
+#define ARCMSR_MESSAGE_WBUFFER		0x0000fe00=0A=
 /* iop data to user space 128bytes */=0A=
-#define ARCMSR_MESSAGE_RBUFFER			      0x0000ff00=0A=
+#define ARCMSR_MESSAGE_RBUFFER		0x0000ff00=0A=
 /* iop message_rwbuffer for message command */=0A=
-#define ARCMSR_MESSAGE_RWBUFFER			      0x0000fa00=0A=
+#define ARCMSR_MESSAGE_RWBUFFER		0x0000fa00=0A=
 /* =0A=
 ************************************************************************=0A=
 **                SPEC. for Areca HBC adapter=0A=
 ************************************************************************=0A=
 */=0A=
-#define ARCMSR_HBC_ISR_THROTTLING_LEVEL		12=0A=
-#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE		20=0A=
+#define ARCMSR_HBC_ISR_THROTTLING_LEVEL	12=0A=
+#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE	20=0A=
 /* Host Interrupt Mask */=0A=
-#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK		0x00000001 /* When clear, the =
Utility_A interrupt routes to the host.*/=0A=
-#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK	0x00000004 /* When =
clear, the General Outbound Doorbell interrupt routes to the host.*/=0A=
-#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK	0x00000008 /* When =
clear, the Outbound Post List FIFO Not Empty interrupt routes to the =
host.*/=0A=
-#define ARCMSR_HBCMU_ALL_INTMASKENABLE		0x0000000D /* disable all ISR */=0A=
+#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK		0x00000001=0A=
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK	0x00000004=0A=
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK	0x00000008=0A=
+#define ARCMSR_HBCMU_ALL_INTMASKENABLE		0x0000000D=0A=
 /* Host Interrupt Status */=0A=
 #define ARCMSR_HBCMU_UTILITY_A_ISR			0x00000001=0A=
-	/*=0A=
-	** Set when the Utility_A Interrupt bit is set in the Outbound =
Doorbell Register.=0A=
-	** It clears by writing a 1 to the Utility_A bit in the Outbound =
Doorbell Clear Register or through automatic clearing (if enabled).=0A=
-	*/=0A=
+/*=0A=
+** Set when the Utility_A Interrupt bit is set=0A=
+** in the Outbound Doorbell Register.=0A=
+** It clears by writing a 1 to the Utility_A=0A=
+** bit in the Outbound Doorbell Clear Register=0A=
+** or through automatic clearing (if enabled).=0A=
+*/=0A=
 #define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR		0x00000004=0A=
-	/*=0A=
-	** Set if Outbound Doorbell register bits 30:1 have a non-zero=0A=
-	** value. This bit clears only when Outbound Doorbell bits=0A=
-	** 30:1 are ALL clear. Only a write to the Outbound Doorbell=0A=
-	** Clear register clears bits in the Outbound Doorbell register.=0A=
-	*/=0A=
+/*=0A=
+** Set if Outbound Doorbell register bits 30:1 have a non-zero=0A=
+** value. This bit clears only when Outbound Doorbell bits=0A=
+** 30:1 are ALL clear. Only a write to the Outbound Doorbell=0A=
+** Clear register clears bits in the Outbound Doorbell register.=0A=
+*/=0A=
 #define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR	0x00000008=0A=
-	/*=0A=
-	** Set whenever the Outbound Post List Producer/Consumer=0A=
-	** Register (FIFO) is not empty. It clears when the Outbound=0A=
-	** Post List FIFO is empty.=0A=
-	*/=0A=
+/*=0A=
+** Set whenever the Outbound Post List Producer/Consumer=0A=
+** Register (FIFO) is not empty. It clears when the Outbound=0A=
+** Post List FIFO is empty.=0A=
+*/=0A=
 #define ARCMSR_HBCMU_SAS_ALL_INT			0x00000010=0A=
-	/*=0A=
-	** This bit indicates a SAS interrupt from a source external to=0A=
-	** the PCIe core. This bit is not maskable.=0A=
-	*/=0A=
-	/* DoorBell*/=0A=
-#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK			0x00000002=0A=
-#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK			0x00000004=0A=
+/*=0A=
+** This bit indicates a SAS interrupt from a source external to=0A=
+** the PCIe core. This bit is not maskable.=0A=
+*/=0A=
+/* DoorBell*/=0A=
+#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK		0x00000002=0A=
+#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK		0x00000004=0A=
 	/*inbound message 0 ready*/=0A=
-#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE		0x00000008=0A=
+#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE	0x00000008=0A=
 	/*more than 12 request completed in a time*/=0A=
-#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING		0x00000010=0A=
-#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK			0x00000002=0A=
+#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING	0x00000010=0A=
+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK		0x00000002=0A=
 	/*outbound DATA WRITE isr door bell clear*/=0A=
 #define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_DOORBELL_CLEAR	0x00000002=0A=
 #define ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK			0x00000004=0A=
@@ -342,35 +345,34 @@ struct FIRMWARE_INFO=0A=
 */=0A=
 struct ARCMSR_CDB=0A=
 {=0A=
-	uint8_t							Bus;=0A=
-	uint8_t							TargetID;=0A=
-	uint8_t							LUN;=0A=
-	uint8_t							Function;=0A=
-	uint8_t							CdbLength;=0A=
-	uint8_t							sgcount;=0A=
-	uint8_t							Flags;=0A=
-#define ARCMSR_CDB_FLAG_SGL_BSIZE          0x01=0A=
-#define ARCMSR_CDB_FLAG_BIOS               0x02=0A=
-#define ARCMSR_CDB_FLAG_WRITE              0x04=0A=
-#define ARCMSR_CDB_FLAG_SIMPLEQ            0x00=0A=
-#define ARCMSR_CDB_FLAG_HEADQ              0x08=0A=
-#define ARCMSR_CDB_FLAG_ORDEREDQ           0x10=0A=
+	uint8_t Bus;=0A=
+	uint8_t TargetID;=0A=
+	uint8_t LUN;=0A=
+	uint8_t Function;=0A=
+	uint8_t CdbLength;=0A=
+	uint8_t sgcount;=0A=
+	uint8_t Flags;=0A=
+#define ARCMSR_CDB_FLAG_SGL_BSIZE	0x01=0A=
+#define ARCMSR_CDB_FLAG_BIOS		0x02=0A=
+#define ARCMSR_CDB_FLAG_WRITE		0x04=0A=
+#define ARCMSR_CDB_FLAG_SIMPLEQ	0x00=0A=
+#define ARCMSR_CDB_FLAG_HEADQ		0x08=0A=
+#define ARCMSR_CDB_FLAG_ORDEREDQ	0x10=0A=
 =0A=
-	uint8_t							msgPages;=0A=
-	uint32_t						Context;=0A=
-	uint32_t						DataLength;=0A=
-	uint8_t							Cdb[16];=0A=
-	uint8_t							DeviceStatus;=0A=
-#define ARCMSR_DEV_CHECK_CONDITION	    0x02=0A=
-#define ARCMSR_DEV_SELECT_TIMEOUT	    0xF0=0A=
-#define ARCMSR_DEV_ABORTED		    0xF1=0A=
-#define ARCMSR_DEV_INIT_FAIL		    0xF2=0A=
+	uint8_t msgPages;=0A=
+	uint32_t Context;=0A=
+	uint32_t DataLength;=0A=
+	uint8_t Cdb[16];=0A=
+	uint8_t DeviceStatus;=0A=
+#define ARCMSR_DEV_CHECK_CONDITION	0x02=0A=
+#define ARCMSR_DEV_SELECT_TIMEOUT	0xF0=0A=
+#define ARCMSR_DEV_ABORTED		0xF1=0A=
+#define ARCMSR_DEV_INIT_FAIL		0xF2=0A=
 =0A=
-	uint8_t							SenseData[15];=0A=
-	union=0A=
-	{=0A=
-		struct SG32ENTRY                sg32entry[1];=0A=
-		struct SG64ENTRY                sg64entry[1];=0A=
+	uint8_t SenseData[15];=0A=
+	union {=0A=
+		struct SG32ENTRY sg32entry[1];=0A=
+		struct SG64ENTRY sg64entry[1];=0A=
 	} u;=0A=
 };=0A=
 /*=0A=
@@ -380,118 +382,118 @@ struct ARCMSR_CDB=0A=
 */=0A=
 struct MessageUnit_A=0A=
 {=0A=
-	uint32_t	resrved0[4];			/*0000 000F*/=0A=
-	uint32_t	inbound_msgaddr0;		/*0010 0013*/=0A=
-	uint32_t	inbound_msgaddr1;		/*0014 0017*/=0A=
-	uint32_t	outbound_msgaddr0;		/*0018 001B*/=0A=
-	uint32_t	outbound_msgaddr1;		/*001C 001F*/=0A=
-	uint32_t	inbound_doorbell;		/*0020 0023*/=0A=
-	uint32_t	inbound_intstatus;		/*0024 0027*/=0A=
-	uint32_t	inbound_intmask;		/*0028 002B*/=0A=
-	uint32_t	outbound_doorbell;		/*002C 002F*/=0A=
-	uint32_t	outbound_intstatus;		/*0030 0033*/=0A=
-	uint32_t	outbound_intmask;		/*0034 0037*/=0A=
-	uint32_t	reserved1[2];			/*0038 003F*/=0A=
-	uint32_t	inbound_queueport;		/*0040 0043*/=0A=
-	uint32_t	outbound_queueport;     	/*0044 0047*/=0A=
-	uint32_t	reserved2[2];			/*0048 004F*/=0A=
-	uint32_t	reserved3[492];			/*0050 07FF 492*/=0A=
-	uint32_t	reserved4[128];			/*0800 09FF 128*/=0A=
-	uint32_t	message_rwbuffer[256];		/*0a00 0DFF 256*/=0A=
-	uint32_t	message_wbuffer[32];		/*0E00 0E7F  32*/=0A=
-	uint32_t	reserved5[32];			/*0E80 0EFF  32*/=0A=
-	uint32_t	message_rbuffer[32];		/*0F00 0F7F  32*/=0A=
-	uint32_t	reserved6[32];			/*0F80 0FFF  32*/=0A=
+	uint32_t resrved0[4];		/*0000 000F*/=0A=
+	uint32_t inbound_msgaddr0;	/*0010 0013*/=0A=
+	uint32_t inbound_msgaddr1;	/*0014 0017*/=0A=
+	uint32_t outbound_msgaddr0;	/*0018 001B*/=0A=
+	uint32_t outbound_msgaddr1;	/*001C 001F*/=0A=
+	uint32_t inbound_doorbell;		/*0020 0023*/=0A=
+	uint32_t inbound_intstatus;		/*0024 0027*/=0A=
+	uint32_t inbound_intmask;		/*0028 002B*/=0A=
+	uint32_t outbound_doorbell;	/*002C 002F*/=0A=
+	uint32_t outbound_intstatus;	/*0030 0033*/=0A=
+	uint32_t outbound_intmask;	/*0034 0037*/=0A=
+	uint32_t reserved1[2];		/*0038 003F*/=0A=
+	uint32_t inbound_queueport;	/*0040 0043*/=0A=
+	uint32_t outbound_queueport;	/*0044 0047*/=0A=
+	uint32_t reserved2[2];		/*0048 004F*/=0A=
+	uint32_t reserved3[492];		/*0050 07FF 492*/=0A=
+	uint32_t reserved4[128];		/*0800 09FF 128*/=0A=
+	uint32_t message_rwbuffer[256];	/*0a00 0DFF 256*/=0A=
+	uint32_t message_wbuffer[32];	/*0E00 0E7F  32*/=0A=
+	uint32_t reserved5[32];		/*0E80 0EFF  32*/=0A=
+	uint32_t message_rbuffer[32];	/*0F00 0F7F  32*/=0A=
+	uint32_t reserved6[32];		/*0F80 0FFF  32*/=0A=
 };=0A=
 =0A=
 struct MessageUnit_B=0A=
 {=0A=
-	uint32_t	post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
-	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
-	uint32_t	postq_index;=0A=
-	uint32_t	doneq_index;=0A=
-	uint32_t		__iomem *drv2iop_doorbell;=0A=
-	uint32_t		__iomem *drv2iop_doorbell_mask;=0A=
-	uint32_t		__iomem *iop2drv_doorbell;=0A=
-	uint32_t		__iomem *iop2drv_doorbell_mask;=0A=
-	uint32_t		__iomem *message_rwbuffer;=0A=
-	uint32_t		__iomem *message_wbuffer;=0A=
-	uint32_t		__iomem *message_rbuffer;=0A=
+	uint32_t post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
+	uint32_t done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
+	uint32_t postq_index;=0A=
+	uint32_t doneq_index;=0A=
+	uint32_t __iomem *drv2iop_doorbell;=0A=
+	uint32_t __iomem *drv2iop_doorbell_mask;=0A=
+	uint32_t __iomem *iop2drv_doorbell;=0A=
+	uint32_t __iomem *iop2drv_doorbell_mask;=0A=
+	uint32_t __iomem *message_rwbuffer;=0A=
+	uint32_t __iomem *message_wbuffer;=0A=
+	uint32_t __iomem *message_rbuffer;=0A=
 };=0A=
 /*=0A=
 *********************************************************************=0A=
 ** LSI=0A=
 *********************************************************************=0A=
 */=0A=
-struct MessageUnit_C{=0A=
-	uint32_t	message_unit_status;			/*0000 0003*/=0A=
-	uint32_t	slave_error_attribute;			/*0004 0007*/=0A=
-	uint32_t	slave_error_address;			/*0008 000B*/=0A=
-	uint32_t	posted_outbound_doorbell;		/*000C 000F*/=0A=
-	uint32_t	master_error_attribute;			/*0010 0013*/=0A=
-	uint32_t	master_error_address_low;		/*0014 0017*/=0A=
-	uint32_t	master_error_address_high;		/*0018 001B*/=0A=
-	uint32_t	hcb_size;				/*001C 001F*/=0A=
-	uint32_t	inbound_doorbell;			/*0020 0023*/=0A=
-	uint32_t	diagnostic_rw_data;			/*0024 0027*/=0A=
-	uint32_t	diagnostic_rw_address_low;		/*0028 002B*/=0A=
-	uint32_t	diagnostic_rw_address_high;		/*002C 002F*/=0A=
-	uint32_t	host_int_status;				/*0030 0033*/=0A=
-	uint32_t	host_int_mask;				/*0034 0037*/=0A=
-	uint32_t	dcr_data;				/*0038 003B*/=0A=
-	uint32_t	dcr_address;				/*003C 003F*/=0A=
-	uint32_t	inbound_queueport;			/*0040 0043*/=0A=
-	uint32_t	outbound_queueport;			/*0044 0047*/=0A=
-	uint32_t	hcb_pci_address_low;			/*0048 004B*/=0A=
-	uint32_t	hcb_pci_address_high;			/*004C 004F*/=0A=
-	uint32_t	iop_int_status;				/*0050 0053*/=0A=
-	uint32_t	iop_int_mask;				/*0054 0057*/=0A=
-	uint32_t	iop_inbound_queue_port;			/*0058 005B*/=0A=
-	uint32_t	iop_outbound_queue_port;		/*005C 005F*/=0A=
-	uint32_t	inbound_free_list_index;			/*0060 0063*/=0A=
-	uint32_t	inbound_post_list_index;			/*0064 0067*/=0A=
-	uint32_t	outbound_free_list_index;			/*0068 006B*/=0A=
-	uint32_t	outbound_post_list_index;			/*006C 006F*/=0A=
-	uint32_t	inbound_doorbell_clear;			/*0070 0073*/=0A=
-	uint32_t	i2o_message_unit_control;			/*0074 0077*/=0A=
-	uint32_t	last_used_message_source_address_low;	/*0078 007B*/=0A=
-	uint32_t	last_used_message_source_address_high;	/*007C 007F*/=0A=
-	uint32_t	pull_mode_data_byte_count[4];		/*0080 008F*/=0A=
-	uint32_t	message_dest_address_index;		/*0090 0093*/=0A=
-	uint32_t	done_queue_not_empty_int_counter_timer;	/*0094 0097*/=0A=
-	uint32_t	utility_A_int_counter_timer;		/*0098 009B*/=0A=
-	uint32_t	outbound_doorbell;			/*009C 009F*/=0A=
-	uint32_t	outbound_doorbell_clear;			/*00A0 00A3*/=0A=
-	uint32_t	message_source_address_index;		/*00A4 00A7*/=0A=
-	uint32_t	message_done_queue_index;		/*00A8 00AB*/=0A=
-	uint32_t	reserved0;				/*00AC 00AF*/=0A=
-	uint32_t	inbound_msgaddr0;			/*00B0 00B3*/=0A=
-	uint32_t	inbound_msgaddr1;			/*00B4 00B7*/=0A=
-	uint32_t	outbound_msgaddr0;			/*00B8 00BB*/=0A=
-	uint32_t	outbound_msgaddr1;			/*00BC 00BF*/=0A=
-	uint32_t	inbound_queueport_low;			/*00C0 00C3*/=0A=
-	uint32_t	inbound_queueport_high;			/*00C4 00C7*/=0A=
-	uint32_t	outbound_queueport_low;			/*00C8 00CB*/=0A=
-	uint32_t	outbound_queueport_high;		/*00CC 00CF*/=0A=
-	uint32_t	iop_inbound_queue_port_low;		/*00D0 00D3*/=0A=
-	uint32_t	iop_inbound_queue_port_high;		/*00D4 00D7*/=0A=
-	uint32_t	iop_outbound_queue_port_low;		/*00D8 00DB*/=0A=
-	uint32_t	iop_outbound_queue_port_high;		/*00DC 00DF*/=0A=
-	uint32_t	message_dest_queue_port_low;		/*00E0 00E3*/=0A=
-	uint32_t	message_dest_queue_port_high;		/*00E4 00E7*/=0A=
-	uint32_t	last_used_message_dest_address_low;	/*00E8 00EB*/=0A=
-	uint32_t	last_used_message_dest_address_high;	/*00EC 00EF*/=0A=
-	uint32_t	message_done_queue_base_address_low;	/*00F0 00F3*/=0A=
-	uint32_t	message_done_queue_base_address_high;	/*00F4 00F7*/=0A=
-	uint32_t	host_diagnostic;				/*00F8 00FB*/=0A=
-	uint32_t	write_sequence;				/*00FC 00FF*/=0A=
-	uint32_t	reserved1[34];				/*0100 0187*/=0A=
-	uint32_t	reserved2[1950];				/*0188 1FFF*/=0A=
-	uint32_t	message_wbuffer[32];			/*2000 207F*/=0A=
-	uint32_t	reserved3[32];				/*2080 20FF*/=0A=
-	uint32_t	message_rbuffer[32];			/*2100 217F*/=0A=
-	uint32_t	reserved4[32];				/*2180 21FF*/=0A=
-	uint32_t	msgcode_rwbuffer[256];			/*2200 23FF*/=0A=
+struct MessageUnit_C {=0A=
+	uint32_t message_unit_status;			/*0000 0003*/=0A=
+	uint32_t slave_error_attribute;			/*0004 0007*/=0A=
+	uint32_t slave_error_address;			/*0008 000B*/=0A=
+	uint32_t posted_outbound_doorbell;			/*000C 000F*/=0A=
+	uint32_t master_error_attribute;			/*0010 0013*/=0A=
+	uint32_t master_error_address_low;			/*0014 0017*/=0A=
+	uint32_t master_error_address_high;		/*0018 001B*/=0A=
+	uint32_t hcb_size;					/*001C 001F*/=0A=
+	uint32_t inbound_doorbell;				/*0020 0023*/=0A=
+	uint32_t diagnostic_rw_data;			/*0024 0027*/=0A=
+	uint32_t diagnostic_rw_address_low;		/*0028 002B*/=0A=
+	uint32_t diagnostic_rw_address_high;		/*002C 002F*/=0A=
+	uint32_t host_int_status;				/*0030 0033*/=0A=
+	uint32_t host_int_mask;				/*0034 0037*/=0A=
+	uint32_t dcr_data;					/*0038 003B*/=0A=
+	uint32_t dcr_address;				/*003C 003F*/=0A=
+	uint32_t inbound_queueport;			/*0040 0043*/=0A=
+	uint32_t outbound_queueport;			/*0044 0047*/=0A=
+	uint32_t hcb_pci_address_low;			/*0048 004B*/=0A=
+	uint32_t hcb_pci_address_high;			/*004C 004F*/=0A=
+	uint32_t iop_int_status;				/*0050 0053*/=0A=
+	uint32_t iop_int_mask;				/*0054 0057*/=0A=
+	uint32_t iop_inbound_queue_port;			/*0058 005B*/=0A=
+	uint32_t iop_outbound_queue_port;			/*005C 005F*/=0A=
+	uint32_t inbound_free_list_index;			/*0060 0063*/=0A=
+	uint32_t inbound_post_list_index;			/*0064 0067*/=0A=
+	uint32_t outbound_free_list_index;			/*0068 006B*/=0A=
+	uint32_t outbound_post_list_index;			/*006C 006F*/=0A=
+	uint32_t inbound_doorbell_clear;			/*0070 0073*/=0A=
+	uint32_t i2o_message_unit_control;			/*0074 0077*/=0A=
+	uint32_t last_used_message_source_address_low;	/*0078 007B*/=0A=
+	uint32_t last_used_message_source_address_high;	/*007C 007F*/=0A=
+	uint32_t pull_mode_data_byte_count[4];		/*0080 008F*/=0A=
+	uint32_t message_dest_address_index;		/*0090 0093*/=0A=
+	uint32_t done_queue_not_empty_int_counter_timer;	/*0094 0097*/=0A=
+	uint32_t utility_A_int_counter_timer;		/*0098 009B*/=0A=
+	uint32_t outbound_doorbell;			/*009C 009F*/=0A=
+	uint32_t outbound_doorbell_clear;			/*00A0 00A3*/=0A=
+	uint32_t message_source_address_index;		/*00A4 00A7*/=0A=
+	uint32_t message_done_queue_index;		/*00A8 00AB*/=0A=
+	uint32_t reserved0;				/*00AC 00AF*/=0A=
+	uint32_t inbound_msgaddr0;			/*00B0 00B3*/=0A=
+	uint32_t inbound_msgaddr1;			/*00B4 00B7*/=0A=
+	uint32_t outbound_msgaddr0;			/*00B8 00BB*/=0A=
+	uint32_t outbound_msgaddr1;			/*00BC 00BF*/=0A=
+	uint32_t inbound_queueport_low;			/*00C0 00C3*/=0A=
+	uint32_t inbound_queueport_high;			/*00C4 00C7*/=0A=
+	uint32_t outbound_queueport_low;			/*00C8 00CB*/=0A=
+	uint32_t outbound_queueport_high;		/*00CC 00CF*/=0A=
+	uint32_t iop_inbound_queue_port_low;		/*00D0 00D3*/=0A=
+	uint32_t iop_inbound_queue_port_high;		/*00D4 00D7*/=0A=
+	uint32_t iop_outbound_queue_port_low;		/*00D8 00DB*/=0A=
+	uint32_t iop_outbound_queue_port_high;		/*00DC 00DF*/=0A=
+	uint32_t message_dest_queue_port_low;		/*00E0 00E3*/=0A=
+	uint32_t message_dest_queue_port_high;		/*00E4 00E7*/=0A=
+	uint32_t last_used_message_dest_address_low;	/*00E8 00EB*/=0A=
+	uint32_t last_used_message_dest_address_high;	/*00EC 00EF*/=0A=
+	uint32_t message_done_queue_base_address_low;	/*00F0 00F3*/=0A=
+	uint32_t message_done_queue_base_address_high;	/*00F4 00F7*/=0A=
+	uint32_t host_diagnostic;				/*00F8 00FB*/=0A=
+	uint32_t write_sequence;				/*00FC 00FF*/=0A=
+	uint32_t reserved1[34];				/*0100 0187*/=0A=
+	uint32_t reserved2[1950];				/*0188 1FFF*/=0A=
+	uint32_t message_wbuffer[32];			/*2000 207F*/=0A=
+	uint32_t reserved3[32];				/*2080 20FF*/=0A=
+	uint32_t message_rbuffer[32];			/*2100 217F*/=0A=
+	uint32_t reserved4[32];				/*2180 21FF*/=0A=
+	uint32_t msgcode_rwbuffer[256];			/*2200 23FF*/=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -500,100 +502,100 @@ struct MessageUnit_C{=0A=
 */=0A=
 struct AdapterControlBlock=0A=
 {=0A=
-	uint32_t  adapter_type;                /* adapter A,B..... */=0A=
-	#define ACB_ADAPTER_TYPE_A            0x00000001	/* hba I IOP */=0A=
-	#define ACB_ADAPTER_TYPE_B            0x00000002	/* hbb M IOP */=0A=
-	#define ACB_ADAPTER_TYPE_C            0x00000004	/* hbc P IOP */=0A=
-	#define ACB_ADAPTER_TYPE_D            0x00000008	/* hbd A IOP */=0A=
-	struct pci_dev *		pdev;=0A=
-	struct Scsi_Host *		host;=0A=
-	unsigned long			vir2phy_offset;=0A=
+	uint32_t adapter_type;	/* adapter A,B..... */=0A=
+	#define ACB_ADAPTER_TYPE_A	0x00000001	/* hba I IOP */=0A=
+	#define ACB_ADAPTER_TYPE_B	0x00000002	/* hbb M IOP */=0A=
+	#define ACB_ADAPTER_TYPE_C	0x00000004	/* hbc P IOP */=0A=
+	#define ACB_ADAPTER_TYPE_D	0x00000008	/* hbd A IOP */=0A=
+	struct pci_dev *pdev;=0A=
+	struct Scsi_Host *host;=0A=
+	unsigned long vir2phy_offset;=0A=
 	/* Offset is used in making arc cdb physical to virtual calculations */=0A=
-	uint32_t			outbound_int_enable;=0A=
-	uint32_t			cdb_phyaddr_hi32;=0A=
-	uint32_t			reg_mu_acc_handle0;=0A=
-	spinlock_t                      			eh_lock;=0A=
-	spinlock_t                      			ccblist_lock;=0A=
+	uint32_t outbound_int_enable;=0A=
+	uint32_t cdb_phyaddr_hi32;=0A=
+	uint32_t reg_mu_acc_handle0;=0A=
+	spinlock_t eh_lock;=0A=
+	spinlock_t ccblist_lock;=0A=
 	union {=0A=
 		struct MessageUnit_A __iomem *pmuA;=0A=
-		struct MessageUnit_B 	*pmuB;=0A=
+		struct MessageUnit_B *pmuB;=0A=
 		struct MessageUnit_C __iomem *pmuC;=0A=
 	};=0A=
 	/* message unit ATU inbound base address0 */=0A=
 	void __iomem *mem_base0;=0A=
 	void __iomem *mem_base1;=0A=
-	uint32_t			acb_flags;=0A=
-	u16			dev_id;=0A=
-	uint8_t                   		adapter_index;=0A=
-	#define ACB_F_SCSISTOPADAPTER         	0x0001=0A=
-	#define ACB_F_MSG_STOP_BGRB     	0x0002=0A=
+	uint32_t acb_flags;=0A=
+	u16 dev_id;=0A=
+	uint8_t adapter_index;=0A=
+	#define ACB_F_SCSISTOPADAPTER			0x0001=0A=
+	#define ACB_F_MSG_STOP_BGRB			0x0002=0A=
 	/* stop RAID background rebuild */=0A=
-	#define ACB_F_MSG_START_BGRB          	0x0004=0A=
+	#define ACB_F_MSG_START_BGRB			0x0004=0A=
 	/* stop RAID background rebuild */=0A=
-	#define ACB_F_IOPDATA_OVERFLOW        	0x0008=0A=
+	#define ACB_F_IOPDATA_OVERFLOW		0x0008=0A=
 	/* iop message data rqbuffer overflow */=0A=
 	#define ACB_F_MESSAGE_WQBUFFER_CLEARED	0x0010=0A=
 	/* message clear wqbuffer */=0A=
-	#define ACB_F_MESSAGE_RQBUFFER_CLEARED  0x0020=0A=
+	#define ACB_F_MESSAGE_RQBUFFER_CLEARED	0x0020=0A=
 	/* message clear rqbuffer */=0A=
-	#define ACB_F_MESSAGE_WQBUFFER_READED   0x0040=0A=
-	#define ACB_F_BUS_RESET               	0x0080=0A=
-	#define ACB_F_BUS_HANG_ON		0x0800/* need hardware reset bus */=0A=
+	#define ACB_F_MESSAGE_WQBUFFER_READED	0x0040=0A=
+	#define ACB_F_BUS_RESET				0x0080=0A=
+	#define ACB_F_BUS_HANG_ON			0x0800=0A=
 =0A=
-	#define ACB_F_IOP_INITED              	0x0100=0A=
+	#define ACB_F_IOP_INITED				0x0100=0A=
 	/* iop init */=0A=
 	#define ACB_F_ABORT				0x0200=0A=
-	#define ACB_F_FIRMWARE_TRAP           		0x0400=0A=
-	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];=0A=
+	#define ACB_F_FIRMWARE_TRAP			0x0400=0A=
+	struct CommandControlBlock *pccb_pool[ARCMSR_MAX_FREECCB_NUM];=0A=
 	/* used for memory free */=0A=
-	struct list_head		ccb_free_list;=0A=
+	struct list_head ccb_free_list;=0A=
 	/* head of free ccb list */=0A=
 =0A=
-	atomic_t			ccboutstandingcount;=0A=
+	atomic_t ccboutstandingcount;=0A=
 	/*The present outstanding command number that in the IOP that=0A=
 					waiting for being handled by FW*/=0A=
 =0A=
-	void *				dma_coherent;=0A=
+	void *dma_coherent;=0A=
 	/* dma_coherent used for memory free */=0A=
-	dma_addr_t			dma_coherent_handle;=0A=
+	dma_addr_t dma_coherent_handle;=0A=
 	/* dma_coherent_handle used for memory free */=0A=
-	dma_addr_t				dma_coherent_handle_hbb_mu;=0A=
-	unsigned int				uncache_size;=0A=
-	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];=0A=
+	dma_addr_t dma_coherent_handle_hbb_mu;=0A=
+	unsigned int uncache_size;=0A=
+	uint8_t rqbuffer[ARCMSR_MAX_QBUFFER];=0A=
 	/* data collection buffer for read from 80331 */=0A=
-	int32_t				rqbuf_firstindex;=0A=
+	int32_t rqbuf_firstindex;=0A=
 	/* first of read buffer  */=0A=
-	int32_t				rqbuf_lastindex;=0A=
+	int32_t rqbuf_lastindex;=0A=
 	/* last of read buffer   */=0A=
-	uint8_t				wqbuffer[ARCMSR_MAX_QBUFFER];=0A=
+	uint8_t wqbuffer[ARCMSR_MAX_QBUFFER];=0A=
 	/* data collection buffer for write to 80331  */=0A=
-	int32_t				wqbuf_firstindex;=0A=
+	int32_t wqbuf_firstindex;=0A=
 	/* first of write buffer */=0A=
-	int32_t				wqbuf_lastindex;=0A=
+	int32_t wqbuf_lastindex;=0A=
 	/* last of write buffer  */=0A=
-	uint8_t				devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];=0A=
+	uint8_t devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];=0A=
 	/* id0 ..... id15, lun0...lun7 */=0A=
-#define ARECA_RAID_GONE               0x55=0A=
-#define ARECA_RAID_GOOD               0xaa=0A=
-	uint32_t			num_resets;=0A=
-	uint32_t			num_aborts;=0A=
-	uint32_t			signature;=0A=
-	uint32_t			firm_request_len;=0A=
-	uint32_t			firm_numbers_queue;=0A=
-	uint32_t			firm_sdram_size;=0A=
-	uint32_t			firm_hd_channels;=0A=
-	uint32_t                           	firm_cfg_version;	=0A=
-	char			firm_model[12];=0A=
-	char			firm_version[20];=0A=
-	char			device_map[20];			/*21,84-99*/=0A=
-	struct work_struct 		arcmsr_do_message_isr_bh;=0A=
-	struct timer_list		eternal_timer;=0A=
-	unsigned short		fw_flag;=0A=
-				#define	FW_NORMAL	0x0000=0A=
-				#define	FW_BOG		0x0001=0A=
-				#define	FW_DEADLOCK	0x0010=0A=
-	atomic_t 			rq_map_token;=0A=
-	atomic_t			ante_token_value;=0A=
+#define ARECA_RAID_GONE		0x55=0A=
+#define ARECA_RAID_GOOD	0xaa=0A=
+	uint32_t num_resets;=0A=
+	uint32_t num_aborts;=0A=
+	uint32_t signature;=0A=
+	uint32_t firm_request_len;=0A=
+	uint32_t firm_numbers_queue;=0A=
+	uint32_t firm_sdram_size;=0A=
+	uint32_t firm_hd_channels;=0A=
+	uint32_t firm_cfg_version;=0A=
+	char firm_model[12];=0A=
+	char firm_version[20];=0A=
+	char device_map[20];	/*21,84-99*/=0A=
+	struct work_struct arcmsr_do_message_isr_bh;=0A=
+	struct timer_list eternal_timer;=0A=
+	unsigned short fw_flag;=0A=
+	#define FW_NORMAL	0x0000=0A=
+	#define FW_BOG		0x0001=0A=
+	#define FW_DEADLOCK	0x0010=0A=
+	atomic_t rq_map_token;=0A=
+	atomic_t ante_token_value;=0A=
 };/* HW_DEVICE_EXTENSION */=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -601,33 +603,33 @@ struct AdapterControlBlock=0A=
 **             this CCB length must be 32 bytes boundary=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
-struct CommandControlBlock{=0A=
-	/*x32:sizeof struct_CCB=3D(32+60)byte, x64:sizeof =
struct_CCB=3D(64+60)byte*/=0A=
-	struct list_head		list;				/*x32: 8byte, x64: 16byte*/=0A=
-	struct scsi_cmnd		*pcmd;				/*8 bytes pointer of linux scsi command */=0A=
-	struct AdapterControlBlock	*acb;				/*x32: 4byte, x64: 8byte*/=0A=
-	uint32_t			cdb_phyaddr_pattern;		/*x32: 4byte, x64: 4byte*/=0A=
-	uint32_t			arc_cdb_size;			/*x32:4byte,x64:4byte*/=0A=
-	uint16_t			ccb_flags;			/*x32: 2byte, x64: 2byte*/=0A=
-	#define			CCB_FLAG_READ			0x0000=0A=
-	#define			CCB_FLAG_WRITE		0x0001=0A=
-	#define			CCB_FLAG_ERROR		0x0002=0A=
-	#define			CCB_FLAG_FLUSHCACHE		0x0004=0A=
-	#define			CCB_FLAG_MASTER_ABORTED	0x0008	=0A=
-	uint16_t                        	startdone;			/*x32:2byte,x32:2byte*/=0A=
-	#define			ARCMSR_CCB_DONE   	        	0x0000=0A=
-	#define			ARCMSR_CCB_START		0x55AA=0A=
-	#define			ARCMSR_CCB_ABORTED		0xAA55=0A=
-	#define			ARCMSR_CCB_ILLEGAL		0xFFFF=0A=
+struct CommandControlBlock {=0A=
+/*x32:sizeof struct_CCB=3D(32+60)byte, x64:sizeof =
struct_CCB=3D(64+60)byte*/=0A=
+	struct list_head list;=0A=
+	struct scsi_cmnd *pcmd;=0A=
+	struct AdapterControlBlock *acb;=0A=
+	uint32_t cdb_phyaddr_pattern;=0A=
+	uint32_t arc_cdb_size;=0A=
+	uint16_t ccb_flags;=0A=
+	#define CCB_FLAG_READ		0x0000=0A=
+	#define CCB_FLAG_WRITE		0x0001=0A=
+	#define CCB_FLAG_ERROR		0x0002=0A=
+	#define CCB_FLAG_FLUSHCACHE	0x0004=0A=
+	#define CCB_FLAG_MASTER_ABORTED	0x0008=0A=
+	uint16_t startdone;=0A=
+	#define ARCMSR_CCB_DONE	0x0000=0A=
+	#define ARCMSR_CCB_START	0x55AA=0A=
+	#define ARCMSR_CCB_ABORTED	0xAA55=0A=
+	#define ARCMSR_CCB_ILLEGAL	0xFFFF=0A=
 	#if BITS_PER_LONG =3D=3D 64=0A=
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+64 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
-		uint32_t                        	reserved[5];		/*24 byte*/=0A=
+		uint32_t reserved[5];	/*24 byte*/=0A=
 	#else=0A=
-	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+32 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
-		uint32_t                        	reserved;		/*8  byte*/=0A=
+	=
/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+3=
2 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/=0A=
+		uint32_t reserved;	/*8  byte*/=0A=
 	#endif=0A=
-	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D   */=0A=
-	struct ARCMSR_CDB		arcmsr_cdb;=0A=
+	=
/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D*/=0A=
+	struct ARCMSR_CDB arcmsr_cdb;=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -636,53 +638,53 @@ struct CommandControlBlock{=0A=
 */=0A=
 struct SENSE_DATA=0A=
 {=0A=
-	uint8_t				ErrorCode:7;=0A=
+	uint8_t ErrorCode:7;=0A=
 #define SCSI_SENSE_CURRENT_ERRORS	0x70=0A=
 #define SCSI_SENSE_DEFERRED_ERRORS	0x71=0A=
-	uint8_t				Valid:1;=0A=
-	uint8_t				SegmentNumber;=0A=
-	uint8_t				SenseKey:4;=0A=
-	uint8_t				Reserved:1;=0A=
-	uint8_t				IncorrectLength:1;=0A=
-	uint8_t				EndOfMedia:1;=0A=
-	uint8_t				FileMark:1;=0A=
-	uint8_t				Information[4];=0A=
-	uint8_t				AdditionalSenseLength;=0A=
-	uint8_t				CommandSpecificInformation[4];=0A=
-	uint8_t				AdditionalSenseCode;=0A=
-	uint8_t				AdditionalSenseCodeQualifier;=0A=
-	uint8_t				FieldReplaceableUnitCode;=0A=
-	uint8_t				SenseKeySpecific[3];=0A=
+	uint8_t Valid:1;=0A=
+	uint8_t SegmentNumber;=0A=
+	uint8_t SenseKey:4;=0A=
+	uint8_t Reserved:1;=0A=
+	uint8_t IncorrectLength:1;=0A=
+	uint8_t EndOfMedia:1;=0A=
+	uint8_t FileMark:1;=0A=
+	uint8_t Information[4];=0A=
+	uint8_t AdditionalSenseLength;=0A=
+	uint8_t CommandSpecificInformation[4];=0A=
+	uint8_t AdditionalSenseCode;=0A=
+	uint8_t AdditionalSenseCodeQualifier;=0A=
+	uint8_t FieldReplaceableUnitCode;=0A=
+	uint8_t SenseKeySpecific[3];=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **  Outbound Interrupt Status Register - OISR=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
-#define     ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG                 0x30=0A=
-#define     ARCMSR_MU_OUTBOUND_PCI_INT                              0x10=0A=
-#define     ARCMSR_MU_OUTBOUND_POSTQUEUE_INT                        0x08=0A=
-#define     ARCMSR_MU_OUTBOUND_DOORBELL_INT                         0x04=0A=
-#define     ARCMSR_MU_OUTBOUND_MESSAGE1_INT                         0x02=0A=
-#define     ARCMSR_MU_OUTBOUND_MESSAGE0_INT                         0x01=0A=
-#define     ARCMSR_MU_OUTBOUND_HANDLE_INT                 \=0A=
-                    (ARCMSR_MU_OUTBOUND_MESSAGE0_INT      \=0A=
-                     |ARCMSR_MU_OUTBOUND_MESSAGE1_INT     \=0A=
-                     |ARCMSR_MU_OUTBOUND_DOORBELL_INT     \=0A=
-                     |ARCMSR_MU_OUTBOUND_POSTQUEUE_INT    \=0A=
-                     |ARCMSR_MU_OUTBOUND_PCI_INT)=0A=
+#define ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG	0x30=0A=
+#define ARCMSR_MU_OUTBOUND_PCI_INT			0x10=0A=
+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INT		0x08=0A=
+#define ARCMSR_MU_OUTBOUND_DOORBELL_INT		0x04=0A=
+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INT		0x02=0A=
+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INT		0x01=0A=
+#define ARCMSR_MU_OUTBOUND_HANDLE_INT	\=0A=
+	(ARCMSR_MU_OUTBOUND_MESSAGE0_INT	\=0A=
+	|ARCMSR_MU_OUTBOUND_MESSAGE1_INT	\=0A=
+	|ARCMSR_MU_OUTBOUND_DOORBELL_INT	\=0A=
+	|ARCMSR_MU_OUTBOUND_POSTQUEUE_INT	\=0A=
+	|ARCMSR_MU_OUTBOUND_PCI_INT)=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **  Outbound Interrupt Mask Register - OIMR=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
-#define     ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG                   0x34=0A=
-#define     ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE                    0x10=0A=
-#define     ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE              0x08=0A=
-#define     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE               0x04=0A=
-#define     ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE               0x02=0A=
-#define     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE               0x01=0A=
-#define     ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE                    0x1F=0A=
+#define ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG		0x34=0A=
+#define ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE		0x10=0A=
+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE	0x08=0A=
+#define ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE	0x04=0A=
+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE	0x02=0A=
+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE	0x01=0A=
+#define ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE		0x1F=0A=
 =0A=
 extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);=0A=
 extern void arcmsr_iop_message_read(struct AdapterControlBlock *);=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2012-12-04 19:09:42.471089955 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2012-12-04 19:12:25.995088366 =
+0800=0A=
@@ -71,12 +71,12 @@=0A=
 #include <scsi/scsicam.h>=0A=
 #include "arcmsr.h"=0A=
 MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");=0A=
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host =
Bus Adapter");=0A=
+MODULE_DESCRIPTION("Areca SAS RAID Controller Driver");=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
 =0A=
-#define	ARCMSR_SLEEPTIME	10=0A=
-#define	ARCMSR_RETRYCOUNT	12=0A=
+#define ARCMSR_SLEEPTIME	10=0A=
+#define ARCMSR_RETRYCOUNT	12=0A=
 =0A=
 wait_queue_head_t wait_q;=0A=
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
@@ -95,16 +95,16 @@ static void arcmsr_iop_init(struct Adapt=0A=
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);=0A=
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock =
*acb);=0A=
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);=0A=
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);=0A=
+static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);=0A=
+static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_request_device_map(unsigned long pacb);=0A=
-static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb);=0A=
-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb);=0A=
-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock =
*acb);=0A=
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);=0A=
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *pACB);=0A=
+static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);=0A=
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);=0A=
 static const char *arcmsr_info(struct Scsi_Host *);=0A=
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);=0A=
@@ -172,14 +172,13 @@ static struct pci_driver arcmsr_pci_driv=0A=
 =
*************************************************************************=
***=0A=
 =
*************************************************************************=
***=0A=
 */=0A=
-=0A=
 static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
 	case ACB_ADAPTER_TYPE_C:=0A=
 		break;=0A=
-	case ACB_ADAPTER_TYPE_B:{=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
 		dma_free_coherent(&acb->pdev->dev,=0A=
 			sizeof(struct MessageUnit_B),=0A=
 			acb->pmuB, acb->dma_coherent_handle_hbb_mu);=0A=
@@ -190,40 +189,50 @@ static void arcmsr_free_hbb_mu(struct Ad=0A=
 static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
-	switch (acb->adapter_type){=0A=
-	case ACB_ADAPTER_TYPE_A:{=0A=
-		acb->pmuA =3D ioremap(pci_resource_start(pdev,0), =
pci_resource_len(pdev,0));=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
+		acb->pmuA =3D ioremap(pci_resource_start(pdev, 0),=0A=
+			pci_resource_len(pdev, 0));=0A=
 		if (!acb->pmuA) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: memory mapping "=0A=
+				"region fail\n", acb->host->host_no);=0A=
 			return false;=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
-	case ACB_ADAPTER_TYPE_B:{=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
 		void __iomem *mem_base0, *mem_base1;=0A=
-		mem_base0 =3D ioremap(pci_resource_start(pdev, 0), =
pci_resource_len(pdev, 0));=0A=
+		mem_base0 =3D ioremap(pci_resource_start(pdev, 0),=0A=
+			pci_resource_len(pdev, 0));=0A=
 		if (!mem_base0) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: memory mapping "=0A=
+				"region fail\n", acb->host->host_no);=0A=
 			return false;=0A=
 		}=0A=
-		mem_base1 =3D ioremap(pci_resource_start(pdev, 2), =
pci_resource_len(pdev, 2));=0A=
+		mem_base1 =3D ioremap(pci_resource_start(pdev, 2),=0A=
+			pci_resource_len(pdev, 2));=0A=
 		if (!mem_base1) {=0A=
 			iounmap(mem_base0);=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: memory mapping "=0A=
+				"region fail\n", acb->host->host_no);=0A=
 			return false;=0A=
 		}=0A=
 		acb->mem_base0 =3D mem_base0;=0A=
 		acb->mem_base1 =3D mem_base1;=0A=
 		break;=0A=
 	}=0A=
-	case ACB_ADAPTER_TYPE_C:{=0A=
-		acb->pmuC =3D ioremap_nocache(pci_resource_start(pdev, 1), =
pci_resource_len(pdev, 1));=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		acb->pmuC =3D ioremap_nocache(pci_resource_start(pdev, 1),=0A=
+			pci_resource_len(pdev, 1));=0A=
 		if (!acb->pmuC) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: memory mapping "=0A=
+				"region fail\n", acb->host->host_no);=0A=
 			return false;=0A=
 		}=0A=
-		if (readl(&acb->pmuC->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/=0A=
+		if (readl(&acb->pmuC->outbound_doorbell) &=0A=
+			ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
+				&acb->pmuC->outbound_doorbell_clear);=0A=
 			return true;=0A=
 		}=0A=
 		break;=0A=
@@ -235,17 +244,17 @@ static bool arcmsr_remap_pciregion(struc=0A=
 static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
-	case ACB_ADAPTER_TYPE_A:{=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
 		iounmap(acb->pmuA);=0A=
 	}=0A=
 	break;=0A=
-	case ACB_ADAPTER_TYPE_B:{=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
 		iounmap(acb->mem_base0);=0A=
 		iounmap(acb->mem_base1);=0A=
 	}=0A=
 =0A=
 	break;=0A=
-	case ACB_ADAPTER_TYPE_C:{=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
 		iounmap(acb->pmuC);=0A=
 	}=0A=
 	}=0A=
@@ -264,11 +273,12 @@ static int arcmsr_bios_param(struct scsi=0A=
 		struct block_device *bdev, sector_t capacity, int *geom)=0A=
 {=0A=
 	int ret, heads, sectors, cylinders, total_capacity;=0A=
-	unsigned char *buffer;/* return copy of block device's partition table =
*/=0A=
+	unsigned char *buffer;=0A=
 =0A=
 	buffer =3D scsi_bios_ptable(bdev);=0A=
 	if (buffer) {=0A=
-		ret =3D scsi_partsize(buffer, capacity, &geom[2], &geom[0], &geom[1]);=0A=
+		ret =3D scsi_partsize(buffer, capacity, &geom[2], &geom[0],=0A=
+			&geom[1]);=0A=
 		kfree(buffer);=0A=
 		if (ret !=3D -1)=0A=
 			return ret;=0A=
@@ -288,7 +298,8 @@ static int arcmsr_bios_param(struct scsi=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_define_adapter_type(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
 	u16 dev_id;=0A=
@@ -308,7 +319,8 @@ static void arcmsr_define_adapter_type(s=0A=
 	}=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
+static uint8_t=0A=
+arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	int i;=0A=
@@ -326,7 +338,8 @@ static uint8_t arcmsr_hba_wait_msgint_re=0A=
 	return false;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
+static uint8_t=0A=
+arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	int i;=0A=
@@ -346,93 +359,103 @@ static uint8_t arcmsr_hbb_wait_msgint_re=0A=
 	return false;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock =
*pACB)=0A=
+static uint8_t=0A=
+arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
 	int i;=0A=
 =0A=
 	for (i =3D 0; i < 2000; i++) {=0A=
 		if (readl(&phbcmu->outbound_doorbell)=0A=
-				& ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			& ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
 			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
-				&phbcmu->outbound_doorbell_clear); /*clear interrupt*/=0A=
+			&phbcmu->outbound_doorbell_clear);=0A=
 			return true;=0A=
 		}=0A=
 		msleep(10);=0A=
-	} /* max 20 seconds */=0A=
-=0A=
+	}=0A=
 	return false;=0A=
 }=0A=
 =0A=
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	int retry_count =3D 30;=0A=
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
 	do {=0A=
-		if (arcmsr_hba_wait_msgint_ready(acb))=0A=
+		if (arcmsr_hbaA_wait_msgint_ready(acb))=0A=
 			break;=0A=
 		else {=0A=
 			retry_count--;=0A=
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
-			timeout, retry count down =3D %d \n", acb->host->host_no, =
retry_count);=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter "=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
+			acb->host->host_no, retry_count);=0A=
 		}=0A=
 	} while (retry_count !=3D 0);=0A=
 }=0A=
 =0A=
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	int retry_count =3D 30;=0A=
 	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);=0A=
 	do {=0A=
-		if (arcmsr_hbb_wait_msgint_ready(acb))=0A=
+		if (arcmsr_hbaB_wait_msgint_ready(acb))=0A=
 			break;=0A=
 		else {=0A=
 			retry_count--;=0A=
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
-			timeout,retry count down =3D %d \n", acb->host->host_no, =
retry_count);=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter "=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
+			acb->host->host_no, retry_count);=0A=
 		}=0A=
 	} while (retry_count !=3D 0);=0A=
 }=0A=
 =0A=
-static void arcmsr_flush_hbc_cache(struct AdapterControlBlock *pACB)=0A=
+static void=0A=
+arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
 	int retry_count =3D 30;/* enlarge wait flush adapter cache time: 10 =
minute */=0A=
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,=0A=
+		&reg->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&reg->inbound_doorbell);=0A=
 	do {=0A=
-		if (arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
+		if (arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
 			break;=0A=
 		} else {=0A=
 			retry_count--;=0A=
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
-			timeout,retry count down =3D %d \n", pACB->host->host_no, =
retry_count);=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter "=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
+			pACB->host->host_no, retry_count);=0A=
 		}=0A=
 	} while (retry_count !=3D 0);=0A=
 	return;=0A=
 }=0A=
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_flush_hba_cache(acb);=0A=
+		arcmsr_hbaA_flush_cache(acb);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_flush_hbb_cache(acb);=0A=
+		arcmsr_hbaB_flush_cache(acb);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		arcmsr_flush_hbc_cache(acb);=0A=
+		arcmsr_hbaC_flush_cache(acb);=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)=0A=
+static int=0A=
+arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
 	void *dma_coherent;=0A=
@@ -452,154 +475,192 @@ static int arcmsr_alloc_ccb_pool(struct=0A=
 	max_xfer_len =3D ARCMSR_MAX_XFER_LEN;=0A=
 	max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;=0A=
 	firm_config_version =3D acb->firm_cfg_version;=0A=
-	if((firm_config_version & 0xFF) >=3D 3){=0A=
-		max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH << ((firm_config_version =
>> 8) & 0xFF)) * 1024;/* max 4M byte */=0A=
+	if ((firm_config_version & 0xFF) >=3D 3) {=0A=
+		max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH <<=0A=
+			((firm_config_version >> 8) & 0xFF)) * 1024;=0A=
 		max_sg_entrys =3D (max_xfer_len/4096);=0A=
 	}=0A=
 	acb->host->max_sectors =3D max_xfer_len/512;=0A=
 	acb->host->sg_tablesize =3D max_sg_entrys;=0A=
-	roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + =
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
+	roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) +=0A=
+		(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
 	acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;=0A=
-	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size, =
&dma_coherent_handle, GFP_KERNEL);=0A=
-	if(!dma_coherent){=0A=
-		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n", =
acb->host->host_no);=0A=
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size,=0A=
+		&dma_coherent_handle, GFP_KERNEL);=0A=
+	if (!dma_coherent) {=0A=
+		pr_notice("arcmsr%d: dma_alloc_coherent got error\n",=0A=
+			acb->host->host_no);=0A=
 		return -ENOMEM;=0A=
 	}=0A=
 	acb->dma_coherent =3D dma_coherent;=0A=
 	acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
 	memset(dma_coherent, 0, acb->uncache_size);=0A=
 	ccb_tmp =3D dma_coherent;=0A=
-	acb->vir2phy_offset =3D (unsigned long)dma_coherent - (unsigned =
long)dma_coherent_handle;=0A=
-	for(i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++){=0A=
-		cdb_phyaddr =3D dma_coherent_handle + offsetof(struct =
CommandControlBlock, arcmsr_cdb);=0A=
-		ccb_tmp->cdb_phyaddr_pattern =3D ((acb->adapter_type =3D=3D =
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));=0A=
+	acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
+		(unsigned long)dma_coherent_handle;=0A=
+	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
+		cdb_phyaddr =3D dma_coherent_handle +=0A=
+			offsetof(struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
+		ccb_tmp->cdb_phyaddr_pattern =3D=0A=
+			((acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_C)=0A=
+			? cdb_phyaddr : (cdb_phyaddr >> 5));=0A=
 		acb->pccb_pool[i] =3D ccb_tmp;=0A=
 		ccb_tmp->acb =3D acb;=0A=
 		INIT_LIST_HEAD(&ccb_tmp->list);=0A=
 		list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);=0A=
-		ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp + =
roundup_ccbsize);=0A=
+		ccb_tmp =3D (struct CommandControlBlock *)=0A=
+			((unsigned long)ccb_tmp + roundup_ccbsize);=0A=
 		dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;=0A=
 	}=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void arcmsr_message_isr_bh_fn(struct work_struct *work) =0A=
+static void=0A=
+arcmsr_message_isr_bh_fn(struct work_struct *work)=0A=
 {=0A=
-	struct AdapterControlBlock *acb =3D container_of(work,struct =
AdapterControlBlock, arcmsr_do_message_isr_bh);=0A=
+	struct AdapterControlBlock *acb =3D container_of(work,=0A=
+		struct AdapterControlBlock, arcmsr_do_message_isr_bh);=0A=
 	switch (acb->adapter_type) {=0A=
-		case ACB_ADAPTER_TYPE_A: {=0A=
-=0A=
-			struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
-			char *acb_dev_map =3D (char *)acb->device_map;=0A=
-			uint32_t __iomem *signature =3D (uint32_t __iomem*) =
(&reg->message_rwbuffer[0]);=0A=
-			char __iomem *devicemap =3D (char __iomem*) =
(&reg->message_rwbuffer[21]);=0A=
-			int target, lun;=0A=
-			struct scsi_device *psdev;=0A=
-			char diff;=0A=
-=0A=
-			atomic_inc(&acb->rq_map_token);=0A=
-			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
-				for(target =3D 0; target < ARCMSR_MAX_TARGETID -1; target++) {=0A=
-					diff =3D (*acb_dev_map)^readb(devicemap);=0A=
-					if (diff !=3D 0) {=0A=
-						char temp;=0A=
-						*acb_dev_map =3D readb(devicemap);=0A=
-						temp =3D*acb_dev_map;=0A=
-						for(lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {=0A=
-							if((temp & 0x01)=3D=3D1 && (diff & 0x01) =3D=3D 1) {	=0A=
-								scsi_add_device(acb->host, 0, target, lun);=0A=
-							}else if((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {=0A=
-								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);=0A=
-								if (psdev !=3D NULL ) {=0A=
-									scsi_remove_device(psdev);=0A=
-									scsi_device_put(psdev);=0A=
-								}=0A=
-							}=0A=
-							temp >>=3D 1;=0A=
-							diff >>=3D 1;=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
+		struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
+		char *acb_dev_map =3D (char *)acb->device_map;=0A=
+		uint32_t __iomem *signature =3D (uint32_t __iomem *)=0A=
+			(&reg->message_rwbuffer[0]);=0A=
+		char __iomem *devicemap =3D (char __iomem *)=0A=
+			(&reg->message_rwbuffer[21]);=0A=
+		int target, lun;=0A=
+		struct scsi_device *psdev;=0A=
+		char diff;=0A=
+=0A=
+		atomic_inc(&acb->rq_map_token);=0A=
+		if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+			for (target =3D 0; target < ARCMSR_MAX_TARGETID - 1;=0A=
+			target++) {=0A=
+				diff =3D (*acb_dev_map) ^ readb(devicemap);=0A=
+				if (diff !=3D 0) {=0A=
+					char temp;=0A=
+					*acb_dev_map =3D readb(devicemap);=0A=
+					temp =3D *acb_dev_map;=0A=
+					for (lun =3D 0; lun <=0A=
+					ARCMSR_MAX_TARGETLUN; lun++) {=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
+						(diff & 0x01) =3D=3D 1) {=0A=
+							scsi_add_device(acb->host,=0A=
+							0, target, lun);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D=0A=
+							scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+						if (psdev !=3D NULL) {=0A=
+							scsi_remove_device(psdev);=0A=
+							scsi_device_put(psdev);=0A=
 						}=0A=
+						}=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
-					devicemap++;=0A=
-					acb_dev_map++;=0A=
 				}=0A=
+				devicemap++;=0A=
+				acb_dev_map++;=0A=
 			}=0A=
-			break;=0A=
 		}=0A=
+		break;=0A=
+	}=0A=
 =0A=
-		case ACB_ADAPTER_TYPE_B: {=0A=
-			struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
-			char *acb_dev_map =3D (char *)acb->device_map;=0A=
-			uint32_t __iomem *signature =3D (uint32_t =
__iomem*)(&reg->message_rwbuffer[0]);=0A=
-			char __iomem *devicemap =3D (char =
__iomem*)(&reg->message_rwbuffer[21]);=0A=
-			int target, lun;=0A=
-			struct scsi_device *psdev;=0A=
-			char diff;=0A=
-=0A=
-			atomic_inc(&acb->rq_map_token);=0A=
-			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
-				for(target =3D 0; target < ARCMSR_MAX_TARGETID -1; target++) {=0A=
-					diff =3D (*acb_dev_map)^readb(devicemap);=0A=
-					if (diff !=3D 0) {=0A=
-						char temp;=0A=
-						*acb_dev_map =3D readb(devicemap);=0A=
-						temp =3D*acb_dev_map;=0A=
-						for(lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {=0A=
-							if((temp & 0x01)=3D=3D1 && (diff & 0x01) =3D=3D 1) {	=0A=
-								scsi_add_device(acb->host, 0, target, lun);=0A=
-							}else if((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {=0A=
-								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);=0A=
-								if (psdev !=3D NULL ) {=0A=
-									scsi_remove_device(psdev);=0A=
-									scsi_device_put(psdev);=0A=
-								}=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
+		char *acb_dev_map =3D (char *)acb->device_map;=0A=
+		uint32_t __iomem *signature =3D=0A=
+			(uint32_t __iomem *)(&reg->message_rwbuffer[0]);=0A=
+		char __iomem *devicemap =3D=0A=
+			(char __iomem *)(&reg->message_rwbuffer[21]);=0A=
+		int target, lun;=0A=
+		struct scsi_device *psdev;=0A=
+		char diff;=0A=
+=0A=
+		atomic_inc(&acb->rq_map_token);=0A=
+		if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+			for (target =3D 0; target <=0A=
+			ARCMSR_MAX_TARGETID - 1; target++) {=0A=
+				diff =3D (*acb_dev_map) ^ readb(devicemap);=0A=
+				if (diff !=3D 0) {=0A=
+					char temp;=0A=
+					*acb_dev_map =3D readb(devicemap);=0A=
+					temp =3D *acb_dev_map;=0A=
+					for (lun =3D 0;=0A=
+					lun < ARCMSR_MAX_TARGETLUN;=0A=
+					lun++) {=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
+							(diff & 0x01) =3D=3D 1) {=0A=
+							scsi_add_device(acb->host,=0A=
+							0, target, lun);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
 							}=0A=
-							temp >>=3D 1;=0A=
-							diff >>=3D 1;=0A=
 						}=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
-					devicemap++;=0A=
-					acb_dev_map++;=0A=
 				}=0A=
+				devicemap++;=0A=
+				acb_dev_map++;=0A=
 			}=0A=
 		}=0A=
-		break;=0A=
-		case ACB_ADAPTER_TYPE_C: {=0A=
-			struct MessageUnit_C *reg  =3D acb->pmuC;=0A=
-			char *acb_dev_map =3D (char *)acb->device_map;=0A=
-			uint32_t __iomem *signature =3D (uint32_t __iomem =
*)(&reg->msgcode_rwbuffer[0]);=0A=
-			char __iomem *devicemap =3D (char __iomem =
*)(&reg->msgcode_rwbuffer[21]);=0A=
-			int target, lun;=0A=
-			struct scsi_device *psdev;=0A=
-			char diff;=0A=
-=0A=
-			atomic_inc(&acb->rq_map_token);=0A=
-			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
-				for (target =3D 0; target < ARCMSR_MAX_TARGETID - 1; target++) {=0A=
-					diff =3D (*acb_dev_map)^readb(devicemap);=0A=
-					if (diff !=3D 0) {=0A=
-						char temp;=0A=
-						*acb_dev_map =3D readb(devicemap);=0A=
-						temp =3D *acb_dev_map;=0A=
-						for (lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {=0A=
-							if ((temp & 0x01) =3D=3D 1 && (diff & 0x01) =3D=3D 1) {=0A=
-								scsi_add_device(acb->host, 0, target, lun);=0A=
-							} else if ((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {=0A=
-								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);=0A=
-								if (psdev !=3D NULL) {=0A=
-									scsi_remove_device(psdev);=0A=
-									scsi_device_put(psdev);=0A=
-								}=0A=
+	}=0A=
+	break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *reg  =3D acb->pmuC;=0A=
+		char *acb_dev_map =3D (char *)acb->device_map;=0A=
+		uint32_t __iomem *signature =3D=0A=
+			(uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);=0A=
+		char __iomem *devicemap =3D=0A=
+			(char __iomem *)(&reg->msgcode_rwbuffer[21]);=0A=
+		int target, lun;=0A=
+		struct scsi_device *psdev;=0A=
+		char diff;=0A=
+=0A=
+		atomic_inc(&acb->rq_map_token);=0A=
+		if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+			for (target =3D 0; target <=0A=
+				ARCMSR_MAX_TARGETID - 1; target++) {=0A=
+				diff =3D (*acb_dev_map) ^ readb(devicemap);=0A=
+				if (diff !=3D 0) {=0A=
+					char temp;=0A=
+					*acb_dev_map =3D=0A=
+						readb(devicemap);=0A=
+					temp =3D *acb_dev_map;=0A=
+					for (lun =3D 0; lun <=0A=
+					ARCMSR_MAX_TARGETLUN; lun++) {=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
+							(diff & 0x01) =3D=3D 1) {=0A=
+							scsi_add_device(acb->host,=0A=
+							0, target, lun);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
 							}=0A=
-							temp >>=3D 1;=0A=
-							diff >>=3D 1;=0A=
 						}=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
-					devicemap++;=0A=
-					acb_dev_map++;=0A=
 				}=0A=
+				devicemap++;=0A=
+				acb_dev_map++;=0A=
 			}=0A=
 		}=0A=
 	}=0A=
+	}=0A=
 }=0A=
 =0A=
 static int arcmsr_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)=0A=
@@ -609,17 +670,16 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	uint8_t bus,dev_fun;=0A=
 	int error;=0A=
 	error =3D pci_enable_device(pdev);=0A=
-	if(error){=0A=
+	if (error)=0A=
 		return -ENODEV;=0A=
-	}=0A=
-	host =3D scsi_host_alloc(&arcmsr_scsi_host_template, sizeof(struct =
AdapterControlBlock));=0A=
-	if(!host){=0A=
+	host =3D scsi_host_alloc(&arcmsr_scsi_host_template,=0A=
+		sizeof(struct AdapterControlBlock));=0A=
+	if (!host)=0A=
     		goto pci_disable_dev;=0A=
-	}=0A=
 	error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));=0A=
-	if(error){=0A=
+	if (error) {=0A=
 		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
-		if(error){=0A=
+		if (error) {=0A=
 			printk(KERN_WARNING=0A=
 			       "scsi%d: No suitable DMA mask available\n",=0A=
 			       host->host_no);=0A=
@@ -634,18 +694,17 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	acb->pdev =3D pdev;=0A=
 	acb->host =3D host;=0A=
 	host->max_lun =3D ARCMSR_MAX_TARGETLUN;=0A=
-	host->max_id =3D ARCMSR_MAX_TARGETID;		/*16:8*/=0A=
-	host->max_cmd_len =3D 16;	 			/*this is issue of 64bit LBA ,over 2T =
byte*/=0A=
-	host->can_queue =3D ARCMSR_MAX_FREECCB_NUM;	/* max simultaneous cmds =
*/		=0A=
-	host->cmd_per_lun =3D ARCMSR_MAX_CMD_PERLUN;	    =0A=
+	host->max_id =3D ARCMSR_MAX_TARGETID;=0A=
+	host->max_cmd_len =3D 16;=0A=
+	host->can_queue =3D ARCMSR_MAX_FREECCB_NUM;=0A=
+	host->cmd_per_lun =3D ARCMSR_MAX_CMD_PERLUN;=0A=
 	host->this_id =3D ARCMSR_SCSI_INITIATOR_ID;=0A=
 	host->unique_id =3D (bus << 8) | dev_fun;=0A=
 	pci_set_drvdata(pdev, host);=0A=
 	pci_set_master(pdev);=0A=
 	error =3D pci_request_regions(pdev, "arcmsr");=0A=
-	if(error){=0A=
+	if (error)=0A=
 		goto scsi_host_release;=0A=
-	}=0A=
 	spin_lock_init(&acb->eh_lock);=0A=
 	spin_lock_init(&acb->ccblist_lock);=0A=
 	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
@@ -655,38 +714,37 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	INIT_LIST_HEAD(&acb->ccb_free_list);=0A=
 	arcmsr_define_adapter_type(acb);=0A=
 	error =3D arcmsr_remap_pciregion(acb);=0A=
-	if(!error){=0A=
+	if (!error)=0A=
 		goto pci_release_regs;=0A=
-	}=0A=
 	error =3D arcmsr_get_firmware_spec(acb);=0A=
-	if(!error){=0A=
+	if (!error)=0A=
 		goto unmap_pci_region;=0A=
-	}=0A=
 	error =3D arcmsr_alloc_ccb_pool(acb);=0A=
-	if(error){=0A=
+	if (error)=0A=
 		goto free_hbb_mu;=0A=
-	}=0A=
 	arcmsr_iop_init(acb);=0A=
 	error =3D scsi_add_host(host, &pdev->dev);=0A=
-	if(error){=0A=
+	if (error)=0A=
 		goto RAID_controller_stop;=0A=
-	}=0A=
-	error =3D request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED, =
"arcmsr", acb);=0A=
-	if(error){=0A=
+	error =3D request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+		IRQF_SHARED, "arcmsr", acb);=0A=
+	if (error)=0A=
 		goto scsi_host_remove;=0A=
-	}=0A=
 	host->irq =3D pdev->irq;=0A=
     	scsi_scan_host(host);=0A=
-	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);=0A=
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
+		arcmsr_message_isr_bh_fn);=0A=
 	atomic_set(&acb->rq_map_token, 16);=0A=
 	atomic_set(&acb->ante_token_value, 16);=0A=
 	acb->fw_flag =3D FW_NORMAL;=0A=
 	init_timer(&acb->eternal_timer);=0A=
-	acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6 * HZ);=0A=
+	acb->eternal_timer.expires =3D jiffies +=0A=
+		msecs_to_jiffies(6 * HZ);=0A=
 	acb->eternal_timer.data =3D (unsigned long) acb;=0A=
-	acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
+	acb->eternal_timer.function =3D=0A=
+		&arcmsr_request_device_map;=0A=
 	add_timer(&acb->eternal_timer);=0A=
-	if(arcmsr_alloc_sysfs_attr(acb))=0A=
+	if (arcmsr_alloc_sysfs_attr(acb))=0A=
 		goto out_free_sysfs;=0A=
 	return 0;=0A=
 out_free_sysfs:=0A=
@@ -709,85 +767,95 @@ pci_disable_dev:=0A=
 	return -ENODEV;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t=0A=
+arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);=0A=
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
-			, acb->host->host_no);=0A=
+	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD,=0A=
+		&reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding "=0A=
+			"command' timeout\n"=0A=
+		, acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t=0A=
+arcmsr_hbaB_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 =0A=
-	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);=0A=
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
-			, acb->host->host_no);=0A=
+	writel(ARCMSR_MESSAGE_ABORT_CMD,=0A=
+		reg->drv2iop_doorbell);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding "=0A=
+			"command' timeout\n"=0A=
+		, acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
-static uint8_t arcmsr_abort_hbc_allcmd(struct AdapterControlBlock *pACB)=0A=
+static uint8_t=0A=
+arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);=0A=
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
-			, pACB->host->host_no);=0A=
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding "=0A=
+			"command' timeout\n"=0A=
+		, pACB->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
-static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t=0A=
+arcmsr_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint8_t rtnval =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		rtnval =3D arcmsr_abort_hba_allcmd(acb);=0A=
+		rtnval =3D arcmsr_hbaA_abort_allcmd(acb);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		rtnval =3D arcmsr_abort_hbb_allcmd(acb);=0A=
+		rtnval =3D arcmsr_hbaB_abort_allcmd(acb);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		rtnval =3D arcmsr_abort_hbc_allcmd(acb);=0A=
+		rtnval =3D arcmsr_hbaC_abort_allcmd(acb);=0A=
 		}=0A=
 	}=0A=
 	return rtnval;=0A=
 }=0A=
 =0A=
-static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock =
*pacb)=0A=
+static bool=0A=
+arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D pacb->pmuB;=0A=
-	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);=0A=
-	if (!arcmsr_hbb_wait_msgint_ready(pacb)) {=0A=
-		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", =
pacb->host->host_no);=0A=
+	writel(ARCMSR_MESSAGE_START_DRIVER_MODE,=0A=
+		reg->drv2iop_doorbell);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(pacb)) {=0A=
+		pr_err("arcmsr%d: can't set driver mode.\n",=0A=
+			pacb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
     	return true;=0A=
 }=0A=
 =0A=
-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)=0A=
+static void=0A=
+arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)=0A=
 {=0A=
 	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
-=0A=
 	scsi_dma_unmap(pcmd);=0A=
 }=0A=
 =0A=
-static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)=0A=
+static void=0A=
+arcmsr_ccb_complete(struct CommandControlBlock *ccb)=0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D ccb->acb;=0A=
 	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
@@ -801,32 +869,37 @@ static void arcmsr_ccb_complete(struct C=0A=
 	pcmd->scsi_done(pcmd);=0A=
 }=0A=
 =0A=
-static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)=0A=
+static void=0A=
+arcmsr_report_sense_info(struct CommandControlBlock *ccb)=0A=
 {=0A=
 =0A=
 	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
-	struct SENSE_DATA *sensebuffer =3D (struct SENSE_DATA =
*)pcmd->sense_buffer;=0A=
+	struct SENSE_DATA *sensebuffer =3D=0A=
+		(struct SENSE_DATA *)pcmd->sense_buffer;=0A=
 	pcmd->result =3D DID_OK << 16;=0A=
 	if (sensebuffer) {=0A=
 		int sense_data_length =3D=0A=
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE=0A=
 			? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;=0A=
 		memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);=0A=
-		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);=0A=
+		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData,=0A=
+			sense_data_length);=0A=
 		sensebuffer->ErrorCode =3D SCSI_SENSE_CURRENT_ERRORS;=0A=
 		sensebuffer->Valid =3D 1;=0A=
 	}=0A=
 }=0A=
 =0A=
-static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)=0A=
+static u32=0A=
+arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	u32 orig_mask =3D 0;=0A=
 	switch (acb->adapter_type) {	=0A=
 	case ACB_ADAPTER_TYPE_A : {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 		orig_mask =3D readl(&reg->outbound_intmask);=0A=
-		writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \=0A=
-						&reg->outbound_intmask);=0A=
+		writel(orig_mask |=0A=
+			ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,=0A=
+			&reg->outbound_intmask);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_B : {=0A=
@@ -835,18 +908,21 @@ static u32 arcmsr_disable_outbound_ints(=0A=
 		writel(0, reg->iop2drv_doorbell_mask);=0A=
 		}=0A=
 		break;=0A=
-	case ACB_ADAPTER_TYPE_C:{=0A=
-		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C *reg =3D=0A=
+			(struct MessageUnit_C *)acb->pmuC;=0A=
 		/* disable all outbound interrupt */=0A=
-		orig_mask =3D readl(&reg->host_int_mask); /* disable outbound =
message0 int */=0A=
-		writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);=0A=
+		orig_mask =3D readl(&reg->host_int_mask);=0A=
+		writel(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,=0A=
+			&reg->host_int_mask);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
 	return orig_mask;=0A=
 }=0A=
 =0A=
-static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb, =0A=
+static void=0A=
+arcmsr_report_ccb_state(struct AdapterControlBlock *acb,=0A=
 			struct CommandControlBlock *ccb, bool error)=0A=
 {=0A=
 	uint8_t id, lun;=0A=
@@ -857,7 +933,7 @@ static void arcmsr_report_ccb_state(stru=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GOOD;=0A=
 		ccb->pcmd->result =3D DID_OK << 16;=0A=
 		arcmsr_ccb_complete(ccb);=0A=
-	}else{=0A=
+	} else {=0A=
 		switch (ccb->arcmsr_cdb.DeviceStatus) {=0A=
 		case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
@@ -883,22 +959,24 @@ static void arcmsr_report_ccb_state(stru=0A=
 			break;=0A=
 =0A=
 		default:=0A=
-			printk(KERN_NOTICE=0A=
-				"arcmsr%d: scsi id =3D %d lun =3D %d isr get command error done, \=0A=
-				but got unknown DeviceStatus =3D 0x%x \n"=0A=
-				, acb->host->host_no=0A=
-				, id=0A=
-				, lun=0A=
-				, ccb->arcmsr_cdb.DeviceStatus);=0A=
-				acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
-				ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
-				arcmsr_ccb_complete(ccb);=0A=
+			pr_notice("arcmsr%d: scsi id =3D %d lun =3D %d "=0A=
+			"isr get command error done, but got unknown "=0A=
+			"DeviceStatus =3D 0x%x\n"=0A=
+			, acb->host->host_no=0A=
+			, id=0A=
+			, lun=0A=
+			, ccb->arcmsr_cdb.DeviceStatus);=0A=
+			acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
+			ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
+			arcmsr_ccb_complete(ccb);=0A=
 			break;=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, =
struct CommandControlBlock *pCCB, bool error)=0A=
+static void=0A=
+arcmsr_drain_donequeue(struct AdapterControlBlock *acb,=0A=
+struct CommandControlBlock *pCCB, bool error)=0A=
 {=0A=
 	int id, lun;=0A=
 	if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
@@ -906,30 +984,32 @@ static void arcmsr_drain_donequeue(struc=0A=
 			struct scsi_cmnd *abortcmd =3D pCCB->pcmd;=0A=
 			if (abortcmd) {=0A=
 				id =3D abortcmd->device->id;=0A=
-				lun =3D abortcmd->device->lun;				=0A=
+				lun =3D abortcmd->device->lun;=0A=
 				abortcmd->result |=3D DID_ABORT << 16;=0A=
 				arcmsr_ccb_complete(pCCB);=0A=
-				printk(KERN_NOTICE "arcmsr%d: pCCB =3D'0x%p' isr got aborted =
command \n",=0A=
+				pr_notice("arcmsr%d: pCCB =3D'0x%p' isr "=0A=
+				"got aborted command\n",=0A=
 				acb->host->host_no, pCCB);=0A=
 			}=0A=
 			return;=0A=
 		}=0A=
-		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \=0A=
-				done acb =3D '0x%p'"=0A=
-				"ccb =3D '0x%p' ccbacb =3D '0x%p' startdone =3D 0x%x"=0A=
-				" ccboutstandingcount =3D %d \n"=0A=
-				, acb->host->host_no=0A=
-				, acb=0A=
-				, pCCB=0A=
-				, pCCB->acb=0A=
-				, pCCB->startdone=0A=
-				, atomic_read(&acb->ccboutstandingcount));=0A=
+		pr_notice("arcmsr%d: isr get an illegal ccb command "=0A=
+			"done acb =3D '0x%p' "=0A=
+			"ccb =3D '0x%p' ccbacb =3D '0x%p' startdone =3D 0x%x "=0A=
+			" ccboutstandingcount =3D %d\n"=0A=
+			, acb->host->host_no=0A=
+			, acb=0A=
+			, pCCB=0A=
+			, pCCB->acb=0A=
+			, pCCB->startdone=0A=
+			, atomic_read(&acb->ccboutstandingcount));=0A=
 		  return;=0A=
 	}=0A=
 	arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 }=0A=
 =0A=
-static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	int i =3D 0;=0A=
 	uint32_t flag_ccb;=0A=
@@ -943,13 +1023,16 @@ static void arcmsr_done4abort_postqueue(=0A=
 		uint32_t outbound_intstatus;=0A=
 		outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
 					acb->outbound_int_enable;=0A=
-		/*clear and abort all outbound posted Q*/=0A=
-		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear =
interrupt*/=0A=
-		while(((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D 0xFFFFFFFF)=0A=
-				&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
-			pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
(flag_ccb << 5));/*frame must be 32 bytes aligned*/=0A=
-			pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		while (((flag_ccb =3D readl(&reg->outbound_queueport))=0A=
+			!=3D 0xFFFFFFFF)=0A=
+			&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
+			pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
+				(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+			pCCB =3D container_of(pARCMSR_CDB,=0A=
+			struct CommandControlBlock, arcmsr_cdb);=0A=
+			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?=0A=
+				true : false;=0A=
 			arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 		}=0A=
 		}=0A=
@@ -957,14 +1040,18 @@ static void arcmsr_done4abort_postqueue(=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		/*clear all outbound posted Q*/=0A=
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /* =
clear doorbell interrupt */=0A=
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,=0A=
+			reg->iop2drv_doorbell);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {=0A=
 			if ((flag_ccb =3D readl(&reg->done_qbuffer[i])) !=3D 0) {=0A=
 				writel(0, &reg->done_qbuffer[i]);=0A=
-				pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
-				pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-				error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+				pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
+				(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+				pCCB =3D container_of(pARCMSR_CDB,=0A=
+				struct CommandControlBlock, arcmsr_cdb);=0A=
+				error =3D (flag_ccb &=0A=
+				ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?=0A=
+				true : false;=0A=
 				arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 			}=0A=
 			reg->post_qbuffer[i] =3D 0;=0A=
@@ -979,27 +1066,34 @@ static void arcmsr_done4abort_postqueue(=0A=
 		uint32_t flag_ccb, ccb_cdb_phy;=0A=
 		bool error;=0A=
 		struct CommandControlBlock *pCCB;=0A=
-		while ((readl(&reg->host_int_status) & =
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < =
ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
+		while ((readl(&reg->host_int_status) &=0A=
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)=0A=
+			&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
 			/*need to do*/=0A=
 			flag_ccb =3D readl(&reg->outbound_queueport_low);=0A=
 			ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
-			pARCMSR_CDB =3D (struct  ARCMSR_CDB =
*)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/=0A=
-			pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : =
false;=0A=
+			pARCMSR_CDB =3D (struct  ARCMSR_CDB *)=0A=
+				(acb->vir2phy_offset+ccb_cdb_phy);=0A=
+			pCCB =3D container_of(pARCMSR_CDB,=0A=
+				struct CommandControlBlock, arcmsr_cdb);=0A=
+			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+				? true : false;=0A=
 			arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 		}=0A=
 	}=0A=
 	}=0A=
 }=0A=
-static void arcmsr_remove(struct pci_dev *pdev)=0A=
+=0A=
+static void=0A=
+arcmsr_remove(struct pci_dev *pdev)=0A=
 {=0A=
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	int poll_count =3D 0;=0A=
 	arcmsr_free_sysfs_attr(acb);=0A=
 	scsi_remove_host(host);=0A=
-	flush_work(&acb->arcmsr_do_message_isr_bh);=0A=
+	flush_work_sync(&acb->arcmsr_do_message_isr_bh);=0A=
 	del_timer_sync(&acb->eternal_timer);=0A=
 	arcmsr_disable_outbound_ints(acb);=0A=
 	arcmsr_stop_adapter_bgrb(acb);=0A=
@@ -1007,20 +1101,21 @@ static void arcmsr_remove(struct pci_dev=0A=
 	acb->acb_flags |=3D ACB_F_SCSISTOPADAPTER;=0A=
 	acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
 =0A=
-	for (poll_count =3D 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD; =
poll_count++){=0A=
+	for (poll_count =3D 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;=0A=
+	poll_count++) {=0A=
 		if (!atomic_read(&acb->ccboutstandingcount))=0A=
 			break;=0A=
-		arcmsr_interrupt(acb);/* FIXME: need spinlock */=0A=
+		arcmsr_interrupt(acb);=0A=
 		msleep(25);=0A=
 	}=0A=
 =0A=
 	if (atomic_read(&acb->ccboutstandingcount)) {=0A=
 		int i;=0A=
-=0A=
 		arcmsr_abort_allcmd(acb);=0A=
 		arcmsr_done4abort_postqueue(acb);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
-			struct CommandControlBlock *ccb =3D acb->pccb_pool[i];=0A=
+			struct CommandControlBlock *ccb =3D=0A=
+				acb->pccb_pool[i];=0A=
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
 				ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
 				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
@@ -1038,14 +1133,15 @@ static void arcmsr_remove(struct pci_dev=0A=
 	pci_set_drvdata(pdev, NULL);=0A=
 }=0A=
 =0A=
-static void arcmsr_shutdown(struct pci_dev *pdev)=0A=
+static void=0A=
+arcmsr_shutdown(struct pci_dev *pdev)=0A=
 {=0A=
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)host->hostdata;=0A=
 	del_timer_sync(&acb->eternal_timer);=0A=
 	arcmsr_disable_outbound_ints(acb);=0A=
-	flush_work(&acb->arcmsr_do_message_isr_bh);=0A=
+	flush_work_sync(&acb->arcmsr_do_message_isr_bh);=0A=
 	arcmsr_stop_adapter_bgrb(acb);=0A=
 	arcmsr_flush_adapter_cache(acb);=0A=
 }=0A=
@@ -1064,7 +1160,8 @@ static void arcmsr_module_exit(void)=0A=
 module_init(arcmsr_module_init);=0A=
 module_exit(arcmsr_module_exit);=0A=
 =0A=
-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,=0A=
+static void=0A=
+arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,=0A=
 						u32 intmask_org)=0A=
 {=0A=
 	u32 mask;=0A=
@@ -1072,11 +1169,13 @@ static void arcmsr_enable_outbound_ints(=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-		mask =3D intmask_org & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |=0A=
-			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE|=0A=
-			     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);=0A=
+		mask =3D intmask_org &=0A=
+		~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |=0A=
+		     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE |=0A=
+		     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);=0A=
 		writel(mask, &reg->outbound_intmask);=0A=
-		acb->outbound_int_enable =3D ~(intmask_org & mask) & 0x000000ff;=0A=
+		acb->outbound_int_enable =3D ~(intmask_org & mask) &=0A=
+			0x000000ff;=0A=
 		}=0A=
 		break;=0A=
 =0A=
@@ -1087,22 +1186,28 @@ static void arcmsr_enable_outbound_ints(=0A=
 			ARCMSR_IOP2DRV_CDB_DONE |=0A=
 			ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);=0A=
 		writel(mask, reg->iop2drv_doorbell_mask);=0A=
-		acb->outbound_int_enable =3D (intmask_org | mask) & 0x0000000f;=0A=
+		acb->outbound_int_enable =3D (intmask_org | mask) &=0A=
+			0x0000000f;=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C *reg =3D acb->pmuC;=0A=
-		mask =3D ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK | =
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_I=
SR_MASK);=0A=
+		mask =3D ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |=0A=
+			ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK |=0A=
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);=0A=
 		writel(intmask_org & mask, &reg->host_int_mask);=0A=
-		acb->outbound_int_enable =3D ~(intmask_org & mask) & 0x0000000f;=0A=
+		acb->outbound_int_enable =3D ~(intmask_org & mask) &=0A=
+			0x0000000f;=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_build_ccb(struct AdapterControlBlock *acb,=0A=
+static int=0A=
+arcmsr_build_ccb(struct AdapterControlBlock *acb,=0A=
 	struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)=0A=
 {=0A=
-	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb =3D=0A=
+		(struct ARCMSR_CDB *)&ccb->arcmsr_cdb;=0A=
 	int8_t *psge =3D (int8_t *)&arcmsr_cdb->u;=0A=
 	__le32 address_lo, address_hi;=0A=
 	int arccdbsize =3D 0x30;=0A=
@@ -1127,25 +1232,27 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 		address_lo =3D cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));=0A=
 		address_hi =3D cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));=0A=
 		if (address_hi =3D=3D 0) {=0A=
-			struct SG32ENTRY *pdma_sg =3D (struct SG32ENTRY *)psge;=0A=
-=0A=
+			struct SG32ENTRY *pdma_sg =3D=0A=
+				(struct SG32ENTRY *)psge;=0A=
 			pdma_sg->address =3D address_lo;=0A=
 			pdma_sg->length =3D length;=0A=
 			psge +=3D sizeof (struct SG32ENTRY);=0A=
 			arccdbsize +=3D sizeof (struct SG32ENTRY);=0A=
 		} else {=0A=
-			struct SG64ENTRY *pdma_sg =3D (struct SG64ENTRY *)psge;=0A=
-=0A=
+			struct SG64ENTRY *pdma_sg =3D=0A=
+			(struct SG64ENTRY *)psge;=0A=
 			pdma_sg->addresshigh =3D address_hi;=0A=
 			pdma_sg->address =3D address_lo;=0A=
-			pdma_sg->length =3D length|cpu_to_le32(IS_SG64_ADDR);=0A=
+			pdma_sg->length =3D length |=0A=
+				cpu_to_le32(IS_SG64_ADDR);=0A=
 			psge +=3D sizeof (struct SG64ENTRY);=0A=
 			arccdbsize +=3D sizeof (struct SG64ENTRY);=0A=
 		}=0A=
 	}=0A=
 	arcmsr_cdb->sgcount =3D (uint8_t)nseg;=0A=
 	arcmsr_cdb->DataLength =3D scsi_bufflen(pcmd);=0A=
-	arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : =
0);=0A=
+	arcmsr_cdb->msgPages =3D arccdbsize / 0x100 +=0A=
+		(arccdbsize % 0x100 ? 1 : 0);=0A=
 	if ( arccdbsize > 256)=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;=0A=
 	if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE)=0A=
@@ -1154,10 +1261,13 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 	return SUCCESS;=0A=
 }=0A=
 =0A=
-static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct =
CommandControlBlock *ccb)=0A=
+static void=0A=
+arcmsr_post_ccb(struct AdapterControlBlock *acb,=0A=
+	struct CommandControlBlock *ccb)=0A=
 {=0A=
 	uint32_t cdb_phyaddr_pattern =3D ccb->cdb_phyaddr_pattern;=0A=
-	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb =3D=0A=
+		(struct ARCMSR_CDB *)&ccb->arcmsr_cdb;=0A=
 	atomic_inc(&acb->ccboutstandingcount);=0A=
 	ccb->startdone =3D ARCMSR_CCB_START;=0A=
 	switch (acb->adapter_type) {=0A=
@@ -1165,10 +1275,12 @@ static void arcmsr_post_ccb(struct Adapt=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 =0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)=0A=
-			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
+			writel(cdb_phyaddr_pattern |=0A=
+			ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
 			&reg->inbound_queueport);=0A=
 		else {=0A=
-				writel(cdb_phyaddr_pattern, &reg->inbound_queueport);=0A=
+				writel(cdb_phyaddr_pattern,=0A=
+				&reg->inbound_queueport);=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
@@ -1177,31 +1289,41 @@ static void arcmsr_post_ccb(struct Adapt=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		uint32_t ending_index, index =3D reg->postq_index;=0A=
 =0A=
-		ending_index =3D ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);=0A=
+		ending_index =3D ((index + 1) %=0A=
+			ARCMSR_MAX_HBB_POSTQUEUE);=0A=
 		writel(0, &reg->post_qbuffer[ending_index]);=0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {=0A=
-			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\=0A=
-						 &reg->post_qbuffer[index]);=0A=
+			writel(cdb_phyaddr_pattern |=0A=
+			ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
+			 &reg->post_qbuffer[index]);=0A=
 		} else {=0A=
-			writel(cdb_phyaddr_pattern, &reg->post_qbuffer[index]);=0A=
+			writel(cdb_phyaddr_pattern,=0A=
+				&reg->post_qbuffer[index]);=0A=
 		}=0A=
 		index++;=0A=
-		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to =
0 */=0A=
+		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;=0A=
 		reg->postq_index =3D index;=0A=
-		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_CDB_POSTED,=0A=
+			reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		struct MessageUnit_C *phbcmu =3D=0A=
+			(struct MessageUnit_C *)acb->pmuC;=0A=
 		uint32_t ccb_post_stamp, arc_cdb_size;=0A=
 =0A=
-		arc_cdb_size =3D (ccb->arc_cdb_size > 0x300) ? 0x300 : =
ccb->arc_cdb_size;=0A=
-		ccb_post_stamp =3D (cdb_phyaddr_pattern | ((arc_cdb_size - 1) >> 6) | =
1);=0A=
+		arc_cdb_size =3D (ccb->arc_cdb_size > 0x300)=0A=
+			? 0x300 : ccb->arc_cdb_size;=0A=
+		ccb_post_stamp =3D (cdb_phyaddr_pattern |=0A=
+			((arc_cdb_size - 1) >> 6) | 1);=0A=
 		if (acb->cdb_phyaddr_hi32) {=0A=
-			writel(acb->cdb_phyaddr_hi32, &phbcmu->inbound_queueport_high);=0A=
-			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);=0A=
+			writel(acb->cdb_phyaddr_hi32,=0A=
+			&phbcmu->inbound_queueport_high);=0A=
+			writel(ccb_post_stamp,=0A=
+			&phbcmu->inbound_queueport_low);=0A=
 		} else {=0A=
-			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);=0A=
+			writel(ccb_post_stamp,=0A=
+			&phbcmu->inbound_queueport_low);=0A=
 		}=0A=
 		}=0A=
 	}=0A=
@@ -1212,40 +1334,45 @@ static void arcmsr_stop_hba_bgrb(struct=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);=0A=
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
-			, acb->host->host_no);=0A=
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter background "=0A=
+		"rebulid' timeout\n"=0A=
+		, acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);=0A=
 =0A=
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
-			, acb->host->host_no);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+		pr_notice(=0A=
+		"arcmsr%d: wait 'stop adapter background "=0A=
+		"rebulid' timeout\n"=0A=
+		, acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)=0A=
+static void=0A=
+arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
 	pACB->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
-			, pACB->host->host_no);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&reg->inbound_doorbell);=0A=
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter background "=0A=
+		"rebulid' timeout\n"=0A=
+		, pACB->host->host_no);=0A=
 	}=0A=
 	return;=0A=
 }=0A=
-static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
@@ -1263,33 +1390,40 @@ static void arcmsr_stop_adapter_bgrb(str=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);=0A=
+	dma_free_coherent(&acb->pdev->dev, acb->uncache_size,=0A=
+	acb->dma_coherent, acb->dma_coherent_handle);=0A=
 }=0A=
 =0A=
-void arcmsr_iop_message_read(struct AdapterControlBlock *acb)=0A=
+void=0A=
+arcmsr_iop_message_read(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,=0A=
+		&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK,=0A=
+		reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
+		&reg->inbound_doorbell);=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
@@ -1298,7 +1432,8 @@ static void arcmsr_iop_message_wrote(str=0A=
 		** push inbound doorbell tell iop, driver data write ok=0A=
 		** and wait reply on next hwinterrupt for next Qbuffer post=0A=
 		*/=0A=
-		writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,=0A=
+		&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
 =0A=
@@ -1308,7 +1443,8 @@ static void arcmsr_iop_message_wrote(str=0A=
 		** push inbound doorbell tell iop, driver data write ok=0A=
 		** and wait reply on next hwinterrupt for next Qbuffer post=0A=
 		*/=0A=
-		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK,=0A=
+		reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
@@ -1317,13 +1453,15 @@ static void arcmsr_iop_message_wrote(str=0A=
 		** push inbound doorbell tell iop, driver data write ok=0A=
 		** and wait reply on next hwinterrupt for next Qbuffer post=0A=
 		*/=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,=0A=
+		&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
 }=0A=
 =0A=
-struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct =
AdapterControlBlock *acb)=0A=
+struct QBUFFER __iomem=0A=
+*arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct QBUFFER __iomem *qbuffer =3D NULL;=0A=
 	switch (acb->adapter_type) {=0A=
@@ -1340,21 +1478,23 @@ struct QBUFFER __iomem *arcmsr_get_iop_r=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		struct MessageUnit_C *phbcmu =3D=0A=
+			(struct MessageUnit_C *)acb->pmuC;=0A=
 		qbuffer =3D (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;=0A=
 		}=0A=
 	}=0A=
 	return qbuffer;=0A=
 }=0A=
 =0A=
-static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct =
AdapterControlBlock *acb)=0A=
+struct QBUFFER __iomem=0A=
+*arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct QBUFFER __iomem *pqbuffer =3D NULL;=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-		pqbuffer =3D (struct QBUFFER __iomem *) &reg->message_wbuffer;=0A=
+		pqbuffer =3D (struct QBUFFER __iomem *)&reg->message_wbuffer;=0A=
 		}=0A=
 		break;=0A=
 =0A=
@@ -1367,12 +1507,12 @@ static struct QBUFFER __iomem *arcmsr_ge=0A=
 		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
 		pqbuffer =3D (struct QBUFFER __iomem *)&reg->message_wbuffer;=0A=
 	}=0A=
-=0A=
 	}=0A=
 	return pqbuffer;=0A=
 }=0A=
 =0A=
-static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock =
*acb)=0A=
+void=0A=
+arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct QBUFFER __iomem *prbuffer;=0A=
 	struct QBUFFER *pQbuffer;=0A=
@@ -1383,12 +1523,13 @@ static void arcmsr_iop2drv_data_wrote_ha=0A=
 	prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
 	iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
 	iop_len =3D prbuffer->data_len;=0A=
-	my_empty_len =3D (rqbuf_firstindex - rqbuf_lastindex - 1) & =
(ARCMSR_MAX_QBUFFER - 1);=0A=
+	my_empty_len =3D (rqbuf_firstindex - rqbuf_lastindex - 1) &=0A=
+	(ARCMSR_MAX_QBUFFER - 1);=0A=
 =0A=
-	if (my_empty_len >=3D iop_len)=0A=
-	{=0A=
+	if (my_empty_len >=3D iop_len) {=0A=
 		while (iop_len > 0) {=0A=
-			pQbuffer =3D (struct QBUFFER *)&acb->rqbuffer[rqbuf_lastindex];=0A=
+			pQbuffer =3D (struct QBUFFER *)=0A=
+			&acb->rqbuffer[rqbuf_lastindex];=0A=
 			memcpy(pQbuffer, iop_data, 1);=0A=
 			rqbuf_lastindex++;=0A=
 			rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
@@ -1397,14 +1538,13 @@ static void arcmsr_iop2drv_data_wrote_ha=0A=
 		}=0A=
 		acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
 		arcmsr_iop_message_read(acb);=0A=
-	}=0A=
-=0A=
-	else {=0A=
+	} else {=0A=
 		acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock =
*acb)=0A=
+void=0A=
+arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_READED;=0A=
 	if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) {=0A=
@@ -1417,8 +1557,8 @@ static void arcmsr_iop2drv_data_read_han=0A=
 		pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
 		iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
 =0A=
-		while ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) && \=0A=
-							(allxfer_len < 124)) {=0A=
+		while ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) &&=0A=
+		(allxfer_len < 124)) {=0A=
 			pQbuffer =3D &acb->wqbuffer[acb->wqbuf_firstindex];=0A=
 			memcpy(iop_data, pQbuffer, 1);=0A=
 			acb->wqbuf_firstindex++;=0A=
@@ -1427,16 +1567,15 @@ static void arcmsr_iop2drv_data_read_han=0A=
 			allxfer_len++;=0A=
 		}=0A=
 		pwbuffer->data_len =3D allxfer_len;=0A=
-=0A=
 		arcmsr_iop_message_wrote(acb);=0A=
 	}=0A=
-=0A=
 	if (acb->wqbuf_firstindex =3D=3D acb->wqbuf_lastindex) {=0A=
 		acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
@@ -1450,19 +1589,13 @@ static void arcmsr_hba_doorbell_isr(stru=0A=
 		arcmsr_iop2drv_data_read_handle(acb);=0A=
 	}=0A=
 }=0A=
-static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
+static void=0A=
+arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
 	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
-	/*=0A=
-	*******************************************************************=0A=
-	**  Maybe here we need to check wrqbuffer_lock is lock or not=0A=
-	**  DOORBELL: din! don!=0A=
-	**  check if there are any mail need to pack from firmware=0A=
-	*******************************************************************=0A=
-	*/=0A=
 	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-	writel(outbound_doorbell, &reg->outbound_doorbell_clear);/*clear =
interrupt*/=0A=
+	writel(outbound_doorbell, &reg->outbound_doorbell_clear);=0A=
 	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {=0A=
 		arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
 	}=0A=
@@ -1470,11 +1603,12 @@ static void arcmsr_hbc_doorbell_isr(stru=0A=
 		arcmsr_iop2drv_data_read_handle(pACB);=0A=
 	}=0A=
 	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-		arcmsr_hbc_message_isr(pACB);    /* messenger of "driver to iop =
commands" */=0A=
+		arcmsr_hbaC_message_isr(pACB);=0A=
 	}=0A=
 	return;=0A=
 }=0A=
-static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t flag_ccb;=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
@@ -1482,13 +1616,17 @@ static void arcmsr_hba_postqueue_isr(str=0A=
 	struct CommandControlBlock *pCCB;=0A=
 	bool error;=0A=
 	while ((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D 0xFFFFFFFF) =
{=0A=
-		pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
-		pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
+			(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+		pCCB =3D container_of(pARCMSR_CDB,=0A=
+			struct CommandControlBlock, arcmsr_cdb);=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)=0A=
+			? true : false;=0A=
 		arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 	}=0A=
 }=0A=
-static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t index;=0A=
 	uint32_t flag_ccb;=0A=
@@ -1499,9 +1637,13 @@ static void arcmsr_hbb_postqueue_isr(str=0A=
 	index =3D reg->doneq_index;=0A=
 	while ((flag_ccb =3D readl(&reg->done_qbuffer[index])) !=3D 0) {=0A=
 		writel(0, &reg->done_qbuffer[index]);=0A=
-		pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
-		pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
+		(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+		pCCB =3D container_of(pARCMSR_CDB,=0A=
+		struct CommandControlBlock, arcmsr_cdb);=0A=
+		error =3D (flag_ccb &=0A=
+		ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)=0A=
+		? true : false;=0A=
 		arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 		index++;=0A=
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;=0A=
@@ -1509,7 +1651,8 @@ static void arcmsr_hbb_postqueue_isr(str=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_C *phbcmu;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
@@ -1522,38 +1665,34 @@ static void arcmsr_hbc_postqueue_isr(str=0A=
 	/* Use correct offset and size for syncing */=0A=
 =0A=
 	while (readl(&phbcmu->host_int_status) &=0A=
-	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){=0A=
+	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {=0A=
 	/* check if command done with no error*/=0A=
 	flag_ccb =3D readl(&phbcmu->outbound_queueport_low);=0A=
-	ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);/*frame must be 32 bytes =
aligned*/=0A=
+	ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
 	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);=0A=
 	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
 	error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;=0A=
 	/* check if command done with no error */=0A=
 	arcmsr_drain_donequeue(acb, ccb, error);=0A=
 	if (throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING, =
&phbcmu->inbound_doorbell);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,=0A=
+		&phbcmu->inbound_doorbell);=0A=
 		break;=0A=
 	}=0A=
 	throttling++;=0A=
 	}=0A=
 }=0A=
-/*=0A=
-************************************************************************=
**********=0A=
-** Handle a message interrupt=0A=
-**=0A=
-** The only message interrupt we expect is in response to a query for =
the current adapter config.  =0A=
-** We want this in order to compare the drivemap so that we can detect =
newly-attached drives.=0A=
-************************************************************************=
**********=0A=
-*/=0A=
-static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A *reg  =3D acb->pmuA;=0A=
 	/*clear interrupt and message state*/=0A=
 	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
-static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
 =0A=
@@ -1561,52 +1700,44 @@ static void arcmsr_hbb_message_isr(struc=0A=
 	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
-/*=0A=
-************************************************************************=
**********=0A=
-** Handle a message interrupt=0A=
-**=0A=
-** The only message interrupt we expect is in response to a query for =
the=0A=
-** current adapter config.=0A=
-** We want this in order to compare the drivemap so that we can detect =
newly-attached drives.=0A=
-************************************************************************=
**********=0A=
-*/=0A=
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_C *reg  =3D acb->pmuC;=0A=
 	/*clear interrupt and message state*/=0A=
-	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&reg->outbound_doorbell_clear);=0A=
+	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
+	&reg->outbound_doorbell_clear);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
 =0A=
-static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)=0A=
+static int=0A=
+arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_intstatus;=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
 		acb->outbound_int_enable;=0A=
-	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))	{=0A=
+	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT)) {=0A=
 		return 1;=0A=
 	}=0A=
 	writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)	{=0A=
-		arcmsr_hba_doorbell_isr(acb);=0A=
-	}=0A=
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {=0A=
-		arcmsr_hba_postqueue_isr(acb);=0A=
-	}=0A=
-	if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) 	{=0A=
-		/* messenger of "driver to iop commands" */=0A=
-		arcmsr_hba_message_isr(acb);=0A=
-	}=0A=
+	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)=0A=
+		arcmsr_hbaA_doorbell_isr(acb);=0A=
+	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)=0A=
+		arcmsr_hbaA_postqueue_isr(acb);=0A=
+	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)=0A=
+		arcmsr_hbaA_message_isr(acb);=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)=0A=
+static int=0A=
+arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	outbound_doorbell =3D readl(reg->iop2drv_doorbell) &=0A=
-				acb->outbound_int_enable;=0A=
+	acb->outbound_int_enable;=0A=
 	if (!outbound_doorbell)=0A=
 		return 1;=0A=
 =0A=
@@ -1614,7 +1745,8 @@ static int arcmsr_handle_hbb_isr(struct=0A=
 	/*in case the last action of doorbell interrupt clearance is cached,=0A=
 	this action can push HW to write down the clear bit*/=0A=
 	readl(reg->iop2drv_doorbell);=0A=
-	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
+	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,=0A=
+		reg->drv2iop_doorbell);=0A=
 	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {=0A=
 		arcmsr_iop2drv_data_wrote_handle(acb);=0A=
 	}=0A=
@@ -1622,65 +1754,64 @@ static int arcmsr_handle_hbb_isr(struct=0A=
 		arcmsr_iop2drv_data_read_handle(acb);=0A=
 	}=0A=
 	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {=0A=
-		arcmsr_hbb_postqueue_isr(acb);=0A=
+		arcmsr_hbaB_postqueue_isr(acb);=0A=
 	}=0A=
-	if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+	if (outbound_doorbell &=0A=
+		ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
 		/* messenger of "driver to iop commands" */=0A=
-		arcmsr_hbb_message_isr(acb);=0A=
+		arcmsr_hbaB_message_isr(acb);=0A=
 	}=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)=0A=
+static int=0A=
+arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	uint32_t host_interrupt_status;=0A=
-	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
-	/*=0A=
-	*********************************************=0A=
-	**   check outbound intstatus=0A=
-	*********************************************=0A=
-	*/=0A=
+	struct MessageUnit_C *phbcmu =3D=0A=
+	(struct MessageUnit_C *)pACB->pmuC;=0A=
 	host_interrupt_status =3D readl(&phbcmu->host_int_status);=0A=
 	if (!host_interrupt_status) {=0A=
 		/*it must be share irq*/=0A=
 		return 1;=0A=
 	}=0A=
 	/* MU ioctl transfer doorbell interrupts*/=0A=
-	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {=0A=
-		arcmsr_hbc_doorbell_isr(pACB);   /* messenger of "ioctl message read =
write" */=0A=
+	if (host_interrupt_status &=0A=
+		ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {=0A=
+		arcmsr_hbaC_doorbell_isr(pACB);=0A=
 	}=0A=
 	/* MU post queue interrupts*/=0A=
-	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {=0A=
-		arcmsr_hbc_postqueue_isr(pACB);  /* messenger of "scsi commands" */=0A=
+	if (host_interrupt_status &=0A=
+		ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {=0A=
+		arcmsr_hbaC_postqueue_isr(pACB);=0A=
 	}=0A=
 	return 0;=0A=
 }=0A=
-static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)=0A=
+static irqreturn_t=0A=
+arcmsr_interrupt(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		if (arcmsr_handle_hba_isr(acb)) {=0A=
+		if (arcmsr_hbaA_handle_isr(acb))=0A=
 			return IRQ_NONE;=0A=
 		}=0A=
-		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		if (arcmsr_handle_hbb_isr(acb)) {=0A=
+		if (arcmsr_hbaB_handle_isr(acb))=0A=
 			return IRQ_NONE;=0A=
 		}=0A=
-		}=0A=
 		break;=0A=
 	 case ACB_ADAPTER_TYPE_C: {=0A=
-		if (arcmsr_handle_hbc_isr(acb)) {=0A=
+		if (arcmsr_hbaC_handle_isr(acb))=0A=
 			return IRQ_NONE;=0A=
 		}=0A=
-		}=0A=
 	}=0A=
 	return IRQ_HANDLED;=0A=
 }=0A=
 =0A=
-static void arcmsr_iop_parking(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_iop_parking(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	if (acb) {=0A=
 		/* stop adapter background rebuild */=0A=
@@ -1695,7 +1826,8 @@ static void arcmsr_iop_parking(struct Ad=0A=
 	}=0A=
 }=0A=
 =0A=
-void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)=0A=
+void=0A=
+arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	int32_t wqbuf_firstindex, wqbuf_lastindex;=0A=
 	uint8_t *pQbuffer;=0A=
@@ -1708,7 +1840,8 @@ void arcmsr_post_ioctldata2iop(struct Ad=0A=
 		acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 		wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
 		wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
-		while ((wqbuf_firstindex !=3D wqbuf_lastindex) && (allxfer_len < =
124)) {=0A=
+		while ((wqbuf_firstindex !=3D wqbuf_lastindex)=0A=
+			&& (allxfer_len < 124)) {=0A=
 			pQbuffer =3D &acb->wqbuffer[wqbuf_firstindex];=0A=
 			memcpy(iop_data, pQbuffer, 1);=0A=
 			wqbuf_firstindex++;=0A=
@@ -1722,20 +1855,20 @@ void arcmsr_post_ioctldata2iop(struct Ad=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
+static int=0A=
+arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
 					struct scsi_cmnd *cmd)=0A=
 {=0A=
 	struct CMD_MESSAGE_FIELD *pcmdmessagefld;=0A=
 	int retvalue =3D 0, transfer_len =3D 0;=0A=
 	char *buffer;=0A=
 	struct scatterlist *sg;=0A=
-	uint32_t controlcode =3D (uint32_t ) cmd->cmnd[5] << 24 |=0A=
-						(uint32_t ) cmd->cmnd[6] << 16 |=0A=
-						(uint32_t ) cmd->cmnd[7] << 8  |=0A=
-						(uint32_t ) cmd->cmnd[8];=0A=
-						/* 4 bytes: Areca io control code */=0A=
+	uint32_t controlcode =3D (uint32_t)cmd->cmnd[5] << 24=0A=
+	|(uint32_t)cmd->cmnd[6] << 16=0A=
+	|(uint32_t)cmd->cmnd[7] << 8=0A=
+	| (uint32_t)cmd->cmnd[8];=0A=
 	sg =3D scsi_sglist(cmd);=0A=
-	buffer =3D kmap_atomic(sg_page(sg)) + sg->offset;=0A=
+	buffer =3D kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;=0A=
 	if (scsi_sg_count(cmd) > 1) {=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 		goto message_out;=0A=
@@ -1746,8 +1879,8 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 		goto message_out;=0A=
 	}=0A=
-	pcmdmessagefld =3D (struct CMD_MESSAGE_FIELD *) buffer;=0A=
-	switch(controlcode) {=0A=
+	pcmdmessagefld =3D (struct CMD_MESSAGE_FIELD *)buffer;=0A=
+	switch (controlcode) {=0A=
 =0A=
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {=0A=
 		unsigned char *ver_addr;=0A=
@@ -1759,7 +1892,6 @@ static int arcmsr_iop_message_xfer(struc=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
-				=0A=
 		ptmpQbuffer =3D ver_addr;=0A=
 		while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)=0A=
 			&& (allxfer_len < 1031)) {=0A=
@@ -1781,7 +1913,8 @@ static int arcmsr_iop_message_xfer(struc=0A=
 			iop_data =3D prbuffer->data;=0A=
 			iop_len =3D readl(&prbuffer->data_len);=0A=
 			while (iop_len > 0) {=0A=
-				acb->rqbuffer[acb->rqbuf_lastindex] =3D readb(iop_data);=0A=
+				acb->rqbuffer[acb->rqbuf_lastindex] =3D=0A=
+				readb(iop_data);=0A=
 				acb->rqbuf_lastindex++;=0A=
 				acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
 				iop_data++;=0A=
@@ -1789,12 +1922,15 @@ static int arcmsr_iop_message_xfer(struc=0A=
 			}=0A=
 			arcmsr_iop_message_read(acb);=0A=
 		}=0A=
-		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);=0A=
+		memcpy(pcmdmessagefld->messagedatabuffer,=0A=
+		ver_addr, allxfer_len);=0A=
 		pcmdmessagefld->cmdmessage.Length =3D allxfer_len;=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		kfree(ver_addr);=0A=
 		}=0A=
@@ -1802,7 +1938,8 @@ static int arcmsr_iop_message_xfer(struc=0A=
 =0A=
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {=0A=
 		unsigned char *ver_addr;=0A=
-		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;=0A=
+		int32_t my_empty_len, user_len, wqbuf_firstindex,=0A=
+		wqbuf_lastindex;=0A=
 		uint8_t *pQbuffer, *ptmpuserbuffer;=0A=
 =0A=
 		ver_addr =3D kmalloc(1032, GFP_ATOMIC);=0A=
@@ -1810,16 +1947,17 @@ static int arcmsr_iop_message_xfer(struc=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D =0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D =0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		ptmpuserbuffer =3D ver_addr;=0A=
 		user_len =3D pcmdmessagefld->cmdmessage.Length;=0A=
-		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);=0A=
+		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer,=0A=
+		user_len);=0A=
 		wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
 		wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
 		if (wqbuf_lastindex !=3D wqbuf_firstindex) {=0A=
@@ -1842,13 +1980,15 @@ static int arcmsr_iop_message_xfer(struc=0A=
 					&acb->wqbuffer[acb->wqbuf_lastindex];=0A=
 					memcpy(pQbuffer, ptmpuserbuffer, 1);=0A=
 					acb->wqbuf_lastindex++;=0A=
-					acb->wqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+					acb->wqbuf_lastindex %=3D=0A=
+					ARCMSR_MAX_QBUFFER;=0A=
 					ptmpuserbuffer++;=0A=
 					user_len--;=0A=
 				}=0A=
-				if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
+				if (acb->acb_flags &=0A=
+				ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
 					acb->acb_flags &=3D=0A=
-						~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
+					~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
 					arcmsr_post_ioctldata2iop(acb);=0A=
 				}=0A=
 			} else {=0A=
@@ -1877,10 +2017,10 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		acb->rqbuf_firstindex =3D 0;=0A=
 		acb->rqbuf_lastindex =3D 0;=0A=
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
@@ -1889,10 +2029,10 @@ static int arcmsr_iop_message_xfer(struc=0A=
 =0A=
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->wqbuffer;=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
@@ -1929,10 +2069,10 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));=0A=
 		pQbuffer =3D acb->wqbuffer;=0A=
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
@@ -1940,10 +2080,10 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_3F;=0A=
 		}=0A=
@@ -1951,10 +2091,10 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		}=0A=
 	case ARCMSR_MESSAGE_SAY_HELLO: {=0A=
 		int8_t *hello_string =3D "Hello! I am ARCMSR";=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
@@ -1964,7 +2104,7 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_SAY_GOODBYE:=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
 		}=0A=
@@ -1972,7 +2112,7 @@ static int arcmsr_iop_message_xfer(struc=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
 		}=0A=
@@ -1984,20 +2124,22 @@ static int arcmsr_iop_message_xfer(struc=0A=
 	}=0A=
 	message_out:=0A=
 	sg =3D scsi_sglist(cmd);=0A=
-	kunmap_atomic(buffer - sg->offset);=0A=
+	kunmap_atomic(buffer - sg->offset, KM_IRQ0);=0A=
 	return retvalue;=0A=
 }=0A=
 =0A=
-static struct CommandControlBlock *arcmsr_get_freeccb(struct =
AdapterControlBlock *acb)=0A=
+struct CommandControlBlock=0A=
+*arcmsr_get_freeccb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct list_head *head =3D &acb->ccb_free_list;=0A=
 	struct CommandControlBlock *ccb =3D NULL;=0A=
 	unsigned long flags;=0A=
 	spin_lock_irqsave(&acb->ccblist_lock, flags);=0A=
 	if (!list_empty(head)) {=0A=
-		ccb =3D list_entry(head->next, struct CommandControlBlock, list);=0A=
+		ccb =3D list_entry(head->next,=0A=
+			struct CommandControlBlock, list);=0A=
 		list_del_init(&ccb->list);=0A=
-	}else{=0A=
+	} else {=0A=
 		spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
 		return 0;=0A=
 	}=0A=
@@ -2005,7 +2147,8 @@ static struct CommandControlBlock *arcms=0A=
 	return ccb;=0A=
 }=0A=
 =0A=
-static void arcmsr_handle_virtual_command(struct AdapterControlBlock =
*acb,=0A=
+void=0A=
+arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,=0A=
 		struct scsi_cmnd *cmd)=0A=
 {=0A=
 	switch (cmd->cmnd[0]) {=0A=
@@ -2034,11 +2177,11 @@ static void arcmsr_handle_virtual_comman=0A=
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */=0A=
 =0A=
 		sg =3D scsi_sglist(cmd);=0A=
-		buffer =3D kmap_atomic(sg_page(sg)) + sg->offset;=0A=
+		buffer =3D kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;=0A=
 =0A=
 		memcpy(buffer, inqdata, sizeof(inqdata));=0A=
 		sg =3D scsi_sglist(cmd);=0A=
-		kunmap_atomic(buffer - sg->offset);=0A=
+		kunmap_atomic(buffer - sg->offset, KM_IRQ0);=0A=
 =0A=
 		cmd->scsi_done(cmd);=0A=
 	}=0A=
@@ -2055,11 +2198,13 @@ static void arcmsr_handle_virtual_comman=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,=0A=
+static int=0A=
+arcmsr_queue_command_lck(struct scsi_cmnd *cmd,=0A=
 	void (* done)(struct scsi_cmnd *))=0A=
 {=0A=
 	struct Scsi_Host *host =3D cmd->device->host;=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+	(struct AdapterControlBlock *)host->hostdata;=0A=
 	struct CommandControlBlock *ccb;=0A=
 	int target =3D cmd->device->id;=0A=
 	int lun =3D cmd->device->lun;=0A=
@@ -2067,8 +2212,10 @@ static int arcmsr_queue_command_lck(stru=0A=
 	cmd->scsi_done =3D done;=0A=
 	cmd->host_scribble =3D NULL;=0A=
 	cmd->result =3D 0;=0A=
-	if ((scsicmd =3D=3D SYNCHRONIZE_CACHE) ||(scsicmd =3D=3D =
SEND_DIAGNOSTIC)){=0A=
-		if(acb->devstate[target][lun] =3D=3D ARECA_RAID_GONE) {=0A=
+	if ((scsicmd =3D=3D SYNCHRONIZE_CACHE) ||=0A=
+		(scsicmd =3D=3D SEND_DIAGNOSTIC)) {=0A=
+		if (acb->devstate[target][lun] =3D=3D=0A=
+			ARECA_RAID_GONE) {=0A=
     			cmd->result =3D (DID_NO_CONNECT << 16);=0A=
 		}=0A=
 		cmd->scsi_done(cmd);=0A=
@@ -2080,13 +2227,14 @@ static int arcmsr_queue_command_lck(stru=0A=
 		return 0;=0A=
 	}=0A=
 	if (atomic_read(&acb->ccboutstandingcount) >=3D=0A=
-			ARCMSR_MAX_OUTSTANDING_CMD)=0A=
+	ARCMSR_MAX_OUTSTANDING_CMD)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	ccb =3D arcmsr_get_freeccb(acb);=0A=
 	if (!ccb)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	if (arcmsr_build_ccb( acb, ccb, cmd ) =3D=3D FAILED) {=0A=
-		cmd->result =3D (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);=0A=
+		cmd->result =3D (DID_ERROR << 16) |=0A=
+			(RESERVATION_CONFLICT << 1);=0A=
 		cmd->scsi_done(cmd);=0A=
 		return 0;=0A=
 	}=0A=
@@ -2096,24 +2244,30 @@ static int arcmsr_queue_command_lck(stru=0A=
 =0A=
 static DEF_SCSI_QCMD(arcmsr_queue_command)=0A=
 =0A=
-static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)=0A=
+static bool=0A=
+arcmsr_hbaA_get_config(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	char *acb_firm_model =3D acb->firm_model;=0A=
 	char *acb_firm_version =3D acb->firm_version;=0A=
 	char *acb_device_map =3D acb->device_map;=0A=
-	char __iomem *iop_firm_model =3D (char __iomem =
*)(&reg->message_rwbuffer[15]);=0A=
-	char __iomem *iop_firm_version =3D (char __iomem =
*)(&reg->message_rwbuffer[17]);=0A=
-	char __iomem *iop_device_map =3D (char __iomem =
*)(&reg->message_rwbuffer[21]);=0A=
+	char __iomem *iop_firm_model =3D=0A=
+		(char __iomem *)(&reg->message_rwbuffer[15]);=0A=
+	char __iomem *iop_firm_version =3D=0A=
+		(char __iomem *)(&reg->message_rwbuffer[17]);=0A=
+	char __iomem *iop_device_map =3D=0A=
+		(char __iomem *)(&reg->message_rwbuffer[21]);=0A=
 	int count;=0A=
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
-			miscellaneous data' timeout \n", acb->host->host_no);=0A=
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,=0A=
+		&reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'get adapter firmware "=0A=
+		"miscellaneous data' timeout\n",=0A=
+		acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
-	while (count){=0A=
+	while (count) {=0A=
 		*acb_firm_model =3D readb(iop_firm_model);=0A=
 		acb_firm_model++;=0A=
 		iop_firm_model++;=0A=
@@ -2121,7 +2275,7 @@ static bool arcmsr_get_hba_config(struct=0A=
 	}=0A=
 =0A=
 	count =3D 16;=0A=
-	while (count){=0A=
+	while (count) {=0A=
 		*acb_firm_version =3D readb(iop_firm_version);=0A=
 		acb_firm_version++;=0A=
 		iop_firm_version++;=0A=
@@ -2129,13 +2283,14 @@ static bool arcmsr_get_hba_config(struct=0A=
 	}=0A=
 =0A=
 	count=3D16;=0A=
-	while(count){=0A=
+	while (count) {=0A=
 		*acb_device_map =3D readb(iop_device_map);=0A=
 		acb_device_map++;=0A=
 		iop_device_map++;=0A=
 		count--;=0A=
 	}=0A=
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n", =0A=
+	pr_notice("Areca RAID Controller%d: F/W %s "=0A=
+		"& Model %s\n",=0A=
 		acb->host->host_no,=0A=
 		acb->firm_version,=0A=
 		acb->firm_model);=0A=
@@ -2144,10 +2299,12 @@ static bool arcmsr_get_hba_config(struct=0A=
 	acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[2]);=0A=
 	acb->firm_sdram_size =3D readl(&reg->message_rwbuffer[3]);=0A=
 	acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[4]);=0A=
-	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
+	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);=0A=
 	return true;=0A=
 }=0A=
-static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)=0A=
+=0A=
+static bool=0A=
+arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
@@ -2163,40 +2320,57 @@ static bool arcmsr_get_hbb_config(struct=0A=
 	char __iomem *iop_device_map;=0A=
 	/*firm_version,21,84-99*/=0A=
 	int count;=0A=
-	dma_coherent =3D dma_alloc_coherent(&pdev->dev, sizeof(struct =
MessageUnit_B), &dma_coherent_handle, GFP_KERNEL);=0A=
-	if (!dma_coherent){=0A=
-		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error for hbb =
mu\n", acb->host->host_no);=0A=
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
+		sizeof(struct MessageUnit_B), &dma_coherent_handle,=0A=
+		GFP_KERNEL);=0A=
+	if (!dma_coherent) {=0A=
+		pr_notice("arcmsr%d: dma_alloc_coherent "=0A=
+		"got error for hbb mu\n", acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	acb->dma_coherent_handle_hbb_mu =3D dma_coherent_handle;=0A=
 	reg =3D (struct MessageUnit_B *)dma_coherent;=0A=
 	acb->pmuB =3D reg;=0A=
-	reg->drv2iop_doorbell=3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);=0A=
-	reg->drv2iop_doorbell_mask =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);=0A=
-	reg->iop2drv_doorbell =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);=0A=
-	reg->iop2drv_doorbell_mask =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);=0A=
-	reg->message_wbuffer =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);=0A=
-	reg->message_rbuffer =3D  (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);=0A=
-	reg->message_rwbuffer =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);=0A=
-	iop_firm_model =3D (char __iomem *)(&reg->message_rwbuffer[15]);	=
/*firm_model,15,60-67*/=0A=
-	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[17]);	=
/*firm_version,17,68-83*/=0A=
-	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]);	=
/*firm_version,21,84-99*/=0A=
+	reg->drv2iop_doorbell =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base0 +=0A=
+		ARCMSR_DRV2IOP_DOORBELL);=0A=
+	reg->drv2iop_doorbell_mask =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base0 +=0A=
+		ARCMSR_DRV2IOP_DOORBELL_MASK);=0A=
+	reg->iop2drv_doorbell =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base0 +=0A=
+		ARCMSR_IOP2DRV_DOORBELL);=0A=
+	reg->iop2drv_doorbell_mask =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base0 +=0A=
+		ARCMSR_IOP2DRV_DOORBELL_MASK);=0A=
+	reg->message_wbuffer =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base1 +=0A=
+		ARCMSR_MESSAGE_WBUFFER);=0A=
+	reg->message_rbuffer =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base1 +=0A=
+		ARCMSR_MESSAGE_RBUFFER);=0A=
+	reg->message_rwbuffer =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base1 +=0A=
+		ARCMSR_MESSAGE_RWBUFFER);=0A=
+	iop_firm_model =3D (char __iomem *)(&reg->message_rwbuffer[15]);=0A=
+	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[17]);=0A=
+	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]);=0A=
 =0A=
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);=0A=
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
-			miscellaneous data' timeout \n", acb->host->host_no);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'get adapter firmware "=0A=
+		"miscellaneous data' timeout\n", acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
-	while (count){=0A=
+	while (count) {=0A=
 		*acb_firm_model =3D readb(iop_firm_model);=0A=
 		acb_firm_model++;=0A=
 		iop_firm_model++;=0A=
 		count--;=0A=
 	}=0A=
 	count =3D 16;=0A=
-	while (count){=0A=
+	while (count) {=0A=
 		*acb_firm_version =3D readb(iop_firm_version);=0A=
 		acb_firm_version++;=0A=
 		iop_firm_version++;=0A=
@@ -2204,14 +2378,15 @@ static bool arcmsr_get_hbb_config(struct=0A=
 	}=0A=
 =0A=
 	count =3D 16;=0A=
-	while(count){=0A=
+	while (count) {=0A=
 		*acb_device_map =3D readb(iop_device_map);=0A=
 		acb_device_map++;=0A=
 		iop_device_map++;=0A=
 		count--;=0A=
 	}=0A=
-	=0A=
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
+=0A=
+	pr_notice("Areca RAID Controller%d: "=0A=
+		"F/W %s & Model %s\n",=0A=
 		acb->host->host_no,=0A=
 		acb->firm_version,=0A=
 		acb->firm_model);=0A=
@@ -2226,41 +2401,45 @@ static bool arcmsr_get_hbb_config(struct=0A=
 	/*firm_sdram_size,3,12-15*/=0A=
 	acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[5]);=0A=
 	/*firm_ide_channels,4,16-19*/=0A=
-	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
+	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);=0A=
 	/*firm_ide_channels,4,16-19*/=0A=
 	return true;=0A=
 }=0A=
 =0A=
-static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)=0A=
+static bool=0A=
+arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	uint32_t intmask_org, Index, firmware_state =3D 0;=0A=
 	struct MessageUnit_C *reg =3D pACB->pmuC;=0A=
 	char *acb_firm_model =3D pACB->firm_model;=0A=
 	char *acb_firm_version =3D pACB->firm_version;=0A=
-	char *iop_firm_model =3D (char *)(&reg->msgcode_rwbuffer[15]);    =
/*firm_model,15,60-67*/=0A=
-	char *iop_firm_version =3D (char *)(&reg->msgcode_rwbuffer[17]);  =
/*firm_version,17,68-83*/=0A=
+	char *iop_firm_model =3D (char *)(&reg->msgcode_rwbuffer[15]);=0A=
+	char *iop_firm_version =3D (char *)(&reg->msgcode_rwbuffer[17]);=0A=
 	int count;=0A=
 	/* disable all outbound interrupt */=0A=
-	intmask_org =3D readl(&reg->host_int_mask); /* disable outbound =
message0 int */=0A=
-	writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, =
&reg->host_int_mask);=0A=
-	/* wait firmware ready */=0A=
+	intmask_org =3D readl(&reg->host_int_mask);=0A=
+	writel(intmask_org | ARCMSR_HBCMU_ALL_INTMASKENABLE,=0A=
+		&reg->host_int_mask);=0A=
 	do {=0A=
 		firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
 	} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
 	/* post "get config" instruction */=0A=
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&reg->inbound_doorbell);=0A=
 	/* wait message ready */=0A=
 	for (Index =3D 0; Index < 2000; Index++) {=0A=
-		if (readl(&reg->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&reg->outbound_doorbell_clear);/*clear interrupt*/=0A=
+		if (readl(&reg->outbound_doorbell) &=0A=
+		ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
+				&reg->outbound_doorbell_clear);=0A=
 			break;=0A=
 		}=0A=
 		udelay(10);=0A=
 	} /*max 1 seconds*/=0A=
 	if (Index >=3D 2000) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
-			miscellaneous data' timeout \n", pACB->host->host_no);=0A=
+		pr_notice("arcmsr%d: wait 'get adapter firmware "=0A=
+		"miscellaneous data' timeout\n", pACB->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
@@ -2277,86 +2456,99 @@ static bool arcmsr_get_hbc_config(struct=0A=
 		iop_firm_version++;=0A=
 		count--;=0A=
 	}=0A=
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
-		pACB->host->host_no,=0A=
-		pACB->firm_version,=0A=
-		pACB->firm_model);=0A=
-	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);   =
/*firm_request_len,1,04-07*/=0A=
-	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]); =
/*firm_numbers_queue,2,08-11*/=0A=
-	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);    =
/*firm_sdram_size,3,12-15*/=0A=
-	pACB->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);  =
/*firm_ide_channels,4,16-19*/=0A=
-	pACB->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
+	pr_notice("Areca RAID Controller%d: F/W %s & "=0A=
+	"Model %s\n",=0A=
+	pACB->host->host_no,=0A=
+	pACB->firm_version,=0A=
+	pACB->firm_model);=0A=
+	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);=0A=
+	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]);=0A=
+	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);=0A=
+	pACB->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);=0A=
+	pACB->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);=0A=
 	/*all interrupt service will be enable at arcmsr_iop_init*/=0A=
 	return true;=0A=
 }=0A=
-static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)=0A=
+=0A=
+static bool=0A=
+arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_A)=0A=
-		return arcmsr_get_hba_config(acb);=0A=
+		return arcmsr_hbaA_get_config(acb);=0A=
 	else if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_B)=0A=
-		return arcmsr_get_hbb_config(acb);=0A=
+		return arcmsr_hbaB_get_config(acb);=0A=
 	else=0A=
-		return arcmsr_get_hbc_config(acb);=0A=
+		return arcmsr_hbaC_get_config(acb);=0A=
 }=0A=
 =0A=
-static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,=0A=
+static int=0A=
+arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
 	struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	struct CommandControlBlock *ccb;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
-	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done =3D 0, poll_count =
=3D 0;=0A=
+	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done =3D 0;=0A=
+	uint32_t poll_count =3D 0;=0A=
 	int rtn;=0A=
 	bool error;=0A=
 	polling_hba_ccb_retry:=0A=
 	poll_count++;=0A=
-	outbound_intstatus =3D readl(&reg->outbound_intstatus) & =
acb->outbound_int_enable;=0A=
-	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear =
interrupt*/=0A=
+	outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
+		acb->outbound_int_enable;=0A=
+	writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
 	while (1) {=0A=
-		if ((flag_ccb =3D readl(&reg->outbound_queueport)) =3D=3D 0xFFFFFFFF) =
{=0A=
-			if (poll_ccb_done){=0A=
+		flag_ccb =3D readl(&reg->outbound_queueport);=0A=
+		if (flag_ccb =3D=3D 0xFFFFFFFF) {=0A=
+			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
-			}else {=0A=
+			} else {=0A=
 				msleep(25);=0A=
-				if (poll_count > 100){=0A=
+				if (poll_count > 100) {=0A=
 					rtn =3D FAILED;=0A=
 					break;=0A=
 				}=0A=
 				goto polling_hba_ccb_retry;=0A=
 			}=0A=
 		}=0A=
-		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
-		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset +=0A=
+			(flag_ccb << 5));=0A=
+		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
 		poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;=0A=
 		if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
-			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"=0A=
-					" poll command abort successfully \n"=0A=
-					, acb->host->host_no=0A=
-					, ccb->pcmd->device->id=0A=
-					, ccb->pcmd->device->lun=0A=
-					, ccb);=0A=
+			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) ||=0A=
+			(ccb =3D=3D poll_ccb)) {=0A=
+				pr_notice("arcmsr%d: scsi id =3D %d "=0A=
+				"lun =3D %d ccb =3D '0x%p' poll command "=0A=
+				"abort successfully\n"=0A=
+				, acb->host->host_no=0A=
+				, ccb->pcmd->device->id=0A=
+				, ccb->pcmd->device->lun=0A=
+				, ccb);=0A=
 				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
 				arcmsr_ccb_complete(ccb);=0A=
 				continue;=0A=
 			}=0A=
-			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
-				" command done ccb =3D '0x%p'"=0A=
-				"ccboutstandingcount =3D %d \n"=0A=
-				, acb->host->host_no=0A=
-				, ccb=0A=
-				, atomic_read(&acb->ccboutstandingcount));=0A=
+			pr_notice("arcmsr%d: polling get an illegal "=0A=
+			"ccb command done ccb =3D '0x%p' "=0A=
+			"ccboutstandingcount =3D %d\n"=0A=
+			, acb->host->host_no=0A=
+			, ccb=0A=
+			, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
 		}=0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?=0A=
+			true : false;=0A=
 		arcmsr_report_ccb_state(acb, ccb, error);=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,=0A=
-					struct CommandControlBlock *poll_ccb)=0A=
+int=0A=
+arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+				struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
@@ -2368,16 +2560,17 @@ static int arcmsr_polling_hbb_ccbdone(st=0A=
 =0A=
 	poll_count++;=0A=
 	/* clear doorbell interrupt */=0A=
-	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
-	while(1){=0A=
+	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,=0A=
+	reg->iop2drv_doorbell);=0A=
+	while (1) {=0A=
 		index =3D reg->doneq_index;=0A=
 		if ((flag_ccb =3D readl(&reg->done_qbuffer[index])) =3D=3D 0) {=0A=
-			if (poll_ccb_done){=0A=
+			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
-			}else {=0A=
+			} else {=0A=
 				msleep(25);=0A=
-				if (poll_count > 100){=0A=
+				if (poll_count > 100) {=0A=
 					rtn =3D FAILED;=0A=
 					break;=0A=
 				}=0A=
@@ -2390,36 +2583,45 @@ static int arcmsr_polling_hbb_ccbdone(st=0A=
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;=0A=
 		reg->doneq_index =3D index;=0A=
 		/* check if command done with no error*/=0A=
-		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
-		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-		poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;=0A=
-		if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
-			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"=0A=
-					" poll command abort successfully \n"=0A=
-					,acb->host->host_no=0A=
-					,ccb->pcmd->device->id=0A=
-					,ccb->pcmd->device->lun=0A=
-					,ccb);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)=0A=
+		(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+		ccb =3D container_of(arcmsr_cdb,=0A=
+			struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
+		poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1 : 0;=0A=
+		if ((ccb->acb !=3D acb) ||=0A=
+		(ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
+			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) ||=0A=
+				(ccb =3D=3D poll_ccb)) {=0A=
+				pr_notice("arcmsr%d: "=0A=
+				"scsi id =3D %d lun =3D %d ccb =3D '0x%p' poll "=0A=
+				"command abort successfully\n"=0A=
+				, acb->host->host_no=0A=
+				, ccb->pcmd->device->id=0A=
+				, ccb->pcmd->device->lun=0A=
+				, ccb);=0A=
 				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
 				arcmsr_ccb_complete(ccb);=0A=
 				continue;=0A=
 			}=0A=
-			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
-				" command done ccb =3D '0x%p'"=0A=
-				"ccboutstandingcount =3D %d \n"=0A=
+			pr_notice("arcmsr%d: polling get an "=0A=
+				"illegal ccb command done ccb =3D '0x%p' "=0A=
+				"ccboutstandingcount =3D %d\n"=0A=
 				, acb->host->host_no=0A=
 				, ccb=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
 		} =0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)=0A=
+		? true : false;=0A=
 		arcmsr_report_ccb_state(acb, ccb, error);=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock *acb, =
struct CommandControlBlock *poll_ccb)=0A=
+static int=0A=
+arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+	struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
 	uint32_t flag_ccb, ccb_cdb_phy;=0A=
@@ -2431,7 +2633,8 @@ static int arcmsr_polling_hbc_ccbdone(st=0A=
 polling_hbc_ccb_retry:=0A=
 	poll_count++;=0A=
 	while (1) {=0A=
-		if ((readl(&reg->host_int_status) & =
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) =3D=3D 0) {=0A=
+		if ((readl(&reg->host_int_status) &=0A=
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) =3D=3D 0) {=0A=
 			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
@@ -2446,58 +2649,66 @@ polling_hbc_ccb_retry:=0A=
 		}=0A=
 		flag_ccb =3D readl(&reg->outbound_queueport_low);=0A=
 		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
-		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);/*frame must be 32 bytes aligned*/=0A=
-		pCCB =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset=0A=
+			+ ccb_cdb_phy);=0A=
+		pCCB =3D container_of(arcmsr_cdb, struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
 		poll_ccb_done =3D (pCCB =3D=3D poll_ccb) ? 1 : 0;=0A=
 		/* check ifcommand done with no error*/=0A=
-		if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
+		if ((pCCB->acb !=3D acb) ||=0A=
+			(pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
 			if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"=0A=
-					" poll command abort successfully \n"=0A=
-					, acb->host->host_no=0A=
-					, pCCB->pcmd->device->id=0A=
-					, pCCB->pcmd->device->lun=0A=
-					, pCCB);=0A=
-					pCCB->pcmd->result =3D DID_ABORT << 16;=0A=
-					arcmsr_ccb_complete(pCCB);=0A=
+				pr_notice("arcmsr%d: "=0A=
+				"scsi id =3D %d lun =3D %d ccb =3D '0x%p' poll "=0A=
+				"command abort successfully\n"=0A=
+				, acb->host->host_no=0A=
+				, pCCB->pcmd->device->id=0A=
+				, pCCB->pcmd->device->lun=0A=
+				, pCCB);=0A=
+				pCCB->pcmd->result =3D DID_ABORT << 16;=0A=
+				arcmsr_ccb_complete(pCCB);=0A=
 				continue;=0A=
 			}=0A=
-			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
-				" command done ccb =3D '0x%p'"=0A=
-				"ccboutstandingcount =3D %d \n"=0A=
-				, acb->host->host_no=0A=
-				, pCCB=0A=
-				, atomic_read(&acb->ccboutstandingcount));=0A=
+			pr_notice("arcmsr%d: polling get an illegal "=0A=
+			"ccb command done ccb =3D '0x%p' "=0A=
+			"ccboutstandingcount =3D %d\n"=0A=
+			, acb->host->host_no=0A=
+			, pCCB=0A=
+			, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
 		}=0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : =
false;=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+			? true : false;=0A=
 		arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
-static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+=0A=
+static int=0A=
+arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
 					struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	int rtn =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		rtn =3D arcmsr_polling_hba_ccbdone(acb, poll_ccb);=0A=
+		rtn =3D arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		rtn =3D arcmsr_polling_hbb_ccbdone(acb, poll_ccb);=0A=
+		rtn =3D arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		rtn =3D arcmsr_polling_hbc_ccbdone(acb, poll_ccb);=0A=
+		rtn =3D arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);=0A=
 		}=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)=0A=
+static int=0A=
+arcmsr_iop_confirm(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;=0A=
 	dma_addr_t dma_coherent_handle;=0A=
@@ -2523,14 +2734,14 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 			struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 			uint32_t intmask_org;=0A=
 			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-			writel(ARCMSR_SIGNATURE_SET_CONFIG, \=0A=
-						&reg->message_rwbuffer[0]);=0A=
+			writel(ARCMSR_SIGNATURE_SET_CONFIG,=0A=
+			&reg->message_rwbuffer[0]);=0A=
 			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);=0A=
-			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \=0A=
-							&reg->inbound_msgaddr0);=0A=
-			if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \=0A=
-				part physical address timeout\n",=0A=
+			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,=0A=
+			&reg->inbound_msgaddr0);=0A=
+			if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+				pr_notice("arcmsr%d: set ccb "=0A=
+				"high part physical address timeout\n",=0A=
 				acb->host->host_no);=0A=
 				return 1;=0A=
 			}=0A=
@@ -2548,10 +2759,11 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		reg->postq_index =3D 0;=0A=
 		reg->doneq_index =3D 0;=0A=
-		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);=0A=
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \=0A=
-				acb->host->host_no);=0A=
+		writel(ARCMSR_MESSAGE_SET_POST_WINDOW,=0A=
+		reg->drv2iop_doorbell);=0A=
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+			pr_notice("arcmsr%d: can not set diver mode\n",=0A=
+			acb->host->host_no);=0A=
 			return 1;=0A=
 		}=0A=
 		post_queue_phyaddr =3D acb->dma_coherent_handle_hbb_mu;=0A=
@@ -2566,11 +2778,10 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		writel(post_queue_phyaddr + 1056, rwbuffer++);=0A=
 		/* ccb maxQ size must be --> [(256 + 8)*4]*/=0A=
 		writel(1056, rwbuffer);=0A=
-=0A=
 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);=0A=
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \=0A=
-			timeout \n",acb->host->host_no);=0A=
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+			pr_notice("arcmsr%d: 'set command Q window' "=0A=
+			"timeout\n", acb->host->host_no);=0A=
 			return 1;=0A=
 		}=0A=
 		arcmsr_hbb_enable_driver_mode(acb);=0A=
@@ -2579,17 +2790,22 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		if (cdb_phyaddr_hi32 !=3D 0) {=0A=
-			struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
-=0A=
-			printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=3D0x%x\n",=0A=
-					acb->adapter_index, cdb_phyaddr_hi32);=0A=
-			writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->msgcode_rwbuffer[0]);=0A=
-			writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);=0A=
-			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);=0A=
-			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&reg->inbound_doorbell);=0A=
-			if (!arcmsr_hbc_wait_msgint_ready(acb)) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \=0A=
-				timeout \n", acb->host->host_no);=0A=
+			struct MessageUnit_C *reg =3D=0A=
+			(struct MessageUnit_C *)acb->pmuC;=0A=
+			pr_notice("arcmsr%d: cdb_phyaddr_hi32 =3D 0x%x\n",=0A=
+			acb->adapter_index, cdb_phyaddr_hi32);=0A=
+			writel(ARCMSR_SIGNATURE_SET_CONFIG,=0A=
+				&reg->msgcode_rwbuffer[0]);=0A=
+			writel(cdb_phyaddr_hi32,=0A=
+				&reg->msgcode_rwbuffer[1]);=0A=
+			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,=0A=
+				&reg->inbound_msgaddr0);=0A=
+			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+				&reg->inbound_doorbell);=0A=
+			if (!arcmsr_hbaC_wait_msgint_ready(acb)) {=0A=
+				pr_notice("arcmsr%d: 'set "=0A=
+				"command Q window' timeout\n",=0A=
+				acb->host->host_no);=0A=
 				return 1;=0A=
 			}=0A=
 		}=0A=
@@ -2598,7 +2814,8 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t firmware_state =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
@@ -2607,161 +2824,203 @@ static void arcmsr_wait_firmware_ready(s=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 		do {=0A=
 			firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
-		} while ((firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D =
0);=0A=
+		} while ((firmware_state &=0A=
+		ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0);=0A=
 		}=0A=
 		break;=0A=
-=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		do {=0A=
 			firmware_state =3D readl(reg->iop2drv_doorbell);=0A=
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
-		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,=0A=
+		reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
 		do {=0A=
 			firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
-		} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D =
0);=0A=
+		} while ((firmware_state &=0A=
+		ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb)=0A=
+static void=0A=
+arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0)=0A=
+		|| ((acb->acb_flags & ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer,=0A=
+			jiffies + msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
-		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)){=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D=0A=
+			atomic_read(&acb->rq_map_token)) {=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		atomic_set(&acb->ante_token_value,=0A=
+			atomic_read(&acb->rq_map_token));=0A=
 		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
 		}=0A=
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,=0A=
+			&reg->inbound_msgaddr0);=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
 	return;=0A=
 }=0A=
 =0A=
-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb)=0A=
+static void=0A=
+arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
-	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
-		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)) {=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D=0A=
+			atomic_read(&acb->rq_map_token)) {=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		atomic_set(&acb->ante_token_value,=0A=
+			atomic_read(&acb->rq_map_token));=0A=
 		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
 		}=0A=
-		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+		writel(ARCMSR_MESSAGE_GET_CONFIG,=0A=
+			reg->drv2iop_doorbell);=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
 	return;=0A=
 }=0A=
 =0A=
-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock =
*acb)=0A=
+static void=0A=
+arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
-	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0)) {=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
-		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)) {=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D=0A=
+			atomic_read(&acb->rq_map_token)) {=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		atomic_set(&acb->ante_token_value,=0A=
+			atomic_read(&acb->rq_map_token));=0A=
 		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
 		}=0A=
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,=0A=
+			&reg->inbound_msgaddr0);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+			&reg->inbound_doorbell);=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
 	return;=0A=
 }=0A=
 =0A=
-static void arcmsr_request_device_map(unsigned long pacb)=0A=
+static void=0A=
+arcmsr_request_device_map(unsigned long pacb)=0A=
 {=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *)pacb;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)pacb;=0A=
 	switch (acb->adapter_type) {=0A=
-		case ACB_ADAPTER_TYPE_A: {=0A=
-			arcmsr_request_hba_device_map(acb);=0A=
-		}=0A=
-		break;=0A=
-		case ACB_ADAPTER_TYPE_B: {=0A=
-			arcmsr_request_hbb_device_map(acb);=0A=
-		}=0A=
-		break;=0A=
-		case ACB_ADAPTER_TYPE_C: {=0A=
-			arcmsr_request_hbc_device_map(acb);=0A=
-		}=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
+		arcmsr_hbaA_request_device_map(acb);=0A=
+	}=0A=
+	break;=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		arcmsr_hbaB_request_device_map(acb);=0A=
+	}=0A=
+	break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		arcmsr_hbaC_request_device_map(acb);=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);=0A=
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
-				rebulid' timeout \n", acb->host->host_no);=0A=
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB,=0A=
+		&reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'start adapter "=0A=
+		"background rebulid' timeout\n", acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);=0A=
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
-				rebulid' timeout \n",acb->host->host_no);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'start adapter "=0A=
+		"backgroundrebulid' timeout\n", acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_start_hbc_bgrb(struct AdapterControlBlock *pACB)=0A=
+static void=0A=
+arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)=0A=
 {=0A=
-	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	struct MessageUnit_C *phbcmu =3D=0A=
+		(struct MessageUnit_C *)pACB->pmuC;=0A=
 	pACB->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&phbcmu->inbound_doorbell);=0A=
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
-				rebulid' timeout \n", pACB->host->host_no);=0A=
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB,=0A=
+		&phbcmu->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&phbcmu->inbound_doorbell);=0A=
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'start adapter "=0A=
+		"background rebulid' timeout\n", pACB->host->host_no);=0A=
 	}=0A=
 	return;=0A=
 }=0A=
-static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
-		arcmsr_start_hba_bgrb(acb);=0A=
+		arcmsr_hbaA_start_bgrb(acb);=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_B:=0A=
-		arcmsr_start_hbb_bgrb(acb);=0A=
+		arcmsr_hbaB_start_bgrb(acb);=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C:=0A=
-		arcmsr_start_hbc_bgrb(acb);=0A=
+		arcmsr_hbaC_start_bgrb(acb);=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_clear_doorbell_queue_buffer(struct =
AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
@@ -2771,30 +3030,36 @@ static void arcmsr_clear_doorbell_queue_=0A=
 		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
 		/*clear doorbell interrupt */=0A=
 		writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
-		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,=0A=
+			&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		/*clear interrupt and message state*/=0A=
-		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,=0A=
+		reg->iop2drv_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK,=0A=
+			reg->drv2iop_doorbell);=0A=
 		/* let IOP know data has been read */=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		struct MessageUnit_C *reg =3D=0A=
+			(struct MessageUnit_C *)acb->pmuC;=0A=
 		uint32_t outbound_doorbell;=0A=
 		/* empty doorbell Qbuffer if door bell ringed */=0A=
 		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
 		writel(outbound_doorbell, &reg->outbound_doorbell_clear);=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
+			&reg->inbound_doorbell);=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
@@ -2802,9 +3067,11 @@ static void arcmsr_enable_eoi_mode(struc=0A=
 	case ACB_ADAPTER_TYPE_B:=0A=
 		{=0A=
 			struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);=0A=
-			if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");=0A=
+			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,=0A=
+			reg->drv2iop_doorbell);=0A=
+			if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+				pr_notice("ARCMSR IOP "=0A=
+				"enables EOI_MODE TIMEOUT");=0A=
 				return;=0A=
 			}=0A=
 		}=0A=
@@ -2815,21 +3082,24 @@ static void arcmsr_enable_eoi_mode(struc=0A=
 	return;=0A=
 }=0A=
 =0A=
-static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hardware_reset(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint8_t value[64];=0A=
 	int i, count =3D 0;=0A=
 	struct MessageUnit_A __iomem *pmuA =3D acb->pmuA;=0A=
 	struct MessageUnit_C __iomem *pmuC =3D acb->pmuC;=0A=
-=0A=
+	u32 temp =3D 0;=0A=
 	/* backup pci config data */=0A=
-	printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n", =
acb->host->host_no);=0A=
+	pr_notice("arcmsr%d: executing hw bus reset .....\n",=0A=
+	acb->host->host_no);=0A=
 	for (i =3D 0; i < 64; i++) {=0A=
 		pci_read_config_byte(acb->pdev, i, &value[i]);=0A=
 	}=0A=
 	/* hardware reset signal */=0A=
 	if ((acb->dev_id =3D=3D 0x1680)) {=0A=
-		writel(ARCMSR_ARC1680_BUS_RESET, &pmuA->reserved1[0]);=0A=
+		writel(ARCMSR_ARC1680_BUS_RESET,=0A=
+			&pmuA->reserved1[0]);=0A=
 	} else if ((acb->dev_id =3D=3D 0x1880)) {=0A=
 		do {=0A=
 			count++;=0A=
@@ -2839,8 +3109,11 @@ static void arcmsr_hardware_reset(struct=0A=
 			writel(0x2, &pmuC->write_sequence);=0A=
 			writel(0x7, &pmuC->write_sequence);=0A=
 			writel(0xD, &pmuC->write_sequence);=0A=
-		} while (((readl(&pmuC->host_diagnostic) & =
ARCMSR_ARC1880_DiagWrite_ENABLE) =3D=3D 0) && (count < 5));=0A=
-		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);=0A=
+		} while ((((temp =3D readl(&pmuC->host_diagnostic)) |=0A=
+		ARCMSR_ARC1880_DiagWrite_ENABLE) =3D=3D 0) &&=0A=
+		(count < 5));=0A=
+		writel(ARCMSR_ARC1880_RESET_ADAPTER,=0A=
+			&pmuC->host_diagnostic);=0A=
 	} else {=0A=
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);=0A=
 	}=0A=
@@ -2852,7 +3125,9 @@ static void arcmsr_hardware_reset(struct=0A=
 	msleep(1000);=0A=
 	return;=0A=
 }=0A=
-static void arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t intmask_org;=0A=
 	/* disable all outbound interrupt */=0A=
@@ -2869,7 +3144,8 @@ static void arcmsr_iop_init(struct Adapt=0A=
 	acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)=0A=
+static uint8_t=0A=
+arcmsr_iop_reset(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct CommandControlBlock *ccb;=0A=
 	uint32_t intmask_org;=0A=
@@ -2892,7 +3168,8 @@ static uint8_t arcmsr_iop_reset(struct A=0A=
 				ccb->ccb_flags =3D 0;=0A=
 				spin_lock_irqsave(&acb->ccblist_lock, flags);=0A=
 				list_add_tail(&ccb->list, &acb->ccb_free_list);=0A=
-				spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
+				spin_unlock_irqrestore(&acb->ccblist_lock,=0A=
+					flags);=0A=
 			}=0A=
 		}=0A=
 		atomic_set(&acb->ccboutstandingcount, 0);=0A=
@@ -2903,147 +3180,178 @@ static uint8_t arcmsr_iop_reset(struct A=0A=
 	return rtnval;=0A=
 }=0A=
 =0A=
-static int arcmsr_bus_reset(struct scsi_cmnd *cmd)=0A=
+static int=0A=
+arcmsr_bus_reset(struct scsi_cmnd *cmd)=0A=
 {=0A=
 	struct AdapterControlBlock *acb;=0A=
 	uint32_t intmask_org, outbound_doorbell;=0A=
 	int retry_count =3D 0;=0A=
 	int rtn =3D FAILED;=0A=
 	acb =3D (struct AdapterControlBlock *) cmd->device->host->hostdata;=0A=
-	printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets =3D %d, =
num_aborts =3D %d \n", acb->num_resets, acb->num_aborts);=0A=
+	pr_err("arcmsr: executing bus reset eh.....num_resets =3D %d, "=0A=
+	"num_aborts =3D %d\n", acb->num_resets, acb->num_aborts);=0A=
 	acb->num_resets++;=0A=
 =0A=
-	switch(acb->adapter_type){=0A=
-		case ACB_ADAPTER_TYPE_A:{=0A=
-			if (acb->acb_flags & ACB_F_BUS_RESET){=0A=
-				long timeout;=0A=
-				printk(KERN_ERR "arcmsr: there is an  bus reset eh =
proceeding.......\n");=0A=
-				timeout =3D wait_event_timeout(wait_q, (acb->acb_flags & =
ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);=0A=
-				if (timeout) {=0A=
-					return SUCCESS;=0A=
-				}=0A=
-			}=0A=
-			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-			if (!arcmsr_iop_reset(acb)) {=0A=
-				struct MessageUnit_A __iomem *reg;=0A=
-				reg =3D acb->pmuA;=0A=
-				arcmsr_hardware_reset(acb);=0A=
-				acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
+		if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
+			long timeout;=0A=
+			pr_err("arcmsr: there is an bus "=0A=
+			"reset eh proceeding.......\n");=0A=
+			timeout =3D wait_event_timeout(wait_q,=0A=
+			(acb->acb_flags & ACB_F_BUS_RESET)=0A=
+			=3D=3D 0, 220 * HZ);=0A=
+			if (timeout) {=0A=
+				return SUCCESS;=0A=
+			}=0A=
+		}=0A=
+		acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+		if (!arcmsr_iop_reset(acb)) {=0A=
+			struct MessageUnit_A __iomem *reg;=0A=
+			reg =3D acb->pmuA;=0A=
+			arcmsr_hardware_reset(acb);=0A=
+			acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
 sleep_again:=0A=
-				ssleep(ARCMSR_SLEEPTIME);=0A=
-				if ((readl(&reg->outbound_msgaddr1) & =
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
-					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, =
retry=3D%d\n", acb->host->host_no, retry_count);=0A=
-					if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
-						acb->fw_flag =3D FW_DEADLOCK;=0A=
-						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY =
TERMINATED!!\n", acb->host->host_no);=0A=
-						return FAILED;=0A=
-					}=0A=
-					retry_count++;=0A=
-					goto sleep_again;=0A=
+			ssleep(ARCMSR_SLEEPTIME);=0A=
+			if ((readl(&reg->outbound_msgaddr1) &=0A=
+			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
+				pr_err("arcmsr%d: waiting for "=0A=
+				"hw bus reset return, retry =3D %d\n",=0A=
+				acb->host->host_no, retry_count);=0A=
+				if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
+					acb->fw_flag =3D FW_DEADLOCK;=0A=
+					pr_err("arcmsr%d: waiting "=0A=
+					"for hw bus reset return, "=0A=
+					"RETRY TERMINATED!!\n",=0A=
+					acb->host->host_no);=0A=
+					return FAILED;=0A=
 				}=0A=
-				acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
-				/* disable all outbound interrupt */=0A=
-				intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-				arcmsr_get_firmware_spec(acb);=0A=
-				arcmsr_start_adapter_bgrb(acb);=0A=
-				/* clear Qbuffer if door bell ringed */=0A=
-				outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-				writel(outbound_doorbell, &reg->outbound_doorbell); /*clear =
interrupt */=0A=
-   				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, =
&reg->inbound_doorbell);=0A=
-				/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
-				arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				rtn =3D SUCCESS;=0A=
-				printk(KERN_ERR "arcmsr: scsi  bus reset eh returns with =
success\n");=0A=
-			} else {=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
-				rtn =3D SUCCESS;=0A=
+				retry_count++;=0A=
+				goto sleep_again;=0A=
 			}=0A=
-			break;=0A=
+			acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+			/* disable all outbound interrupt */=0A=
+			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+			arcmsr_get_firmware_spec(acb);=0A=
+			arcmsr_start_adapter_bgrb(acb);=0A=
+			/* clear Qbuffer if door bell ringed */=0A=
+			outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+			writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
+			writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,=0A=
+				&reg->inbound_doorbell);=0A=
+			arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer, jiffies +=0A=
+				msecs_to_jiffies(6 * HZ));=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			rtn =3D SUCCESS;=0A=
+			pr_err("arcmsr: scsi bus reset eh "=0A=
+			"returns with success\n");=0A=
+		} else {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+			jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			rtn =3D SUCCESS;=0A=
 		}=0A=
-		case ACB_ADAPTER_TYPE_B:{=0A=
-			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-			if (!arcmsr_iop_reset(acb)) {=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				rtn =3D FAILED;=0A=
-			} else {=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
-				rtn =3D SUCCESS;=0A=
-			}=0A=
-			break;=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+		if (!arcmsr_iop_reset(acb)) {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			rtn =3D FAILED;=0A=
+		} else {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			rtn =3D SUCCESS;=0A=
 		}=0A=
-		case ACB_ADAPTER_TYPE_C:{=0A=
-			if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
-				long timeout;=0A=
-				printk(KERN_ERR "arcmsr: there is an bus reset eh =
proceeding.......\n");=0A=
-				timeout =3D wait_event_timeout(wait_q, (acb->acb_flags & =
ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);=0A=
-				if (timeout) {=0A=
-					return SUCCESS;=0A=
-				}=0A=
-			}=0A=
-			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-			if (!arcmsr_iop_reset(acb)) {=0A=
-				struct MessageUnit_C __iomem *reg;=0A=
-				reg =3D acb->pmuC;=0A=
-				arcmsr_hardware_reset(acb);=0A=
-				acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
+			long timeout;=0A=
+			pr_err("arcmsr: there is an bus "=0A=
+			"reset eh proceeding.......\n");=0A=
+			timeout =3D wait_event_timeout(wait_q,=0A=
+			(acb->acb_flags & ACB_F_BUS_RESET) =3D=3D 0,=0A=
+			220 * HZ);=0A=
+			if (timeout) {=0A=
+				return SUCCESS;=0A=
+			}=0A=
+		}=0A=
+		acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+		if (!arcmsr_iop_reset(acb)) {=0A=
+			struct MessageUnit_C __iomem *reg;=0A=
+			reg =3D acb->pmuC;=0A=
+			arcmsr_hardware_reset(acb);=0A=
+			acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
 sleep:=0A=
-				ssleep(ARCMSR_SLEEPTIME);=0A=
-				if ((readl(&reg->host_diagnostic) & 0x04) !=3D 0) {=0A=
-					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, =
retry=3D%d\n", acb->host->host_no, retry_count);=0A=
-					if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
-						acb->fw_flag =3D FW_DEADLOCK;=0A=
-						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY =
TERMINATED!!\n", acb->host->host_no);=0A=
-						return FAILED;=0A=
-					}=0A=
-					retry_count++;=0A=
-					goto sleep;=0A=
+			ssleep(ARCMSR_SLEEPTIME);=0A=
+			if ((readl(&reg->host_diagnostic) & 0x04) !=3D 0) {=0A=
+				pr_err("arcmsr%d: waiting "=0A=
+				"for hw bus reset return, retry =3D %d\n",=0A=
+				acb->host->host_no, retry_count);=0A=
+				if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
+					acb->fw_flag =3D FW_DEADLOCK;=0A=
+					pr_err("arcmsr%d: "=0A=
+					"waiting for hw bus reset return, "=0A=
+					"RETRY TERMINATED!!\n",=0A=
+					acb->host->host_no);=0A=
+					return FAILED;=0A=
 				}=0A=
-				acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
-				/* disable all outbound interrupt */=0A=
-				intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-				arcmsr_get_firmware_spec(acb);=0A=
-				arcmsr_start_adapter_bgrb(acb);=0A=
-				/* clear Qbuffer if door bell ringed */=0A=
-				outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-				writel(outbound_doorbell, &reg->outbound_doorbell_clear); /*clear =
interrupt */=0A=
-				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
-				/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
-				arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				rtn =3D SUCCESS;=0A=
-				printk(KERN_ERR "arcmsr: scsi bus reset eh returns with success\n");=0A=
-			} else {=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
-				rtn =3D SUCCESS;=0A=
+				retry_count++;=0A=
+				goto sleep;=0A=
 			}=0A=
-			break;=0A=
+			acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+			/* disable all outbound interrupt */=0A=
+			intmask_org =3D=0A=
+			arcmsr_disable_outbound_ints(acb);=0A=
+			arcmsr_get_firmware_spec(acb);=0A=
+			arcmsr_start_adapter_bgrb(acb);=0A=
+			/* clear Qbuffer if door bell ringed */=0A=
+			outbound_doorbell =3D=0A=
+			readl(&reg->outbound_doorbell);=0A=
+			writel(outbound_doorbell,=0A=
+				&reg->outbound_doorbell_clear);=0A=
+			writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
+				&reg->inbound_doorbell);=0A=
+			arcmsr_enable_outbound_ints(acb,=0A=
+				intmask_org);=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer, jiffies +=0A=
+				msecs_to_jiffies(6 * HZ));=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			rtn =3D SUCCESS;=0A=
+			pr_err("arcmsr: scsi bus reset "=0A=
+			"eh returns with success\n");=0A=
+		} else {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
+			rtn =3D SUCCESS;=0A=
 		}=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,=0A=
+static int=0A=
+arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,=0A=
 		struct CommandControlBlock *ccb)=0A=
 {=0A=
 	int rtn;=0A=
@@ -3051,15 +3359,17 @@ static int arcmsr_abort_one_cmd(struct A=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_abort(struct scsi_cmnd *cmd)=0A=
+static int=0A=
+arcmsr_abort(struct scsi_cmnd *cmd)=0A=
 {=0A=
-	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *)cmd->device->host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *)=0A=
+		cmd->device->host->hostdata;=0A=
 	int i =3D 0;=0A=
 	int rtn =3D FAILED;=0A=
-	printk(KERN_NOTICE=0A=
-		"arcmsr%d: abort device command of scsi id =3D %d lun =3D %d \n",=0A=
-		acb->host->host_no, cmd->device->id, cmd->device->lun);=0A=
+	pr_notice("arcmsr%d: abort device command of "=0A=
+	"scsi id =3D %d lun =3D %d\n",=0A=
+	acb->host->host_no,=0A=
+	cmd->device->id, cmd->device->lun);=0A=
 	acb->acb_flags |=3D ACB_F_ABORT;=0A=
 	acb->num_aborts++;=0A=
 	/*=0A=
@@ -3073,7 +3383,8 @@ static int arcmsr_abort(struct scsi_cmnd=0A=
 =0A=
 	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
 		struct CommandControlBlock *ccb =3D acb->pccb_pool[i];=0A=
-		if (ccb->startdone =3D=3D ARCMSR_CCB_START && ccb->pcmd =3D=3D cmd) {=0A=
+		if (ccb->startdone =3D=3D ARCMSR_CCB_START &&=0A=
+			ccb->pcmd =3D=3D cmd) {=0A=
 			ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
 			rtn =3D arcmsr_abort_one_cmd(acb, ccb);=0A=
 			break;=0A=
@@ -3083,10 +3394,11 @@ static int arcmsr_abort(struct scsi_cmnd=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static const char *arcmsr_info(struct Scsi_Host *host)=0A=
+static const char=0A=
+*arcmsr_info(struct Scsi_Host *host)=0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+	(struct AdapterControlBlock *)host->hostdata;=0A=
 	static char buf[256];=0A=
 	char *type;=0A=
 	int raid6 =3D 1;=0A=
@@ -3125,3 +3437,4 @@ static const char *arcmsr_info(struct Sc=0A=
 			ARCMSR_DRIVER_VERSION);=0A=
 	return buf;=0A=
 }=0A=
+=0A=

------=_NextPart_000_0000_01CDD259.C55D22B0--

