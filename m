From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2 of 3] block: Block layer data integrity support
Date: Tue, 17 Jun 2008 11:57:57 -0400
Message-ID: <ad2f7b73689e3b3a61e1.1213718277@sermon.lab.mkp.net>
References: <patchbomb.1213718275@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:59421 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbYFQP7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 11:59:31 -0400
In-Reply-To: <patchbomb.1213718275@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Some block devices support verifying the integrity of requests by way
of checksums or other protection information that is submitted along
with the I/O.

This patch implements support for generating and verifying integrity
metadata, as well as correctly merging, splitting and cloning bios and
requests that have this extra information attached.

See Documentation/block/data-integrity.txt for more information.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
13 files changed, 1355 insertions(+), 7 deletions(-)
block/Kconfig          |   12 
block/Makefile         |    1 
block/blk-core.c       |    7 
block/blk-integrity.c  |  382 +++++++++++++++++++++++++
block/blk-merge.c      |    3 
block/blk.h            |    8 
block/elevator.c       |    6 
fs/Makefile            |    1 
fs/bio-integrity.c     |  708 ++++++++++++++++++++++++++++++++++++++++++++++++
fs/bio.c               |   32 +-
include/linux/bio.h    |   94 ++++++
include/linux/blkdev.h |  105 +++++++
include/linux/genhd.h  |    3 



diff --git a/block/Kconfig b/block/Kconfig
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -81,6 +81,18 @@ config BLK_DEV_BSG
 
 	  If unsure, say N.
 
+config BLK_DEV_INTEGRITY
+	bool "Block layer data integrity support"
+	---help---
+	Some storage devices allow extra information to be
+	stored/retrieved to help protect the data.  The block layer
+	data integrity option provides hooks which can be used by
+	filesystems to ensure better data integrity.
+
+	Say yes here if you have a storage device that provides the
+	T10/SCSI Data Integrity Field or the T13/ATA External Path
+	Protection.  If in doubt, say N.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
diff --git a/block/Makefile b/block/Makefile
--- a/block/Makefile
+++ b/block/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
+obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
diff --git a/block/blk-core.c b/block/blk-core.c
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -143,6 +143,10 @@ static void req_bio_endio(struct request
 
 		bio->bi_size -= nbytes;
 		bio->bi_sector += (nbytes >> 9);
+
+		if (bio_integrity(bio))
+			bio_integrity_advance(bio, nbytes);
+
 		if (bio->bi_size == 0)
 			bio_endio(bio, error);
 	} else {
@@ -1381,6 +1385,9 @@ end_io:
 		 */
 		blk_partition_remap(bio);
 
+		if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
+			goto end_io;
+
 		if (old_sector != -1)
 			blk_add_trace_remap(q, bio, old_dev, bio->bi_sector,
 					    old_sector);
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
new file mode 100644
--- /dev/null
+++ b/block/blk-integrity.c
@@ -0,0 +1,382 @@
+/*
+ * blk-integrity.c - Block layer data integrity extensions
+ *
+ * Copyright (C) 2007, 2008 Oracle Corporation
+ * Written by: Martin K. Petersen <martin.petersen@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
+ * USA.
+ *
+ */
+
+#include <linux/blkdev.h>
+#include <linux/mempool.h>
+#include <linux/bio.h>
+#include <linux/scatterlist.h>
+
+#include "blk.h"
+
+static struct kmem_cache *integrity_cachep;
+
+/**
+ * blk_rq_count_integrity_sg - Count number of integrity scatterlist elements
+ * @rq:		request with integrity metadata attached
+ *
+ * Description: Returns the number of elements required in a
+ * scatterlist corresponding to the integrity metadata in a request.
+ */
+int blk_rq_count_integrity_sg(struct request *rq)
+{
+	struct bio_vec *iv, *ivprv;
+	struct req_iterator iter;
+	unsigned int segments;
+
+	ivprv = NULL;
+	segments = 0;
+
+	rq_for_each_integrity_segment(iv, rq, iter) {
+
+		if (!ivprv || !BIOVEC_PHYS_MERGEABLE(ivprv, iv))
+			segments++;
+
+		ivprv = iv;
+	}
+
+	return segments;
+}
+EXPORT_SYMBOL(blk_rq_count_integrity_sg);
+
+/**
+ * blk_rq_map_integrity_sg - Map integrity metadata into a scatterlist
+ * @rq:		request with integrity metadata attached
+ * @sglist:	target scatterlist
+ *
+ * Description: Map the integrity vectors in request into a
+ * scatterlist.  The scatterlist must be big enough to hold all
+ * elements.  I.e. sized using blk_rq_count_integrity_sg().
+ */
+int blk_rq_map_integrity_sg(struct request *rq, struct scatterlist *sglist)
+{
+	struct bio_vec *iv, *ivprv;
+	struct req_iterator iter;
+	struct scatterlist *sg;
+	unsigned int segments;
+
+	ivprv = NULL;
+	sg = NULL;
+	segments = 0;
+
+	rq_for_each_integrity_segment(iv, rq, iter) {
+
+		if (ivprv) {
+			if (!BIOVEC_PHYS_MERGEABLE(ivprv, iv))
+				goto new_segment;
+
+			sg->length += iv->bv_len;
+		} else {
+new_segment:
+			if (!sg)
+				sg = sglist;
+			else {
+				sg->page_link &= ~0x02;
+				sg = sg_next(sg);
+			}
+
+			sg_set_page(sg, iv->bv_page, iv->bv_len, iv->bv_offset);
+			segments++;
+		}
+
+		ivprv = iv;
+	}
+
+	if (sg)
+		sg_mark_end(sg);
+
+	return segments;
+}
+EXPORT_SYMBOL(blk_rq_map_integrity_sg);
+
+/**
+ * blk_integrity_compare - Compare integrity profile of two block devices
+ * @b1:		Device to compare
+ * @b2:		Device to compare
+ *
+ * Description: Meta-devices like DM and MD need to verify that all
+ * sub-devices use the same integrity format before advertising to
+ * upper layers that they can send/receive integrity metadata.  This
+ * function can be used to check whether two block devices have
+ * compatible integrity formats.
+ */
+int blk_integrity_compare(struct block_device *bd1, struct block_device *bd2)
+{
+	struct blk_integrity *b1 = bd1->bd_disk->integrity;
+	struct blk_integrity *b2 = bd2->bd_disk->integrity;
+
+	BUG_ON(bd1->bd_disk == NULL);
+	BUG_ON(bd2->bd_disk == NULL);
+
+	if (!b1 || !b2)
+		return 0;
+
+	if (b1->sector_size != b2->sector_size) {
+		printk(KERN_ERR "%s: %s/%s sector sz %u != %u\n", __func__,
+		       bd1->bd_disk->disk_name, bd2->bd_disk->disk_name,
+		       b1->sector_size, b2->sector_size);
+		return -1;
+	}
+
+	if (b1->tuple_size != b2->tuple_size) {
+		printk(KERN_ERR "%s: %s/%s tuple sz %u != %u\n", __func__,
+		       bd1->bd_disk->disk_name, bd2->bd_disk->disk_name,
+		       b1->tuple_size, b2->tuple_size);
+		return -1;
+	}
+
+	if (b1->tag_size && b2->tag_size && (b1->tag_size != b2->tag_size)) {
+		printk(KERN_ERR "%s: %s/%s tag sz %u != %u\n", __func__,
+		       bd1->bd_disk->disk_name, bd2->bd_disk->disk_name,
+		       b1->tag_size, b2->tag_size);
+		return -1;
+	}
+
+	if (strcmp(b1->name, b2->name)) {
+		printk(KERN_ERR "%s: %s/%s type %s != %s\n", __func__,
+		       bd1->bd_disk->disk_name, bd2->bd_disk->disk_name,
+		       b1->name, b2->name);
+		return -1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(blk_integrity_compare);
+
+struct integrity_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_integrity *, char *);
+	ssize_t (*store)(struct blk_integrity *, const char *, size_t);
+};
+
+static ssize_t integrity_attr_show(struct kobject *kobj, struct attribute *attr,
+				   char *page)
+{
+	struct blk_integrity *bi =
+		container_of(kobj, struct blk_integrity, kobj);
+	struct integrity_sysfs_entry *entry =
+		container_of(attr, struct integrity_sysfs_entry, attr);
+
+	return entry->show(bi, page);
+}
+
+static ssize_t integrity_attr_store(struct kobject *kobj, struct attribute *attr,
+				    const char *page, size_t count)
+{
+	struct blk_integrity *bi =
+		container_of(kobj, struct blk_integrity, kobj);
+	struct integrity_sysfs_entry *entry =
+		container_of(attr, struct integrity_sysfs_entry, attr);
+	ssize_t ret = 0;
+
+	if (entry->store)
+		ret = entry->store(bi, page, count);
+
+	return ret;
+}
+
+static ssize_t integrity_format_show(struct blk_integrity *bi, char *page)
+{
+	if (bi != NULL && bi->name != NULL)
+		return sprintf(page, "%s\n", bi->name);
+	else
+		return sprintf(page, "none\n");
+}
+
+static ssize_t integrity_tag_size_show(struct blk_integrity *bi, char *page)
+{
+	if (bi != NULL)
+		return sprintf(page, "%u\n", bi->tag_size);
+	else
+		return sprintf(page, "0\n");
+}
+
+static ssize_t integrity_read_store(struct blk_integrity *bi,
+				    const char *page, size_t count)
+{
+	char *p = (char *) page;
+	unsigned long val = simple_strtoul(p, &p, 10);
+
+	if (val)
+		set_bit(INTEGRITY_FLAG_READ, &bi->flags);
+	else
+		clear_bit(INTEGRITY_FLAG_READ, &bi->flags);
+
+	return count;
+}
+
+static ssize_t integrity_read_show(struct blk_integrity *bi, char *page)
+{
+	return sprintf(page, "%d\n",
+		       test_bit(INTEGRITY_FLAG_READ, &bi->flags) ? 1 : 0);
+}
+
+static ssize_t integrity_write_store(struct blk_integrity *bi,
+				     const char *page, size_t count)
+{
+	char *p = (char *) page;
+	unsigned long val = simple_strtoul(p, &p, 10);
+
+	if (val)
+		set_bit(INTEGRITY_FLAG_WRITE, &bi->flags);
+	else
+		clear_bit(INTEGRITY_FLAG_WRITE, &bi->flags);
+
+	return count;
+}
+
+static ssize_t integrity_write_show(struct blk_integrity *bi, char *page)
+{
+	return sprintf(page, "%d\n",
+		       test_bit(INTEGRITY_FLAG_WRITE, &bi->flags) ? 1 : 0);
+}
+
+static struct integrity_sysfs_entry integrity_format_entry = {
+	.attr = { .name = "format", .mode = S_IRUGO },
+	.show = integrity_format_show,
+};
+
+static struct integrity_sysfs_entry integrity_tag_size_entry = {
+	.attr = { .name = "tag_size", .mode = S_IRUGO },
+	.show = integrity_tag_size_show,
+};
+
+static struct integrity_sysfs_entry integrity_read_entry = {
+	.attr = { .name = "read_verify", .mode = S_IRUGO | S_IWUSR },
+	.show = integrity_read_show,
+	.store = integrity_read_store,
+};
+
+static struct integrity_sysfs_entry integrity_write_entry = {
+	.attr = { .name = "write_generate", .mode = S_IRUGO | S_IWUSR },
+	.show = integrity_write_show,
+	.store = integrity_write_store,
+};
+
+static struct attribute *integrity_attrs[] = {
+	&integrity_format_entry.attr,
+	&integrity_tag_size_entry.attr,
+	&integrity_read_entry.attr,
+	&integrity_write_entry.attr,
+	NULL,
+};
+
+static struct sysfs_ops integrity_ops = {
+	.show	= &integrity_attr_show,
+	.store	= &integrity_attr_store,
+};
+
+static int __init blk_dev_integrity_init(void)
+{
+	integrity_cachep = kmem_cache_create("blkdev_integrity",
+					     sizeof(struct blk_integrity),
+					     0, SLAB_PANIC, NULL);
+	return 0;
+}
+subsys_initcall(blk_dev_integrity_init);
+
+static void blk_integrity_release(struct kobject *kobj)
+{
+	struct blk_integrity *bi =
+		container_of(kobj, struct blk_integrity, kobj);
+
+	kmem_cache_free(integrity_cachep, bi);
+}
+
+static struct kobj_type integrity_ktype = {
+	.default_attrs	= integrity_attrs,
+	.sysfs_ops	= &integrity_ops,
+	.release	= blk_integrity_release,
+};
+
+/**
+ * blk_integrity_register - Register a gendisk as being integrity-capable
+ * @disk:	struct gendisk pointer to make integrity-aware
+ * @template:	integrity profile
+ *
+ * Description: When a device needs to advertise itself as being able
+ * to send/receive integrity metadata it must use this function to
+ * register the capability with the block layer.  The template is a
+ * blk_integrity struct with values appropriate for the underlying
+ * hardware.  See Documentation/block/data-integrity.txt.
+ */
+int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
+{
+	struct blk_integrity *bi;
+
+	BUG_ON(disk == NULL);
+	BUG_ON(template == NULL);
+
+	if (disk->integrity == NULL) {
+		bi = kmem_cache_alloc(integrity_cachep, GFP_KERNEL | __GFP_ZERO);
+		if (!bi)
+			return -1;
+
+		if (kobject_init_and_add(&bi->kobj, &integrity_ktype,
+					 &disk->dev.kobj, "%s", "integrity")) {
+			kmem_cache_free(integrity_cachep, bi);
+			return -1;
+		}
+
+		kobject_uevent(&bi->kobj, KOBJ_ADD);
+
+		set_bit(INTEGRITY_FLAG_READ, &bi->flags);
+		set_bit(INTEGRITY_FLAG_WRITE, &bi->flags);
+		bi->sector_size = disk->queue->hardsect_size;
+		disk->integrity = bi;
+	} else
+		bi = disk->integrity;
+
+	/* Use the provided profile as template */
+	bi->name = template->name;
+	bi->generate_fn = template->generate_fn;
+	bi->verify_fn = template->verify_fn;
+	bi->tuple_size = template->tuple_size;
+	bi->set_tag_fn = template->set_tag_fn;
+	bi->get_tag_fn = template->get_tag_fn;
+	bi->tag_size = template->tag_size;
+
+	return 0;
+}
+EXPORT_SYMBOL(blk_integrity_register);
+
+/**
+ * blk_integrity_unregister - Remove block integrity profile
+ * @disk:	disk whose integrity profile to deallocate
+ *
+ * Description: This function frees all memory used by the block
+ * integrity profile.  To be called at device teardown.
+ */
+void blk_integrity_unregister(struct gendisk *disk)
+{
+	struct blk_integrity *bi;
+
+	if (!disk || !disk->integrity)
+		return;
+
+	bi = disk->integrity;
+
+	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
+	kobject_del(&bi->kobj);
+	kobject_put(&disk->dev.kobj);
+	kmem_cache_free(integrity_cachep, bi);
+}
+EXPORT_SYMBOL(blk_integrity_unregister);
diff --git a/block/blk-merge.c b/block/blk-merge.c
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -441,6 +441,9 @@ static int attempt_merge(struct request_
 	    || next->special)
 		return 0;
 
+	if (blk_integrity_rq(req) != blk_integrity_rq(next))
+		return 0;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
diff --git a/block/blk.h b/block/blk.h
--- a/block/blk.h
+++ b/block/blk.h
@@ -51,4 +51,12 @@ static inline int queue_congestion_off_t
 	return q->nr_congestion_off;
 }
 
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+
+#define rq_for_each_integrity_segment(bvl, _rq, _iter)		\
+	__rq_for_each_bio(_iter.bio, _rq)			\
+		bip_for_each_vec(bvl, _iter.bio->bi_integrity, _iter.i)
+
+#endif /* BLK_DEV_INTEGRITY */
+
 #endif
diff --git a/block/elevator.c b/block/elevator.c
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -84,6 +84,12 @@ int elv_rq_merge_ok(struct request *rq, 
 	 * must be same device and not a special request
 	 */
 	if (rq->rq_disk != bio->bi_bdev->bd_disk || rq->special)
+		return 0;
+
+	/*
+	 * only merge integrity protected bio into ditto rq
+	 */
+	if (bio_integrity(bio) != blk_integrity_rq(rq))
 		return 0;
 
 	if (!elv_iosched_allow_merge(rq, bio))
diff --git a/fs/Makefile b/fs/Makefile
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -19,6 +19,7 @@ obj-y +=	no-block.o
 obj-y +=	no-block.o
 endif
 
+obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
new file mode 100644
--- /dev/null
+++ b/fs/bio-integrity.c
@@ -0,0 +1,708 @@
+/*
+ * bio-integrity.c - bio data integrity extensions
+ *
+ * Copyright (C) 2007, 2008 Oracle Corporation
+ * Written by: Martin K. Petersen <martin.petersen@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
+ * USA.
+ *
+ */
+
+#include <linux/blkdev.h>
+#include <linux/mempool.h>
+#include <linux/bio.h>
+#include <linux/workqueue.h>
+
+static struct kmem_cache *bio_integrity_slab __read_mostly;
+static struct workqueue_struct *kintegrityd_wq;
+
+/**
+ * bio_integrity_alloc_bioset - Allocate integrity payload and attach it to bio
+ * @bio:	bio to attach integrity metadata to
+ * @gfp_mask:	Memory allocation mask
+ * @nr_vecs:	Number of integrity metadata scatter-gather elements
+ * @bs:		bio_set to allocate from
+ *
+ * Description: This function prepares a bio for attaching integrity
+ * metadata.  nr_vecs specifies the maximum number of pages containing
+ * integrity metadata that can be attached.
+ */
+struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio, gfp_t gfp_mask, unsigned int nr_vecs, struct bio_set *bs)
+{
+	struct bio_integrity_payload *bip;
+	struct bio_vec *iv;
+	unsigned long idx;
+
+	BUG_ON(bio == NULL);
+
+	bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
+	if (unlikely(bip == NULL)) {
+		printk(KERN_ERR "%s: could not alloc bip\n", __func__);
+		return NULL;
+	}
+
+	memset(bip, 0, sizeof(*bip));
+
+	iv = bvec_alloc_bs(gfp_mask, nr_vecs, &idx, bs);
+	if (unlikely(iv == NULL)) {
+		printk(KERN_ERR "%s: could not alloc bip_vec\n", __func__);
+		mempool_free(bip, bs->bio_integrity_pool);
+		return NULL;
+	}
+
+	bip->bip_pool = idx;
+	bip->bip_vec = iv;
+	bip->bip_bio = bio;
+	bio->bi_integrity = bip;
+
+	return bip;
+}
+EXPORT_SYMBOL(bio_integrity_alloc_bioset);
+
+/**
+ * bio_integrity_alloc - Allocate integrity payload and attach it to bio
+ * @bio:	bio to attach integrity metadata to
+ * @gfp_mask:	Memory allocation mask
+ * @nr_vecs:	Number of integrity metadata scatter-gather elements
+ *
+ * Description: This function prepares a bio for attaching integrity
+ * metadata.  nr_vecs specifies the maximum number of pages containing
+ * integrity metadata that can be attached.
+ */
+struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp_mask, unsigned int nr_vecs)
+{
+	return bio_integrity_alloc_bioset(bio, gfp_mask, nr_vecs, fs_bio_set);
+}
+EXPORT_SYMBOL(bio_integrity_alloc);
+
+/**
+ * bio_integrity_free - Free bio integrity payload
+ * @bio:	bio containing bip to be freed
+ * @bs:		bio_set this bio was allocated from
+ *
+ * Description: Used to free the integrity portion of a bio. Usually
+ * called from bio_free().
+ */
+void bio_integrity_free(struct bio *bio, struct bio_set *bs)
+{
+	struct bio_integrity_payload *bip = bio->bi_integrity;
+
+	BUG_ON(bip == NULL);
+
+	/* A cloned bio doesn't own the integrity metadata */
+	if (!bio_flagged(bio, BIO_CLONED) && bip->bip_buf != NULL)
+		kfree(bip->bip_buf);
+
+	mempool_free(bip->bip_vec, bs->bvec_pools[bip->bip_pool]);
+	mempool_free(bip, bs->bio_integrity_pool);
+
+	bio->bi_integrity = NULL;
+}
+EXPORT_SYMBOL(bio_integrity_free);
+
+/**
+ * bio_integrity_add_page - Attach integrity metadata
+ * @bio:	bio to update
+ * @page:	page containing integrity metadata
+ * @len:	number of bytes of integrity metadata in page
+ * @offset:	start offset within page
+ *
+ * Description: Attach a page containing integrity metadata to bio.
+ */
+int bio_integrity_add_page(struct bio *bio, struct page *page,
+			   unsigned int len, unsigned int offset)
+{
+	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct bio_vec *iv;
+
+	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_pool)) {
+		printk(KERN_ERR "%s: bip_vec full\n", __func__);
+		return 0;
+	}
+
+	iv = bip_vec_idx(bip, bip->bip_vcnt);
+	BUG_ON(iv == NULL);
+	BUG_ON(iv->bv_page != NULL);
+
+	iv->bv_page = page;
+	iv->bv_len = len;
+	iv->bv_offset = offset;
+	bip->bip_vcnt++;
+
+	return len;
+}
+EXPORT_SYMBOL(bio_integrity_add_page);
+
+/**
+ * bio_integrity_enabled - Check whether integrity can be passed
+ * @bio:	bio to check
+ *
+ * Description: Determines whether bio_integrity_prep() can be called
+ * on this bio or not.	bio data direction and target device must be
+ * set prior to calling.  The functions honors the write_generate and
+ * read_verify flags in sysfs.
+ */
+int bio_integrity_enabled(struct bio *bio)
+{
+	/* Already protected? */
+	if (bio_integrity(bio))
+		return 0;
+
+	return bdev_integrity_enabled(bio->bi_bdev, bio_data_dir(bio));
+}
+EXPORT_SYMBOL(bio_integrity_enabled);
+
+/**
+ * bio_integrity_hw_sectors - Convert 512b sectors to hardware ditto
+ * @bi:		blk_integrity profile for device
+ * @sectors:	Number of 512 sectors to convert
+ *
+ * Description: The block layer calculates everything in 512 byte
+ * sectors but integrity metadata is done in terms of the hardware
+ * sector size of the storage device.  Convert the block layer sectors
+ * to physical sectors.
+ */
+static inline unsigned int bio_integrity_hw_sectors(struct blk_integrity *bi, unsigned int sectors)
+{
+	/* At this point there are only 512b or 4096b DIF/EPP devices */
+	if (bi->sector_size == 4096)
+		return sectors >>= 3;
+
+	return sectors;
+}
+
+/**
+ * bio_integrity_tag_size - Retrieve integrity tag space
+ * @bio:	bio to inspect
+ *
+ * Description: Returns the maximum number of tag bytes that can be
+ * attached to this bio. Filesystems can use this to determine how
+ * much metadata to attach to an I/O.
+ */
+unsigned int bio_integrity_tag_size(struct bio *bio)
+{
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+
+	BUG_ON(bio->bi_size == 0);
+
+	return bi->tag_size * (bio->bi_size / bi->sector_size);
+}
+EXPORT_SYMBOL(bio_integrity_tag_size);
+
+int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len, int set)
+{
+	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+	unsigned int nr_sectors;
+
+	BUG_ON(bip->bip_buf == NULL);
+
+	if (bi->tag_size == 0)
+		return -1;
+
+	nr_sectors = bio_integrity_hw_sectors(bi, DIV_ROUND_UP(len, bi->tag_size));
+
+	if (nr_sectors * bi->tuple_size > bip->bip_size) {
+		printk(KERN_ERR "%s: tag too big for bio: %u > %u\n",
+		       __func__, nr_sectors * bi->tuple_size, bip->bip_size);
+		return -1;
+	}
+
+	if (set)
+		bi->set_tag_fn(bip->bip_buf, tag_buf, nr_sectors);
+	else
+		bi->get_tag_fn(bip->bip_buf, tag_buf, nr_sectors);
+
+	return 0;
+}
+
+/**
+ * bio_integrity_set_tag - Attach a tag buffer to a bio
+ * @bio:	bio to attach buffer to
+ * @tag_buf:	Pointer to a buffer containing tag data
+ * @len:	Length of the included buffer
+ *
+ * Description: Use this function to tag a bio by leveraging the extra
+ * space provided by devices formatted with integrity protection.  The
+ * size of the integrity buffer must be <= to the size reported by
+ * bio_integrity_tag_size().
+ */
+int bio_integrity_set_tag(struct bio *bio, void *tag_buf, unsigned int len)
+{
+	BUG_ON(bio_data_dir(bio) != WRITE);
+
+	return bio_integrity_tag(bio, tag_buf, len, 1);
+}
+EXPORT_SYMBOL(bio_integrity_set_tag);
+
+/**
+ * bio_integrity_get_tag - Retrieve a tag buffer from a bio
+ * @bio:	bio to retrieve buffer from
+ * @tag_buf:	Pointer to a buffer for the tag data
+ * @len:	Length of the target buffer
+ *
+ * Description: Use this function to retrieve the tag buffer from a
+ * completed I/O. The size of the integrity buffer must be <= to the
+ * size reported by bio_integrity_tag_size().
+ */
+int bio_integrity_get_tag(struct bio *bio, void *tag_buf, unsigned int len)
+{
+	BUG_ON(bio_data_dir(bio) != READ);
+
+	return bio_integrity_tag(bio, tag_buf, len, 0);
+}
+EXPORT_SYMBOL(bio_integrity_get_tag);
+
+/**
+ * bio_integrity_generate - Generate integrity metadata for a bio
+ * @bio:	bio to generate integrity metadata for
+ *
+ * Description: Generates integrity metadata for a bio by calling the
+ * block device's generation callback function.  The bio must have a
+ * bip attached with enough room to accommodate the generated
+ * integrity metadata.
+ */
+static void bio_integrity_generate(struct bio *bio)
+{
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+	struct blk_integrity_exchg bix;
+	struct bio_vec *bv;
+	sector_t sector = bio->bi_sector;
+	unsigned int i, sectors, total;
+	void *prot_buf = bio->bi_integrity->bip_buf;
+
+	total = 0;
+	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
+	bix.sector_size = bi->sector_size;
+
+	bio_for_each_segment(bv, bio, i) {
+		void *kaddr = kmap_atomic(bv->bv_page, KM_USER0);
+		bix.data_buf = kaddr + bv->bv_offset;
+		bix.data_size = bv->bv_len;
+		bix.prot_buf = prot_buf;
+		bix.sector = sector;
+
+		bi->generate_fn(&bix);
+
+		sectors = bv->bv_len / bi->sector_size;
+		sector += sectors;
+		prot_buf += sectors * bi->tuple_size;
+		total += sectors * bi->tuple_size;
+		BUG_ON(total > bio->bi_integrity->bip_size);
+
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+}
+
+/**
+ * bio_integrity_prep - Prepare bio for integrity I/O
+ * @bio:	bio to prepare
+ *
+ * Description: Allocates a buffer for integrity metadata, maps the
+ * pages and attaches them to a bio.  The bio must have data
+ * direction, target device and start sector set priot to calling.  In
+ * the WRITE case, integrity metadata will be generated using the
+ * block device's integrity function.  In the READ case, the buffer
+ * will be prepared for DMA and a suitable end_io handler set up.
+ */
+int bio_integrity_prep(struct bio *bio)
+{
+	struct bio_integrity_payload *bip;
+	struct blk_integrity *bi;
+	struct request_queue *q;
+	void *buf;
+	unsigned long start, end;
+	unsigned int len, nr_pages;
+	unsigned int bytes, offset, i;
+	unsigned int sectors;
+
+	bi = bdev_get_integrity(bio->bi_bdev);
+	q = bdev_get_queue(bio->bi_bdev);
+	BUG_ON(bi == NULL);
+	BUG_ON(bio_integrity(bio));
+
+	sectors = bio_integrity_hw_sectors(bi, bio_sectors(bio));
+
+	/* Allocate kernel buffer for protection data */
+	len = sectors * blk_integrity_tuple_size(bi);
+	buf = kmalloc(len, GFP_NOIO | __GFP_NOFAIL | q->bounce_gfp);
+	if (unlikely(buf == NULL)) {
+		printk(KERN_ERR "could not allocate integrity buffer\n");
+		return -EIO;
+	}
+
+	end = (((unsigned long) buf) + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = ((unsigned long) buf) >> PAGE_SHIFT;
+	nr_pages = end - start;
+
+	/* Allocate bio integrity payload and integrity vectors */
+	bip = bio_integrity_alloc(bio, GFP_NOIO, nr_pages);
+	if (unlikely(bip == NULL)) {
+		printk(KERN_ERR "could not allocate data integrity bioset\n");
+		kfree(buf);
+		return -EIO;
+	}
+
+	bip->bip_buf = buf;
+	bip->bip_size = len;
+	bip->bip_sector = bio->bi_sector;
+
+	/* Map it */
+	offset = offset_in_page(buf);
+	for (i = 0 ; i < nr_pages ; i++) {
+		int ret;
+		bytes = PAGE_SIZE - offset;
+
+		if (len <= 0)
+			break;
+
+		if (bytes > len)
+			bytes = len;
+
+		ret = bio_integrity_add_page(bio, virt_to_page(buf),
+					     bytes, offset);
+
+		if (ret == 0)
+			return 0;
+
+		if (ret < bytes)
+			break;
+
+		buf += bytes;
+		len -= bytes;
+		offset = 0;
+	}
+
+	/* Install custom I/O completion handler if read verify is enabled */
+	if (bio_data_dir(bio) == READ) {
+		bip->bip_end_io = bio->bi_end_io;
+		bio->bi_end_io = bio_integrity_endio;
+	}
+
+	/* Auto-generate integrity metadata if this is a write */
+	if (bio_data_dir(bio) == WRITE)
+		bio_integrity_generate(bio);
+
+	return 0;
+}
+EXPORT_SYMBOL(bio_integrity_prep);
+
+/**
+ * bio_integrity_verify - Verify integrity metadata for a bio
+ * @bio:	bio to verify
+ *
+ * Description: This function is called to verify the integrity of a
+ * bio.	 The data in the bio io_vec is compared to the integrity
+ * metadata returned by the HBA.
+ */
+static int bio_integrity_verify(struct bio *bio)
+{
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+	struct blk_integrity_exchg bix;
+	struct bio_vec *bv;
+	sector_t sector = bio->bi_integrity->bip_sector;
+	unsigned int i, sectors, total, ret;
+	void *prot_buf = bio->bi_integrity->bip_buf;
+
+	ret = total = 0;
+	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
+	bix.sector_size = bi->sector_size;
+
+	bio_for_each_segment(bv, bio, i) {
+		void *kaddr = kmap_atomic(bv->bv_page, KM_USER0);
+		bix.data_buf = kaddr + bv->bv_offset;
+		bix.data_size = bv->bv_len;
+		bix.prot_buf = prot_buf;
+		bix.sector = sector;
+
+		ret = bi->verify_fn(&bix);
+
+		if (ret) {
+			kunmap_atomic(kaddr, KM_USER0);
+			break;
+		}
+
+		sectors = bv->bv_len / bi->sector_size;
+		sector += sectors;
+		prot_buf += sectors * bi->tuple_size;
+		total += sectors * bi->tuple_size;
+		BUG_ON(total > bio->bi_integrity->bip_size);
+
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+
+	return ret;
+}
+
+/**
+ * bio_integrity_verify_fn - Integrity I/O completion worker
+ * @work:	Work struct stored in bio to be verified
+ *
+ * Description: This workqueue function is called to complete a READ
+ * request.  The function verifies the transferred integrity metadata
+ * and then calls the original bio end_io function.
+ */
+static void bio_integrity_verify_fn(struct work_struct *work)
+{
+	struct bio_integrity_payload *bip = 
+		container_of(work, struct bio_integrity_payload, bip_work);
+	struct bio *bio = bip->bip_bio;
+	int error = bip->bip_error;
+
+	if (bio_integrity_verify(bio)) {
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+		error = -EIO;
+	}
+
+	/* Restore original bio completion handler */
+	bio->bi_end_io = bip->bip_end_io;
+
+	if (bio->bi_end_io)
+		bio->bi_end_io(bio, error);
+}
+
+/**
+ * bio_integrity_endio - Integrity I/O completion function
+ * @bio:	Protected bio
+ * @error:	Pointer to errno
+ *
+ * Description: Completion for integrity I/O
+ *
+ * Normally I/O completion is done in interrupt context.  However,
+ * verifying I/O integrity is a time-consuming task which must be run
+ * in process context.	This function postpones completion
+ * accordingly.
+ */
+void bio_integrity_endio(struct bio *bio, int error)
+{
+	struct bio_integrity_payload *bip = bio->bi_integrity;
+
+	BUG_ON(bip->bip_bio != bio);
+
+	bip->bip_error = error;
+	INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
+	queue_work(kintegrityd_wq, &bip->bip_work);
+}
+EXPORT_SYMBOL(bio_integrity_endio);
+
+/**
+ * bio_integrity_mark_head - Advance bip_vec skip bytes
+ * @bip:	Integrity vector to advance
+ * @skip:	Number of bytes to advance it
+ */
+void bio_integrity_mark_head(struct bio_integrity_payload *bip, unsigned int skip)
+{
+	struct bio_vec *iv;
+	unsigned int i;
+
+	bip_for_each_vec(iv, bip, i) {
+		if (skip == 0) {
+			bip->bip_idx = i;
+			return;
+		} else if (skip >= iv->bv_len) {
+			skip -= iv->bv_len;
+		} else { /* skip < iv->bv_len) */
+			iv->bv_offset += skip;
+			iv->bv_len -= skip;
+			bip->bip_idx = i;
+			return;
+		}
+	}
+}
+
+/**
+ * bio_integrity_mark_tail - Truncate bip_vec to be len bytes long
+ * @bip:	Integrity vector to truncate
+ * @len:	New length of integrity vector
+ */
+void bio_integrity_mark_tail(struct bio_integrity_payload *bip, unsigned int len)
+{
+	struct bio_vec *iv;
+	unsigned int i;
+
+	bip_for_each_vec(iv, bip, i) {
+		if (len == 0) {
+			bip->bip_vcnt = i;
+			return;
+		} else if (len >= iv->bv_len) {
+			len -= iv->bv_len;
+		} else { /* len < iv->bv_len) */
+			iv->bv_len = len;
+			len = 0;
+		}
+	}
+}
+
+/**
+ * bio_integrity_advance - Advance integrity vector
+ * @bio:	bio whose integrity vector to update
+ * @bytes_done:	number of data bytes that have been completed
+ *
+ * Description: This function calculates how many integrity bytes the
+ * number of completed data bytes correspond to and advances the
+ * integrity vector accordingly.
+ */
+void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
+{
+	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+	unsigned int nr_sectors;
+
+	BUG_ON(bip == NULL);
+	BUG_ON(bi == NULL);
+
+	nr_sectors = bio_integrity_hw_sectors(bi, bytes_done >> 9);
+	bio_integrity_mark_head(bip, nr_sectors * bi->tuple_size);
+}
+EXPORT_SYMBOL(bio_integrity_advance);
+
+/**
+ * bio_integrity_trim - Trim integrity vector
+ * @bio:	bio whose integrity vector to update
+ * @offset:	offset to first data sector
+ * @sectors:	number of data sectors
+ *
+ * Description: Used to trim the integrity vector in a cloned bio.
+ * The ivec will be advanced corresponding to 'offset' data sectors
+ * and the length will be truncated corresponding to 'len' data
+ * sectors.
+ */
+void bio_integrity_trim(struct bio *bio, unsigned int offset, unsigned int sectors)
+{
+	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+	unsigned int nr_sectors;
+
+	BUG_ON(bip == NULL);
+	BUG_ON(bi == NULL);
+	BUG_ON(!bio_flagged(bio, BIO_CLONED));
+
+	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
+	bip->bip_sector = bip->bip_sector + offset;
+	bio_integrity_mark_head(bip, offset * bi->tuple_size);
+	bio_integrity_mark_tail(bip, sectors * bi->tuple_size);
+}
+EXPORT_SYMBOL(bio_integrity_trim);
+
+/**
+ * bio_integrity_split - Split integrity metadata
+ * @bio:	Protected bio
+ * @bp:		Resulting bio_pair
+ * @sectors:	Offset
+ *
+ * Description: Splits an integrity page into a bio_pair.
+ */
+void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
+{
+	struct blk_integrity *bi;
+	struct bio_integrity_payload *bip = bio->bi_integrity;
+	unsigned int nr_sectors;
+
+	if (bio_integrity(bio) == 0)
+		return;
+
+	bi = bdev_get_integrity(bio->bi_bdev);
+	BUG_ON(bi == NULL);
+	BUG_ON(bip->bip_vcnt != 1);
+
+	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
+
+	bp->bio1.bi_integrity = &bp->bip1;
+	bp->bio2.bi_integrity = &bp->bip2;
+
+	bp->iv1 = bip->bip_vec[0];
+	bp->iv2 = bip->bip_vec[0];
+
+	bp->bip1.bip_vec = &bp->iv1;
+	bp->bip2.bip_vec = &bp->iv2;
+
+	bp->iv1.bv_len = sectors * bi->tuple_size;
+	bp->iv2.bv_offset += sectors * bi->tuple_size;
+	bp->iv2.bv_len -= sectors * bi->tuple_size;
+
+	bp->bip1.bip_sector = bio->bi_integrity->bip_sector;
+	bp->bip2.bip_sector = bio->bi_integrity->bip_sector + nr_sectors;
+
+	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
+	bp->bip1.bip_idx = bp->bip2.bip_idx = 0;
+}
+EXPORT_SYMBOL(bio_integrity_split);
+
+/**
+ * bio_integrity_clone - Callback for cloning bios with integrity metadata
+ * @bio:	New bio
+ * @bio_src:	Original bio
+ * @bs:		bio_set to allocate bip from
+ *
+ * Description:	Called to allocate a bip when cloning a bio
+ */
+int bio_integrity_clone(struct bio *bio, struct bio *bio_src, struct bio_set *bs)
+{
+	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
+	struct bio_integrity_payload *bip;
+
+	BUG_ON(bip_src == NULL);
+
+	bip = bio_integrity_alloc_bioset(bio, GFP_NOIO, bip_src->bip_vcnt, bs);
+
+	if (bip == NULL)
+		return -EIO;
+
+	memcpy(bip->bip_vec, bip_src->bip_vec,
+	       bip_src->bip_vcnt * sizeof(struct bio_vec));
+
+	bip->bip_sector = bip_src->bip_sector;
+	bip->bip_vcnt = bip_src->bip_vcnt;
+	bip->bip_idx = bip_src->bip_idx;
+
+	return 0;
+}
+EXPORT_SYMBOL(bio_integrity_clone);
+
+int bioset_integrity_create(struct bio_set *bs, int pool_size)
+{
+	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size,
+							  bio_integrity_slab);
+	if (!bs->bio_integrity_pool)
+		return -1;
+
+	return 0;
+}
+EXPORT_SYMBOL(bioset_integrity_create);
+
+void bioset_integrity_free(struct bio_set *bs)
+{
+	if (bs->bio_integrity_pool)
+		mempool_destroy(bs->bio_integrity_pool);
+}
+EXPORT_SYMBOL(bioset_integrity_free);
+
+void __init bio_integrity_init_slab(void)
+{
+	bio_integrity_slab = KMEM_CACHE(bio_integrity_payload,
+					SLAB_HWCACHE_ALIGN|SLAB_PANIC);
+}
+EXPORT_SYMBOL(bio_integrity_init_slab);
+
+static int __init integrity_init(void)
+{
+	kintegrityd_wq = create_workqueue("kintegrityd");
+
+	if (!kintegrityd_wq)
+		panic("Failed to create kintegrityd\n");
+
+	return 0;
+}
+subsys_initcall(integrity_init);
diff --git a/fs/bio.c b/fs/bio.c
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -50,6 +50,11 @@ static struct biovec_slab bvec_slabs[BIO
  */
 struct bio_set *fs_bio_set;
 
+inline unsigned int bvec_nr_vecs(unsigned short idx)
+{
+	return bvec_slabs[idx].nr_vecs;
+}
+
 struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx, struct bio_set *bs)
 {
 	struct bio_vec *bvl;
@@ -90,6 +95,9 @@ void bio_free(struct bio *bio, struct bi
 
 		mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
 	}
+
+	if (bio_integrity(bio))
+		bio_integrity_free(bio, bio_set);
 
 	mempool_free(bio, bio_set->bio_pool);
 }
@@ -249,9 +257,19 @@ struct bio *bio_clone(struct bio *bio, g
 {
 	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
 
-	if (b) {
-		b->bi_destructor = bio_fs_destructor;
-		__bio_clone(b, bio);
+	if (!b)
+		return NULL;
+
+	b->bi_destructor = bio_fs_destructor;
+	__bio_clone(b, bio);
+
+	if (bio_integrity(bio)) {
+		int ret;
+
+		ret = bio_integrity_clone(b, bio, fs_bio_set);
+
+		if (ret < 0)
+			return NULL;
 	}
 
 	return b;
@@ -1223,6 +1241,9 @@ struct bio_pair *bio_split(struct bio *b
 	bp->bio1.bi_private = bi;
 	bp->bio2.bi_private = pool;
 
+	if (bio_integrity(bi))
+		bio_integrity_split(bi, bp, first_sectors);
+
 	return bp;
 }
 
@@ -1264,6 +1285,7 @@ void bioset_free(struct bio_set *bs)
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
+	bioset_integrity_free(bs);
 	biovec_free_pools(bs);
 
 	kfree(bs);
@@ -1278,6 +1300,9 @@ struct bio_set *bioset_create(int bio_po
 
 	bs->bio_pool = mempool_create_slab_pool(bio_pool_size, bio_slab);
 	if (!bs->bio_pool)
+		goto bad;
+
+	if (bioset_integrity_create(bs, bio_pool_size))
 		goto bad;
 
 	if (!biovec_create_pools(bs, bvec_pool_size))
@@ -1306,6 +1331,7 @@ static int __init init_bio(void)
 {
 	bio_slab = KMEM_CACHE(bio, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
+	bio_integrity_init_slab();
 	biovec_init_slabs();
 
 	fs_bio_set = bioset_create(BIO_POOL_SIZE, 2);
diff --git a/include/linux/bio.h b/include/linux/bio.h
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -64,6 +64,7 @@ struct bio_vec {
 
 struct bio_set;
 struct bio;
+struct bio_integrity_payload;
 typedef void (bio_end_io_t) (struct bio *, int);
 typedef void (bio_destructor_t) (struct bio *);
 
@@ -112,6 +113,9 @@ struct bio {
 	atomic_t		bi_cnt;		/* pin count */
 
 	void			*bi_private;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	struct bio_integrity_payload *bi_integrity;  /* data integrity */
+#endif
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
 };
@@ -271,6 +275,29 @@ static inline void *bio_data(struct bio 
  */
 #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
 
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+/*
+ * bio integrity payload
+ */
+struct bio_integrity_payload {
+	struct bio		*bip_bio;	/* parent bio */
+	struct bio_vec		*bip_vec;	/* integrity data vector */
+
+	sector_t		bip_sector;	/* virtual start sector */
+
+	void			*bip_buf;	/* generated integrity data */
+	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
+
+	int			bip_error;	/* saved I/O error */
+	unsigned int		bip_size;
+
+	unsigned short		bip_pool;	/* pool the ivec came from */
+	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
+	unsigned short		bip_idx;	/* current bip_vec index */
+
+	struct work_struct	bip_work;	/* I/O completion */
+};
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 /*
  * A bio_pair is used when we need to split a bio.
@@ -283,10 +310,14 @@ static inline void *bio_data(struct bio 
  *   in bio2.bi_private
  */
 struct bio_pair {
-	struct bio	bio1, bio2;
-	struct bio_vec	bv1, bv2;
-	atomic_t	cnt;
-	int		error;
+	struct bio			bio1, bio2;
+	struct bio_vec			bv1, bv2;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	struct bio_integrity_payload	bip1, bip2;
+	struct bio_vec			iv1, iv2;
+#endif
+	atomic_t			cnt;
+	int				error;
 };
 extern struct bio_pair *bio_split(struct bio *bi, mempool_t *pool,
 				  int first_sectors);
@@ -334,6 +365,7 @@ extern int bio_uncopy_user(struct bio *)
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
 extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set *);
+extern inline unsigned int bvec_nr_vecs(unsigned short idx);
 
 /*
  * bio_set is used to allow other portions of the IO system to
@@ -346,6 +378,9 @@ extern struct bio_vec *bvec_alloc_bs(gfp
 
 struct bio_set {
 	mempool_t *bio_pool;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	mempool_t *bio_integrity_pool;
+#endif
 	mempool_t *bvec_pools[BIOVEC_NR_POOLS];
 };
 
@@ -410,5 +445,56 @@ static inline char *__bio_kmap_irq(struc
 	__bio_kmap_irq((bio), (bio)->bi_idx, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+
+#define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
+#define bip_vec(bip)		bip_vec_idx(bip, 0)
+
+#define __bip_for_each_vec(bvl, bip, i, start_idx)			\
+	for (bvl = bip_vec_idx((bip), (start_idx)), i = (start_idx);	\
+	     i < (bip)->bip_vcnt;					\
+	     bvl++, i++)
+
+#define bip_for_each_vec(bvl, bip, i)					\
+	__bip_for_each_vec(bvl, bip, i, (bip)->bip_idx)
+
+#define bio_integrity(bio)	((bio)->bi_integrity ? 1 : 0)
+
+extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
+extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
+extern void bio_integrity_free(struct bio *, struct bio_set *);
+extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
+extern int bio_integrity_enabled(struct bio *bio);
+extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
+extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
+extern int bio_integrity_prep(struct bio *);
+extern void bio_integrity_endio(struct bio *, int);
+extern void bio_integrity_advance(struct bio *, unsigned int);
+extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
+extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
+extern int bio_integrity_clone(struct bio *, struct bio *, struct bio_set *);
+extern int bioset_integrity_create(struct bio_set *, int);
+extern void bioset_integrity_free(struct bio_set *);
+extern void bio_integrity_init_slab(void);
+
+#else /* CONFIG_BLK_DEV_INTEGRITY */
+
+#define bio_integrity(a)		(0)
+#define bioset_integrity_create(a, b)	(0)
+#define bio_integrity_prep(a)		(0)
+#define bio_integrity_enabled(a)	(0)
+#define bio_integrity_clone(a, b, c)	(0)
+#define bioset_integrity_free(a)	do { } while (0)
+#define bio_integrity_free(a, b)	do { } while (0)
+#define bio_integrity_endio(a, b)	do { } while (0)
+#define bio_integrity_advance(a, b)	do { } while (0)
+#define bio_integrity_trim(a, b, c)	do { } while (0)
+#define bio_integrity_split(a, b, c)	do { } while (0)
+#define bio_integrity_set_tag(a, b, c)	do { } while (0)
+#define bio_integrity_get_tag(a, b, c)	do { } while (0)
+#define bio_integrity_init_slab(a)	do { } while (0)
+
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
+
 #endif /* CONFIG_BLOCK */
 #endif /* __LINUX_BIO_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -113,6 +113,7 @@ enum rq_flag_bits {
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_RW_META,		/* metadata io request */
 	__REQ_COPY_USER,	/* contains copies of user pages */
+	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -135,6 +136,7 @@ enum rq_flag_bits {
 #define REQ_ALLOCED	(1 << __REQ_ALLOCED)
 #define REQ_RW_META	(1 << __REQ_RW_META)
 #define REQ_COPY_USER	(1 << __REQ_COPY_USER)
+#define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
 
 #define BLK_MAX_CDB	16
 
@@ -866,6 +868,109 @@ void kblockd_flush_work(struct work_stru
 	MODULE_ALIAS("block-major-" __stringify(major) "-*")
 
 
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+
+#define INTEGRITY_FLAG_READ	1	/* verify data integrity on read */
+#define INTEGRITY_FLAG_WRITE	2	/* generate data integrity on write */
+
+struct blk_integrity_exchg {
+	void			*prot_buf;
+	void			*data_buf;
+	sector_t		sector;
+	unsigned int		data_size;
+	unsigned short		sector_size;
+	const char		*disk_name;
+};
+
+typedef void (integrity_gen_fn) (struct blk_integrity_exchg *);
+typedef int (integrity_vrfy_fn) (struct blk_integrity_exchg *);
+typedef void (integrity_set_tag_fn) (void *, void *, unsigned int);
+typedef void (integrity_get_tag_fn) (void *, void *, unsigned int);
+
+struct blk_integrity {
+	integrity_gen_fn	*generate_fn;
+	integrity_vrfy_fn	*verify_fn;
+	integrity_set_tag_fn	*set_tag_fn;
+	integrity_get_tag_fn	*get_tag_fn;
+
+	unsigned short		flags;
+	unsigned short		tuple_size;
+	unsigned short		sector_size;
+	unsigned short		tag_size;
+
+	const char		*name;
+
+	struct kobject		kobj;
+};
+
+extern int blk_integrity_register(struct gendisk *, struct blk_integrity *);
+extern void blk_integrity_unregister(struct gendisk *);
+extern int blk_integrity_compare(struct block_device *, struct block_device *);
+extern int blk_rq_map_integrity_sg(struct request *, struct scatterlist *);
+extern int blk_rq_count_integrity_sg(struct request *);
+
+static inline unsigned short blk_integrity_tuple_size(struct blk_integrity *bi)
+{
+	if (bi)
+		return bi->tuple_size;
+
+	return 0;
+}
+
+static inline struct blk_integrity *bdev_get_integrity(struct block_device *bdev)
+{
+	return bdev->bd_disk->integrity;
+}
+
+static inline unsigned int bdev_get_tag_size(struct block_device *bdev)
+{
+	struct blk_integrity *bi = bdev_get_integrity(bdev);
+
+	if (bi)
+		return bi->tag_size;
+
+	return 0;
+}
+
+static inline int bdev_integrity_enabled(struct block_device *bdev, int rw)
+{
+	struct blk_integrity *bi = bdev_get_integrity(bdev);
+
+	if (bi == NULL)
+		return 0;
+
+	if (rw == READ && bi->verify_fn != NULL &&
+	    test_bit(INTEGRITY_FLAG_READ, &bi->flags))
+		return 1;
+
+	if (rw == WRITE && bi->generate_fn != NULL &&
+	    test_bit(INTEGRITY_FLAG_WRITE, &bi->flags))
+		return 1;
+
+	return 0;
+}
+
+static inline int blk_integrity_rq(struct request *rq)
+{
+	BUG_ON(rq->bio == NULL);
+
+	return bio_integrity(rq->bio);
+}
+
+#else /* CONFIG_BLK_DEV_INTEGRITY */
+
+#define blk_integrity_rq(rq)			(0)
+#define blk_rq_count_integrity_sg(a)		(0)
+#define blk_rq_map_integrity_sg(a, b)		(0)
+#define bdev_get_integrity(a)			(0)
+#define bdev_get_tag_size(a)			(0)
+#define blk_integrity_compare(a, b)		(0)
+#define blk_integrity_register(a, b)		(0)
+#define blk_integrity_unregister(a)		do { } while (0);
+
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
+
+
 #else /* CONFIG_BLOCK */
 /*
  * stubs for when the block layer is configured out
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -141,6 +141,9 @@ struct gendisk {
 	struct disk_stats dkstats;
 #endif
 	struct work_struct async_notify;
+#ifdef  CONFIG_BLK_DEV_INTEGRITY
+	struct blk_integrity *integrity;
+#endif
 };
 
 /* 


