From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] aha152x: fix isa/pcmcia compile problem
Date: Fri, 18 Jan 2008 09:53:16 +0900
Message-ID: <478FF87C.2050307@gmail.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>	<478F7F2B.9000801@linux.vnet.ibm.com> <20080117111104.3baa878e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:1685 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbYARAx2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 19:53:28 -0500
Received: by rv-out-0910.google.com with SMTP id k20so715251rvb.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jan 2008 16:53:27 -0800 (PST)
In-Reply-To: <20080117111104.3baa878e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fischer@norbit.de, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, Samuel Ortiz <samuel@sortiz.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

aha152x.c is built twice - once for the isa driver and once for the
PCMCIA one.  Through #ifdefs, the compiled codes are slightly
different; thus, global symbols need to be given different names
depending on which flavor is being built.  This patch adds GLOBAL()
macro to aha152x.h which changes the symbol depending on PCMCIA.

This bug has always existed but has been masked by the fact the
drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus
avoided the duplicate symbols during compilation.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/scsi/aha152x.c             |   12 ++++++------
 drivers/scsi/aha152x.h             |   20 +++++++++++++++++---
 drivers/scsi/pcmcia/aha152x_stub.c |   10 ++++++----
 3 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index ea8c699..0204f44 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -769,7 +769,7 @@ static irqreturn_t swintr(int irqno, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
+struct Scsi_Host *GLOBAL(aha152x_probe_one)(struct aha152x_setup *setup)
 {
 	struct Scsi_Host *shpnt;
 
@@ -905,7 +905,7 @@ out_host_put:
 	return NULL;
 }
 
-void aha152x_release(struct Scsi_Host *shpnt)
+void GLOBAL(aha152x_release)(struct Scsi_Host *shpnt)
 {
 	if (!shpnt)
 		return;
@@ -1327,7 +1327,7 @@ static void reset_ports(struct Scsi_Host *shpnt)
  * Reset the host (bus and controller)
  *
  */
-int aha152x_host_reset_host(struct Scsi_Host *shpnt)
+int GLOBAL(aha152x_host_reset_host)(struct Scsi_Host *shpnt)
 {
 	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: host reset\n", shpnt->host_no);
 
@@ -1345,7 +1345,7 @@ int aha152x_host_reset_host(struct Scsi_Host *shpnt)
  */
 static int aha152x_host_reset(Scsi_Cmnd *SCpnt)
 {
-	return aha152x_host_reset_host(SCpnt->device->host);
+	return GLOBAL(aha152x_host_reset_host)(SCpnt->device->host);
 }
 
 /*
@@ -3916,7 +3916,7 @@ static int __init aha152x_init(void)
 
 	for (i=0; i<setup_count; i++) {
 		if ( request_region(setup[i].io_port, IO_RANGE, "aha152x") ) {
-			struct Scsi_Host *shpnt = aha152x_probe_one(&setup[i]);
+			struct Scsi_Host *shpnt = GLOBAL(aha152x_probe_one)(&setup[i]);
 
 			if( !shpnt ) {
 				release_region(setup[i].io_port, IO_RANGE);
@@ -3946,7 +3946,7 @@ static void __exit aha152x_exit(void)
 	list_for_each_entry(hd, &aha152x_host_list, host_list) {
 		struct Scsi_Host *shost = container_of((void *)hd, struct Scsi_Host, hostdata);
 
-		aha152x_release(shost);
+		GLOBAL(aha152x_release)(shost);
 	}
 }
 
diff --git a/drivers/scsi/aha152x.h b/drivers/scsi/aha152x.h
index ac4bfa4..7db6c47 100644
--- a/drivers/scsi/aha152x.h
+++ b/drivers/scsi/aha152x.h
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
+#define GLOBAL(x)	x
+#endif
+
+struct Scsi_Host *GLOBAL(aha152x_probe_one)(struct aha152x_setup *);
+void GLOBAL(aha152x_release)(struct Scsi_Host *);
+int GLOBAL(aha152x_host_reset_host)(struct Scsi_Host *);
 
 #endif /* _AHA152X_H */
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 2dd0dc9..57f83d1 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
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
@@ -194,7 +196,7 @@ static int aha152x_config_cs(struct pcmcia_device *link)
     if (ext_trans)
         s.ext_trans = ext_trans;
 
-    host = aha152x_probe_one(&s);
+    host = GLOBAL(aha152x_probe_one)(&s);
     if (host == NULL) {
 	printk(KERN_INFO "aha152x_cs: no SCSI devices found\n");
 	goto cs_failed;
@@ -216,7 +218,7 @@ static void aha152x_release_cs(struct pcmcia_device *link)
 {
 	scsi_info_t *info = link->priv;
 
-	aha152x_release(info->host);
+	GLOBAL(aha152x_release)(info->host);
 	pcmcia_disable_device(link);
 }
 
@@ -224,7 +226,7 @@ static int aha152x_resume(struct pcmcia_device *link)
 {
 	scsi_info_t *info = link->priv;
 
-	aha152x_host_reset_host(info->host);
+	GLOBAL(aha152x_host_reset_host)(info->host);
 
 	return 0;
 }
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
