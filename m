From: akpm@osdl.org
Subject: [patch 23/28] scsi: remove seagate.h
Date: Mon, 25 Sep 2006 16:59:09 -0700
Message-ID: <200609252359.k8PNx9aG003532@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:42683 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751774AbWIYX7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Removes seagate.h from the kernel tree.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/Kconfig   |    4 ++--
 drivers/scsi/seagate.c |    2 +-
 drivers/scsi/seagate.h |   19 -------------------
 3 files changed, 3 insertions(+), 22 deletions(-)

diff -puN drivers/scsi/Kconfig~scsi-remove-seagateh drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-remove-seagateh
+++ a/drivers/scsi/Kconfig
@@ -1262,8 +1262,8 @@ config SCSI_SEAGATE
 	  These are 8-bit SCSI controllers; the ST-01 is also supported by
 	  this driver.  It is explained in section 3.9 of the SCSI-HOWTO,
 	  available from <http://www.tldp.org/docs.html#howto>.  If it
-	  doesn't work out of the box, you may have to change some settings in
-	  <file:drivers/scsi/seagate.h>.
+	  doesn't work out of the box, you may have to change some macros at
+	  compiletime, which are described in <file:drivers/scsi/seagate.c>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called seagate.
diff -puN drivers/scsi/seagate.c~scsi-remove-seagateh drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c~scsi-remove-seagateh
+++ a/drivers/scsi/seagate.c
@@ -106,7 +106,6 @@
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
-#include "seagate.h"
 
 #include <scsi/scsi_ioctl.h>
 
@@ -322,6 +321,7 @@ static Signature __initdata signatures[]
 static int hostno = -1;
 static void seagate_reconnect_intr (int, void *, struct pt_regs *);
 static irqreturn_t do_seagate_reconnect_intr (int, void *, struct pt_regs *);
+static int seagate_st0x_bus_reset(Scsi_Cmnd *);
 
 #ifdef FAST
 static int fast = 1;
diff -puN drivers/scsi/seagate.h~scsi-remove-seagateh /dev/null
--- a/drivers/scsi/seagate.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- *	seagate.h Copyright (C) 1992 Drew Eckhardt 
- *	low level scsi driver header for ST01/ST02 by
- *		Drew Eckhardt 
- *
- *	<drew@colorado.edu>
- */
-
-#ifndef _SEAGATE_H
-#define SEAGATE_H
-
-static int seagate_st0x_detect(struct scsi_host_template *);
-static int seagate_st0x_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-
-static int seagate_st0x_abort(Scsi_Cmnd *);
-static const char *seagate_st0x_info(struct Scsi_Host *);
-static int seagate_st0x_bus_reset(Scsi_Cmnd *);
-
-#endif /* _SEAGATE_H */
_
