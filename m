From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] libsas: convert to standard kernel debugging
Date: Sun, 23 Jan 2011 08:19:00 -0600
Message-ID: <1295792340.3007.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56738 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1AWOTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jan 2011 09:19:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id D637F94430
	for <linux-scsi@vger.kernel.org>; Sun, 23 Jan 2011 15:19:03 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Instead of using a config option for debugging, just dump the
messages with KERN_DEBUG.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 18f33cd..9dafe64 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -46,11 +46,3 @@ config SCSI_SAS_HOST_SMP
 		Allows sas hosts to receive SMP frames.  Selecting this
 		option builds an SMP interpreter into libsas.  Say
 		N here if you want to save the few kb this consumes.
-
-config SCSI_SAS_LIBSAS_DEBUG
-	bool "Compile the SAS Domain Transport Attributes in debug mode"
-	default y
-	depends on SCSI_SAS_LIBSAS
-	help
-		Compiles the SAS Layer in debug mode.  In debug mode, the
-		SAS Layer prints diagnostic and debug messages.
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index 1ad1323..566a100 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -21,10 +21,6 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 
-ifeq ($(CONFIG_SCSI_SAS_LIBSAS_DEBUG),y)
-	EXTRA_CFLAGS += -DSAS_DEBUG
-endif
-
 obj-$(CONFIG_SCSI_SAS_LIBSAS) += libsas.o
 libsas-y +=  sas_init.o     \
 		sas_phy.o      \
diff --git a/drivers/scsi/libsas/sas_dump.c b/drivers/scsi/libsas/sas_dump.c
index c17c250..fc46093 100644
--- a/drivers/scsi/libsas/sas_dump.c
+++ b/drivers/scsi/libsas/sas_dump.c
@@ -24,8 +24,6 @@
 
 #include "sas_dump.h"
 
-#ifdef SAS_DEBUG
-
 static const char *sas_hae_str[] = {
 	[0] = "HAE_RESET",
 };
@@ -72,5 +70,3 @@ void sas_dump_port(struct asd_sas_port *port)
 	SAS_DPRINTK("port%d: oob_mode:0x%x\n", port->id, port->oob_mode);
 	SAS_DPRINTK("port%d: num_phys:%d\n", port->id, port->num_phys);
 }
-
-#endif /* SAS_DEBUG */
diff --git a/drivers/scsi/libsas/sas_dump.h b/drivers/scsi/libsas/sas_dump.h
index 47b45d4..800e4c6 100644
--- a/drivers/scsi/libsas/sas_dump.h
+++ b/drivers/scsi/libsas/sas_dump.h
@@ -24,19 +24,7 @@
 
 #include "sas_internal.h"
 
-#ifdef SAS_DEBUG
-
 void sas_dprint_porte(int phyid, enum port_event pe);
 void sas_dprint_phye(int phyid, enum phy_event pe);
 void sas_dprint_hae(struct sas_ha_struct *sas_ha, enum ha_event he);
 void sas_dump_port(struct asd_sas_port *port);
-
-#else /* SAS_DEBUG */
-
-static inline void sas_dprint_porte(int phyid, enum port_event pe) { }
-static inline void sas_dprint_phye(int phyid, enum phy_event pe) { }
-static inline void sas_dprint_hae(struct sas_ha_struct *sas_ha,
-				  enum ha_event he) { }
-static inline void sas_dump_port(struct asd_sas_port *port) { }
-
-#endif /* SAS_DEBUG */
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 0001374..8b538bd 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -33,11 +33,7 @@
 
 #define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
 
-#ifdef SAS_DEBUG
-#define SAS_DPRINTK(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
-#else
-#define SAS_DPRINTK(fmt, ...)
-#endif
+#define SAS_DPRINTK(fmt, ...) printk(KERN_DEBUG "sas: " fmt, ## __VA_ARGS__)
 
 #define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
 #define ASSIGN_SAS_TASK(_sc, _t) do { (_sc)->host_scribble = (void *) _t; } while (0)


