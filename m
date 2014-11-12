From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 18/37] mac_scsi: Remove header
Date: Wed, 12 Nov 2014 16:12:04 +1100
Message-ID: <20141112051150.745455089@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40988 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbaKLFnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:20 -0500
Content-Disposition: inline; filename=mac_scsi-remove-header
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

The #defines in mac_scsi.h are intended to influence subsequent #includes in
mac_scsi.c. IMHO, that's too convoluted.

Remove mac_scsi.h by moving those macro definitions to mac_scsi.c,
consistent with other NCR5380 drivers.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/mac_scsi.c |   21 ++++++++++++++++++++-
 drivers/scsi/mac_scsi.h |   42 ------------------------------------------
 2 files changed, 20 insertions(+), 43 deletions(-)

Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-11-12 16:11:16.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-11-12 16:11:20.000000000 +1100
@@ -31,10 +31,29 @@
 #include <asm/mac_via.h>
 
 #include <scsi/scsi_host.h>
-#include "mac_scsi.h"
+
+/* Definitions for the core NCR5380 driver. */
 
 #define PSEUDO_DMA
 
+#define NCR5380_implementation_fields   /* none */
+#define NCR5380_local_declare()         struct Scsi_Host *_instance
+#define NCR5380_setup(instance)         _instance = instance
+
+#define NCR5380_read(reg)               macscsi_read(_instance, reg)
+#define NCR5380_write(reg, value)       macscsi_write(_instance, reg, value)
+
+#define NCR5380_pread                   macscsi_pread
+#define NCR5380_pwrite                  macscsi_pwrite
+
+#define NCR5380_intr                    macscsi_intr
+#define NCR5380_queue_command           macscsi_queue_command
+#define NCR5380_abort                   macscsi_abort
+#define NCR5380_bus_reset               macscsi_bus_reset
+#define NCR5380_info                    macscsi_info
+#define NCR5380_show_info               macscsi_show_info
+#define NCR5380_write_info              macscsi_write_info
+
 #include "NCR5380.h"
 
 #define RESET_BOOT
Index: linux/drivers/scsi/mac_scsi.h
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.h	2014-11-12 16:11:13.000000000 +1100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,42 +0,0 @@
-/*
- * Cumana Generic NCR5380 driver defines
- *
- * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *      +1 (303) 440-4894
- */
-
-#ifndef MAC_NCR5380_H
-#define MAC_NCR5380_H
-
-#ifndef ASM
-
-#include <scsi/scsicam.h>
-
-#define NCR5380_implementation_fields /* none */
-
-#define NCR5380_local_declare() \
-        struct Scsi_Host *_instance
-
-#define NCR5380_setup(instance) \
-        _instance = instance
-
-#define NCR5380_read(reg) macscsi_read(_instance, reg)
-#define NCR5380_write(reg, value) macscsi_write(_instance, reg, value)
-
-#define NCR5380_pread 	macscsi_pread
-#define NCR5380_pwrite 	macscsi_pwrite
-	
-#define NCR5380_intr macscsi_intr
-#define NCR5380_queue_command macscsi_queue_command
-#define NCR5380_abort macscsi_abort
-#define NCR5380_bus_reset macscsi_bus_reset
-#define NCR5380_info macscsi_info
-#define NCR5380_show_info macscsi_show_info
-#define NCR5380_write_info macscsi_write_info
-
-#endif /* ndef ASM */
-#endif /* MAC_NCR5380_H */
-


