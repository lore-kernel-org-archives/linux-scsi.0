From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] scsi: ses fix mem leaking when fail to add intf
Date: Sat, 09 Feb 2008 15:15:47 -0800
Message-ID: <200802091515.48076.yinghai.lu@sun.com>
References: <200802090413.53275.yinghai.lu@sun.com>
 <1202569242.4254.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1202569242.4254.9.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com
List-Id: linux-scsi@vger.kernel.org

[PATCH] scsi: ses fix mem leaking when fail to add intf

fix leaking with scomp leaking when failing.
also remove one extra space.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/drivers/scsi/ses.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ses.c
+++ linux-2.6/drivers/scsi/ses.c
@@ -416,11 +416,11 @@ static int ses_intf_add(struct class_dev
 	int i, j, types, len, components = 0;
 	int err = -ENOMEM;
 	struct enclosure_device *edev;
-	struct ses_component *scomp;
+	struct ses_component *scomp = NULL;
 
 	if (!scsi_device_enclosure(sdev)) {
 		/* not an enclosure, but might be in one */
-		edev = 	enclosure_find(&sdev->host->shost_gendev);
+		edev = enclosure_find(&sdev->host->shost_gendev);
 		if (edev) {
 			ses_match_to_enclosure(edev, sdev);
 			class_device_put(&edev->cdev);
@@ -456,9 +456,6 @@ static int ses_intf_add(struct class_dev
 	if (!buf)
 		goto err_free;
 
-	ses_dev->page1 = buf;
-	ses_dev->page1_len = len;
-
 	result = ses_recv_diag(sdev, 1, buf, len);
 	if (result)
 		goto recv_failed;
@@ -473,6 +470,9 @@ static int ses_intf_add(struct class_dev
 		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components += type_ptr[1];
 	}
+	ses_dev->page1 = buf;
+	ses_dev->page1_len = len;
+	buf = NULL;
 
 	result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
@@ -489,6 +489,7 @@ static int ses_intf_add(struct class_dev
 		goto recv_failed;
 	ses_dev->page2 = buf;
 	ses_dev->page2_len = len;
+	buf = NULL;
 
 	/* The additional information page --- allows us
 	 * to match up the devices */
@@ -506,11 +507,26 @@ static int ses_intf_add(struct class_dev
 		goto recv_failed;
 	ses_dev->page10 = buf;
 	ses_dev->page10_len = len;
+	buf = NULL;
 
  no_page10:
-	scomp = kmalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
+
+	/* Page 7 for the descriptors is optional */
+	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
+	if (result)
+		goto simple_populate;
+
+	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	/* add 1 for trailing '\0' we'll use */
+	buf = kzalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		goto err_free;
+	result = ses_recv_diag(sdev, 7, buf, len);
+
+ simple_populate:
+	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
-		goto  err_free;
+		goto err_free;
 
 	edev = enclosure_register(cdev->dev, sdev->sdev_gendev.bus_id,
 				  components, &ses_enclosure_callbacks);
@@ -521,20 +537,10 @@ static int ses_intf_add(struct class_dev
 
 	edev->scratch = ses_dev;
 	for (i = 0; i < components; i++)
-		edev->component[i].scratch = scomp++;
+		edev->component[i].scratch = scomp + i;
 
-	/* Page 7 for the descriptors is optional */
-	buf = NULL;
-	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
-	if (result)
-		goto simple_populate;
-
-	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
-	/* add 1 for trailing '\0' we'll use */
-	buf = kzalloc(len + 1, GFP_KERNEL);
-	result = ses_recv_diag(sdev, 7, buf, len);
+	/* result and buf from page 7 check */
 	if (result) {
- simple_populate:
 		kfree(buf);
 		buf = NULL;
 		desc_ptr = NULL;
@@ -598,6 +604,7 @@ static int ses_intf_add(struct class_dev
 	err = -ENODEV;
  err_free:
 	kfree(buf);
+	kfree(scomp);
 	kfree(ses_dev->page10);
 	kfree(ses_dev->page2);
 	kfree(ses_dev->page1);
@@ -630,6 +637,7 @@ static void ses_intf_remove(struct class
 	ses_dev = edev->scratch;
 	edev->scratch = NULL;
 
+	kfree(ses_dev->page10);
 	kfree(ses_dev->page1);
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
