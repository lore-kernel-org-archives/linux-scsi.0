From: jsmart2021@gmail.com
Subject: [PATCH 00/20] lpfc: Update lpfc to revision 11.2.0.10
Date: Sat,  4 Mar 2017 09:30:20 -0800
Message-ID: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35269 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbdCDRa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:30:59 -0500
Received: by mail-qk0-f196.google.com with SMTP id n127so34672153qkf.2
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:30:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>

From: James Smart <jsmart2021@gmail.com>

This set of patches are mainly cleanups and fixes to the large
nvme post that was recently integrated. It includes a patch to
break the mandate for both NVME and SCSI subystems.

James Smart (20):
  scsi: lpfc: remove redundant assignment of sgel
  scsi: lpfc: sanity check hrq is null before dereferencing it
  scsi: lpfc: don't dereference dma_buf->iocbq before null check
  scsi: lpfc: fix missing spin_unlock on sql_list_lock
  lpfc: Fix crash during Hardware error recovery on SLI3 adapters
  lpfc: Fix RCTL value on NVME LS request and response
  lpfc: Fix NVME CMD IU byte swapped word 1 problem
  lpfc: Fix IO submission if WQ is full
  lpfc: Fix nvme allocation bug on failed nvme_fc_register_localport
  lpfc: add NVME exchange aborts
  lpfc: Fix eh_deadline setting for sli3 adapters.
  lpfc: add transport eh_timed_out reference
  lpfc: Rework lpfc Kconfig for NVME options
  lpfc: Rename LPFC_MAX_EQ_DELAY to LPFC_MAX_EQ_DELAY_EQID_CNT
  lpfc: correct double print
  lpfc: remove dead sli3 nvme code
  lpfc: correct rdp diag portnames
  lpfc: code cleanups in NVME initiator base
  lpfc: code cleanups in NVME initiator discovery
  lpfc: revise version number to 11.2.0.10

 drivers/scsi/Kconfig             |  19 +++++--
 drivers/scsi/lpfc/lpfc.h         |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c    |   9 +++-
 drivers/scsi/lpfc/lpfc_crtn.h    |   4 +-
 drivers/scsi/lpfc/lpfc_ct.c      |   2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  22 --------
 drivers/scsi/lpfc/lpfc_els.c     |  22 +++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  19 ++++---
 drivers/scsi/lpfc/lpfc_hw4.h     |   4 +-
 drivers/scsi/lpfc/lpfc_init.c    |  80 ++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_mem.c     |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c    | 107 ++++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_nvme.h    |   1 +
 drivers/scsi/lpfc/lpfc_nvmet.c   |  43 +++++++++++++---
 drivers/scsi/lpfc/lpfc_scsi.c    |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c     |  68 +++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_sli4.h    |   6 +++
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 18 files changed, 312 insertions(+), 106 deletions(-)

-- 
2.5.0
