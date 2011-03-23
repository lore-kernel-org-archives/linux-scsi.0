From: vikas.chaudhary@qlogic.com
Subject: [PATCH 11/13] qla4xxx: Use polling mode for disable interrupt mailbox completion
Date: Wed, 23 Mar 2011 08:07:33 -0700
Message-ID: <1300892853-29931-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:56239 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S933043Ab1CWPLo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 11:11:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com, Sarang Radke <sarang.radke@qlogic.com>

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
-	if (test_bit(AF_INTERRUPTS_ON, &ha->flags))
+	if (test_and_clear_bit(AF_INTERRUPTS_ON, &ha->flags))
 		qla4_8xxx_mbx_intr_disable(ha);
 
 	spin_lock_irq(&ha->hardware_lock);
 	/* BIT 10 - set */
 	qla4_8xxx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0x0400);
 	spin_unlock_irq(&ha->hardware_lock);
-	clear_bit(AF_INTERRUPTS_ON, &ha->flags);
 }
 
 struct ql4_init_msix_entry {
-- 
1.7.3.2

