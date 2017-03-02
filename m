From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] scsi: remove incorrect __exit markups
Date: Wed, 1 Mar 2017 17:38:38 -0800
Message-ID: <20170302013838.GA4489@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35030 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753448AbdCBBox (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 20:44:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Even if bus is not hot-pluggable, devices can be unbound from the
driver via sysfs, so we should not be using __exit annotations on
remove() methods. The only exception is drivers registered with
platform_driver_probe() which specifically disables sysfs bind/unbind
attributes.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/scsi/sgiwd93.c    | 2 +-
 drivers/scsi/sni_53c710.c | 2 +-
 drivers/scsi/zalon.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 6d215e2fb46d..71b4b91d2215 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -297,7 +297,7 @@ static int sgiwd93_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __exit sgiwd93_remove(struct platform_device *pdev)
+static int sgiwd93_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(pdev);
 	struct ip22_hostdata *hdata = (struct ip22_hostdata *) host->hostdata;
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 76278072147e..1f9a087daf69 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -117,7 +117,7 @@ static int snirm710_probe(struct platform_device *dev)
 	return -ENODEV;
 }
 
-static int __exit snirm710_driver_remove(struct platform_device *dev)
+static int snirm710_driver_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
 	struct NCR_700_Host_Parameters *hostdata =
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 97ccb0383539..b2cf1faa819d 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -167,7 +167,7 @@ static struct parisc_device_id zalon_tbl[] = {
 
 MODULE_DEVICE_TABLE(parisc, zalon_tbl);
 
-static int __exit zalon_remove(struct parisc_device *dev)
+static int zalon_remove(struct parisc_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
 
-- 
2.12.0.rc1.440.g5b76565f74-goog


-- 
Dmitry
