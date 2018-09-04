From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 0/3] scsi: ufs-qcom: Remove all direct calls to qcom-ufs phy
Date: Tue,  4 Sep 2018 15:47:16 +0530
Message-ID: <20180904101719.18049-1-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: subhashj@codeaurora.org, bjorn.andersson@linaro.org, evgreen@chromium.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Cleaning up the ufs-qcom host further to remove all direct calls
into qcom-ufs driver.
Only phy-qcom-ufs-qmp-20nm phy handles these direct calls from ufs host
and this phy is not used in any supported qcom platform in current kernel.
So, while we free up the host from all the ufs_qcom_phy_*() API calls
we should declare 20nm phy as broken.
For this we fork out couple of configs from PHY_QCOM_UFS -
PHY_QCOM_UFS_14NM and PHY_QCOM_UFS_20NM out of which we declare
PHY_QCOM_UFS_20NM as 'broken'.

This series helps in a clean use of ufs phy support for sdm845
and further SoCs that will also use phy-qcom-qmp phy driver.

Vivek Gautam (3):
  phy: qcom-ufs: Remove stale methods that handle ref clk
  scsi/ufs: qcom: Remove ufs_qcom_phy_*() calls from host
  phy: qcom-ufs: Declare 20nm qcom ufs qmp phy as Broken

 drivers/phy/qualcomm/Kconfig          | 17 ++++++++++++
 drivers/phy/qualcomm/Makefile         |  4 +--
 drivers/phy/qualcomm/phy-qcom-ufs-i.h |  2 +-
 drivers/phy/qualcomm/phy-qcom-ufs.c   | 50 -----------------------------------
 drivers/scsi/ufs/ufs-qcom.c           | 28 +-------------------
 drivers/scsi/ufs/ufs-qcom.h           |  5 ----
 include/linux/phy/phy-qcom-ufs.h      | 38 --------------------------
 7 files changed, 21 insertions(+), 123 deletions(-)
 delete mode 100644 include/linux/phy/phy-qcom-ufs.h

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
