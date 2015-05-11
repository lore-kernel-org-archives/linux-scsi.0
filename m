From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v7] scsi: esp_scsi: fix module reference for scsi host
Date: Mon, 11 May 2015 22:18:33 +0900
Message-ID: <1431350313-5009-3-git-send-email-akinobu.mita@gmail.com>
References: <1431350313-5009-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36360 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbbEKNTJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 09:19:09 -0400
Received: by pabsx10 with SMTP id sx10so109959850pab.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2015 06:19:08 -0700 (PDT)
In-Reply-To: <1431350313-5009-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

While accessing a scsi device on host adapter supported by sub driver
for the ESP chip (mac_esp, am53c974, sun_esp, jazz_esp, sun3x_esp),
the module reference count for ESP SCSI driver core module (esp_scsi)
is incremented but not incremented for actual sub drivers.  Because
these drivers allocate scsi hosts with scsi_esp_template defined in
the core module.  So these drivers always can be unloaded.

This fixes it by preparing scsi host template which is initialized at
module_init() for each esp sub driver.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/am53c974.c  |  7 +++++--
 drivers/scsi/esp_scsi.c  | 13 +++++++++++--
 drivers/scsi/esp_scsi.h  |  9 +++++++--
 drivers/scsi/jazz_esp.c  |  7 +++++--
 drivers/scsi/mac_esp.c   |  7 +++++--
 drivers/scsi/sun3x_esp.c |  7 +++++--
 drivers/scsi/sun_esp.c   |  7 +++++--
 7 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index beea30e..06dac4d 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -397,10 +397,11 @@ static void dc390_check_eeprom(struct esp *esp)
 		esp->config4 |= ESP_CONFIG4_RADE | ESP_CONFIG4_RAE;
 }
 
+static struct scsi_host_template pci_esp_template;
+
 static int pci_esp_probe_one(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
-	struct scsi_host_template *hostt = &scsi_esp_template;
 	int err = -ENODEV;
 	struct Scsi_Host *shost;
 	struct esp *esp;
@@ -417,7 +418,7 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 		goto fail_disable_device;
 	}
 
-	shost = scsi_host_alloc(hostt, sizeof(struct esp));
+	shost = scsi_host_alloc(&pci_esp_template, sizeof(struct esp));
 	if (!shost) {
 		dev_printk(KERN_INFO, &pdev->dev,
 			   "failed to allocate scsi host\n");
@@ -558,6 +559,8 @@ static struct pci_driver am53c974_driver = {
 
 static int __init am53c974_module_init(void)
 {
+	scsi_esp_template_init(&pci_esp_template, DRV_MODULE_NAME);
+
 	return pci_register_driver(&am53c974_driver);
 }
 
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 065b25d..c61d2de 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2675,7 +2675,7 @@ static const char *esp_info(struct Scsi_Host *host)
 	return "esp";
 }
 
-struct scsi_host_template scsi_esp_template = {
+static const struct scsi_host_template scsi_esp_template = {
 	.module			= THIS_MODULE,
 	.name			= "esp",
 	.info			= esp_info,
@@ -2696,7 +2696,16 @@ struct scsi_host_template scsi_esp_template = {
 	.skip_settle_delay	= 1,
 	.use_blk_tags		= 1,
 };
-EXPORT_SYMBOL(scsi_esp_template);
+
+void __scsi_esp_template_init(struct scsi_host_template *sht, const char *name,
+			      struct module *owner)
+{
+	*sht = scsi_esp_template;
+	sht->name = name;
+	sht->proc_name = name;
+	sht->module = owner;
+}
+EXPORT_SYMBOL(__scsi_esp_template_init);
 
 static void esp_get_signalling(struct Scsi_Host *host)
 {
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 84dcbe4..a03dbed 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -544,9 +544,11 @@ struct esp {
 
 /* A front-end driver for the ESP chip should do the following in
  * it's device probe routine:
+ * 0) Declare the scsi_host_template and initialize it using
+ *    scsi_esp_template_init() with the driver name in module_init().
  * 1) Allocate the host and private area using scsi_host_alloc()
  *    with size 'sizeof(struct esp)'.  The first argument to
- *    scsi_host_alloc() should be &scsi_esp_template.
+ *    scsi_host_alloc() should be the scsi_host_template initialized in 0)
  * 2) Set host->max_id as appropriate.
  * 3) Set esp->host to the scsi_host itself, and esp->dev
  *    to the device object pointer.
@@ -573,7 +575,10 @@ struct esp {
  * 13) Check scsi_esp_register() return value, release all resources
  *     if an error was returned.
  */
-extern struct scsi_host_template scsi_esp_template;
+extern void __scsi_esp_template_init(struct scsi_host_template *sht,
+				     const char *name, struct module *owner);
+#define scsi_esp_template_init(sht, name) \
+	__scsi_esp_template_init(sht, name, THIS_MODULE)
 extern int scsi_esp_register(struct esp *, struct device *);
 
 extern void scsi_esp_unregister(struct esp *);
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 9aaa74e..d51025c 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -129,15 +129,16 @@ static const struct esp_driver_ops jazz_esp_ops = {
 	.dma_error	=	jazz_esp_dma_error,
 };
 
+static struct scsi_host_template esp_jazz_template;
+
 static int esp_jazz_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	struct resource *res;
 	int err;
 
-	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	host = scsi_host_alloc(&esp_jazz_template, sizeof(struct esp));
 
 	err = -ENOMEM;
 	if (!host)
@@ -231,6 +232,8 @@ static struct platform_driver esp_jazz_driver = {
 
 static int __init jazz_esp_init(void)
 {
+	scsi_esp_template_init(&esp_jazz_template, DRV_MODULE_NAME);
+
 	return platform_driver_register(&esp_jazz_driver);
 }
 
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 14c0334..81317b1 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -481,9 +481,10 @@ static struct esp_driver_ops mac_esp_ops = {
 	.dma_error        = mac_esp_dma_error,
 };
 
+static struct scsi_host_template esp_mac_template;
+
 static int esp_mac_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	int err;
@@ -495,7 +496,7 @@ static int esp_mac_probe(struct platform_device *dev)
 	if (dev->id > 1)
 		return -ENODEV;
 
-	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	host = scsi_host_alloc(&esp_mac_template, sizeof(struct esp));
 
 	err = -ENOMEM;
 	if (!host)
@@ -622,6 +623,8 @@ static struct platform_driver esp_mac_driver = {
 
 static int __init mac_esp_init(void)
 {
+	scsi_esp_template_init(&esp_mac_template, DRV_MODULE_NAME);
+
 	return platform_driver_register(&esp_mac_driver);
 }
 
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index e26e81d..06f6f84 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -194,15 +194,16 @@ static const struct esp_driver_ops sun3x_esp_ops = {
 	.dma_error	=	sun3x_esp_dma_error,
 };
 
+static struct scsi_host_template esp_sun3x_template;
+
 static int esp_sun3x_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	struct resource *res;
 	int err = -ENOMEM;
 
-	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	host = scsi_host_alloc(&esp_sun3x_template, sizeof(struct esp));
 	if (!host)
 		goto fail;
 
@@ -300,6 +301,8 @@ static struct platform_driver esp_sun3x_driver = {
 
 static int __init sun3x_esp_init(void)
 {
+	scsi_esp_template_init(&esp_sun3x_template, DRV_MODULE_NAME);
+
 	return platform_driver_register(&esp_sun3x_driver);
 }
 
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 7b6d4c2..2534bdc 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -486,15 +486,16 @@ static const struct esp_driver_ops sbus_esp_ops = {
 	.dma_error	=	sbus_esp_dma_error,
 };
 
+static struct scsi_host_template esp_sbus_template;
+
 static int esp_sbus_probe_one(struct platform_device *op,
 			      struct platform_device *espdma, int hme)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	int err;
 
-	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	host = scsi_host_alloc(&esp_sbus_template, sizeof(struct esp));
 
 	err = -ENOMEM;
 	if (!host)
@@ -641,6 +642,8 @@ static struct platform_driver esp_sbus_driver = {
 
 static int __init sunesp_init(void)
 {
+	scsi_esp_template_init(&esp_sbus_template, DRV_MODULE_NAME);
+
 	return platform_driver_register(&esp_sbus_driver);
 }
 
-- 
1.9.1

