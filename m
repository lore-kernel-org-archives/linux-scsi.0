From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Patch: linux-2.5.47/drivers/scsi/megaraid.c set pcidev.dma_mask directly
Date: Sat, 16 Nov 2002 06:29:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021116062944.A18441@baldur.yggdrasil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, atulm@lsil.com, johnsom@home.com, kgb@knm.org.pl


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

        linux-2.5.47/drivers/scsi/megaraid.c directly sets
pci_dev->dma_mask instead of calling pci_set_dma_mask.
pci_dev.dma_mask may be moved soon (probably to
pci_dev.device.dma_mask).  So, applying this patch will reduce or
eliminate the need to change this code when that happens, and it will
be one less change to maintain between 2.4 and 2.5+ kernels.

        If these changes look OK, then I would appreciate it if the
appropriate maintainers (Atul, James?) would shepherd this patch to
Linus or let me know if there is something more I should do.

-- 
Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="diffs.megaraid"

--- linux-2.5.47/drivers/scsi/megaraid.c	2002-11-10 19:28:01.000000000 -0800
+++ linux/drivers/scsi/megaraid.c	2002-11-16 05:54:00.000000000 -0800
@@ -3150,9 +3173,9 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		if ((megaCfg->flag & BOARD_64BIT) && BITS_PER_LONG == 64)
 #ifdef __LP64__
-			pdev->dma_mask = 0xffffffffffffffff;
+			pci_set_dma_mask(pdev, 0xffffffffffffffff);
 #else
-			pdev->dma_mask = 0xffffffff;
+			pci_set_dma_mask(pdev, 0xffffffff);
 #endif
 #endif
 		continue;

--OXfL5xGRrasGEqWY--
