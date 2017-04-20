From: jsmart2021@gmail.com
Subject: [PATCH-v1 00/22] lpfc updates for 11.2.0.12
Date: Wed, 19 Apr 2017 21:46:19 -0700
Message-ID: <20170420044641.10657-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34719 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938019AbdDTEqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 00:46:54 -0400
Received: by mail-oi0-f65.google.com with SMTP id y11so3466430oie.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 21:46:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>

From: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes, code cleanups, and error
handling, mostly in the nvme area of lpfc.

There is one new feature in the series to add Fabric Assigned WWN support.

The patches were cut against the linux-block tree, for-4.12/block branch,
and are intended to be pulled in through that tree rather than the scsi trees.

The patches are dependent on the FC nvme/nvmet patches from the following 2
series:
http://lists.infradead.org/pipermail/linux-nvme/2017-April/009250.html
http://lists.infradead.org/pipermail/linux-nvme/2017-April/009256.html

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
 drivers/scsi/lpfc/lpfc_debugfs.c   |  69 ++++---
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       |  68 +++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 131 +++++++++----
 drivers/scsi/lpfc/lpfc_hw.h        |   3 +
 drivers/scsi/lpfc/lpfc_hw4.h       |   4 +
 drivers/scsi/lpfc/lpfc_init.c      | 202 +++++++++++++-------
 drivers/scsi/lpfc/lpfc_mbox.c      |   7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   8 +-
 drivers/scsi/lpfc/lpfc_nvme.c      | 139 ++++++++++----
 drivers/scsi/lpfc/lpfc_nvme.h      |   7 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     | 378 ++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_nvmet.h     |  14 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  22 ++-
 drivers/scsi/lpfc/lpfc_sli4.h      |   2 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   3 +-
 22 files changed, 814 insertions(+), 342 deletions(-)

-- 
2.1.0
