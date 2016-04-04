From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v3 0/5] mempool based chained scatterlist alloc/free api
Date: Mon, 04 Apr 2016 14:48:06 -0700
Message-ID: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Ming Lin <ming.l@ssi.samsung.com>

The fist 4 patches make the SG related definitions/structs/functions
in SCSI code generic and the last patch move it to lib/sg_pool.c.

v3:
  - Resend for Tejun to review. No code change since v2.
  - Add review/ack tags

v2:
  - do modification in scsi code first then move to lib/sg_pool.c
  - address Christoph's comments


Ming Lin (5):
  scsi: replace "scsi_data_buffer" with "sg_table" in SG functions
  scsi: replace "mq" with "first_chunk" in SG functions
  scsi: rename SG related struct and functions
  scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS
  lib: scatterlist: move SG pool code from SCSI driver to lib/sg_pool.c

 drivers/ata/pata_icside.c           |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c |   4 +-
 drivers/scsi/Kconfig                |   1 +
 drivers/scsi/arm/cumana_2.c         |   2 +-
 drivers/scsi/arm/eesox.c            |   2 +-
 drivers/scsi/arm/powertec.c         |   2 +-
 drivers/scsi/esas2r/esas2r_main.c   |   4 +-
 drivers/scsi/hisi_sas/hisi_sas.h    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h |   2 +-
 drivers/scsi/scsi_debug.c           |   2 +-
 drivers/scsi/scsi_lib.c             | 172 +++++-------------------------------
 drivers/usb/storage/scsiglue.c      |   2 +-
 include/linux/scatterlist.h         |  25 ++++++
 include/scsi/scsi.h                 |  19 ----
 include/scsi/scsi_host.h            |   2 +-
 lib/Kconfig                         |   7 ++
 lib/Makefile                        |   1 +
 lib/sg_pool.c                       | 172 ++++++++++++++++++++++++++++++++++++
 19 files changed, 241 insertions(+), 186 deletions(-)
 create mode 100644 lib/sg_pool.c

-- 
1.9.1
