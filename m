From: akpm@linux-foundation.org
Subject: [patch 01/13] git-scsi-misc: fix isa/pcmcia compile problem
Date: Mon, 04 Feb 2008 23:53:10 -0800
Message-ID: <200802050752.m157qqYH010688@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbYBEHxG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 02:53:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, htejun@gmail.com, kamalesh@linux.vnet.ibm.com

From: Tejun Heo <htejun@gmail.com>

aha152x.c and fdomain are built twice - once for the isa driver and once
for the PCMCIA one.  Through #ifdefs, the compiled codes are slightly
different; thus, global symbols need to be given different names depending
on which flavor is being built.  This patch adds GLOBAL() macro to
aha152x.h and fdomain.h which change the symbol depending on PCMCIA.

This bug has always existed but has been masked by the fact the
drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus avoided
the duplicate symbols during compilation.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Tejun Heo <htejun@gmail.com>
Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aha152x.c             |   12 ++++++------
 drivers/scsi/aha152x.h             |   20 +++++++++++++++++---
 drivers/scsi/fdomain.c             |   20 ++++++++++----------
 drivers/scsi/fdomain.h             |   21 +++++++++++++++++----
 drivers/scsi/pcmcia/aha152x_stub.c |   10 ++++++----
 drivers/scsi/pcmcia/fdomain_stub.c |   10 ++++++----
 6 files changed, 62 insertions(+), 31 deletions(-)

diff -puN drivers/scsi/aha152x.c~scsi-fix-isa-pcmcia-compile-problem drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c~scsi-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/aha152x.c
@@ -768,7 +768,7 @@ static irqreturn_t swintr(int irqno, voi
 	return IRQ_HANDLED;
 }
 
-struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
+struct Scsi_Host *GLOBAL(aha152x_probe_one)(struct aha152x_setup *setup)
 {
 	struct Scsi_Host *shpnt;
 
@@ -904,7 +904,7 @@ out_host_put:
 	return NULL;
 }
 
-void aha152x_release(struct Scsi_Host *shpnt)
+void GLOBAL(aha152x_release)(struct Scsi_Host *shpnt)
 {
 	if (!shpnt)
 		return;
@@ -1320,7 +1320,7 @@ static void reset_ports(struct Scsi_Host
  * Reset the host (bus and controller)
  *
  */
-int aha152x_host_reset_host(struct Scsi_Host *shpnt)
+int GLOBAL(aha152x_host_reset_host)(struct Scsi_Host *shpnt)
 {
 	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: host reset\n", shpnt->host_no);
 
@@ -1338,7 +1338,7 @@ int aha152x_host_reset_host(struct Scsi_
  */
 static int aha152x_host_reset(Scsi_Cmnd *SCpnt)
 {
-	return aha152x_host_reset_host(SCpnt->device->host);
+	return GLOBAL(aha152x_host_reset_host)(SCpnt->device->host);
 }
 
 /*
@@ -3894,7 +3894,7 @@ static int __init aha152x_init(void)
 
 	for (i=0; i<setup_count; i++) {
 		if ( request_region(setup[i].io_port, IO_RANGE, "aha152x") ) {
-			struct Scsi_Host *shpnt = aha152x_probe_one(&setup[i]);
+			struct Scsi_Host *shpnt = GLOBAL(aha152x_probe_one)(&setup[i]);
 
 			if( !shpnt ) {
 				release_region(setup[i].io_port, IO_RANGE);
@@ -3924,7 +3924,7 @@ static void __exit aha152x_exit(void)
 	list_for_each_entry(hd, &aha152x_host_list, host_list) {
 		struct Scsi_Host *shost = container_of((void *)hd, struct Scsi_Host, hostdata);
 
-		aha152x_release(shost);
+		GLOBAL(aha152x_release)(shost);
 	}
 }
 
diff -puN drivers/scsi/aha152x.h~scsi-fix-isa-pcmcia-compile-problem drivers/scsi/aha152x.h
--- a/drivers/scsi/aha152x.h~scsi-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/aha152x.h
@@ -330,8 +330,22 @@ struct aha152x_setup {
 	char *conf;
 };
 
-struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
-void aha152x_release(struct Scsi_Host *);
-int aha152x_host_reset_host(struct Scsi_Host *);
+/*
+ * This file and aha152x.c are compiled in two different ways - for
+ * the isa driver and pcmcia one.  When building the pcmcia one, the
+ * file is slightly modified, so they can't share the same object
+ * file.  The following macro alters a symbol depending on whether
+ * pcmcia driver is being built or not and should be used for any
+ * global symbol.
+ */
+#if defined(PCMCIA)
+#define GLOBAL(x)	CS_##x
+#else
+#define GLOBAL(x)	ISA_##x
+#endif
+
+struct Scsi_Host *GLOBAL(aha152x_probe_one)(struct aha152x_setup *);
+void GLOBAL(aha152x_release)(struct Scsi_Host *);
+int GLOBAL(aha152x_host_reset_host)(struct Scsi_Host *);
 
 #endif /* _AHA152X_H */
diff -puN drivers/scsi/fdomain.c~scsi-fix-isa-pcmcia-compile-problem drivers/scsi/fdomain.c
--- a/drivers/scsi/fdomain.c~scsi-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/fdomain.c
@@ -550,7 +550,7 @@ static void print_banner( struct Scsi_Ho
    printk( "\n" );
 }
 
-int fdomain_setup(char *str)
+int GLOBAL(fdomain_setup)(char *str)
 {
 	int ints[4];
 
@@ -571,7 +571,7 @@ int fdomain_setup(char *str)
 	return 1;
 }
 
-__setup("fdomain=", fdomain_setup);
+__setup("fdomain=", GLOBAL(fdomain_setup));
 
 
 static void do_pause(unsigned amount)	/* Pause for amount*10 milliseconds */
@@ -890,7 +890,7 @@ fail:
 
 #endif
 
-struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
+struct Scsi_Host *GLOBAL(__fdomain_16x0_detect)(struct scsi_host_template *tpnt)
 {
    int              retcode;
    struct Scsi_Host *shpnt;
@@ -931,7 +931,7 @@ struct Scsi_Host *__fdomain_16x0_detect(
       }
    }
 
-   fdomain_16x0_bus_reset(NULL);
+   GLOBAL(fdomain_16x0_bus_reset)(NULL);
 
    if (fdomain_test_loopback()) {
       printk(KERN_ERR  "scsi: <fdomain> Detection failed (loopback test failed at port base 0x%x)\n", port_base);
@@ -1004,8 +1004,8 @@ fail:
 static int fdomain_16x0_detect(struct scsi_host_template *tpnt)
 {
 	if (fdomain)
-		fdomain_setup(fdomain);
-	return (__fdomain_16x0_detect(tpnt) != NULL);
+		GLOBAL(fdomain_setup)(fdomain);
+	return (GLOBAL(__fdomain_16x0_detect)(tpnt) != NULL);
 }
 
 static const char *fdomain_16x0_info( struct Scsi_Host *ignore )
@@ -1564,7 +1564,7 @@ static int fdomain_16x0_abort(struct scs
    return SUCCESS;
 }
 
-int fdomain_16x0_bus_reset(struct scsi_cmnd *SCpnt)
+int GLOBAL(fdomain_16x0_bus_reset)(struct scsi_cmnd *SCpnt)
 {
    unsigned long flags;
 
@@ -1746,7 +1746,7 @@ static int fdomain_16x0_release(struct S
 	return 0;
 }
 
-struct scsi_host_template fdomain_driver_template = {
+struct scsi_host_template GLOBAL(fdomain_driver_template) = {
 	.module			= THIS_MODULE,
 	.name			= "fdomain",
 	.proc_name		= "fdomain",
@@ -1754,7 +1754,7 @@ struct scsi_host_template fdomain_driver
 	.info			= fdomain_16x0_info,
 	.queuecommand		= fdomain_16x0_queue,
 	.eh_abort_handler	= fdomain_16x0_abort,
-	.eh_bus_reset_handler	= fdomain_16x0_bus_reset,
+	.eh_bus_reset_handler	= GLOBAL(fdomain_16x0_bus_reset),
 	.bios_param		= fdomain_16x0_biosparam,
 	.release		= fdomain_16x0_release,
 	.can_queue		= 1,
@@ -1774,7 +1774,7 @@ static struct pci_device_id fdomain_pci_
 };
 MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
 #endif
-#define driver_template fdomain_driver_template
+#define driver_template GLOBAL(fdomain_driver_template)
 #include "scsi_module.c"
 
 #endif
diff -puN drivers/scsi/fdomain.h~scsi-fix-isa-pcmcia-compile-problem drivers/scsi/fdomain.h
--- a/drivers/scsi/fdomain.h~scsi-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/fdomain.h
@@ -18,7 +18,20 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-extern struct scsi_host_template fdomain_driver_template;
-extern int fdomain_setup(char *str);
-extern struct Scsi_Host *__fdomain_16x0_detect(struct  scsi_host_template *tpnt );
-extern int fdomain_16x0_bus_reset(struct scsi_cmnd *SCpnt);
+/*
+ * fdomain is compiled in two different ways - for the isa driver and
+ * pcmcia one.  When building the pcmcia one, the file is slightly
+ * modified, so they can't share the same object file.  The following
+ * macro alters a symbol depending on whether pcmcia driver is being
+ * built or not and should be used for any global symbol.
+ */
+#if defined(PCMCIA)
+#define GLOBAL(x)	CS_##x
+#else
+#define GLOBAL(x)	ISA_##x
+#endif
+
+extern struct scsi_host_template GLOBAL(fdomain_driver_template);
+extern int GLOBAL(fdomain_setup)(char *str);
+extern struct Scsi_Host *GLOBAL(__fdomain_16x0_detect)(struct scsi_host_template *tpnt);
+extern int GLOBAL(fdomain_16x0_bus_reset)(struct scsi_cmnd *SCpnt);
diff -puN drivers/scsi/pcmcia/aha152x_stub.c~scsi-fix-isa-pcmcia-compile-problem drivers/scsi/pcmcia/aha152x_stub.c
--- a/drivers/scsi/pcmcia/aha152x_stub.c~scsi-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/pcmcia/aha152x_stub.c
@@ -47,13 +47,15 @@
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
-#include "aha152x.h"
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
 
+#define PCMCIA	1
+#include "aha152x.h"
+
 #ifdef PCMCIA_DEBUG
 static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0644);
@@ -194,7 +196,7 @@ static int aha152x_config_cs(struct pcmc
     if (ext_trans)
         s.ext_trans = ext_trans;
 
-    host = aha152x_probe_one(&s);
+    host = GLOBAL(aha152x_probe_one)(&s);
     if (host == NULL) {
 	printk(KERN_INFO "aha152x_cs: no SCSI devices found\n");
 	goto cs_failed;
@@ -216,7 +218,7 @@ static void aha152x_release_cs(struct pc
 {
 	scsi_info_t *info = link->priv;
 
-	aha152x_release(info->host);
+	GLOBAL(aha152x_release)(info->host);
 	pcmcia_disable_device(link);
 }
 
@@ -224,7 +226,7 @@ static int aha152x_resume(struct pcmcia_
 {
 	scsi_info_t *info = link->priv;
 
-	aha152x_host_reset_host(info->host);
+	GLOBAL(aha152x_host_reset_host)(info->host);
 
 	return 0;
 }
diff -puN drivers/scsi/pcmcia/fdomain_stub.c~scsi-fix-isa-pcmcia-compile-problem drivers/scsi/pcmcia/fdomain_stub.c
--- a/drivers/scsi/pcmcia/fdomain_stub.c~scsi-fix-isa-pcmcia-compile-problem
+++ a/drivers/scsi/pcmcia/fdomain_stub.c
@@ -44,13 +44,15 @@
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
-#include "fdomain.h"
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
 
+#define PCMCIA	1
+#include "fdomain.h"
+
 /*====================================================================*/
 
 /* Module parameters */
@@ -161,9 +163,9 @@ static int fdomain_config(struct pcmcia_
 
     /* Set configuration options for the fdomain driver */
     sprintf(str, "%d,%d", link->io.BasePort1, link->irq.AssignedIRQ);
-    fdomain_setup(str);
+    GLOBAL(fdomain_setup)(str);
 
-    host = __fdomain_16x0_detect(&fdomain_driver_template);
+    host = GLOBAL(__fdomain_16x0_detect)(&GLOBAL(fdomain_driver_template));
     if (!host) {
         printk(KERN_INFO "fdomain_cs: no SCSI devices found\n");
 	goto cs_failed;
@@ -202,7 +204,7 @@ static void fdomain_release(struct pcmci
 
 static int fdomain_resume(struct pcmcia_device *link)
 {
-	fdomain_16x0_bus_reset(NULL);
+	GLOBAL(fdomain_16x0_bus_reset)(NULL);
 
 	return 0;
 }
_
