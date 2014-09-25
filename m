From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 06/19] qla2xxx: Enable SLER conditionally in target mode.
Date: Thu, 25 Sep 2014 04:09:59 -0400
Message-ID: <1411632612-7320-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Sequence level error recovery (aka FC Tape) is not really required
for disk devices. On heavily loaded system, with slow turn around,
a bunch of status enquiries using REC puts additional burden to the
target, so just turn off SLER by default.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c64266a..2d4003f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5172,8 +5172,13 @@ qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
 		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_9);
-		/* Enable FC tapes support */
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+#ifdef QLT_ENABLE_TAPE
+		/* Enable FC Tape support */
+		nv->firmware_options_2 |= cpu_to_le32(BIT_12);
+#else
+		/* Disable FC Tape support */
+		nv->firmware_options_2 &= cpu_to_le32(~BIT_12);
+#endif
 		/* Disable Full Login after LIP */
 		nv->host_p &= __constant_cpu_to_le32(~BIT_10);
 		/* Enable target PRLI control */
@@ -5255,8 +5260,13 @@ qlt_81xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_81xx *nv)
 		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
 		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_9);
-		/* Enable FC tapes support */
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+#ifdef QLT_ENABLE_TAPE
+		/* Enable FC tape support */
+		nv->firmware_options_2 |= cpu_to_le32(BIT_12);
+#else
+		/* Disable FC tape support */
+		nv->firmware_options_2 &= cpu_to_le32(~BIT_12);
+#endif
 		/* Disable Full Login after LIP */
 		nv->host_p &= __constant_cpu_to_le32(~BIT_10);
 		/* Enable target PRLI control */
-- 
1.7.7
