From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/23] advansys: use host_reset
Date: Fri, 24 Apr 2015 13:18:20 +0200
Message-ID: <1429874322-85488-3-git-send-email-hare@suse.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965944AbbDXLSq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 07:18:46 -0400
In-Reply-To: <1429874322-85488-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The advansys_reset() function is actually a host reset, not a
bus reset. And there is no need to have a 'last_reset'
value; the same value exists in struct Scsi_Host.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ae95e34..e936f48 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2366,7 +2366,6 @@ struct asc_board {
 		ADVEEP_38C0800_CONFIG adv_38C0800_eep;	/* 38C0800 EEPROM config. */
 		ADVEEP_38C1600_CONFIG adv_38C1600_eep;	/* 38C1600 EEPROM config. */
 	} eep_config;
-	ulong last_reset;	/* Saved last reset time */
 	/* /proc/scsi/advansys/[0...] */
 #ifdef ADVANSYS_STATS
 	struct asc_stats asc_stats;	/* Board statistics */
@@ -3350,7 +3349,7 @@ static void asc_prt_driver_conf(struct seq_file *m, struct Scsi_Host *shost)
 
 	seq_printf(m,
 		   " flags 0x%x, last_reset 0x%lx, jiffies 0x%lx, asc_n_io_port 0x%x\n",
-		   boardp->flags, boardp->last_reset, jiffies,
+		   boardp->flags, shost->last_reset, jiffies,
 		   boardp->asc_n_io_port);
 
 	seq_printf(m, " io_port 0x%lx\n", shost->io_port);
@@ -7453,7 +7452,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 /*
  * advansys_reset()
  *
- * Reset the bus associated with the command 'scp'.
+ * Reset the host associated with the command 'scp'.
  *
  * This function runs its own thread. Interrupts must be blocked but
  * sleeping is allowed and no locking other than for host structures is
@@ -7471,7 +7470,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 
 	ASC_STATS(shost, reset);
 
-	scmd_printk(KERN_INFO, scp, "SCSI bus reset started...\n");
+	scmd_printk(KERN_INFO, scp, "SCSI host reset started...\n");
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
@@ -7482,20 +7481,19 @@ static int advansys_reset(struct scsi_cmnd *scp)
 
 		/* Refer to ASC_IERR_* definitions for meaning of 'err_code'. */
 		if (asc_dvc->err_code || !asc_dvc->overrun_dma) {
-			scmd_printk(KERN_INFO, scp, "SCSI bus reset error: "
+			scmd_printk(KERN_INFO, scp, "SCSI host reset error: "
 				    "0x%x, status: 0x%x\n", asc_dvc->err_code,
 				    status);
 			ret = FAILED;
 		} else if (status) {
-			scmd_printk(KERN_INFO, scp, "SCSI bus reset warning: "
+			scmd_printk(KERN_INFO, scp, "SCSI host reset warning: "
 				    "0x%x\n", status);
 		} else {
-			scmd_printk(KERN_INFO, scp, "SCSI bus reset "
+			scmd_printk(KERN_INFO, scp, "SCSI host reset "
 				    "successful\n");
 		}
 
 		ASC_DBG(1, "after AscInitAsc1000Driver()\n");
-		spin_lock_irqsave(shost->host_lock, flags);
 	} else {
 		/*
 		 * If the suggest reset bus flags are set, then reset the bus.
@@ -7504,28 +7502,25 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		ADV_DVC_VAR *adv_dvc = &boardp->dvc_var.adv_dvc_var;
 
 		/*
-		 * Reset the target's SCSI bus.
+		 * Reset the chip and SCSI bus.
 		 */
 		ASC_DBG(1, "before AdvResetChipAndSB()\n");
 		switch (AdvResetChipAndSB(adv_dvc)) {
 		case ASC_TRUE:
-			scmd_printk(KERN_INFO, scp, "SCSI bus reset "
+			scmd_printk(KERN_INFO, scp, "SCSI host reset "
 				    "successful\n");
 			break;
 		case ASC_FALSE:
 		default:
-			scmd_printk(KERN_INFO, scp, "SCSI bus reset error\n");
+			scmd_printk(KERN_INFO, scp, "SCSI host reset error\n");
 			ret = FAILED;
 			break;
 		}
 		spin_lock_irqsave(shost->host_lock, flags);
 		AdvISR(adv_dvc);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
-	/* Save the time of the most recently completed reset. */
-	boardp->last_reset = jiffies;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
 	ASC_DBG(1, "ret %d\n", ret);
 
 	return ret;
@@ -11232,7 +11227,7 @@ static struct scsi_host_template advansys_template = {
 	.name = DRV_NAME,
 	.info = advansys_info,
 	.queuecommand = advansys_queuecommand,
-	.eh_bus_reset_handler = advansys_reset,
+	.eh_host_reset_handler = advansys_reset,
 	.bios_param = advansys_biosparam,
 	.slave_configure = advansys_slave_configure,
 	/*
-- 
1.8.5.2

