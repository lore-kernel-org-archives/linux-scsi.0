From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RFC PATCH 3/4] convert dm-multipath to blkerr error values
Date: Wed, 24 Aug 2005 04:04:27 -0500
Message-ID: <1124874267.10888.20.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:979 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750795AbVHXJEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 05:04:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, axboe@suse.de, linux-scsi@vger.kernel.org

Ok here is a first pass at converting dm-multipath.
I have tested with some software iSCSI drivers.

The next step is to move the sense code in dm-emc
to scsi. One possible problem is coming up with
a BLKERR value that will give dm-multipath the same
info as MP_BYPASS_PG.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -94,8 +94,11 @@ struct multipath {
 struct mpath_io {
 	struct pgpath *pgpath;
 	struct dm_bio_details details;
+	int retries;
 };
 
+#define MPIO_MAX_RETRIES 5
+
 typedef int (*action_fn) (struct pgpath *pgpath);
 
 #define MIN_IOS 256	/* Mempool size */
@@ -370,7 +373,7 @@ static void dispatch_queued_ios(struct m
 
 		r = map_io(m, bio, mpio, 1);
 		if (r < 0)
-			bio_endio(bio, bio->bi_size, r);
+			bio_endio(bio, bio->bi_size, BLKERR_IO);
 		else if (r == 1)
 			generic_make_request(bio);
 
@@ -781,6 +784,7 @@ static int multipath_map(struct dm_targe
 
 	mpio = mempool_alloc(m->mpio_pool, GFP_NOIO);
 	dm_bio_record(&mpio->details, bio);
+	mpio->retries = 0;
 
 	map_context->ptr = mpio;
 	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
@@ -988,6 +992,20 @@ void dm_pg_init_complete(struct path *pa
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
+/* queue for the daemon to resubmit or fail */
+static void requeue_io(struct multipath *m, struct bio *bio,
+		       struct mpath_io *mpio)
+{
+	dm_bio_restore(&mpio->details, bio);
+
+	spin_lock(&m->lock);
+	bio_list_add(&m->queued_ios, bio);
+	m->queue_size++;
+	if (!m->queue_io)
+		queue_work(kmultipathd, &m->process_queued_ios);
+	spin_unlock(&m->lock);
+}
+
 /*
  * end_io handling
  */
@@ -997,20 +1015,11 @@ static int do_end_io(struct multipath *m
 	struct hw_handler *hwh = &m->hw_handler;
 	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
 
-	if (!error)
-		return 0;	/* I/O complete */
-
-	if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
-		return error;
-
-	if (error == -EOPNOTSUPP)
-		return error;
-
 	spin_lock(&m->lock);
 	if (!m->nr_valid_paths) {
 		if (!m->queue_if_no_path) {
 			spin_unlock(&m->lock);
-			return -EIO;
+			return BLKERR_FATAL_DEV;
 		} else {
 			spin_unlock(&m->lock);
 			goto requeue;
@@ -1030,20 +1039,11 @@ static int do_end_io(struct multipath *m
 	}
 
 	if (err_flags & MP_ERROR_IO)
-		return -EIO;
+		return BLKERR_FATAL_DEV;
 
-      requeue:
-	dm_bio_restore(&mpio->details, bio);
-
-	/* queue for the daemon to resubmit or fail */
-	spin_lock(&m->lock);
-	bio_list_add(&m->queued_ios, bio);
-	m->queue_size++;
-	if (!m->queue_io)
-		queue_work(kmultipathd, &m->process_queued_ios);
-	spin_unlock(&m->lock);
-
-	return 1;	/* io not complete */
+requeue:
+	requeue_io(m, bio, mpio);	
+	return -1;	/* io not complete */
 }
 
 static int multipath_end_io(struct dm_target *ti, struct bio *bio,
@@ -1053,15 +1053,40 @@ static int multipath_end_io(struct dm_ta
 	struct mpath_io *mpio = (struct mpath_io *) map_context->ptr;
 	struct pgpath *pgpath = mpio->pgpath;
 	struct path_selector *ps;
-	int r;
+	int r = error;
+
+	switch (error) {
+	case BLK_SUCCESS:
+		break;
+	case BLKERR_NOTSUPP:
+		break;
+	case BLKERR_WOULDBLOCK:
+		if (bio_rw_ahead(bio))
+			break;
+	case BLKERR_RETRY_DRV:
+	case BLKERR_RETRY_DEV:
+	case BLKERR_RETRY_XPT:
+		/*
+		 * this should be modifiable, we should also add some
+		 * counters to indicate how many error we have on this
+		 * path.
+		 */
+		if (mpio->retries++ < MPIO_MAX_RETRIES) {
+			requeue_io(m, bio, mpio);
+			r = -1;
+			break;
+		} else
+			r = BLKERR_FATAL_DEV;
+	default:
+		r  = do_end_io(m, bio, error, mpio);
+	}
 
-	r  = do_end_io(m, bio, error, mpio);
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path);
 	}
-	if (r <= 0)
+	if (r != -1)
 		mempool_free(mpio, m->mpio_pool);
 
 	return r;


