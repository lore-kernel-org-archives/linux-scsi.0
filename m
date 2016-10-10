From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 00/12] Fixes, cleanup and g_NCR5380_mmio/g_NCR5380 merger
Date: Mon, 10 Oct 2016 00:46:52 -0400 (EDT)
Message-ID: <cover.1476051961.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch series has fixes for compatibility, reliability and
performance issues and some cleanup. It also includes a new version
of Ondrej Zary's patch that merges g_NCR5380_mmio into g_NCR5380.

I've tested this patch series using mac_scsi on a Powerbook 180.
Ondrej tested the g_NCR5380 driver and Michael tested atari_scsi.
The other drivers have been compile-tested.

Changes since v1:
- rebased on 4.9/scsi-queue
- added reviewed-by tags
- tweaked the order of struct members in patch 7/12

Changes since v2:
- added tested-by tags
- fixed typo in log message for patch 3/12


Finn Thain (12):
  scsi/g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio drivers
  scsi/cumana_1: Remove unused cumanascsi_setup() function
  scsi/atari_scsi: Make device register accessors re-entrant
  scsi/ncr5380: Simplify register polling limit
  scsi/ncr5380: Increase register polling limit
  scsi/ncr5380: Improve hostdata struct member alignment and
    cache-ability
  scsi/ncr5380: Store IO ports and addresses in host private data
  scsi/ncr5380: Use correct types for device register accessors
  scsi/ncr5380: Pass hostdata pointer to register polling routines
  scsi/ncr5380: Expedite register polling
  scsi/ncr5380: Use correct types for DMA routines
  scsi/ncr5380: Suppress unhelpful "interrupt without IRQ bit" message

 MAINTAINERS                   |   1 -
 drivers/scsi/Kconfig          |  32 +----
 drivers/scsi/Makefile         |   1 -
 drivers/scsi/NCR5380.c        | 137 +++++++++++---------
 drivers/scsi/NCR5380.h        |  87 +++++++++----
 drivers/scsi/arm/cumana_1.c   |  98 +++++++-------
 drivers/scsi/arm/oak.c        |  34 +++--
 drivers/scsi/atari_scsi.c     |  77 ++++++-----
 drivers/scsi/dmx3191d.c       |  20 +--
 drivers/scsi/g_NCR5380.c      | 290 ++++++++++++++++++++----------------------
 drivers/scsi/g_NCR5380.h      |  32 +----
 drivers/scsi/g_NCR5380_mmio.c |  10 --
 drivers/scsi/mac_scsi.c       |  83 +++++-------
 drivers/scsi/sun3_scsi.c      |  80 ++++++------
 14 files changed, 495 insertions(+), 487 deletions(-)
 delete mode 100644 drivers/scsi/g_NCR5380_mmio.c

-- 
2.7.3
