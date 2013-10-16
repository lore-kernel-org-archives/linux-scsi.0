From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] tcm_loop: Implement target reset
Date: Wed, 16 Oct 2013 09:12:56 +0200
Message-ID: <1381907576-81857-6-git-send-email-hare@suse.de>
References: <1381907576-81857-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381907576-81857-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Implement target reset by resetting the transport status.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index febe166..d52c0aa 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -392,6 +392,32 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
+static int tcm_loop_target_reset(struct scsi_cmnd *sc)
+{
+	struct tcm_loop_hba *tl_hba;
+	struct tcm_loop_tpg *tl_tpg;
+	int ret = FAILED;
+
+	/*
+	 * Locate the tcm_loop_hba_t pointer
+	 */
+	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
+	if (!tl_hba) {
+		pr_err("Unable to perform device reset without"
+				" active I_T Nexus\n");
+		return FAILED;
+	}
+	/*
+	 * Locate the tl_tpg pointer from TargetID in sc->device->id
+	 */
+	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
+	if (tl_tpg) {
+		tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
+		return SUCCESS;
+	}
+	return FAILED;
+}
+
 static int tcm_loop_slave_alloc(struct scsi_device *sd)
 {
 	set_bit(QUEUE_FLAG_BIDI, &sd->request_queue->queue_flags);
@@ -421,6 +447,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.change_queue_type	= tcm_loop_change_queue_type,
 	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
+	.eh_target_reset_handler = tcm_loop_target_reset,
 	.can_queue		= 1024,
 	.this_id		= -1,
 	.sg_tablesize		= 256,
-- 
1.7.12.4
