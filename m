From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 3/5] blk_end_request: dynamic load
 balancing for request-based dm-multipath
Date: Fri, 31 Aug 2007 18:45:28 -0400 (EDT)
Message-ID: <20070831.184528.31636876.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch adds dynamic load balancer to request-based dm-multipath.

Request-based dm itself is still under development and not ready
for inclusion.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/Makefile           |    3
 drivers/md/dm-adaptive.c      |  369 ++++++++++++++++++++++++++++++++++++++++++ drivers/md/dm-load-balance.c  |  342 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-mpath.c         |   32 ++-
 drivers/md/dm-path-selector.h |    7
 drivers/md/dm-round-robin.c   |    2
 drivers/md/dm.c               |    4
 include/linux/device-mapper.h |    3
 8 files changed, 742 insertions(+), 20 deletions(-)

diff -rupN a2-rqdm-mpath/drivers/md/dm-adaptive.c a3-rqdm-mpath-dlb/drivers/md/dm-adaptive.c
--- a2-rqdm-mpath/drivers/md/dm-adaptive.c	1969-12-31 19:00:00.000000000 -0500
+++ a3-rqdm-mpath-dlb/drivers/md/dm-adaptive.c	2007-08-28 16:41:34.000000000 -0400
@@ -0,0 +1,369 @@
+/*
+ * Copyright (C) 2007 NEC Corporation.  All Rights Reserved.
+ * dm-adaptive.c
+ *
+ * Module Author: Kiyoshi Ueda
+ *
+ * This file is released under the GPL.
+ *
+ * Adaptive path selector.
+ */
+
+#include "dm.h"
+#include "dm-path-selector.h"
+
+#define DM_MSG_PREFIX	"multipath adaptive"
+#define AD_MIN_IO	100
+#define AD_VERSION	"0.2.0"
+
+struct selector {
+//	spinlock_t lock;
+	struct list_head valid_paths;
+	struct list_head failed_paths;
+};
+
+struct path_info {
+	struct list_head list;
+	struct dm_path *path;
+	unsigned int repeat_count;
+
+	atomic_t in_flight;	/* Total size of in-flight I/Os */
+	size_t perf;		/* Recent performance of the path */
+	sector_t last_sectors;	/* Total sectors of the last disk_stat_read */
+	size_t last_io_ticks;	/* io_ticks of the last disk_stat_read */
+
+	size_t rqsz[2];		/* Size of the last request.  For Debug */
+};
+
+static void free_paths(struct list_head *paths)
+{
+	struct path_info *pi, *next;
+
+	list_for_each_entry_safe(pi, next, paths, list) {
+		list_del(&pi->list);
+		pi->path->pscontext = NULL;
+		kfree(pi);
+	}
+}
+
+static struct selector *alloc_selector(void)
+{
+	struct selector *s = kmalloc(sizeof(*s), GFP_KERNEL);
+
+	if (s) {
+		memset(s, 0, sizeof(*s));
+		INIT_LIST_HEAD(&s->valid_paths);
+		INIT_LIST_HEAD(&s->failed_paths);
+//		s->lock = SPIN_LOCK_UNLOCKED;
+	}
+
+	return s;
+}
+
+static int ad_create(struct path_selector *ps, unsigned argc, char **argv)
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
+static void ad_destroy(struct path_selector *ps)
+{
+	struct selector *s = (struct selector *) ps->context;
+
+	free_paths(&s->valid_paths);
+	free_paths(&s->failed_paths);
+	kfree(s);
+	ps->context = NULL;
+}
+
+static int ad_status(struct path_selector *ps, struct dm_path *path,
+			status_type_t type, char *result, unsigned int maxlen)
+{
+	struct path_info *pi;
+	int sz = 0;
+
+	if (!path)
+		DMEMIT("0 ");
+	else {
+		pi = (struct path_info *) path->pscontext;
+		if (!pi)
+			BUG();
+
+		switch (type) {
+		case STATUSTYPE_INFO:
+			DMEMIT("if:%08lu pf:%06lu rsR:%06lu rsW:%06lu ",
+				(unsigned long) atomic_read(&pi->in_flight),
+				pi->perf,
+				pi->rqsz[READ], pi->rqsz[WRITE]);
+			break;
+		case STATUSTYPE_TABLE:
+			DMEMIT("%u ", pi->repeat_count);
+			break;
+		}
+	}
+
+	return sz;
+}
+
+/*
+ * Note: Assuming IRQs are enabled when this function gets called.
+ */
+static int ad_add_path(struct path_selector *ps, struct dm_path *path,
+			int argc, char **argv, char **error)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi;
+	unsigned int repeat_count = AD_MIN_IO;
+	struct gendisk *disk = path->dev->bdev->bd_disk;
+
+	if (argc > 1) {
+		*error = "adaptive ps: incorrect number of arguments";
+		return -EINVAL;
+	}
+
+	/* First path argument is number of I/Os before switching path. */
+	if ((argc == 1) && (sscanf(argv[0], "%u", &repeat_count) != 1)) {
+		*error = "adaptive ps: invalid repeat count";
+		return -EINVAL;
+	}
+
+	/* allocate the path */
+	pi = kmalloc(sizeof(*pi), GFP_KERNEL);
+	if (!pi) {
+		*error = "adaptive ps: Error allocating path context";
+		return -ENOMEM;
+	}
+
+	pi->path = path;
+	pi->repeat_count = repeat_count;
+
+	pi->perf = 0;
+	pi->last_sectors = disk_stat_read(disk, sectors[READ])
+			   + disk_stat_read(disk, sectors[WRITE]);
+	pi->last_io_ticks = disk_stat_read(disk, io_ticks);
+	atomic_set(&pi->in_flight, 0);
+	pi->rqsz[READ]  = pi->rqsz[WRITE]  = 0;
+
+	path->pscontext = pi;
+
+//	spin_lock_irq(&s->lock);
+	list_add_tail(&pi->list, &s->valid_paths);
+//	spin_unlock_irq(&s->lock);
+
+	return 0;
+}
+
+/*
+ * Note: Called with IRQ disabled from mpath.c/fail_path().
+ */
+static void ad_fail_path(struct path_selector *ps, struct dm_path *p)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi = (struct path_info *) p->pscontext;
+
+//	spin_lock(&s->lock);
+	list_move(&pi->list, &s->failed_paths);
+//	spin_unlock(&s->lock);
+}
+
+/*
+ * Notes: Called with IRQ disabled from mpath.c/reinstate_path().
+ */
+static int ad_reinstate_path(struct path_selector *ps, struct dm_path *p)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi = (struct path_info *) p->pscontext;
+
+	if(!pi)
+		BUG();
+
+//	spin_lock(&s->lock);
+	list_move_tail(&pi->list, &s->valid_paths);
+//	spin_unlock(&s->lock);
+
+	return 0;
+}
+
+static void stats_update(struct path_info *pi)
+{
+	sector_t sectors;
+	size_t io_ticks, tmp;
+	struct gendisk *disk = pi->path->dev->bdev->bd_disk;
+
+	sectors = disk_stat_read(disk, sectors[READ])
+		  + disk_stat_read(disk, sectors[WRITE]);
+	io_ticks = disk_stat_read(disk, io_ticks);
+
+	if ((sectors != pi->last_sectors) && (io_ticks != pi->last_io_ticks)) {
+		tmp = (sectors - pi->last_sectors) << 9;
+		do_div(tmp, jiffies_to_msecs((io_ticks - pi->last_io_ticks)));
+		pi->perf = tmp;
+
+		pi->last_sectors = sectors;
+		pi->last_io_ticks = io_ticks;
+	}
+}
+
+static int ad_compare_load(struct path_info *pi1, struct path_info *pi2,
+			   size_t new_io)
+{
+	size_t if1, if2;
+//	size_t st1, st2;
+
+	if1 = atomic_read(&pi1->in_flight);
+	if2 = atomic_read(&pi2->in_flight);
+
+	/*
+	 * Case 1: No performace data available. Choose less loaded path.
+	 */
+	if (!pi1->perf || !pi2->perf)
+		return if1 - if2;
+
+	/*
+	 * Case 2: Calculate service time. Choose faster path.
+	 *           if ((if1+new_io)/pi1->perf < (if2+new_io)/pi2->perf) pi1.
+	 *           if ((if1+new_io)/pi1->perf > (if2+new_io)/pi2->perf) pi2.
+	 *         To avoid do_div(), use
+	 *           if ((if1+new_io)*pi2->perf < (if2+new_io)*pi1->perf) pi1.
+	 *           if ((if1+new_io)*pi2->perf > (if2+new_io)*pi1->perf) pi2.
+	 */
+//	st1 = (if2 + new_io) * pi1->perf;
+//	st2 = (if1 + new_io) * pi2->perf;
+//	st1 = (if2) * pi1->perf;
+//	st2 = (if1) * pi2->perf;
+	if1 = (if1 + new_io) << 10;
+	if2 = (if2 + new_io) << 10;
+	do_div(if1, pi1->perf);
+	do_div(if2, pi2->perf);
+
+//	if (st1 != st2)
+//		return (st2 < st1) ? -1 : 1;
+	if (if1 != if2)
+		return if1 - if2;
+
+	/*
+	 * Case 3: Service time is equal. Choose faster path.
+	 */
+	return pi2->perf - pi1->perf;
+}
+
+static struct dm_path *ad_select_path(struct path_selector *ps,
+				   unsigned int *repeat_count, size_t nr_bytes)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi, *best = NULL;
+//	unsigned long flags;
+
+	if (!s)
+		BUG();
+	if (!repeat_count)
+		BUG();
+
+//	spin_lock_irqsave(&s->lock, flags);
+	if (list_empty(&s->valid_paths)) {
+//		spin_unlock_irqrestore(&s->lock, flags);
+		printk(KERN_INFO "adaptive ps: no valid paths.\n");
+		return NULL;
+	}
+
+	/* Change preferred (first in list) path to evenly balance. */
+	list_move_tail(s->valid_paths.next, &s->valid_paths);
+
+	/* Update performance information before best path selection */
+	list_for_each_entry(pi, &s->valid_paths, list) {
+		stats_update(pi);
+	}
+
+	list_for_each_entry(pi, &s->valid_paths, list) {
+		if (!best)
+			best = pi;
+		else {
+			if (ad_compare_load(pi, best, nr_bytes) < 0)
+				best = pi;
+		}
+	}
+//	spin_unlock_irqrestore(&s->lock, flags);
+
+	if (best) {
+		*repeat_count = best->repeat_count;
+		return best->path;
+	}
+
+	return NULL;
+}
+
+static int ad_start_io(struct path_selector *ps, struct dm_path *p,
+			struct request *clone)
+{
+	struct path_info *pi = (struct path_info *) p->pscontext;
+	int rw = rq_data_dir(clone);
+
+	/* Update debug information */
+	pi->rqsz[rw] = clone->nr_sectors << 9;
+
+	atomic_add(clone->nr_sectors << 9, &pi->in_flight);
+
+	return 0;
+}
+
+static int ad_end_io(struct path_selector *ps, struct dm_path *p,
+			struct request *clone, int nr_bytes)
+{
+	struct path_info *pi = (struct path_info *) p->pscontext;
+
+	atomic_sub(nr_bytes, &pi->in_flight);
+
+	return 0;
+}
+
+static struct path_selector_type ad_ps = {
+	.name		= "adaptive",
+	.module		= THIS_MODULE,
+	.table_args	= 1,
+	.info_args	= 4,
+	.create		= ad_create,
+	.destroy	= ad_destroy,
+	.status		= ad_status,
+	.add_path	= ad_add_path,
+	.fail_path	= ad_fail_path,
+	.reinstate_path	= ad_reinstate_path,
+	.select_path	= ad_select_path,
+	.start_io	= ad_start_io,
+	.end_io		= ad_end_io,
+};
+
+static int __init dm_ad_init(void)
+{
+	int r = dm_register_path_selector(&ad_ps);
+
+	if (r < 0)
+		DMERR("adaptive: register failed %d", r);
+
+	DMINFO("dm-adaptive version " AD_VERSION " loaded");
+
+	return r;
+}
+
+static void __exit dm_ad_exit(void)
+{
+	int r = dm_unregister_path_selector(&ad_ps);
+
+	if (r < 0)
+		DMERR("adaptive: unregister failed %d", r);
+}
+
+module_init(dm_ad_init);
+module_exit(dm_ad_exit);
+
+MODULE_DESCRIPTION(
+	"Copyright (C) 2007 NEC Corporation.  All Rights Reserved.\n"
+	DM_NAME " Adaptive path selector (dm-adaptive.c version AD_VERSION)"
+);
+MODULE_AUTHOR("Kiyoshi Ueda <k-ueda@ct.jp.nec.com>");
+MODULE_LICENSE("GPL");
diff -rupN a2-rqdm-mpath/drivers/md/dm.c a3-rqdm-mpath-dlb/drivers/md/dm.c
--- a2-rqdm-mpath/drivers/md/dm.c	2007-08-29 14:33:31.000000000 -0400
+++ a3-rqdm-mpath-dlb/drivers/md/dm.c	2007-08-29 14:33:34.000000000 -0400
@@ -829,7 +829,7 @@ static int clone_end_request(struct requ
 		error = !uptodate ? -EIO : uptodate;
 
 	if (endio_first) {
-		r = endio_first(tio->ti, clone, error, &tio->info);
+		r = endio_first(tio->ti, clone, error, nr_bytes, &tio->info);
 		switch (r) {
 		case 0:
 			/* succeeded */
@@ -1357,7 +1357,7 @@ static void dm_request_fn(struct request
 
 		ti = dm_table_find_target(map, rq->sector);
 		congested = ti->type->congested;
-		if (congested && congested(ti))
+		if (congested && congested(ti, rq->nr_sectors << 9))
 			break;
 
 		blkdev_dequeue_request(rq);
diff -rupN a2-rqdm-mpath/drivers/md/dm-load-balance.c a3-rqdm-mpath-dlb/drivers/md/dm-load-balance.c
--- a2-rqdm-mpath/drivers/md/dm-load-balance.c	1969-12-31 19:00:00.000000000 -0500
+++ a3-rqdm-mpath-dlb/drivers/md/dm-load-balance.c	2007-08-28 16:41:34.000000000 -0400
@@ -0,0 +1,342 @@
+/*
+ * (C) Copyright IBM Corp. 2004,2005    All Rights Reserved.
+ * dm-load-balance.c
+ *
+ * Module Author: Stefan Bader
+ *
+ * This file is released under the GPL.
+ *
+ * Load balancing path selector.
+ */
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <asm/atomic.h>
+
+#include "dm.h"
+#include "dm-path-selector.h"
+
+#define DM_MSG_PREFIX	"multipath load-balance"
+#define LB_MIN_IO	128
+#define LB_VERSION	"0.1.0"
+
+struct selector {
+	spinlock_t		lock;
+	struct list_head	valid_paths;
+	struct list_head	failed_paths;
+};
+
+struct path_info {
+	struct list_head	list;
+	struct dm_path *	path;
+	unsigned int		repeat_count;
+	atomic_t		load;
+};
+
+static struct selector *alloc_selector(void)
+{
+	struct selector *	s;
+
+	if ((s = kmalloc(sizeof(*s), GFP_KERNEL)) != NULL) {
+		memset(s, 0, sizeof(*s));
+		INIT_LIST_HEAD(&s->valid_paths);
+		INIT_LIST_HEAD(&s->failed_paths);
+		s->lock = SPIN_LOCK_UNLOCKED;
+	}
+
+	return s;
+}
+
+static inline void free_selector(struct selector *s)
+{
+	kfree(s);
+}
+
+static int lb_create(struct path_selector *ps, unsigned argc, char **argv)
+{
+	struct selector *	s;
+
+	if ((s = alloc_selector()) == NULL)
+		return -ENOMEM;
+
+	ps->context = s;
+
+	return 0;
+}
+
+static void lb_free_paths(struct list_head *paths)
+{
+	struct path_info *	cpi;
+	struct path_info *	npi;
+
+	list_for_each_entry_safe(cpi, npi, paths, list) {
+		list_del(&cpi->list);
+		cpi->path->pscontext = NULL;
+		kfree(cpi);
+	}
+}
+
+static void lb_destroy(struct path_selector *ps)
+{
+	struct selector *	s;
+
+	s = (struct selector *) ps->context;
+	lb_free_paths(&s->valid_paths);
+	lb_free_paths(&s->failed_paths);
+	free_selector(s);
+	ps->context = NULL;
+}
+
+/*
+ * Note: Assuming IRQs are enabled when this function gets called.
+ */
+static int
+lb_add_path(
+	struct path_selector *	ps,
+	struct dm_path *	path,
+	int			argc,
+	char **			argv,
+	char **			error)
+{
+	struct selector *	s;
+	struct path_info *	pi;
+	unsigned int		repeat_count;
+
+	s = (struct selector *) ps->context;
+
+	/* Parse the arguments */
+	if (argc > 1) {
+		*error = "dm-load-balance: incorrect number of arguments";
+		return -EINVAL;
+	}
+
+	/* First path argument is number of I/Os before switching path. */
+	repeat_count = LB_MIN_IO;
+	if (argc > 0) {
+		if (sscanf(argv[0], "%u", &repeat_count) != 1) {
+			*error = "load-balance ps: invalid repeat count";
+			return -EINVAL;
+		}
+	}
+
+	/* Allocate the path information structure */
+	if ((pi = kmalloc(sizeof(*pi), GFP_KERNEL)) == NULL) {
+		*error = "dm-load-balance: Error allocating path information";
+		return -ENOMEM;
+	}
+
+	pi->path         = path;
+	pi->repeat_count = repeat_count;
+	atomic_set(&pi->load, 0);
+	path->pscontext = pi;
+
+	spin_lock_irq(&s->lock);
+	list_add_tail(&pi->list, &s->valid_paths);
+	spin_unlock_irq(&s->lock);
+
+	return 0;
+}
+
+/*
+ * Note: Called with IRQ disabled from mpath.c/fail_path().
+ */
+static void
+lb_fail_path(struct path_selector *ps, struct dm_path *p)
+{
+	struct path_info *	pi;
+	struct selector *	s;
+
+	pi = (struct path_info *) p->pscontext;
+	s  = (struct selector *) ps->context;
+
+	spin_lock(&s->lock);
+	list_move(&pi->list, &s->failed_paths);
+	spin_unlock(&s->lock);
+}
+
+/*
+ * Notes: Called with IRQ disabled from mpath.c/reinstate_path().
+ */
+static int
+lb_reinstate_path(struct path_selector *ps, struct dm_path *p)
+{
+	struct path_info *	pi;
+	struct selector *	s;
+
+	pi = (struct path_info *) p->pscontext;
+	s  = (struct selector *)  ps->context;
+
+	if(!pi)
+		BUG();
+
+	spin_lock(&s->lock);
+	list_move_tail(&pi->list, &s->valid_paths);
+	spin_unlock(&s->lock);
+
+	return 0;
+}
+
+static inline int
+lb_compare_load(struct path_info *pi1, struct path_info *pi2)
+{
+	return atomic_read(&pi1->load) - atomic_read(&pi2->load);
+}
+
+static struct dm_path *
+lb_select_path(
+	struct path_selector *	ps,
+	unsigned *		repeat,
+	size_t			nr_bytes)
+{
+	struct selector *	s;
+	struct path_info *	cpi;
+	struct path_info *	spi;
+	unsigned long		flags;
+
+	s   = (struct selector *) ps->context;
+	if (!s)
+		BUG();
+	if (!repeat)
+		BUG();
+
+	spin_lock_irqsave(&s->lock, flags);
+	if (list_empty(&s->valid_paths)) {
+		spin_unlock_irqrestore(&s->lock, flags);
+		printk(KERN_ERR "dm-load-balance: no valid paths!\n");
+		return NULL;
+	}
+
+	/* Change preferred (first in list) path to evenly balance. */
+	list_move_tail(s->valid_paths.next, &s->valid_paths);
+
+	spi = NULL;
+	list_for_each_entry(cpi, &s->valid_paths, list) {
+		if (spi == NULL) {
+			spi = cpi;
+		} else {
+			if (lb_compare_load(cpi, spi) < 0) {
+				spi = cpi;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&s->lock, flags);
+
+	if (spi)
+		*repeat = spi->repeat_count;
+
+	return spi ? spi->path : NULL;
+}
+
+static int
+lb_io_started(
+	struct path_selector *	ps,
+	struct dm_path *	p,
+	struct request *	clone)
+{
+	struct path_info *	pi;
+
+	pi = (struct path_info *) p->pscontext;
+	atomic_inc(&pi->load);
+
+	return 0;
+}
+
+static int
+lb_io_finished(
+	struct path_selector *	ps,
+	struct dm_path *	p,
+	struct request *	clone,
+	int			nr_bytes)
+{
+	struct path_info *	pi;
+
+	pi = (struct path_info *) p->pscontext;
+	atomic_dec(&pi->load);
+
+	return 0;
+}
+
+static int
+lb_status(
+	struct path_selector *	ps,
+	struct dm_path *	p,
+	status_type_t		type,
+	char *			result,
+	unsigned int		maxlen)
+{
+	struct path_info *	pi;
+	int			sz;
+
+	/* This is used by DMEMIT. */
+	sz = 0;
+
+	/* When called with (p == NULL) return selector status/args. */
+	if (!p) {
+		DMEMIT("0 ");
+	} else {
+		pi = (struct path_info *) p->pscontext;
+		if (!pi)
+			BUG();
+
+		switch (type) {
+			case STATUSTYPE_TABLE:
+				DMEMIT("%i ", pi->repeat_count);
+				break;
+			case STATUSTYPE_INFO:
+				DMEMIT("%i ", atomic_read(&pi->load));
+				break;
+		}
+	}
+
+	return sz;
+}
+
+static struct path_selector_type lb_ps = {
+	.name		= "load-balance",
+	.module		= THIS_MODULE,
+	.table_args	= 1,
+	.info_args	= 1,
+	.create		= lb_create,
+	.destroy	= lb_destroy,
+	.status		= lb_status,
+	.add_path	= lb_add_path,
+	.fail_path	= lb_fail_path,
+	.reinstate_path	= lb_reinstate_path,
+	.select_path	= lb_select_path,
+	.start_io	= lb_io_started,
+	.end_io		= lb_io_finished,
+};
+
+int __init dm_lb_ps_init(void)
+{
+	int rc;
+
+	rc = dm_register_path_selector(&lb_ps);
+	if (rc < 0)
+		DMERR("load-balance: register failed %d", rc);
+
+	DMINFO("dm-load-balance version " LB_VERSION " loaded");
+
+	return rc;
+}
+
+void __exit dm_lb_ps_exit(void)
+{
+	int rc;
+
+	rc = dm_unregister_path_selector(&lb_ps);
+	if (rc < 0)
+		DMERR("load-balance: unregister failed %d", rc);
+}
+
+module_init(dm_lb_ps_init);
+module_exit(dm_lb_ps_exit);
+
+MODULE_AUTHOR("Stefan Bader <Stefan.Bader at de.ibm.com>");
+MODULE_DESCRIPTION(
+        "(C) Copyright IBM Corp. 2004,2005   All Rights Reserved.\n"
+        DM_NAME " load balancing path selector (dm-load-balance.c version "
+	LB_VERSION ")"
+);
+MODULE_LICENSE("GPL");
+
diff -rupN a2-rqdm-mpath/drivers/md/dm-mpath.c a3-rqdm-mpath-dlb/drivers/md/dm-mpath.c
--- a2-rqdm-mpath/drivers/md/dm-mpath.c	2007-08-29 14:07:39.000000000 -0400
+++ a3-rqdm-mpath-dlb/drivers/md/dm-mpath.c	2007-08-29 14:07:59.000000000 -0400
@@ -227,11 +227,12 @@ static void __switch_pg(struct multipath
 	}
 }
 
-static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg)
+static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
+			       size_t nr_bytes)
 {
 	struct dm_path *path;
 
-	path = pg->ps.type->select_path(&pg->ps, &m->repeat_count);
+	path = pg->ps.type->select_path(&pg->ps, &m->repeat_count, nr_bytes);
 	if (!path)
 		return -ENXIO;
 
@@ -243,7 +244,7 @@ static int __choose_path_in_pg(struct mu
 	return 0;
 }
 
-static void __choose_pgpath(struct multipath *m)
+static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 {
 	struct priority_group *pg;
 	unsigned bypassed = 1;
@@ -255,12 +256,12 @@ static void __choose_pgpath(struct multi
 	if (m->next_pg) {
 		pg = m->next_pg;
 		m->next_pg = NULL;
-		if (!__choose_path_in_pg(m, pg))
+		if (!__choose_path_in_pg(m, pg, nr_bytes))
 			return;
 	}
 
 	/* Don't change PG until it has no remaining paths */
-	if (m->current_pg && !__choose_path_in_pg(m, m->current_pg))
+	if (m->current_pg && !__choose_path_in_pg(m, m->current_pg, nr_bytes))
 		return;
 
 	/*
@@ -272,7 +273,7 @@ static void __choose_pgpath(struct multi
 		list_for_each_entry(pg, &m->priority_groups, list) {
 			if (pg->bypassed == bypassed)
 				continue;
-			if (!__choose_path_in_pg(m, pg))
+			if (!__choose_path_in_pg(m, pg, nr_bytes))
 				return;
 		}
 	} while (bypassed--);
@@ -311,7 +312,7 @@ static int map_io(struct multipath *m, s
 	/* Do we need to select a new pgpath? */
 	if (!m->current_pgpath ||
 	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
-		__choose_pgpath(m);
+		__choose_pgpath(m, clone->nr_sectors << 9);
 
 	pgpath = m->current_pgpath;
 
@@ -345,6 +346,10 @@ static int map_io(struct multipath *m, s
 
 	mpio->pgpath = pgpath;
 
+	if (r == 1 && m->current_pg->ps.type->start_io)
+		m->current_pg->ps.type->start_io(&m->current_pg->ps,
+						 &pgpath->path, clone);
+
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	return r;
@@ -421,7 +426,7 @@ static void process_queued_ios(struct wo
 		goto out;
 
 	if (!m->current_pgpath)
-		__choose_pgpath(m);
+		__choose_pgpath(m, 1 << 19); /* Assume 512 KB */
 
 	pgpath = m->current_pgpath;
 
@@ -1086,7 +1091,8 @@ static int do_end_io(struct multipath *m
  * clone->q's lock must be held
  */
 static int multipath_end_io_first(struct dm_target *ti, struct request *clone,
-				  int error, union map_info *map_context)
+				  int error, int nr_bytes,
+				  union map_info *map_context)
 {
 	struct multipath *m = ti->private;
 	struct dm_mpath_io *mpio = map_context->ptr;
@@ -1098,7 +1104,7 @@ static int multipath_end_io_first(struct
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path);
+			ps->type->end_io(ps, &pgpath->path, clone, nr_bytes);
 	}
 
 	return r;
@@ -1327,7 +1333,7 @@ static int multipath_ioctl(struct dm_tar
 	spin_lock_irqsave(&m->lock, flags);
 
 	if (!m->current_pgpath)
-		__choose_pgpath(m);
+		__choose_pgpath(m, 1 << 19); /* Assume 512KB */
 
 	if (m->current_pgpath) {
 		bdev = m->current_pgpath->path.dev->bdev;
@@ -1384,7 +1390,7 @@ static int __pg_congested(struct priorit
 }
 #endif
 
-static int multipath_congested(struct dm_target *ti)
+static int multipath_congested(struct dm_target *ti, size_t nr_bytes)
 {
 	int r = 0;
 	struct multipath *m = (struct multipath *) ti->private;
@@ -1409,7 +1415,7 @@ static int multipath_congested(struct dm
 	 * in map_io(). (This is a hack for pre-decrementing repeat_count
 	 * in map_io().  Needs to be fixed this repeat_count bug.)
 	 */
-	__choose_pgpath(m);
+	__choose_pgpath(m, nr_bytes);
 	if (m->current_pgpath) {
 		if (__pgpath_congested(m->current_pgpath)) {
 			r = 1;
diff -rupN a2-rqdm-mpath/drivers/md/dm-path-selector.h a3-rqdm-mpath-dlb/drivers/md/dm-path-selector.h
--- a2-rqdm-mpath/drivers/md/dm-path-selector.h	2007-08-13 00:25:24.000000000 -0400
+++ a3-rqdm-mpath-dlb/drivers/md/dm-path-selector.h	2007-08-28 16:41:34.000000000 -0400
@@ -56,7 +56,7 @@ struct path_selector_type {
 	 * the path fails.
 	 */
 	struct dm_path *(*select_path) (struct path_selector *ps,
-				     unsigned *repeat_count);
+				       unsigned *repeat_count, size_t nr_bytes);
 
 	/*
 	 * Notify the selector that a path has failed.
@@ -75,7 +75,10 @@ struct path_selector_type {
 	int (*status) (struct path_selector *ps, struct dm_path *path,
 		       status_type_t type, char *result, unsigned int maxlen);
 
-	int (*end_io) (struct path_selector *ps, struct dm_path *path);
+	int (*start_io) (struct path_selector *ps, struct dm_path *path,
+			struct request *clone);
+	int (*end_io) (struct path_selector *ps, struct dm_path *path,
+			struct request *clone, int nr_bytes);
 };
 
 /* Register a path selector */
diff -rupN a2-rqdm-mpath/drivers/md/dm-round-robin.c a3-rqdm-mpath-dlb/drivers/md/dm-round-robin.c
--- a2-rqdm-mpath/drivers/md/dm-round-robin.c	2007-08-13 00:25:24.000000000 -0400
+++ a3-rqdm-mpath-dlb/drivers/md/dm-round-robin.c	2007-08-28 16:41:34.000000000 -0400
@@ -160,7 +160,7 @@ static int rr_reinstate_path(struct path
 }
 
 static struct dm_path *rr_select_path(struct path_selector *ps,
-				   unsigned *repeat_count)
+				      unsigned *repeat_count, size_t nr_bytes)
 {
 	struct selector *s = (struct selector *) ps->context;
 	struct path_info *pi = NULL;
diff -rupN a2-rqdm-mpath/drivers/md/Makefile a3-rqdm-mpath-dlb/drivers/md/Makefile
--- a2-rqdm-mpath/drivers/md/Makefile	2007-08-13 00:25:24.000000000 -0400
+++ a3-rqdm-mpath-dlb/drivers/md/Makefile	2007-08-28 16:41:34.000000000 -0400
@@ -33,7 +33,8 @@ obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
-obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
+obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o \
+				   dm-load-balance.o dm-adaptive.o
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
 obj-$(CONFIG_DM_MULTIPATH_RDAC)	+= dm-rdac.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
diff -rupN a2-rqdm-mpath/include/linux/device-mapper.h a3-rqdm-mpath-dlb/include/linux/device-mapper.h
--- a2-rqdm-mpath/include/linux/device-mapper.h	2007-08-28 15:21:48.000000000 -0400
+++ a3-rqdm-mpath-dlb/include/linux/device-mapper.h	2007-08-28 16:41:34.000000000 -0400
@@ -64,6 +64,7 @@ typedef int (*dm_endio_fn) (struct dm_ta
 
 typedef int (*dm_request_endio_first_fn) (struct dm_target *ti,
 					  struct request *clone, int error,
+					  int nr_bytes,
 					  union map_info *map_context);
 
 typedef int (*dm_request_endio_fn) (struct dm_target *ti,
@@ -88,7 +89,7 @@ typedef int (*dm_message_fn) (struct dm_
 typedef int (*dm_ioctl_fn) (struct dm_target *ti, struct inode *inode,
 			    struct file *filp, unsigned int cmd,
 			    unsigned long arg);
-typedef int (*dm_congested_fn) (struct dm_target *ti);
+typedef int (*dm_congested_fn) (struct dm_target *ti, size_t nr_bytes);
 
 void dm_error(const char *message);
 
