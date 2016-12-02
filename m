From: Juergen Gross <jgross@suse.com>
Subject: [PATCH v2] xen/scsifront: don't request a slot on the ring until request is ready
Date: Fri,  2 Dec 2016 07:10:54 +0100
Message-ID: <20161202061054.14402-1-jgross@suse.com>
References: <20161125202650.GK6266@mwanda>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161125202650.GK6266@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, lambert.quentin@gmail.com, linux-scsi@vger.kernel.org, dan.carpenter@oracle.com, jejb@linux.vnet.ibm.com, martin.peter^Cn@oracle.com, Juergen Gross <jgross@suse.com>
List-Id: linux-scsi@vger.kernel.org

Instead of requesting a new slot on the ring to the backend early, do
so only after all has been setup for the request to be sent. This
makes error handling easier as we don't need to undo the request id
allocation and ring slot allocation.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/xen-scsifront.c | 190 +++++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 106 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index c01316c..9aa1fe1 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -79,10 +79,13 @@
 struct vscsifrnt_shadow {
 	/* command between backend and frontend */
 	unsigned char act;
+	uint8_t nr_segments;
 	uint16_t rqid;
+	uint16_t ref_rqid;
 
 	unsigned int nr_grants;		/* number of grants in gref[] */
 	struct scsiif_request_segment *sg;	/* scatter/gather elements */
+	struct scsiif_request_segment seg[VSCSIIF_SG_TABLESIZE];
 
 	/* Do reset or abort function. */
 	wait_queue_head_t wq_reset;	/* reset work queue           */
@@ -172,68 +175,90 @@ static void scsifront_put_rqid(struct vscsifrnt_info *info, uint32_t id)
 		scsifront_wake_up(info);
 }
 
-static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
+static int scsifront_do_request(struct vscsifrnt_info *info,
+				struct vscsifrnt_shadow *shadow)
 {
 	struct vscsiif_front_ring *ring = &(info->ring);
 	struct vscsiif_request *ring_req;
+	struct scsi_cmnd *sc = shadow->sc;
 	uint32_t id;
+	int i, notify;
+
+	if (RING_FULL(&info->ring))
+		return -EBUSY;
 
 	id = scsifront_get_rqid(info);	/* use id in response */
 	if (id >= VSCSIIF_MAX_REQS)
-		return NULL;
+		return -EBUSY;
+
+	info->shadow[id] = shadow;
+	shadow->rqid = id;
 
 	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
-
 	ring->req_prod_pvt++;
 
-	ring_req->rqid = (uint16_t)id;
+	ring_req->rqid        = id;
+	ring_req->act         = shadow->act;
+	ring_req->ref_rqid    = shadow->ref_rqid;
+	ring_req->nr_segments = shadow->nr_segments;
 
-	return ring_req;
-}
+	ring_req->id      = sc->device->id;
+	ring_req->lun     = sc->device->lun;
+	ring_req->channel = sc->device->channel;
+	ring_req->cmd_len = sc->cmd_len;
 
-static void scsifront_do_request(struct vscsifrnt_info *info)
-{
-	struct vscsiif_front_ring *ring = &(info->ring);
-	int notify;
+	BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
+
+	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
+
+	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
+	ring_req->timeout_per_command = sc->request->timeout / HZ;
+
+	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
+		ring_req->seg[i] = shadow->seg[i];
 
 	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(ring, notify);
 	if (notify)
 		notify_remote_via_irq(info->irq);
+
+	return 0;
 }
 
-static void scsifront_gnttab_done(struct vscsifrnt_info *info, uint32_t id)
+static void scsifront_gnttab_done(struct vscsifrnt_info *info,
+				  struct vscsifrnt_shadow *shadow)
 {
-	struct vscsifrnt_shadow *s = info->shadow[id];
 	int i;
 
-	if (s->sc->sc_data_direction == DMA_NONE)
+	if (shadow->sc->sc_data_direction == DMA_NONE)
 		return;
 
-	for (i = 0; i < s->nr_grants; i++) {
-		if (unlikely(gnttab_query_foreign_access(s->gref[i]) != 0)) {
+	for (i = 0; i < shadow->nr_grants; i++) {
+		if (unlikely(gnttab_query_foreign_access(shadow->gref[i]))) {
 			shost_printk(KERN_ALERT, info->host, KBUILD_MODNAME
 				     "grant still in use by backend\n");
 			BUG();
 		}
-		gnttab_end_foreign_access(s->gref[i], 0, 0UL);
+		gnttab_end_foreign_access(shadow->gref[i], 0, 0UL);
 	}
 
-	kfree(s->sg);
+	kfree(shadow->sg);
 }
 
 static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 				   struct vscsiif_response *ring_rsp)
 {
+	struct vscsifrnt_shadow *shadow;
 	struct scsi_cmnd *sc;
 	uint32_t id;
 	uint8_t sense_len;
 
 	id = ring_rsp->rqid;
-	sc = info->shadow[id]->sc;
+	shadow = info->shadow[id];
+	sc = shadow->sc;
 
 	BUG_ON(sc == NULL);
 
-	scsifront_gnttab_done(info, id);
+	scsifront_gnttab_done(info, shadow);
 	scsifront_put_rqid(info, id);
 
 	sc->result = ring_rsp->rslt;
@@ -366,7 +391,6 @@ static void scsifront_finish_all(struct vscsifrnt_info *info)
 
 static int map_data_for_request(struct vscsifrnt_info *info,
 				struct scsi_cmnd *sc,
-				struct vscsiif_request *ring_req,
 				struct vscsifrnt_shadow *shadow)
 {
 	grant_ref_t gref_head;
@@ -379,7 +403,6 @@ static int map_data_for_request(struct vscsifrnt_info *info,
 	struct scatterlist *sg;
 	struct scsiif_request_segment *seg;
 
-	ring_req->nr_segments = 0;
 	if (sc->sc_data_direction == DMA_NONE || !data_len)
 		return 0;
 
@@ -398,7 +421,7 @@ static int map_data_for_request(struct vscsifrnt_info *info,
 		if (!shadow->sg)
 			return -ENOMEM;
 	}
-	seg = shadow->sg ? : ring_req->seg;
+	seg = shadow->sg ? : shadow->seg;
 
 	err = gnttab_alloc_grant_references(seg_grants + data_grants,
 					    &gref_head);
@@ -423,9 +446,9 @@ static int map_data_for_request(struct vscsifrnt_info *info,
 				info->dev->otherend_id,
 				xen_page_to_gfn(page), 1);
 			shadow->gref[ref_cnt] = ref;
-			ring_req->seg[ref_cnt].gref   = ref;
-			ring_req->seg[ref_cnt].offset = (uint16_t)off;
-			ring_req->seg[ref_cnt].length = (uint16_t)bytes;
+			shadow->seg[ref_cnt].gref   = ref;
+			shadow->seg[ref_cnt].offset = (uint16_t)off;
+			shadow->seg[ref_cnt].length = (uint16_t)bytes;
 
 			page++;
 			len -= bytes;
@@ -473,44 +496,14 @@ static int map_data_for_request(struct vscsifrnt_info *info,
 	}
 
 	if (seg_grants)
-		ring_req->nr_segments = VSCSIIF_SG_GRANT | seg_grants;
+		shadow->nr_segments = VSCSIIF_SG_GRANT | seg_grants;
 	else
-		ring_req->nr_segments = (uint8_t)ref_cnt;
+		shadow->nr_segments = (uint8_t)ref_cnt;
 	shadow->nr_grants = ref_cnt;
 
 	return 0;
 }
 
-static struct vscsiif_request *scsifront_command2ring(
-		struct vscsifrnt_info *info, struct scsi_cmnd *sc,
-		struct vscsifrnt_shadow *shadow)
-{
-	struct vscsiif_request *ring_req;
-
-	memset(shadow, 0, sizeof(*shadow));
-
-	ring_req = scsifront_pre_req(info);
-	if (!ring_req)
-		return NULL;
-
-	info->shadow[ring_req->rqid] = shadow;
-	shadow->rqid = ring_req->rqid;
-
-	ring_req->id      = sc->device->id;
-	ring_req->lun     = sc->device->lun;
-	ring_req->channel = sc->device->channel;
-	ring_req->cmd_len = sc->cmd_len;
-
-	BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
-
-	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
-
-	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = sc->request->timeout / HZ;
-
-	return ring_req;
-}
-
 static int scsifront_enter(struct vscsifrnt_info *info)
 {
 	if (info->pause)
@@ -536,36 +529,25 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 				  struct scsi_cmnd *sc)
 {
 	struct vscsifrnt_info *info = shost_priv(shost);
-	struct vscsiif_request *ring_req;
 	struct vscsifrnt_shadow *shadow = scsi_cmd_priv(sc);
 	unsigned long flags;
 	int err;
-	uint16_t rqid;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsifront_enter(info)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-	if (RING_FULL(&info->ring))
-		goto busy;
-
-	ring_req = scsifront_command2ring(info, sc, shadow);
-	if (!ring_req)
-		goto busy;
 
 	sc->result = 0;
-
-	rqid = ring_req->rqid;
-	ring_req->act = VSCSIIF_ACT_SCSI_CDB;
+	memset(shadow, 0, sizeof(*shadow));
 
 	shadow->sc  = sc;
 	shadow->act = VSCSIIF_ACT_SCSI_CDB;
 
-	err = map_data_for_request(info, sc, ring_req, shadow);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (scsifront_enter(info)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	err = map_data_for_request(info, sc, shadow);
 	if (err < 0) {
 		pr_debug("%s: err %d\n", __func__, err);
-		scsifront_put_rqid(info, rqid);
 		scsifront_return(info);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		if (err == -ENOMEM)
@@ -575,7 +557,11 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		return 0;
 	}
 
-	scsifront_do_request(info);
+	if (scsifront_do_request(info, shadow)) {
+		scsifront_gnttab_done(info, shadow);
+		goto busy;
+	}
+
 	scsifront_return(info);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -598,26 +584,30 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 	struct Scsi_Host *host = sc->device->host;
 	struct vscsifrnt_info *info = shost_priv(host);
 	struct vscsifrnt_shadow *shadow, *s = scsi_cmd_priv(sc);
-	struct vscsiif_request *ring_req;
 	int err = 0;
 
-	shadow = kmalloc(sizeof(*shadow), GFP_NOIO);
+	shadow = kzalloc(sizeof(*shadow), GFP_NOIO);
 	if (!shadow)
 		return FAILED;
 
+	shadow->act = act;
+	shadow->rslt_reset = RSLT_RESET_WAITING;
+	shadow->sc = sc;
+	shadow->ref_rqid = s->rqid;
+	init_waitqueue_head(&shadow->wq_reset);
+
 	spin_lock_irq(host->host_lock);
 
 	for (;;) {
-		if (!RING_FULL(&info->ring)) {
-			ring_req = scsifront_command2ring(info, sc, shadow);
-			if (ring_req)
-				break;
-		}
-		if (err || info->pause) {
-			spin_unlock_irq(host->host_lock);
-			kfree(shadow);
-			return FAILED;
-		}
+		if (scsifront_enter(info))
+			goto fail;
+
+		if (!scsifront_do_request(info, shadow))
+			break;
+
+		scsifront_return(info);
+		if (err)
+			goto fail;
 		info->wait_ring_available = 1;
 		spin_unlock_irq(host->host_lock);
 		err = wait_event_interruptible(info->wq_sync,
@@ -625,23 +615,6 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 		spin_lock_irq(host->host_lock);
 	}
 
-	if (scsifront_enter(info)) {
-		spin_unlock_irq(host->host_lock);
-		kfree(shadow);
-		return FAILED;
-	}
-
-	ring_req->act = act;
-	ring_req->ref_rqid = s->rqid;
-
-	shadow->act = act;
-	shadow->rslt_reset = RSLT_RESET_WAITING;
-	init_waitqueue_head(&shadow->wq_reset);
-
-	ring_req->nr_segments = 0;
-
-	scsifront_do_request(info);
-
 	spin_unlock_irq(host->host_lock);
 	err = wait_event_interruptible(shadow->wq_reset, shadow->wait_reset);
 	spin_lock_irq(host->host_lock);
@@ -660,6 +633,11 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 	scsifront_return(info);
 	spin_unlock_irq(host->host_lock);
 	return err;
+
+fail:
+	spin_unlock_irq(host->host_lock);
+	kfree(shadow);
+	return FAILED;
 }
 
 static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
-- 
2.10.2
