From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v2 00/17] add fixes, device quirks, error recovery,
Date: Mon, 26 Oct 2015 17:40:55 +0200
Message-ID: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

V2:
This series should be pushed on top of 15 patches series:
"Big fixes, retries, handle a race condition"
fixed and few comments.

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
  scsi: ufs: disable vccq if it's not needed by UFS device
  scsi: ufs: make error handling bit faster
  scsi: ufs: add error recovery after DL NAC error
  scsi: ufs: add retry for query descriptors
  scsi: ufs: handle non spec compliant bkops behaviour by device
  scsi: ufs: tune UniPro parameters to optimize hibern8 exit time
  scsi: ufs: fix leakage during link off state
  scsi: ufs: add device quirk delay before putting UFS rails in LPM
  scsi: ufs-qcom: set PA_Local_TX_LCC_Enable before link startup
  scsi: ufs-qcom: fix compilation warnings

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  11 +
 drivers/scsi/ufs/Makefile                          |   2 +-
 drivers/scsi/ufs/ufs-qcom.c                        | 163 ++++-
 drivers/scsi/ufs/ufs-qcom.h                        |   9 +
 drivers/scsi/ufs/ufs.h                             |  32 +
 drivers/scsi/ufs/ufs_quirks.c                      | 104 +++
 drivers/scsi/ufs/ufs_quirks.h                      | 131 ++++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  36 +-
 drivers/scsi/ufs/ufshcd.c                          | 803 ++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h                          |  44 +-
 drivers/scsi/ufs/ufshci.h                          |   4 +
 drivers/scsi/ufs/unipro.h                          |  22 +
 12 files changed, 1217 insertions(+), 144 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs_quirks.c
 create mode 100644 drivers/scsi/ufs/ufs_quirks.h

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
