From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/17] lpfc updates for 11.4.0.0
Date: Thu,  1 Jun 2017 21:06:54 -0700
Message-ID: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:34301 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbdFBEH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:07:27 -0400
Received: by mail-qt0-f181.google.com with SMTP id c13so51428063qtc.1
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:07:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes, code cleanups, and error
handling in lpfc.

The patches were cut against the Martin's 4.12/scsi-fixes tree.
There are no outside dependencies. The patches should merge via
Martin's tree. 

Version 2 is a recut against scsi-fixes and includes 2 additional
patches (Coverity scan and EQ delay).

James Smart (17):
  lpfc: Add nvme initiator devloss support
  lpfc: Fix transition nvme-i rport handling to nport only.
  lpfc: Fix nvme port role handling in sysfs and debugfs handlers.
  lpfc: Add changes to assist in NVMET debugging
  lpfc: Fix Lun Priority level shown as NA
  lpfc: Fix nvmet node ref count handling
  lpfc: Fix Port going offline after multiple resets.
  lpfc: Fix counters so outstandng NVME IO count is accurate
  lpfc: Fix return value of board_mode store routine in case of online
    failure
  lpfc: Fix crash on powering off BFS VM with passthrough device
  lpfc: Fix System panic after loading the driver
  lpfc: Null pointer dereference when log_verbose is set to 0xffffffff
  lpfc: Fix PRLI retry handling when target rejects it.
  lpfc: Fix vports not logging into target
  lpfc: Fix defects reported by Coverity Scan
  lpfc: Add auto EQ delay logic
  lpfc: update to revision to 11.4.0.0

 drivers/scsi/lpfc/lpfc.h         |  23 +++--
 drivers/scsi/lpfc/lpfc_attr.c    |  94 +++++++++++------
 drivers/scsi/lpfc/lpfc_ct.c      |  31 +++---
 drivers/scsi/lpfc/lpfc_debugfs.c |  76 ++++++++------
 drivers/scsi/lpfc/lpfc_els.c     |  17 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c |  14 +--
 drivers/scsi/lpfc/lpfc_hw4.h     |  14 +++
 drivers/scsi/lpfc/lpfc_init.c    | 125 ++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_nvme.c    | 178 ++++++++++++--------------------
 drivers/scsi/lpfc/lpfc_nvme.h    |   2 -
 drivers/scsi/lpfc/lpfc_nvmet.c   | 218 ++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_nvmet.h   |  14 +--
 drivers/scsi/lpfc/lpfc_scsi.c    |  19 +++-
 drivers/scsi/lpfc/lpfc_sli.c     |  79 +++++++++-----
 drivers/scsi/lpfc/lpfc_sli.h     |   1 +
 drivers/scsi/lpfc/lpfc_sli4.h    |  12 ++-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 17 files changed, 588 insertions(+), 331 deletions(-)

-- 
2.11.0
