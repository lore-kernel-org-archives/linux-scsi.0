From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 00/44] Convert FibreChannel bsg code to use bsg-lib
Date: Tue, 11 Oct 2016 13:28:31 +0200
Message-ID: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39061 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752891AbcJKL3Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 07:29:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

This series converts the current bsg usage in the FibreChannel drivers over
to use bsg-lib. SAS will follow but 44 patches are big enough for one shot,
so I didn't want to include SAS in there as well.

It looks a bit huge but most of the patches are only code movement and slow
API conversions so everything still works and builds when doing git bisects.

I did take some inspiration from a similar patchset from Mike Christie
dating back to 2011 but it's not a 1:1 copy. Patch 43/44 is heavily based
on his series and attribution is given to him in the commit message.

It is currently regression tested on FCoE using the 'fcns' and
'fcrls'utilities.  I'm still trying to figure out how to test the other
LLDDs. So any pointer from the respective maintainers are appreciated
although the LLDD changes are purely mechanical. All they do is change from
'struct fc_bsg_job' to 'struct bsg_job' and corresponding changes in order
to get the series bisectable.

The idea for this change arose when discussing racy sysfs handling the FC
bsg code with Christoph and is a next step in moving all bsg clients to
bsg-lib to eventually clean up the in kernel bsg API.

Johannes Thumshirn (44):
  scsi: Get rid of struct fc_bsg_buffer
  bfa: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  zfcp: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  ibmvfc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  lpfc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  qla2xxx: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  libfc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  scsi: fc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
  scsi: fc: Export fc_bsg_jobdone
  zfcp: Use fc_bsg_jobdone()
  bfa: Use fc_bsg_jobdone()
  ibmvfc: Use fc_bsg_jobdone()
  libfc: Use fc_bsg_jobdone()
  lpfc: Use fc_bsg_jobdone()
  qla2xxx: Use fc_bsg_jobdone()
  scsi: fc: remove job_done method from struct fc_bsg_job
  scsi: Unify interfaces of fc_bsg_jobdone and bsg_job_done
  scsi: fc: provide fc_bsg_to_shost() helper
  scsi: fc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
  bfa: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
  lpfc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
  qla2xxx: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
  libfc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
  ibmvfc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
  zfcp: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
  scsi: fc: provide fc_bsg_to_rport() helper
  scsi: fc: use fc_bsg_to_rport() to access a bsg_job's rport
  zfcp: use fc_bsg_to_rport() to access a bsg_job's rport
  qla2xxx: use fc_bsg_to_rport() to access a bsg_job's rport
  lpfc: use fc_bsg_to_rport() to access a bsg_job's rport
  libfc: use fc_bsg_to_rport() to access a bsg_job's rport
  ibmvfc: use fc_bsg_to_rport() to access a bsg_job's rport
  scsi: libfc: don't set FC_RQST_STATE_DONE before calling
    fc_bsg_jobdone()
  scsi: fc: implement kref backed reference counting
  block: add reference counting for struct bsg_job
  scsi: change FC drivers to use 'struct bsg_job'
  block: export bsg_destroy_job
  scsi: fc: Use bsg_destroy_job
  block: export bsg_softirq_done
  scsi: fc: use bsg_softirq_done
  scsi: fc: use bsg_job_done
  block: add bsg_job_put() and bsg_job_get()
  scsi: fc: move FC transport's bsg code to bsg-lib
  block: unexport bsg_softirq_done() again

 block/bsg-lib.c                  |  19 +-
 drivers/s390/scsi/zfcp_fc.c      |  33 +--
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
 18 files changed, 742 insertions(+), 854 deletions(-)

-- 
1.8.5.6

