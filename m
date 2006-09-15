From: Henne <henne@nachtwindheim.de>
Subject: [PATCH 1/2] scsi: remove seagate.h
Date: Fri, 15 Sep 2006 18:50:34 +0200
Message-ID: <450AD9DA.7030105@nachtwindheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server6.greatnet.de ([83.133.96.26]:40623 "EHLO
	server6.greatnet.de") by vger.kernel.org with ESMTP
	id S1750754AbWIOQua (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 12:50:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Removes seagate.h from the kerneltree.
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---

diff -ruN linux-2.6.18-rc7-git1/drivers/scsi/Kconfig devel/drivers/scsi/Kconfig
--- linux-2.6.18-rc7-git1/drivers/scsi/Kconfig	2006-08-01 01:31:43.000000000 +0200
+++ devel/drivers/scsi/Kconfig	2006-09-15 18:03:12.000000000 +0200
@@ -1368,8 +1368,8 @@
 	  These are 8-bit SCSI controllers; the ST-01 is also supported by
 	  this driver.  It is explained in section 3.9 of the SCSI-HOWTO,
 	  available from <http://www.tldp.org/docs.html#howto>.  If it
-	  doesn't work out of the box, you may have to change some settings in
-	  <file:drivers/scsi/seagate.h>.
+	  doesn't work out of the box, you may have to change some macros at
+	  compiletime, which are described in <file:drivers/scsi/seagate.c>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called seagate.
diff -ruN linux-2.6.18-rc7-git1/drivers/scsi/seagate.c devel/drivers/scsi/seagate.c
--- linux-2.6.18-rc7-git1/drivers/scsi/seagate.c	2006-08-01 01:31:43.000000000 +0200
+++ devel/drivers/scsi/seagate.c	2006-09-15 17:49:44.000000000 +0200
@@ -106,7 +106,6 @@
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
-#include "seagate.h"
 
 #include <scsi/scsi_ioctl.h>
 
@@ -322,6 +321,7 @@
 static int hostno = -1;
 static void seagate_reconnect_intr (int, void *, struct pt_regs *);
 static irqreturn_t do_seagate_reconnect_intr (int, void *, struct pt_regs *);
+static int seagate_st0x_bus_reset(Scsi_Cmnd *);
 
 #ifdef FAST
 static int fast = 1;
diff -ruN linux-2.6.18-rc7-git1/drivers/scsi/seagate.h devel/drivers/scsi/seagate.h
--- linux-2.6.18-rc7-git1/drivers/scsi/seagate.h	2006-08-01 01:31:43.000000000 +0200
+++ devel/drivers/scsi/seagate.h	1970-01-01 01:00:00.000000000 +0100
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


