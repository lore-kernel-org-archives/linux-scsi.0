From: "Randy.Dunlap" <randy.dunlap@verizon.net>
Subject: [PATCH] fdomain screwup
Date: Wed, 23 Jun 2004 22:51:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040623225138.24d73e65.randy.dunlap@verizon.net>
References: <20040623132832.230133c9.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out008pub.verizon.net ([206.46.170.108]:47024 "EHLO
	out008.verizon.net") by vger.kernel.org with ESMTP id S261439AbUFXF5G
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 01:57:06 -0400
In-Reply-To: <20040623132832.230133c9.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>


| From: Andrew Morton
| To: linux-scsi@vger.kernel.org
| Subject: fdomain screwup
| 
| - fdomain_setup() is marked __init, but is called from non-__init
|   fdomain_16x0_detect()
| 
| - fdomain_setup() is declared in drivers/scsi/pcmcia/fdomain_stub.c as
|   taking two arguments, but is implemented in fdomain_setup() taking a
|   single argument.
| 
|   Please, never ever ever put extern function declarations in .c files. 
|   Put it in a header file which is visible to the definition and to all
|   callsites.
| 
| - fdomain_setup() is declared static, hence the linkage fails.
| 
| - fdomain_16x0_bus_reset() is implemented in drivers/scsi/fdomain.c but
|   has static scope, so the call from drivers/scsi/pcmcia/fdomain_stub.c
|   doesn't work.

[I didn't find this to be the case, so I didn't fix it.]

| - fdomain_16x0_bus_reset() has an extern declaration in
|   drivers/scsi/pcmcia/fdomain_stub.c.  This should be moved to a header
|   file which is visible to etc...

Builds and loads.  No hardware to test.

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>


diffstat:=
 drivers/scsi/fdomain.c             |    5 +++--
 drivers/scsi/fdomain.h             |   24 ++++++++++++++++++++++++
 drivers/scsi/pcmcia/fdomain_stub.c |   12 +++---------
 3 files changed, 30 insertions(+), 11 deletions(-)

diff -Naurp ./drivers/scsi/pcmcia/fdomain_stub.c~fdomain_screwup ./drivers/scsi/pcmcia/fdomain_stub.c
--- ./drivers/scsi/pcmcia/fdomain_stub.c~fdomain_screwup	2004-06-23 21:49:30.000000000 -0700
+++ ./drivers/scsi/pcmcia/fdomain_stub.c	2004-06-23 22:24:01.000000000 -0700
@@ -45,6 +45,7 @@
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
+#include "fdomain.h"
 
 #include <pcmcia/version.h>
 #include <pcmcia/cs_types.h>
@@ -84,10 +85,6 @@ typedef struct scsi_info_t {
     struct Scsi_Host	*host;
 } scsi_info_t;
 
-extern Scsi_Host_Template fdomain_driver_template;
-extern void fdomain_setup(char *str, int *ints);
-extern struct Scsi_Host *__fdomain_16x0_detect( Scsi_Host_Template *tpnt );
-extern int fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt);
 
 static void fdomain_release(dev_link_t *link);
 static int fdomain_event(event_t event, int priority,
@@ -189,7 +186,7 @@ static void fdomain_config(dev_link_t *l
     scsi_info_t *info = link->priv;
     tuple_t tuple;
     cisparse_t parse;
-    int i, last_ret, last_fn, ints[3];
+    int i, last_ret, last_fn;
     u_char tuple_data[64];
     char str[16];
     struct Scsi_Host *host;
@@ -229,11 +226,8 @@ static void fdomain_config(dev_link_t *l
     release_region(link->io.BasePort1, link->io.NumPorts1);
 
     /* Set configuration options for the fdomain driver */
-    ints[0] = 2;
-    ints[1] = link->io.BasePort1;
-    ints[2] = link->irq.AssignedIRQ;
     sprintf(str, "%d,%d", link->io.BasePort1, link->irq.AssignedIRQ);
-    fdomain_setup(str, ints);
+    fdomain_setup(str);
     
     host = __fdomain_16x0_detect(&fdomain_driver_template);
     if (!host) {
diff -Naurp ./drivers/scsi/fdomain.c~fdomain_screwup ./drivers/scsi/fdomain.c
--- ./drivers/scsi/fdomain.c~fdomain_screwup	2004-06-23 21:49:30.000000000 -0700
+++ ./drivers/scsi/fdomain.c	2004-06-23 22:10:32.000000000 -0700
@@ -286,6 +286,7 @@
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
+#include "fdomain.h"
 
 MODULE_AUTHOR("Rickard E. Faith");
 MODULE_DESCRIPTION("Future domain SCSI driver");
@@ -552,7 +553,7 @@ static void print_banner( struct Scsi_Ho
    printk( "\n" );
 }
 
-int __init fdomain_setup(char *str)
+int fdomain_setup(char *str)
 {
 	int ints[4];
 
@@ -902,7 +903,7 @@ struct Scsi_Host *__fdomain_16x0_detect(
    Write_FIFO_port       = port_base + Write_FIFO;
    Write_SCSI_Data_port  = port_base + Write_SCSI_Data;
 
-   fdomain_16x0_bus_reset( NULL);
+   fdomain_16x0_bus_reset(NULL);
 
    if (fdomain_test_loopback()) {
       printk(KERN_ERR  "scsi: <fdomain> Detection failed (loopback test failed at port base 0x%x)\n", port_base);
diff -Naurp ./drivers/scsi/fdomain.h~fdomain_screwup ./drivers/scsi/fdomain.h
--- ./drivers/scsi/fdomain.h~fdomain_screwup	2004-06-23 22:00:46.000000000 -0700
+++ ./drivers/scsi/fdomain.h	2004-06-23 22:22:39.000000000 -0700
@@ -0,0 +1,24 @@
+/*
+ * fdomain.c -- Future Domain TMC-16x0 SCSI driver
+ * Author: Rickard E. Faith, faith@cs.unc.edu
+ * Copyright 1992-1996, 1998 Rickard E. Faith (faith@acm.org)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+extern Scsi_Host_Template fdomain_driver_template;
+extern int fdomain_setup(char *str);
+extern struct Scsi_Host *__fdomain_16x0_detect( Scsi_Host_Template *tpnt );
+extern int fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt);


