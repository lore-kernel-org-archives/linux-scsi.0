From: Matt Domsch <Matt_Domsch@dell.com>
Subject: [PATCH 2.4.30-pre1] aic7xxx: don't reset chip on pause
Date: Fri, 18 Feb 2005 15:50:50 -0600
Message-ID: <20050218215049.GA1960@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from linux.us.dell.com ([143.166.224.162]:59743 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261514AbVBRVuv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 16:50:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com
Cc: linux-scsi@vger.kernel.org

Patch below taken from RHEL3 Update 4 kernel 2.4.21-27.EL, fixes a bug
in the aic79xx and aic7xxx drivers, where upon trying to pause the
controller chip, it is accidentally hard-reset.  This causes PCI
Parity errors to appear on Dell PowerEdge 4600 servers as the inb()
immediately after accidental reset receives corrupted data.

Patch was submitted by Justin Gibbs many moons ago, but never applied
to mainline 2.4.  Marcelo, please apply.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

diff -urNp --exclude-from=/home/mdomsch/excludes --minimal ./aic79xx_pci.c /home/mdomsch/kernels/linux-2.4.21-27.EL/drivers/scsi/aic7xxx/aic79xx_pci.c
--- ./aic79xx_pci.c	Fri Feb 18 14:38:22 2005
+++ linux/drivers/scsi/aic7xxx/aic79xx_pci.c	Wed Dec  1 20:49:28 2004
@@ -451,8 +457,10 @@ ahd_pci_test_register_access(struct ahd_
 	 * or read prefetching could be initiated by the
 	 * CPU or host bridge.  Our device does not support
 	 * either, so look for data corruption and/or flaged
-	 * PCI errors.
+	 * PCI errors.  First pause without causing another
+	 * chip reset.
 	 */
+	hcntrl &= ~CHIPRST;
 	ahd_outb(ahd, HCNTRL, hcntrl|PAUSE);
 	while (ahd_is_paused(ahd) == 0)
 		;
diff -urNp --exclude-from=/home/mdomsch/excludes --minimal ./aic7xxx_pci.c /home/mdomsch/kernels/linux-2.4.21-27.EL/drivers/scsi/aic7xxx/aic7xxx_pci.c
--- ./aic7xxx_pci.c	Fri Feb 18 14:38:22 2005
+++ /home/mdomsch/kernels/linux-2.4.21-27.EL/drivers/scsi/aic7xxx/aic7xxx_pci.c	Wed Dec  1 20:49:28 2004
@@ -1284,8 +1284,10 @@ ahc_pci_test_register_access(struct ahc_
 	 * or read prefetching could be initiated by the
 	 * CPU or host bridge.  Our device does not support
 	 * either, so look for data corruption and/or flagged
-	 * PCI errors.
+	 * PCI errors.  First pause without causing another
+	 * chip reset.
 	 */
+	hcntrl &= ~CHIPRST;
 	ahc_outb(ahc, HCNTRL, hcntrl|PAUSE);
 	while (ahc_is_paused(ahc) == 0)
 		;
