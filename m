From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v4 00/13] lpfc new hardware patches for 12.0.0.0
Date: Fri, 16 Feb 2018 09:28:14 -0800
Message-ID: <20180216172827.3739-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f43.google.com ([209.85.160.43]:39504 "EHLO
        mail-pl0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbeBPR32 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2018 12:29:28 -0500
Received: by mail-pl0-f43.google.com with SMTP id s13so2025541plq.6
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 09:29:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set adds support for Broadcom's new G7 product that
supports G4G FC.

The patches were cut against the Martin's 4.17/scsi-queue tree.

v2:
 Address comments:
   patch 1, 2, 4, 7: patch description typos
   patch 6: typo on 256GBit speed define

v3:
 Add review tags
 Address comments:
   patch 4: parens, replace set_memory_wc by ioremap_wc
   patch 6: reformat strings
   patch 9: parens
   patch 13: patch title
 patch 5: add missing snippet for default id string
 patch 9, 11: log print condensed to line

v4:
 Add review tags
 patch4: revert to using set_memory_wc


James Smart (13):
  lpfc: Rework lpfc to allow different sli4 cq and eq handlers
  lpfc: Rework sli4 doorbell infrastructure
  lpfc: Add SLI-4 if_type=6 support to the code base
  lpfc: Add push-to-adapter support to sli4
  lpfc: Add PCI Ids for if_type=6 hardware
  lpfc: Add 64G link speed support
  lpfc: Add if_type=6 support for cycling valid bits
  lpfc: Enable fw download on if_type=6 devices
  lpfc: Add embedded data pointers for enhanced performance
  lpfc: Fix nvme embedded io length on new hardware
  lpfc: Work around NVME cmd iu SGL type
  lpfc: update driver version to 12.0.0.0
  lpfc: Change Copyright of 12.0.0.0 modified files to 2018

 drivers/scsi/lpfc/lpfc.h         |  20 +-
 drivers/scsi/lpfc/lpfc_attr.c    |  86 +++++--
 drivers/scsi/lpfc/lpfc_bsg.c     |   6 +-
 drivers/scsi/lpfc/lpfc_ct.c      |   7 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  22 +-
 drivers/scsi/lpfc/lpfc_debugfs.h |  13 +-
 drivers/scsi/lpfc/lpfc_els.c     |   5 +
 drivers/scsi/lpfc/lpfc_hbadisc.c |   1 +
 drivers/scsi/lpfc/lpfc_hw.h      |  15 +-
 drivers/scsi/lpfc/lpfc_hw4.h     | 115 ++++++++-
 drivers/scsi/lpfc/lpfc_ids.h     |   4 +-
 drivers/scsi/lpfc/lpfc_init.c    | 247 +++++++++++++++---
 drivers/scsi/lpfc/lpfc_mbox.c    |   4 +
 drivers/scsi/lpfc/lpfc_nvme.c    |  69 +++--
 drivers/scsi/lpfc/lpfc_nvmet.c   |  24 ++
 drivers/scsi/lpfc/lpfc_scsi.c    |   8 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 535 +++++++++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_sli4.h    |  30 ++-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 19 files changed, 963 insertions(+), 250 deletions(-)

-- 
2.13.1
