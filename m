From: Andi Kleen <ak@suse.de>
Subject: [PATCH] Mark initio.c driver as x86-32 only
Date: Thu, 12 Jul 2007 12:52:17 +0200
Message-ID: <200707121252.17201.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42405 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760341AbXGLKwW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2007 06:52:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com


initio.h contains this structure that is passed to the hardware:

typedef struct Scsi_Ctrl_Blk {
	struct Scsi_Ctrl_Blk *SCB_NxtScb;
	UBYTE SCB_Status;	/*4 */
	UBYTE SCB_NxtStat;	/*5 */
	UBYTE SCB_Mode;		/*6 */
	UBYTE SCB_Msgin;	/*7 SCB_Res0 */
        ...


Which is obviously not 64bit safe. It also doesn't seem to dma map this 
structure at all.

Mark the driver as X86_32 only in Kconfig.

Signed-off-by: Andi Kleen <ak@suse.de>

diff -u linux-2.6.22-dma/drivers/scsi/Kconfig-o linux-2.6.22-dma/drivers/scsi/Kconfig
--- linux-2.6.22-dma/drivers/scsi/Kconfig-o	2007-07-11 14:24:21.000000000 +0200
+++ linux-2.6.22-dma/drivers/scsi/Kconfig	2007-07-12 12:49:19.000000000 +0200
@@ -845,7 +845,8 @@
 
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
-	depends on PCI && SCSI
+	# driver not 64bit safe and doesn't use pci dma API consistently
+	depends on PCI && SCSI && X86_32
 	help
 	  This is support for the Initio 91XXU(W) SCSI host adapter.  Please
 	  read the SCSI-HOWTO, available from


