From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] megaraid_sas: fix endianess for the crash dump state support
Date: Sat, 10 Jan 2015 18:11:23 +0100
Message-ID: <1420909883-19479-11-git-send-email-hch@lst.de>
References: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34204 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbbAJRM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:26 -0500
In-Reply-To: <1420909883-19479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Note that this one is a bit fishy: it seems like it should always be read
and written using either words or bytes, but never using a mixture.

Please verify against the hardware documentation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 81484f1..465dd45 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1676,7 +1676,7 @@ struct megasas_instance {
 	u32 drv_buf_alloc;
 	u32 crash_dump_fw_support;
 	u32 crash_dump_drv_support;
-	u32 crash_dump_app_support;
+	__le32 crash_dump_app_support;
 	u32 secure_jbod_support;
 	spinlock_t crashdump_lock;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3d4a080..29a1b20 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6010,7 +6010,7 @@ static int megasas_set_crash_dump_params_ioctl(
 {
 	struct megasas_instance *local_instance;
 	int i, error = 0;
-	int crash_support;
+	__le32 crash_support;
 
 	crash_support = cmd->frame->dcmd.mbox.w[0];
 
@@ -6020,7 +6020,7 @@ static int megasas_set_crash_dump_params_ioctl(
 			if ((local_instance->adprecovery ==
 				MEGASAS_HBA_OPERATIONAL) &&
 				!megasas_set_crash_dump_params(local_instance,
-					crash_support)) {
+					le32_to_cpu(crash_support))) {
 				local_instance->crash_dump_app_support =
 					crash_support;
 				dev_info(&local_instance->pdev->dev,
@@ -6084,7 +6084,8 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 					       MFI_FRAME_SGL64 |
 					       MFI_FRAME_SENSE64));
 
-	if (cmd->frame->dcmd.opcode == MR_DRIVER_SET_APP_CRASHDUMP_MODE) {
+	if (cmd->frame->dcmd.opcode ==
+			cpu_to_le32(MR_DRIVER_SET_APP_CRASHDUMP_MODE)) {
 		error = megasas_set_crash_dump_params_ioctl(cmd);
 		megasas_return_cmd(instance, cmd);
 		return error;
-- 
1.9.1

