From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 11/14] xen-scsiback: Convert to percpu_ida tag allocation
Date: Fri, 11 Mar 2016 06:30:07 +0000
Message-ID: <1457677810-2478-12-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>, David Vrabel <david.vrabel@citrix.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts xen-scsiback to use percpu_ida tag
pre-allocation for struct vscsibk_pend descriptor, in
order to avoid fast-path struct vscsibk_pend memory
allocations.

Note by default this is currently hardcoded to 128.

(Add wrapper for handling pending_req tag failure - Juergen)
(Drop left-over se_cmd memset in scsiback_cmd_exec - Juergen)

Acked-by: Juergen Gross <jgross@suse.com>
Tested-by: Juergen Gross <jgross@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/xen/xen-scsiback.c | 167 ++++++++++++++++++++++++---------------------
 1 file changed, 89 insertions(+), 78 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 077993f..3f379f7 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -141,6 +141,8 @@ struct scsiback_tmr {
 	wait_queue_head_t tmr_wait;
 };
 
+#define VSCSI_DEFAULT_SESSION_TAGS	128
+
 struct scsiback_nexus {
 	/* Pointer to TCM session for I_T Nexus */
 	struct se_session *tvn_se_sess;
@@ -190,7 +192,6 @@ module_param_named(max_buffer_pages, scsiback_max_buffer_pages, int, 0644);
 MODULE_PARM_DESC(max_buffer_pages,
 "Maximum number of free pages to keep in backend buffer");
 
-static struct kmem_cache *scsiback_cachep;
 static DEFINE_SPINLOCK(free_pages_lock);
 static int free_pages_num;
 static LIST_HEAD(scsiback_free_pages);
@@ -321,11 +322,11 @@ static void scsiback_free_translation_entry(struct kref *kref)
 	kfree(entry);
 }
 
-static void scsiback_do_resp_with_sense(char *sense_buffer, int32_t result,
-			uint32_t resid, struct vscsibk_pend *pending_req)
+static void scsiback_send_response(struct vscsibk_info *info,
+			char *sense_buffer, int32_t result, uint32_t resid,
+			uint16_t rqid)
 {
 	struct vscsiif_response *ring_res;
-	struct vscsibk_info *info = pending_req->info;
 	int notify;
 	struct scsi_sense_hdr sshdr;
 	unsigned long flags;
@@ -337,7 +338,7 @@ static void scsiback_do_resp_with_sense(char *sense_buffer, int32_t result,
 	info->ring.rsp_prod_pvt++;
 
 	ring_res->rslt   = result;
-	ring_res->rqid   = pending_req->rqid;
+	ring_res->rqid   = rqid;
 
 	if (sense_buffer != NULL &&
 	    scsi_normalize_sense(sense_buffer, VSCSIIF_SENSE_BUFFERSIZE,
@@ -357,6 +358,13 @@ static void scsiback_do_resp_with_sense(char *sense_buffer, int32_t result,
 
 	if (notify)
 		notify_remote_via_irq(info->irq);
+}
+
+static void scsiback_do_resp_with_sense(char *sense_buffer, int32_t result,
+			uint32_t resid, struct vscsibk_pend *pending_req)
+{
+	scsiback_send_response(pending_req->info, sense_buffer, result,
+			       resid, pending_req->rqid);
 
 	if (pending_req->v2p)
 		kref_put(&pending_req->v2p->kref,
@@ -388,10 +396,6 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
 	struct se_session *sess = pending_req->v2p->tpg->tpg_nexus->tvn_se_sess;
 	int rc;
 
-	memset(pending_req->sense_buffer, 0, VSCSIIF_SENSE_BUFFERSIZE);
-
-	memset(se_cmd, 0, sizeof(*se_cmd));
-
 	scsiback_get(pending_req->info);
 	se_cmd->tag = pending_req->rqid;
 	rc = target_submit_cmd_map_sgls(se_cmd, sess, pending_req->cmnd,
@@ -616,15 +620,13 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	err = (se_cmd->se_tmr_req->response == TMR_FUNCTION_COMPLETE) ?
 		SUCCESS : FAILED;
 
+	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
+	transport_generic_free_cmd(&pending_req->se_cmd, 1);
+	return;
 out:
-	if (tmr) {
-		transport_generic_free_cmd(&pending_req->se_cmd, 1);
+	if (tmr)
 		kfree(tmr);
-	}
-
 	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
-
-	kmem_cache_free(scsiback_cachep, pending_req);
 }
 
 /*
@@ -653,15 +655,53 @@ out:
 	return entry;
 }
 
-static int prepare_pending_reqs(struct vscsibk_info *info,
-				struct vscsiif_request *ring_req,
-				struct vscsibk_pend *pending_req)
+static struct vscsibk_pend *scsiback_get_pend_req(struct vscsiif_back_ring *ring,
+				struct v2p_entry *v2p)
+{
+	struct scsiback_tpg *tpg = v2p->tpg;
+	struct scsiback_nexus *nexus = tpg->tpg_nexus;
+	struct se_session *se_sess = nexus->tvn_se_sess;
+	struct vscsibk_pend *req;
+	int tag, i;
+
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	if (tag < 0) {
+		pr_err("Unable to obtain tag for vscsiif_request\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	req = &((struct vscsibk_pend *)se_sess->sess_cmd_map)[tag];
+	memset(req, 0, sizeof(*req));
+	req->se_cmd.map_tag = tag;
+
+	for (i = 0; i < VSCSI_MAX_GRANTS; i++)
+		req->grant_handles[i] = SCSIBACK_INVALID_HANDLE;
+
+	return req;
+}
+
+static struct vscsibk_pend *prepare_pending_reqs(struct vscsibk_info *info,
+				struct vscsiif_back_ring *ring,
+				struct vscsiif_request *ring_req)
 {
+	struct vscsibk_pend *pending_req;
 	struct v2p_entry *v2p;
 	struct ids_tuple vir;
 
-	pending_req->rqid       = ring_req->rqid;
-	pending_req->info       = info;
+	/* request range check from frontend */
+	if ((ring_req->sc_data_direction != DMA_BIDIRECTIONAL) &&
+		(ring_req->sc_data_direction != DMA_TO_DEVICE) &&
+		(ring_req->sc_data_direction != DMA_FROM_DEVICE) &&
+		(ring_req->sc_data_direction != DMA_NONE)) {
+		pr_debug("invalid parameter data_dir = %d\n",
+			ring_req->sc_data_direction);
+		return ERR_PTR(-EINVAL);
+	}
+	if (ring_req->cmd_len > VSCSIIF_MAX_COMMAND_SIZE) {
+		pr_debug("invalid parameter cmd_len = %d\n",
+			ring_req->cmd_len);
+		return ERR_PTR(-EINVAL);
+	}
 
 	vir.chn = ring_req->channel;
 	vir.tgt = ring_req->id;
@@ -669,33 +709,24 @@ static int prepare_pending_reqs(struct vscsibk_info *info,
 
 	v2p = scsiback_do_translation(info, &vir);
 	if (!v2p) {
-		pending_req->v2p = NULL;
 		pr_debug("the v2p of (chn:%d, tgt:%d, lun:%d) doesn't exist.\n",
-			vir.chn, vir.tgt, vir.lun);
-		return -ENODEV;
+			 vir.chn, vir.tgt, vir.lun);
+		return ERR_PTR(-ENODEV);
 	}
-	pending_req->v2p = v2p;
 
-	/* request range check from frontend */
-	pending_req->sc_data_direction = ring_req->sc_data_direction;
-	if ((pending_req->sc_data_direction != DMA_BIDIRECTIONAL) &&
-		(pending_req->sc_data_direction != DMA_TO_DEVICE) &&
-		(pending_req->sc_data_direction != DMA_FROM_DEVICE) &&
-		(pending_req->sc_data_direction != DMA_NONE)) {
-		pr_debug("invalid parameter data_dir = %d\n",
-			pending_req->sc_data_direction);
-		return -EINVAL;
+	pending_req = scsiback_get_pend_req(ring, v2p);
+	if (IS_ERR(pending_req)) {
+		kref_put(&v2p->kref, scsiback_free_translation_entry);
+		return ERR_PTR(-ENOMEM);
 	}
-
+	pending_req->rqid = ring_req->rqid;
+	pending_req->info = info;
+	pending_req->v2p = v2p;
+	pending_req->sc_data_direction = ring_req->sc_data_direction;
 	pending_req->cmd_len = ring_req->cmd_len;
-	if (pending_req->cmd_len > VSCSIIF_MAX_COMMAND_SIZE) {
-		pr_debug("invalid parameter cmd_len = %d\n",
-			pending_req->cmd_len);
-		return -EINVAL;
-	}
 	memcpy(pending_req->cmnd, ring_req->cmnd, pending_req->cmd_len);
 
-	return 0;
+	return pending_req;
 }
 
 static int scsiback_do_cmd_fn(struct vscsibk_info *info)
@@ -704,7 +735,7 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 	struct vscsiif_request ring_req;
 	struct vscsibk_pend *pending_req;
 	RING_IDX rc, rp;
-	int err, more_to_do;
+	int more_to_do;
 	uint32_t result;
 
 	rc = ring->req_cons;
@@ -722,16 +753,13 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 	while ((rc != rp)) {
 		if (RING_REQUEST_CONS_OVERFLOW(ring, rc))
 			break;
-		pending_req = kmem_cache_alloc(scsiback_cachep, GFP_KERNEL);
-		if (!pending_req)
-			return 1;
 
 		RING_COPY_REQUEST(ring, rc, &ring_req);
 		ring->req_cons = ++rc;
 
-		err = prepare_pending_reqs(info, &ring_req, pending_req);
-		if (err) {
-			switch (err) {
+		pending_req = prepare_pending_reqs(info, ring, &ring_req);
+		if (IS_ERR(pending_req)) {
+			switch (PTR_ERR(pending_req)) {
 			case -ENODEV:
 				result = DID_NO_CONNECT;
 				break;
@@ -739,9 +767,8 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 				result = DRIVER_ERROR;
 				break;
 			}
-			scsiback_do_resp_with_sense(NULL, result << 24, 0,
-						    pending_req);
-			kmem_cache_free(scsiback_cachep, pending_req);
+			scsiback_send_response(info, NULL, result << 24, 0,
+					       ring_req.rqid);
 			return 1;
 		}
 
@@ -750,8 +777,8 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 			if (scsiback_gnttab_data_map(&ring_req, pending_req)) {
 				scsiback_fast_flush_area(pending_req);
 				scsiback_do_resp_with_sense(NULL,
-					DRIVER_ERROR << 24, 0, pending_req);
-				kmem_cache_free(scsiback_cachep, pending_req);
+						DRIVER_ERROR << 24, 0, pending_req);
+				transport_generic_free_cmd(&pending_req->se_cmd, 0);
 			} else {
 				scsiback_cmd_exec(pending_req);
 			}
@@ -765,9 +792,9 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info)
 			break;
 		default:
 			pr_err_ratelimited("invalid request\n");
-			scsiback_do_resp_with_sense(NULL, DRIVER_ERROR << 24,
-						    0, pending_req);
-			kmem_cache_free(scsiback_cachep, pending_req);
+			scsiback_do_resp_with_sense(NULL, DRIVER_ERROR << 24, 0,
+						    pending_req);
+			transport_generic_free_cmd(&pending_req->se_cmd, 0);
 			break;
 		}
 
@@ -1355,10 +1382,9 @@ static int scsiback_check_stop_free(struct se_cmd *se_cmd)
 
 static void scsiback_release_cmd(struct se_cmd *se_cmd)
 {
-	struct vscsibk_pend *pending_req = container_of(se_cmd,
-				struct vscsibk_pend, se_cmd);
+	struct se_session *se_sess = se_cmd->se_sess;
 
-	kmem_cache_free(scsiback_cachep, pending_req);
+	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 
 static int scsiback_shutdown_session(struct se_session *se_sess)
@@ -1511,7 +1537,9 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 		goto out_unlock;
 	}
 
-	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg, 0, 0,
+	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg,
+						     VSCSI_DEFAULT_SESSION_TAGS,
+						     sizeof(struct vscsibk_pend),
 						     TARGET_PROT_NORMAL, name,
 						     tv_nexus, scsiback_alloc_sess_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
@@ -1840,16 +1868,6 @@ static struct xenbus_driver scsiback_driver = {
 	.otherend_changed	= scsiback_frontend_changed
 };
 
-static void scsiback_init_pend(void *p)
-{
-	struct vscsibk_pend *pend = p;
-	int i;
-
-	memset(pend, 0, sizeof(*pend));
-	for (i = 0; i < VSCSI_MAX_GRANTS; i++)
-		pend->grant_handles[i] = SCSIBACK_INVALID_HANDLE;
-}
-
 static int __init scsiback_init(void)
 {
 	int ret;
@@ -1860,14 +1878,9 @@ static int __init scsiback_init(void)
 	pr_debug("xen-pvscsi: fabric module %s on %s/%s on "UTS_RELEASE"\n",
 		 VSCSI_VERSION, utsname()->sysname, utsname()->machine);
 
-	scsiback_cachep = kmem_cache_create("vscsiif_cache",
-		sizeof(struct vscsibk_pend), 0, 0, scsiback_init_pend);
-	if (!scsiback_cachep)
-		return -ENOMEM;
-
 	ret = xenbus_register_backend(&scsiback_driver);
 	if (ret)
-		goto out_cache_destroy;
+		goto out;
 
 	ret = target_register_template(&scsiback_ops);
 	if (ret)
@@ -1877,8 +1890,7 @@ static int __init scsiback_init(void)
 
 out_unregister_xenbus:
 	xenbus_unregister_driver(&scsiback_driver);
-out_cache_destroy:
-	kmem_cache_destroy(scsiback_cachep);
+out:
 	pr_err("%s: error %d\n", __func__, ret);
 	return ret;
 }
@@ -1894,7 +1906,6 @@ static void __exit scsiback_exit(void)
 	}
 	target_unregister_template(&scsiback_ops);
 	xenbus_unregister_driver(&scsiback_driver);
-	kmem_cache_destroy(scsiback_cachep);
 }
 
 module_init(scsiback_init);
-- 
1.9.1
