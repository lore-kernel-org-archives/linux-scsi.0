From: vikas.chaudhary@qlogic.com
Subject: [PATCH 12/13] qla4xxx: masking required bits of add_fw_options during initialization
Date: Mon, 21 Mar 2011 03:34:35 -0700
Message-ID: <1300703676-27398-12-git-send-email-vikas.chaudhary@qlogic.com>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46148 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753022Ab1CUKqF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 06:46:05 -0400
In-Reply-To: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com, Prasanna Mumbai <prasanna.mumbai@qlogic.com>

From: Prasanna Mumbai <prasanna.mumbai@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Prasanna Mumbai <prasanna.mumbai@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h  |    1 +
 drivers/scsi/qla4xxx/ql4_mbx.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index c198579..31e2bf9 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -455,6 +455,7 @@ struct addr_ctrl_blk {
 	uint8_t res0;	/* 07 */
 	uint16_t eth_mtu_size;	/* 08-09 */
 	uint16_t add_fw_options;	/* 0A-0B */
+#define SERIALIZE_TASK_MGMT		0x0400
 
 	uint8_t hb_interval;	/* 0C */
 	uint8_t inst_num; /* 0D */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 199fa64..f9d81c8 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -476,6 +476,11 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 
 	init_fw_cb->fw_options &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
 
+	/* Set bit for "serialize task mgmt" all other bits need to be zero */
+	init_fw_cb->add_fw_options = 0;
+	init_fw_cb->add_fw_options |=
+	    __constant_cpu_to_le16(SERIALIZE_TASK_MGMT);
+
 	if (qla4xxx_set_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma)
 		!= QLA_SUCCESS) {
 		DEBUG2(printk(KERN_WARNING
-- 
1.7.3.2

