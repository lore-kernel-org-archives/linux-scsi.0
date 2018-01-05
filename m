From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v4 0/5] Introduce sgl_alloc() and sgl_free()
Date: Fri,  5 Jan 2018 08:26:45 -0800
Message-ID: <20180105162650.31083-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-nvme@lists.infradead.org, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hello Jens,

As you know there are multiple drivers that both allocate a scatter/gather
list and populate that list with pages. This patch series moves the code for
allocating and freeing such scatterlists from several drivers into
lib/scatterlist.c. Please consider this patch series for kernel v4.16.

Changes between v3 and v4:
- Left out patches 6..8 as requested by Martin Petersen. These patches will be
  sent to Martin after this series has been merged.

Changes between v2 and v3:
- Added Reviewed-by tags that had been posted as replies on v2.
- Cc'ed the crypto maintainers for the entire patch series.

Changes between v1 and v2:
- Moved the sgl_alloc*() and sgl_free() functions from a new source file into
  lib/scatterlist.c.
- Changed the argument order for the sgl_alloc*() functions such that the
  (pointer to) the output argument comes last.

Bart Van Assche (5):
  lib/scatterlist: Introduce sgl_alloc() and sgl_free()
  crypto: scompress - use sgl_alloc() and sgl_free()
  nvmet/fc: Use sgl_alloc() and sgl_free()
  nvmet/rdma: Use sgl_alloc() and sgl_free()
  target: Use sgl_alloc_order() and sgl_free()

 crypto/Kconfig                         |   1 +
 crypto/scompress.c                     |  51 +---------------
 drivers/nvme/target/Kconfig            |   2 +
 drivers/nvme/target/fc.c               |  36 +----------
 drivers/nvme/target/rdma.c             |  63 ++------------------
 drivers/target/Kconfig                 |   1 +
 drivers/target/target_core_transport.c |  46 ++-------------
 include/linux/scatterlist.h            |  10 ++++
 lib/Kconfig                            |   4 ++
 lib/scatterlist.c                      | 105 +++++++++++++++++++++++++++++++++
 10 files changed, 135 insertions(+), 184 deletions(-)

-- 
2.15.1
