From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v2 0/4] fixing building errors and warnings when components
Date: Wed,  3 Jun 2015 12:37:31 +0300
Message-ID: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, pebolle@tiscali.nl, gbroner@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

V2:
In this Version, comments from reviewers were addressed
and also, added another change: PATCH v2 4/4
In this change we glue the variant attributes (vops, etc)
at the time of the platform probing, so they can be used
by the driver when it doing its initialization phase.

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

Yaniv Gardi (4):
  phy: qcom-ufs: fix build error when the component is built as a module
  scsi: ufs-qcom: fix compilation warning if compiled as a module
  scsi: ufs-qcom: update configuration option of SCSI_UFS_QCOM component
  scsi: ufs: probe and init of variant driver from the platform device

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  8 ++++
 drivers/phy/phy-qcom-ufs.c                         | 11 +++++
 drivers/scsi/ufs/Kconfig                           |  2 +-
 drivers/scsi/ufs/ufs-qcom.c                        | 47 +++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   | 33 +++++++++------
 5 files changed, 86 insertions(+), 15 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
