From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 07/11] fnic: Convert to host_lock less w/ interrupts disabled externally
Date: Wed, 17 Nov 2010 14:19:18 -0800
Message-ID: <1290032358-4979-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.230]:21752 "HELO
	nm8-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933707Ab0KQWTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 17:19:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts fnic to run in host_lock less mode with the new
IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling ->queuecommand()
dispatch.  It also drops the legacy host_lock unlock optimization.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/fnic/fnic_scsi.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 22d0240..9f51beb 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -349,7 +349,8 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
  * Routine to send a scsi cdb
  * Called with host_lock held and interrupts disabled.
  */
-static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
+static int fnic_queuecommand_irq_disable(struct scsi_cmnd *sc,
+					void (*done)(struct scsi_cmnd *))
 {
 	struct fc_lport *lp;
 	struct fc_rport *rport;
@@ -373,13 +374,6 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	/*
-	 * Release host lock, use driver resource specific locks from here.
-	 * Don't re-enable interrupts in case they were disabled prior to the
-	 * caller disabling them.
-	 */
-	spin_unlock(lp->host->host_lock);
-
 	/* Get a new io_req for this SCSI IO */
 	fnic = lport_priv(lp);
 
@@ -452,12 +446,10 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 		}
 	}
 out:
-	/* acquire host lock before returning to SCSI */
-	spin_lock(lp->host->host_lock);
 	return ret;
 }
 
-DEF_SCSI_QCMD(fnic_queuecommand)
+IRQ_DISABLE_SCSI_QCMD(fnic_queuecommand)
 
 /*
  * fnic_fcpio_fw_reset_cmpl_handler
-- 
1.7.2.3

