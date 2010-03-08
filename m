From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] [TCM]: Release legacy SPC-2 reservation during TMR LUN_RESET
Date: Mon,  8 Mar 2010 11:51:13 -0800
Message-ID: <1268077873-19780-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:33925 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755533Ab0CHTvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 14:51:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates core_tmr_lun_reset() to properly release any legacy SPC-2 reservations
when a TMR LUN_RESET has been received.  This only applys to legacy SPC-2 reservations,
as >= SPC-3 persistent reservations is not effected by TMR LUN_RESET.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 366c2f4..3cc2bf0 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -383,6 +383,18 @@ int core_tmr_lun_reset(
 		spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
 	}
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
+	/*
+	 * Clear any legacy SPC-2 reservation when called during
+	 * LOGICAL UNIT RESET
+	 */
+	if (!(preempt_and_abort_list) &&
+	     (dev->dev_flags & DF_SPC2_RESERVATIONS)) {
+		spin_lock(&dev->dev_reservation_lock);
+		dev->dev_reserved_node_acl = NULL;
+		dev->dev_flags &= ~DF_SPC2_RESERVATIONS;
+		spin_unlock(&dev->dev_reservation_lock);
+		printk(KERN_INFO "LUN_RESET: SCSI-2 Released reservation\n");	
+	}	
 
 #ifdef SNMP_SUPPORT
 	spin_lock(&dev->stats_lock);
-- 
1.5.6.5

