From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V3 00/16] UFS: Power management support
Date: Wed, 10 Sep 2014 14:54:07 +0300
Message-ID: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:43840 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaIJLyg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 07:54:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>

This patch seies introduces support for power management in the driver as well as vendor specific initialization - registers, clocks, voltage regulators etc.

It includes also a rework for the init sequence and other PM pre-requisite such as write protection support, handling well-known LUN, error handling (retries), bkops, START_STOP unit command, and ICC levels settings.

--
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

Sahitya Tummala (3):
  scsi: ufs: Add support for clock gating
  scsi: ufs: Add freq-table-hz property for UFS device
  scsi: ufs: Add support for clock scaling using devfreq framework

Subhash Jadavani (6):
  scsi: support well known logical units
  scsi: balance out autopm get/put calls in scsi_sysfs_add_sdev()
  scsi: ufs: refactor query descriptor API support
  scsi: ufs: introduce well known logical unit in ufs
  scsi: ufs: add UFS power management support
  scsi: ufs: tune bkops while power managment events

Sujit Reddy Thumma (4):
  scsi: ufs: Allow vendor specific initialization
  scsi: ufs: Add regulator enable support
  scsi: ufs: Add clock initialization support
  scsi: ufs: improve init sequence

Yaniv Gardi (1):
  scsi: ufs: Active Power Mode - configuring bActiveICCLevel

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   37 +
 drivers/scsi/scsi_scan.c                           |   14 +
 drivers/scsi/scsi_sysfs.c                          |    5 +-
 drivers/scsi/sd.c                                  |    2 +
 drivers/scsi/sr.c                                  |    2 +
 drivers/scsi/st.c                                  |    2 +
 drivers/scsi/ufs/Kconfig                           |    2 +
 drivers/scsi/ufs/ufs.h                             |  131 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |   55 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  282 ++-
 drivers/scsi/ufs/ufshcd.c                          | 2408 ++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h                          |  277 ++-
 drivers/scsi/ufs/ufshci.h                          |    9 +-
 drivers/scsi/ufs/unipro.h                          |   56 +
 include/scsi/scsi.h                                |    1 +
 15 files changed, 2962 insertions(+), 321 deletions(-)

-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

