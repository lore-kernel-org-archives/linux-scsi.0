From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 11/13] qla4xxx: Use polling mode for disable interrupt
 mailbox completion
Date: Sun, 13 Mar 2011 22:25:38 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B1511@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:30018
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab1CNFZq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:25:46 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Sarang Radke <sarang.radke@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Sarang Radke <sarang.radke@qlogic.com>

Disable Interrupt MBX completion will disable the interrupt on successful completion.
Fixed the bug where driver was waiting for Interrupt to come in for its completion.
Now driver will poll for disable interrupt MBX completion.

Signed-off-by: Sarang Radke <sarang.radke@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 3d5ef2d..35381cb 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2304,14 +2304,13 @@ qla4_8xxx_enable_intrs(struct scsi_qla_host *ha)
 void
 qla4_8xxx_disable_intrs(struct scsi_qla_host *ha)
 {
-       if (test_bit(AF_INTERRUPTS_ON, &ha->flags))
+       if (test_and_clear_bit(AF_INTERRUPTS_ON, &ha->flags))
                qla4_8xxx_mbx_intr_disable(ha);

        spin_lock_irq(&ha->hardware_lock);
        /* BIT 10 - set */
        qla4_8xxx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0x0400);
        spin_unlock_irq(&ha->hardware_lock);
-       clear_bit(AF_INTERRUPTS_ON, &ha->flags);
 }

 struct ql4_init_msix_entry {
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

