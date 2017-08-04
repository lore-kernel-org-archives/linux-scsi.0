From: Vivek Gautam <vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 0/5] qcom-ufs: phy/hcd: Refactor phy initialization code
Date: Fri,  4 Aug 2017 12:18:47 +0530
Message-ID: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kishon-l0cyMroinI0@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vivek Gautam <vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
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

Vivek Gautam (5):
  dt-bindings: phy: Add PHY_TYPE_UFS definition
  phy: Add UFS PHY modes
  phy: qcom-ufs: Add support to set phy mode
  scsi/ufs: qcom: Set phy mode based on the controllers HS MODE
  ufs/phy: qcom: Refactor to use phy_init call

 drivers/phy/qualcomm/phy-qcom-ufs-i.h        |  4 +--
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c | 23 ++++++++++++++--
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c | 23 ++++++++++++++--
 drivers/phy/qualcomm/phy-qcom-ufs.c          | 38 +++++++--------------------
 drivers/scsi/ufs/ufs-qcom.c                  | 39 ++++++++++++----------------
 include/dt-bindings/phy/phy.h                |  1 +
 include/linux/phy/phy-qcom-ufs.h             |  3 ---
 include/linux/phy/phy.h                      |  2 ++
 8 files changed, 74 insertions(+), 59 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
