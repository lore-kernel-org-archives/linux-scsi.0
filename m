From: Anton Blanchard <anton@samba.org>
Subject: sym2 error handler sleeps with irqs off
Date: Fri, 11 Jul 2003 16:20:46 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030711062045.GA9236@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:58546 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S266608AbTGKGIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2003 02:08:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

The scsi error handler calls driver error handlers with the host_lock
taken. We need to drop it before calling down() in the sym2 driver.

Anton

===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.13 vs edited =====
--- 1.13/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Feb  7 19:20:34 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Feb 13 00:00:21 2003
@@ -1112,6 +1112,7 @@
 	int sts = -1;
 	struct sym_eh_wait eh, *ep = &eh;
 	char devname[20];
+	unsigned long flags;
 
 	sprintf(devname, "%s:%d:%d", sym_name(np), cmd->device->id, cmd->device->lun);
 
@@ -1203,7 +1204,11 @@
 		ep->timer.data = (u_long)cmd;
 		ep->timed_out = 1;	/* Be pessimistic for once :) */
 		add_timer(&ep->timer);
+		local_save_flags(flags);
+		spin_unlock_irq(cmd->device->host->host_lock);
 		down(&ep->sem);
+		local_irq_restore(flags);
+		spin_lock(cmd->device->host->host_lock);
 		if (ep->timed_out)
 			sts = -2;
 	}
