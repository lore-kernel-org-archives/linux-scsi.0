From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: remove final hosts.h usage removal
Date: Sat, 19 Jun 2004 17:56:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040619155634.GA2756@devserv.devel.redhat.com>
References: <20040619153341.GA28055@devserv.devel.redhat.com> <1087659680.1747.77.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:27776 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264085AbUFSP5L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 11:57:11 -0400
Content-Disposition: inline
In-Reply-To: <1087659680.1747.77.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, gregkh@kroah.com, rmk@arm.linux.org.uk

On Sat, Jun 19, 2004 at 10:41:19AM -0500, James Bottomley wrote:
> On Sat, 2004-06-19 at 10:33, Arjan van de Ven wrote:
> > the patch eblow finishes off the removal of the obsolete hosts.h usage, and
> > now that the users are gone, it's safe to turn on the warning to
> > prevent accidental future use... Please apply
> 
> Er, a quick look in drivers/scsi/arm shows it still to be in use...
> 
> jejb@mulgrave> grep hosts\\.h drivers/scsi/arm/*.c
> drivers/scsi/arm/acornscsi.c:#include "../hosts.h"
> drivers/scsi/arm/arxescsi.c:#include "../hosts.h"
> drivers/scsi/arm/cumana_1.c:#include "../hosts.h"
> drivers/scsi/arm/cumana_2.c:#include "../hosts.h"
> drivers/scsi/arm/ecoscsi.c:#include "../hosts.h"
> drivers/scsi/arm/eesox.c:#include "../hosts.h"
> drivers/scsi/arm/fas216.c:#include "../hosts.h"
> drivers/scsi/arm/oak.c:#include "../hosts.h"
> drivers/scsi/arm/powertec.c:#include "../hosts.h"

ok whacked those too; updated patch below

diff -urNp linux-2.6.7/drivers/scsi/hosts.h linux/drivers/scsi/hosts.h
--- linux-2.6.7/drivers/scsi/hosts.h
+++ linux/drivers/scsi/hosts.h
@@ -1,2 +1,2 @@
-// #warning "This file is obsolete, please use <scsi/scsi_host.h> instead"
+#warning "This file is obsolete, please use <scsi/scsi_host.h> instead"
 #include <scsi/scsi_host.h>
diff -purN linux-2.6.7/drivers/block/cciss_scsi.c linux/drivers/block/cciss_scsi.c
--- linux-2.6.7/drivers/block/cciss_scsi.c	2004-06-16 07:19:01.000000000 +0200
+++ linux/drivers/block/cciss_scsi.c	2004-06-19 17:24:11.000000000 +0200
@@ -29,7 +29,7 @@
    physical nor logical disks are presented through the scsi layer. */
 
 #include "../scsi/scsi.h" 
-#include "../scsi/hosts.h" 
+#include <scsi/scsi_host.h> 
 #include <asm/atomic.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff -purN linux-2.6.7/drivers/fc4/fc.c linux/drivers/fc4/fc.c
--- linux-2.6.7/drivers/fc4/fc.c	2004-06-16 07:19:36.000000000 +0200
+++ linux/drivers/fc4/fc.c	2004-06-19 17:53:00.262612588 +0200
@@ -38,7 +38,7 @@
 #include <asm/irq.h>
 #include <asm/semaphore.h>
 #include "fcp_impl.h"
-#include "../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 /* #define FCDEBUG */
 
diff -purN linux-2.6.7/drivers/ieee1394/sbp2.c linux/drivers/ieee1394/sbp2.c
--- linux-2.6.7/drivers/ieee1394/sbp2.c	2004-06-16 07:18:58.000000000 +0200
+++ linux/drivers/ieee1394/sbp2.c	2004-06-19 17:24:29.000000000 +0200
@@ -65,7 +65,7 @@
 #include <asm/scatterlist.h>
 
 #include "../scsi/scsi.h"
-#include "../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "csr1212.h"
 #include "ieee1394.h"
diff -purN linux-2.6.7/drivers/message/fusion/mptctl.c linux/drivers/message/fusion/mptctl.c
--- linux-2.6.7/drivers/message/fusion/mptctl.c	2004-06-19 17:17:10.000000000 +0200
+++ linux/drivers/message/fusion/mptctl.c	2004-06-19 17:24:45.000000000 +0200
@@ -91,7 +91,7 @@
 #include <linux/kdev_t.h>	/* needed for access to Scsi_Host struct */
 #include <linux/blkdev.h>
 #include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 #define COPYRIGHT	"Copyright (c) 1999-2004 LSI Logic Corporation"
 #define MODULEAUTHOR	"Steven J. Ralston, Noah Romer, Pamela Delaney"
diff -purN linux-2.6.7/drivers/net/fc/iph5526.c linux/drivers/net/fc/iph5526.c
--- linux-2.6.7/drivers/net/fc/iph5526.c	2004-06-16 07:19:01.000000000 +0200
+++ linux/drivers/net/fc/iph5526.c	2004-06-19 17:54:01.717117098 +0200
@@ -52,7 +52,7 @@ static const char *version =
 			       others + includes if_fcdevice.h */
 
 #include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 #include "../../fc4/fcp.h"
 
 #include <asm/system.h>
diff -purN linux-2.6.7/drivers/scsi/aha152x.c linux/drivers/scsi/aha152x.c
--- linux-2.6.7/drivers/scsi/aha152x.c	2004-06-16 07:18:56.000000000 +0200
+++ linux/drivers/scsi/aha152x.c	2004-06-19 17:25:38.000000000 +0200
@@ -257,7 +257,7 @@
 #include <scsi/scsicam.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "aha152x.h"
 
 
diff -purN linux-2.6.7/drivers/scsi/arm/acornscsi.c linux/drivers/scsi/arm/acornscsi.c
--- linux-2.6.7/drivers/scsi/arm/acornscsi.c	2004-06-16 07:19:23.000000000 +0200
+++ linux/drivers/scsi/arm/acornscsi.c	2004-06-19 17:53:20.325165386 +0200
@@ -150,7 +150,7 @@
 #include <asm/ecard.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 #include "acornscsi.h"
 #include "msgqueue.h"
 #include "scsi.h"
diff -purN linux-2.6.7/drivers/scsi/arm/arxescsi.c linux/drivers/scsi/arm/arxescsi.c
--- linux-2.6.7/drivers/scsi/arm/arxescsi.c	2004-06-16 07:19:23.000000000 +0200
+++ linux/drivers/scsi/arm/arxescsi.c	2004-06-19 17:53:21.610008670 +0200
@@ -37,7 +37,7 @@
 #include <asm/ecard.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 #include "fas216.h"
 
 struct arxescsi_info {
diff -purN linux-2.6.7/drivers/scsi/arm/cumana_1.c linux/drivers/scsi/arm/cumana_1.c
--- linux-2.6.7/drivers/scsi/arm/cumana_1.c	2004-06-16 07:18:57.000000000 +0200
+++ linux/drivers/scsi/arm/cumana_1.c	2004-06-19 17:53:22.691876713 +0200
@@ -17,7 +17,7 @@
 #include <asm/system.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 
 #include <scsi/scsicam.h>
 
diff -purN linux-2.6.7/drivers/scsi/arm/cumana_2.c linux/drivers/scsi/arm/cumana_2.c
--- linux-2.6.7/drivers/scsi/arm/cumana_2.c	2004-06-16 07:19:43.000000000 +0200
+++ linux/drivers/scsi/arm/cumana_2.c	2004-06-19 17:53:23.785743294 +0200
@@ -35,7 +35,7 @@
 #include <asm/pgtable.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 #include "fas216.h"
 #include "scsi.h"
 
diff -purN linux-2.6.7/drivers/scsi/arm/ecoscsi.c linux/drivers/scsi/arm/ecoscsi.c
--- linux-2.6.7/drivers/scsi/arm/ecoscsi.c	2004-06-16 07:20:04.000000000 +0200
+++ linux/drivers/scsi/arm/ecoscsi.c	2004-06-19 17:53:24.873610606 +0200
@@ -33,7 +33,7 @@
 #include <asm/system.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 
 #define NCR5380_implementation_fields	int port, ctrl
 #define NCR5380_local_declare()		struct Scsi_Host *_instance
diff -purN linux-2.6.7/drivers/scsi/arm/eesox.c linux/drivers/scsi/arm/eesox.c
--- linux-2.6.7/drivers/scsi/arm/eesox.c	2004-06-16 07:20:26.000000000 +0200
+++ linux/drivers/scsi/arm/eesox.c	2004-06-19 17:53:25.976476090 +0200
@@ -41,7 +41,7 @@
 #include <asm/pgtable.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 #include "fas216.h"
 #include "scsi.h"
 
diff -purN linux-2.6.7/drivers/scsi/arm/fas216.c linux/drivers/scsi/arm/fas216.c
--- linux-2.6.7/drivers/scsi/arm/fas216.c	2004-06-16 07:19:13.000000000 +0200
+++ linux/drivers/scsi/arm/fas216.c	2004-06-19 17:53:28.377183278 +0200
@@ -52,7 +52,7 @@
 #include <asm/ecard.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 #include "fas216.h"
 #include "scsi.h"
 
diff -purN linux-2.6.7/drivers/scsi/arm/oak.c linux/drivers/scsi/arm/oak.c
--- linux-2.6.7/drivers/scsi/arm/oak.c	2004-06-16 07:18:37.000000000 +0200
+++ linux/drivers/scsi/arm/oak.c	2004-06-19 17:53:31.063855592 +0200
@@ -17,7 +17,7 @@
 #include <asm/system.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 
 #define AUTOSENSE
 /*#define PSEUDO_DMA*/
diff -purN linux-2.6.7/drivers/scsi/arm/powertec.c linux/drivers/scsi/arm/powertec.c
--- linux-2.6.7/drivers/scsi/arm/powertec.c	2004-06-16 07:19:37.000000000 +0200
+++ linux/drivers/scsi/arm/powertec.c	2004-06-19 17:53:32.231713152 +0200
@@ -26,7 +26,7 @@
 #include <asm/pgtable.h>
 
 #include "../scsi.h"
-#include "../hosts.h"
+#include <scsi/scsi_host.h>
 #include "fas216.h"
 #include "scsi.h"
 
diff -purN linux-2.6.7/drivers/scsi/gdth.c linux/drivers/scsi/gdth.c
--- linux-2.6.7/drivers/scsi/gdth.c	2004-06-16 07:19:37.000000000 +0200
+++ linux/drivers/scsi/gdth.c	2004-06-19 17:26:00.000000000 +0200
@@ -410,7 +410,7 @@
 #endif
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "gdth.h"
 
 static void gdth_delay(int milliseconds);
diff -purN linux-2.6.7/drivers/scsi/pcmcia/nsp_cs.c linux/drivers/scsi/pcmcia/nsp_cs.c
--- linux-2.6.7/drivers/scsi/pcmcia/nsp_cs.c	2004-06-19 17:17:06.000000000 +0200
+++ linux/drivers/scsi/pcmcia/nsp_cs.c	2004-06-19 17:26:24.000000000 +0200
@@ -46,7 +46,7 @@
 #include <asm/irq.h>
 
 #include <../drivers/scsi/scsi.h>
-#include <../drivers/scsi/hosts.h>
+#include <scsi/scsi_host.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
diff -purN linux-2.6.7/drivers/usb/image/hpusbscsi.c linux/drivers/usb/image/hpusbscsi.c
--- linux-2.6.7/drivers/usb/image/hpusbscsi.c	2004-06-16 07:20:26.000000000 +0200
+++ linux/drivers/usb/image/hpusbscsi.c	2004-06-19 17:25:04.000000000 +0200
@@ -11,7 +11,7 @@
 #include <asm/atomic.h>
 #include <linux/blkdev.h>
 #include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "hpusbscsi.h"
 
diff -purN linux-2.6.7/drivers/usb/image/microtek.c linux/drivers/usb/image/microtek.c
--- linux-2.6.7/drivers/usb/image/microtek.c	2004-06-16 07:20:26.000000000 +0200
+++ linux/drivers/usb/image/microtek.c	2004-06-19 17:25:20.000000000 +0200
@@ -136,7 +136,7 @@
 #include <asm/atomic.h>
 #include <linux/blkdev.h>
 #include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "microtek.h"
 
