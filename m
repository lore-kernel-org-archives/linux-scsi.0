From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/21] lpfc updates for 11.4.0.4
Date: Fri, 29 Sep 2017 17:34:26 -0700
Message-ID: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:44242 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752571AbdI3Ae4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:34:56 -0400
Received: by mail-qt0-f196.google.com with SMTP id o13so1637784qtf.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 17:34:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes and additions to
the driver.

The patches were cut against the Martin's 4.14/scsi-queue tree.
There are no outside dependencies.

v2:
  Split patch 1 into separate patches
  Added stable cc's where requested
  "Fix oops of nvme host during driver unload" revised to only
    block submit routines due to bug. abort routines must
    function to cleanup.
  Add "correct nvme sg segment count check" patch

Dick Kennedy (18):
  lpfc: fix pci hot plug crash in timer management routines
  lpfc: fix pci hot plug crash in list_add call
  lpfc: Fix crash receiving ELS while detaching driver
  lpfc: Fix lpfc nvme host rejecting IO with Not Ready message
  lpfc: Fix warning messages when NVME_TARGET_FC not defined
  lpfc: PLOGI failures during NPIV testing
  lpfc: Make ktime sampling more accurate
  lpfc: Move CQ processing to a soft IRQ
  lpfc: Fix FCP hba_wqidx assignment
  lpfc: Revise NVME module parameter descriptions for better clarity
  lpfc: Fix oops if nvmet_fc_register_targetport fails
  lpfc: Disable NPIV support if NVME is enabled
  lpfc: Fix crash in lpfc_nvme_fcp_io_submit during LIP
  lpfc: Fix secure firmware updates
  lpfc: Ensure io aborts interlocked with the target.
  lpfc: Extend RDP support
  lpfc: Fix oops of nvme host during driver unload.
  lpfc: change version to 11.4.0.4

James Smart (3):
  lpfc: Reduce log spew on controller reconnects
  lpfc: Set missing abort context
  lpfc: correct nvme sg segment count check

 drivers/scsi/lpfc/lpfc.h           |   3 +
 drivers/scsi/lpfc/lpfc_attr.c      |  10 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   4 +-
 drivers/scsi/lpfc/lpfc_els.c       |  19 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   8 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |   2 +-
 drivers/scsi/lpfc/lpfc_init.c      |  30 ++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c      | 167 ++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_nvmet.c     | 148 +++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli.c       | 216 +++++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_sli4.h      |   4 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   9 ++
 14 files changed, 405 insertions(+), 219 deletions(-)

-- 
2.13.1
