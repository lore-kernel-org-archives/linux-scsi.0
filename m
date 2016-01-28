From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH v2 10/15] megaraid_sas: IO throttling support
Date: Thu, 28 Jan 2016 21:04:31 +0530
Message-ID: <1453995276-24955-11-git-send-email-sumit.saxena@avagotech.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33083 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966476AbcA1Pfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:35:48 -0500
Received: by mail-pa0-f53.google.com with SMTP id cy9so24858603pac.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:35:47 -0800 (PST)
In-Reply-To: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will add capability in driver to tell firmware that it can throttle IOs in case Controller's Queue depth is downgraded post OFU
(Online firmware upgrade). This feature will ensure firmware can be downgraded from higher queue depth to lower queue depth without needing system reboot.
Added throttling code in IO path of driver, in case OS tries to send more IOs than post OFU firmware's queue depth.

I have accomodated Tomas' comments provided on last time sent patch- removed the un-necessary code of throttling of IOs against can_queue inside
function- megasas_build_and_issue_cmd_fusion() as SCSI mid layer will anyways does this.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 6 ++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 2a2f491..c8d25a7 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1537,7 +1537,8 @@ union megasas_sgl_frame {
 typedef union _MFI_CAPABILITIES {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved:21;
+		u32     reserved:20;
+		u32     support_qd_throttling:1;
 		u32     support_fp_rlbypass:1;
 		u32     support_vfid_in_ioframe:1;
 		u32     support_ext_io_size:1;
@@ -1561,7 +1562,8 @@ typedef union _MFI_CAPABILITIES {
 		u32     support_ext_io_size:1;
 		u32     support_vfid_in_ioframe:1;
 		u32     support_fp_rlbypass:1;
-		u32     reserved:21;
+		u32     support_qd_throttling:1;
+		u32     reserved:20;
 #endif
 	} mfi_capabilities;
 	__le32		reg;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6b8547c..2c4912f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -803,6 +803,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	if (!dual_qdepth_disable)
 		drv_ops->mfi_capabilities.support_ext_queue_depth = 1;
 
+	drv_ops->mfi_capabilities.support_qd_throttling = 1;
 	/* Convert capability to LE32 */
 	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
 
-- 
1.8.3.1

