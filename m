From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 0/3] fixing building errors and warnings when components
Date: Tue, 19 May 2015 16:47:08 +0300
Message-ID: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, kishon@ti.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

V1:
The following combination of components, when SCSI_UFS_QCOM=y
and PHY_QCOM_UFS=m is illegal and causes build errors.
The 3rd patch in the series enables the SCSI_UFS_QCOM component to 
be compiled as a module (by changing its configuration to tristate).
So now, compiling SCSI_UFS_QCOM=m forces PHY_QCOM_UFS=m, and 
SCSI_UFS_QCOM=y forces PHY_QCOM_UFS=y.

In addition, when PHY_QCOM_UFS=m, external functions in 
phy-ufs-qcom.c should be exported. The 1st patch fixes it.

Another issue that we see when SCSI_UFS_QCOM=m is a warning that
the 2nd patch fixes.

notice:
checkpatch gives an error on the commit message of patch 1/3
in the series. Ignore as the commit message is the build errors
that this patch fixes.

Yaniv Gardi (3):
  phy: qcom-ufs: fix build error when the driver is built as a module
  scsi: ufs-qcom: fix compilation warning if compiled as a module
  scsi: ufs-qcom: update configuration option of SCSI_UFS_QCOM component

 drivers/phy/phy-qcom-ufs.c  | 11 +++++++++++
 drivers/scsi/ufs/Kconfig    |  2 +-
 drivers/scsi/ufs/ufs-qcom.c |  2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
