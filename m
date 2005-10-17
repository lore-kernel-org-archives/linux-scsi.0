From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC] block layer (request based) multipath
Date: Mon, 17 Oct 2005 06:08:48 -0500
Message-ID: <1129547329.3058.6.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:21922 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932267AbVJQLJO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 07:09:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com

The following patch implements a basic multipath driver at the block
layer. It uses the dm-mutlipath code and really just uses requests
instead of BIOs. I still have to finish some more trivial things like
manual path onlining, manual failover support and deciding on a
interface (currently using sysfs but I need to add some tests and locking
if I am going to keep it - will probably switch to configfs later) but the
basics are there and I wanted to get feedback before I proceed.

Why a request based multipath driver when we have MD multipath and
DM multipath at the BIO layer? Good question :)

1. I have been trying to support some of the quirks in vendor's
HW and to do this we need detailed error codes. If you look at the back
of SCSI SPEC you will notice we have a boat load of errors codes, plus we
can make up our own. And unfortunately to support special features they
have used and abused these values :) Another thing the block layer needs
is detailed error values, and I have tried to wedge the quirky vendor
specific values into them but it has not gone so well. A generic block
layer error code framework can describe a lot of errors but we cannot
get the level of details needed for multipath without making the codes too
SCSI and vendor specific.

By working at the request queue level we can use the BLOCK PC infrastructure
(and later the generic packet one) to pass back all the error info we need
for this vendor specific case. Note, for errors like transport or driver
problems or generic device failures we would use the generic block layer
codes when they are implemented.

2. Another quirk in storage boxes is the ability to manually fail over
(sometimes this is the only way to fail over too). To do
this today we are forming BLOCK PC SCSI requests from the DM multipath
hw handlers and sending them from a driver that normally works on
BIOs to the request queue.

If we move a layer down to the request level we can then have a common
code path for sending the failover request with the Read/Write requests
and we can have common code for the Read/Write and Failover vendor specific
error code evaluation. In fact, this patch was a result of me adding better
retry handling to dm-multipath for failover requests using the BLOCK PC
infrastructure.


3. Some side benefits we get from working at the request level are:
A. Reuse the request_queue queueing capabilities for retries, congestion
detection, and OOM handling (handling mempools, scheduling the next process
fairly, being able to not over queue when blocked up etc).
B. IO Scheduler is in the right place (AS or deadline on top with noop underneath).
C. Simplified path selectors since we no longer have to deal with BIOs
merging.
D. SG_IO, Tape, CD or anyplace else that used to work with requests
and could not be supported by dm-multipath can be supported - in thoery 
at least :)


The patch is made against 2.6.14-rc4. I have done some basic testing of
this patch and failover works OK. The patch needs a lot of fixups.
It is not ready for merging anywhere. And I am not asking for a formal
review (will break up the patches for reviewers later) so do not waste
your time. I am more concerned about getting feedback about the possible
problems (I know some have said wait for 2.7, but if I am going to muck around
with every block layer driver to go the error code wedging path this may
be less invasive) and if the sense code passing is a gross layer violation
or not. The hw_handler and path_selector code is from dm-multipath but was
made to work with requests and sysfs. The major new code is in blk_mpath.c and
blk_sysfs.c.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/blk_hw_handler.c linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_hw_handler.c
--- linux-2.6.14-rc4/drivers/block/blk_mpath/blk_hw_handler.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_hw_handler.c	2005-10-17 05:04:57.000000000 -0500
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005 Mike Christie All rights reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Multipath hardware handler registration.
+ */
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#include "blk_hw_handler.h"
+
+struct hwh_internal {
+	struct hw_handler_type hwht;
+
+	struct list_head list;
+	long use;
+};
+
+#define hwht_to_hwhi(__hwht) container_of((__hwht), struct hwh_internal, hwht)
+
+static LIST_HEAD(_hw_handlers);
+static DECLARE_RWSEM(_hwh_lock);
+
+static struct hwh_internal *__find_hw_handler_type(const char *name)
+{
+	struct hwh_internal *hwhi;
+
+	list_for_each_entry(hwhi, &_hw_handlers, list) {
+		if (!strcmp(name, hwhi->hwht.name))
+			return hwhi;
+	}
+
+	return NULL;
+}
+
+static struct hwh_internal *get_hw_handler(const char *name)
+{
+	struct hwh_internal *hwhi;
+
+	down_read(&_hwh_lock);
+	hwhi = __find_hw_handler_type(name);
+	if (hwhi) {
+		if ((hwhi->use == 0) && !try_module_get(hwhi->hwht.module))
+			hwhi = NULL;
+		else
+			hwhi->use++;
+	}
+	up_read(&_hwh_lock);
+
+	return hwhi;
+}
+
+struct hw_handler_type *blk_get_hw_handler(const char *name)
+{
+	struct hwh_internal *hwhi;
+
+	if (!name)
+		return NULL;
+
+	hwhi = get_hw_handler(name);
+	if (!hwhi) {
+		request_module("blk_%s", name);
+		hwhi = get_hw_handler(name);
+	}
+
+	return hwhi ? &hwhi->hwht : NULL;
+}
+
+void blk_put_hw_handler(struct hw_handler_type *hwht)
+{
+	struct hwh_internal *hwhi;
+
+	if (!hwht)
+		return;
+
+	down_read(&_hwh_lock);
+	hwhi = __find_hw_handler_type(hwht->name);
+	if (!hwhi)
+		goto out;
+
+	if (--hwhi->use == 0)
+		module_put(hwhi->hwht.module);
+
+	if (hwhi->use < 0)
+		BUG();
+
+      out:
+	up_read(&_hwh_lock);
+}
+
+static struct hwh_internal *_alloc_hw_handler(struct hw_handler_type *hwht)
+{
+	struct hwh_internal *hwhi = kmalloc(sizeof(*hwhi), GFP_KERNEL);
+
+	if (hwhi) {
+		memset(hwhi, 0, sizeof(*hwhi));
+		hwhi->hwht = *hwht;
+	}
+
+	return hwhi;
+}
+
+int blk_register_hw_handler(struct hw_handler_type *hwht)
+{
+	int r = 0;
+	struct hwh_internal *hwhi = _alloc_hw_handler(hwht);
+
+	if (!hwhi)
+		return -ENOMEM;
+
+	down_write(&_hwh_lock);
+
+	if (__find_hw_handler_type(hwht->name)) {
+		kfree(hwhi);
+		r = -EEXIST;
+	} else
+		list_add(&hwhi->list, &_hw_handlers);
+
+	up_write(&_hwh_lock);
+
+	return r;
+}
+
+int blk_unregister_hw_handler(struct hw_handler_type *hwht)
+{
+	struct hwh_internal *hwhi;
+
+	down_write(&_hwh_lock);
+
+	hwhi = __find_hw_handler_type(hwht->name);
+	if (!hwhi) {
+		up_write(&_hwh_lock);
+		return -EINVAL;
+	}
+
+	if (hwhi->use) {
+		up_write(&_hwh_lock);
+		return -ETXTBSY;
+	}
+
+	list_del(&hwhi->list);
+
+	up_write(&_hwh_lock);
+
+	kfree(hwhi);
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(blk_register_hw_handler);
+EXPORT_SYMBOL_GPL(blk_unregister_hw_handler);
diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/blk_hw_handler.h linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_hw_handler.h
--- linux-2.6.14-rc4/drivers/block/blk_mpath/blk_hw_handler.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_hw_handler.h	2005-10-17 05:07:48.000000000 -0500
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005 Mike Christie All rights reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Multipath hardware handler registration.
+ */
+
+#ifndef _BLK_HW_HANDLER_H
+#define _BLK_HW_HANDLER_H
+
+struct hw_handler_type;
+struct hw_handler {
+	struct hw_handler_type *type;
+	void *context;
+};
+
+struct attribute_group;
+struct request;
+struct path;
+
+/*
+ * Constructs a hardware handler object, takes custom arguments
+ */
+/* Information about a hardware handler type */
+struct hw_handler_type {
+	char *name;
+	struct module *module;
+
+	struct attribute_group *hw_handler_attrs;
+
+	int (*create) (struct hw_handler *handler);
+	void (*destroy) (struct hw_handler *hwh);
+
+	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,
+			 struct path *path);
+	unsigned (*complete_rq) (struct hw_handler *hwh, struct request *rq);
+};
+
+/* Register a hardware handler */
+int blk_register_hw_handler(struct hw_handler_type *type);
+
+/* Unregister a hardware handler */
+int blk_unregister_hw_handler(struct hw_handler_type *type);
+
+/* Returns a registered hardware handler type */
+struct hw_handler_type *blk_get_hw_handler(const char *name);
+
+/* Releases a hardware handler  */
+void blk_put_hw_handler(struct hw_handler_type *hwht);
+
+/* Error flags for complete_rq and dm_pg_init_complete */
+enum {
+	__MP_FAIL_PATH,		/* Fail path */
+	__MP_RETRY_PATH,	/* Retry path */
+	__MP_BYPASS_PG,		/* Try different group */
+	__MP_ERROR_IO,		/* Don't retry this I/O */
+};
+
+#define MP_FAIL_PATH	(1 << __MP_FAIL_PATH)
+#define MP_RETRY_PATH	(1 << __MP_RETRY_PATH)
+#define MP_BYPASS_PG	(1 << __MP_BYPASS_PG)
+#define MP_ERROR_IO	(1 << __MP_ERROR_IO)
+
+#endif
diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/blk_mpath.c linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_mpath.c
--- linux-2.6.14-rc4/drivers/block/blk_mpath/blk_mpath.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_mpath.c	2005-10-17 04:57:05.000000000 -0500
@@ -0,0 +1,718 @@
+/*
+ * Copyright (C) 2005 Mike Christie, All rights reserved.
+ * Copyright (C) 2003 Sistina Software Limited.
+ * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Route requests to block devices
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/file.h>
+#include <scsi/scsi_cmnd.h>
+
+#include "blk_mpath.h"
+
+struct mpath_io {
+	struct pgpath *pgpath;
+	struct request *rq_clone;
+	struct request *rq_orig;
+	/*
+	 * buffer for request completion status data (currently scsi
+	 * specific but can be fixed to fit any size or make hw_handler
+	 * specific
+	 */
+	unsigned char status[SCSI_SENSE_BUFFERSIZE];
+};
+
+static kmem_cache_t *mpio_cache;
+#define MPIO_POOL_SZ 4
+
+static void __switch_pg(struct blk_mpath *mpath, struct pgpath *pgpath)
+{
+	struct hw_handler *hwh = &mpath->hw_handler;
+
+	mpath->current_pg = pgpath->pg;
+
+	/* Must we initialise the PG first, and queue I/O till it's ready? */
+	if (hwh->type && hwh->type->pg_init) {
+		mpath->pg_init_required = 1;
+		mpath->queue_io = 1;
+	} else {
+		mpath->pg_init_required = 0;
+		mpath->queue_io = 0;
+	}
+}
+
+static int __choose_path_in_pg(struct blk_mpath *mpath,
+			       struct priority_group *pg)
+{
+	struct path *path;
+
+	path = pg->ps.type->select_path(&pg->ps, &mpath->repeat_count);
+	if (!path)
+		return -ENXIO;
+
+	mpath->current_pgpath = path_to_pgpath(path);
+
+	if (mpath->current_pg != pg)
+		__switch_pg(mpath, mpath->current_pgpath);
+
+	return 0;
+}
+
+static void __choose_pgpath(struct blk_mpath *mpath)
+{
+	struct priority_group *pg;
+	unsigned bypassed = 1;
+
+	if (!mpath->nr_valid_paths)
+		goto failed;
+
+	/* Were we instructed to switch PG? */
+	if (mpath->next_pg) {
+		pg = mpath->next_pg;
+		mpath->next_pg = NULL;
+		if (!__choose_path_in_pg(mpath, pg))
+			return;
+	}
+
+	/* Don't change PG until it has no remaining paths */
+	if (mpath->current_pg && !__choose_path_in_pg(mpath, mpath->current_pg))
+		return;
+
+	/*
+	 * Loop through priority groups until we find a valid path.
+	 * First time we skip PGs marked 'bypassed'.
+	 * Second time we only try the ones we skipped.
+	 */
+	do {
+		list_for_each_entry(pg, &mpath->priority_groups, list) {
+			if (pg->bypassed == bypassed)
+				continue;
+			if (!__choose_path_in_pg(mpath, pg))
+				return;
+		}
+	} while (bypassed--);
+
+failed:
+	mpath->current_pgpath = NULL;
+	mpath->current_pg = NULL;
+}
+
+/*
+ * Take a path out of use.
+ */
+static int fail_path(struct pgpath *pgpath)
+{
+	unsigned long flags;
+	struct blk_mpath *mpath = pgpath->pg->mpath;
+
+	spin_lock_irqsave(&mpath->path_lock, flags);
+
+	if (pgpath->state != BLK_MPATH_ACTIVE)
+		goto out;
+
+	printk(KERN_INFO "blk_mpath: Failing path\n");
+
+	pgpath->pg->ps.type->fail_path(&pgpath->pg->ps, &pgpath->path);
+	pgpath->state = BLK_MPATH_FAILED;
+	pgpath->fail_count++;
+
+	mpath->nr_valid_paths--;
+
+	if (pgpath == mpath->current_pgpath)
+		mpath->current_pgpath = NULL;
+
+	/* TODO FIRE EVENT */
+ out:
+	spin_unlock_irqrestore(&mpath->path_lock, flags);
+
+	return 0;
+}
+
+/*
+ * Temporarily try to avoid having to use the specified PG
+ */
+static void bypass_pg(struct blk_mpath *mpath, struct priority_group *pg,
+		      int bypassed)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mpath->path_lock, flags);
+
+	pg->bypassed = bypassed;
+	mpath->current_pgpath = NULL;
+	mpath->current_pg = NULL;
+
+	spin_unlock_irqrestore(&mpath->path_lock, flags);
+
+	/* TODO FIRE EVENT */
+}
+
+static void __blk_mpath_end_request(struct blk_mpath *mpath,
+				    struct mpath_io *mpio, struct request *rq,
+				    int err)
+{
+	int nr_bytes = rq->hard_nr_sectors << 9;
+
+	if (!nr_bytes)
+		nr_bytes = rq->data_len;
+
+	end_that_request_chunk(rq, err, nr_bytes);
+	end_that_request_last(rq);
+	mempool_free(mpio, mpath->mpio_pool);
+}
+
+static void blk_mpath_end_request(struct blk_mpath *mpath,
+				  struct mpath_io *mpio, struct request *rq,
+				  int err)
+{
+	struct request_queue *q = rq->q;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__blk_mpath_end_request(mpath, mpio, rq, err);
+	spin_unlock_irqrestore(q->queue_lock, flags);	
+}
+
+/*
+ * This works like the bio stacker handlers where we do not really
+ * handle partial completions (if any part of the request fails we retry
+ * the whole thing). If we decide to handle partial completions we need
+ * to fix the bio and request handling.
+ */
+static int blk_mpath_complete_first(struct request *rq, int err, int nr_bytes)
+{
+	/*
+	 * this is just the clone and we have this copied so go ahead and
+	 * change it.
+	 */
+	rq->hard_nr_sectors -= (nr_bytes >> 9);
+	return rq->hard_nr_sectors > 0 ? 1 : 0;
+}
+
+/*
+ * called with rq->q's lock held
+ */
+static void blk_mpath_complete_request(struct request *rq)
+{
+	struct mpath_io *mpio = rq->end_io_data;
+	struct blk_mpath *mpath = mpio->pgpath->pg->mpath;
+	struct hw_handler *hwh = &mpath->hw_handler;
+	struct request *rq_orig = mpio->rq_orig;
+	struct request_queue *q_orig = mpio->rq_orig->q;
+	unsigned long flags;
+	unsigned err_flags;
+	int err;
+
+	if (!rq->errors) {
+		err = 1;
+		goto complete_rq;
+	}
+
+	err_flags = MP_FAIL_PATH;
+	/*
+	 * TODO: check for different types of errors (transport, device etc)
+	 * This is where the block layer error values will come in handy.
+	 *
+	 * The hw handler just handles its device specific errors (for scsi
+	 * this would be when we have a CHECK_CONDITION for example
+	 */
+	if (hwh->type && hwh->type->complete_rq)
+		err_flags = hwh->type->complete_rq(hwh, rq);
+
+	if (mpio->pgpath) {
+		if (err_flags & MP_FAIL_PATH)
+			fail_path(mpio->pgpath);
+
+		if (err_flags & MP_BYPASS_PG)
+			bypass_pg(mpath, mpio->pgpath->pg, 1);
+	}
+
+	if (err_flags & MP_ERROR_IO) {
+		err = -EIO;
+		goto complete_rq;
+	}
+
+	spin_lock_irqsave(&mpath->path_lock, flags);
+	if (!mpath->nr_valid_paths) {
+		if (!mpath->queue_if_no_path) {
+			spin_unlock_irqrestore(&mpath->path_lock, flags);
+			err = -EIO;
+			goto complete_rq;
+		}
+	}
+        spin_unlock_irqrestore(&mpath->path_lock, flags);
+
+	mempool_free(mpio, mpath->mpio_pool);
+
+	/* free request used for clone */
+	__blk_put_request(rq->q, rq);
+
+	/* requeue original on the virtual queue */
+	spin_lock_irqsave(q_orig->queue_lock, flags);	
+	blk_requeue_request(q_orig, rq_orig);
+	blk_plug_device(q_orig);
+	spin_unlock_irqrestore(q_orig->queue_lock, flags);
+
+
+	return;
+
+ complete_rq:
+	/* free clone */
+	__blk_put_request(rq->q, rq);
+	/* complete original request */
+	blk_mpath_end_request(mpath, mpio, rq_orig, err);
+}
+
+/*
+ * This should go into ll_rw_blk.c
+ */
+struct request *blk_clone_rq(struct request *rq, struct request_queue *dest_q,
+			     gfp_t gfp_mask)
+{
+	struct request *rq_clone;
+
+	rq_clone = blk_get_request(dest_q, rq_data_dir(rq), gfp_mask);
+	if (!rq_clone)
+		return NULL;
+
+	memcpy(rq_clone->cmd, rq->cmd, sizeof(rq->cmd));
+	rq_clone->cmd_len = rq->cmd_len;
+	rq_clone->flags = rq->flags;
+	rq_clone->nr_phys_segments = rq->nr_phys_segments;
+	rq_clone->nr_hw_segments = rq->nr_hw_segments;
+	rq_clone->current_nr_sectors = rq->current_nr_sectors;
+	rq_clone->hard_cur_sectors = rq->hard_cur_sectors;
+	rq_clone->hard_nr_sectors = rq->hard_nr_sectors;
+	rq_clone->nr_sectors = rq->nr_sectors;
+	rq_clone->hard_sector = rq->hard_sector;
+	rq_clone->sector = rq->sector;
+	rq_clone->data_len = rq->data_len;
+	rq_clone->buffer = rq->buffer;
+	rq_clone->data = rq->data;
+	rq_clone->bio = rq->bio;
+	rq_clone->biotail = rq->biotail;
+	rq_clone->sense = rq->sense;
+	rq_clone->ioprio = rq->ioprio;
+
+	return rq_clone;
+}
+
+static int setup_rq(struct request *rq, struct mpath_io *mpio,
+		    struct pgpath *pgpath)
+{
+	struct request *rq_clone;
+
+	rq_clone = blk_clone_rq(rq, pgpath->path.q, GFP_ATOMIC);
+	if (!rq_clone)
+		return -ENOMEM;
+
+	/* rq->timeouts =  */
+	rq_clone->flags |= REQ_FAILFAST | REQ_NOMERGE;
+	rq_clone->rq_disk = mpio->pgpath->path.disk;
+	rq_clone->end_io_data = mpio;
+	rq_clone->end_io = blk_mpath_complete_request;	
+	rq_clone->end_io_first = blk_mpath_complete_first;
+	/*
+	 * these will be more generic with the packet layer stuff is done
+	 */
+	rq_clone->sense = mpio->status;
+	rq_clone->sense_len = 0;
+
+	mpio->rq_clone = rq_clone;
+	mpio->rq_orig = rq;
+
+	return 0;
+}
+
+static int route_io(struct blk_mpath *mpath, struct request *rq,
+		  struct mpath_io *mpio)
+{
+	int r = 0;
+	unsigned long flags;
+	struct pgpath *pgpath;
+
+	spin_lock_irqsave(&mpath->path_lock, flags);
+
+	/* Do we need to select a new pgpath? */
+	if (!mpath->current_pgpath ||
+	    (!mpath->queue_io &&
+	     (mpath->repeat_count && --mpath->repeat_count == 0)))
+		__choose_pgpath(mpath);
+
+	pgpath = mpath->current_pgpath;
+	if ((pgpath && mpath->queue_io) ||
+	    (!pgpath && mpath->queue_if_no_path)) {
+		/*
+		 * Block layer requeue. Will run queue when we get
+		 * get a path, timeout, or manual intervention
+		 */
+		blk_stop_queue(mpath->q);
+		r = 1;
+	} else if (!pgpath)
+		/* Fatal Failure */
+		r = -EIO;
+	else {
+		mpio->pgpath = pgpath;
+		r = setup_rq(rq, mpio, pgpath);
+	}
+
+	spin_unlock_irqrestore(&mpath->path_lock, flags);
+
+	return r;
+}
+
+/*
+ * called with q's lock held
+ */
+static void blk_mpath_request_fn(struct request_queue *q)
+{
+	struct blk_mpath *mpath = q->queuedata;
+	struct request *rq;
+	struct mpath_io *mpio;
+	int err;
+
+	while ((rq = elv_next_request(q)) != NULL) {
+		mpio = mempool_alloc(mpath->mpio_pool, GFP_ATOMIC);
+		if (!mpio)
+			goto plug_queue;
+		memset(mpio, 0, sizeof(*mpio));
+
+		err = route_io(mpath, rq, mpio);
+		switch (err) {
+			case 0:
+				/* success */
+				break;
+			case -ENOMEM:
+			case 1:
+				/* requeue */
+				goto free_mpio;
+			default:
+				/* fatal error */
+				blkdev_dequeue_request(rq);
+				__blk_mpath_end_request(mpath, mpio, rq, -EIO);
+				continue;
+		}
+
+		blkdev_dequeue_request(rq);
+		/*
+		 * TODO: we need something similar to the generic_make_request
+		 * so we can insert into any queue. Since this is not a
+		 * major feature just insert it to the one below us for now
+		 *
+		 * Drop the higher lock and grab the lower queue lock.
+		 */
+		spin_unlock_irq(q->queue_lock);
+		elv_add_request(mpio->rq_clone->q, mpio->rq_clone,
+				ELEVATOR_INSERT_BACK, 1);
+		spin_lock_irq(q->queue_lock);
+	}
+
+	return;
+
+ free_mpio:
+	mempool_free(mpio, mpath->mpio_pool);
+ plug_queue:
+	blk_plug_device(q);
+	return;
+}
+
+static int blk_mpath_major;
+
+static int blk_mpath_open(struct inode *inode, struct file *file)
+{
+	struct blk_mpath *mpath;
+
+	mpath = inode->i_bdev->bd_disk->private_data;
+	if (!class_device_get(&mpath->cdev))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int blk_mpath_close(struct inode *inode, struct file *file)
+{
+	struct blk_mpath *mpath;
+
+	mpath = inode->i_bdev->bd_disk->private_data;
+	class_device_put(&mpath->cdev);
+	return 0;
+}
+
+static struct block_device_operations blk_mpath_ops = {
+	.open = blk_mpath_open,
+	.release = blk_mpath_close,
+	.owner = THIS_MODULE,
+};
+
+struct blk_mpath *blk_mpath_create_dev(const char *name)
+{
+	struct request_queue *q;
+	struct blk_mpath *mpath;
+	struct gendisk *disk;
+
+	mpath = kzalloc(sizeof(*mpath), GFP_KERNEL);
+	if (!mpath)
+		return NULL;
+
+	INIT_LIST_HEAD(&mpath->priority_groups);
+	spin_lock_init(&mpath->path_lock);
+	mpath->state = BLK_MPATH_CREATED;
+	mpath->nr_valid_paths = 0;
+	mpath->mpio_pool = mempool_create(MPIO_POOL_SZ, mempool_alloc_slab,
+					  mempool_free_slab, mpio_cache);
+	if (!mpath->mpio_pool)
+		goto free_mpath;
+
+	q = blk_init_queue(blk_mpath_request_fn, NULL);
+	if (!q)
+		goto free_mpool;
+
+	mpath->q = q;
+	q->queuedata = mpath;
+
+	blk_mpath_major = register_blkdev(0, "mp");
+	if (blk_mpath_major < 0)
+		goto free_queue;
+
+	disk = alloc_disk(1);
+	if (!disk)
+		goto unreg_blkdev;
+
+	mpath->disk = disk;
+	disk->queue = q;
+	disk->major = blk_mpath_major;
+	disk->fops = &blk_mpath_ops;
+	disk->private_data = mpath;
+	sprintf(disk->disk_name, "mp-%s", name);
+
+	return mpath;
+
+ unreg_blkdev:
+	unregister_blkdev(blk_mpath_major, "mp");
+ free_queue:
+	blk_cleanup_queue(q);
+ free_mpool:
+	mempool_destroy(mpath->mpio_pool);
+ free_mpath:
+	kfree(mpath);
+	return NULL;
+}
+
+void blk_mpath_start_dev(struct blk_mpath *mpath)
+{
+	if (mpath->state != BLK_MPATH_CREATED)
+		return;
+
+	mpath->state = BLK_MPATH_ACTIVE;
+	add_disk(mpath->disk);
+}
+
+void blk_mpath_free_dev(struct blk_mpath *mpath)
+{
+	blk_mpath_free_hwh(&mpath->hw_handler);
+
+	if (mpath->state != BLK_MPATH_CREATED)
+		del_gendisk(mpath->disk);
+	blk_cleanup_queue(mpath->q);
+	put_disk(mpath->disk);
+	unregister_blkdev(blk_mpath_major, "mp");
+	mempool_destroy(mpath->mpio_pool);
+	kfree(mpath);
+}
+
+struct priority_group *blk_mpath_create_pg(struct blk_mpath *mpath)
+{
+	struct priority_group *pg;
+	unsigned long flags;
+
+	pg = kzalloc(sizeof(*pg), GFP_KERNEL);
+	if (!pg)
+		return NULL;
+
+	INIT_LIST_HEAD(&pg->pgpaths);
+	INIT_LIST_HEAD(&pg->list);
+	pg->mpath = mpath;
+	pg->state = BLK_MPATH_CREATED;
+
+	spin_lock_irqsave(&mpath->path_lock, flags);
+	mpath->nr_priority_groups++;
+	list_add_tail(&pg->list, &mpath->priority_groups);
+	spin_unlock_irqrestore(&mpath->path_lock, flags);
+
+	return pg;
+}
+
+void blk_mpath_free_pg(struct priority_group *pg)
+{
+	struct blk_mpath *mpath = pg->mpath;
+	struct path_selector *ps = &pg->ps;
+	unsigned long flags;
+
+	blk_mpath_free_ps(ps);
+
+	spin_lock_irqsave(&mpath->path_lock, flags);
+	list_del(&pg->list);
+	mpath->nr_priority_groups--;
+	spin_unlock_irqrestore(&mpath->path_lock, flags);
+
+	kfree(pg);
+}
+
+struct pgpath *blk_mpath_create_pgpath(struct priority_group *pg, int fd)
+{
+	struct blk_mpath *mpath = pg->mpath;
+	struct path_selector *ps = &pg->ps;
+	struct block_device *bdev;
+	struct pgpath *pgpath;	
+	struct file *file;
+	unsigned long flags;
+
+	pgpath = kzalloc(sizeof(*pgpath), GFP_KERNEL);
+	if (!pgpath)
+		return NULL;
+
+	INIT_LIST_HEAD(&pgpath->list);
+	pgpath->pg = pg;
+	pgpath->state = BLK_MPATH_ACTIVE;
+
+	file = fget(fd);
+	if (!file) {
+		printk(KERN_ERR "Could not get fd %d\n", fd);
+		goto free_pgpath;
+	}
+	bdev = file->f_dentry->d_inode->i_bdev;
+	pgpath->path.q = bdev_get_queue(bdev);
+	pgpath->path.disk = bdev->bd_disk;
+	pgpath->file = file;
+
+	if (ps->type)
+		ps->type->add_path(ps, &pgpath->path);
+
+	set_capacity(mpath->disk, get_capacity(bdev->bd_disk));
+	blk_queue_stack_limits(mpath->q, pgpath->path.q);
+
+	spin_lock_irqsave(&mpath->path_lock, flags);
+	mpath->nr_valid_paths++;
+	pg->nr_pgpaths++;
+	list_add_tail(&pgpath->list, &pg->pgpaths);
+	spin_unlock_irqrestore(&mpath->path_lock, flags);
+
+	return pgpath;
+
+ free_pgpath:
+	kfree(pgpath);
+	return NULL;
+}
+
+void blk_mpath_free_pgpath(struct pgpath *pgpath)
+{
+	struct blk_mpath *mpath = pgpath->pg->mpath;
+	unsigned long flags;
+
+	fput(pgpath->file);
+
+	spin_lock_irqsave(&mpath->path_lock, flags);
+	list_del(&pgpath->list);
+	kfree(pgpath);
+	spin_unlock_irqrestore(&mpath->path_lock, flags);
+}
+
+struct path_selector *blk_mpath_create_ps(struct priority_group *pg,
+					  const char *name)
+{
+	struct path_selector_type *pst;
+	int err;
+
+	pst = blk_get_path_selector(name);
+	if (!pst) {
+		printk(KERN_ERR "Could not get path selector %s\n", name);
+		return NULL;
+	}
+
+	err = pst->create(&pg->ps);
+	if (err)
+		goto put_ps;
+
+	pg->ps.type = pst;
+	return &pg->ps;
+
+ put_ps:
+        blk_put_path_selector(pst);
+        return NULL;
+
+}
+
+void blk_mpath_free_ps(struct path_selector *ps)
+{
+	if (ps->type) {
+		ps->type->destroy(ps);
+		blk_put_path_selector(ps->type);
+	}
+}
+
+struct hw_handler *blk_mpath_create_hwh(struct blk_mpath *mpath,
+					const char *name)
+{
+	struct hw_handler_type *hwht;
+	int err;
+
+	hwht = blk_get_hw_handler(name);
+	if (!hwht) {
+		printk(KERN_ERR "Could not get hw handler %s\n", name);
+		return NULL;
+	}
+
+	err = hwht->create(&mpath->hw_handler);
+	if (err)
+		goto put_hwh;
+
+	mpath->hw_handler.type = hwht;
+	return &mpath->hw_handler;
+
+ put_hwh:
+	blk_put_hw_handler(hwht);
+	return NULL;
+}
+
+void blk_mpath_free_hwh(struct hw_handler *hwh)
+{
+	if (hwh->type) {
+		hwh->type->destroy(hwh);
+		blk_put_hw_handler(hwh->type);
+	}
+}
+
+int __init blk_mpath_init(void)
+{
+	int err;
+
+	mpio_cache = kmem_cache_create("blk_mpath", sizeof(struct mpath_io),
+				       0, 0, NULL, NULL);
+	if (!mpio_cache)
+		return -ENOMEM;
+
+	err = blk_mpath_sysfs_init();
+	if (err)
+		kmem_cache_destroy(mpio_cache);
+
+	return err;
+}
+
+void __exit blk_mpath_exit(void)
+{
+	blk_mpath_sysfs_exit();
+	kmem_cache_destroy(mpio_cache);
+}
+
+module_init(blk_mpath_init);
+module_exit(blk_mpath_exit);
+
+MODULE_AUTHOR("Mike Christie");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("route requests");
diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/blk_mpath.h linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_mpath.h
--- linux-2.6.14-rc4/drivers/block/blk_mpath/blk_mpath.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_mpath.h	2005-10-17 05:06:33.000000000 -0500
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) 2005 Mike Christie, All rights reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Route requests to block devices and handle lower level block driver
+ * errors. This works with a dm target, which handles the redriving of IO.
+ */
+
+#ifndef _BLK_MPATH_H
+#define _BLK_MPATH_H
+
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/mempool.h>
+
+#include "blk_path_selector.h"
+#include "blk_hw_handler.h"
+
+struct request_queue;
+struct gendisk;
+struct file;
+struct blk_mpath;
+
+enum {
+	BLK_MPATH_CREATED,
+	BLK_MPATH_ACTIVE,
+	BLK_MPATH_FAILED,
+	BLL_MPATH_BYPASSED,
+	BLK_MPATH_REMOVED,
+};
+
+struct path {
+	struct request_queue *q;/* Read-only */
+	struct gendisk *disk;	/* Read-only */
+	unsigned is_active;	/* Read-only */
+
+	void *pscontext;	/* For path-selector use */
+	void *hwhcontext;	/* For hw-handler use */
+};
+
+/* Path properties */
+struct pgpath {
+	struct list_head list;
+	int state;
+
+	struct file *file;
+
+	struct priority_group *pg;	/* Owning PG */
+	unsigned fail_count;		/* Cumulative failure count */
+
+	struct path path;
+	struct kobject kobj;
+};
+
+#define path_to_pgpath(__pgp) \
+	container_of((__pgp), struct pgpath, path)
+
+/*
+ * Paths are grouped into Priority Groups and numbered from 1 upwards.
+ * Each has a path selector which controls which path gets used.
+ */
+struct priority_group {
+	struct list_head list;
+	int state;
+
+	struct blk_mpath *mpath;		/* Owning multipath instance */
+	struct path_selector ps;
+
+	unsigned pg_num;		/* Reference number */
+	unsigned bypassed;		/* Temporarily bypass this PG? */
+
+	unsigned nr_pgpaths;		/* Number of paths in PG */
+	struct list_head pgpaths;
+
+	struct kobject kobj;
+};
+
+struct blk_mpath {
+	struct request_queue *q;
+	struct gendisk *disk;
+	struct class_device cdev;
+
+	int state;
+
+	spinlock_t path_lock;		/* protects paths and groups */
+	struct list_head priority_groups;
+	unsigned nr_priority_groups;
+
+	struct hw_handler hw_handler;
+
+	unsigned pg_init_required;	/* pg_init needs calling? */
+	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
+
+	unsigned nr_valid_paths;	/* Total number of usable paths */
+	struct pgpath *current_pgpath;
+	struct priority_group *current_pg;
+	struct priority_group *next_pg;	/* Switch to this PG if set */
+	unsigned repeat_count;		/* I/Os left before calling PS again */
+
+	unsigned queue_io;		/* Must we queue all I/O? */
+	unsigned queue_if_no_path;	/* Queue I/O if last path fails? */
+	unsigned saved_queue_if_no_path; /* Saved state during suspension */
+
+	mempool_t *mpio_pool;
+};
+
+/* mpath dev fns */
+extern void blk_mpath_free_dev(struct blk_mpath *mpath);
+extern struct blk_mpath *blk_mpath_create_dev(const char *name);
+extern void blk_mpath_start_dev(struct blk_mpath *mpath);
+/* priority groups fns */
+extern struct priority_group *blk_mpath_create_pg(struct blk_mpath *mpath);
+extern void blk_mpath_free_pg(struct priority_group *pg);
+/* path fns */
+extern struct pgpath *blk_mpath_create_pgpath(struct priority_group *pg,
+					      int fd);
+extern void blk_mpath_free_pgpath(struct pgpath *pgpath);
+/* path selector fns */
+extern struct path_selector *blk_mpath_create_ps(struct priority_group *pg,
+						 const char *name);
+extern void blk_mpath_free_ps(struct path_selector *ps);
+/* hw handler fns */
+extern struct hw_handler *blk_mpath_create_hwh(struct blk_mpath *mpath,
+					       const char *name);
+extern void blk_mpath_free_hwh(struct hw_handler *hwh);
+
+extern int blk_mpath_sysfs_init(void);
+extern void blk_mpath_sysfs_exit(void);
+
+#endif
diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/blk_path_selector.c linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_path_selector.c
--- linux-2.6.14-rc4/drivers/block/blk_mpath/blk_path_selector.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_path_selector.c	2005-10-17 04:56:01.000000000 -0500
@@ -0,0 +1,158 @@
+/*
+ * Copyright (C) 2003 Sistina Software.
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005 Mike Christie All rights reserved.
+ *
+ * Module Author: Heinz Mauelshagen
+ *
+ * This file is released under the GPL.
+ *
+ * Path selector registration.
+ */
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#include "blk_path_selector.h"
+
+struct ps_internal {
+	struct path_selector_type pst;
+
+	struct list_head list;
+	long use;
+};
+
+#define pst_to_psi(__pst) container_of((__pst), struct ps_internal, pst)
+
+static LIST_HEAD(_path_selectors);
+static DECLARE_RWSEM(_ps_lock);
+
+static struct ps_internal *__find_path_selector_type(const char *name)
+{
+	struct ps_internal *psi;
+
+	list_for_each_entry(psi, &_path_selectors, list) {
+		if (!strcmp(name, psi->pst.name))
+			return psi;
+	}
+
+	return NULL;
+}
+
+static struct ps_internal *get_path_selector(const char *name)
+{
+	struct ps_internal *psi;
+
+	down_read(&_ps_lock);
+	psi = __find_path_selector_type(name);
+	if (psi) {
+		if ((psi->use == 0) && !try_module_get(psi->pst.module))
+			psi = NULL;
+		else
+			psi->use++;
+	}
+	up_read(&_ps_lock);
+
+	return psi;
+}
+
+struct path_selector_type *blk_get_path_selector(const char *name)
+{
+	struct ps_internal *psi;
+
+	if (!name)
+		return NULL;
+
+	psi = get_path_selector(name);
+	if (!psi) {
+		request_module("blk_%s", name);
+		psi = get_path_selector(name);
+	}
+
+	return psi ? &psi->pst : NULL;
+}
+
+void blk_put_path_selector(struct path_selector_type *pst)
+{
+	struct ps_internal *psi;
+
+	if (!pst)
+		return;
+
+	down_read(&_ps_lock);
+	psi = __find_path_selector_type(pst->name);
+	if (!psi)
+		goto out;
+
+	if (--psi->use == 0)
+		module_put(psi->pst.module);
+
+	if (psi->use < 0)
+		BUG();
+
+out:
+	up_read(&_ps_lock);
+}
+
+static struct ps_internal *_alloc_path_selector(struct path_selector_type *pst)
+{
+	struct ps_internal *psi = kmalloc(sizeof(*psi), GFP_KERNEL);
+
+	if (psi) {
+		memset(psi, 0, sizeof(*psi));
+		psi->pst = *pst;
+	}
+
+	return psi;
+}
+
+int blk_register_path_selector(struct path_selector_type *pst)
+{
+	int r = 0;
+	struct ps_internal *psi = _alloc_path_selector(pst);
+
+	if (!psi)
+		return -ENOMEM;
+
+	down_write(&_ps_lock);
+
+	if (__find_path_selector_type(pst->name)) {
+		kfree(psi);
+		r = -EEXIST;
+	} else
+		list_add(&psi->list, &_path_selectors);
+
+	up_write(&_ps_lock);
+
+	return r;
+}
+
+int blk_unregister_path_selector(struct path_selector_type *pst)
+{
+	struct ps_internal *psi;
+
+	down_write(&_ps_lock);
+
+	psi = __find_path_selector_type(pst->name);
+	if (!psi) {
+		up_write(&_ps_lock);
+		return -EINVAL;
+	}
+
+	if (psi->use) {
+		up_write(&_ps_lock);
+		return -ETXTBSY;
+	}
+
+	list_del(&psi->list);
+
+	up_write(&_ps_lock);
+
+	kfree(psi);
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(blk_register_path_selector);
+EXPORT_SYMBOL_GPL(blk_unregister_path_selector);
diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/blk_path_selector.h linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_path_selector.h
--- linux-2.6.14-rc4/drivers/block/blk_mpath/blk_path_selector.h	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_path_selector.h	2005-10-17 05:08:00.000000000 -0500
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) 2003 Sistina Software.
+ * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005 Mike Christie All rights reserved.
+ *
+ * Module Author: Heinz Mauelshagen
+ *
+ * This file is released under the GPL.
+ *
+ * Path-Selector registration.
+ */
+
+#ifndef _BLK_PATH_SELECTOR_H
+#define _BLK_PATH_SELECTOR_H
+
+struct attribute_group;
+struct module;
+struct path;
+
+/*
+ * We provide an abstraction for the code that chooses which path
+ * to send some io down.
+ */
+struct path_selector_type;
+struct path_selector {
+	struct path_selector_type *type;
+	void *context;
+};
+
+/* Information about a path selector type */
+struct path_selector_type {
+	char *name;
+	struct module *module;
+
+	/*
+	 * path selector specific attributes
+	 */
+	struct attribute_group *path_selector_attrs;
+
+	int (*create) (struct path_selector *ps);
+	void (*destroy) (struct path_selector *ps);
+
+	/*
+	 * path selector path specific attributes
+	 */
+	struct attribute_group *path_attrs;
+	int (*add_path) (struct path_selector *ps, struct path *path);
+
+	/*
+	 * Chooses a path for this io, if no paths are available then
+	 * NULL will be returned.
+	 *
+	 * repeat_count is the number of times to use the path before
+	 * calling the function again.  0 means don't call it again unless
+	 * the path fails.
+	 */
+	struct path *(*select_path) (struct path_selector *ps,
+				     unsigned *repeat_count);
+
+	/*
+	 * Notify the selector that a path has failed.
+	 */
+	void (*fail_path) (struct path_selector *ps, struct path *p);
+
+	/*
+	 * Ask selector to reinstate a path.
+	 */
+	int (*reinstate_path) (struct path_selector *ps, struct path *p);
+	int (*end_io) (struct path_selector *ps, struct path *path);
+};
+
+/* Register a path selector */
+int blk_register_path_selector(struct path_selector_type *type);
+
+/* Unregister a path selector */
+int blk_unregister_path_selector(struct path_selector_type *type);
+
+/* Returns a registered path selector type */
+struct path_selector_type *blk_get_path_selector(const char *name);
+
+/* Releases a path selector  */
+void blk_put_path_selector(struct path_selector_type *pst);
+
+#endif
diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/blk_round_robin.c linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_round_robin.c
--- linux-2.6.14-rc4/drivers/block/blk_mpath/blk_round_robin.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_round_robin.c	2005-10-17 04:56:01.000000000 -0500
@@ -0,0 +1,182 @@
+/*
+ * Copyright (C) 2003 Sistina Software.
+ * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005 Mike Christie All rights reserved.
+ *
+ * Module Author: Heinz Mauelshagen
+ *
+ * This file is released under the GPL.
+ *
+ * Round-robin path selector.
+ */
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#include "blk_mpath.h"
+#include "blk_path_selector.h"
+
+/*-----------------------------------------------------------------
+ * Path-handling code, paths are held in lists
+ *---------------------------------------------------------------*/
+struct path_info {
+	struct list_head list;
+	struct path *path;
+	unsigned repeat_count;
+};
+
+static void free_paths(struct list_head *paths)
+{
+	struct path_info *pi, *next;
+
+	list_for_each_entry_safe(pi, next, paths, list) {
+		list_del(&pi->list);
+		kfree(pi);
+	}
+}
+
+/*-----------------------------------------------------------------
+ * Round-robin selector
+ *---------------------------------------------------------------*/
+
+#define RR_MIN_IO		1000
+
+struct selector {
+	struct list_head valid_paths;
+	struct list_head invalid_paths;
+};
+
+static struct selector *alloc_selector(void)
+{
+	struct selector *s = kmalloc(sizeof(*s), GFP_KERNEL);
+
+	if (s) {
+		INIT_LIST_HEAD(&s->valid_paths);
+		INIT_LIST_HEAD(&s->invalid_paths);
+	}
+
+	return s;
+}
+
+static int rr_create(struct path_selector *ps)
+{
+	struct selector *s;
+
+	s = alloc_selector();
+	if (!s)
+		return -ENOMEM;
+
+	ps->context = s;
+	return 0;
+}
+
+static void rr_destroy(struct path_selector *ps)
+{
+	struct selector *s = ps->context;
+
+	free_paths(&s->valid_paths);
+	free_paths(&s->invalid_paths);
+	kfree(s);
+	ps->context = NULL;
+}
+
+/*
+ * Called during initialisation to register each path with an
+ * optional repeat_count.
+ */
+static int rr_add_path(struct path_selector *ps, struct path *path)
+{
+	struct selector *s = ps->context;
+	struct path_info *pi;
+	unsigned repeat_count = RR_MIN_IO;
+
+	/* allocate the path */
+	pi = kmalloc(sizeof(*pi), GFP_KERNEL);
+	if (!pi) {
+		printk(KERN_ERR "round-robin ps: Error allocating path "
+		      "context\n");
+		return -ENOMEM;
+	}
+
+	pi->path = path;
+	pi->repeat_count = repeat_count;
+
+	path->pscontext = pi;
+
+	list_add(&pi->list, &s->valid_paths);
+
+	return 0;
+}
+
+static void rr_fail_path(struct path_selector *ps, struct path *p)
+{
+	struct selector *s = ps->context;
+	struct path_info *pi = p->pscontext;
+
+	list_move(&pi->list, &s->invalid_paths);
+}
+
+static int rr_reinstate_path(struct path_selector *ps, struct path *p)
+{
+	struct selector *s = ps->context;
+	struct path_info *pi = p->pscontext;
+
+	list_move(&pi->list, &s->valid_paths);
+
+	return 0;
+}
+
+static struct path *rr_select_path(struct path_selector *ps,
+				   unsigned *repeat_count)
+{
+	struct selector *s = ps->context;
+	struct path_info *pi = NULL;
+
+	if (!list_empty(&s->valid_paths)) {
+		pi = list_entry(s->valid_paths.next, struct path_info, list);
+		list_move_tail(&pi->list, &s->valid_paths);
+		*repeat_count = pi->repeat_count;
+	}
+
+	return pi ? pi->path : NULL;
+}
+
+static struct path_selector_type rr_ps = {
+	.name = "round_robin",
+	.module = THIS_MODULE,
+	.create = rr_create,
+	.destroy = rr_destroy,
+	.add_path = rr_add_path,
+	.fail_path = rr_fail_path,
+	.reinstate_path = rr_reinstate_path,
+	.select_path = rr_select_path,
+	/*
+	 * TODO add attribute_group attrs for custom interface
+	 */
+};
+
+static int __init blk_rr_init(void)
+{
+	int r;
+
+	r = blk_register_path_selector(&rr_ps);
+	if (r < 0)
+		printk(KERN_ERR "round_robin: register failed %d\n", r);
+	return r;
+}
+
+static void __exit blk_rr_exit(void)
+{
+	int r;
+
+	r = blk_unregister_path_selector(&rr_ps);
+	if (r < 0)
+		printk(KERN_ERR "round-robin: unregister failed %d\n", r);
+}
+
+module_init(blk_rr_init);
+module_exit(blk_rr_exit);
+
+MODULE_DESCRIPTION("round-robin multipath path selector");
+MODULE_AUTHOR("Sistina Software <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/blk_sysfs.c linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_sysfs.c
--- linux-2.6.14-rc4/drivers/block/blk_mpath/blk_sysfs.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/blk_sysfs.c	2005-10-17 04:58:14.000000000 -0500
@@ -0,0 +1,413 @@
+/*
+ * Copyright (C) 2005 Mike Christie, All rights reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * sysfs inteface
+ */
+
+#include <linux/blkdev.h>
+
+#include "blk_mpath.h"
+
+static ssize_t remove_pgpath(struct pgpath *pgpath, const char *buf,
+			     size_t count)
+{
+	sysfs_remove_link(&pgpath->kobj, "queue");
+	kobject_unregister(&pgpath->kobj);
+	return count;
+}
+
+struct pgpath_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct pgpath *, char *);
+	ssize_t (*store)(struct pgpath *, const char *, size_t);
+};
+
+static struct pgpath_attr remove_path_attr = {
+	.attr = {.name = "remove", .mode = S_IWUSR },
+	.store = remove_pgpath,
+};
+
+static struct attribute *pgpath_attrs[] = {
+	&remove_path_attr.attr,
+	NULL,
+};
+
+#define to_pgpath_attr(_a) \
+	container_of(_a, struct pgpath_attr, attr)
+
+#define kobj_to_pgpath(_k) \
+	container_of(_k, struct pgpath, kobj)
+
+static ssize_t pgpath_attr_show(struct kobject *kobj, struct attribute *attr,
+				char *buf)
+{
+	struct pgpath_attr *_attr = to_pgpath_attr(attr);
+	struct pgpath *pgpath = kobj_to_pgpath(kobj);
+
+	pgpath = kobj_to_pgpath(kobj);
+        if (!_attr->show)
+                return -EINVAL;
+
+        return _attr->show(pgpath, buf);
+}
+
+static ssize_t pgpath_attr_store(struct kobject *kobj, struct attribute *attr,
+				 const char *buf, size_t count)
+{
+        struct pgpath_attr *_attr = to_pgpath_attr(attr);
+        struct pgpath *pgpath = kobj_to_pgpath(kobj);
+
+        if (!_attr->store)
+                return -EINVAL;
+
+        return _attr->store(pgpath, buf, count);
+}
+
+static struct sysfs_ops pgpath_ops = {
+	.show = pgpath_attr_show,
+	.store = pgpath_attr_store,
+};
+
+static void release_pgpath(struct kobject *kobj)
+{
+	struct pgpath *pgpath = kobj_to_pgpath(kobj);
+	struct priority_group *pg = pgpath->pg;
+
+	blk_mpath_free_pgpath(pgpath);
+	kobject_put(&pg->kobj);
+}
+
+static struct kobj_type pgpath_ktype = {
+	.sysfs_ops = &pgpath_ops,
+	.default_attrs = pgpath_attrs,
+	.release = release_pgpath,
+};
+
+static ssize_t create_pgpath(struct priority_group *pg, const char *buf,
+			     size_t count)
+{
+	struct pgpath *pgpath;
+	struct kobject *kobj;
+	int err, fd;
+
+	if (sscanf(buf, "%d\n", &fd) != 1) {
+		printk(KERN_ERR "Invalid fd %s\n", buf);
+		return -EINVAL;
+	}
+
+	pgpath = blk_mpath_create_pgpath(pg, fd);
+	if (!pgpath)
+		return -ENOMEM;
+
+	kobj = &pgpath->kobj;
+	kobj->parent = kobject_get(&pg->kobj);
+	snprintf(kobj->name, KOBJ_NAME_LEN, "pgpath-%u", pg->nr_pgpaths);
+	kobj->ktype = &pgpath_ktype;
+
+	err = kobject_register(kobj);
+	if (err)
+		goto free_pgpath;
+
+	/* not critical */
+	sysfs_create_link(kobj, &pgpath->path.q->kobj, "queue");
+
+	return count;
+
+ free_pgpath:
+	blk_mpath_free_pgpath(pgpath);
+	return err;
+}
+
+static ssize_t remove_pg(struct priority_group *pg, const char *buf,
+			 size_t count)
+{
+	struct path_selector *ps = &pg->ps;
+
+	if (ps->type && ps->type->path_selector_attrs)
+		sysfs_remove_group(&pg->kobj, ps->type->path_selector_attrs);
+	kobject_unregister(&pg->kobj);
+	return count;
+}
+
+static ssize_t create_ps(struct priority_group *pg, const char *buf,
+			 size_t count)
+{
+	struct path_selector *ps;
+	int err;
+
+	/*
+	 * support swap later
+	 */
+	if (pg->ps.type)
+		return -EINVAL;
+
+	ps = blk_mpath_create_ps(pg, buf);
+	if (!ps)
+		return -EINVAL;
+
+	if (ps->type->path_selector_attrs) {
+		err = sysfs_create_group(&pg->kobj,
+					 ps->type->path_selector_attrs);	
+		if (err)
+			goto destroy_ps;
+	}
+
+	return count;
+
+ destroy_ps:
+	blk_mpath_free_ps(ps);
+	return err;
+}
+
+static ssize_t show_ps(struct priority_group *pg, char *buf)
+{
+	if (!pg->ps.type)
+		return sprintf(buf, "none\n");
+	else
+		return sprintf(buf, "%s\n", pg->ps.type->name);
+}
+
+struct priority_group_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct priority_group *, char *);
+	ssize_t (*store)(struct priority_group *, const char *, size_t);
+};
+
+static struct priority_group_attr create_path_attr = {
+	.attr = {.name = "create_path", .mode = S_IWUSR },
+	.store = create_pgpath,
+};
+
+static struct priority_group_attr remove_pg_attr = {
+	.attr = {.name = "remove", .mode = S_IWUSR },
+	.store = remove_pg,
+};
+
+static struct priority_group_attr path_selector_attr = {
+	.attr = {.name = "path_selector", .mode = S_IRUGO | S_IWUSR },
+	.store = create_ps,
+	.show = show_ps,
+};
+
+static struct attribute *priority_group_attrs[] = {
+	&create_path_attr.attr,
+	&remove_pg_attr.attr,
+	&path_selector_attr.attr,
+	NULL,
+};
+
+#define to_pg_attr(_a) \
+	container_of(_a, struct priority_group_attr, attr)
+
+#define kobj_to_pg(_k) \
+	container_of(_k, struct priority_group, kobj)
+
+static ssize_t pg_attr_show(struct kobject *kobj, struct attribute *attr,
+			    char *buf)
+{
+	struct priority_group_attr *_attr = to_pg_attr(attr);
+	struct priority_group *pg = kobj_to_pg(kobj);
+
+	pg = kobj_to_pg(kobj);
+        if (!_attr->show)
+                return -EINVAL;
+
+        return _attr->show(pg, buf);
+}
+
+static ssize_t pg_attr_store(struct kobject *kobj, struct attribute *attr,
+			     const char *buf, size_t count)
+{
+        struct priority_group_attr *_attr = to_pg_attr(attr);
+        struct priority_group *pg = kobj_to_pg(kobj);
+
+        if (!_attr->store)
+                return -EINVAL;
+
+        return _attr->store(pg, buf, count);
+}
+
+static struct sysfs_ops priority_group_ops = {
+	.show = pg_attr_show,
+	.store = pg_attr_store,
+};
+
+static void release_pg(struct kobject *kobj)
+{
+	struct priority_group *pg = kobj_to_pg(kobj);
+	struct blk_mpath *mpath = pg->mpath;
+
+	blk_mpath_free_pg(pg);
+	kobject_put(&mpath->cdev.kobj);
+}
+
+static struct kobj_type priority_group_ktype = {
+	.sysfs_ops = &priority_group_ops,
+	.default_attrs = priority_group_attrs,
+	.release = release_pg,
+};
+
+#define cdev_to_mpath(_cdev) \
+	container_of(_cdev, struct blk_mpath, cdev)
+
+static ssize_t create_pg(struct class_device *cdev, const char *buf,
+			 size_t count)
+{
+	struct blk_mpath *mpath = cdev_to_mpath(cdev);
+	struct priority_group *pg;
+	struct kobject *kobj;
+	int err;
+
+	pg = blk_mpath_create_pg(mpath);
+	if (!pg)
+		return -ENOMEM;
+
+	kobj = &pg->kobj;
+	kobj->parent = kobject_get(&mpath->cdev.kobj);
+	snprintf(kobj->name, KOBJ_NAME_LEN, "pg-%u", mpath->nr_priority_groups);
+	kobj->ktype = &priority_group_ktype;
+
+	err = kobject_register(kobj);
+	if (err)
+		goto free_pg;
+
+	return count;
+
+ free_pg:
+	blk_mpath_free_pg(pg);
+	return err;
+}
+
+static CLASS_DEVICE_ATTR(create_group, S_IWUSR, NULL, create_pg);
+
+static ssize_t create_hw_handler(struct class_device *cdev, const char *buf,
+				 size_t count)
+{
+	struct blk_mpath *mpath = cdev_to_mpath(cdev);
+	struct hw_handler *hwh;
+	int err;
+
+	hwh = blk_mpath_create_hwh(mpath, buf);
+	if (!hwh)
+		return -EINVAL;
+
+	if (hwh->type->hw_handler_attrs) {
+		err = sysfs_create_group(&mpath->cdev.kobj,
+					 hwh->type->hw_handler_attrs);	
+		if (err)
+			goto free_hwh;
+	}
+
+	return count;
+
+ free_hwh:
+	blk_mpath_free_hwh(hwh);
+	return err;
+}
+
+static CLASS_DEVICE_ATTR(create_hw_handler, S_IWUSR, NULL,
+			 create_hw_handler);
+
+static ssize_t start_dev(struct class_device *cdev, const char *buf,
+			 size_t count)
+{
+	blk_mpath_start_dev(cdev_to_mpath(cdev));
+	return count;
+}
+
+static CLASS_DEVICE_ATTR(start_dev, S_IWUSR, NULL, start_dev);
+
+static ssize_t remove_mpath(struct class_device *cdev, const char *buf,
+			    size_t count);
+static CLASS_DEVICE_ATTR(remove_dev, S_IWUSR, NULL, remove_mpath);
+
+static struct attribute *blk_mpath_atts[] = {
+	&class_device_attr_create_group.attr,
+	&class_device_attr_create_hw_handler.attr,
+	&class_device_attr_remove_dev.attr,
+	&class_device_attr_start_dev.attr,
+	NULL
+};
+
+static struct attribute_group blk_mpath_attr_group = {
+	.attrs = blk_mpath_atts,
+};
+
+static ssize_t remove_mpath(struct class_device *cdev, const char *buf,
+			    size_t count)
+{
+	struct blk_mpath *mpath = cdev_to_mpath(cdev);
+	struct hw_handler *hwh = &mpath->hw_handler;
+
+	if (hwh->type && hwh->type->hw_handler_attrs)
+		sysfs_remove_group(&mpath->cdev.kobj,
+				   hwh->type->hw_handler_attrs);
+	sysfs_remove_group(&cdev->kobj, &blk_mpath_attr_group);
+	class_device_unregister(cdev);
+	return count;
+}
+
+static void release_mpath(struct class_device *cdev)
+{
+	blk_mpath_free_dev(cdev_to_mpath(cdev));
+}
+
+static struct class blk_mpath_class = {
+	.name = "blk_mpath",
+	.release = release_mpath,
+};
+
+static ssize_t create_mpath(struct class *class_dev, const char *buf,
+			    size_t count)
+{
+	struct blk_mpath *mpath;
+	struct class_device *cdev;
+	int err;
+
+	mpath = blk_mpath_create_dev(buf);
+	if (!mpath)
+		return -ENOMEM;
+
+	cdev = &mpath->cdev;
+	cdev->class = &blk_mpath_class;
+	snprintf(cdev->class_id, BUS_ID_SIZE, "mpath-%s", buf);
+
+	err = class_device_register(cdev);
+	if (err) {
+		blk_mpath_free_dev(mpath);
+		return err;
+	}
+
+	err = sysfs_create_group(&cdev->kobj, &blk_mpath_attr_group);
+	if (err) {
+		class_device_unregister(cdev);
+		return err;
+	}
+
+	return count;
+}
+
+static CLASS_ATTR(create_dev, S_IWUSR, NULL, create_mpath);
+
+int __init blk_mpath_sysfs_init(void)
+{
+	int err;
+
+	err = class_register(&blk_mpath_class);
+	if (err)
+		return err;
+
+	err = class_create_file(&blk_mpath_class, &class_attr_create_dev);
+	if (err)
+		class_unregister(&blk_mpath_class);
+
+	return err;
+}
+
+void __exit blk_mpath_sysfs_exit(void)
+{
+	class_remove_file(&blk_mpath_class, &class_attr_create_dev);
+	class_unregister(&blk_mpath_class);
+}
diff -Naurp linux-2.6.14-rc4/drivers/block/blk_mpath/Makefile linux-2.6.14-rc4.work/drivers/block/blk_mpath/Makefile
--- linux-2.6.14-rc4/drivers/block/blk_mpath/Makefile	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.14-rc4.work/drivers/block/blk_mpath/Makefile	2005-10-17 04:56:01.000000000 -0500
@@ -0,0 +1,7 @@
+#
+# Makefile for block layer multipath
+#
+
+obj-$(CONFIG_BLK_MPATH) += blk_multipath.o blk_round_robin.o
+blk_multipath-objs := blk_mpath.o blk_sysfs.o blk_hw_handler.o \
+			blk_path_selector.o
diff -Naurp linux-2.6.14-rc4/drivers/block/Kconfig linux-2.6.14-rc4.work/drivers/block/Kconfig
--- linux-2.6.14-rc4/drivers/block/Kconfig	2005-10-10 20:19:19.000000000 -0500
+++ linux-2.6.14-rc4.work/drivers/block/Kconfig	2005-10-17 04:55:42.000000000 -0500
@@ -464,4 +464,10 @@ config ATA_OVER_ETH
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.
 
+config BLK_MPATH
+	tristate "Block Layer Multipath"
+	depends on DM_MULTIPATH
+	help
+	  This driver provides the low level multipath handling
+
 endmenu
diff -Naurp linux-2.6.14-rc4/drivers/block/ll_rw_blk.c linux-2.6.14-rc4.work/drivers/block/ll_rw_blk.c
--- linux-2.6.14-rc4/drivers/block/ll_rw_blk.c	2005-10-10 20:19:19.000000000 -0500
+++ linux-2.6.14-rc4.work/drivers/block/ll_rw_blk.c	2005-10-17 04:55:42.000000000 -0500
@@ -287,6 +287,7 @@ static inline void rq_init(request_queue
 	rq->nr_phys_segments = 0;
 	rq->sense = NULL;
 	rq->end_io = NULL;
+	rq->end_io_first = NULL;
 	rq->end_io_data = NULL;
 }
 
@@ -2298,6 +2299,7 @@ void blk_execute_rq_nowait(request_queue
 	rq->rq_disk = bd_disk;
 	rq->flags |= REQ_NOMERGE;
 	rq->end_io = done;
+
 	elv_add_request(q, rq, where, 1);
 	generic_unplug_device(q);
 }
@@ -2445,7 +2447,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2473,6 +2475,8 @@ static void __blk_put_request(request_qu
 	}
 }
 
+EXPORT_SYMBOL(__blk_put_request);
+
 void blk_put_request(struct request *req)
 {
 	/*
@@ -3110,6 +3114,9 @@ static int __end_that_request_first(stru
 	int total_bytes, bio_nbytes, error, next_idx = 0;
 	struct bio *bio;
 
+	if (req->end_io_first)
+		return req->end_io_first(req, uptodate, nr_bytes);
+
 	/*
 	 * extend uptodate bool to allow < 0 value to be direct io error
 	 */
diff -Naurp linux-2.6.14-rc4/drivers/block/Makefile linux-2.6.14-rc4.work/drivers/block/Makefile
--- linux-2.6.14-rc4/drivers/block/Makefile	2005-10-10 20:19:19.000000000 -0500
+++ linux-2.6.14-rc4.work/drivers/block/Makefile	2005-10-17 04:55:42.000000000 -0500
@@ -45,3 +45,4 @@ obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 
+obj-$(CONFIG_BLK_MPATH)		+= blk_mpath/
diff -Naurp linux-2.6.14-rc4/drivers/scsi/scsi_lib.c linux-2.6.14-rc4.work/drivers/scsi/scsi_lib.c
--- linux-2.6.14-rc4/drivers/scsi/scsi_lib.c	2005-10-10 20:19:19.000000000 -0500
+++ linux-2.6.14-rc4.work/drivers/scsi/scsi_lib.c	2005-10-17 04:55:35.000000000 -0500
@@ -833,7 +833,8 @@ void scsi_io_completion(struct scsi_cmnd
 		if (sense_valid)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
-	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
+	/* SG_IO ioctl from block level or blk_mpath */
+	if (blk_pc_request(req) || blk_extended_err(req)) {
 		req->errors = result;
 		if (result) {
 			clear_errors = 0;
diff -Naurp linux-2.6.14-rc4/include/linux/blkdev.h linux-2.6.14-rc4.work/include/linux/blkdev.h
--- linux-2.6.14-rc4/include/linux/blkdev.h	2005-10-10 20:19:19.000000000 -0500
+++ linux-2.6.14-rc4.work/include/linux/blkdev.h	2005-10-17 04:55:42.000000000 -0500
@@ -103,6 +103,7 @@ void swap_io_context(struct io_context *
 
 struct request;
 typedef void (rq_end_io_fn)(struct request *);
+typedef int (rq_end_first_fn)(struct request *, int, int);
 
 struct request_list {
 	int count[2];
@@ -194,6 +195,7 @@ struct request {
 	 * completion callback. end_io_data should be folded in with waiting
 	 */
 	rq_end_io_fn *end_io;
+	rq_end_first_fn *end_io_first;
 	void *end_io_data;
 };
 
@@ -446,6 +448,7 @@ enum {
 #define blk_pc_request(rq)	((rq)->flags & REQ_BLOCK_PC)
 #define blk_noretry_request(rq)	((rq)->flags & REQ_FAILFAST)
 #define blk_rq_started(rq)	((rq)->flags & REQ_STARTED)
+#define blk_extended_err(rq)	(blk_noretry_request(rq) && rq->sense)
 
 #define blk_account_rq(rq)	(blk_rq_started(rq) && blk_fs_request(rq))
 
@@ -548,6 +551,7 @@ extern void blk_unregister_queue(struct 
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
+extern void __blk_put_request(request_queue_t *, struct request *);
 extern void blk_end_sync_rq(struct request *rq);
 extern void blk_attempt_remerge(request_queue_t *, struct request *);
 extern struct request *blk_get_request(request_queue_t *, int, int);
@@ -569,6 +573,7 @@ extern int blk_rq_map_kern(request_queue
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *, struct sg_iovec *, int);
 extern int blk_execute_rq(request_queue_t *, struct gendisk *,
 			  struct request *, int);
+
 static inline request_queue_t *bdev_get_queue(struct block_device *bdev)
 {
 	return bdev->bd_disk->queue;


