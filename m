From: Arjan van de Ven <arjanv@redhat.com>
Subject: remove final hosts.h usage removal
Date: Sat, 19 Jun 2004 17:33:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040619153341.GA28055@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:9190 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264034AbUFSPeB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 11:34:01 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gregkh@kroah.com

Hi,

the patch eblow finishes off the removal of the obsolete hosts.h usage, and
now that the users are gone, it's safe to turn on the warning to
prevent accidental future use... Please apply

Greetings,
    Arjan van de Ven


diff -urNp linux-2.6.7/drivers/scsi/hosts.h linux/drivers/scsi/hosts.h
--- linux-2.6.7/drivers/scsi/hosts.h
+++ linux/drivers/scsi/hosts.h
@@ -1,2 +1,2 @@
-// #warning "This file is obsolete, please use <scsi/scsi_host.h> instead"
+#warning "This file is obsolete, please use <scsi/scsi_host.h> instead"
 #include <scsi/scsi_host.h>
diff -purN linux-2.6.7/drivers/block/cciss_scsi.c linux/drivers/block/cciss_scsi.c
--- linux-2.6.7/drivers/block/cciss_scsi.c	2004-06-16 07:19:01.000000000 +0200
+++ linux/drivers/block/cciss_scsi.c	2004-06-19 17:24:11.306282203 +0200
@@ -29,7 +29,7 @@
    physical nor logical disks are presented through the scsi layer. */
 
 #include "../scsi/scsi.h" 
-#include "../scsi/hosts.h" 
+#include <scsi/scsi_host.h> 
 #include <asm/atomic.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff -purN linux-2.6.7/drivers/ieee1394/sbp2.c linux/drivers/ieee1394/sbp2.c
--- linux-2.6.7/drivers/ieee1394/sbp2.c	2004-06-16 07:18:58.000000000 +0200
+++ linux/drivers/ieee1394/sbp2.c	2004-06-19 17:24:29.256128871 +0200
@@ -65,7 +65,7 @@
 #include <asm/scatterlist.h>
 
 #include "../scsi/scsi.h"
-#include "../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "csr1212.h"
 #include "ieee1394.h"
diff -purN linux-2.6.7/drivers/message/fusion/mptctl.c linux/drivers/message/fusion/mptctl.c
--- linux-2.6.7/drivers/message/fusion/mptctl.c	2004-06-19 17:17:10.000000000 +0200
+++ linux/drivers/message/fusion/mptctl.c	2004-06-19 17:24:45.333200094 +0200
@@ -91,7 +91,7 @@
 #include <linux/kdev_t.h>	/* needed for access to Scsi_Host struct */
 #include <linux/blkdev.h>
 #include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 #define COPYRIGHT	"Copyright (c) 1999-2004 LSI Logic Corporation"
 #define MODULEAUTHOR	"Steven J. Ralston, Noah Romer, Pamela Delaney"
diff -purN linux-2.6.7/drivers/scsi/aha152x.c linux/drivers/scsi/aha152x.c
--- linux-2.6.7/drivers/scsi/aha152x.c	2004-06-16 07:18:56.000000000 +0200
+++ linux/drivers/scsi/aha152x.c	2004-06-19 17:25:38.029877350 +0200
@@ -257,7 +257,7 @@
 #include <scsi/scsicam.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "aha152x.h"
 
 
diff -purN linux-2.6.7/drivers/scsi/gdth.c linux/drivers/scsi/gdth.c
--- linux-2.6.7/drivers/scsi/gdth.c	2004-06-16 07:19:37.000000000 +0200
+++ linux/drivers/scsi/gdth.c	2004-06-19 17:26:00.763149402 +0200
@@ -410,7 +410,7 @@
 #endif
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "gdth.h"
 
 static void gdth_delay(int milliseconds);
diff -purN linux-2.6.7/drivers/scsi/pcmcia/nsp_cs.c linux/drivers/scsi/pcmcia/nsp_cs.c
--- linux-2.6.7/drivers/scsi/pcmcia/nsp_cs.c	2004-06-19 17:17:06.000000000 +0200
+++ linux/drivers/scsi/pcmcia/nsp_cs.c	2004-06-19 17:26:24.214335099 +0200
@@ -46,7 +46,7 @@
 #include <asm/irq.h>
 
 #include <../drivers/scsi/scsi.h>
-#include <../drivers/scsi/hosts.h>
+#include <scsi/scsi_host.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
diff -purN linux-2.6.7/drivers/usb/image/hpusbscsi.c linux/drivers/usb/image/hpusbscsi.c
--- linux-2.6.7/drivers/usb/image/hpusbscsi.c	2004-06-16 07:20:26.000000000 +0200
+++ linux/drivers/usb/image/hpusbscsi.c	2004-06-19 17:25:04.513898845 +0200
@@ -11,7 +11,7 @@
 #include <asm/atomic.h>
 #include <linux/blkdev.h>
 #include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "hpusbscsi.h"
 
diff -purN linux-2.6.7/drivers/usb/image/microtek.c linux/drivers/usb/image/microtek.c
--- linux-2.6.7/drivers/usb/image/microtek.c	2004-06-16 07:20:26.000000000 +0200
+++ linux/drivers/usb/image/microtek.c	2004-06-19 17:25:20.304004284 +0200
@@ -136,7 +136,7 @@
 #include <asm/atomic.h>
 #include <linux/blkdev.h>
 #include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "microtek.h"
 
