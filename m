From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 00/17] add fixes, device quirks, error recovery,
Date: Sun, 13 Sep 2015 17:52:40 +0300
Message-ID: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

V1:
This series should be pushed on top of 15 patches series:
"Big fixes, retries, handle a race condition"

Yaniv Gardi (17):
  scsi: ufs-qcom: add number of lanes per direction
  scsi: ufs: add option to change default UFS power management level
  scsi: ufs: optimize system suspend handling
  scsi: ufs: avoid spurious UFS host controller interrupts
  scsi: ufs: implement scsi host timeout handler
  scsi :ufs: verify hba controller hce reg value
  scsi: ufs: separate device and host quirks
  scsi: ufs: split broken LCC quirk
  scsi: ufs: disable vccq if it's not needed by UFS device
  scsi: ufs: make error handling bit faster
  scsi: ufs: add error recovery after DL NAC error
  scsi: ufs: add retry for query descriptors
  scsi: ufs: handle non spec compliant bkops behaviour by device
  scsi: ufs: tune UniPro parameters to optimize hibern8 exit time
  scsi: ufs: fix leakage during link off state
  scsi: ufs: add delay before putting UFS rails in low power modes
  scsi: ufs-qcom: set PA_Local_TX_LCC_Enable before link startup

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  11 +
 drivers/scsi/ufs/Makefile                          |   2 +-
 drivers/scsi/ufs/ufs-qcom.c                        | 163 +++-
 drivers/scsi/ufs/ufs-qcom.h                        |   9 +
 drivers/scsi/ufs/ufs.h                             |  32 +
 drivers/scsi/ufs/ufs_quirks.c                      | 101 +++
 drivers/scsi/ufs/ufs_quirks.h                      | 123 +++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  17 +-
 drivers/scsi/ufs/ufshcd.c                          | 829 ++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h                          |  44 +-
 drivers/scsi/ufs/ufshci.h                          |   4 +
 drivers/scsi/ufs/unipro.h                          |  22 +
 12 files changed, 1215 insertions(+), 142 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs_quirks.c
 create mode 100644 drivers/scsi/ufs/ufs_quirks.h

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
