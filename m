From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH RESEND v4 00/15] Convert FibreChannel bsg code to use bsg-lib
Date: Thu, 17 Nov 2016 16:09:23 +0100
Message-ID: <cover.1479374719.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

This series converts the current bsg usage in the FibreChannel drivers over
to use bsg-lib. SAS will follow once FC is in a good enough shape.

I did take some inspiration from a similar patchset from Mike Christie
dating back to 2011 but it's not a 1:1 copy. Patch 15/16 is heavily based
on his series and attribution is given to him in the commit message.

It is currently regression tested on FCoE and lpfc using the 'fcns',
'fcrls' and 'fcping' (see my FC_BSG_RPT_ELS patch for fcping) utilities and
zfcp_show/zfcp_ping on s390x.

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

Changes to v3:
* Rebase on mkp/4.10/scsi-queue (and fixup the new lpfc bsg function)
* Move checks for request and reply len before accessing them (hopefully fixes zfcp)
* Added Tyrel's Acked-bys
* Added Christoph's Reviewed-bys
* Squashed bsg_job_done patches as requested by Christoph
* Fixed the hopefully last bisection breaking point
* Fixed kernel panic on s390 with patch 2/15
* Fixed kernel panic on s390 with patch 5/15
* Fixed zfcp_show output on s390 with patch 4/15


Johannes Thumshirn (15):
  scsi: Get rid of struct fc_bsg_buffer
  scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  scsi: fc: Export fc_bsg_jobdone and use it in FC drivers
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
 drivers/s390/scsi/zfcp_fc.c      |  36 ++--
 drivers/scsi/Kconfig             |   1 +
 drivers/scsi/bfa/bfad_bsg.c      |  62 +++---
 drivers/scsi/bfa/bfad_im.h       |   4 +-
 drivers/scsi/ibmvscsi/ibmvfc.c   |  40 ++--
 drivers/scsi/libfc/fc_lport.c    |  47 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 387 +++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_crtn.h    |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c   | 449 ++++++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_def.h   |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h   |   4 +-
 drivers/scsi/qla2xxx/qla_iocb.c  |  13 +-
 drivers/scsi/qla2xxx/qla_isr.c   |  52 +++--
 drivers/scsi/qla2xxx/qla_mr.c    |  15 +-
 drivers/scsi/scsi_transport_fc.c | 433 +++++++------------------------------
 include/linux/bsg-lib.h          |   4 +
 include/scsi/libfc.h             |   2 +-
 include/scsi/scsi_transport_fc.h |  62 ++----
 20 files changed, 770 insertions(+), 874 deletions(-)

-- 
1.8.5.6
