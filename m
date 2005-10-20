From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] procfs support for sgiwd93
Date: Thu, 20 Oct 2005 19:04:34 +0100
Message-ID: <20051020180434.GA24813@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extgw-uk.mips.com ([62.254.210.129]:57623 "EHLO
	bacchus.net.dhis.org") by vger.kernel.org with ESMTP
	id S932514AbVJTSEq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 14:04:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>

So then without the offending procfs line; I assume this part should be ok.

Move the remaining bits of sgiwd93.h into sgiwd93.c; replace the use of
CMD_PER_LUN and CAN_QUEUE by raw numbers.

Signed-off-by: Thiemo Seufer <ths@networkno.de>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/scsi/sgiwd93.h |   24 ------------------------
 drivers/scsi/sgiwd93.c |    5 ++---
 2 files changed, 2 insertions(+), 27 deletions(-)

Index: manual-akpm.git/drivers/scsi/sgiwd93.c
===================================================================
--- manual-akpm.git.orig/drivers/scsi/sgiwd93.c
+++ manual-akpm.git/drivers/scsi/sgiwd93.c
@@ -33,7 +33,6 @@
 #include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "wd33c93.h"
-#include "sgiwd93.h"
 
 #include <linux/stat.h>
 
@@ -335,10 +334,10 @@ static Scsi_Host_Template driver_templat
 	.eh_abort_handler	= wd33c93_abort,
 	.eh_bus_reset_handler	= sgiwd93_bus_reset,
 	.eh_host_reset_handler	= wd33c93_host_reset,
-	.can_queue		= CAN_QUEUE,
+	.can_queue		= 16,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= CMD_PER_LUN,
+	.cmd_per_lun		= 8,
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 #include "scsi_module.c"
Index: manual-akpm.git/drivers/scsi/sgiwd93.h
===================================================================
--- manual-akpm.git.orig/drivers/scsi/sgiwd93.h
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
