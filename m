From: gurinder.shergill@hp.com
Subject: [PATCH] qla2xxx: Fix for locking issue between driver ISR and mailbox routines
Date: Fri, 12 Apr 2013 11:17:22 -0700
Message-ID: <1365790642-32379-1-git-send-email-gurinder.shergill@hp.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:17245 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3DMCVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Apr 2013 22:21:39 -0400
Received: from g5t0030.atlanta.hp.com (g5t0030.atlanta.hp.com [16.228.8.142])
	by g5t0007.atlanta.hp.com (Postfix) with ESMTP id A09401408C
	for <linux-scsi@vger.kernel.org>; Sat, 13 Apr 2013 02:21:38 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Gurinder (Sunny) Shergill" <gurinder.shergill@hp.com>

The qla2xxx driver uses ha->mbx_cmd_flags variable to pass information between
its ISR and mailbox routines, however, it does so without the protection of
any locks.  Under certain conditions, this can lead to multiple mailbox
command completions being signaled, which, in turn, leads to a false mailbox
timeout error for the subsequently issued mailbox command.

The issue occurs frequently but intermittenly with the Qlogic 8GFC mezz
card during initialization, resulting in initialization failure.

Signed-off-by: Gurinder (Sunny) Shergill <gurinder.shergill@hp.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 25 +++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_mbx.c |  2 --
 drivers/scsi/qla2xxx/qla_mr.c  |  9 ++++++---
 drivers/scsi/qla2xxx/qla_nx.c  | 28 ++++++++++++++++++++++------
 4 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 259d920..b757ee3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -104,14 +104,18 @@ qla2100_intr_handler(int irq, void *dev_id)
 			RD_REG_WORD(&reg->hccr);
 		}
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 		complete(&ha->mbx_intr_comp);
+		return IRQ_HANDLED;
 	}
 
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (IRQ_HANDLED);
 }
 
@@ -221,14 +225,18 @@ qla2300_intr_handler(int irq, void *dev_id)
 		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 		RD_REG_WORD_RELAXED(&reg->hccr);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 		complete(&ha->mbx_intr_comp);
+		return IRQ_HANDLED;
 	}
 
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (IRQ_HANDLED);
 }
 
@@ -2613,14 +2621,18 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		if (unlikely(IS_QLA83XX(ha) && (ha->pdev->revision == 1)))
 			ndelay(3500);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 		complete(&ha->mbx_intr_comp);
+		return IRQ_HANDLED;
 	}
 
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -2763,13 +2775,18 @@ qla24xx_msix_default(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 		complete(&ha->mbx_intr_comp);
+		return IRQ_HANDLED;
 	}
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9e5d89d..3587ec2 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -179,8 +179,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 		wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
 
-		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
-
 	} else {
 		ql_dbg(ql_dbg_mbx, vha, 0x1011,
 		    "Cmd=%x Polling Mode.\n", command);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 729b743..0ab020c 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -149,8 +149,6 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct mbx_cmd_32 *mcp)
 
 		wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
 
-		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
-
 	} else {
 		ql_dbg(ql_dbg_mbx, vha, 0x112c,
 		    "Cmd=%x Polling Mode.\n", command);
@@ -2934,13 +2932,18 @@ qlafx00_intr_handler(int irq, void *dev_id)
 		QLAFX00_CLR_INTR_REG(ha, clr_intr);
 		QLAFX00_RD_INTR_REG(ha);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 		complete(&ha->mbx_intr_comp);
+		return IRQ_HANDLED;
 	}
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 10754f51..c8e8407 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2074,9 +2074,6 @@ qla82xx_intr_handler(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->host_int, 0);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	if (!ha->flags.msi_enabled)
-		qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
 
 #ifdef QL_DEBUG_LEVEL_17
 	if (!irq && ha->flags.eeh_busy)
@@ -2088,8 +2085,21 @@ qla82xx_intr_handler(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 		set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		if (!ha->flags.msi_enabled)
+			qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
+
 		complete(&ha->mbx_intr_comp);
+		return IRQ_HANDLED;
 	}
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (!ha->flags.msi_enabled)
+		qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
+
 	return IRQ_HANDLED;
 }
 
@@ -2149,8 +2159,6 @@ qla82xx_msix_default(int irq, void *dev_id)
 		WRT_REG_DWORD(&reg->host_int, 0);
 	} while (0);
 
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 #ifdef QL_DEBUG_LEVEL_17
 	if (!irq && ha->flags.eeh_busy)
 		ql_log(ql_log_warn, vha, 0x5044,
@@ -2161,8 +2169,14 @@ qla82xx_msix_default(int irq, void *dev_id)
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 		(status & MBX_INTERRUPT) && ha->flags.mbox_int) {
 			set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 			complete(&ha->mbx_intr_comp);
+			return IRQ_HANDLED;
 	}
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -3345,8 +3359,10 @@ void qla82xx_clear_pending_mbx(scsi_qla_host_t *vha)
 		ha->flags.mbox_busy = 0;
 		ql_log(ql_log_warn, vha, 0x6010,
 		    "Doing premature completion of mbx command.\n");
-		if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags))
+		if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags)) {
+			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 			complete(&ha->mbx_intr_comp);
+		}
 	}
 }
 
-- 
1.7.11.7

