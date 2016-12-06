From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 04/22] qla2xxx: Clear BIT 15 in NVRAM during initialization.
Date: Tue, 6 Dec 2016 12:30:33 -0800
Message-ID: <1481056251-2310-5-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0043.outbound.protection.outlook.com ([104.47.34.43]:52352
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752185AbcLFUbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:31:08 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Some of the ports have BIT_15 of firmware_options1 set. This is a
reserved bit and should not be set for Target Mode. Clear BIT 15
during stage1 initialization.

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8a762a6..adb3b93 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6527,7 +6527,6 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		/* Disable ini mode, if requested */
 		if (!qla_ini_mode_enabled(vha))
 			nv->firmware_options_1 |= cpu_to_le32(BIT_5);
-
 		/* Disable Full Login after LIP */
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
@@ -6541,6 +6540,13 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 
 		/* Disable Full Login after LIP */
 		nv->host_p &= cpu_to_le32(~BIT_10);
+
+		/*
+		 * clear BIT 15 explicitly as we have seen at least
+		 * a couple of instances where this was set and this
+		 * was causing the firmware to not be initialized.
+		 */
+		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_15);
 		/* Enable target PRLI control */
 		nv->firmware_options_2 |= cpu_to_le32(BIT_14);
 	} else {
@@ -6630,6 +6636,13 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_9);
+		/*
+		 * clear BIT 15 explicitly as we have seen at
+		 * least a couple of instances where this was set
+		 * and this was causing the firmware to not be
+		 * initialized.
+		 */
+		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_15);
 		if (ql2xtgt_tape_enable)
 			/* Enable FC tape support */
 			nv->firmware_options_2 |= cpu_to_le32(BIT_12);
-- 
1.8.3.1

