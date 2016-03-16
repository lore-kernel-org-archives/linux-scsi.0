From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 00/22] ncr5380: Eliminate macros, reduce code duplication, fix bugs etc
Date: Wed, 16 Mar 2016 14:18:41 +1100
Message-ID: <20160316031841.911913894@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org


This patch series has more macro elimination and some tweaks to the
DMA hooks so that all the wrapper drivers can share the same core
DMA algorithm. This resolves the major discrepancies between the two
core drivers, which relate to code conditional on the REAL_DMA and
PSEUDO_DMA macros.

After all the wrapper drivers agree on the DMA hook api, the core driver
fork gets resolved. NCR5380.c is adopted by atari_scsi and sun3_scsi and
atari_NCR5380.c is then deleted.

Historically, the 5380 drivers suffered from over-use of conditional
compilation, which caused the compile-time configuration space to explode,
leading to core driver code that was practically untestable, unmaintainable
and difficult to reason about. It also prevented driver modules from
sharing object code.

Along with REAL_DMA, REAL_DMA_POLL and PSEUDO_DMA, most of the remaining
macros are also eradicated, such as CONFIG_SCSI_GENERIC_NCR53C400,
SUPPORT_TAGS, DONT_USE_INTR, AUTOPROBE_IRQ and BIOSPARAM.

Also in this patch series, some duplicated documentation is removed and
the PDMA implementation in mac_scsi finally gets fixed.

This patch series was tested by exercising the dmx3191d and mac_scsi modules
on suitable hardware. Help with driver testing on ISA and Atari hardware
is sought as I don't have any (likewise RiscPC ecards and Sun 3 hardware).

Changes since v1:
- Patch 4: don't remove MIN_DMA_SIZE macro from wrapper drivers.
- Patch 9: improve commit log entry and add 'Reviewed-by' tag.
- Patch 14: reduce shost->max_lun limit instead of adding MAX_LUN limit.
- Patches 20 and 22: set the default cmd_per_lun to 4.
- For the rest: add 'Reviewed-by' tag.

---
 Documentation/scsi/g_NCR5380.txt       |   17 
 Documentation/scsi/scsi-parameters.txt |   11 
 drivers/scsi/Kconfig                   |   11 
 drivers/scsi/NCR5380.c                 |  657 +++-----
 drivers/scsi/NCR5380.h                 |  143 -
 drivers/scsi/arm/cumana_1.c            |   25 
 drivers/scsi/arm/oak.c                 |   22 
 drivers/scsi/atari_NCR5380.c           | 2676 ---------------------------------
 drivers/scsi/atari_scsi.c              |  144 -
 drivers/scsi/dmx3191d.c                |   10 
 drivers/scsi/dtc.c                     |   27 
 drivers/scsi/dtc.h                     |    7 
 drivers/scsi/g_NCR5380.c               |  143 -
 drivers/scsi/g_NCR5380.h               |   26 
 drivers/scsi/mac_scsi.c                |  241 +-
 drivers/scsi/pas16.c                   |   27 
 drivers/scsi/pas16.h                   |    5 
 drivers/scsi/sun3_scsi.c               |   47 
 drivers/scsi/t128.c                    |   19 
 drivers/scsi/t128.h                    |    7 
 20 files changed, 634 insertions(+), 3631 deletions(-)
