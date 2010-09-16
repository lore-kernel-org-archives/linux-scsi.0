From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 7/8] tcm_loop: Remove host_lock unlock() + lock() from tcm_loop_queuecommand()
Date: Thu, 16 Sep 2010 15:36:18 -0700
Message-ID: <1284676578-10873-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from tcm_loop_fabric_scsi.c:tcm_loop_queuecommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index b95ed03..a0a1a55 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -324,8 +324,6 @@ static int tcm_loop_queuecommand(
 		" scsi_buf_len: %u\n", sc->device->host->host_no,
 		sc->device->id, sc->device->channel, sc->device->lun,
 		sc->cmnd[0], scsi_bufflen(sc));
-
-	spin_unlock_irq(host->host_lock);
 	/*
 	 * Locate the tcm_loop_hba_t pointer 
 	 */
@@ -345,7 +343,6 @@ static int tcm_loop_queuecommand(
 	 */
 	se_cmd = tcm_loop_allocate_core_cmd(tl_hba, se_tpg, sc);
 	if (!(se_cmd)) {
-		spin_lock_irq(host->host_lock);
 		sc->result = host_byte(DID_ERROR);
 		(*done)(sc);
 		return 0;
@@ -354,10 +351,6 @@ static int tcm_loop_queuecommand(
 	 * Queue up the newly allocated to be processed in TCM thread context.
 	*/
 	se_cmd->transport_add_cmd_to_queue(se_cmd, TRANSPORT_NEW_CMD_MAP);
-	/*
-	 * Reaquire the the struct scsi_host->host_lock before returning
-	 */
-	spin_lock_irq(host->host_lock);
 	return 0;
 }
 
-- 
1.7.2.3
