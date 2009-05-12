From: akpm@linux-foundation.org
Subject: [patch 8/9] scsi: ses check name in enclosure_component_register()
Date: Tue, 12 May 2009 13:49:48 -0700
Message-ID: <200905122109.n4CL93Do011437@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406AbZELVbk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 17:31:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, yinghai@kernel.org, James.Bottomley@HansenPartnership.com

From: Yinghai Lu <yinghai@kernel.org>

dev_set_name will use sprintf to copy the name.  need to check if the name
does valid.

Otherwise the code will error from device_add() later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/enclosure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/enclosure.c~scsi-ses-check-name-in-enclosure_component_register-v2 drivers/misc/enclosure.c
--- a/drivers/misc/enclosure.c~scsi-ses-check-name-in-enclosure_component_register-v2
+++ a/drivers/misc/enclosure.c
@@ -119,7 +119,7 @@ enclosure_register(struct device *dev, c
 	edev->edev.class = &enclosure_class;
 	edev->edev.parent = get_device(dev);
 	edev->cb = cb;
-	dev_set_name(&edev->edev, name);
+	dev_set_name(&edev->edev, "%s", name);
 	err = device_register(&edev->edev);
 	if (err)
 		goto err;
@@ -255,8 +255,8 @@ enclosure_component_register(struct encl
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	if (name)
-		dev_set_name(cdev, name);
+	if (name && name[0])
+		dev_set_name(cdev, "%s", name);
 	else
 		dev_set_name(cdev, "%u", number);
 
_
