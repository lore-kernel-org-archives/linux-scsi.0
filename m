From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5 of 7] block: Block/request layer data integrity support
Date: Sat, 07 Jun 2008 00:55:38 -0400
Message-ID: <5be7c534c9542dc4bab1.1212814538@sermon.lab.mkp.net>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:38420 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYFGE5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jun 2008 00:57:45 -0400
In-Reply-To: <patchbomb.1212814533@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

10 files changed, 849 insertions(+)
Documentation/block/data-integrity.txt |  327 +++++++++++++++++++++++++++
block/Kconfig                          |   12 
block/Makefile                         |    1 
block/blk-core.c                       |    7 
block/blk-integrity.c                  |  385 ++++++++++++++++++++++++++++++++
block/blk-merge.c                      |    3 
block/blk.h                            |    8 
block/elevator.c                       |    6 
include/linux/blkdev.h                 |   97 ++++++++
include/linux/genhd.h                  |    3 


Support for merging and mapping bio integrity metadata.

Block device integrity type registration.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r f2ae9d5bce4c -r 5be7c534c954 Documentation/block/data-integrity.txt
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/Documentation/block/data-integrity.txt	Sat Jun 07 00:45:15 2008 -0400
@@ -0,0 +1,327 @@
+----------------------------------------------------------------------
+1. INTRODUCTION
+
+Modern filesystems feature checksumming of data and metadata to
+protect against data corruption.  However, the detection of the
+corruption is done at read time which could potentially be months
+after the data was written.  At that point the original data that the
+application tried to write is most likely lost.
+
+The solution is to ensure that the disk is actually storing what the
+application meant it to.  Recent additions to both the SCSI family
+protocols (SBC Data Integrity Field, SCC protection proposal) as well
+as SATA/T13 (External Path Protection) try to remedy this by adding
+support for appending integrity metadata to an I/O.  The integrity
+metadata (or protection information in SCSI terminology) includes a
+checksum for each sector as well as an incrementing counter that
+ensures the individual sectors are written in the right order.  And
+for some protection schemes also that the I/O is written to the right
+place on disk.
+
+Current storage controllers and devices implement various protective
+measures, for instance checksumming and scrubbing.  But these
+technologies are working in their own isolated domains or at best
+between adjacent nodes in the I/O path.  The interesting thing about
+DIF and the other integrity extensions is that the protection format
+is well defined and every node in the I/O path can verify the
+integrity of the I/O and reject it if corruption is detected.  This
+allows not only corruption prevention but also isolation of the point
+of failure.
+
+----------------------------------------------------------------------
+2. THE DATA INTEGRITY EXTENSIONS
+
+As written, the protocol extensions only protect the path between
+controller and storage device.  However, many controllers actually
+allow the operating system to interact with the integrity metadata
+(IMD).  We have been working with several FC/SAS HBA vendors to enable
+the protection information to be transferred to and from their
+controllers.
+
+The SCSI Data Integrity Field works by appending 8 bytes of protection
+information to each sector.  The data + integrity metadata is stored
+in 520 byte sectors on disk.  Data + IMD are interleaved when
+transferred between the controller and target.  The T13 proposal is
+similar.
+
+Because it is highly inconvenient for operating systems to deal with
+520 (and 4104) byte sectors, we approached several HBA vendors and
+encouraged them to allow separation of the data and integrity metadata
+scatter-gather lists.
+
+The controller will interleave the buffers on write and split them on
+read.  This means that the Linux can DMA the data buffers to and from
+host memory without changes to the page cache.
+
+Also, the 16-bit CRC checksum mandated by both the SCSI and SATA specs
+is somewhat heavy to compute in software.  Benchmarks found that
+calculating this checksum had a significant impact on system
+performance for a number of workloads.  Some controllers allow a
+lighter-weight checksum to be used when interfacing with the operating
+system.  Emulex, for instance, supports the TCP/IP checksum instead.
+The IP checksum received from the OS is converted to the 16-bit CRC
+when writing and vice versa.  This allows the integrity metadata to be
+generated by Linux or the application at very low cost (comparable to
+software RAID5).
+
+The IP checksum is weaker than the CRC in terms of detecting bit
+errors.  However, the strength is really in the separation of the data
+buffers and the integrity metadata.  These two distinct buffers much
+match up for an I/O to complete.
+
+The separation of the data and integrity metadata buffers as well as
+the choice in checksums is referred to as the Data Integrity
+Extensions.  As these extensions are outside the scope of the protocol
+bodies (T10, T13), Oracle and its partners are trying to standardize
+them within the Storage Networking Industry Association.
+
+----------------------------------------------------------------------
+3. KERNEL CHANGES
+
+The data integrity framework in Linux enables protection information
+to be pinned to I/Os and sent to/received from controllers that
+support it.
+
+The advantage to the integrity extensions in SCSI and SATA is that
+they enable us to protect the entire path from application to storage
+device.  However, at the same time this is also the biggest
+disadvantage. It means that the protection information must be in a
+format that can be understood by the disk.
+
+Generally Linux/POSIX applications are agnostic to the intricacies of
+the storage devices they are accessing.  The virtual filesystem switch
+and the block layer make things like hardware sector size and
+transport protocols completely transparent to the application.
+
+However, this level of detail is required when preparing the
+protection information to send to a disk.  Consequently, the very
+concept of an end-to-end protection scheme is a layering violation.
+It is completely unreasonable for an application to be aware whether
+it is accessing a SCSI or SATA disk.
+
+The data integrity support implemented in Linux attempts to hide this
+from the application.  As far as the application (and to some extent
+the kernel) is concerned, the integrity metadata is opaque information
+that's attached to the I/O.
+
+The current implementation allows the block layer to automatically
+generate the protection information for any I/O.  Eventually the
+intent is to move the integrity metadata calculation to userspace for
+user data.  Metadata and other I/O that originates within the kernel
+will still use the automatic generation interface.
+
+Some storage devices allow each hardware sector to be tagged with a
+16-bit value.  The owner of this tag space is the owner of the block
+device.  I.e. the filesystem in most cases.  The filesystem can use
+this extra space to tag sectors as they see fit.  Because the tag
+space is limited, the block interface allows tagging bigger chunks by
+way of interleaving.  This way, 8*16 bits of information can be
+attached to a typical 4KB filesystem block.
+
+This also means that applications such as fsck and mkfs will need
+access to manipulate the tags from user space.  A passthrough
+interface for this is being worked on.
+
+
+----------------------------------------------------------------------
+4. BLOCK LAYER IMPLEMENTATION DETAILS
+
+4.1 BIO
+
+The data integrity patches add a new field to struct bio when
+CONFIG_BLK_DEV_INTEGRITY is enabled.  bio->bi_integrity is a pointer
+to a struct bip which contains the bio integrity payload.  Essentially
+a bip is a trimmed down struct bio which holds a bio_vec containing
+the integrity metadata and the required housekeeping information (bvec
+pool, vector count, etc.)
+
+A kernel subsystem can enable data integrity protection on a bio by
+calling bio_integrity_alloc(bio).  This will allocate and attach the
+bip to the bio.
+
+Individual pages containing integrity metadata can subsequently be
+attached using bio_integrity_add_page().
+
+bio_free() will automatically free the bip.
+
+
+4.2 BLOCK DEVICE
+
+Because the format of the protection data is tied to the physical
+disk, each block device has been extended with a block integrity
+profile (struct blk_integrity).  This optional profile is registered
+with the block layer using blk_integrity_register().
+
+The profile contains callback functions for generating and verifying
+the protection data, as well as getting and setting application tags.
+The profile also contains a few constants to aid in completing,
+merging and splitting the integrity metadata.
+
+Layered block devices will need to pick a profile that's appropriate
+for all subdevices.  blk_integrity_compare() can help with that.  DM
+and MD linear, RAID0 and RAID1 are currently supported.  RAID4/5/6
+will require extra work due to the application tag.
+
+
+----------------------------------------------------------------------
+5.0 BLOCK LAYER INTEGRITY API
+
+5.1 NORMAL FILESYSTEM
+
+    The normal filesystem is unaware that the underlying block device
+    is capable of sending/receiving integrity metadata.  The IMD will
+    be automatically generated by the block layer at submit_bio() time
+    in case of a WRITE.  A READ request will cause the I/O integrity
+    to be verified upon completion.
+
+    IMD generation and verification can be toggled using the
+
+      /sys/class/block/<bdev>/integrity/write_generate
+
+    and
+
+      /sys/class/block/<bdev>/integrity/read_verify
+
+    flags.
+
+
+5.2 INTEGRITY-AWARE FILESYSTEM
+
+    A filesystem that is integrity-aware can prepare I/Os with IMD
+    attached.  It can also use the application tag space if this is
+    supported by the block device.
+
+
+    int bdev_integrity_enabled(block_device, int rw);
+
+      bdev_integrity_enabled() will return 1 if the block device
+      supports integrity metadata transfer for the data direction
+      specified in 'rw'.
+
+      bdev_integrity_enabled() honors the write_generate and
+      read_verify flags in sysfs and will respond accordingly.
+
+
+    int bio_integrity_prep(bio);
+
+      To generate IMD for WRITE and to set up buffers for READ, the
+      filesystem must call bio_integrity_prep(bio).
+
+      Prior to calling this function, the bio data direction and start
+      sector must be set, and the bio should have all data pages
+      added.  It is up to the caller to ensure that the bio does not
+      change while I/O is in progress.
+
+      bio_integrity_prep() should only be called if
+      bio_integrity_enabled() returned 1.
+
+
+    int bio_integrity_tag_size(bio);
+
+      If the filesystem wants to use the application tag space it will
+      first have to find out how much storage space is available.
+      Because tag space is generally limited (usually 2 bytes per
+      sector regardless of sector size), the integrity framework
+      supports interleaving the information between the sectors in an
+      I/O.
+
+      Filesystems can call bio_integrity_tag_size(bio) to find out how
+      many bytes of storage are available for that particular bio.
+
+      Another option is bdev_get_tag_size(block_device) which will
+      return the number of available bytes per hardware sector.
+
+
+    int bio_integrity_set_tag(bio, void *tag_buf, len);
+
+      After a successful return from bio_integrity_prep(),
+      bio_integrity_set_tag() can be used to attach an opaque tag
+      buffer to a bio.  Obviously this only makes sense if the I/O is
+      a WRITE.
+
+
+    int bio_integrity_get_tag(bio, void *tag_buf, len);
+
+      Similarly, at READ I/O completion time the filesystem can
+      retrieve the tag buffer using bio_integrity_get_tag().
+
+
+6.3 PASSING EXISTING INTEGRITY METADATA
+
+    Filesystems that either generate their own integrity metadata or
+    are capable of transferring IMD from user space can use the
+    following calls:
+
+
+    struct bip * bio_integrity_alloc(bio, gfp_mask, nr_pages);
+
+      Allocates the bio integrity payload and hangs it off of the bio.
+      nr_pages indicate how many pages of protection data need to be
+      stored in the integrity bio_vec list (similar to bio_alloc()).
+
+      The integrity payload will be freed at bio_free() time.
+
+
+    int bio_integrity_add_page(bio, page, len, offset);
+
+      Attaches a page containing integrity metadata to an existing
+      bio.  The bio must have an existing bip,
+      i.e. bio_integrity_alloc() must have been called.  For a WRITE,
+      the integrity metadata in the pages must be in a format
+      understood by the target device with the notable exception that
+      the sector numbers will be remapped as the request traverses the
+      I/O stack.  This implies that the pages added using this call
+      will be modified during I/O!  The first reference tag in the
+      integrity metadata must have a value of bip->bip_sector.
+
+      Pages can be added using bio_integrity_add_page() as long as
+      there is room in the bip bio_vec array (nr_pages).
+
+      Upon completion of a READ operation, the attached pages will
+      contain the integrity metadata received from the storage device.
+      It is up to the receiver to process them and verify data
+      integrity upon completion.
+
+
+6.4 REGISTERING A BLOCK DEVICE AS CAPABLE OF EXCHANGING INTEGRITY
+    METADATA
+
+    To enable integrity exchange on a block device the gendisk must be
+    registered as capable:
+
+    int blk_integrity_register(gendisk, blk_integrity);
+
+      The blk_integrity struct is a template and should contain the
+      following:
+
+        static struct blk_integrity my_profile = {
+            .name                   = "STANDARDSBODY-TYPE-VARIANT-CSUM",
+            .generate_fn            = my_generate_fn,
+       	    .verify_fn              = my_verify_fn,
+       	    .get_tag_fn             = my_get_tag_fn,
+       	    .set_tag_fn             = my_set_tag_fn,
+	    .tuple_size             = sizeof(struct my_tuple_size),
+	    .tag_size               = <tag bytes per hw sector>,
+        };
+
+      'name' is a text string which will be visible in sysfs.  This is
+      part of the userland API so chose it carefully and never change
+      it.  The format is standards body-type-variant.
+      E.g. T10-DIF-TYPE1-IP or T13-EPP-0-CRC.
+
+      'generate_fn' generates appropriate integrity metadata (for WRITE).
+
+      'verify_fn' verifies that the data buffer matches the integrity
+      metadata.
+
+      'tuple_size' must be set to match the size of the integrity
+      metadata per sector.  I.e. 8 for DIF and EPP.
+
+      'tag_size' must be set to identify how many bytes of tag space
+      are available per hardware sector.  For DIF this is either 2 or
+      0 depending on the value of the Control Mode Page ATO bit.
+
+      See 6.2 for a description of get_tag_fn and set_tag_fn.
+
+----------------------------------------------------------------------
+2007-12-24 Martin K. Petersen <martin.petersen@oracle.com>
diff -r f2ae9d5bce4c -r 5be7c534c954 block/Kconfig
--- a/block/Kconfig	Sat Jun 07 00:45:15 2008 -0400
+++ b/block/Kconfig	Sat Jun 07 00:45:15 2008 -0400
@@ -81,6 +81,18 @@
 
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
+	Protection.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
diff -r f2ae9d5bce4c -r 5be7c534c954 block/Makefile
--- a/block/Makefile	Sat Jun 07 00:45:15 2008 -0400
+++ b/block/Makefile	Sat Jun 07 00:45:15 2008 -0400
@@ -14,3 +14,4 @@
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
+obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
diff -r f2ae9d5bce4c -r 5be7c534c954 block/blk-core.c
--- a/block/blk-core.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/block/blk-core.c	Sat Jun 07 00:45:15 2008 -0400
@@ -143,6 +143,10 @@
 
 		bio->bi_size -= nbytes;
 		bio->bi_sector += (nbytes >> 9);
+
+		if (bio_integrity(bio))
+			bio_integrity_advance(bio, nbytes);
+
 		if (bio->bi_size == 0)
 			bio_endio(bio, error);
 	} else {
@@ -1381,6 +1385,9 @@
 		 */
 		blk_partition_remap(bio);
 
+		if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
+			goto end_io;
+
 		if (old_sector != -1)
 			blk_add_trace_remap(q, bio, old_dev, bio->bi_sector,
 					    old_sector);
diff -r f2ae9d5bce4c -r 5be7c534c954 block/blk-integrity.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/block/blk-integrity.c	Sat Jun 07 00:45:15 2008 -0400
@@ -0,0 +1,385 @@
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
+		if (ivprv && BIOVEC_PHYS_MERGEABLE(ivprv, iv))
+			;
+		else
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
+	ssize_t ret = -EIO;
+
+	if (entry->show)
+		ret = entry->show(bi, page);
+
+	return ret;
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
+	if (val == 1)
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
+	if (val == 1)
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
+					 &disk->dev.kobj, "%s", "integrity"))
+			return -1;
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
+}
+EXPORT_SYMBOL(blk_integrity_unregister);
diff -r f2ae9d5bce4c -r 5be7c534c954 block/blk-merge.c
--- a/block/blk-merge.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/block/blk-merge.c	Sat Jun 07 00:45:15 2008 -0400
@@ -441,6 +441,9 @@
 	    || next->special)
 		return 0;
 
+	if (blk_integrity_rq(req) != blk_integrity_rq(next))
+		return 0;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
diff -r f2ae9d5bce4c -r 5be7c534c954 block/blk.h
--- a/block/blk.h	Sat Jun 07 00:45:15 2008 -0400
+++ b/block/blk.h	Sat Jun 07 00:45:15 2008 -0400
@@ -51,4 +51,12 @@
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
diff -r f2ae9d5bce4c -r 5be7c534c954 block/elevator.c
--- a/block/elevator.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/block/elevator.c	Sat Jun 07 00:45:15 2008 -0400
@@ -84,6 +84,12 @@
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
diff -r f2ae9d5bce4c -r 5be7c534c954 include/linux/blkdev.h
--- a/include/linux/blkdev.h	Sat Jun 07 00:45:15 2008 -0400
+++ b/include/linux/blkdev.h	Sat Jun 07 00:45:15 2008 -0400
@@ -113,6 +113,7 @@
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_RW_META,		/* metadata io request */
 	__REQ_COPY_USER,	/* contains copies of user pages */
+	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -135,6 +136,7 @@
 #define REQ_ALLOCED	(1 << __REQ_ALLOCED)
 #define REQ_RW_META	(1 << __REQ_RW_META)
 #define REQ_COPY_USER	(1 << __REQ_COPY_USER)
+#define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
 
 #define BLK_MAX_CDB	16
 
@@ -866,6 +868,101 @@
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
+	return (bi == NULL) ? 0 : bi->tuple_size;
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
+	return (bi == NULL) ? 0 : bi->tag_size;
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
diff -r f2ae9d5bce4c -r 5be7c534c954 include/linux/genhd.h
--- a/include/linux/genhd.h	Sat Jun 07 00:45:15 2008 -0400
+++ b/include/linux/genhd.h	Sat Jun 07 00:45:15 2008 -0400
@@ -141,6 +141,9 @@
 	struct disk_stats dkstats;
 #endif
 	struct work_struct async_notify;
+#ifdef  CONFIG_BLK_DEV_INTEGRITY
+	struct blk_integrity *integrity;
+#endif
 };
 
 /* 


