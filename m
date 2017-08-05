From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/20] lpfc updates for 11.4.0.3
Date: Fri,  4 Aug 2017 17:47:11 -0700
Message-ID: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34868 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752535AbdHEArl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:47:41 -0400
Received: by mail-pg0-f67.google.com with SMTP id l64so3109692pge.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:47:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com

This patch set provides a number of bug fixes and one additions.
The additions are BB credit support.

The patches were cut against the Martin's 4.13/scsi-fixes tree.
There are no outside dependencies.

V2:
 removed redundant Expresslane patch
 removed if type 6 support. Will add later.
 Incorporated patch from Maurizio Lombardi int constant too large


Dick Kennedy (17):
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

James Smart (2):
  lpfc: remove console log clutter
  lpfc: Add Buffer to Buffer credit recovery support

Maurizio Lombardi (1):
  scsi: lpfc: fix "integer constant too large" error on 32bit archs

 drivers/scsi/lpfc/lpfc.h           |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  52 ++++++-
 drivers/scsi/lpfc/lpfc_attr.h      |  10 ++
 drivers/scsi/lpfc/lpfc_crtn.h      |   5 +-
 drivers/scsi/lpfc/lpfc_ct.c        |   4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |  11 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       | 101 +++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  12 +-
 drivers/scsi/lpfc/lpfc_hw.h        |  18 ++-
 drivers/scsi/lpfc/lpfc_hw4.h       |  23 +++-
 drivers/scsi/lpfc/lpfc_init.c      |  62 +++++++--
 drivers/scsi/lpfc/lpfc_mbox.c      |  35 ++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  25 +++-
 drivers/scsi/lpfc/lpfc_nvme.c      |  25 ++--
 drivers/scsi/lpfc/lpfc_nvmet.c     | 271 ++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_nvmet.h     |  14 ++
 drivers/scsi/lpfc/lpfc_sli.c       |  56 +++++---
 drivers/scsi/lpfc/lpfc_sli4.h      |  23 +++-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 20 files changed, 598 insertions(+), 155 deletions(-)

-- 
2.13.1
