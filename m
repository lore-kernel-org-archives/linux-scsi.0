From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/8] Introduce sgl_alloc() and sgl_free()
Date: Thu, 12 Oct 2017 15:45:42 -0700
Message-ID: <20171012224550.25440-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hello Jens,

As you probably know there are multiple drivers that both allocate a
scatter/gather list and populate that list with pages. This patch series moves
the code for allocating and freeing such scatterlists from these drivers into
a new source file, namely lib/sgl_alloc. Please consider this patch series for
kernel v4.15.

Notes:
- Only the ib_srpt driver changes have been tested but none of the other
  drivers have been retested.
- The next step is to introduce a caching mechanism for these scatterlists
  and make the nvmet/rdma and SCSI target drivers use that caching mechanism
  since for these drivers sgl allocation occurs in the hot path.

Thanks,

Bart.

Bart Van Assche (8):
  lib: Introduce sgl_alloc() and sgl_free()
  crypto: scompress - use sgl_alloc() and sgl_free()
  nvmet/fc: Use sgl_alloc() and sgl_free()
  nvmet/rdma: Use sgl_alloc() and sgl_free()
  target: Use sgl_alloc_order() and sgl_free()
  scsi/ipr: Use sgl_alloc_order() and sgl_free_order()
  scsi/pmcraid: Remove an unused structure member
  scsi/pmcraid: Use sgl_alloc_order() and sgl_free_order()

 crypto/Kconfig                         |   1 +
 crypto/scompress.c                     |  52 +----------------
 drivers/nvme/target/Kconfig            |   2 +
 drivers/nvme/target/fc.c               |  37 +-----------
 drivers/nvme/target/rdma.c             |  64 ++-------------------
 drivers/scsi/Kconfig                   |   2 +
 drivers/scsi/ipr.c                     |  50 +++-------------
 drivers/scsi/ipr.h                     |   2 +-
 drivers/scsi/pmcraid.c                 |  44 ++------------
 drivers/scsi/pmcraid.h                 |   3 +-
 drivers/target/Kconfig                 |   1 +
 drivers/target/target_core_transport.c |  47 ++-------------
 include/linux/sgl_alloc.h              |  16 ++++++
 lib/Kconfig                            |   4 ++
 lib/Makefile                           |   1 +
 lib/sgl_alloc.c                        | 102 +++++++++++++++++++++++++++++++++
 16 files changed, 161 insertions(+), 267 deletions(-)
 create mode 100644 include/linux/sgl_alloc.h
 create mode 100644 lib/sgl_alloc.c

-- 
2.14.2
