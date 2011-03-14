From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 12/13] qla4xxx: masking required bits of add_fw_options
 during initialization
Date: Sun, 13 Mar 2011 22:25:55 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B1512@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:21575
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab1CNF0B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:26:01 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Prasanna Mumbai <prasanna.mumbai@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

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
        uint8_t res0;   /* 07 */
        uint16_t eth_mtu_size;  /* 08-09 */
        uint16_t add_fw_options;        /* 0A-0B */
+#define SERIALIZE_TASK_MGMT            0x0400

        uint8_t hb_interval;    /* 0C */
        uint8_t inst_num; /* 0D */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 199fa64..f9d81c8 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -476,6 +476,11 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)

        init_fw_cb->fw_options &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);

+       /* Set bit for "serialize task mgmt" all other bits need to be zero */
+       init_fw_cb->add_fw_options = 0;
+       init_fw_cb->add_fw_options |=
+           __constant_cpu_to_le16(SERIALIZE_TASK_MGMT);
+
        if (qla4xxx_set_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma)
                != QLA_SUCCESS) {
                DEBUG2(printk(KERN_WARNING
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

