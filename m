From: Dolev Raviv <draviv@codeaurora.org>
Subject: [RFC 00/10] UFS: Power managment support
Date: Mon, 11 Aug 2014 15:40:28 +0300
Message-ID: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch seies introduces support for power managment in the driver
as well as vendor specific initialization - registers, clocks, voltage
regulators etc.

It includes also a rework for the init sequnce and other PM pre-
requisit such as write protection support, well-known LUN, error
handling (retries), bkops, START_STOP, and ICC levels.

Subhash Jadavani (4):
  scsi: ufs: refactor query descriptor API support
  scsi: support well known logical units
  scsi: ufs: introduce well known logical unit in ufs
  scsi: ufs: add UFS power management support

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
 drivers/scsi/ufs/ufs.h                             |  131 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |   55 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  260 ++-
 drivers/scsi/ufs/ufshcd.c                          | 1733 ++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h                          |  152 +-
 drivers/scsi/ufs/ufshci.h                          |    9 +-
 include/scsi/scsi.h                                |    1 +
 include/scsi/scsi_host.h                           |    5 +
 12 files changed, 2155 insertions(+), 257 deletions(-)

-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
