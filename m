From: Evan Green <evgreen@chromium.org>
Subject: [PATCH] scsi: ufs: Remove select of phy-qcom-ufs from ufs-qcom
Date: Fri, 11 Jan 2019 15:31:59 -0800
Message-ID: <20190111233159.218342-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Douglas Anderson <dianders@chromium.org>, Evan Green <evgreen@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

CONFIG_SCSI_UFS_QCOM selects CONFIG_PHY_QCOM_UFS, assuming that
this was the only possible PHY driver Qualcomm's UFS controller
would use. But in SDM845, the UFS driver is bundled into phy-qcom-qmp,
and phy-qcom-ufs is unused.

Remove the select, since for SDM845 it adds useless drivers to the
build.

Signed-off-by: Evan Green <evgreen@chromium.org>
---

 drivers/scsi/ufs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 2ddbb26d9c265..6db37cf306b05 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -99,7 +99,6 @@ config SCSI_UFS_DWC_TC_PLATFORM
 config SCSI_UFS_QCOM
 	tristate "QCOM specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
-	select PHY_QCOM_UFS
 	help
 	  This selects the QCOM specific additions to UFSHCD platform driver.
 	  UFS host on QCOM needs some vendor specific configuration before
-- 
2.18.1
