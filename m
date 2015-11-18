From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Wed, 18 Nov 2015 19:34:55 +1100
Message-ID: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Like my previous work on the NCR5380 drivers, this patch series has bug
fixes, code cleanup and modernization. These drivers suffer from mistakes,
poor style and neglect and this long series addresses the worst of it,
covering all ten wrapper drivers and both of the core driver forks. The
combined size of the drivers is reduced by about 750 LoC.

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

I have compile-tested all patches to all NCR5380 drivers (x86, ARM, m68k)
and regression tested mac_scsi and dmx3191d modules on suitable hardware.
Testing the mac_scsi and dmx3191d modules provides only limited coverage.
It would be good to see some testing of ISA cards and Sun 3 and Atari
hardware too (I don't have any).

---
 drivers/scsi/Kconfig         |   17 
 drivers/scsi/NCR5380.c       | 2871 +++++++++++++++++++------------------------
 drivers/scsi/NCR5380.h       |   72 -
 drivers/scsi/arm/cumana_1.c  |   30 
 drivers/scsi/arm/oak.c       |   26 
 drivers/scsi/atari_NCR5380.c | 2295 +++++++++++++++-------------------
 drivers/scsi/atari_scsi.c    |  102 -
 drivers/scsi/dmx3191d.c      |   32 
 drivers/scsi/dtc.c           |  114 -
 drivers/scsi/dtc.h           |   45 
 drivers/scsi/g_NCR5380.c     |  178 +-
 drivers/scsi/g_NCR5380.h     |   56 
 drivers/scsi/mac_scsi.c      |  116 -
 drivers/scsi/pas16.c         |  115 -
 drivers/scsi/pas16.h         |   40 
 drivers/scsi/sun3_scsi.c     |  141 --
 drivers/scsi/t128.c          |  101 -
 drivers/scsi/t128.h          |   39 
 18 files changed, 2815 insertions(+), 3575 deletions(-)
