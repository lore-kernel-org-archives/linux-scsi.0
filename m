From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/21] lpfc updates for 11.4.0.3
Date: Wed,  2 Aug 2017 16:36:27 -0700
Message-ID: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34535 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdHBXht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:37:49 -0400
Received: by mail-qt0-f194.google.com with SMTP id i19so6160750qte.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:37:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes and two additions.
The additions are BB credit support and Adapter type 6 support.

The patches were cut against the Martin's 4.13/scsi-fixes tree.
There are no outside dependencies.

Dick Kennedy (18):
  lpfc: Fix opps when ExpressLane is enabled
  lpfc: Fix plogi collision that causes illegal state transition
  lpfc: Fix loop mode target discovery
  lpfc: Fix rediscovery on switch blade pull
  lpfc: Fix oops when NVME Target is discovered in a nonNVME environment
  lpfc: convert info messages to standard messages
  lpfc: Correct return error codes to align with nvme_fc transport
  lpfc: Fix handling of FCP and NVME FC4 types in Pt2Pt topology
  lpfc: Fix duplicate NVME rport entries and namespaces.
  lpfc: Fix crash in lpfc nvmet when fc port is reset
  lpfc: Fix NVME PRLI handling during RSCN
  lpfc: Correct issues with FAWWN and FDISCs
  lpfc: Limit amount of work processed in IRQ
  lpfc: Fix MRQ > 1 context list handling
  lpfc: Fix relative offset error on large nvmet target ios
  lpfc: Fix nvme target failure after 2nd adapter reset
  lpfc: Fix bad sgl reposting after 2nd adapter reset
  lpfc: lpfc version bump 11.4.0.3

James Smart (3):
  lpfc: remove console log clutter
  lpfc: Add Buffer to Buffer credit recovery support
  lpfc: Add new adapter type 6 support

 drivers/scsi/lpfc/lpfc.h           |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  52 ++++-
 drivers/scsi/lpfc/lpfc_attr.h      |  10 +
 drivers/scsi/lpfc/lpfc_crtn.h      |   5 +-
 drivers/scsi/lpfc/lpfc_ct.c        |   4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |  31 +--
 drivers/scsi/lpfc/lpfc_debugfs.h   |  11 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       | 101 +++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  12 +-
 drivers/scsi/lpfc/lpfc_hw.h        |  18 +-
 drivers/scsi/lpfc/lpfc_hw4.h       | 108 ++++++++-
 drivers/scsi/lpfc/lpfc_init.c      | 209 ++++++++++++++---
 drivers/scsi/lpfc/lpfc_mbox.c      |  35 ++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  25 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  29 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c     | 276 ++++++++++++++++------
 drivers/scsi/lpfc/lpfc_nvmet.h     |  14 ++
 drivers/scsi/lpfc/lpfc_sli.c       | 461 +++++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli4.h      |  50 +++-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 21 files changed, 1142 insertions(+), 315 deletions(-)

-- 
2.13.1
