From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm_loop: Drop legacy host_lock usage in SHT->queuecommand() caller
Date: Thu, 11 Nov 2010 02:25:23 -0800
Message-ID: <1289471123-29097-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Following the the great host lock push-down in 3039f3ffcc5, this patch drops
the historical optimization (and most certain deadlock) of:

	 spin_unlock_irq(host_lock); do_some_lld_work(); spin_lock_irq(host_lock)

from within tcm_loop_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 80f2940..8175681 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -311,7 +311,6 @@ static int tcm_loop_queuecommand(
 {
 	struct se_cmd *se_cmd;
 	struct se_portal_group *se_tpg;
-	struct Scsi_Host *host = sc->device->host;
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
 
@@ -321,8 +320,6 @@ static int tcm_loop_queuecommand(
 		" scsi_buf_len: %u\n", sc->device->host->host_no,
 		sc->device->id, sc->device->channel, sc->device->lun,
 		sc->cmnd[0], scsi_bufflen(sc));
-
-	spin_unlock_irq(host->host_lock);
 	/*
 	 * Locate the tcm_loop_hba_t pointer 
 	 */
@@ -342,7 +339,6 @@ static int tcm_loop_queuecommand(
 	 */
 	se_cmd = tcm_loop_allocate_core_cmd(tl_hba, se_tpg, sc);
 	if (!(se_cmd)) {
-		spin_lock_irq(host->host_lock);
 		sc->result = host_byte(DID_ERROR);
 		(*done)(sc);
 		return 0;
@@ -351,10 +347,6 @@ static int tcm_loop_queuecommand(
 	 * Queue up the newly allocated to be processed in TCM thread context.
 	*/
 	transport_generic_handle_cdb_map(se_cmd);
-	/*
-	 * Reaquire the the struct scsi_host->host_lock before returning
-	 */
-	spin_lock_irq(host->host_lock);
 	return 0;
 }
 
-- 
1.5.6.5
