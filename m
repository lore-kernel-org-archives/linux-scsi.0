From: James Bottomley <James.Bottomley@suse.de>
Subject: ses: add subenclosure support
Date: Fri, 18 Mar 2011 11:24:23 -0400
Message-ID: <1300461863.2632.2.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1CRPY2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2011 11:24:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 0A6E0867E2
	for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2011 16:24:27 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

There have been many complaints that an enclosure with subenclosures
isn't attached to by the ses driver.   Until now, though, no-one had
been willing to provide access to one.

Subenclosures are added simply by flattening the tree (i.e. all
subenclosure devices show up under the one main device).  This may have
consequences if the naming is only unique per subenclosure, but that's a
bug for another day.  The tested array had no page 7, so no device
naming at all.  It also only had the disk devices on one of its
subenclosures (all the others had power, fans, temperature and various
sensors), so testing of this is fairly rudimentary.

James

---

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 3b00e90..eb7a3e8 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -35,9 +35,11 @@
 
 struct ses_device {
 	unsigned char *page1;
+	unsigned char *page1_types;
 	unsigned char *page2;
 	unsigned char *page10;
 	short page1_len;
+	short page1_num_types;
 	short page2_len;
 	short page10_len;
 };
@@ -110,12 +112,12 @@ static int ses_set_page2_descriptor(struct enclosure_device *edev,
 	int i, j, count = 0, descriptor = ecomp->number;
 	struct scsi_device *sdev = to_scsi_device(edev->edev.parent);
 	struct ses_device *ses_dev = edev->scratch;
-	unsigned char *type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	unsigned char *type_ptr = ses_dev->page1_types;
 	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
 	/* Clear everything */
 	memset(desc_ptr, 0, ses_dev->page2_len - 8);
-	for (i = 0; i < ses_dev->page1[10]; i++, type_ptr += 4) {
+	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {
 		for (j = 0; j < type_ptr[1]; j++) {
 			desc_ptr += 4;
 			if (type_ptr[0] != ENCLOSURE_COMPONENT_DEVICE &&
@@ -140,12 +142,12 @@ static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
 	int i, j, count = 0, descriptor = ecomp->number;
 	struct scsi_device *sdev = to_scsi_device(edev->edev.parent);
 	struct ses_device *ses_dev = edev->scratch;
-	unsigned char *type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	unsigned char *type_ptr = ses_dev->page1_types;
 	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
 	ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len);
 
-	for (i = 0; i < ses_dev->page1[10]; i++, type_ptr += 4) {
+	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {
 		for (j = 0; j < type_ptr[1]; j++) {
 			desc_ptr += 4;
 			if (type_ptr[0] != ENCLOSURE_COMPONENT_DEVICE &&
@@ -358,7 +360,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 	unsigned char *buf = NULL, *type_ptr, *desc_ptr, *addl_desc_ptr = NULL;
 	int i, j, page7_len, len, components;
 	struct ses_device *ses_dev = edev->scratch;
-	int types = ses_dev->page1[10];
+	int types = ses_dev->page1_num_types;
 	unsigned char *hdr_buf = kzalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
 
 	if (!hdr_buf)
@@ -393,7 +395,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 	}
 	if (ses_dev->page10)
 		addl_desc_ptr = ses_dev->page10 + 8;
-	type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	type_ptr = ses_dev->page1_types;
 	components = 0;
 	for (i = 0; i < types; i++, type_ptr += 4) {
 		for (j = 0; j < type_ptr[1]; j++) {
@@ -503,6 +505,7 @@ static int ses_intf_add(struct device *cdev,
 	u32 result;
 	int i, types, len, components = 0;
 	int err = -ENOMEM;
+	int num_enclosures;
 	struct enclosure_device *edev;
 	struct ses_component *scomp = NULL;
 
@@ -530,16 +533,6 @@ static int ses_intf_add(struct device *cdev,
 	if (result)
 		goto recv_failed;
 
-	if (hdr_buf[1] != 0) {
-		/* FIXME: need subenclosure support; I've just never
-		 * seen a device with subenclosures and it makes the
-		 * traversal routines more complex */
-		sdev_printk(KERN_ERR, sdev,
-			"FIXME driver has no support for subenclosures (%d)\n",
-			hdr_buf[1]);
-		goto err_free;
-	}
-
 	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
@@ -549,11 +542,24 @@ static int ses_intf_add(struct device *cdev,
 	if (result)
 		goto recv_failed;
 
-	types = buf[10];
+	types = 0;
 
-	type_ptr = buf + 12 + buf[11];
+	/* we always have one main enclosure and the rest are referred
+	 * to as secondary subenclosures */
+	num_enclosures = buf[1] + 1;
 
-	for (i = 0; i < types; i++, type_ptr += 4) {
+	/* begin at the enclosure descriptor */
+	type_ptr = buf + 8;
+	/* skip all the enclosure descriptors */
+	for (i = 0; i < num_enclosures && type_ptr < buf + len; i++) {
+		types += type_ptr[2];
+		type_ptr += type_ptr[3] + 4;
+	}
+
+	ses_dev->page1_types = type_ptr;
+	ses_dev->page1_num_types = types;
+
+	for (i = 0; i < types && type_ptr < buf + len; i++, type_ptr += 4) {
 		if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
 		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components += type_ptr[1];


