From: Paul Jackson <pj@sgi.com>
Subject: SCSI QLA not working on latest *-mm SN2
Date: Wed, 15 Sep 2004 15:51:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915155132.177b51f2.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:37865 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267700AbUIOWwX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 18:52:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

Andrew Vasquez,

[My inbox had a message recommending a copy linux-scsi as well,
 so resending to include that list as well. ]

Jeremy Higdon recommended I send this to you.  I am running into
a fatal problem with SCSI QLA2, unable to boot using the latest *-mm
on SGI's SN2 hardware (don't know if other hardware involved or not).

This is on 2.6.9-rc1-mm5, and more recent variants of *-mm.

$ grep QLA2XXX_VERSION drivers/scsi/qla2xxx/qla_version.h
#define QLA2XXX_VERSION      "8.00.00b21-k"

My source currently includes the patch of Monday that begins:

======================================================================
===== drivers/scsi/qla2xxx/qla_os.c 1.46 vs edited =====
--- 1.46/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:07:52 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2004-09-13 14:07:23 -07:00
@@ -2892,6 +2892,19 @@
 			continue;
 		}
 
+		/* get consistent memory allocated for init control block */
+		ha->init_cb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
...
======================================================================

I am pretty sure that I also saw this problem earlier Monday morning,
before this patch.

Beginning with 2.6.9-rc1-mm5, I have had to comment out some of the QLA
config options in order to boot on an SN2.  That is, unless I make the
following edit to my .config:

========================================
--- 2.6.9-rc2-mmx/.config       2004-09-14 23:03:21.000000000 -0700
+++ 2.6.9-rc2-mmx/.config.disable_qla   2004-09-14 23:02:50.000000000 -0700
@@ -315,9 +315,9 @@ CONFIG_SCSI_SATA_VITESSE=y
 CONFIG_SCSI_QLOGIC_1280=y
 CONFIG_SCSI_QLA2XXX=y
 # CONFIG_SCSI_QLA21XX is not set
-CONFIG_SCSI_QLA22XX=y
-CONFIG_SCSI_QLA2300=y
-CONFIG_SCSI_QLA2322=y
+# CONFIG_SCSI_QLA22XX is not set
+# CONFIG_SCSI_QLA2300 is not set
+# CONFIG_SCSI_QLA2322 is not set
 # CONFIG_SCSI_QLA6312 is not set
 # CONFIG_SCSI_QLA6322 is not set
 # CONFIG_SCSI_DC395x is not set
========================================

my boot fails with the following output:

========================================
Uniform CD-ROM driver Revision: 3.20
qla1280: QLA12160 found on PCI bus 1, dev 3
ACPI: PCI interrupt 0000:01:03.0[A]: no GSI
scsi(0): Enabling SN2 PCI DMA dual channel lockup workaround
scsi(0): Enabling SN2 PCI DMA workaround
scsi(0:0): Resetting SCSI BUS
scsi(0:1): Resetting SCSI BUS
scsi0 : QLogic QLA12160 PCI to SCSI Host Adapter
       Firmware version: 10.04.32, Driver version 3.24.4
  Vendor: SGI       Model: ST336753LC        Rev: 2741
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(0:0:1:0): Sync: period 9, offset 14, Wide, DT, Tagged queuing: depth 255
  Vendor: SGI       Model: ST336753LC        Rev: 2741
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(0:0:2:0): Sync: period 9, offset 14, Wide, DT, Tagged queuing: depth 255
QLogic Fibre Channel HBA Driver (a0000001007ab1d0)
ACPI: PCI interrupt 0000:02:01.0[A]: no GSI
qla2200 0000:02:01.0: Found an ISP2200, irq 58, iobase 0xc00000080cc00000
qla2200 0000:02:01.0: Configuring PCI space...
PCI: slot 0000:02:01.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
POD entered via OS requested halt, using Cac mode
========================================

This is on a couple of small (4 and 8 cpu) SN2 systems, that boot with
earlier kernels just fine.

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
