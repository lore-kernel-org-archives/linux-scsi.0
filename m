From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 11/16] pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (scsi)
Date: Sat, 24 Oct 2009 21:43:01 +0200
Message-ID: <1256413386-20501-11-git-send-email-linux@dominikbrodowski.net>
References: <20091024194219.GA19546@comet.dominikbrodowski.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:55644 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751312AbZJXTnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2009 15:43:12 -0400
In-Reply-To: <20091024194219.GA19546@comet.dominikbrodowski.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-pcmcia@lists.infradead.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, linux-scsi@vger.kernel.org

Convert PCMCIA drivers to use the dynamic debug infrastructure, instead of
requiring manual settings of PCMCIA_DEBUG.

Also, remove all usages of the CS_CHECK macro and replace them with proper
Linux style calling and return value checking. The extra error reporting may
be dropped, as the PCMCIA core already complains about any (non-driver-author)
errors.

CC: linux-scsi@vger.kernel.org
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/scsi/pcmcia/aha152x_stub.c |   40 +++++++++++---------------------
 drivers/scsi/pcmcia/fdomain_stub.c |   43 ++++++++++++----------------------
 drivers/scsi/pcmcia/qlogic_stub.c  |   44 +++++++++++++----------------------
 drivers/scsi/pcmcia/sym53c500_cs.c |   41 +++++++++++----------------------
 4 files changed, 59 insertions(+), 109 deletions(-)

diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 67cde01..43ad074 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -54,15 +54,6 @@
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
 
-#ifdef PCMCIA_DEBUG
-static int pc_debug = PCMCIA_DEBUG;
-module_param(pc_debug, int, 0644);
-#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
-static char *version =
-"aha152x_cs.c 1.54 2000/06/12 21:27:25 (David Hinds)";
-#else
-#define DEBUG(n, args...)
-#endif
 
 /*====================================================================*/
 
@@ -103,7 +94,7 @@ static int aha152x_probe(struct pcmcia_device *link)
 {
     scsi_info_t *info;
 
-    DEBUG(0, "aha152x_attach()\n");
+    dev_dbg(&link->dev, "aha152x_attach()\n");
 
     /* Create new SCSI device */
     info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -127,7 +118,7 @@ static int aha152x_probe(struct pcmcia_device *link)
 
 static void aha152x_detach(struct pcmcia_device *link)
 {
-    DEBUG(0, "aha152x_detach(0x%p)\n", link);
+    dev_dbg(&link->dev, "aha152x_detach\n");
 
     aha152x_release_cs(link);
 
@@ -137,9 +128,6 @@ static void aha152x_detach(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-#define CS_CHECK(fn, ret) \
-do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
-
 static int aha152x_config_check(struct pcmcia_device *p_dev,
 				cistpl_cftable_entry_t *cfg,
 				cistpl_cftable_entry_t *dflt,
@@ -164,19 +152,21 @@ static int aha152x_config_cs(struct pcmcia_device *link)
 {
     scsi_info_t *info = link->priv;
     struct aha152x_setup s;
-    int last_ret, last_fn;
+    int ret
     struct Scsi_Host *host;
 
-    DEBUG(0, "aha152x_config(0x%p)\n", link);
+    dev_dbg(&link->dev, "aha152x_config\n");
 
-    last_ret = pcmcia_loop_config(link, aha152x_config_check, NULL);
-    if (last_ret) {
-	cs_error(link, RequestIO, last_ret);
-	goto failed;
-    }
+    ret = pcmcia_loop_config(link, aha152x_config_check, NULL);
+    if (ret)
+	    goto failed;
 
-    CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
-    CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
+    ret = pcmcia_request_irq(link, &link->irq);
+    if (ret)
+	    goto failed;
+    ret = pcmcia_request_configuration(link, &link->conf);
+    if (ret)
+	    goto failed;
     
     /* Set configuration options for the aha152x driver */
     memset(&s, 0, sizeof(s));
@@ -194,7 +184,7 @@ static int aha152x_config_cs(struct pcmcia_device *link)
     host = aha152x_probe_one(&s);
     if (host == NULL) {
 	printk(KERN_INFO "aha152x_cs: no SCSI devices found\n");
-	goto cs_failed;
+	goto failed;
     }
 
     sprintf(info->node.dev_name, "scsi%d", host->host_no);
@@ -203,8 +193,6 @@ static int aha152x_config_cs(struct pcmcia_device *link)
 
     return 0;
 
-cs_failed:
-    cs_error(link, last_fn, last_ret);
 failed:
     aha152x_release_cs(link);
     return -ENODEV;
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 06254f4..5792b55 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -59,16 +59,6 @@ MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("Future Domain PCMCIA SCSI driver");
 MODULE_LICENSE("Dual MPL/GPL");
 
-#ifdef PCMCIA_DEBUG
-static int pc_debug = PCMCIA_DEBUG;
-module_param(pc_debug, int, 0);
-#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
-static char *version =
-"fdomain_cs.c 1.47 2001/10/13 00:08:52 (David Hinds)";
-#else
-#define DEBUG(n, args...)
-#endif
-
 /*====================================================================*/
 
 typedef struct scsi_info_t {
@@ -86,7 +76,7 @@ static int fdomain_probe(struct pcmcia_device *link)
 {
 	scsi_info_t *info;
 
-	DEBUG(0, "fdomain_attach()\n");
+	dev_dbg(&link->dev, "fdomain_attach()\n");
 
 	/* Create new SCSI device */
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -111,7 +101,7 @@ static int fdomain_probe(struct pcmcia_device *link)
 
 static void fdomain_detach(struct pcmcia_device *link)
 {
-	DEBUG(0, "fdomain_detach(0x%p)\n", link);
+	dev_dbg(&link->dev, "fdomain_detach\n");
 
 	fdomain_release(link);
 
@@ -120,9 +110,6 @@ static void fdomain_detach(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-#define CS_CHECK(fn, ret) \
-do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
-
 static int fdomain_config_check(struct pcmcia_device *p_dev,
 				cistpl_cftable_entry_t *cfg,
 				cistpl_cftable_entry_t *dflt,
@@ -137,20 +124,22 @@ static int fdomain_config_check(struct pcmcia_device *p_dev,
 static int fdomain_config(struct pcmcia_device *link)
 {
     scsi_info_t *info = link->priv;
-    int last_ret, last_fn;
+    int ret;
     char str[22];
     struct Scsi_Host *host;
 
-    DEBUG(0, "fdomain_config(0x%p)\n", link);
+    dev_dbg(&link->dev, "fdomain_config\n");
 
-    last_ret = pcmcia_loop_config(link, fdomain_config_check, NULL);
-    if (last_ret) {
-	    cs_error(link, RequestIO, last_ret);
+    ret = pcmcia_loop_config(link, fdomain_config_check, NULL);
+    if (ret)
 	    goto failed;
-    }
 
-    CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
-    CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
+    ret = pcmcia_request_irq(link, &link->irq);
+    if (ret)
+	    goto failed;
+    ret = pcmcia_request_configuration(link, &link->conf);
+    if (ret)
+	    goto failed;
 
     /* A bad hack... */
     release_region(link->io.BasePort1, link->io.NumPorts1);
@@ -162,11 +151,11 @@ static int fdomain_config(struct pcmcia_device *link)
     host = __fdomain_16x0_detect(&fdomain_driver_template);
     if (!host) {
         printk(KERN_INFO "fdomain_cs: no SCSI devices found\n");
-	goto cs_failed;
+	goto failed;
     }
 
     if (scsi_add_host(host, NULL))
-	    goto cs_failed;
+	    goto failed;
     scsi_scan_host(host);
 
     sprintf(info->node.dev_name, "scsi%d", host->host_no);
@@ -175,8 +164,6 @@ static int fdomain_config(struct pcmcia_device *link)
 
     return 0;
 
-cs_failed:
-    cs_error(link, last_fn, last_ret);
 failed:
     fdomain_release(link);
     return -ENODEV;
@@ -188,7 +175,7 @@ static void fdomain_release(struct pcmcia_device *link)
 {
 	scsi_info_t *info = link->priv;
 
-	DEBUG(0, "fdomain_release(0x%p)\n", link);
+	dev_dbg(&link->dev, "fdomain_release\n");
 
 	scsi_remove_host(info->host);
 	pcmcia_disable_device(link);
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 20c3e5e..65d7ad5 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -62,15 +62,6 @@
 
 static char qlogic_name[] = "qlogic_cs";
 
-#ifdef PCMCIA_DEBUG
-static int pc_debug = PCMCIA_DEBUG;
-module_param(pc_debug, int, 0644);
-#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
-static char *version = "qlogic_cs.c 1.79-ac 2002/10/26 (David Hinds)";
-#else
-#define DEBUG(n, args...)
-#endif
-
 static struct scsi_host_template qlogicfas_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= qlogic_name,
@@ -159,7 +150,7 @@ static int qlogic_probe(struct pcmcia_device *link)
 {
 	scsi_info_t *info;
 
-	DEBUG(0, "qlogic_attach()\n");
+	dev_dbg(&link->dev, "qlogic_attach()\n");
 
 	/* Create new SCSI device */
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -183,7 +174,7 @@ static int qlogic_probe(struct pcmcia_device *link)
 
 static void qlogic_detach(struct pcmcia_device *link)
 {
-	DEBUG(0, "qlogic_detach(0x%p)\n", link);
+	dev_dbg(&link->dev, "qlogic_detach\n");
 
 	qlogic_release(link);
 	kfree(link->priv);
@@ -192,9 +183,6 @@ static void qlogic_detach(struct pcmcia_device *link)
 
 /*====================================================================*/
 
-#define CS_CHECK(fn, ret) \
-do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
-
 static int qlogic_config_check(struct pcmcia_device *p_dev,
 			       cistpl_cftable_entry_t *cfg,
 			       cistpl_cftable_entry_t *dflt,
@@ -213,19 +201,22 @@ static int qlogic_config_check(struct pcmcia_device *p_dev,
 static int qlogic_config(struct pcmcia_device * link)
 {
 	scsi_info_t *info = link->priv;
-	int last_ret, last_fn;
+	int ret;
 	struct Scsi_Host *host;
 
-	DEBUG(0, "qlogic_config(0x%p)\n", link);
+	dev_dbg(&link->dev, "qlogic_config\n");
 
-	last_ret = pcmcia_loop_config(link, qlogic_config_check, NULL);
-	if (last_ret) {
-		cs_error(link, RequestIO, last_ret);
+	ret = pcmcia_loop_config(link, qlogic_config_check, NULL);
+	if (ret)
+		goto failed;
+
+	ret = pcmcia_request_irq(link, &link->irq);
+	if (ret)
 		goto failed;
-	}
 
-	CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
-	CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
+	ret = pcmcia_request_configuration(link, &link->conf);
+	if (ret)
+		goto failed;
 
 	if ((info->manf_id == MANFID_MACNICA) || (info->manf_id == MANFID_PIONEER) || (info->manf_id == 0x0098)) {
 		/* set ATAcmd */
@@ -244,7 +235,7 @@ static int qlogic_config(struct pcmcia_device * link)
 	
 	if (!host) {
 		printk(KERN_INFO "%s: no SCSI devices found\n", qlogic_name);
-		goto cs_failed;
+		goto failed;
 	}
 
 	sprintf(info->node.dev_name, "scsi%d", host->host_no);
@@ -253,12 +244,9 @@ static int qlogic_config(struct pcmcia_device * link)
 
 	return 0;
 
-cs_failed:
-	cs_error(link, last_fn, last_ret);
-	pcmcia_disable_device(link);
 failed:
+	pcmcia_disable_device(link);
 	return -ENODEV;
-
 }				/* qlogic_config */
 
 /*====================================================================*/
@@ -267,7 +255,7 @@ static void qlogic_release(struct pcmcia_device *link)
 {
 	scsi_info_t *info = link->priv;
 
-	DEBUG(0, "qlogic_release(0x%p)\n", link);
+	dev_dbg(&link->dev, "qlogic_release\n");
 
 	scsi_remove_host(info->host);
 
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index b330c11..851a41c 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -77,17 +77,6 @@
 #include <pcmcia/ds.h>
 #include <pcmcia/ciscode.h>
 
-/* ================================================================== */
-
-#ifdef PCMCIA_DEBUG
-static int pc_debug = PCMCIA_DEBUG;
-module_param(pc_debug, int, 0);
-#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
-static char *version =
-"sym53c500_cs.c 0.9c 2004/10/27 (Bob Tracy)";
-#else
-#define DEBUG(n, args...)
-#endif
 
 /* ================================================================== */
 
@@ -525,7 +514,7 @@ SYM53C500_release(struct pcmcia_device *link)
 	struct scsi_info_t *info = link->priv;
 	struct Scsi_Host *shost = info->host;
 
-	DEBUG(0, "SYM53C500_release(0x%p)\n", link);
+	dev_dbg(&link->dev, "SYM53C500_release\n");
 
 	/*
 	*  Do this before releasing/freeing resources.
@@ -697,9 +686,6 @@ static struct scsi_host_template sym53c500_driver_template = {
      .shost_attrs		= SYM53C500_shost_attrs
 };
 
-#define CS_CHECK(fn, ret) \
-do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
-
 static int SYM53C500_config_check(struct pcmcia_device *p_dev,
 				  cistpl_cftable_entry_t *cfg,
 				  cistpl_cftable_entry_t *dflt,
@@ -719,24 +705,27 @@ static int
 SYM53C500_config(struct pcmcia_device *link)
 {
 	struct scsi_info_t *info = link->priv;
-	int last_ret, last_fn;
+	int ret;
 	int irq_level, port_base;
 	struct Scsi_Host *host;
 	struct scsi_host_template *tpnt = &sym53c500_driver_template;
 	struct sym53c500_data *data;
 
-	DEBUG(0, "SYM53C500_config(0x%p)\n", link);
+	dev_dbg(&link->dev, "SYM53C500_config\n");
 
 	info->manf_id = link->manf_id;
 
-	last_ret = pcmcia_loop_config(link, SYM53C500_config_check, NULL);
-	if (last_ret) {
-		cs_error(link, RequestIO, last_ret);
+	ret = pcmcia_loop_config(link, SYM53C500_config_check, NULL);
+	if (ret)
+		goto failed;
+
+	ret = pcmcia_request_irq(link, &link->irq);
+	if (ret)
 		goto failed;
-	}
 
-	CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
-	CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
+	ret = pcmcia_request_configuration(link, &link->conf);
+	if (ret)
+		goto failed;
 
 	/*
 	*  That's the trouble with copying liberally from another driver.
@@ -824,8 +813,6 @@ err_release:
 	printk(KERN_INFO "sym53c500_cs: no SCSI devices found\n");
 	return -ENODEV;
 
-cs_failed:
-	cs_error(link, last_fn, last_ret);
 failed:
 	SYM53C500_release(link);
 	return -ENODEV;
@@ -855,7 +842,7 @@ static int sym53c500_resume(struct pcmcia_device *link)
 static void
 SYM53C500_detach(struct pcmcia_device *link)
 {
-	DEBUG(0, "SYM53C500_detach(0x%p)\n", link);
+	dev_dbg(&link->dev, "SYM53C500_detach\n");
 
 	SYM53C500_release(link);
 
@@ -868,7 +855,7 @@ SYM53C500_probe(struct pcmcia_device *link)
 {
 	struct scsi_info_t *info;
 
-	DEBUG(0, "SYM53C500_attach()\n");
+	dev_dbg(&link->dev, "SYM53C500_attach()\n");
 
 	/* Create new SCSI device */
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-- 
1.6.0.4

