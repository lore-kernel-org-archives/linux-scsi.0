From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] SCSI: fix data corruption caused by ses v2
Date: Wed, 13 Feb 2008 16:25:16 -0800
Message-ID: <200802131625.17172.yinghai.lu@sun.com>
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802122310.23050.yinghai.lu@sun.com>
 <1202945127.3109.89.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61262 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762743AbYBNARV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 19:17:21 -0500
In-reply-to: <1202945127.3109.89.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>


one system: initrd get courrupted:

RAMDISK: Compressed image found at block 0
RAMDISK: incomplete write (-28 != 2048) 134217728
crc error
VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 388k freed
init_special_inode: bogus i_mode (177777)
Warning: unable to open an initial console.
init_special_inode: bogus i_mode (177777)
init_special_inode: bogus i_mode (177777)
Kernel panic - not syncing: No init found.  Try passing init= option to kernel.

bisected to
commit 9927c68864e9c39cc317b4f559309ba29e642168
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sun Feb 3 15:48:56 2008 -0600

    [SCSI] ses: add new Enclosure ULD

changes:
1. change char to unsigned char to avoid type change later.
2. preserve len for page1
3. need to move desc_ptr even the entry is not enclosure_component_device/raid.
   so keep desc_ptr on right position
4. record page7 len, and double check if desc_ptr out of boundary before touch.
5. fix typo in subenclosure checking: should use hdr_buf instead.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/drivers/scsi/ses.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ses.c
+++ linux-2.6/drivers/scsi/ses.c
@@ -33,9 +33,9 @@
 #include <scsi/scsi_host.h>
 
 struct ses_device {
-	char *page1;
-	char *page2;
-	char *page10;
+	unsigned char *page1;
+	unsigned char *page2;
+	unsigned char *page10;
 	short page1_len;
 	short page2_len;
 	short page10_len;
@@ -67,7 +66,7 @@ static int ses_probe(struct device *dev)
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
-	char cmd[] = {
+	unsigned char cmd[] = {
 		RECEIVE_DIAGNOSTIC,
 		1,		/* Set PCV bit */
 		page_code,
@@ -85,7 +84,7 @@ static int ses_send_diag(struct scsi_dev
 {
 	u32 result;
 
-	char cmd[] = {
+	unsigned char cmd[] = {
 		SEND_DIAGNOSTIC,
 		0x10,		/* Set PF bit */
 		0,
@@ -104,13 +103,13 @@ static int ses_send_diag(struct scsi_dev
 
 static int ses_set_page2_descriptor(struct enclosure_device *edev,
 				      struct enclosure_component *ecomp,
-				      char *desc)
+				      unsigned char *desc)
 {
 	int i, j, count = 0, descriptor = ecomp->number;
 	struct scsi_device *sdev = to_scsi_device(edev->cdev.dev);
 	struct ses_device *ses_dev = edev->scratch;
-	char *type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
-	char *desc_ptr = ses_dev->page2 + 8;
+	unsigned char *type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
 	/* Clear everything */
 	memset(desc_ptr, 0, ses_dev->page2_len - 8);
@@ -133,14 +132,14 @@ static int ses_set_page2_descriptor(stru
 	return ses_send_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len);
 }
 
-static char *ses_get_page2_descriptor(struct enclosure_device *edev,
+static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
 				      struct enclosure_component *ecomp)
 {
 	int i, j, count = 0, descriptor = ecomp->number;
 	struct scsi_device *sdev = to_scsi_device(edev->cdev.dev);
 	struct ses_device *ses_dev = edev->scratch;
-	char *type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
-	char *desc_ptr = ses_dev->page2 + 8;
+	unsigned char *type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
 	ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len);
 
@@ -160,17 +159,18 @@ static char *ses_get_page2_descriptor(st
 static void ses_get_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp)
 {
-	char *desc;
+	unsigned char *desc;
 
 	desc = ses_get_page2_descriptor(edev, ecomp);
-	ecomp->fault = (desc[3] & 0x60) >> 4;
+	if (desc)
+		ecomp->fault = (desc[3] & 0x60) >> 4;
 }
 
 static int ses_set_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp,
 			 enum enclosure_component_setting val)
 {
-	char desc[4] = {0 };
+	unsigned char desc[4] = {0 };
 
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
@@ -190,26 +190,28 @@ static int ses_set_fault(struct enclosur
 static void ses_get_status(struct enclosure_device *edev,
 			   struct enclosure_component *ecomp)
 {
-	char *desc;
+	unsigned char *desc;
 
 	desc = ses_get_page2_descriptor(edev, ecomp);
-	ecomp->status = (desc[0] & 0x0f);
+	if (desc)
+		ecomp->status = (desc[0] & 0x0f);
 }
 
 static void ses_get_locate(struct enclosure_device *edev,
 			   struct enclosure_component *ecomp)
 {
-	char *desc;
+	unsigned char *desc;
 
 	desc = ses_get_page2_descriptor(edev, ecomp);
-	ecomp->locate = (desc[2] & 0x02) ? 1 : 0;
+	if (desc)
+		ecomp->locate = (desc[2] & 0x02) ? 1 : 0;
 }
 
 static int ses_set_locate(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp,
 			  enum enclosure_component_setting val)
 {
-	char desc[4] = {0 };
+	unsigned char desc[4] = {0 };
 
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
@@ -229,7 +231,7 @@ static int ses_set_active(struct enclosu
 			  struct enclosure_component *ecomp,
 			  enum enclosure_component_setting val)
 {
-	char desc[4] = {0 };
+	unsigned char desc[4] = {0 };
 
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
@@ -409,11 +409,11 @@ static int ses_intf_add(struct class_dev
 {
 	struct scsi_device *sdev = to_scsi_device(cdev->dev);
 	struct scsi_device *tmp_sdev;
-	unsigned char *buf = NULL, *hdr_buf, *type_ptr, *desc_ptr,
-		*addl_desc_ptr;
+	unsigned char *buf = NULL, *hdr_buf, *type_ptr, *desc_ptr = NULL,
+		*addl_desc_ptr = NULL;
 	struct ses_device *ses_dev;
 	u32 result;
-	int i, j, types, len, components = 0;
+	int i, j, types, len, page7_len = 0, components = 0;
 	int err = -ENOMEM;
 	struct enclosure_device *edev;
 	struct ses_component *scomp = NULL;
@@ -447,7 +447,7 @@ static int ses_intf_add(struct class_dev
 		 * traversal routines more complex */
 		sdev_printk(KERN_ERR, sdev,
 			"FIXME driver has no support for subenclosures (%d)\n",
-			buf[1]);
+			hdr_buf[1]);
 		goto err_free;
 	}
 
@@ -461,9 +461,8 @@ static int ses_intf_add(struct class_dev
 		goto recv_failed;
 
 	types = buf[10];
-	len = buf[11];
 
-	type_ptr = buf + 12 + len;
+	type_ptr = buf + 12 + buf[11];
 
 	for (i = 0; i < types; i++, type_ptr += 4) {
 		if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
@@ -494,22 +493,21 @@ static int ses_intf_add(struct class_dev
 	/* The additional information page --- allows us
 	 * to match up the devices */
 	result = ses_recv_diag(sdev, 10, hdr_buf, INIT_ALLOC_SIZE);
-	if (result)
-		goto no_page10;
+	if (!result) {
 
-	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
-	buf = kzalloc(len, GFP_KERNEL);
-	if (!buf)
-		goto err_free;
-
-	result = ses_recv_diag(sdev, 10, buf, len);
-	if (result)
-		goto recv_failed;
-	ses_dev->page10 = buf;
-	ses_dev->page10_len = len;
-	buf = NULL;
+		len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+		buf = kzalloc(len, GFP_KERNEL);
+		if (!buf)
+			goto err_free;
+
+		result = ses_recv_diag(sdev, 10, buf, len);
+		if (result)
+			goto recv_failed;
+		ses_dev->page10 = buf;
+		ses_dev->page10_len = len;
+		buf = NULL;
+	}
 
- no_page10:
 	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
 		goto err_free;
@@ -530,7 +528,7 @@ static int ses_intf_add(struct class_dev
 	if (result)
 		goto simple_populate;
 
-	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	page7_len = len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	/* add 1 for trailing '\0' we'll use */
 	buf = kzalloc(len + 1, GFP_KERNEL);
 	if (!buf)
@@ -547,7 +545,8 @@ static int ses_intf_add(struct class_dev
 		len = (desc_ptr[2] << 8) + desc_ptr[3];
 		/* skip past overall descriptor */
 		desc_ptr += len + 4;
-		addl_desc_ptr = ses_dev->page10 + 8;
+		if (ses_dev->page10)
+			addl_desc_ptr = ses_dev->page10 + 8;
 	}
 	type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
 	components = 0;
@@ -557,6 +556,10 @@ static int ses_intf_add(struct class_dev
 			struct enclosure_component *ecomp;
 
 			if (desc_ptr) {
+				if (desc_ptr >= buf + page7_len) {
+					desc_ptr = NULL;
+					goto noname;
+				}
 				len = (desc_ptr[2] << 8) + desc_ptr[3];
 				desc_ptr += 4;
 				/* Add trailing zero - pushes into
@@ -564,22 +567,25 @@ static int ses_intf_add(struct class_dev
 				desc_ptr[len] = '\0';
 				name = desc_ptr;
 			}
-			if (type_ptr[0] != ENCLOSURE_COMPONENT_DEVICE &&
-			    type_ptr[0] != ENCLOSURE_COMPONENT_ARRAY_DEVICE)
-				continue;
-			ecomp =	enclosure_component_register(edev,
+		noname:
+			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
+			    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE) {
+
+				ecomp =	enclosure_component_register(edev,
 							     components++,
 							     type_ptr[0],
 							     name);
-			if (desc_ptr) {
-				desc_ptr += len;
-				if (!IS_ERR(ecomp))
+
+				if (!IS_ERR(ecomp) && addl_desc_ptr)
 					ses_process_descriptor(ecomp,
 							       addl_desc_ptr);
-
-				if (addl_desc_ptr)
-					addl_desc_ptr += addl_desc_ptr[1] + 2;
 			}
+			if (desc_ptr)
+				desc_ptr += len;
+
+			if (addl_desc_ptr)
+				addl_desc_ptr += addl_desc_ptr[1] + 2;
+
 		}
 	}
 	kfree(buf);
