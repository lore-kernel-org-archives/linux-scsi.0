From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.15+ merge window
Date: Fri, 13 Jun 2014 16:57:56 -0700
Message-ID: <1402703876.2224.112.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is just a couple of drivers (hpsa and lpfc) that got left out for
further testing in linux-next.  We also have one fix to a prior
submission (qla2xxx sparse).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

James Smart (16):
      lpfc: Update lpfc version to driver version 10.2.8001.0
      lpfc: Fix ExpressLane priority setup
      lpfc: mark old devices as obsolete
      lpfc: Fix for initializing RRQ bitmap
      lpfc: Fix for cleaning up stale ring flag and sp_queue_event entries
      lpfc: Update lpfc version to driver version 10.2.8000.0
      lpfc: Update Copyright on changed files from 8.3.45 patches
      lpfc: Update Copyright on changed files
      lpfc: Fixed locking for scsi task management commands
      lpfc: Convert runtime references to old xlane cfg param to fof cfg param
      lpfc: Fix FW dump using sysfs
      lpfc: Fix SLI4 s abort loop to process all FCP rings and under ring_lock
      lpfc: Fixed kernel panic in lpfc_abort_handler
      lpfc: Fix locking for postbufq when freeing
      lpfc: Fix locking for lpfc_hba_down_post
      lpfc: Fix dynamic transitions of FirstBurst from on to off

Justin Lindley (1):
      hpsa: change doorbell reset delay to ten seconds

Quinn Tran (1):
      qla2xxx: fix sparse warnings introduced by previous target mode t10-dif patch

Stephen M. Cameron (18):
      hpsa: fix handling of hpsa_volume_offline return value
      hpsa: return -ENOMEM not -1 on kzalloc failure in hpsa_get_device_id
      hpsa: remove messages about volume status VPD inquiry page not supported
      hpsa: report check condition even if no sense data present for ioaccel2 mode
      hpsa: remove bad unlikely annotation from device list updating code
      hpsa: fix event filtering to prevent excessive rescans with old firmware
      hpsa: kill annoying messages about SSD Smart Path retries
      hpsa: define extended_report_lun_entry data structure
      hpsa: Rearrange start_io to avoid one unlock/lock sequence in main io path
      hpsa: avoid unnecessary readl on every command submission
      hpsa: use per-cpu variable for lockup_detected
      hpsa: set irq affinity hints to route MSI-X vectors across CPUs
      hpsa: allocate reply queues individually
      hpsa: choose number of reply queues more intelligently.
      hpsa: remove dev_dbg() calls from hot paths
      hpsa: use gcc aligned attribute instead of manually padding structs
      hpsa: allow passthru ioctls to work with bidirectional commands
      hpsa: remove unused fields from struct ctlr_info

And the diffstat

 drivers/scsi/hpsa.c               | 266 ++++++++++++++++++++--------------
 drivers/scsi/hpsa.h               |  42 +++---
 drivers/scsi/hpsa_cmd.h           |  49 +++----
 drivers/scsi/lpfc/lpfc.h          |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c     |  23 +--
 drivers/scsi/lpfc/lpfc_bsg.c      |   2 +-
 drivers/scsi/lpfc/lpfc_bsg.h      |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h     |   6 +-
 drivers/scsi/lpfc/lpfc_debugfs.c  |   4 +-
 drivers/scsi/lpfc/lpfc_els.c      |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c  |   5 +-
 drivers/scsi/lpfc/lpfc_hw.h       |   2 +-
 drivers/scsi/lpfc/lpfc_hw4.h      |   2 +-
 drivers/scsi/lpfc/lpfc_init.c     | 258 +++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_mem.c      |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c     |  60 ++++++--
 drivers/scsi/lpfc/lpfc_scsi.h     |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c      | 297 +++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_sli.h      |   2 +-
 drivers/scsi/lpfc/lpfc_sli4.h     |   2 +-
 drivers/scsi/lpfc/lpfc_version.h  |   6 +-
 drivers/scsi/qla2xxx/qla_def.h    |  16 +-
 drivers/scsi/qla2xxx/qla_target.c |  15 +-
 drivers/scsi/qla2xxx/qla_target.h |  16 +-
 24 files changed, 715 insertions(+), 369 deletions(-)

James
