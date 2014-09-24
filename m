From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH/RESEND V5 00/17] UFS: Power management support
Date: Wed, 24 Sep 2014 18:13:56 +0300
Message-ID: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch seies introduces support for power management in the driver as well as vendor specific initialization - registers, clocks, voltage regulators etc.

It includes also a rework for the init sequence and other PM pre-requisite such as write protection support, handling well-known LUN, error handling (retries), bkops, START_STOP unit command, and ICC levels settings.

--
Changes from V4:
 - Restored "[01/16] scsi: support well known logical units" to fix type issue"
   and renamed "[01/17] scsi: fixing the "type" for well known LUs"
 - Add "[02/17] scsi: sysfs: don't add scsi_device if its already added"
   to help addressing Chris comments.
 - Squashed "[10/17] scsi: ufs: introduce well known logical unit in ufs" and
   "[09/17] scsi: ufs: manually add well known logical" and addressed most of
   Chris comments here.
 - Cleanup in "[11/16] scsi: ufs: add UFS power management support" to align
   it with comments made on previous patches.

Changes from V3:
 - Replaced "[01/16] scsi: support well known logical units" with
   "[09/17] scsi: ufs: manually add well known logical
 - add patch "[PATCH V4 05/17] scsi: ufs: add voting support for host"
 - Fix couple of compilation issues introduced in V3
 - Add a NULL pointer test to hba->vops before accessing it
 - Changed disable/enable irq with request/free irq

Changes from V2:
 - Reordered scsi core patches
 - add patch "[PATCH V3 02/16] scsi: balance out autopm get/put calls in"
 - Minor changes/fixes to the patches:
    * "[PATCH V3 10/16] scsi: ufs: add UFS power management support"
    * "[PATCH V3 12/16] scsi: ufs: Add support for clock gating"
    * "[PATCH V3 16/16] scsi: ufs: definitions for phy interface"
   In order to address community concerns, and as a result of further
   development and testing.

Changes from V1:
 - 6 new patches apended at the end
 - Allow overriding power configuration with controller support and
   preferences/capabilities <Dolev Raviv>
 - Allow overriding power choice with controller capabilities <Dolev Raviv>
 - Add support for clock gating and clock scaling <Sahitya Tummala>
 - Add capability to control the auto bkops during suspend <Subhash Jadavani>
 - Add misc changes for phy/unipro driver usage <Dolev Raviv>

Dolev Raviv (2):
  scsi: ufs: refactor configuring power mode
  scsi: ufs: definitions for phy interface

Raviv Shvili (1):
  scsi: ufs: add voting support for host controller power

Sahitya Tummala (3):
  scsi: ufs: Add support for clock gating
  scsi: ufs: Add freq-table-hz property for UFS device
  scsi: ufs: Add support for clock scaling using devfreq framework

Subhash Jadavani (6):
  scsi: fixing the "type" for well known LUs
  scsi: sysfs: don't add scsi_device if its already added
  scsi: ufs: refactor query descriptor API support
  scsi: ufs: manually add well known logical units
  scsi: ufs: add UFS power management support
  scsi: ufs: tune bkops while power managment events

Sujit Reddy Thumma (4):
  scsi: ufs: Allow vendor specific initialization
  scsi: ufs: Add regulator enable support
  scsi: ufs: Add clock initialization support
  scsi: ufs: improve init sequence

Yaniv Gardi (1):
  scsi: ufs: Active Power Mode - configuring bActiveICCLevel

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   41 +
 drivers/scsi/scsi_scan.c                           |    8 +
 drivers/scsi/scsi_sysfs.c                          |    3 +
 drivers/scsi/ufs/Kconfig                           |    2 +
 drivers/scsi/ufs/ufs.h                             |  132 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |   55 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  291 ++-
 drivers/scsi/ufs/ufshcd.c                          | 2519 ++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h                          |  280 ++-
 drivers/scsi/ufs/ufshci.h                          |    9 +-
 drivers/scsi/ufs/unipro.h                          |   56 +
 include/scsi/scsi.h                                |    1 +
 12 files changed, 3095 insertions(+), 302 deletions(-)

-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
