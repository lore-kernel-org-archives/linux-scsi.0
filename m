From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] remove a bogus check in sym2 driver
Date: Tue, 24 Jun 2003 13:34:22 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624033422.GB927@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:48020 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S265641AbTFXDYh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 23:24:37 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: akpm@digeo.com


Hi,

The sym2 driver has a check for a very broken bios where it seems 
devices appear twice. This test is broken on a machine with PCI domains
since busnumber:devfn is not a unique identifier.

When we move to the scsi hotplug interface all this code will go away
but in the short term we need the following fix.

Anton

===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.23 vs edited =====
--- 1.23/drivers/scsi/sym53c8xx_2/sym_glue.c	Tue Jun 10 09:09:11 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Tue Jun 17 10:37:43 2003
@@ -2752,14 +2757,6 @@
 		}
 		/* This one is guaranteed by AC to do nothing :-) */
 		if (pci_enable_device(pcidev))
-			continue;
-		/* Some HW as the HP LH4 may report twice PCI devices */
-		for (i = 0; i < count ; i++) {
-			if (devtbl[i].s.bus       == PciBusNumber(pcidev) && 
-			    devtbl[i].s.device_fn == PciDeviceFn(pcidev))
-				break;
-		}
-		if (i != count)	/* Ignore this device if we already have it */
 			continue;
 		devp = &devtbl[count];
 		devp->host_id = SYM_SETUP_HOST_ID;
