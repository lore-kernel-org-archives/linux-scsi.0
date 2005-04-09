From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/qla2xxx/qla_os.c: remove dead code
Date: Sun, 10 Apr 2005 01:06:17 +0200
Message-ID: <20050409230617.GQ3632@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:61190 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261411AbVDIXGV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Apr 2005 19:06:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch removes some dead code found by the Coverity checker (rval 
can't be FAILED at the time of this check).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.12-rc2-mm2-full/drivers/scsi/qla2xxx/qla_os.c.old	2005-04-09 22:24:09.000000000 +0200
+++ linux-2.6.12-rc2-mm2-full/drivers/scsi/qla2xxx/qla_os.c	2005-04-09 22:49:01.000000000 +0200
@@ -1649,14 +1649,11 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 	clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 
 	spin_lock_irq(ha->host->host_lock);
-	if (rval == FAILED)
-		goto out;
 
 	/* Waiting for our command in done_queue to be returned to OS.*/
 	if (!qla2x00_eh_wait_for_pending_commands(ha))
 		rval = FAILED;
 
- out:
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
 			(rval == FAILED) ? "failed" : "succeded");
 

