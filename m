From: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] procfs support for sgiwd93
Date: Sat, 15 Oct 2005 02:38:24 +0100
Message-ID: <20051015013824.GA25248@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extgw-uk.mips.com ([62.254.210.129]:34312 "EHLO
	bacchus.net.dhis.org") by vger.kernel.org with ESMTP
	id S932253AbVJQKLs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:11:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>

FYI and reviewing pleassure.

Author: Thiemo Seufer <ths@networkno.de>
Date:   Tue Apr 12 14:00:38 2005 +0000

Enable proc support, minor code cleanup.

Signed-off-by: Thiemo Seufer <ths@networkno.de>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/scsi/sgiwd93.h |   24 ------------------------
 drivers/scsi/sgiwd93.c |    8 ++++----
 2 files changed, 4 insertions(+), 28 deletions(-)

Index: manual.git/drivers/scsi/sgiwd93.c
===================================================================
--- manual.git.orig/drivers/scsi/sgiwd93.c
+++ manual.git/drivers/scsi/sgiwd93.c
@@ -33,7 +33,6 @@
 #include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "wd33c93.h"
-#include "sgiwd93.h"
 
 #include <linux/stat.h>
 
@@ -327,7 +326,6 @@ static int sgiwd93_bus_reset(Scsi_Cmnd *
  * on 64-bit systems with memory outside the compat address spaces.
  */
 static Scsi_Host_Template driver_template = {
-	.proc_name		= "SGIWD93",
 	.name			= "SGI WD93",
 	.detect			= sgiwd93_detect,
 	.release		= sgiwd93_release,
@@ -335,10 +333,12 @@ static Scsi_Host_Template driver_templat
 	.eh_abort_handler	= wd33c93_abort,
 	.eh_bus_reset_handler	= sgiwd93_bus_reset,
 	.eh_host_reset_handler	= wd33c93_host_reset,
-	.can_queue		= CAN_QUEUE,
+	.proc_info		= wd33c93_proc_info,
+	.proc_name		= "SGIWD93",
+	.can_queue		= 16,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= CMD_PER_LUN,
+	.cmd_per_lun		= 8,
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 #include "scsi_module.c"
Index: manual.git/drivers/scsi/sgiwd93.h
===================================================================
--- manual.git.orig/drivers/scsi/sgiwd93.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* $Id: sgiwd93.h,v 1.5 1998/08/25 09:18:50 ralf Exp $
- * sgiwd93.h: SGI WD93 scsi definitions.
- *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
- */
-#ifndef _SGIWD93_H
-#define _SGIWD93_H
-
-#ifndef CMD_PER_LUN
-#define CMD_PER_LUN 8
-#endif
-
-#ifndef CAN_QUEUE
-#define CAN_QUEUE   16
-#endif
-
-int sgiwd93_detect(Scsi_Host_Template *);
-int sgiwd93_release(struct Scsi_Host *instance);
-const char *wd33c93_info(void);
-int wd33c93_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-int wd33c93_abort(Scsi_Cmnd *);
-int wd33c93_host_reset(Scsi_Cmnd * SCpnt);
-
-#endif /* !(_SGIWD93_H) */
