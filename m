From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v4 13/19] fnic: Remove host_lock unlock() + lock() from fnic_queuecommand()
Date: Mon, 27 Sep 2010 19:07:21 -0700
Message-ID: <1285639641-7465-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
fnic_scsi.c:fnic_queuecommand().  This also includes setting the
SHT->unlocked_qcmd=1 for host_lock less fnic fnic_queuecommand operation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/fnic/fnic_main.c |    1 +
 drivers/scsi/fnic/fnic_scsi.c |    9 ---------
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 9eb7a9e..2537814 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -104,6 +104,7 @@ static struct scsi_host_template fnic_host_template = {
 	.slave_alloc = fnic_slave_alloc,
 	.change_queue_depth = fc_change_queue_depth,
 	.change_queue_type = fc_change_queue_type,
+	.unlocked_qcmd = 1,
 	.this_id = -1,
 	.cmd_per_lun = 3,
 	.can_queue = FNIC_MAX_IO_REQ,
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 198cbab..7cf3372 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -373,13 +373,6 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
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
 
@@ -452,8 +445,6 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		}
 	}
 out:
-	/* acquire host lock before returning to SCSI */
-	spin_lock(lp->host->host_lock);
 	return ret;
 }
 
-- 
1.7.3
