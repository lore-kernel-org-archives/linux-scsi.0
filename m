From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 00/10] ufs-qcom: phy/hcd: Clean up qcom-ufs phy and ufs-qcom hcd
Date: Tue, 18 Oct 2016 19:58:07 +0530
Message-ID: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

These patches cleanup the ufs phy driver to an extent.
Subsequent patches will target to clean the phy_init() of
these qcom-ufs phy drivers in order to get rid of a number of
exported APIs that phy drivers expose for ufs-qcom hcd driver
to use.

These patches are based on linux-phy next branch, and have been
tested with on db820c hardware with integration branch -
'integration-linux-qcomlt' of qualcomm linaro lt tree [1].

Changes from v1:
 1) Added a patch to the series to remove following unnecessary
    function declarations by moving the code:
    - __ufs_qcom_phy_init_vreg(),
    - ufs_qcom_phy_init_vreg(),
    - ufs_qcom_phy_base_init()
 2) Cleaned up following functions further for patch [2]:
    - ufs_qcom_phy_enable(/disable)_ref_clk()
    - ufs_qcom_phy_enable(/disable)_iface_clk()
 3) Added patch to add phy_exit() call to ufs-qcom exit path.
 4) Added a patch to remove ufs_qcom_phy_exit() from 'phy-qcom-ufs'
    driver, since this api just powers off the phy.

[1] https://git.linaro.org/landing-teams/working/qualcomm/kernel.git
[2] ufs-qcom: phy/hcd: Refactoring phy clock handling

Vivek Gautam (9):
  phy: qcom-ufs: Remove unnecessary BUG_ON
  phy: qcom-ufs: Use devm sibling of kstrdup for regulator names
  phy: qcom-ufs-qmp-xx: Discard remove callback for drivers.
  phy: qcom-ufs: Cleanup clock and regulator initialization
  phy: qcom-ufs: Remove unnecessary function declarations
  phy: qcom-ufs-qmp-xx: Move clock and regulator init out of phy init
  ufs-qcom: phy/hcd: Refactoring phy clock handling
  scsi/ufs: qcom: Add phy_exit call in hcd exit path
  phy: qcom-ufs: Remove common layer phy exit callback

Yaniv Gardi (1):
  phy: qcom-ufs: remove failure when rx/tx_iface_clk are absence

 drivers/phy/phy-qcom-ufs-i.h        |   7 +-
 drivers/phy/phy-qcom-ufs-qmp-14nm.c |  71 ++++-----
 drivers/phy/phy-qcom-ufs-qmp-20nm.c |  65 ++++-----
 drivers/phy/phy-qcom-ufs.c          | 278 ++++++++++++++++--------------------
 drivers/scsi/ufs/ufs-qcom.c         |  16 +--
 include/linux/phy/phy-qcom-ufs.h    |  18 ---
 6 files changed, 182 insertions(+), 273 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
