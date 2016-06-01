From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/14] target: Allow backends to operate independent of se_cmd
Date: Wed,  1 Jun 2016 21:48:33 +0000
Message-ID: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Jens, HCH & Co,

This series introduces target_iostate and target_iomem descriptors
that abstract what existing target backend drivers require in order
to process I/O, sync_cache, write_same and unmap via sbc_ops.

The purpose is to allow existing target backend drivers from within
/sys/kernel/config/target/core/ to be accessed externally outside
of the existing /sys/kernel/config/target/$FABRIC/ configfs layout,
to operate independently of se_cmd and SCSI specific dependencies.

Namely, it's intended for the upcoming nvme-target code to utilize
existing target-core backend drivers and T10-PI logic, without
requiring consumers to be under /sys/kernel/config/target/$FABRIC/
configfs layout.

Also included is a prerequisite bug-fix for target-core, and IBLOCK
optimization for eliminating the internal memory allocation.

Beyond that, it's predominantly mechanical changes.

Please review,

--nab

Nicholas Bellinger (14):
  target: Fix for hang of Ordered task in TCM
  target: Add target_iomem descriptor
  target: Add target_iostate descriptor
  target: Add target_complete_ios wrapper
  target: Setup target_iostate memory in __target_execute_cmd
  target: Convert se_cmd->execute_cmd to target_iostate
  target/sbc: Convert sbc_ops->execute_rw to target_iostate
  target/sbc: Convert sbc_dif_copy_prot to target_iostate
  target/file: Convert sbc_dif_verify to target_iostate
  target/iblock: Fold iblock_req into target_iostate
  target/sbc: Convert sbc_ops->execute_sync_cache to target_iostate
  target/sbc: Convert sbc_ops->execute_write_same to target_iostate
  target/sbc: Convert sbc_ops->execute_unmap to target_iostate
  target: Make sbc_ops accessable via target_backend_ops

 drivers/infiniband/ulp/isert/ib_isert.c           |  61 ++---
 drivers/infiniband/ulp/srpt/ib_srpt.c             |   6 +-
 drivers/scsi/qla2xxx/qla_target.c                 |  64 ++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |  29 +--
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c          |   8 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c       |  20 +-
 drivers/target/iscsi/iscsi_target.c               |  26 +-
 drivers/target/iscsi/iscsi_target_datain_values.c |  18 +-
 drivers/target/iscsi/iscsi_target_erl0.c          |  24 +-
 drivers/target/iscsi/iscsi_target_erl1.c          |   8 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  40 ++--
 drivers/target/iscsi/iscsi_target_tmr.c           |   4 +-
 drivers/target/iscsi/iscsi_target_util.c          |   4 +-
 drivers/target/loopback/tcm_loop.c                |   2 +-
 drivers/target/sbp/sbp_target.c                   |   8 +-
 drivers/target/target_core_alua.c                 |  43 ++--
 drivers/target/target_core_alua.h                 |   6 +-
 drivers/target/target_core_device.c               |  24 +-
 drivers/target/target_core_file.c                 | 142 +++++------
 drivers/target/target_core_iblock.c               | 166 ++++++-------
 drivers/target/target_core_iblock.h               |   5 -
 drivers/target/target_core_internal.h             |   1 +
 drivers/target/target_core_pr.c                   |  68 +++---
 drivers/target/target_core_pr.h                   |   8 +-
 drivers/target/target_core_pscsi.c                |  26 +-
 drivers/target/target_core_rd.c                   |  44 ++--
 drivers/target/target_core_sbc.c                  | 278 ++++++++++++----------
 drivers/target/target_core_spc.c                  |  47 ++--
 drivers/target/target_core_transport.c            | 272 ++++++++++++---------
 drivers/target/target_core_user.c                 |  41 ++--
 drivers/target/target_core_xcopy.c                |  33 +--
 drivers/target/target_core_xcopy.h                |   4 +-
 drivers/target/tcm_fc/tfc_cmd.c                   |  14 +-
 drivers/target/tcm_fc/tfc_io.c                    |  21 +-
 drivers/usb/gadget/function/f_tcm.c               |  50 ++--
 drivers/vhost/scsi.c                              |   2 +-
 include/target/target_core_backend.h              |  30 ++-
 include/target/target_core_base.h                 |  72 ++++--
 include/target/target_core_fabric.h               |   3 +-
 include/trace/events/target.h                     |   4 +-
 40 files changed, 931 insertions(+), 795 deletions(-)

-- 
1.9.1
