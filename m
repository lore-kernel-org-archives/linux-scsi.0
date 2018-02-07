From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/13] lpfc new hardware patches for 12.0.0.0
Date: Tue,  6 Feb 2018 18:28:38 -0800
Message-ID: <20180207022851.11800-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35204 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752537AbeBGC3A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 21:29:00 -0500
Received: by mail-oi0-f68.google.com with SMTP id e15so2935053oiy.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2018 18:29:00 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set adds support for Broadcom's new G7 product that
supports G4G FC.

The patches were cut against the Martin's 4.16/scsi-queue tree.

The patches are dependent (layered on top of) the lpfc 11.4.0.7
patchset that was recently posted. See:
  https://www.spinics.net/lists/linux-scsi/msg116956.html

v2:
 Address comments:
   patch 1, 2, 4, 7 - patch description typos
   patch 6 - typo on 256GBit speed define


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
  lpfc: Update 12.0.0.0 modified files for 2018 Copyright

 drivers/scsi/lpfc/lpfc.h         |  20 +-
 drivers/scsi/lpfc/lpfc_attr.c    |  85 +++++--
 drivers/scsi/lpfc/lpfc_bsg.c     |   6 +-
 drivers/scsi/lpfc/lpfc_ct.c      |   7 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  22 +-
 drivers/scsi/lpfc/lpfc_debugfs.h |  13 +-
 drivers/scsi/lpfc/lpfc_els.c     |   5 +
 drivers/scsi/lpfc/lpfc_hbadisc.c |   1 +
 drivers/scsi/lpfc/lpfc_hw.h      |  15 +-
 drivers/scsi/lpfc/lpfc_hw4.h     | 115 ++++++++-
 drivers/scsi/lpfc/lpfc_ids.h     |   4 +-
 drivers/scsi/lpfc/lpfc_init.c    | 245 +++++++++++++++---
 drivers/scsi/lpfc/lpfc_mbox.c    |   4 +
 drivers/scsi/lpfc/lpfc_nvme.c    |  69 +++--
 drivers/scsi/lpfc/lpfc_nvmet.c   |  24 ++
 drivers/scsi/lpfc/lpfc_scsi.c    |   8 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 535 +++++++++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_sli4.h    |  30 ++-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 19 files changed, 960 insertions(+), 250 deletions(-)

-- 
2.13.1
