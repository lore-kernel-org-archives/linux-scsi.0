From: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 12 Jun 2009 16:13:46 +0200
Message-ID: <20090612141346.GY5139@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com> <20090611081032.GN5139@amd.com> <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="neYutvxvOLaeuPCA"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:63831 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZFLOOO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 10:14:14 -0400
Content-Disposition: inline
In-Reply-To: <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

--neYutvxvOLaeuPCA
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
> DMA-API: device driver tries to free DM
> A memory it has not allocated [device address=3D0x000000011e4c3000]
> [size=3D4096 bytes]

Hmm, looking again over the code I've seen that the ref
dma_debug_entries are not alway filled with all necessary information
for best-fit. Can you please try if you still get false warnings when
you apply the two patches attached instead of the one I sent yesterday?

Thanks,

	Joerg

--=20
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei M=FCnchen
 System    |=20
 Research  | Gesch=E4ftsf=FChrer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis M=FCnchen
           | Registergericht M=FCnchen, HRB Nr. 43632

--neYutvxvOLaeuPCA
Content-Type: text/x-diff; charset="us-ascii"
Content-Disposition: attachment;
	filename="0001-dma-debug-check-for-sg_call_ents-in-best-fit-algorit.patch"

>From 4620c534541fb4d28c0c52553274ef94a43813ab Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 11 Jun 2009 10:03:42 +0200
Subject: [PATCH 1/2] dma-debug: check for sg_call_ents in best-fit algorithm too

If we don't check for sg_call_ents the hash_bucket_find function might
still return the wrong dma_debug_entry for sg mappings.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ad65fc0..c71e2dd 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -262,11 +262,12 @@ static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 		 */
 		matches += 1;
 		match_lvl = 0;
-		entry->size      == ref->size      ? ++match_lvl : match_lvl;
-		entry->type      == ref->type      ? ++match_lvl : match_lvl;
-		entry->direction == ref->direction ? ++match_lvl : match_lvl;
+		entry->size         == ref->size         ? ++match_lvl : 0;
+		entry->type         == ref->type         ? ++match_lvl : 0;
+		entry->direction    == ref->direction    ? ++match_lvl : 0;
+		entry->sg_call_ents == ref->sg_call_ents ? ++match_lvl : 0;
 
-		if (match_lvl == 3) {
+		if (match_lvl == 4) {
 			/* perfect-fit - return the result */
 			return entry;
 		} else if (match_lvl > last_lvl) {
@@ -1076,16 +1077,14 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			.dev_addr       = sg_dma_address(s),
 			.size           = sg_dma_len(s),
 			.direction      = dir,
-			.sg_call_ents   = 0,
+			.sg_call_ents   = nelems,
 		};
 
 		if (mapped_ents && i >= mapped_ents)
 			break;
 
-		if (!i) {
-			ref.sg_call_ents = nelems;
+		if (!i)
 			mapped_ents = get_nr_mapped_entries(dev, s);
-		}
 
 		check_unmap(&ref);
 	}
-- 
1.6.3.1


--neYutvxvOLaeuPCA
Content-Type: text/x-diff; charset="us-ascii"
Content-Disposition: attachment;
	filename="0002-dma-debug-be-more-careful-when-building-reference-en.patch"

>From 15aad0cfd5061c6c479666234278d1473445c473 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 12 Jun 2009 15:25:06 +0200
Subject: [PATCH 2/2] dma-debug: be more careful when building reference entries

The current code is not very careful when it builds reference
dma_debug_entries which get passed to hash_bucket_find(). But since this
function changed to a best-fit algorithm these entries have to be more
acurate. This patch adds this higher level of accuracy.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |  134 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index c71e2dd..3b93129 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -874,72 +874,68 @@ static void check_for_illegal_area(struct device *dev, void *addr, u64 size)
 				"[addr=%p] [size=%llu]\n", addr, size);
 }
 
-static void check_sync(struct device *dev, dma_addr_t addr,
-		       u64 size, u64 offset, int direction, bool to_cpu)
+static void check_sync(struct device *dev,
+		       struct dma_debug_entry *ref,
+		       bool to_cpu)
 {
-	struct dma_debug_entry ref = {
-		.dev            = dev,
-		.dev_addr       = addr,
-		.size           = size,
-		.direction      = direction,
-	};
 	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	bucket = get_hash_bucket(&ref, &flags);
+	bucket = get_hash_bucket(ref, &flags);
 
-	entry = hash_bucket_find(bucket, &ref);
+	entry = hash_bucket_find(bucket, ref);
 
 	if (!entry) {
 		err_printk(dev, NULL, "DMA-API: device driver tries "
 				"to sync DMA memory it has not allocated "
 				"[device address=0x%016llx] [size=%llu bytes]\n",
-				(unsigned long long)addr, size);
+				(unsigned long long)ref->dev_addr, ref->size);
 		goto out;
 	}
 
-	if ((offset + size) > entry->size) {
+	if (ref->size > entry->size) {
 		err_printk(dev, entry, "DMA-API: device driver syncs"
 				" DMA memory outside allocated range "
 				"[device address=0x%016llx] "
-				"[allocation size=%llu bytes] [sync offset=%llu] "
-				"[sync size=%llu]\n", entry->dev_addr, entry->size,
-				offset, size);
+				"[allocation size=%llu bytes] "
+				"[sync offset+size=%llu]\n",
+				entry->dev_addr, entry->size,
+				ref->size);
 	}
 
-	if (direction != entry->direction) {
+	if (ref->direction != entry->direction) {
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"DMA memory with different direction "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
+				(unsigned long long)ref->dev_addr, entry->size,
 				dir2name[entry->direction],
-				dir2name[direction]);
+				dir2name[ref->direction]);
 	}
 
 	if (entry->direction == DMA_BIDIRECTIONAL)
 		goto out;
 
 	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
-		      !(direction == DMA_TO_DEVICE))
+		      !(ref->direction == DMA_TO_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"device read-only DMA memory for cpu "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
+				(unsigned long long)ref->dev_addr, entry->size,
 				dir2name[entry->direction],
-				dir2name[direction]);
+				dir2name[ref->direction]);
 
 	if (!to_cpu && !(entry->direction == DMA_TO_DEVICE) &&
-		       !(direction == DMA_FROM_DEVICE))
+		       !(ref->direction == DMA_FROM_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"device write-only DMA memory to device "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
+				(unsigned long long)ref->dev_addr, entry->size,
 				dir2name[entry->direction],
-				dir2name[direction]);
+				dir2name[ref->direction]);
 
 out:
 	put_hash_bucket(bucket, &flags);
@@ -1037,19 +1033,16 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 }
 EXPORT_SYMBOL(debug_dma_map_sg);
 
-static int get_nr_mapped_entries(struct device *dev, struct scatterlist *s)
+static int get_nr_mapped_entries(struct device *dev,
+				 struct dma_debug_entry *ref)
 {
-	struct dma_debug_entry *entry, ref;
+	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 	int mapped_ents;
 
-	ref.dev      = dev;
-	ref.dev_addr = sg_dma_address(s);
-	ref.size     = sg_dma_len(s),
-
-	bucket       = get_hash_bucket(&ref, &flags);
-	entry        = hash_bucket_find(bucket, &ref);
+	bucket       = get_hash_bucket(ref, &flags);
+	entry        = hash_bucket_find(bucket, ref);
 	mapped_ents  = 0;
 
 	if (entry)
@@ -1084,7 +1077,7 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			break;
 
 		if (!i)
-			mapped_ents = get_nr_mapped_entries(dev, s);
+			mapped_ents = get_nr_mapped_entries(dev, &ref);
 
 		check_unmap(&ref);
 	}
@@ -1139,10 +1132,19 @@ EXPORT_SYMBOL(debug_dma_free_coherent);
 void debug_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 				   size_t size, int direction)
 {
+	struct dma_debug_entry ref;
+
 	if (unlikely(global_disable))
 		return;
 
-	check_sync(dev, dma_handle, size, 0, direction, true);
+	ref.type         = dma_debug_single;
+	ref.dev          = dev;
+	ref.dev_addr     = dma_handle;
+	ref.size         = size;
+	ref.direction    = direction;
+	ref.sg_call_ents = 0;
+
+	check_sync(dev, &ref, true);
 }
 EXPORT_SYMBOL(debug_dma_sync_single_for_cpu);
 
@@ -1150,10 +1152,19 @@ void debug_dma_sync_single_for_device(struct device *dev,
 				      dma_addr_t dma_handle, size_t size,
 				      int direction)
 {
+	struct dma_debug_entry ref;
+
 	if (unlikely(global_disable))
 		return;
 
-	check_sync(dev, dma_handle, size, 0, direction, false);
+	ref.type         = dma_debug_single;
+	ref.dev          = dev;
+	ref.dev_addr     = dma_handle;
+	ref.size         = size;
+	ref.direction    = direction;
+	ref.sg_call_ents = 0;
+
+	check_sync(dev, &ref, false);
 }
 EXPORT_SYMBOL(debug_dma_sync_single_for_device);
 
@@ -1162,10 +1173,19 @@ void debug_dma_sync_single_range_for_cpu(struct device *dev,
 					 unsigned long offset, size_t size,
 					 int direction)
 {
+	struct dma_debug_entry ref;
+
 	if (unlikely(global_disable))
 		return;
 
-	check_sync(dev, dma_handle, size, offset, direction, true);
+	ref.type         = dma_debug_single;
+	ref.dev          = dev;
+	ref.dev_addr     = dma_handle;
+	ref.size         = offset + size;
+	ref.direction    = direction;
+	ref.sg_call_ents = 0;
+
+	check_sync(dev, &ref, true);
 }
 EXPORT_SYMBOL(debug_dma_sync_single_range_for_cpu);
 
@@ -1174,10 +1194,19 @@ void debug_dma_sync_single_range_for_device(struct device *dev,
 					    unsigned long offset,
 					    size_t size, int direction)
 {
+	struct dma_debug_entry ref;
+
 	if (unlikely(global_disable))
 		return;
 
-	check_sync(dev, dma_handle, size, offset, direction, false);
+	ref.type         = dma_debug_single;
+	ref.dev          = dev;
+	ref.dev_addr     = dma_handle;
+	ref.size         = offset + size;
+	ref.direction    = direction;
+	ref.sg_call_ents = 0;
+
+	check_sync(dev, &ref, false);
 }
 EXPORT_SYMBOL(debug_dma_sync_single_range_for_device);
 
@@ -1191,14 +1220,24 @@ void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
+
+		struct dma_debug_entry ref = {
+			.type           = dma_debug_sg,
+			.dev            = dev,
+			.paddr          = sg_phys(s),
+			.dev_addr       = sg_dma_address(s),
+			.size           = sg_dma_len(s),
+			.direction      = direction,
+			.sg_call_ents   = nelems,
+		};
+
 		if (!i)
-			mapped_ents = get_nr_mapped_entries(dev, s);
+			mapped_ents = get_nr_mapped_entries(dev, &ref);
 
 		if (i >= mapped_ents)
 			break;
 
-		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
-			   direction, true);
+		check_sync(dev, &ref, true);
 	}
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_cpu);
@@ -1213,14 +1252,23 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
+
+		struct dma_debug_entry ref = {
+			.type           = dma_debug_sg,
+			.dev            = dev,
+			.paddr          = sg_phys(s),
+			.dev_addr       = sg_dma_address(s),
+			.size           = sg_dma_len(s),
+			.direction      = direction,
+			.sg_call_ents   = nelems,
+		};
 		if (!i)
-			mapped_ents = get_nr_mapped_entries(dev, s);
+			mapped_ents = get_nr_mapped_entries(dev, &ref);
 
 		if (i >= mapped_ents)
 			break;
 
-		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
-			   direction, false);
+		check_sync(dev, &ref, false);
 	}
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_device);
-- 
1.6.3.1


--neYutvxvOLaeuPCA--
