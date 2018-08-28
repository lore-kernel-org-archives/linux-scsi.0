From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: [PATCH 0/2] Fix allmodconfig build with bare-metal toolchain
Date: Tue, 28 Aug 2018 17:24:19 +0300
Message-ID: <20180828142421.15335-1-semen.protsenko@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Attempt to build allmodconfig (for ARM platforms) using bare-metal
toolchain fails with errors related to __linux__ definition. It's only
defined on Linux toolchains, but not defined on bare-metal toolchains.
This patch series fixes that.

Some similar patches (for different files) were applied previously:
  - commit 4c82456eeb4d ("fuse: fix type definitions in uapi header")
  - commit b6330548383c ("drm.h: Fix DRM compilation with bare-metal
toolchain.")

Sam Protsenko (2):
  codafs: Fix build using bare-metal toolchain
  scsi: aic7xxx: Fix build using bare-metal toolchain

 drivers/scsi/aic7xxx/aic7770.c                  |  2 +-
 drivers/scsi/aic7xxx/aic79xx.h                  |  4 ++--
 drivers/scsi/aic7xxx/aic79xx_core.c             | 12 ++++++------
 drivers/scsi/aic7xxx/aic79xx_pci.c              |  2 +-
 drivers/scsi/aic7xxx/aic7xxx.h                  |  4 ++--
 drivers/scsi/aic7xxx/aic7xxx_93cx6.c            |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c             | 12 ++++++------
 drivers/scsi/aic7xxx/aic7xxx_pci.c              |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.h            |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y       |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l       |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c     |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h     |  2 +-
 include/uapi/linux/coda.h                       |  5 +++++
 16 files changed, 32 insertions(+), 27 deletions(-)

-- 
2.18.0
