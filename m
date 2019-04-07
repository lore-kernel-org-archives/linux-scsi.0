From: Ondrej Zary <linux@zary.sk>
Subject: [RFC PATCH 2/2] fdomain: Fix compilation
Date: Sun,  7 Apr 2019 20:56:17 +0200
Message-ID: <20190407185617.8467-3-linux@zary.sk>
References: <20190407185617.8467-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190407185617.8467-1-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik Faith <faith@cs.unc.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove usage of scsi_module.c, .use_clustering and scsi_(un)register.
This allows the driver to compile and also work (tested with PCI card).

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/fdomain.c             | 48 ++++++++++++++++++++++++++++----------
 drivers/scsi/pcmcia/fdomain_stub.c |  2 +-
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index ebbe5a3e665d..fe9e373c27a8 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -415,6 +415,7 @@ static char * fdomain = NULL;
 module_param(fdomain, charp, 0);
 
 #ifndef PCMCIA
+static struct Scsi_Host	*fdomain_shost;
 
 static unsigned long addresses[] = {
    0xc8000,
@@ -959,7 +960,7 @@ struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
 /* Print out a banner here in case we can't
    get resources.  */
 
-   shpnt = scsi_register( tpnt, 0 );
+   shpnt = scsi_host_alloc( tpnt, 0 );
    if(shpnt == NULL) {
 	release_region(port_base, 0x10);
    	return NULL;
@@ -1003,13 +1004,6 @@ struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
    return NULL;
 }
 
-static int fdomain_16x0_detect(struct scsi_host_template *tpnt)
-{
-	if (fdomain)
-		fdomain_setup(fdomain);
-	return (__fdomain_16x0_detect(tpnt) != NULL);
-}
-
 static const char *fdomain_16x0_info( struct Scsi_Host *ignore )
 {
    static char buffer[128];
@@ -1739,6 +1733,7 @@ static int fdomain_16x0_biosparam(struct scsi_device *sdev,
    return 0;
 }
 
+#ifndef PCMCIA
 static int fdomain_16x0_release(struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq)
@@ -1749,22 +1744,21 @@ static int fdomain_16x0_release(struct Scsi_Host *shpnt)
 		pci_dev_put(PCI_dev);
 	return 0;
 }
+#endif
 
 struct scsi_host_template fdomain_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "fdomain",
 	.proc_name		= "fdomain",
-	.detect			= fdomain_16x0_detect,
 	.info			= fdomain_16x0_info,
 	.queuecommand		= fdomain_16x0_queue,
 	.eh_abort_handler	= fdomain_16x0_abort,
 	.eh_host_reset_handler	= fdomain_16x0_host_reset,
 	.bios_param		= fdomain_16x0_biosparam,
-	.release		= fdomain_16x0_release,
 	.can_queue		= 1,
 	.this_id		= 6,
 	.sg_tablesize		= 64,
-	.use_clustering		= DISABLE_CLUSTERING,
+	.dma_boundary		= PAGE_SIZE - 1,
 };
 
 #ifndef PCMCIA
@@ -1778,6 +1772,36 @@ static struct pci_device_id fdomain_pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
 #endif
 #define driver_template fdomain_driver_template
-#include "scsi_module.c"
+
+static int __init fdomain_16x0_init(void)
+{
+	int ret;
+
+	if (fdomain)
+		fdomain_setup(fdomain);
+	fdomain_shost = __fdomain_16x0_detect(&driver_template);
+	if (!fdomain_shost)
+		return -ENODEV;
+
+	ret = scsi_add_host(fdomain_shost, NULL);
+	if (ret)
+		goto fail;
+	scsi_scan_host(fdomain_shost);
+
+	return 0;
+fail:
+	scsi_remove_host(fdomain_shost);
+	return ret;
+}
+
+static void __exit fdomain_16x0_exit(void)
+{
+	scsi_remove_host(fdomain_shost);
+	fdomain_16x0_release(fdomain_shost);
+	scsi_host_put(fdomain_shost);
+}
+
+module_init(fdomain_16x0_init);
+module_exit(fdomain_16x0_exit);
 
 #endif
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 953a792150ae..5febbb7d611b 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -166,7 +166,7 @@ static void fdomain_release(struct pcmcia_device *link)
 
 	scsi_remove_host(info->host);
 	pcmcia_disable_device(link);
-	scsi_unregister(info->host);
+	scsi_host_put(info->host);
 }
 
 /*====================================================================*/
-- 
Ondrej Zary
