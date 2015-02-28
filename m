From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v5 4/4] scsi: esp_scsi: adjust module reference for scsi host
Date: Sat, 28 Feb 2015 23:16:57 +0900
Message-ID: <1425133017-7216-5-git-send-email-akinobu.mita@gmail.com>
References: <1425133017-7216-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39949 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbbB1ORl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 09:17:41 -0500
Received: by paceu11 with SMTP id eu11so30310650pac.7
        for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2015 06:17:41 -0800 (PST)
In-Reply-To: <1425133017-7216-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

While accessing a scsi device on host adapter supported by sub driver for
the ESP chip (mac_esp, am53c974, sun_esp, jazz_esp, sun3x_esp), the module
reference count is not incremented.  Because these drivers allocate scsi
hosts with scsi_esp_template defined in ESP SCSI driver core module.  So
these drivers always can be unloaded.

This fixes it by passing correct module reference to newly introduced
scsi_esp_host_alloc() so that .module field in struct Scsi_Host can be
adjusted.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
No change from v3

 drivers/scsi/am53c974.c  |  3 +--
 drivers/scsi/esp_scsi.c  | 16 +++++++++++++---
 drivers/scsi/esp_scsi.h  | 11 +++++++----
 drivers/scsi/jazz_esp.c  |  3 +--
 drivers/scsi/mac_esp.c   |  3 +--
 drivers/scsi/sun3x_esp.c |  3 +--
 drivers/scsi/sun_esp.c   |  3 +--
 7 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index a6f5ee8..3b53f01 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -400,7 +400,6 @@ static void dc390_check_eeprom(struct esp *esp)
 static int pci_esp_probe_one(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
-	struct scsi_host_template *hostt = &scsi_esp_template;
 	int err = -ENODEV;
 	struct Scsi_Host *shost;
 	struct esp *esp;
@@ -417,7 +416,7 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 		goto fail_disable_device;
 	}
 
-	shost = scsi_host_alloc(hostt, sizeof(struct esp));
+	shost = scsi_esp_host_alloc(sizeof(struct esp));
 	if (!shost) {
 		dev_printk(KERN_INFO, &pdev->dev,
 			   "failed to allocate scsi host\n");
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 065b25d..4484c90 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2675,8 +2675,7 @@ static const char *esp_info(struct Scsi_Host *host)
 	return "esp";
 }
 
-struct scsi_host_template scsi_esp_template = {
-	.module			= THIS_MODULE,
+static struct scsi_host_template scsi_esp_template = {
 	.name			= "esp",
 	.info			= esp_info,
 	.queuecommand		= esp_queuecommand,
@@ -2696,7 +2695,18 @@ struct scsi_host_template scsi_esp_template = {
 	.skip_settle_delay	= 1,
 	.use_blk_tags		= 1,
 };
-EXPORT_SYMBOL(scsi_esp_template);
+
+struct Scsi_Host *__scsi_esp_host_alloc(int privsize, struct module *owner)
+{
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_alloc(&scsi_esp_template, privsize);
+	if (shost)
+		shost->module = owner;
+
+	return shost;
+}
+EXPORT_SYMBOL(__scsi_esp_host_alloc);
 
 static void esp_get_signalling(struct Scsi_Host *host)
 {
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 84dcbe4..9309e08 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -544,9 +544,8 @@ struct esp {
 
 /* A front-end driver for the ESP chip should do the following in
  * it's device probe routine:
- * 1) Allocate the host and private area using scsi_host_alloc()
- *    with size 'sizeof(struct esp)'.  The first argument to
- *    scsi_host_alloc() should be &scsi_esp_template.
+ * 1) Allocate the host and private area using scsi_esp_host_alloc()
+ *    with size 'sizeof(struct esp)'.
  * 2) Set host->max_id as appropriate.
  * 3) Set esp->host to the scsi_host itself, and esp->dev
  *    to the device object pointer.
@@ -573,7 +572,11 @@ struct esp {
  * 13) Check scsi_esp_register() return value, release all resources
  *     if an error was returned.
  */
-extern struct scsi_host_template scsi_esp_template;
+extern struct Scsi_Host *__scsi_esp_host_alloc(int privsize,
+						struct module *owner);
+#define scsi_esp_host_alloc(privsize)	\
+	__scsi_esp_host_alloc(privsize, THIS_MODULE)
+
 extern int scsi_esp_register(struct esp *, struct device *);
 
 extern void scsi_esp_unregister(struct esp *);
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 9aaa74e..9c268f7 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -131,13 +131,12 @@ static const struct esp_driver_ops jazz_esp_ops = {
 
 static int esp_jazz_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	struct resource *res;
 	int err;
 
-	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	host = scsi_esp_host_alloc(sizeof(struct esp));
 
 	err = -ENOMEM;
 	if (!host)
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 14c0334..ad4ad71 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -483,7 +483,6 @@ static struct esp_driver_ops mac_esp_ops = {
 
 static int esp_mac_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	int err;
@@ -495,7 +494,7 @@ static int esp_mac_probe(struct platform_device *dev)
 	if (dev->id > 1)
 		return -ENODEV;
 
-	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	host = scsi_esp_host_alloc(sizeof(struct esp));
 
 	err = -ENOMEM;
 	if (!host)
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index e26e81d..adb4368 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -196,13 +196,12 @@ static const struct esp_driver_ops sun3x_esp_ops = {
 
 static int esp_sun3x_probe(struct platform_device *dev)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	struct resource *res;
 	int err = -ENOMEM;
 
-	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	host = scsi_esp_host_alloc(sizeof(struct esp));
 	if (!host)
 		goto fail;
 
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 7b6d4c2..1449bea 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -489,12 +489,11 @@ static const struct esp_driver_ops sbus_esp_ops = {
 static int esp_sbus_probe_one(struct platform_device *op,
 			      struct platform_device *espdma, int hme)
 {
-	struct scsi_host_template *tpnt = &scsi_esp_template;
 	struct Scsi_Host *host;
 	struct esp *esp;
 	int err;
 
-	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+	host = scsi_esp_host_alloc(sizeof(struct esp));
 
 	err = -ENOMEM;
 	if (!host)
-- 
1.9.1

