From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/3] multipath: Implement workqueue framework for hardware handler
Date: Thu, 15 Nov 2007 10:16:25 +0100
Message-ID: <20071115091625.B31B9347400@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXKOJQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Nov 2007 04:16:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com, linux-scsi@vger.kernel.org


Some hardware handler might prefer to queue the commands to
the controller so as not to flood the controller with commands.
This patch implements a generic workqueue framework for
hardware handler and converts dm-mpath-rdac to use it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-hw-handler.c |   88 ++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-hw-handler.h |   14 ++++++
 drivers/md/dm-mpath-rdac.c |   99 ++++++++++++++++++++++----------------------
 drivers/md/dm-mpath.c      |    7 ++-
 4 files changed, 153 insertions(+), 55 deletions(-)

diff --git a/drivers/md/dm-hw-handler.c b/drivers/md/dm-hw-handler.c
index 2ee84d8..1d02c6a 100644
--- a/drivers/md/dm-hw-handler.c
+++ b/drivers/md/dm-hw-handler.c
@@ -11,10 +11,14 @@
 
 #include <linux/slab.h>
 
+#define DM_MSG_PREFIX "multipath hwh"
+
 struct hwh_internal {
 	struct hw_handler_type hwht;
 
 	struct list_head list;
+	struct workqueue_struct *workq;
+	char *workq_name;
 	long use;
 };
 
@@ -99,6 +103,24 @@ static struct hwh_internal *_alloc_hw_handler(struct hw_handler_type *hwht)
 	return hwhi;
 }
 
+static int _alloc_hw_workq(struct hwh_internal *hwhi,
+			  struct hw_handler_type *hwht)
+{
+	int r = 0;
+
+	hwhi->workq_name = kzalloc(strlen(hwht->name) + 6, GFP_KERNEL);
+	if (!hwhi->workq_name)
+		return -ENOMEM;
+
+	sprintf(hwhi->workq_name, "%s_wkqd", hwht->name);
+	hwhi->workq = create_singlethread_workqueue(hwhi->workq_name);
+
+	if (!hwhi->workq)
+		r = -EEXIST;
+
+	return r;
+}
+
 int dm_register_hw_handler(struct hw_handler_type *hwht)
 {
 	int r = 0;
@@ -112,9 +134,13 @@ int dm_register_hw_handler(struct hw_handler_type *hwht)
 	if (__find_hw_handler_type(hwht->name)) {
 		kfree(hwhi);
 		r = -EEXIST;
-	} else
-		list_add(&hwhi->list, &_hw_handlers);
+	} else {
+		if (hwht->workq_fn)
+			r = _alloc_hw_workq(hwhi, hwht);
 
+		if (!r)
+			list_add(&hwhi->list, &_hw_handlers);
+	}
 	up_write(&_hwh_lock);
 
 	return r;
@@ -141,11 +167,68 @@ int dm_unregister_hw_handler(struct hw_handler_type *hwht)
 
 	up_write(&_hwh_lock);
 
+	if (hwhi->workq) {
+		destroy_workqueue(hwhi->workq);
+		kfree(hwhi->workq_name);
+	}
+
 	kfree(hwhi);
 
 	return 0;
 }
 
+static void dm_service_hw_workq(struct work_struct *work)
+{
+	struct hw_handler *hwh = container_of(work, struct hw_handler, work);
+	struct hw_handler_type *hwht = hwh->type;
+	struct hwh_internal *hwhi = container_of(hwht, struct hwh_internal, hwht);
+
+	if (hwht->workq_fn)
+		hwht->workq_fn(hwh);
+
+}
+
+int dm_create_hw_handler(struct hw_handler *hwh, unsigned int argc,
+			 char **argv)
+{
+	struct hw_handler_type *hwht = hwh->type;
+	int r;
+
+	r = hwht->create(hwh, argc, argv);
+	if (r)
+		return r;
+
+	if (hwht->workq_fn) {
+		INIT_WORK(&hwh->work, dm_service_hw_workq);
+	}
+
+	return 0;
+}
+
+void dm_destroy_hw_handler(struct hw_handler *hwh)
+{
+	struct hw_handler_type *hwht = hwh->type;
+
+	hwht->destroy(hwh);
+}
+
+void dm_enqueue_hw_workq(struct hw_handler *hwh)
+{
+	struct hw_handler_type *hwht = hwh->type;
+	struct hwh_internal *hwhi = container_of(hwht, struct hwh_internal, hwht);
+
+	down_read(&_hwh_lock);
+	if (!hwhi->workq)
+		goto out;
+
+	DMWARN("submit %s request", hwh->type->name);
+	queue_work(hwhi->workq, &hwh->work);
+
+ out:
+	up_read(&_hwh_lock);
+	return;
+}
+
 unsigned dm_scsi_err_handler(struct hw_handler *hwh, struct bio *bio)
 {
 #if 0
@@ -210,4 +293,5 @@ unsigned dm_scsi_err_handler(struct hw_handler *hwh, struct bio *bio)
 
 EXPORT_SYMBOL_GPL(dm_register_hw_handler);
 EXPORT_SYMBOL_GPL(dm_unregister_hw_handler);
+EXPORT_SYMBOL_GPL(dm_enqueue_hw_workq);
 EXPORT_SYMBOL_GPL(dm_scsi_err_handler);
diff --git a/drivers/md/dm-hw-handler.h b/drivers/md/dm-hw-handler.h
index 46809dc..9216682 100644
--- a/drivers/md/dm-hw-handler.h
+++ b/drivers/md/dm-hw-handler.h
@@ -14,9 +14,12 @@
 #include "dm-mpath.h"
 
 struct hw_handler_type;
+
 struct hw_handler {
+	struct list_head entry;
 	struct hw_handler_type *type;
 	struct mapped_device *md;
+	struct work_struct work;
 	void *context;
 };
 
@@ -37,6 +40,7 @@ struct hw_handler_type {
 	unsigned (*error) (struct hw_handler *hwh, struct bio *bio);
 	int (*status) (struct hw_handler *hwh, status_type_t type,
 		       char *result, unsigned int maxlen);
+	void (*workq_fn) (struct hw_handler *hwh);
 };
 
 /* Register a hardware handler */
@@ -51,6 +55,16 @@ struct hw_handler_type *dm_get_hw_handler(const char *name);
 /* Releases a hardware handler  */
 void dm_put_hw_handler(struct hw_handler_type *hwht);
 
+/* Creates a hardware handler */
+int dm_create_hw_handler(struct hw_handler *handler, unsigned int argc,
+			 char **argv);
+
+/* Destroys a hardware handler */
+void dm_destroy_hw_handler(struct hw_handler *handler);
+
+/* Enqueue an element to the workqueue */
+void dm_enqueue_hw_workq(struct hw_handler *hwh);
+
 /* Default err function */
 unsigned dm_scsi_err_handler(struct hw_handler *hwh, struct bio *bio);
 
diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
index e04eb5c..99f755c 100644
--- a/drivers/md/dm-mpath-rdac.c
+++ b/drivers/md/dm-mpath-rdac.c
@@ -176,14 +176,12 @@ struct c2_inquiry {
 };
 
 struct rdac_handler {
-	struct list_head	entry; /* list waiting to submit MODE SELECT */
 	unsigned		timeout;
 	struct rdac_controller	*ctlr;
 #define UNINITIALIZED_LUN	(1 << 8)
 	unsigned		lun;
 	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
 	struct dm_path		*path;
-	struct work_struct	work;
 #define	SEND_C2_INQUIRY		1
 #define	SEND_C4_INQUIRY		2
 #define	SEND_C8_INQUIRY		3
@@ -200,7 +198,6 @@ struct rdac_handler {
 
 static LIST_HEAD(ctlr_list);
 static DEFINE_SPINLOCK(list_lock);
-static struct workqueue_struct *rdac_wkqd;
 
 static inline int had_failures(struct request *req, int error)
 {
@@ -208,15 +205,16 @@ static inline int had_failures(struct request *req, int error)
 			msg_byte(req->errors) != COMMAND_COMPLETE);
 }
 
-static void rdac_resubmit_all(struct rdac_handler *h)
+static void rdac_resubmit_all(struct rdac_controller *ctlr)
 {
-	struct rdac_controller *ctlr = h->ctlr;
-	struct rdac_handler *tmp, *h1;
+	struct rdac_handler *h;
+	struct hw_handler *tmp, *h1;
 
 	spin_lock(&ctlr->lock);
 	list_for_each_entry_safe(h1, tmp, &ctlr->cmd_list, entry) {
-		h1->cmd_to_send = SEND_C9_INQUIRY;
-		queue_work(rdac_wkqd, &h1->work);
+		h = h1->context;
+		h->cmd_to_send = SEND_C9_INQUIRY;
+		dm_enqueue_hw_workq(h1);
 		list_del(&h1->entry);
 	}
 	ctlr->submitted = 0;
@@ -225,7 +223,8 @@ static void rdac_resubmit_all(struct rdac_handler *h)
 
 static void mode_select_endio(struct request *req, int error)
 {
-	struct rdac_handler *h = req->end_io_data;
+	struct hw_handler *hwh = req->end_io_data;
+	struct rdac_handler *h = hwh->context;
 	struct scsi_sense_hdr sense_hdr;
 	int sense = 0, fail = 0;
 
@@ -247,13 +246,13 @@ static void mode_select_endio(struct request *req, int error)
 			 * 0x62900    - Power On, Reset, or Bus Device Reset
 			 */
 			h->cmd_to_send = SEND_C9_INQUIRY;
-			queue_work(rdac_wkqd, &h->work);
+			dm_enqueue_hw_workq(hwh);
 			goto done;
 		}
 		if (sense)
 			DMINFO("MODE_SELECT failed on %s with sense 0x%x",
 						h->path->dev->name, sense);
- 	}
+	}
 failed:
 	if (fail || sense)
 		dm_pg_init_complete(h->path, MP_FAIL_PATH);
@@ -261,13 +260,14 @@ failed:
 		dm_pg_init_complete(h->path, 0);
 
 done:
-	rdac_resubmit_all(h);
+	rdac_resubmit_all(h->ctlr);
 	__blk_put_request(req->q, req);
 }
 
-static struct request *get_rdac_req(struct rdac_handler *h,
+static struct request *get_rdac_req(struct hw_handler *hwh,
 			void *buffer, unsigned buflen, int rw)
 {
+	struct rdac_handler *h = hwh->context;
 	struct request *rq;
 	struct request_queue *q = bdev_get_queue(h->path->dev->bdev);
 
@@ -284,20 +284,21 @@ static struct request *get_rdac_req(struct rdac_handler *h,
 		return NULL;
 	}
 
- 	memset(&rq->cmd, 0, BLK_MAX_CDB);
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
 
-	rq->end_io_data = h;
+	rq->end_io_data = hwh;
 	rq->timeout = h->timeout;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
 	return rq;
 }
 
-static struct request *rdac_failover_get(struct rdac_handler *h)
+static struct request *rdac_failover_get(struct hw_handler *hwh)
 {
+	struct rdac_handler *h = hwh->context;
 	struct request *rq;
 	struct rdac_mode_common *common;
 	unsigned data_size;
@@ -330,7 +331,7 @@ static struct request *rdac_failover_get(struct rdac_handler *h)
 	common->rdac_options = RDAC_FORCED_QUIESENCE;
 
 	/* get request for block layer packet command */
-	rq = get_rdac_req(h, &h->ctlr->mode_select, data_size, WRITE);
+	rq = get_rdac_req(hwh, &h->ctlr->mode_select, data_size, WRITE);
 	if (!rq) {
 		DMERR("rdac_failover_get: no rq");
 		return NULL;
@@ -351,14 +352,15 @@ static struct request *rdac_failover_get(struct rdac_handler *h)
 }
 
 /* Acquires h->ctlr->lock */
-static void submit_mode_select(struct rdac_handler *h)
+static void submit_mode_select(struct hw_handler *hwh)
 {
+	struct rdac_handler *h = hwh->context;
 	struct request *rq;
 	struct request_queue *q = bdev_get_queue(h->path->dev->bdev);
 
 	spin_lock(&h->ctlr->lock);
 	if (h->ctlr->submitted) {
-		list_add(&h->entry, &h->ctlr->cmd_list);
+		list_add(&hwh->entry, &h->ctlr->cmd_list);
 		goto drop_lock;
 	}
 
@@ -367,13 +369,13 @@ static void submit_mode_select(struct rdac_handler *h)
 		goto fail_path;
 	}
 
-	rq = rdac_failover_get(h);
+	rq = rdac_failover_get(hwh);
 	if (!rq) {
 		DMERR("submit_mode_select: no rq");
 		goto fail_path;
 	}
 
-	DMINFO("queueing MODE_SELECT command on %s", h->path->dev->name);
+	DMINFO("submit MODE_SELECT command on %s", h->path->dev->name);
 
 	blk_execute_rq_nowait(q, NULL, rq, 1, mode_select_endio);
 	h->ctlr->submitted = 1;
@@ -429,7 +431,8 @@ done:
 
 static void c4_endio(struct request *req, int error)
 {
-	struct rdac_handler *h = req->end_io_data;
+	struct hw_handler *hwh = req->end_io_data;
+	struct rdac_handler *h = hwh->context;
 	struct c4_inquiry *sp;
 
 	if (had_failures(req, error)) {
@@ -443,7 +446,7 @@ static void c4_endio(struct request *req, int error)
 
 	if (h->ctlr) {
 		h->cmd_to_send = SEND_C9_INQUIRY;
-		queue_work(rdac_wkqd, &h->work);
+		dm_enqueue_hw_workq(hwh);
 	} else
 		dm_pg_init_complete(h->path, MP_FAIL_PATH);
 done:
@@ -452,7 +455,8 @@ done:
 
 static void c2_endio(struct request *req, int error)
 {
-	struct rdac_handler *h = req->end_io_data;
+	struct hw_handler *hwh = req->end_io_data;
+	struct rdac_handler *h = hwh->context;
 	struct c2_inquiry *sp;
 
 	if (had_failures(req, error)) {
@@ -469,14 +473,15 @@ static void c2_endio(struct request *req, int error)
 		h->ctlr->use_10_ms = 0;
 
 	h->cmd_to_send = SEND_MODE_SELECT;
-	queue_work(rdac_wkqd, &h->work);
+	dm_enqueue_hw_workq(hwh);
 done:
 	__blk_put_request(req->q, req);
 }
 
 static void c9_endio(struct request *req, int error)
 {
-	struct rdac_handler *h = req->end_io_data;
+	struct hw_handler *hwh = req->end_io_data;
+	struct rdac_handler *h = hwh->context;
 	struct c9_inquiry *sp;
 
 	if (had_failures(req, error)) {
@@ -510,14 +515,15 @@ static void c9_endio(struct request *req, int error)
 			h->cmd_to_send = SEND_MODE_SELECT;
 	} else
 		h->cmd_to_send = SEND_C4_INQUIRY;
-	queue_work(rdac_wkqd, &h->work);
+	dm_enqueue_hw_workq(hwh);
 done:
 	__blk_put_request(req->q, req);
 }
 
 static void c8_endio(struct request *req, int error)
 {
-	struct rdac_handler *h = req->end_io_data;
+	struct hw_handler *hwh = req->end_io_data;
+	struct rdac_handler *h = hwh->context;
 	struct c8_inquiry *sp;
 
 	if (had_failures(req, error)) {
@@ -531,21 +537,22 @@ static void c8_endio(struct request *req, int error)
 	sp = &h->inq.c8;
 	h->lun = sp->lun[7]; /* currently it uses only one byte */
 	h->cmd_to_send = SEND_C9_INQUIRY;
-	queue_work(rdac_wkqd, &h->work);
+	dm_enqueue_hw_workq(hwh);
 done:
 	__blk_put_request(req->q, req);
 }
 
-static void submit_inquiry(struct rdac_handler *h, int page_code,
+static void submit_inquiry(struct hw_handler *hwh, int page_code,
 		unsigned int len, rq_end_io_fn endio)
 {
+	struct rdac_handler *h = hwh->context;
 	struct request *rq;
 	struct request_queue *q = bdev_get_queue(h->path->dev->bdev);
 
 	if (!q)
 		goto fail_path;
 
-	rq = get_rdac_req(h, &h->inq, len, READ);
+	rq = get_rdac_req(hwh, &h->inq, len, READ);
 	if (!rq)
 		goto fail_path;
 
@@ -562,25 +569,25 @@ fail_path:
 	dm_pg_init_complete(h->path, MP_FAIL_PATH);
 }
 
-static void service_wkq(struct work_struct *work)
+static void rdac_service_wkq(struct hw_handler *hwh)
 {
-	struct rdac_handler *h = container_of(work, struct rdac_handler, work);
+	struct rdac_handler *h = hwh->context;
 
 	switch (h->cmd_to_send) {
 	case SEND_C2_INQUIRY:
-		submit_inquiry(h, 0xC2, sizeof(struct c2_inquiry), c2_endio);
+		submit_inquiry(hwh, 0xC2, sizeof(struct c2_inquiry), c2_endio);
 		break;
 	case SEND_C4_INQUIRY:
-		submit_inquiry(h, 0xC4, sizeof(struct c4_inquiry), c4_endio);
+		submit_inquiry(hwh, 0xC4, sizeof(struct c4_inquiry), c4_endio);
 		break;
 	case SEND_C8_INQUIRY:
-		submit_inquiry(h, 0xC8, sizeof(struct c8_inquiry), c8_endio);
+		submit_inquiry(hwh, 0xC8, sizeof(struct c8_inquiry), c8_endio);
 		break;
 	case SEND_C9_INQUIRY:
-		submit_inquiry(h, 0xC9, sizeof(struct c9_inquiry), c9_endio);
+		submit_inquiry(hwh, 0xC9, sizeof(struct c9_inquiry), c9_endio);
 		break;
 	case SEND_MODE_SELECT:
-		submit_mode_select(h);
+		submit_mode_select(hwh);
 		break;
 	default:
 		BUG();
@@ -603,7 +610,7 @@ static int rdac_create(struct hw_handler *hwh, unsigned argc, char **argv)
 		DMWARN("incorrect number of arguments");
 		return -EINVAL;
 	} else {
-		if (sscanf(argv[1], "%u", &timeout) != 1) {
+		if (sscanf(argv[0], "%u", &timeout) != 1) {
 			DMWARN("invalid timeout value");
 			return -EINVAL;
 		}
@@ -616,7 +623,6 @@ static int rdac_create(struct hw_handler *hwh, unsigned argc, char **argv)
 	hwh->context = h;
 	h->timeout = timeout;
 	h->lun = UNINITIALIZED_LUN;
-	INIT_WORK(&h->work, service_wkq);
 	DMWARN("using RDAC command with timeout %u", h->timeout);
 
 	return 0;
@@ -646,10 +652,10 @@ static void rdac_pg_init(struct hw_handler *hwh, unsigned bypassed,
 	h->path = path;
 	switch (h->lun) {
 	case UNINITIALIZED_LUN:
-		submit_inquiry(h, 0xC8, sizeof(struct c8_inquiry), c8_endio);
+		submit_inquiry(hwh, 0xC8, sizeof(struct c8_inquiry), c8_endio);
 		break;
 	default:
-		submit_inquiry(h, 0xC9, sizeof(struct c9_inquiry), c9_endio);
+		submit_inquiry(hwh, 0xC9, sizeof(struct c9_inquiry), c9_endio);
 	}
 }
 
@@ -660,22 +666,16 @@ static struct hw_handler_type rdac_handler = {
 	.destroy = rdac_destroy,
 	.pg_init = rdac_pg_init,
 	.error = rdac_error,
+	.workq_fn = rdac_service_wkq,
 };
 
 static int __init rdac_init(void)
 {
 	int r;
 
-	rdac_wkqd = create_singlethread_workqueue("rdac_wkqd");
-	if (!rdac_wkqd) {
-		DMERR("Failed to create workqueue rdac_wkqd.");
-		return -ENOMEM;
-	}
-
 	r = dm_register_hw_handler(&rdac_handler);
 	if (r < 0) {
 		DMERR("%s: register failed %d", RDAC_DM_HWH_NAME, r);
-		destroy_workqueue(rdac_wkqd);
 		return r;
 	}
 
@@ -687,7 +687,6 @@ static void __exit rdac_exit(void)
 {
 	int r = dm_unregister_hw_handler(&rdac_handler);
 
-	destroy_workqueue(rdac_wkqd);
 	if (r < 0)
 		DMERR("%s: unregister failed %d", RDAC_DM_HWH_NAME, r);
 }
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 24b2b1e..65a52b7 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -201,7 +201,7 @@ static void free_multipath(struct multipath *m)
 	}
 
 	if (hwh->type) {
-		hwh->type->destroy(hwh);
+		dm_destroy_hw_handler(hwh);
 		dm_put_hw_handler(hwh->type);
 	}
 
@@ -677,14 +677,15 @@ static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 	m->hw_handler.md = dm_table_get_md(ti->table);
 	dm_put(m->hw_handler.md);
 
-	r = hwht->create(&m->hw_handler, hw_argc - 1, as->argv);
+	m->hw_handler.type = hwht;
+
+	r = dm_create_hw_handler(&m->hw_handler, hw_argc - 1, as->argv);
 	if (r) {
 		dm_put_hw_handler(hwht);
 		ti->error = "hardware handler constructor failed";
 		return r;
 	}
 
-	m->hw_handler.type = hwht;
 	consume(as, hw_argc - 1);
 
 	return 0;
-- 
1.5.3.2

