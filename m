From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 04/16] scsi: qla1280: Add missing destroy_timer_on_stack()
Date: Sun, 23 Mar 2014 15:09:26 -0000
Message-ID: <20140323150752.960739079@linutronix.de>
References: <20140323150557.288925975@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=scsi-qla1280-add-missing-destroy-timer-on-stack.patch
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Andrew Morton <akpm@linux-foundation.org>, Michael Reed <mdr@sgi.com>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Otherwise we leak a tracking object when DEBUG_OBJECTS is enabled.

This code should use wait_for_completion_timeout() instead, but that's
a different issue.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Reed <mdr@sgi.com>
Cc: scsi <linux-scsi@vger.kernel.org>
---
 drivers/scsi/qla1280.c |    1 +
 1 file changed, 1 insertion(+)

Index: tip/drivers/scsi/qla1280.c
===================================================================
--- tip.orig/drivers/scsi/qla1280.c
+++ tip/drivers/scsi/qla1280.c
@@ -2514,6 +2514,7 @@ qla1280_mailbox_command(struct scsi_qla_
 
 	wait_for_completion(&wait);
 	del_timer_sync(&timer);
+	destroy_timer_on_stack(&timer);
 
 	spin_lock_irq(ha->host->host_lock);
 
