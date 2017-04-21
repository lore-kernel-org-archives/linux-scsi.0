From: jsmart2021@gmail.com
Subject: [PATCH v3 00/22] lpfc updates for 11.2.0.12
Date: Fri, 21 Apr 2017 16:04:44 -0700
Message-ID: <20170421230506.925-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35809 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423351AbdDUXFL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 19:05:11 -0400
Received: by mail-oi0-f68.google.com with SMTP id m34so14688913oik.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 16:05:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>

From: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes, code cleanups, and error
handling, mostly in the nvme area of lpfc.

There is one new feature in the series to add Fabric Assigned WWN support.

The patches were cut against the linux-block tree, for-4.12/block branch,
after Jens has pulled in the "nmve updates for 4.12" from today.
The updates included all dependencies for lpfc. The patches apply
cleanly to both the block branch and the nvme-4.12 tree/branch.
They should be good to go through Jen's tree.

James Smart (22):
  Standardize nvme SGL segment count
  Fix nvme unregister port timeout.
  Fix rejected nvme LS Req.
  Fix log message in completion path.
  Add debug messages for nvme/fcp resource allocation.
  Fix spelling in comments.
  Remove unused defines for NVME PostBuf.
  Remove NULL ptr check before kfree.
  Fix extra line print in rqpair debug print.
  Fix PRLI ACC rsp for NVME
  Fix driver unload/reload operation.
  Fix driver usage of 128B WQEs when WQ_CREATE is V1.
  Fix nvme initiator handling when not enabled.
  Remove hba lock from NVMET issue WQE.
  Fix driver load issues when MRQ=8
  Fix crash after issuing lip reset
  Fix max_sgl_segments settings for NVME / NVMET
  Add Fabric assigned WWN support.
  Fix implicit logo and RSCN handling for NVMET
  Update ABORT processing for NVMET.
  Fix Express lane queue creation.
  lpfc revison 11.2.0.12

 drivers/scsi/lpfc/lpfc.h           |   5 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  10 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   4 +
 drivers/scsi/lpfc/lpfc_crtn.h      |   9 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  68 +++++--
 drivers/scsi/lpfc/lpfc_debugfs.c   |  67 ++++---
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       |  68 +++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 133 +++++++++----
 drivers/scsi/lpfc/lpfc_hw.h        |   3 +
 drivers/scsi/lpfc/lpfc_hw4.h       |   4 +
 drivers/scsi/lpfc/lpfc_init.c      | 202 +++++++++++++-------
 drivers/scsi/lpfc/lpfc_mbox.c      |   7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   8 +-
 drivers/scsi/lpfc/lpfc_nvme.c      | 140 ++++++++++----
 drivers/scsi/lpfc/lpfc_nvme.h      |   7 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     | 377 ++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_nvmet.h     |  14 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  22 ++-
 drivers/scsi/lpfc/lpfc_sli4.h      |   2 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   3 +-
 22 files changed, 813 insertions(+), 343 deletions(-)

-- 
2.9.3
