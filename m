From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [(re)Announce] Emulex LightPulse Device Driver
Date: Tue, 18 May 2004 12:59:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040518125950.A9363@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F92F0@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:22797 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262972AbUERL7y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 07:59:54 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F92F0@xbl.ma.emulex.com>; from James.Smart@Emulex.com on Sun, May 09, 2004 at 12:33:35AM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

the driver lacks dma-mapping includes all over the place which makes it
fail at least on ppc32.  while we're at it reorder includes alphabetically.


diff -urp lpfcdriver-2.6-8.0.1/lpfc_ct.c lpfcdriver-2.6-8.0.1.hch/lpfc_ct.c
--- lpfcdriver-2.6-8.0.1/lpfc_ct.c	2004-05-16 20:03:37.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc_ct.c	2004-05-18 13:17:42.595315904 +0200
@@ -28,6 +28,7 @@
 #include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/utsname.h>
+#include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <linux/utsname.h>
 
diff -urp lpfcdriver-2.6-8.0.1/lpfc_els.c lpfcdriver-2.6-8.0.1.hch/lpfc_els.c
--- lpfcdriver-2.6-8.0.1/lpfc_els.c	2004-05-16 20:03:37.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc_els.c	2004-05-18 13:18:09.426236984 +0200
@@ -21,12 +21,11 @@
 /*
  * $Id: lpfc_els.c,v 1.10 2004/05/16 14:24:55 jselx Exp $
  */
-#include <linux/version.h>
-#include <linux/spinlock.h>
-#include <linux/pci.h>
-
-
 #include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/version.h>
 #include <scsi/scsi_device.h>
 
 #include "lpfc_hw.h"
diff -urp lpfcdriver-2.6-8.0.1/lpfc_hbadisc.c lpfcdriver-2.6-8.0.1.hch/lpfc_hbadisc.c
--- lpfcdriver-2.6-8.0.1/lpfc_hbadisc.c	2004-05-16 20:03:37.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc_hbadisc.c	2004-05-18 13:18:39.805618616 +0200
@@ -22,12 +22,12 @@
  * $Id: lpfc_hbadisc.c,v 1.10 2004/05/16 14:24:55 jselx Exp $
  */
 
-#include <linux/version.h>
-#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/version.h>
 
-
-#include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 
diff -urp lpfcdriver-2.6-8.0.1/lpfc_init.c lpfcdriver-2.6-8.0.1.hch/lpfc_init.c
--- lpfcdriver-2.6-8.0.1/lpfc_init.c	2004-05-16 20:03:37.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc_init.c	2004-05-18 13:19:08.068322032 +0200
@@ -22,14 +22,14 @@
  * $Id: lpfc_init.c,v 1.10 2004/05/16 14:30:20 jselx Exp $
  */
 
-#include <linux/version.h>
-#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/ctype.h>
+#include <linux/dma-mapping.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/version.h>
 
-
-#include <linux/blkdev.h>
 #include <scsi/scsi_device.h>
-#include <linux/ctype.h>
 
 #include "lpfc_version.h"
 #include "lpfc_hw.h"
diff -urp lpfcdriver-2.6-8.0.1/lpfc_mbox.c lpfcdriver-2.6-8.0.1.hch/lpfc_mbox.c
--- lpfcdriver-2.6-8.0.1/lpfc_mbox.c	2004-05-16 20:03:37.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc_mbox.c	2004-05-18 13:19:35.834100992 +0200
@@ -21,12 +21,12 @@
 /*
  * $Id: lpfc_mbox.c,v 1.8 2004/04/29 23:24:00 jselx Exp $
  */
-#include <linux/version.h>
-#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/version.h>
 
-
-#include <linux/blkdev.h>
 #include <scsi/scsi_device.h>
 
 #include "lpfc_hw.h"
diff -urp lpfcdriver-2.6-8.0.1/lpfc_nportdisc.c lpfcdriver-2.6-8.0.1.hch/lpfc_nportdisc.c
--- lpfcdriver-2.6-8.0.1/lpfc_nportdisc.c	2004-05-16 20:03:37.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc_nportdisc.c	2004-05-18 13:20:00.839299624 +0200
@@ -22,12 +22,12 @@
  * $Id: lpfc_nportdisc.c,v 1.10 2004/05/16 14:31:05 jselx Exp $
  */
 
-#include <linux/version.h>
-#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/version.h>
 
-
-#include <linux/blkdev.h>
 #include <scsi/scsi_device.h>
 
 #include "lpfc_hw.h"
diff -urp lpfcdriver-2.6-8.0.1/lpfc_sli.c lpfcdriver-2.6-8.0.1.hch/lpfc_sli.c
--- lpfcdriver-2.6-8.0.1/lpfc_sli.c	2004-05-16 20:03:38.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc_sli.c	2004-05-18 12:58:15.823692152 +0200
@@ -27,6 +27,7 @@
 
 
 #include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <scsi/scsi_device.h>
 
