From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] scsi: ses fix for len and mem leaking when fail to add intf
Date: Sat, 09 Feb 2008 04:13:52 -0800
Message-ID: <200802090413.53275.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com
List-Id: linux-scsi@vger.kernel.org

[PATCH] scsi: ses fix for len and mem leaking when fail to add intf

change to u32 before left shifting char
also fix leaking with scomp leaking when failing.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/drivers/scsi/ses.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ses.c
+++ linux-2.6/drivers/scsi/ses.c
@@ -369,7 +369,7 @@ static void ses_match_to_enclosure(struc
 			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
 		goto free;
 
-	len = (buf[2] << 8) + buf[3];
+	len = ((u32)buf[2] << 8) + buf[3];
 	desc = buf + 4;
 	while (desc < buf + len) {
 		enum scsi_protocol proto = desc[0] >> 4;
@@ -420,7 +420,7 @@ static int ses_intf_add(struct class_dev
 
 	if (!scsi_device_enclosure(sdev)) {
 		/* not an enclosure, but might be in one */
-		edev = 	enclosure_find(&sdev->host->shost_gendev);
+		edev = enclosure_find(&sdev->host->shost_gendev);
 		if (edev) {
 			ses_match_to_enclosure(edev, sdev);
 			class_device_put(&edev->cdev);
@@ -451,18 +451,18 @@ static int ses_intf_add(struct class_dev
 		goto err_free;
 	}
 
-	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	len = ((u32)hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
 		goto err_free;
 
-	ses_dev->page1 = buf;
-	ses_dev->page1_len = len;
-
 	result = ses_recv_diag(sdev, 1, buf, len);
 	if (result)
 		goto recv_failed;
 
+	ses_dev->page1 = buf;
+	ses_dev->page1_len = len;
+
 	types = buf[10];
 	len = buf[11];
 
@@ -474,11 +474,12 @@ static int ses_intf_add(struct class_dev
 			components += type_ptr[1];
 	}
 
+	buf = NULL;
 	result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
 		goto recv_failed;
 
-	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	len = ((u32)hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
 		goto err_free;
@@ -492,11 +493,12 @@ static int ses_intf_add(struct class_dev
 
 	/* The additional information page --- allows us
 	 * to match up the devices */
+	buf = NULL;
 	result = ses_recv_diag(sdev, 10, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
 		goto no_page10;
 
-	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	len = ((u32)hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
 		goto err_free;
@@ -506,16 +508,18 @@ static int ses_intf_add(struct class_dev
 		goto recv_failed;
 	ses_dev->page10 = buf;
 	ses_dev->page10_len = len;
+	buf = NULL;
 
  no_page10:
 	scomp = kmalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
-		goto  err_free;
+		goto err_free;
 
 	edev = enclosure_register(cdev->dev, sdev->sdev_gendev.bus_id,
 				  components, &ses_enclosure_callbacks);
 	if (IS_ERR(edev)) {
 		err = PTR_ERR(edev);
+		kfree(scomp);
 		goto err_free;
 	}
 
@@ -524,24 +528,27 @@ static int ses_intf_add(struct class_dev
 		edev->component[i].scratch = scomp++;
 
 	/* Page 7 for the descriptors is optional */
-	buf = NULL;
 	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
 		goto simple_populate;
 
-	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	len = ((u32)hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	/* add 1 for trailing '\0' we'll use */
 	buf = kzalloc(len + 1, GFP_KERNEL);
-	result = ses_recv_diag(sdev, 7, buf, len);
-	if (result) {
+	if (buf)
+		result = ses_recv_diag(sdev, 7, buf, len);
+	else
+		result = 7;
+
  simple_populate:
+	if (result) {
 		kfree(buf);
 		buf = NULL;
 		desc_ptr = NULL;
 		addl_desc_ptr = NULL;
 	} else {
 		desc_ptr = buf + 8;
-		len = (desc_ptr[2] << 8) + desc_ptr[3];
+		len = ((u32)desc_ptr[2] << 8) + desc_ptr[3];
 		/* skip past overall descriptor */
 		desc_ptr += len + 4;
 		addl_desc_ptr = ses_dev->page10 + 8;
@@ -554,7 +561,7 @@ static int ses_intf_add(struct class_dev
 			struct enclosure_component *ecomp;
 
 			if (desc_ptr) {
-				len = (desc_ptr[2] << 8) + desc_ptr[3];
+				len = ((u32)desc_ptr[2] << 8) + desc_ptr[3];
 				desc_ptr += 4;
 				/* Add trailing zero - pushes into
 				 * reserved space */
@@ -575,7 +582,7 @@ static int ses_intf_add(struct class_dev
 							       addl_desc_ptr);
 
 				if (addl_desc_ptr)
-					addl_desc_ptr += addl_desc_ptr[1] + 2;
+					addl_desc_ptr += 2 + addl_desc_ptr[1];
 			}
 		}
 	}
@@ -597,7 +604,6 @@ static int ses_intf_add(struct class_dev
 		    result);
 	err = -ENODEV;
  err_free:
-	kfree(buf);
 	kfree(ses_dev->page10);
 	kfree(ses_dev->page2);
 	kfree(ses_dev->page1);
@@ -630,6 +636,7 @@ static void ses_intf_remove(struct class
 	ses_dev = edev->scratch;
 	edev->scratch = NULL;
 
+	kfree(ses_dev->page10);
 	kfree(ses_dev->page1);
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
