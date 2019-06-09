From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 0/7] NCR5380 drivers: fixes and other improvements
Date: Sun, 09 Jun 2019 11:19:11 +1000
Message-ID: <cover.1560043151.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Joshua Thompson <funaho@jurai.org>, linux-m68k@lists.linux-m68k.org
List-Id: linux-scsi@vger.kernel.org

Among other improvements, this patch series fixes a data corruption bug
in the mac_scsi driver and a bug in the EH abort routine in the core
5380 driver.

For consistency I have ignored certain checkpatch.pl complaints about
the indentation in mac_scsi.c. The remaining complaints seem to be
false positives.

Some of these patches are not trivial to backport. Those patches have
been nominated for recent -stable branches only.

Changed since v1:
 - Added acked-by tag.
 - Dropped new mac_pdma.h file.


Finn Thain (7):
  Revert "scsi: ncr5380: Increase register polling limit"
  scsi: NCR5380: Always re-enable reselection interrupt
  scsi: NCR5380: Handle PDMA failure reliably
  scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
  scsi: mac_scsi: Fix pseudo DMA implementation, take 2
  scsi: mac_scsi: Enable PDMA on Mac IIfx
  scsi: mac_scsi: Treat Last Byte Sent time-out as failure

 arch/m68k/mac/config.c  |  10 +-
 drivers/scsi/NCR5380.c  |  18 +-
 drivers/scsi/NCR5380.h  |   2 +-
 drivers/scsi/mac_scsi.c | 421 +++++++++++++++++++++++++---------------
 4 files changed, 273 insertions(+), 178 deletions(-)

-- 
2.21.0
