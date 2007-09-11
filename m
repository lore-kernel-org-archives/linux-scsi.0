From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH][RFC] Use bio markers for request callback
Date: Tue, 11 Sep 2007 12:44:46 +0200
Message-ID: <20070911124446.qs5cek5mskowckcc@imap.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_7bbcgtrerlwk"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

This message is in MIME format.

--=_7bbcgtrerlwk
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi all,

this is a proposal for a different implementation of request  
callbacks. The existing ->endio callback of a request is actually a  
destructor function, to be called to terminate a request and free all  
structures.

However, on certain occasions (like request-based multipathing) it is  
desirable to have a callback function for a request which is called  
right after the request is finished, ie in end_that_request_first()  
before any bio->bi_endio callback is called.

So a simple solution for this is to clone the request and add a new  
'marker' bio in front of the bio list of the request. This callback  
will be attached a structure in bi_private which keeps a pointer to  
the cloned and the original request, thus serving as a callback for  
the request itself.

Proposed patch attached. As usual comments are welcome.

Cheers,

Hannes

--=_7bbcgtrerlwk
Content-Type: text/x-patch;
	charset=UTF-8;
	name="rq-marker-bio"
Content-Disposition: attachment;
	filename="rq-marker-bio"
Content-Transfer-Encoding: quoted-printable

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index a15845c..c286f05 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -40,7 +40,6 @@ static void blk_unplug_work(struct work_struct *work);
 static void blk_unplug_timeout(unsigned long data);
 static void drive_stat_acct(struct request *rq, int nr_sectors, int new_io)=
;
 static void init_request_from_bio(struct request *req, struct bio *bio);
-static int __make_request(struct request_queue *q, struct bio *bio);
 static struct io_context *current_io_context(gfp_t gfp_flags, int node);
=20
 /*
@@ -2912,7 +2911,7 @@ static void init_request_from_bio(struct request *req,=
 struct bio *bio)
 =09req->start_time =3D jiffies;
 }
=20
-static int __make_request(struct request_queue *q, struct bio *bio)
+int __make_request(struct request_queue *q, struct bio *bio)
 {
 =09struct request *req;
 =09int el_ret, nr_sectors, barrier, err;
@@ -3030,6 +3029,7 @@ end_io:
 =09bio_endio(bio, nr_sectors << 9, err);
 =09return 0;
 }
+EXPORT_SYMBOL(__make_request);
=20
 /*
  * If bio->bi_dev is a partition, remap the location
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d6ca9d0..76acda2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2003 Sistina Software Limited.
  * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2007 NEC Corporation.
  *
  * This file is released under the GPL.
  */
@@ -8,8 +9,7 @@
 #include "dm.h"
 #include "dm-path-selector.h"
 #include "dm-hw-handler.h"
-#include "dm-bio-list.h"
-#include "dm-bio-record.h"
+#include "dm-rq-record.h"
=20
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -77,7 +77,7 @@ struct multipath {
 =09unsigned saved_queue_if_no_path;/* Saved state during suspension */
=20
 =09struct work_struct process_queued_ios;
-=09struct bio_list queued_ios;
+=09struct list_head queued_ios;
 =09unsigned queue_size;
=20
 =09struct work_struct trigger_event;
@@ -94,7 +94,7 @@ struct multipath {
  */
 struct dm_mpath_io {
 =09struct pgpath *pgpath;
-=09struct dm_bio_details details;
+=09struct dm_rq_details details;
 };
=20
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -171,6 +171,7 @@ static struct multipath *alloc_multipath(struct dm_targe=
t *ti)
 =09m =3D kzalloc(sizeof(*m), GFP_KERNEL);
 =09if (m) {
 =09=09INIT_LIST_HEAD(&m->priority_groups);
+=09=09INIT_LIST_HEAD(&m->queued_ios);
 =09=09spin_lock_init(&m->lock);
 =09=09m->queue_io =3D 1;
 =09=09INIT_WORK(&m->process_queued_ios, process_queued_ios);
@@ -180,6 +181,9 @@ static struct multipath *alloc_multipath(struct dm_targe=
t *ti)
 =09=09=09kfree(m);
 =09=09=09return NULL;
 =09=09}
+
+=09=09dm_table_enable_elevator(ti->table);
+
 =09=09m->ti =3D ti;
 =09=09ti->private =3D m;
 =09}
@@ -202,6 +206,8 @@ static void free_multipath(struct multipath *m)
 =09=09dm_put_hw_handler(hwh->type);
 =09}
=20
+=09dm_table_disable_elevator(m->ti->table);
+
 =09mempool_destroy(m->mpio_pool);
 =09kfree(m);
 }
@@ -299,7 +305,7 @@ static int __must_push_back(struct multipath *m)
 =09=09dm_noflush_suspending(m->ti));
 }
=20
-static int map_io(struct multipath *m, struct bio *bio,
+static int map_io(struct multipath *m, struct request *clone,
 =09=09  struct dm_mpath_io *mpio, unsigned was_queued)
 {
 =09int r =3D DM_MAPIO_REMAPPED;
@@ -321,22 +327,30 @@ static int map_io(struct multipath *m, struct bio *bio=
,
 =09if ((pgpath && m->queue_io) ||
 =09    (!pgpath && m->queue_if_no_path)) {
 =09=09/* Queue for the daemon to resubmit */
-=09=09bio_list_add(&m->queued_ios, bio);
+=09=09list_add_tail(&clone->queuelist, &m->queued_ios);
 =09=09m->queue_size++;
 =09=09if ((m->pg_init_required && !m->pg_init_in_progress) ||
 =09=09    !m->queue_io)
 =09=09=09queue_work(kmultipathd, &m->process_queued_ios);
 =09=09pgpath =3D NULL;
+=09=09clone->q =3D NULL;
+=09=09clone->rq_disk =3D NULL;
 =09=09r =3D DM_MAPIO_SUBMITTED;
-=09} else if (pgpath)
-=09=09bio->bi_bdev =3D pgpath->path.dev->bdev;
-=09else if (__must_push_back(m))
-=09=09r =3D DM_MAPIO_REQUEUE;
-=09else
+=09} else if (pgpath) {
+=09=09clone->q =3D bdev_get_queue(pgpath->path.dev->bdev);
+=09=09clone->rq_disk =3D pgpath->path.dev->bdev->bd_disk;
+=09} else {
+=09=09printk(KERN_INFO "request %p: failed to map\n", clone);
+=09=09clone->q =3D NULL;
+=09=09clone->rq_disk =3D NULL;
 =09=09r =3D -EIO;=09/* Failed */
+=09}
=20
 =09mpio->pgpath =3D pgpath;
=20
+=09if (r =3D=3D DM_MAPIO_REMAPPED && m->current_pg->ps.type->start_io)
+=09=09m->current_pg->ps.type->start_io(&m->current_pg->ps,
+=09=09=09=09=09=09 &pgpath->path, clone);
 =09spin_unlock_irqrestore(&m->lock, flags);
=20
 =09return r;
@@ -373,30 +387,38 @@ static void dispatch_queued_ios(struct multipath *m)
 {
 =09int r;
 =09unsigned long flags;
-=09struct bio *bio =3D NULL, *next;
 =09struct dm_mpath_io *mpio;
 =09union map_info *info;
+=09struct request *clone, *n;
+=09LIST_HEAD(cl);
=20
 =09spin_lock_irqsave(&m->lock, flags);
-=09bio =3D bio_list_get(&m->queued_ios);
+=09list_splice_init(&m->queued_ios, &cl);
 =09spin_unlock_irqrestore(&m->lock, flags);
=20
-=09while (bio) {
-=09=09next =3D bio->bi_next;
-=09=09bio->bi_next =3D NULL;
+=09list_for_each_entry_safe(clone, n, &cl, queuelist) {
+=09=09struct bio *bio =3D clone->bio;
+=09=09list_del(&clone->queuelist);
+
+=09=09BUG_ON(!bio);
=20
-=09=09info =3D dm_get_mapinfo(bio);
+=09=09info =3D dm_get_mapinfo(clone->bio);
 =09=09mpio =3D info->ptr;
=20
-=09=09r =3D map_io(m, bio, mpio, 1);
-=09=09if (r < 0)
+=09=09r =3D map_io(m, clone, mpio, 1);
+=09=09if (r < 0) {
+=09=09=09printk(KERN_INFO "%s: map clone %p failed\n",
+=09=09=09       __FUNCTION__, clone);
+=09=09=09/* FIXME */
 =09=09=09bio_endio(bio, bio->bi_size, r);
-=09=09else if (r =3D=3D DM_MAPIO_REMAPPED)
-=09=09=09generic_make_request(bio);
-=09=09else if (r =3D=3D DM_MAPIO_REQUEUE)
+=09=09} else if (r =3D=3D DM_MAPIO_REMAPPED)
+=09=09=09dm_dispatch_request(clone->q, clone);
+=09=09else if (r =3D=3D DM_MAPIO_REQUEUE) {
+=09=09=09printk(KERN_INFO "%s: requeue map clone %p\n",
+=09=09=09       __FUNCTION__, clone);
+=09=09=09/* FIXME */
 =09=09=09bio_endio(bio, bio->bi_size, -EIO);
-
-=09=09bio =3D next;
+=09=09}
 =09}
 }
=20
@@ -789,23 +811,29 @@ static void multipath_dtr(struct dm_target *ti)
 }
=20
 /*
- * Map bios, recording original fields for later in case we have to resubmi=
t
+ * Map cloned requests
  */
-static int multipath_map(struct dm_target *ti, struct bio *bio,
+static int multipath_map(struct dm_target *ti, struct request *clone,
 =09=09=09 union map_info *map_context)
 {
 =09int r;
 =09struct dm_mpath_io *mpio;
 =09struct multipath *m =3D (struct multipath *) ti->private;
=20
+=09if (blk_barrier_rq(clone))
+=09=09return -EOPNOTSUPP;
+
 =09mpio =3D mempool_alloc(m->mpio_pool, GFP_NOIO);
-=09dm_bio_record(&mpio->details, bio);
+=09memset(mpio, 0, sizeof(mpio));
=20
+=09clone->cmd_flags |=3D REQ_FAILFAST;
+=09dm_rq_record(&mpio->details, clone);
 =09map_context->ptr =3D mpio;
-=09bio->bi_rw |=3D (1 << BIO_RW_FAILFAST);
-=09r =3D map_io(m, bio, mpio, 0);
-=09if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE)
+=09r =3D map_io(m, clone, mpio, 0);
+=09if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE) {
 =09=09mempool_free(mpio, m->mpio_pool);
+=09=09map_context->ptr =3D NULL;
+=09}
=20
 =09return r;
 }
@@ -1007,25 +1035,37 @@ void dm_pg_init_complete(struct dm_path *path, unsig=
ned err_flags)
 =09spin_unlock_irqrestore(&m->lock, flags);
 }
=20
+static void multipath_queue_in_tgt(struct dm_target *ti, struct request *cl=
one,
+=09=09=09=09   union map_info *map_context)
+{
+=09struct multipath *m =3D (struct multipath *) ti->private;
+=09struct dm_mpath_io *mpio =3D (struct dm_mpath_io *) map_context->ptr;
+=09unsigned long flags =3D 0UL;
+
+=09dm_rq_restore(&mpio->details, clone);
+
+=09/* queue for the daemon to resubmit or fail */
+=09spin_lock_irqsave(&m->lock, flags);
+=09list_add_tail(&clone->queuelist, &m->queued_ios);
+=09m->queue_size++;
+=09if (!m->queue_io)
+=09=09queue_work(kmultipathd, &m->process_queued_ios);
+=09spin_unlock_irqrestore(&m->lock, flags);
+}
+
 /*
  * end_io handling
  */
-static int do_end_io(struct multipath *m, struct bio *bio,
+static int do_end_io(struct multipath *m, struct request *clone,
 =09=09     int error, struct dm_mpath_io *mpio)
 {
 =09struct hw_handler *hwh =3D &m->hw_handler;
 =09unsigned err_flags =3D MP_FAIL_PATH;=09/* Default behavior */
-=09unsigned long flags;
+=09unsigned long flags =3D 0UL;
=20
-=09if (!error)
+=09if (!clone->errors && !error)
 =09=09return 0;=09/* I/O complete */
=20
-=09if ((error =3D=3D -EWOULDBLOCK) && bio_rw_ahead(bio))
-=09=09return error;
-
-=09if (error =3D=3D -EOPNOTSUPP)
-=09=09return error;
-
 =09spin_lock_irqsave(&m->lock, flags);
 =09if (!m->nr_valid_paths) {
 =09=09if (__must_push_back(m)) {
@@ -1041,9 +1081,6 @@ static int do_end_io(struct multipath *m, struct bio *=
bio,
 =09}
 =09spin_unlock_irqrestore(&m->lock, flags);
=20
-=09if (hwh->type && hwh->type->error)
-=09=09err_flags =3D hwh->type->error(hwh, bio);
-
 =09if (mpio->pgpath) {
 =09=09if (err_flags & MP_FAIL_PATH)
 =09=09=09fail_path(mpio->pgpath);
@@ -1056,21 +1093,14 @@ static int do_end_io(struct multipath *m, struct bio=
 *bio,
 =09=09return -EIO;
=20
       requeue:
-=09dm_bio_restore(&mpio->details, bio);
-
-=09/* queue for the daemon to resubmit or fail */
-=09spin_lock_irqsave(&m->lock, flags);
-=09bio_list_add(&m->queued_ios, bio);
-=09m->queue_size++;
-=09if (!m->queue_io)
-=09=09queue_work(kmultipathd, &m->process_queued_ios);
-=09spin_unlock_irqrestore(&m->lock, flags);
-
 =09return DM_ENDIO_INCOMPLETE;=09/* io not complete */
 }
=20
-static int multipath_end_io(struct dm_target *ti, struct bio *bio,
-=09=09=09    int error, union map_info *map_context)
+/*
+ * clone->q's lock must be held
+ */
+static int multipath_end_io_first(struct dm_target *ti, struct request *clo=
ne,
+=09=09=09=09  int error, union map_info *map_context)
 {
 =09struct multipath *m =3D ti->private;
 =09struct dm_mpath_io *mpio =3D map_context->ptr;
@@ -1078,18 +1108,34 @@ static int multipath_end_io(struct dm_target *ti, st=
ruct bio *bio,
 =09struct path_selector *ps;
 =09int r;
=20
-=09r  =3D do_end_io(m, bio, error, mpio);
+=09r  =3D do_end_io(m, clone, error, mpio);
 =09if (pgpath) {
 =09=09ps =3D &pgpath->pg->ps;
 =09=09if (ps->type->end_io)
-=09=09=09ps->type->end_io(ps, &pgpath->path);
+=09=09=09ps->type->end_io(ps, &pgpath->path, clone);
 =09}
-=09if (r !=3D DM_ENDIO_INCOMPLETE)
+=09if (r !=3D DM_ENDIO_INCOMPLETE && mpio) {
 =09=09mempool_free(mpio, m->mpio_pool);
+=09=09map_context->ptr =3D NULL;
+=09}
=20
 =09return r;
 }
=20
+static int multipath_end_io(struct dm_target *ti, struct request *clone,
+=09=09=09    int error, union map_info *map_context)
+{
+=09struct multipath *m =3D (struct multipath *) ti->private;
+=09struct dm_mpath_io *mpio =3D (struct dm_mpath_io *) map_context->ptr;
+
+=09if (mpio) {
+=09=09mempool_free(mpio, m->mpio_pool);
+=09=09map_context->ptr =3D NULL;
+=09}
+
+=09return 0;
+}
+
 /*
  * Suspend can't complete until all the I/O is processed so if
  * the last path fails we must error any remaining I/O.
@@ -1329,8 +1375,10 @@ static struct target_type multipath_target =3D {
 =09.module =3D THIS_MODULE,
 =09.ctr =3D multipath_ctr,
 =09.dtr =3D multipath_dtr,
-=09.map =3D multipath_map,
-=09.end_io =3D multipath_end_io,
+=09.map_rq =3D multipath_map,
+=09.rq_end_io_first =3D multipath_end_io_first,
+=09.rq_end_io =3D multipath_end_io,
+=09.queue_in_tgt =3D multipath_queue_in_tgt,
 =09.presuspend =3D multipath_presuspend,
 =09.resume =3D multipath_resume,
 =09.status =3D multipath_status,
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index 27357b8..089a979 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -75,7 +75,10 @@ struct path_selector_type {
 =09int (*status) (struct path_selector *ps, struct dm_path *path,
 =09=09       status_type_t type, char *result, unsigned int maxlen);
=20
-=09int (*end_io) (struct path_selector *ps, struct dm_path *path);
+=09int (*start_io) (struct path_selector *ps, struct dm_path *path,
+=09=09=09struct request *clone);
+=09int (*end_io) (struct path_selector *ps, struct dm_path *path,
+=09=09=09struct request *clone);
 };
=20
 /* Register a path selector */
diff --git a/drivers/md/dm-rq-record.h b/drivers/md/dm-rq-record.h
new file mode 100644
index 0000000..4e09598
--- /dev/null
+++ b/drivers/md/dm-rq-record.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2007 NEC Corporation.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_RQ_RECORD_H
+#define DM_RQ_RECORD_H
+
+#include <linux/blkdev.h>
+
+/*
+ * There are lots of mutable fields in the request struct that get
+ * changed by the lower levels of the block layer.  Some targets,
+ * such as multipath, may wish to resubmit a request on error.  The
+ * functions in this file help the target record and restore the
+ * original request state.
+ */
+struct dm_rq_details {
+=09unsigned int cmd_flags;
+=09int ref_count;
+};
+
+static inline void dm_rq_record(struct dm_rq_details *rd, struct request *r=
q)
+{
+=09rd->cmd_flags =3D rq->cmd_flags;
+=09rd->ref_count =3D rq->ref_count;
+}
+
+static inline void dm_rq_restore(struct dm_rq_details *rd, struct request *=
rq)
+{
+=09rq->cmd_flags =3D rd->cmd_flags;
+=09rq->ref_count =3D rd->ref_count;
+}
+
+#endif
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2bcde57..ad0c85e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1033,6 +1033,28 @@ struct mapped_device *dm_table_get_md(struct dm_table=
 *t)
 =09return t->md;
 }
=20
+int dm_table_enable_elevator(struct dm_table *t)
+{
+=09struct mapped_device *md =3D dm_table_get_md(t);
+
+=09if (!md)
+=09=09return 1;
+
+=09if (dm_enable_elevator(md)) {
+=09=09dm_put(md);
+=09=09return 1;
+=09}
+=09dm_put(md);
+
+=09return 0;
+}
+
+void dm_table_disable_elevator(struct dm_table *t)
+{
+=09/* No reference taken */
+=09dm_disable_elevator(t->md);
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
@@ -1044,3 +1066,5 @@ EXPORT_SYMBOL(dm_table_put);
 EXPORT_SYMBOL(dm_table_get);
 EXPORT_SYMBOL(dm_table_unplug_all);
 EXPORT_SYMBOL(dm_table_flush_all);
+EXPORT_SYMBOL(dm_table_enable_elevator);
+EXPORT_SYMBOL(dm_table_disable_elevator);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2120155..7ac9527 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -24,6 +24,8 @@
=20
 #define DM_MSG_PREFIX "core"
=20
+#define DM_DEBUG
+
 static const char *_name =3D DM_NAME;
=20
 static unsigned int major =3D 0;
@@ -31,13 +33,19 @@ static unsigned int _major =3D 0;
=20
 static DEFINE_SPINLOCK(_minor_lock);
 /*
- * One of these is allocated per bio.
+ * One of these is allocated per bio / request.
  */
 struct dm_io {
 =09struct mapped_device *md;
 =09int error;
-=09struct bio *bio;
-=09atomic_t io_count;
+=09union {
+=09=09struct bio *bio;
+=09=09struct request *req;
+=09} data;
+=09union {
+=09=09atomic_t io_count;
+=09=09struct request *orig;
+=09} parm;
 =09unsigned long start_time;
 };
=20
@@ -48,6 +56,7 @@ struct dm_io {
 struct dm_target_io {
 =09struct dm_io *io;
 =09struct dm_target *ti;
+=09struct dm_table *map;
 =09union map_info info;
 };
=20
@@ -103,6 +112,7 @@ struct mapped_device {
 =09 * io objects are allocated from here.
 =09 */
 =09mempool_t *io_pool;
+=09mempool_t *rq_pool;
 =09mempool_t *tio_pool;
=20
 =09struct bio_set *bs;
@@ -125,6 +135,7 @@ struct mapped_device {
=20
 #define MIN_IOS 256
 static struct kmem_cache *_io_cache;
+static struct kmem_cache *_rq_cache;
 static struct kmem_cache *_tio_cache;
=20
 static int __init local_init(void)
@@ -143,6 +154,14 @@ static int __init local_init(void)
 =09=09return -ENOMEM;
 =09}
=20
+=09_rq_cache =3D kmem_cache_create("dm_rq", sizeof(struct request),
+=09=09=09=09      0, 0, NULL);
+=09if (!_rq_cache) {
+=09=09kmem_cache_destroy(_tio_cache);
+=09=09kmem_cache_destroy(_io_cache);
+=09=09return -ENOMEM;
+=09}
+
 =09_major =3D major;
 =09r =3D register_blkdev(_major, _name);
 =09if (r < 0) {
@@ -160,6 +179,7 @@ static int __init local_init(void)
 static void local_exit(void)
 {
 =09kmem_cache_destroy(_tio_cache);
+=09kmem_cache_destroy(_rq_cache);
 =09kmem_cache_destroy(_io_cache);
 =09unregister_blkdev(_major, _name);
=20
@@ -341,6 +361,16 @@ static void free_tio(struct mapped_device *md, struct d=
m_target_io *tio)
 =09mempool_free(tio, md->tio_pool);
 }
=20
+static inline struct request *alloc_rq(struct mapped_device *md)
+{
+=09return mempool_alloc(md->rq_pool, GFP_NOIO);
+}
+
+static inline void free_rq(struct mapped_device *md, struct request *rq)
+{
+=09mempool_free(rq, md->rq_pool);
+}
+
 static void start_io_acct(struct dm_io *io)
 {
 =09struct mapped_device *md =3D io->md;
@@ -356,7 +386,7 @@ static void start_io_acct(struct dm_io *io)
 static int end_io_acct(struct dm_io *io)
 {
 =09struct mapped_device *md =3D io->md;
-=09struct bio *bio =3D io->bio;
+=09struct bio *bio =3D io->data.bio;
 =09unsigned long duration =3D jiffies - io->start_time;
 =09int pending;
 =09int rw =3D bio_data_dir(bio);
@@ -434,6 +464,94 @@ int dm_set_geometry(struct mapped_device *md, struct hd=
_geometry *geo)
 =09return 0;
 }
=20
+/*
+ * The queue is only valid as long as you have a reference
+ * count on 'md'.
+ */
+struct request_queue *dm_get_queue(struct mapped_device *md)
+{
+=09if (blk_get_queue(md->queue))
+=09=09return NULL;
+
+=09return md->queue;
+}
+EXPORT_SYMBOL_GPL(dm_get_queue);
+
+void dm_put_queue(struct request_queue *q)
+{
+=09blk_put_queue(q);
+}
+EXPORT_SYMBOL_GPL(dm_put_queue);
+
+void dm_stop_queue(struct request_queue *q)
+{
+=09unsigned long flags;
+
+=09spin_lock_irqsave(q->queue_lock, flags);
+=09blk_stop_queue(q);
+=09spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_stop_queue);
+
+void dm_start_queue(struct request_queue *q)
+{
+=09unsigned long flags;
+
+=09spin_lock_irqsave(q->queue_lock, flags);
+=09if (blk_queue_stopped(q))
+=09=09blk_start_queue(q);
+=09spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_start_queue);
+
+void __dm_requeue_request(struct request_queue *q, struct request *rq)
+{
+=09if (elv_queue_empty(q))
+=09=09blk_plug_device(q);
+=09blk_requeue_request(q, rq);
+}
+EXPORT_SYMBOL_GPL(__dm_requeue_request);
+
+void dm_requeue_request(struct request_queue *q, struct request *rq)
+{
+=09unsigned long flags;
+
+=09spin_lock_irqsave(q->queue_lock, flags);
+=09__dm_requeue_request(q, rq);
+=09spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_requeue_request);
+
+void dm_dispatch_request(struct request_queue *q, struct request *rq)
+{
+=09int where =3D ELEVATOR_INSERT_BACK;
+=09unsigned long flags;
+
+=09spin_lock_irqsave(q->queue_lock, flags);
+
+=09/* Initialize statistic stuff */
+=09disk_round_stats(rq->rq_disk);
+=09rq->start_time =3D jiffies;
+=09rq->rq_disk->in_flight++;
+
+=09__elv_add_request(q, rq, where, 0);
+
+=09spin_unlock_irqrestore(q->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_dispatch_request);
+
+static void kill_request(struct request *rq)
+{
+=09int nr_bytes =3D rq->hard_nr_sectors << 9;
+
+=09if (!nr_bytes)
+=09=09nr_bytes =3D rq->data_len;
+
+=09rq->cmd_flags |=3D REQ_QUIET;
+=09end_that_request_first(rq, 0, nr_bytes);
+=09end_that_request_last(rq, 0);
+}
+
 /*-----------------------------------------------------------------
  * CRUD START:
  *   A more elegant soln is in the works that uses the queue
@@ -460,7 +578,7 @@ static void dec_pending(struct dm_io *io, int error)
 =09if (error && !(io->error > 0 && __noflush_suspending(io->md)))
 =09=09io->error =3D error;
=20
-=09if (atomic_dec_and_test(&io->io_count)) {
+=09if (atomic_dec_and_test(&io->parm.io_count)) {
 =09=09if (io->error =3D=3D DM_ENDIO_REQUEUE) {
 =09=09=09/*
 =09=09=09 * Target requested pushing back the I/O.
@@ -469,7 +587,7 @@ static void dec_pending(struct dm_io *io, int error)
 =09=09=09 */
 =09=09=09spin_lock_irqsave(&io->md->pushback_lock, flags);
 =09=09=09if (__noflush_suspending(io->md))
-=09=09=09=09bio_list_add(&io->md->pushback, io->bio);
+=09=09=09=09bio_list_add(&io->md->pushback, io->data.bio);
 =09=09=09else
 =09=09=09=09/* noflush suspend was interrupted. */
 =09=09=09=09io->error =3D -EIO;
@@ -481,10 +599,10 @@ static void dec_pending(struct dm_io *io, int error)
 =09=09=09wake_up(&io->md->wait);
=20
 =09=09if (io->error !=3D DM_ENDIO_REQUEUE) {
-=09=09=09blk_add_trace_bio(io->md->queue, io->bio,
+=09=09=09blk_add_trace_bio(io->md->queue, io->data.bio,
 =09=09=09=09=09  BLK_TA_COMPLETE);
=20
-=09=09=09bio_endio(io->bio, io->bio->bi_size, io->error);
+=09=09=09bio_endio(io->data.bio, io->data.bio->bi_size, io->error);
 =09=09}
=20
 =09=09free_io(io->md, io);
@@ -533,6 +651,30 @@ static int clone_endio(struct bio *bio, unsigned int do=
ne, int error)
 =09return r;
 }
=20
+static void blk_update_cloned_rq(struct request *rq, struct request *clone)
+{
+=09clone->nr_phys_segments =3D rq->nr_phys_segments;
+=09clone->nr_hw_segments =3D rq->nr_hw_segments;
+=09clone->current_nr_sectors =3D rq->current_nr_sectors;
+=09clone->hard_cur_sectors =3D rq->hard_cur_sectors;
+=09clone->hard_nr_sectors =3D rq->hard_nr_sectors;
+=09clone->nr_sectors =3D rq->nr_sectors;
+=09clone->hard_sector =3D rq->hard_sector;
+=09clone->sector =3D rq->sector;
+=09clone->data_len =3D rq->data_len;
+=09clone->buffer =3D rq->buffer;
+=09clone->data =3D rq->data;
+=09clone->bio =3D rq->bio;
+=09clone->biotail =3D rq->biotail;
+}
+
+static void dec_rq_pending(struct dm_target_io *tio)
+{
+=09if (!atomic_dec_return(&tio->io->md->pending))
+=09=09/* nudge anyone waiting on suspend queue */
+=09=09wake_up(&tio->io->md->wait);
+}
+
 static sector_t max_io_len(struct mapped_device *md,
 =09=09=09   sector_t sector, struct dm_target *ti)
 {
@@ -573,14 +715,14 @@ static void __map_bio(struct dm_target *ti, struct bio=
 *clone,
 =09 * anything, the target has assumed ownership of
 =09 * this io.
 =09 */
-=09atomic_inc(&tio->io->io_count);
+=09atomic_inc(&tio->io->parm.io_count);
 =09sector =3D clone->bi_sector;
 =09r =3D ti->type->map(ti, clone, &tio->info);
 =09if (r =3D=3D DM_MAPIO_REMAPPED) {
 =09=09/* the bio has been remapped so dispatch it */
=20
 =09=09blk_add_trace_remap(bdev_get_queue(clone->bi_bdev), clone,
-=09=09=09=09    tio->io->bio->bi_bdev->bd_dev,
+=09=09=09=09    tio->io->data.bio->bi_bdev->bd_dev,
 =09=09=09=09    clone->bi_sector, sector);
=20
 =09=09generic_make_request(clone);
@@ -613,7 +755,10 @@ struct clone_info {
 static void dm_bio_destructor(struct bio *bio)
 {
 =09struct bio_set *bs =3D bio->bi_private;
-
+#ifdef DM_DEBUG
+=09if (bio_rq_callback(bio))
+=09=09printk(KERN_INFO "%s: bio %p\n", __FUNCTION__, bio);
+#endif
 =09bio_free(bio, bs);
 }
=20
@@ -686,6 +831,7 @@ static void __clone_and_map(struct clone_info *ci)
 =09=09clone =3D clone_bio(bio, ci->sector, ci->idx,
 =09=09=09=09  bio->bi_vcnt - ci->idx, ci->sector_count,
 =09=09=09=09  ci->md->bs);
+
 =09=09__map_bio(ti, clone, tio);
 =09=09ci->sector_count =3D 0;
=20
@@ -740,7 +886,6 @@ static void __clone_and_map(struct clone_info *ci)
 =09=09=09clone =3D split_bvec(bio, ci->sector, ci->idx,
 =09=09=09=09=09   bv->bv_offset + offset, len,
 =09=09=09=09=09   ci->md->bs);
-
 =09=09=09__map_bio(ti, clone, tio);
=20
 =09=09=09ci->sector +=3D len;
@@ -769,8 +914,8 @@ static void __split_bio(struct mapped_device *md, struct=
 bio *bio)
 =09ci.bio =3D bio;
 =09ci.io =3D alloc_io(md);
 =09ci.io->error =3D 0;
-=09atomic_set(&ci.io->io_count, 1);
-=09ci.io->bio =3D bio;
+=09atomic_set(&ci.io->parm.io_count, 1);
+=09ci.io->data.bio =3D bio;
 =09ci.io->md =3D md;
 =09ci.sector =3D bio->bi_sector;
 =09ci.sector_count =3D bio_sectors(bio);
@@ -784,6 +929,272 @@ static void __split_bio(struct mapped_device *md, stru=
ct bio *bio)
 =09dec_pending(ci.io, 0);
 =09dm_table_put(ci.map);
 }
+
+/*
+ * request cloning
+ */
+static void clone_end_request(struct request *rq, int error)
+{
+=09struct dm_target_io *tio =3D (struct dm_target_io *)rq->end_io_data;
+=09dm_request_endio_fn endio =3D tio->ti->type->rq_end_io;
+=09struct request_queue *q =3D rq->q;
+=09struct request *orig =3D tio->io->parm.orig;
+=09struct mapped_device *md =3D tio->io->md;
+=09int uptodate;
+
+=09/* Safeguard */
+=09rq->end_io =3D NULL;
+=09rq->end_io_data =3D NULL;
+
+=09if (endio)
+=09=09endio(tio->ti, rq, error, &tio->info);
+
+=09__blk_put_request(q, rq);
+
+=09if (orig) {
+=09=09spin_unlock_irq(q->queue_lock);
+=09=09uptodate =3D (error < 0)? error: !error;
+=09=09end_that_request_last(orig, uptodate);
+=09=09spin_lock_irq(q->queue_lock);
+=09}
+
+=09dec_rq_pending(tio);
+=09free_io(md, tio->io);
+=09free_tio(md, tio);
+=09free_rq(md, rq);
+}
+
+static int clone_rq_endio(struct bio *bio, unsigned int bytes, int error)
+{
+=09struct dm_target_io *tio =3D (struct dm_target_io *)bio->bi_private;
+=09struct request *clone =3D tio->io->data.req;
+=09struct request *orig =3D tio->io->parm.orig;
+=09struct mapped_device *md =3D tio->io->md;
+=09int r =3D 0, uptodate;
+=09dm_request_endio_first_fn endio =3D tio->ti->type->rq_end_io_first;
+=09dm_request_queue_in_tgt_fn queue_in_tgt =3D tio->ti->type->queue_in_tgt;
+=09struct request_queue *q =3D clone->q, *q_orig =3D orig->q;
+
+=09if (bio->bi_size)
+=09=09return 1;
+
+=09if (endio) {
+=09=09r =3D endio(tio->ti, clone, error, &tio->info);
+=09=09switch (r) {
+=09=09case 0:
+#ifdef DM_DEBUG
+=09=09=09printk(KERN_INFO "clone %p bio %p endio done\n",
+=09=09=09       clone, bio);
+#endif
+=09=09=09/* Destroy sequencer bio */
+=09=09=09bio->bi_private =3D md->bs;
+=09=09=09bio_put(bio);
+=09=09=09/* succeeded */
+=09=09=09break;
+=09=09case DM_ENDIO_INCOMPLETE:
+=09=09=09/* FIXME */
+=09=09=09printk(KERN_INFO "clone %p bio %p endio incomplete\n",
+=09=09=09       clone, bio);
+=09=09=09/* the target wants to handle the io without unmap */
+=09=09=09__blk_put_request(q, clone);
+=09=09=09clone->special =3D NULL;
+=09=09=09clone->errors =3D 0;
+
+=09=09=09if (!queue_in_tgt) {
+=09=09=09=09DMERR("queue_in_tgt isn't implemented.");
+=09=09=09=09BUG();
+=09=09=09}
+=09=09=09queue_in_tgt(tio->ti, clone, &tio->info);
+=09=09=09blk_run_queue(q_orig);
+
+=09=09=09return 0;
+=09=09case DM_ENDIO_REQUEUE:
+=09=09=09/* FIXME */
+=09=09=09printk(KERN_INFO "clone %p bio %p endio requeue\n",
+=09=09=09       clone, bio);
+=09=09=09/*
+=09=09=09 * The target wants to requeue the original request,
+=09=09=09 * unthread sequencer bio and stop bio processing.
+=09=09=09 */
+=09=09=09clone->bio =3D NULL;
+=09=09=09clone->biotail =3D clone->bio;
+=09=09=09/* Destroy sequencer bio */
+=09=09=09bio->bi_private =3D md->bs;
+=09=09=09bio_put(bio);
+=09=09=09/* Requeue original request */
+=09=09=09dm_requeue_request(q_orig, orig);
+=09=09=09break;
+=09=09default:
+=09=09=09/* FIXME */
+=09=09=09printk(KERN_INFO "clone %p bio %p endio return %d\n",
+=09=09=09       clone, bio, r);
+=09=09=09if (r >=3D 0) {
+=09=09=09=09DMWARN("unimplemented target endio return value: %d", r);
+=09=09=09=09BUG();
+=09=09=09}
+=09=09=09/* Destroy sequencer bio */
+=09=09=09bio->bi_private =3D md->bs;
+=09=09=09bio_put(bio);
+=09=09=09break;
+=09=09}
+=09}
+
+=09/*
+=09 * Finish original request
+=09 */
+=09uptodate =3D (error < 0)? error: !error;
+=09r =3D end_that_request_first(orig, uptodate,
+=09=09=09=09   orig->hard_cur_sectors);
+=09/*
+=09 * Recopy the original request fields that were updated
+=09 * in blk_end_request() to the clone.
+=09 */
+=09blk_update_cloned_rq(orig, clone);
+
+=09return r?1:0;
+}
+
+static struct bio *alloc_seq_bio(struct request *req, struct bio_set *bs)
+{
+=09struct bio *clone;
+
+=09clone =3D bio_alloc_bioset(GFP_NOIO, 0, bs);
+=09clone->bi_sector =3D 0;
+=09clone->bi_flags |=3D 1 << BIO_CLONED;
+=09clone->bi_rw |=3D (1 << BIO_RW_RQCALLBACK);
+=09clone->bi_vcnt =3D 0;
+=09clone->bi_size =3D 0;
+=09clone->bi_idx =3D 0;
+=09clone->bi_end_io =3D clone_rq_endio;
+=09bio_phys_segments(req->q, clone);
+=09bio_hw_segments(req->q, clone);
+=09clone->bi_private =3D req;
+=09clone->bi_destructor =3D dm_bio_destructor;
+=09clone->bi_flags &=3D ~(1 << BIO_SEG_VALID);
+#ifdef DM_DEBUG
+=09printk(KERN_INFO "%s: bio %p\n", __FUNCTION__, clone);
+#endif
+=09return clone;
+}
+
+static void setup_clone(struct request *clone, struct request *rq)
+{
+=09memset(clone, 0, sizeof(struct request));
+=09INIT_LIST_HEAD(&clone->queuelist);
+=09INIT_LIST_HEAD(&clone->donelist);
+=09clone->cmd_flags =3D (rq_data_dir(rq) | REQ_NOMERGE);
+=09clone->cmd_type =3D rq->cmd_type;
+=09clone->sector =3D rq->sector;
+=09clone->hard_sector =3D rq->hard_sector;
+=09clone->nr_sectors =3D rq->nr_sectors;
+=09clone->hard_nr_sectors =3D rq->hard_nr_sectors;
+=09clone->current_nr_sectors =3D rq->current_nr_sectors;
+=09clone->hard_cur_sectors =3D rq->hard_cur_sectors;
+=09clone->bio =3D rq->bio;
+=09clone->biotail =3D rq->biotail;
+=09INIT_HLIST_NODE(&clone->hash);
+=09clone->start_time =3D jiffies;
+=09clone->nr_phys_segments =3D rq->nr_phys_segments;
+=09clone->nr_hw_segments =3D rq->nr_hw_segments;
+=09clone->ioprio =3D rq->ioprio;
+=09clone->buffer =3D rq->buffer;
+=09clone->tag =3D -1;
+=09clone->ref_count =3D 1;
+=09clone->cmd_len =3D rq->cmd_len;
+=09memcpy(clone->cmd, rq->cmd, sizeof(rq->cmd));
+=09clone->data_len =3D rq->data_len;
+=09clone->sense_len =3D rq->sense_len;
+=09clone->data =3D rq->data;
+=09clone->sense =3D rq->sense;
+}
+
+static int clone_and_map_request(struct dm_target *ti, struct request *rq,
+=09=09=09=09 struct mapped_device *md)
+{
+=09int r;
+=09struct request *clone;
+=09struct dm_target_io *tio;
+
+=09tio =3D alloc_tio(md); /* only one for each original request */
+=09if (!tio)
+=09=09/* -ENOMEM, requeue */
+=09=09return 1;
+=09tio->io =3D alloc_io(md);
+=09if (!tio->io) {
+=09=09/* -ENOMEM, requeue */
+=09=09free_tio(md, tio);
+=09=09return 1;
+=09}
+=09tio->io->md =3D md;
+=09tio->io->error =3D 0;
+=09tio->ti =3D ti;
+=09memset(&tio->info, 0, sizeof(tio->info));
+
+=09clone =3D alloc_rq(md);
+=09if (!clone) {
+=09=09/* -ENOMEM, requeue */
+=09=09free_io(md, tio->io);
+=09=09free_tio(md, tio);
+=09=09return 1;
+=09}
+=09setup_clone(clone, rq);
+=09clone->bio =3D alloc_seq_bio(clone, md->bs);
+=09clone->end_io =3D clone_end_request;
+=09clone->end_io_data =3D tio;
+=09clone->bio->bi_end_io =3D clone_rq_endio;
+=09clone->bio->bi_private =3D tio;
+=09clone->bio->bi_next =3D rq->bio;
+=09tio->io->data.req =3D clone;
+=09tio->io->parm.orig =3D rq;
+
+=09atomic_inc(&md->pending);
+=09r =3D ti->type->map_rq(ti, clone, &tio->info);
+=09switch (r) {
+=09case DM_MAPIO_REMAPPED:
+#ifdef DM_DEBUG
+=09=09printk(KERN_INFO "clone %p remapped\n", clone);
+#endif
+=09=09/* the clone has been remapped so dispatch it */
+=09=09dm_dispatch_request(clone->q, clone);
+=09=09break;
+=09case DM_MAPIO_SUBMITTED:
+#ifdef DM_DEBUG
+=09=09printk(KERN_INFO "clone %p submitted\n", clone);
+#endif
+=09=09/* the target has taken the request to submit by itself */
+=09=09break;
+=09case DM_MAPIO_REQUEUE:
+=09=09printk(KERN_INFO "clone %p removed\n", clone);
+=09=09/* the target has requested to requeue the original request */
+=09=09clone->end_io =3D NULL;
+=09=09clone->end_io_data =3D NULL;
+=09=09dec_rq_pending(tio);
+=09=09free_io(md, tio->io);
+=09=09free_tio(md, tio);
+=09=09free_rq(md, clone);
+=09=09printk(KERN_INFO "requeue request %p\n", rq);
+=09=09return 1;
+=09default:
+=09=09printk(KERN_INFO "clone %p failure %d\n", clone, r);
+=09=09if (r >=3D 0) {
+=09=09=09DMWARN("unimplemented target map return value: %d", r);
+=09=09=09BUG();
+=09=09}
+=09=09clone->end_io =3D NULL;
+=09=09clone->end_io_data =3D NULL;
+
+=09=09dec_rq_pending(tio);
+=09=09free_io(md, tio->io);
+=09=09free_tio(md, tio);
+=09=09free_rq(md, clone);
+=09=09printk(KERN_INFO "kill request %p\n", rq);
+=09=09kill_request(rq);
+=09=09break;
+=09}
+
+=09return 0;
+}
+
 /*-----------------------------------------------------------------
  * CRUD END
  *---------------------------------------------------------------*/
@@ -844,6 +1255,41 @@ static int dm_request(struct request_queue *q, struct =
bio *bio)
 =09return 0;
 }
=20
+/*
+ * q->request_fn for request based dm.
+ * called with q->queue_lock held
+ */
+static void dm_request_fn(struct request_queue *q)
+{
+=09int r;
+=09struct mapped_device *md =3D (struct mapped_device *)q->queuedata;
+=09struct dm_table *map =3D dm_get_table(md);
+=09struct dm_target *ti;
+=09struct request *rq;
+
+=09while (!blk_queue_plugged(q)) {
+=09=09rq =3D elv_next_request(q);
+=09=09if (!rq)
+=09=09=09break;
+#ifdef DM_DEBUG
+=09=09printk(KERN_INFO "got request %p\n", rq);
+#endif
+=09=09ti =3D dm_table_find_target(map, rq->sector);
+
+=09=09blkdev_dequeue_request(rq);
+=09=09spin_unlock_irq(q->queue_lock);
+=09=09r =3D clone_and_map_request(ti, rq, md);
+=09=09spin_lock_irq(q->queue_lock);
+
+=09=09if (r)
+=09=09=09__dm_requeue_request(q, rq);
+=09}
+
+=09dm_table_put(map);
+
+=09return;
+}
+
 static int dm_flush_all(struct request_queue *q, struct gendisk *disk,
 =09=09=09sector_t *error_sector)
 {
@@ -870,6 +1316,30 @@ static void dm_unplug_all(struct request_queue *q)
 =09}
 }
=20
+static int dm_make_request(struct request_queue *q, struct bio *bio)
+{
+=09/*
+=09 * There is no use in forwarding any barrier request since we can't
+=09 * guarantee it is (or can be) handled by the targets correctly.
+=09 */
+=09if (unlikely(bio_barrier(bio))) {
+=09=09bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
+=09=09return 0;
+=09}
+
+=09return __make_request(q, bio);
+}
+
+static int dm_prep_rq (struct request_queue *q, struct request *req)
+{
+=09struct mapped_device *md =3D q->queuedata;
+
+=09if (test_bit(DMF_BLOCK_IO, &md->flags))
+=09=09return BLKPREP_DEFER;
+
+=09return BLKPREP_OK;
+}
+
 static int dm_any_congested(void *congested_data, int bdi_bits)
 {
 =09int r;
@@ -997,10 +1467,14 @@ static struct mapped_device *alloc_dev(int minor)
 =09atomic_set(&md->open_count, 0);
 =09atomic_set(&md->event_nr, 0);
=20
-=09md->queue =3D blk_alloc_queue(GFP_KERNEL);
+=09md->queue =3D blk_init_queue(dm_request_fn, NULL);
 =09if (!md->queue)
 =09=09goto bad1_free_minor;
=20
+=09md->queue->nr_requests =3D BLKDEV_MAX_RQ;
+=09md->queue->nr_batching =3D 32;
+=09md->queue->unplug_thresh =3D 4;
+=09md->queue->unplug_delay =3D (3 * HZ) / 1000;
 =09md->queue->queuedata =3D md;
 =09md->queue->backing_dev_info.congested_fn =3D dm_any_congested;
 =09md->queue->backing_dev_info.congested_data =3D md;
@@ -1013,9 +1487,13 @@ static struct mapped_device *alloc_dev(int minor)
 =09if (!md->io_pool)
 =09=09goto bad2;
=20
+=09md->rq_pool =3D mempool_create_slab_pool(MIN_IOS, _rq_cache);
+=09if (!md->rq_pool)
+=09=09goto bad3;
+
 =09md->tio_pool =3D mempool_create_slab_pool(MIN_IOS, _tio_cache);
 =09if (!md->tio_pool)
-=09=09goto bad3;
+=09=09goto bad4;
=20
 =09md->bs =3D bioset_create(16, 16);
 =09if (!md->bs)
@@ -1023,7 +1501,7 @@ static struct mapped_device *alloc_dev(int minor)
=20
 =09md->disk =3D alloc_disk(1);
 =09if (!md->disk)
-=09=09goto bad4;
+=09=09goto bad5;
=20
 =09atomic_set(&md->pending, 0);
 =09init_waitqueue_head(&md->wait);
@@ -1047,10 +1525,12 @@ static struct mapped_device *alloc_dev(int minor)
=20
 =09return md;
=20
- bad4:
+ bad5:
 =09bioset_free(md->bs);
  bad_no_bioset:
 =09mempool_destroy(md->tio_pool);
+ bad4:
+=09mempool_destroy(md->rq_pool);
  bad3:
 =09mempool_destroy(md->io_pool);
  bad2:
@@ -1073,6 +1553,7 @@ static void free_dev(struct mapped_device *md)
 =09=09bdput(md->suspended_bdev);
 =09}
 =09mempool_destroy(md->tio_pool);
+=09mempool_destroy(md->rq_pool);
 =09mempool_destroy(md->io_pool);
 =09bioset_free(md->bs);
 =09del_gendisk(md->disk);
@@ -1508,6 +1989,40 @@ out:
 =09return r;
 }
=20
+/*
+ * Functions to enable and disable elevator support for
+ * individual devices.
+ */
+int dm_enable_elevator(struct mapped_device *md)
+{
+=09if (md->queue->make_request_fn =3D=3D dm_make_request)
+=09=09return 0;
+
+=09blk_queue_make_request(md->queue, dm_make_request);
+=09blk_queue_prep_rq(md->queue, dm_prep_rq);
+=09md->queue->unplug_fn =3D generic_unplug_device;
+=09md->queue->backing_dev_info.congested_fn =3D NULL;
+=09md->queue->backing_dev_info.congested_data =3D NULL;
+=09set_bit(QUEUE_FLAG_CLUSTER, &md->queue->queue_flags);
+
+=09return 0;
+}
+EXPORT_SYMBOL(dm_enable_elevator);
+
+void dm_disable_elevator(struct mapped_device *md)
+{
+=09if (md->queue->make_request_fn =3D=3D dm_request)
+=09=09return;
+
+=09blk_queue_make_request(md->queue, dm_request);
+=09blk_queue_prep_rq(md->queue, NULL);
+=09md->queue->unplug_fn =3D dm_unplug_all;
+=09md->queue->backing_dev_info.congested_fn =3D dm_any_congested;
+=09md->queue->backing_dev_info.congested_data =3D md;
+=09clear_bit(QUEUE_FLAG_CLUSTER, &md->queue->queue_flags);
+}
+EXPORT_SYMBOL(dm_disable_elevator);
+
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 462ee65..57e7edb 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -112,6 +112,8 @@ int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 void dm_table_unplug_all(struct dm_table *t);
 int dm_table_flush_all(struct dm_table *t);
+int dm_table_enable_elevator(struct dm_table *t);
+void dm_table_disable_elevator(struct dm_table *t);
=20
 /*-----------------------------------------------------------------
  * A registry of target types.
@@ -182,5 +184,10 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long ele=
m_size);
 union map_info *dm_get_mapinfo(struct bio *bio);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
+void dm_dispatch_request(struct request_queue *q, struct request *rq);
+int dm_enable_elevator(struct mapped_device *md);
+void dm_disable_elevator(struct mapped_device *md);
+struct request_queue *dm_get_queue(struct mapped_device *md);
+void dm_put_queue(struct request_queue *q);
=20
 #endif
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1ddef34..cb46e30 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -152,6 +152,7 @@ struct bio {
 #define BIO_RW_FAILFAST=093
 #define BIO_RW_SYNC=094
 #define BIO_RW_META=095
+#define BIO_RW_RQCALLBACK=096=09/* Request callback */
=20
 /*
  * upper 16 bits of bi_rw define the io priority of this bio
@@ -183,6 +184,7 @@ struct bio {
 #define bio_failfast(bio)=09((bio)->bi_rw & (1 << BIO_RW_FAILFAST))
 #define bio_rw_ahead(bio)=09((bio)->bi_rw & (1 << BIO_RW_AHEAD))
 #define bio_rw_meta(bio)=09((bio)->bi_rw & (1 << BIO_RW_META))
+#define bio_rq_callback(bio)=09((bio)->bi_rw & (1 << BIO_RW_RQCALLBACK))
=20
 /*
  * will die
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b126c6f..7f72ea6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -647,6 +647,7 @@ extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
+extern int __make_request(struct request_queue *q, struct bio *bio);
 extern void blk_end_sync_rq(struct request *rq, int error);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern void blk_insert_request(struct request_queue *, struct request *, in=
t, void *);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 499f537..1e7748a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -14,6 +14,7 @@ struct dm_target;
 struct dm_table;
 struct dm_dev;
 struct mapped_device;
+struct request;
=20
 typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
=20
@@ -45,6 +46,9 @@ typedef void (*dm_dtr_fn) (struct dm_target *ti);
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 =09=09=09  union map_info *map_context);
=20
+typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clo=
ne,
+=09=09=09=09  union map_info *map_context);
+
 /*
  * Returns:
  * < 0 : error (currently ignored)
@@ -57,6 +61,18 @@ typedef int (*dm_endio_fn) (struct dm_target *ti,
 =09=09=09    struct bio *bio, int error,
 =09=09=09    union map_info *map_context);
=20
+typedef int (*dm_request_endio_first_fn) (struct dm_target *ti,
+=09=09=09=09=09  struct request *clone, int error,
+=09=09=09=09=09  union map_info *map_context);
+
+typedef int (*dm_request_endio_fn) (struct dm_target *ti,
+=09=09=09=09    struct request *clone, int error,
+=09=09=09=09    union map_info *map_context);
+
+typedef void (*dm_request_queue_in_tgt_fn) (struct dm_target *ti,
+=09=09=09=09=09    struct request *clone,
+=09=09=09=09=09    union map_info *map_context);
+
 typedef void (*dm_flush_fn) (struct dm_target *ti);
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
 typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
@@ -98,7 +114,11 @@ struct target_type {
 =09dm_ctr_fn ctr;
 =09dm_dtr_fn dtr;
 =09dm_map_fn map;
+=09dm_map_request_fn map_rq;
 =09dm_endio_fn end_io;
+=09dm_request_endio_first_fn rq_end_io_first;
+=09dm_request_endio_fn rq_end_io;
+=09dm_request_queue_in_tgt_fn queue_in_tgt;
 =09dm_flush_fn flush;
 =09dm_presuspend_fn presuspend;
 =09dm_postsuspend_fn postsuspend;

--=_7bbcgtrerlwk
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=_7bbcgtrerlwk--
