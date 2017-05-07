From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 00/19] aacraid: Patchset with reset rework and misc fixes
Date: Sun, 7 May 2017 06:34:05 -0700
Message-ID: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0059.outbound.protection.outlook.com ([104.47.41.59]:37120
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752615AbdEGVpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:45:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

This patchset primarily focuses on tweaking and hardening the controller
reset support for both ARC and HBA1000 devices. Now the driver can only
reset the controller thru eh reset. Included a srb memory fix and pci
dma allocation fix.

Raghava Aditya Renukunta (19):
 [SCSI] aacraid: Remove GFP_DMA for raw srb memory
 [SCSI] aacraid: Fix DMAR issues with  iommu=pt
 [SCSI] aacraid: Added 32 and 64 queue depth for arc natives
 [SCSI] aacraid: Set correct Queue Depth for HBA1000 RAW disks
 [SCSI] aacraid: Remove reset support from check_health
 [SCSI] aacraid: Change wait time for fib completion
 [SCSI] aacraid: Log count info of scsi cmds before reset
 [SCSI] aacraid: Print ctrl status before eh reset
 [SCSI] aacraid: Using single reset mask for IOP reset
 [SCSI] aacraid: Rework IOP reset
 [SCSI] aacraid: Add periodic checks to see IOP reset status
 [SCSI] aacraid: Rework SOFT reset code
 [SCSI] aacraid: Rework aac_src_restart
 [SCSI] aacraid: Use correct function to get ctrl health
 [SCSI] aacraid: Make sure ioctl returns on controller reset
 [SCSI] aacraid: Enable ctrl reset for both hba and arc
 [SCSI] aacraid: Add reset debugging statements
 [SCSI] aacraid: Remove reference to Series-9
 [SCSI] aacraid: Update driver version to 50834

 drivers/scsi/aacraid/aachba.c   |  17 ++-
 drivers/scsi/aacraid/aacraid.h  |  22 +++-
 drivers/scsi/aacraid/commctrl.c |  13 ++-
 drivers/scsi/aacraid/comminit.c |  18 +---
 drivers/scsi/aacraid/commsup.c  |  73 +++++++------
 drivers/scsi/aacraid/linit.c    | 232 ++++++++++++++++++++++++----------------
 drivers/scsi/aacraid/src.c      | 136 +++++++++++++----------
 7 files changed, 296 insertions(+), 215 deletions(-)

-- 
2.7.4
