From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 12/14] xen-scsiback: Convert to TARGET_SCF_ACK_KREF I/O krefs
Date: Fri, 11 Mar 2016 06:30:08 +0000
Message-ID: <1457677810-2478-13-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>, David Vrabel <david.vrabel@citrix.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts xen-scsiback to modern TARGET_SCF_ACK_KREF
usage for scsiback_cmd_done() callback path.

It also also converts TMR -> scsiback_device_action() to use
modern target_submit_tmr() code.

Acked-by: Juergen Gross <jgross@suse.com>
Tested-by: Juergen Gross <jgross@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/xen/xen-scsiback.c | 56 +++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 3f379f7..652c8ce 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -388,6 +388,12 @@ static void scsiback_cmd_done(struct vscsibk_pend *pending_req)
 	scsiback_fast_flush_area(pending_req);
 	scsiback_do_resp_with_sense(sense_buffer, errors, resid, pending_req);
 	scsiback_put(info);
+	/*
+	 * Drop the extra KREF_ACK reference taken by target_submit_cmd_map_sgls()
+	 * ahead of scsiback_check_stop_free() ->  transport_generic_free_cmd()
+	 * final se_cmd->cmd_kref put.
+	 */
+	target_put_sess_cmd(&pending_req->se_cmd);
 }
 
 static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
@@ -401,7 +407,7 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
 	rc = target_submit_cmd_map_sgls(se_cmd, sess, pending_req->cmnd,
 			pending_req->sense_buffer, pending_req->v2p->lun,
 			pending_req->data_len, 0,
-			pending_req->sc_data_direction, 0,
+			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF,
 			pending_req->sgl, pending_req->n_sg,
 			NULL, 0, NULL, 0);
 	if (rc < 0) {
@@ -590,31 +596,28 @@ static void scsiback_disconnect(struct vscsibk_info *info)
 static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	enum tcm_tmreq_table act, int tag)
 {
-	int rc, err = FAILED;
 	struct scsiback_tpg *tpg = pending_req->v2p->tpg;
+	struct scsiback_nexus *nexus = tpg->tpg_nexus;
 	struct se_cmd *se_cmd = &pending_req->se_cmd;
 	struct scsiback_tmr *tmr;
+	u64 unpacked_lun = pending_req->v2p->lun;
+	int rc, err = FAILED;
 
 	tmr = kzalloc(sizeof(struct scsiback_tmr), GFP_KERNEL);
-	if (!tmr)
-		goto out;
+	if (!tmr) {
+		target_put_sess_cmd(se_cmd);
+		goto err;
+	}
 
 	init_waitqueue_head(&tmr->tmr_wait);
 
-	transport_init_se_cmd(se_cmd, tpg->se_tpg.se_tpg_tfo,
-		tpg->tpg_nexus->tvn_se_sess, 0, DMA_NONE, TCM_SIMPLE_TAG,
-		&pending_req->sense_buffer[0]);
-
-	rc = core_tmr_alloc_req(se_cmd, tmr, act, GFP_KERNEL);
-	if (rc < 0)
-		goto out;
-
-	se_cmd->se_tmr_req->ref_task_tag = tag;
-
-	if (transport_lookup_tmr_lun(se_cmd, pending_req->v2p->lun) < 0)
-		goto out;
+	rc = target_submit_tmr(&pending_req->se_cmd, nexus->tvn_se_sess,
+			       &pending_req->sense_buffer[0],
+			       unpacked_lun, tmr, act, GFP_KERNEL,
+			       tag, TARGET_SCF_ACK_KREF);
+	if (rc)
+		goto err;
 
-	transport_generic_handle_tmr(se_cmd);
 	wait_event(tmr->tmr_wait, atomic_read(&tmr->tmr_complete));
 
 	err = (se_cmd->se_tmr_req->response == TMR_FUNCTION_COMPLETE) ?
@@ -623,7 +626,7 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
 	transport_generic_free_cmd(&pending_req->se_cmd, 1);
 	return;
-out:
+err:
 	if (tmr)
 		kfree(tmr);
 	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
@@ -1368,21 +1371,18 @@ static u32 scsiback_tpg_get_inst_index(struct se_portal_group *se_tpg)
 
 static int scsiback_check_stop_free(struct se_cmd *se_cmd)
 {
-	/*
-	 * Do not release struct se_cmd's containing a valid TMR pointer.
-	 * These will be released directly in scsiback_device_action()
-	 * with transport_generic_free_cmd().
-	 */
-	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-		return 0;
-
-	transport_generic_free_cmd(se_cmd, 0);
-	return 1;
+	return transport_generic_free_cmd(se_cmd, 0);
 }
 
 static void scsiback_release_cmd(struct se_cmd *se_cmd)
 {
 	struct se_session *se_sess = se_cmd->se_sess;
+	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
+
+	if (se_tmr && se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
+		struct scsiback_tmr *tmr = se_tmr->fabric_tmr_ptr;
+		kfree(tmr);
+	}
 
 	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
-- 
1.9.1
