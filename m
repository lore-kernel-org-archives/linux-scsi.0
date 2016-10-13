From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 00/16] Convert FibreChannel bsg code to use bsg-lib
Date: Thu, 13 Oct 2016 17:00:16 +0200
Message-ID: <cover.1476369687.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

This series converts the current bsg usage in the FibreChannel drivers over
to use bsg-lib. SAS will follow once FC is in a good enough shape.

I did take some inspiration from a similar patchset from Mike Christie
dating back to 2011 but it's not a 1:1 copy. Patch 15/16 is heavily based
on his series and attribution is given to him in the commit message.

It is currently regression tested on FCoE using the 'fcns' and
'fcrls' utilities.  I'm still trying to figure out how to test the other
LLDDs. So any pointer from the respective maintainers are appreciated
although the LLDD changes are purely mechanical. All they do is change from
'struct fc_bsg_job' to 'struct bsg_job' and corresponding changes in order
to get the series bisectable.

The idea for this change arose when discussing racy sysfs handling the FC
bsg code with Christoph and is a next step in moving all bsg clients to
bsg-lib to eventually clean up the in kernel bsg API.

Changes to v1:
* Reduce the number of individual patches (44 -> 16)
* Fix s390 build failure (forgotten to kill fc_bsg_job from zfcp_ext.h)
* Fix build failure on configs without CONFIG_BLK_DEV_BSGLIB
* Make bsg_job_get() call kref_get_unless_zero() and use it in scsi_transport_fc.c

Changes to v2:
* Add Hannes' Reviewd-by tags
* Address Hannes' comment about kref handling in 8/16
* Move CONFIG_BLK_DEV_BSGLIB dependency to patch 12/16 as per 0day results

Johannes Thumshirn (16):
  scsi: Get rid of struct fc_bsg_buffer
  scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  scsi: fc: Export fc_bsg_jobdone and use it in FC drivers
  scsi: Unify interfaces of fc_bsg_jobdone and bsg_job_done
  scsi: fc: provide fc_bsg_to_shost() helper
  scsi: fc: provide fc_bsg_to_rport() helper
  scsi: libfc: don't set FC_RQST_STATE_DONE before calling
    fc_bsg_jobdone()
  scsi: fc: implement kref backed reference counting
  block: add reference counting for struct bsg_job
  scsi: change FC drivers to use 'struct bsg_job'
  scsi: fc: Use bsg_destroy_job
  scsi: fc: use bsg_softirq_done
  scsi: fc: use bsg_job_done
  block: add bsg_job_put() and bsg_job_get()
  scsi: fc: move FC transport's bsg code to bsg-lib
  block: unexport bsg_softirq_done() again

 block/bsg-lib.c                  |  23 +-
 drivers/s390/scsi/zfcp_ext.h     |   4 +-
 drivers/s390/scsi/zfcp_fc.c      |  33 +--
 drivers/scsi/Kconfig             |   1 +
 drivers/scsi/bfa/bfad_bsg.c      |  62 +++---
 drivers/scsi/bfa/bfad_im.h       |   4 +-
 drivers/scsi/ibmvscsi/ibmvfc.c   |  40 ++--
 drivers/scsi/libfc/fc_lport.c    |  47 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 375 +++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_crtn.h    |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c   | 449 ++++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_def.h   |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h   |   4 +-
 drivers/scsi/qla2xxx/qla_iocb.c  |  13 +-
 drivers/scsi/qla2xxx/qla_isr.c   |  52 +++--
 drivers/scsi/qla2xxx/qla_mr.c    |  15 +-
 drivers/scsi/scsi_transport_fc.c | 409 ++++++-----------------------------
 include/linux/bsg-lib.h          |   4 +
 include/scsi/libfc.h             |   2 +-
 include/scsi/scsi_transport_fc.h |  62 ++----
 20 files changed, 748 insertions(+), 857 deletions(-)

-- 
1.8.5.6
