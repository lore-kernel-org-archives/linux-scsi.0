From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH 6/8] qla4xxx: Resubmission: ql4_isr.c support for new mbx
	cmds
Date: Wed, 23 May 2007 18:03:20 -0700
Message-ID: <1179968600.16099.17.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6073 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbXEXBEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 21:04:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

Add support to log all AENs and service mbx cmd completions for QLA4032

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

 drivers/scsi/qla4xxx/ql4_isr.c |   53 ++++++++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 35b9e36..946e22b 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -6,6 +6,9 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 /**
  * qla2x00_process_completed_request() - Process a Fast Post response.
@@ -417,6 +420,7 @@ static void qla4xxx_isr_decode_mailbox(s
 				       uint32_t mbox_status)
 {
 	int i;
+	uint32_t mbox_stat2, mbox_stat3;
 
 	if ((mbox_status == MBOX_STS_BUSY) ||
 	    (mbox_status == MBOX_STS_INTERMEDIATE_COMPLETION) ||
@@ -437,6 +441,12 @@ static void qla4xxx_isr_decode_mailbox(s
 	} else if (mbox_status >> 12 == MBOX_ASYNC_EVENT_STATUS) {
 		/* Immediately process the AENs that don't require much work.
 		 * Only queue the database_changed AENs */
+		if (ha->aen_log.count < MAX_AEN_ENTRIES) {
+			for (i = 0; i < MBOX_AEN_REG_COUNT; i++)
+				ha->aen_log.entry[ha->aen_log.count].mbox_sts[i] =
+					readl(&ha->reg->mailbox[i]);
+			ha->aen_log.count++;
+		}
 		switch (mbox_status) {
 		case MBOX_ASTS_SYSTEM_ERROR:
 			/* Log Mailbox registers */
@@ -493,6 +503,16 @@ static void qla4xxx_isr_decode_mailbox(s
 				      mbox_status));
 			break;
 
+		case MBOX_ASTS_IP_ADDR_STATE_CHANGED:
+			mbox_stat2 = readl(&ha->reg->mailbox[2]);
+			mbox_stat3 = readl(&ha->reg->mailbox[3]);
+
+			if ((mbox_stat3 == 5) && (mbox_stat2 == 3))
+				set_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags);
+			else if ((mbox_stat3 == 2) && (mbox_stat2 == 5))
+				set_bit(DPC_RESET_HA, &ha->dpc_flags);
+			break;
+
 		case MBOX_ASTS_MAC_ADDRESS_CHANGED:
 		case MBOX_ASTS_DNS:
 			/* No action */
@@ -518,11 +538,6 @@ static void qla4xxx_isr_decode_mailbox(s
 			/* Queue AEN information and process it in the DPC
 			 * routine */
 			if (ha->aen_q_count > 0) {
-				/* advance pointer */
-				if (ha->aen_in == (MAX_AEN_ENTRIES - 1))
-					ha->aen_in = 0;
-				else
-					ha->aen_in++;
 
 				/* decrement available counter */
 				ha->aen_q_count--;
@@ -542,6 +557,10 @@ static void qla4xxx_isr_decode_mailbox(s
 					      ha->aen_q[ha->aen_in].mbox_sts[2],
 					      ha->aen_q[ha->aen_in].mbox_sts[3],
 					      ha->aen_q[ha->aen_in].  mbox_sts[4]));
+				/* advance pointer */
+				ha->aen_in++;
+				if (ha->aen_in == MAX_AEN_ENTRIES)
+					ha->aen_in = 0;
 
 				/* The DPC routine will process the aen */
 				set_bit(DPC_AEN, &ha->dpc_flags);
@@ -724,25 +743,24 @@ void qla4xxx_process_aen(struct scsi_qla
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	while (ha->aen_out != ha->aen_in) {
-		/* Advance pointers for next entry */
-		if (ha->aen_out == (MAX_AEN_ENTRIES - 1))
-			ha->aen_out = 0;
-		else
-			ha->aen_out++;
-
-		ha->aen_q_count++;
 		aen = &ha->aen_q[ha->aen_out];
-
 		/* copy aen information to local structure */
 		for (i = 0; i < MBOX_AEN_REG_COUNT; i++)
 			mbox_sts[i] = aen->mbox_sts[i];
 
+		ha->aen_q_count++;
+		ha->aen_out++;
+
+		if (ha->aen_out == MAX_AEN_ENTRIES)
+			ha->aen_out = 0;
+
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		DEBUG(printk("scsi%ld: AEN[%d] %04x, index [%d] state=%04x "
-			     "mod=%x conerr=%08x \n", ha->host_no, ha->aen_out,
-			     mbox_sts[0], mbox_sts[2], mbox_sts[3],
-			     mbox_sts[1], mbox_sts[4]));
+		DEBUG2(printk("qla4xxx(%ld): AEN[%d]=0x%08x, mbx1=0x%08x mbx2=0x%08x"
+			" mbx3=0x%08x mbx4=0x%08x\n", ha->host_no,
+			(ha->aen_out ? (ha->aen_out-1): (MAX_AEN_ENTRIES-1)),
+			mbox_sts[0], mbox_sts[1], mbox_sts[2],
+			mbox_sts[3], mbox_sts[4]));
 
 		switch (mbox_sts[0]) {
 		case MBOX_ASTS_DATABASE_CHANGED:
@@ -792,6 +810,5 @@ void qla4xxx_process_aen(struct scsi_qla
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 }
 

