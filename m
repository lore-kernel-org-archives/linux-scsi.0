From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 06/17] qla2xxx: Enable SLER conditionally in target mode.
Date: Thu, 25 Sep 2014 06:14:48 -0400
Message-ID: <1411640099-7856-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:16915 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbaIYKs7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 06:48:59 -0400
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

From: Arun Easi <arun.easi@qlogic.com>

Sequence level error recovery (aka FC Tape) is not really required
for disk devices. On heavily loaded system, with slow turn around,
a bunch of status enquiries using REC puts additional burden to the
target, so just turn off SLER by default.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1503cf4..85587fc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -42,6 +42,11 @@
 #include "qla_def.h"
 #include "qla_target.h"
 
+static int ql2xtgt_tape_enable;
+module_param(ql2xtgt_tape_enable, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2xtgt_tape_enable,
+		"Enables Sequence level error recovery (aka FC Tape). Default is 0 - no SLER. 1 - Enable SLER.");
+
 static char *qlini_mode = QLA2XXX_INI_MODE_STR_ENABLED;
 module_param(qlini_mode, charp, S_IRUGO);
 MODULE_PARM_DESC(qlini_mode,
@@ -5172,8 +5177,13 @@ qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
 		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_9);
-		/* Enable FC tapes support */
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+		if (ql2xtgt_tape_enable)
+			/* Enable FC Tape support */
+			nv->firmware_options_2 |= cpu_to_le32(BIT_12);
+		else
+			/* Disable FC Tape support */
+			nv->firmware_options_2 &= cpu_to_le32(~BIT_12);
+
 		/* Disable Full Login after LIP */
 		nv->host_p &= __constant_cpu_to_le32(~BIT_10);
 		/* Enable target PRLI control */
@@ -5255,8 +5265,13 @@ qlt_81xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_81xx *nv)
 		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
 		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_9);
-		/* Enable FC tapes support */
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+		if (ql2xtgt_tape_enable)
+			/* Enable FC tape support */
+			nv->firmware_options_2 |= cpu_to_le32(BIT_12);
+		else
+			/* Disable FC tape support */
+			nv->firmware_options_2 &= cpu_to_le32(~BIT_12);
+
 		/* Disable Full Login after LIP */
 		nv->host_p &= __constant_cpu_to_le32(~BIT_10);
 		/* Enable target PRLI control */
-- 
1.7.7

