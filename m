From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH/RFC V2 00/16] UFS: Power managment support
Date: Thu, 14 Aug 2014 16:30:51 +0300
Message-ID: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch seies introduces support for power managment in the driver as well as vendor specific initialization - registers, clocks, voltage regulators etc.

It includes also a rework for the init sequnce and other PM pre-requisit such as write protection support, handling well-known LUN, error handling (retries), bkops, START_STOP unit command, and ICC levels settings.

--
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

Subhash Jadavani (5):
  scsi: ufs: refactor query descriptor API support
  scsi: support well known logical units
  scsi: ufs: introduce well known logical unit in ufs
  scsi: ufs: add UFS power management support
  scsi: ufs: add capability to control the auto bkops during suspend

Sujit Reddy Thumma (5):
  scsi: ufs: Allow vendor specific initialization
  scsi: ufs: Add regulator enable support
  scsi: ufs: Add clock initialization support
  scsi: ufs: improve init sequence
  scsi: sd: Avoid sending medium write commands if device is write
    protected

Yaniv Gardi (1):
  scsi: ufs: Active Power Mode - configuring bActiveICCLevel

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   37 +
 drivers/scsi/scsi_scan.c                           |   16 +
 drivers/scsi/scsi_sysfs.c                          |    7 +
 drivers/scsi/sd.c                                  |    6 +-
 drivers/scsi/ufs/Kconfig                           |    2 +
 drivers/scsi/ufs/ufs.h                             |  131 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |   55 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  282 ++-
 drivers/scsi/ufs/ufshcd.c                          | 2400 ++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h                          |  277 ++-
 drivers/scsi/ufs/ufshci.h                          |    9 +-
 drivers/scsi/ufs/unipro.h                          |   56 +
 include/scsi/scsi.h                                |    1 +
 include/scsi/scsi_host.h                           |    5 +
 14 files changed, 2959 insertions(+), 325 deletions(-)

-- 
1.8.5.2
