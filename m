From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v3 00/12] ufs-qcom: phy/hcd: Clean up qcom-ufs phy and ufs-qcom hcd
Date: Sun, 30 Oct 2016 01:52:02 +0530
Message-ID: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbcJ2UW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2016 16:22:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>

These patches cleanup the ufs phy driver to an extent.
Subsequent patches will target to clean the phy_init() of
these qcom-ufs phy drivers in order to get rid of a number of
exported APIs that phy drivers expose for ufs-qcom hcd driver
to use.

These patches are based on linux-phy next branch, and have been
tested with on db820c hardware with integration branch -
'integration-linux-qcomlt' of qualcomm linaro lt tree [1].

Changes since v2:
 1) Addressed review comment for the patch making tx/rx_iface clocks
    as optional.
    Added a new compatible string for 14nm ufs phy present on msm8996
    chips, and skipping the tx/r_iface clock fetching based on this
    compatible string.
 2) Added phy_power_off() and phy_power_on() calls in setup_clock()
    callback of ufs-qcom platform driver. This is to follow the
    turning off of the clocks during aggressive clock gating.
 3) Addressed review comment for fixing commit message for patch:
    phy: qcom-ufs-qmp-xx: Discard remove callback for drivers.
 4) Added a patch to remove the call to devm_free() for resource
    allocated through devm_kzalloc().

Changes since v1:
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


Vivek Gautam (12):
  phy: qcom-ufs: Remove unnecessary BUG_ON
  phy: qcom-ufs: Use devm sibling of kstrdup for regulator names
  phy: qcom-ufs: Cleanup clock and regulator initialization
  phy: qcom-ufs-14nm: Add new compatible for msm8996 based phy
  phy: qcom-ufs: Skip obtaining rx/tx_iface_clk for msm8996 based phy
  phy: qcom-ufs-qmp-xx: Discard remove callback for drivers.
  phy: qcom-ufs: Remove unnecessary function declarations
  phy: qcom-ufs-qmp-xx: Move clock and regulator init out of phy init
  ufs-qcom: phy/hcd: Refactoring phy clock handling
  phy: qcom-ufs: Remove common layer phy exit callback
  scsi/ufs: qcom: Add phy_exit call in hcd exit path
  scsi/ufs: qcom: Don't free resource-managed kmalloc element

 Documentation/devicetree/bindings/ufs/ufs-qcom.txt |   7 +-
 drivers/phy/phy-qcom-ufs-i.h                       |   7 +-
 drivers/phy/phy-qcom-ufs-qmp-14nm.c                |  72 +++---
 drivers/phy/phy-qcom-ufs-qmp-20nm.c                |  65 ++---
 drivers/phy/phy-qcom-ufs.c                         | 269 +++++++++------------
 drivers/scsi/ufs/ufs-qcom.c                        |  20 +-
 include/linux/phy/phy-qcom-ufs.h                   |  18 --
 7 files changed, 184 insertions(+), 274 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

