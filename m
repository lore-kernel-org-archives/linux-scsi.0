From: John Stultz <john.stultz@linaro.org>
Subject: [RFC][PATCH v2] scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC
Date: Mon, 22 Oct 2018 17:31:50 -0700
Message-ID: <1540254710-26936-1-git-send-email-john.stultz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>
Cc: Wei Li <liwei213@huawei.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>, John Stultz <john.stultz@linaro.org>
List-Id: linux-scsi@vger.kernel.org

From: Wei Li <liwei213@huawei.com>

Hynix ufs has deviations on hi36xx platform which will result in
ufs bursts transfer failures.

To fix the problem, the Hynix device must set the register
VS_DebugSaveConfigTime to 0x10, which will set time reference
for SaveConfigTime is 250 ns. The time reference for SaveConfigTime
is 40 ns by default.

This patch is necessary to boot on HiKey960 boards that use
Hynix UFS chips (H28U62301AMR model: hB8aL1).

Not sure if this is the preferred way of scoping the quirk to
the controller or not. Feedback would be greatly appreciated!

Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Wei Li <liwei213@huawei.com>
Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
[jstultz: Forward ported from older code, slight tweak to commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
v2:
* Narrowed the UFS chip model to the specific model where
  the issue has been seen. (SKhynix  H28U62301AMR model: hB8aL1)
* Reworked logic to be contained in ufs-hisi.c since it seems to
  be a controller issue that crops up with this specific chip
---
 drivers/scsi/ufs/ufs-hisi.c | 14 ++++++++++++++
 drivers/scsi/ufs/ufshcd.c   |  2 +-
 drivers/scsi/ufs/ufshcd.h   |  2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 46df707..a306acf 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -20,6 +20,7 @@
 #include "unipro.h"
 #include "ufs-hisi.h"
 #include "ufshci.h"
+#include "ufs_quirks.h"
 
 static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 {
@@ -390,6 +391,19 @@ static void ufs_hisi_set_dev_cap(struct ufs_hisi_dev_params *hisi_param)
 
 static void ufs_hisi_pwr_change_pre_change(struct ufs_hba *hba)
 {
+	struct ufs_dev_desc card = {0};
+
+	if (!ufs_get_device_desc(hba, &card)) {
+		if ((card.wmanufacturerid == UFS_VENDOR_SKHYNIX) &&
+		    (STR_PRFX_EQUAL("hB8aL1" /*H28U62301AMR*/, card.model))) {
+			pr_info("Hynix ufs flash device must set VS_DebugSaveConfigTime 0x10\n");
+			/* VS_DebugSaveConfigTime */
+			ufshcd_dme_set(hba, UIC_ARG_MIB(0xD0A0), 0x10);
+			/* sync length */
+			ufshcd_dme_set(hba, UIC_ARG_MIB(0x1556), 0x48);
+		}
+	}
+
 	/* update */
 	ufshcd_dme_set(hba, UIC_ARG_MIB(0x15A8), 0x1);
 	/* PA_TxSkip */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c55f38e..326fa32 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6242,7 +6242,7 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	return ret;
 }
 
-static int ufs_get_device_desc(struct ufs_hba *hba,
+int ufs_get_device_desc(struct ufs_hba *hba,
 			       struct ufs_dev_desc *dev_desc)
 {
 	int err;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 33fdd3f..31c0562 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -877,6 +877,8 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 			   u8 param_offset,
 			   u8 *param_read_buf,
 			   u8 param_size);
+int ufs_get_device_desc(struct ufs_hba *hba,
+			struct ufs_dev_desc *dev_desc);
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
-- 
2.7.4
