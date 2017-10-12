From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 0/5] qcom-ufs: phy/hcd: Refactor phy initialization code
Date: Thu, 12 Oct 2017 11:49:31 +0530
Message-ID: <1507789176-2760-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, robh+dt@kernel.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Refactoring the qcom-ufs phy and host controller code to move
further towards the generic phy usage. Right now the qcom-ufs exports
a bunch of APIs that are used by the host controller to initialize
the phy.
With this patch series, we populate the phy_init() which was a no-op
earlier. The host controller then calls the phy_init() at the designated
place rather than doing it invariably in ufs_hcd_init().

As part of this series, we introduce phy modes for ufs phy.
The M-PHY has two data rates defined for each generations (Gears) -
Rate A and Rate B. These can serve as the two modes of ufs HS phy.
Host controller can direct the phy to set the respective configurations
based on the phy modes.

The patch-series has been tested with necessary dt patches on db820c.


Hi Kishon,

I shall be on vacation for the next week. Can you kindly consider
picking this series for 4.15. Martin was good with last version
of the patches[1], and Subhash has reviewed the patches of which
he has given 'Reviewed-by' for [PATCH 4/5] , and I have addressed
his comments for the last patch. I hope it's not too late for 4.15.
Subhash, can you please consider giving your 'Reviewed-by' for
the last patch if you find it good.

[1] https://lkml.org/lkml/2017/8/10/958

Vivek Gautam (5):
  dt-bindings: phy: Add PHY_TYPE_UFS definition
  phy: Add UFS PHY modes
  phy: qcom-ufs: Add support to set phy mode
  scsi/ufs: qcom: Set phy mode based on the controllers HS MODE
  ufs/phy: qcom: Refactor to use phy_init call

 drivers/phy/qualcomm/phy-qcom-ufs-i.h        |  5 ++--
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c | 29 +++++++++++++++++--
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c | 29 +++++++++++++++++--
 drivers/phy/qualcomm/phy-qcom-ufs.c          | 42 ++++++++++------------------
 drivers/scsi/ufs/ufs-qcom.c                  | 39 +++++++++++---------------
 include/dt-bindings/phy/phy.h                |  1 +
 include/linux/phy/phy-qcom-ufs.h             |  3 --
 include/linux/phy/phy.h                      |  2 ++
 8 files changed, 91 insertions(+), 59 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
