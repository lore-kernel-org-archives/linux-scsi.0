From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 00/31] SCSI patches for kernel v4.13.
Date: Tue, 23 May 2017 17:33:49 -0700
Message-ID: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Hello Martin,

This patch series consists of the bug fixes I came up with during
the past two months. Please consider these patches for kernel v4.13.

Thanks,

Bart.

Bart Van Assche (31):
  Split scsi_internal_device_block()
  Create two versions of scsi_internal_device_unblock()
  Protect SCSI device state changes with a mutex
  Introduce scsi_start_queue()
  Make __scsi_remove_device go straight from BLOCKED to DEL
  scmd_eh_abort_handler(): Add a comment
  scsi: Use blk_mq_rq_to_pdu() to convert a request to a SCSI command
    pointer
  sd, sr: Convert two assignments into warning statements
  block: Avoid that blk_exit_rl() triggers a use-after-free
  Avoid that scsi_exit_rq() triggers a use-after-free
  block: Introduce queue flag QUEUE_FLAG_SCSI_SUP
  bsg: Check queue type before attaching to a queue
  pktcdvd: Check queue type before attaching to a queue
  cdrom: Check private request size before attaching to a queue
  nfsd: Check private request size before submitting a SCSI request
  scsi: Make scsi_ioctl_reset() pass the request queue pointer to
    blk_rq_init()
  block: Introduce request_queue.initialize_rq_fn()
  block: Make scsi_req_init() calls implicit
  scsi: Change argument type of scsi_req_init()
  scsi: Only add commands to the device command list if required by the
    LLD
  scsi: Move most of scsi_init_command() into scsi_initialize_rq()
  scsi: Inline scsi_init_command()
  scsi: Move sense buffer pointer initialization into
    scsi_initialize_rq()
  scsi: Make scsi_initialize_rq() zero the entire struct scsi_cmnd
  scsi-mq: Make behavior scsi_mq_prep_fn() closer to that of
    scsi_prep_fn()
  scsi: Move the code for clearing private command data into
    scsi_dispatch_cmd()
  scsi: Consolidate more initialization code
  scsi_setup_fs_cmnd(): Call scsi_req_init() instead of open-coding it
  scsi: snic: Remove code that zeroes driver-private command data
  scsi: virtio: Remove code that zeroes driver-private command data
  xen/scsifront: Remove code that zeroes driver-private command data

 block/blk-cgroup.c                   |   2 +-
 block/blk-core.c                     |  13 +-
 block/blk-mq.c                       |   3 +
 block/blk-sysfs.c                    |   2 +-
 block/blk.h                          |   2 +-
 block/bsg-lib.c                      |   1 +
 block/bsg.c                          |   7 +-
 block/scsi_ioctl.c                   |  13 +-
 drivers/block/cciss.c                |   1 +
 drivers/block/pktcdvd.c              |   6 +-
 drivers/cdrom/cdrom.c                |   5 +-
 drivers/ide/ide-atapi.c              |   2 -
 drivers/ide/ide-cd.c                 |   1 -
 drivers/ide/ide-cd_ioctl.c           |   1 -
 drivers/ide/ide-devsets.c            |   1 -
 drivers/ide/ide-disk.c               |   1 -
 drivers/ide/ide-ioctls.c             |   2 -
 drivers/ide/ide-park.c               |   2 -
 drivers/ide/ide-pm.c                 |   2 -
 drivers/ide/ide-probe.c              |   7 +-
 drivers/ide/ide-tape.c               |   1 -
 drivers/ide/ide-taskfile.c           |   1 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   8 +-
 drivers/scsi/osd/osd_initiator.c     |   2 -
 drivers/scsi/osst.c                  |   1 -
 drivers/scsi/scsi.c                  |   9 +-
 drivers/scsi/scsi_error.c            |  26 ++-
 drivers/scsi/scsi_lib.c              | 327 +++++++++++++++++++++--------------
 drivers/scsi/scsi_priv.h             |   4 +-
 drivers/scsi/scsi_scan.c             |  16 +-
 drivers/scsi/scsi_sysfs.c            |  37 +++-
 drivers/scsi/scsi_transport_sas.c    |   7 +
 drivers/scsi/scsi_transport_srp.c    |   7 +-
 drivers/scsi/sd.c                    |   9 +-
 drivers/scsi/sg.c                    |   2 -
 drivers/scsi/snic/snic_scsi.c        |   2 -
 drivers/scsi/sr.c                    |   2 +-
 drivers/scsi/st.c                    |   1 -
 drivers/scsi/virtio_scsi.c           |   1 -
 drivers/scsi/xen-scsifront.c         |   1 -
 drivers/target/target_core_pscsi.c   |   2 -
 fs/nfsd/blocklayout.c                |   4 +-
 include/linux/blkdev.h               |   6 +
 include/scsi/scsi_cmnd.h             |   1 +
 include/scsi/scsi_device.h           |   7 +-
 include/scsi/scsi_request.h          |   2 +-
 include/scsi/scsi_tcq.h              |   2 +-
 47 files changed, 345 insertions(+), 217 deletions(-)

-- 
2.12.2
