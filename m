From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 00/78] More fixes, cleanup and modernization for NCR5380 drivers
Date: Sun, 03 Jan 2016 16:05:01 +1100
Message-ID: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Like my previous work on the NCR5380 drivers, this patch series has bug
fixes, code cleanup and modernization. These drivers suffer from mistakes,
poor style and neglect and this long series addresses the worst of it,
covering all ten wrapper drivers and both of the core driver forks. The
combined size of the drivers is reduced by over 700 LoC.

This series continues to reduce divergence between the two core driver
forks, often by copying a bug fix from one to the other. Most patches are
larger for having to keep the two forks in sync. Making the same change to
both is churn if one of them is to be removed but neither can be as yet.
By the end of this series the diff between the two forks is minimal, so it
becomes clear what caused the fork and what can be done about it.

This patch series did benefit from scripts/checkpatch.pl but not too much.
Decades ago, these drivers started out with 4-space tabs and if the 80
column limit were to be strictly enforced now, it would require adding new
functions and shortening identifiers. I would defer this sort of activity
until after the fork has been resolved.

All patches to all NCR5380 drivers (x86, ARM, m68k) have been compile-
tested. The mac_scsi, dmx3191d, g_NCR5380 and atari_scsi modules were
regression tested on suitable hardware.

Changes since v1:
- Patch 8 omits a pointless assignment.
- Patch 10 gets a better error message.
- Patch 20 drops the WQ_CPU_INTENSIVE flag.
- Patch 21 adds timing calibration for the register polling loop.
- Patch 49 is replaced by a new one that removes FLAG_DTC3181E.
- Patch 72 by Ondrej Zary was added to fix pseudo DMA on 53C400.

Changes since v2:
- Patch 21 has better calibration with low HZ values.
- Patch 57 no longer attempts to dereference a NULL pointer on Atari.
- Patch 66 initializes max_sectors in the host templates.
- Patches 73 thru 77 by Ondrej Zary were added with additional fixes for
  53C400-compatible cards.

Changes since v3:
- Patch 67 removes another redundant comment.
- Patch 68 was split into two patches as requested.
- Latest Tested-By and Reviewed-By tags were added.

---
 drivers/scsi/Kconfig         |   17 
 drivers/scsi/NCR5380.c       | 2876 +++++++++++++++++++------------------------
 drivers/scsi/NCR5380.h       |   87 -
 drivers/scsi/arm/cumana_1.c  |   31 
 drivers/scsi/arm/oak.c       |   27 
 drivers/scsi/atari_NCR5380.c | 2280 +++++++++++++++-------------------
 drivers/scsi/atari_scsi.c    |  102 -
 drivers/scsi/dmx3191d.c      |   33 
 drivers/scsi/dtc.c           |  115 -
 drivers/scsi/dtc.h           |   45 
 drivers/scsi/g_NCR5380.c     |  408 +++---
 drivers/scsi/g_NCR5380.h     |   66 
 drivers/scsi/mac_scsi.c      |  117 -
 drivers/scsi/pas16.c         |  116 -
 drivers/scsi/pas16.h         |   40 
 drivers/scsi/sun3_scsi.c     |  141 --
 drivers/scsi/t128.c          |  102 -
 drivers/scsi/t128.h          |   39 
 18 files changed, 2947 insertions(+), 3695 deletions(-)
