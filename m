From: j00310691 <john.garry@huawei.com>
Subject: [PATCH v2 02/23] hisi_sas: relocate DEV_IS_EXPANDER
Date: Tue, 26 Jan 2016 01:21:51 +0800
Message-ID: <1453742532-53092-3-git-send-email-john.garry@huawei.com>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Relocate DEV_IS_EXPANDER to hisi_sas.h as
it will be required for v2 hw support.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 4 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 5af2e41..21eb2bb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -37,6 +37,10 @@
 #define HISI_SAS_MAX_SSP_RESP_SZ (sizeof(struct ssp_frame_hdr) + 1024)
 #define HISI_SAS_MAX_SMP_RESP_SZ 1028
 
+#define DEV_IS_EXPANDER(type) \
+	((type == SAS_EDGE_EXPANDER_DEVICE) || \
+	(type == SAS_FANOUT_EXPANDER_DEVICE))
+
 struct hisi_hba;
 
 enum {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 99b1950..7689939 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -12,10 +12,6 @@
 #include "hisi_sas.h"
 #define DRV_NAME "hisi_sas"
 
-#define DEV_IS_EXPANDER(type) \
-	((type == SAS_EDGE_EXPANDER_DEVICE) || \
-	(type == SAS_FANOUT_EXPANDER_DEVICE))
-
 #define DEV_IS_GONE(dev) \
 	((!dev) || (dev->dev_type == SAS_PHY_UNUSED))
 
-- 
1.9.1
