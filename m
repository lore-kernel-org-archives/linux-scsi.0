From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 069/104] lib/string_helpers.c:string_get_size(): remove
 redundant prefixes
Date: Fri, 13 Feb 2015 16:05:54 -0800
Message-ID: <1423872354.10229.7.camel@HansenPartnership.com>
References: <54dd30d9.8sIvA5PVH18vSWTI%akpm@linux-foundation.org>
	 <1423783508.6286.25.camel@HansenPartnership.com>
	 <20150212154019.6c27b3301962c0650ee3a516@linux-foundation.org>
	 <1423784729.6286.32.camel@HansenPartnership.com>
	 <20150212155516.937d2df60ad00737096478b2@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40203 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbbBNAF4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2015 19:05:56 -0500
In-Reply-To: <20150212155516.937d2df60ad00737096478b2@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux@rasmusvillemoes.dk, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2015-02-12 at 15:55 -0800, Andrew Morton wrote:
> On Thu, 12 Feb 2015 15:45:29 -0800 James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> 
> > ...
> >
> > > I don't get it.  As the man says, this is presently dead code and
> > > string_get_size() will need to be changed to work for disks larger than
> > > 2^64 bytes.  That change may be to take a u128 or it may be as you
> > > suggest: replace the `u64 size' with `u64 size, u64 units' which is
> > > effectively the same thing.
> > 
> > The first thing someone's going to do is pass in blocks, because that's
> > the way the rest of block functions. If we're lucky the add "ZB" too,
> > but if not we run off the end in some obscure large cluster somewhere.
> > Don't set people up to make mistakes.
> 
> Well maybe.  A little bit.  But it assumes that someone is going to
> make a change then not test it.

That would be SOP for very large devices ... very few developers have
access.  However, since it's easy to fix, I'll do that instead of
complaining about the lack of analysis.

This fixes the routine and all the call sites to pass arguments in in
terms of a known block size.  Given that all the callers were scaling
from blocks to bytes anyway, it fits naturally and fixes the overflow
that would occur with very large devices in the old scheme.

James

---

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index cdfbd21..26d2440 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -344,7 +344,7 @@ static void virtblk_config_changed_work(struct work_struct *work)
 	struct request_queue *q = vblk->disk->queue;
 	char cap_str_2[10], cap_str_10[10];
 	char *envp[] = { "RESIZE=1", NULL };
-	u64 capacity, size;
+	u64 capacity;
 
 	/* Host must always specify the capacity. */
 	virtio_cread(vdev, struct virtio_blk_config, capacity, &capacity);
@@ -356,9 +356,10 @@ static void virtblk_config_changed_work(struct work_struct *work)
 		capacity = (sector_t)-1;
 	}
 
-	size = capacity * queue_logical_block_size(q);
-	string_get_size(size, STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
-	string_get_size(size, STRING_UNITS_10, cap_str_10, sizeof(cap_str_10));
+	string_get_size(capacity, queue_logical_block_size(q),
+			STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
+	string_get_size(capacity, queue_logical_block_size(q),
+			STRING_UNITS_10, cap_str_10, sizeof(cap_str_10));
 
 	dev_notice(&vdev->dev,
 		  "new size: %llu %d-byte logical blocks (%s/%s)\n",
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index c69afb5..2fc4269 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2230,7 +2230,7 @@ static int mmc_blk_alloc_part(struct mmc_card *card,
 	part_md->part_type = part_type;
 	list_add(&part_md->part, &md->part);
 
-	string_get_size((u64)get_capacity(part_md->disk) << 9, STRING_UNITS_2,
+	string_get_size((u64)get_capacity(part_md->disk), 512, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
 	pr_info("%s: %s %s partition %u %s\n",
 	       part_md->disk->disk_name, mmc_card_id(card),
@@ -2436,7 +2436,7 @@ static int mmc_blk_probe(struct device *dev)
 	if (IS_ERR(md))
 		return PTR_ERR(md);
 
-	string_get_size((u64)get_capacity(md->disk) << 9, STRING_UNITS_2,
+	string_get_size((u64)get_capacity(md->disk), 512, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
 	pr_info("%s: %s %s %s %s\n",
 		md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6b78476..3c7fe4e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2235,11 +2235,11 @@ got_data:
 
 	{
 		char cap_str_2[10], cap_str_10[10];
-		u64 sz = (u64)sdkp->capacity << ilog2(sector_size);
 
-		string_get_size(sz, STRING_UNITS_2, cap_str_2,
-				sizeof(cap_str_2));
-		string_get_size(sz, STRING_UNITS_10, cap_str_10,
+		string_get_size(sdkp->capacity, sector_size,
+				STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
+		string_get_size(sdkp->capacity, sector_size,
+				STRING_UNITS_10, cap_str_10,
 				sizeof(cap_str_10));
 
 		if (sdkp->first_scan || old_capacity != sdkp->capacity) {
diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 6575718..2633280 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -10,7 +10,7 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
-void string_get_size(u64 size, enum string_size_units units,
+void string_get_size(u64 size, u64 blk_size, enum string_size_units units,
 		     char *buf, int len);
 
 #define UNESCAPE_SPACE		0x01
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 8f8c441..bff19f8 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -4,6 +4,7 @@
  * Copyright 31 August 2008 James Bottomley
  * Copyright (C) 2013, Intel Corporation
  */
+#include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/export.h>
@@ -14,7 +15,8 @@
 
 /**
  * string_get_size - get the size in the specified units
- * @size:	The size to be converted
+ * @size:	The size to be converted in blocks
+ * @blk_size:	Size of the block (use 1 for size in bytes)
  * @units:	units to use (powers of 1000 or 1024)
  * @buf:	buffer to format to
  * @len:	length of buffer
@@ -24,14 +26,14 @@
  * at least 9 bytes and will always be zero terminated.
  *
  */
-void string_get_size(u64 size, const enum string_size_units units,
+void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		     char *buf, int len)
 {
 	static const char *const units_10[] = {
-		"B", "kB", "MB", "GB", "TB", "PB", "EB"
+		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
 	};
 	static const char *const units_2[] = {
-		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"
+		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"
 	};
 	static const char *const *const units_str[] = {
 		[STRING_UNITS_10] = units_10,
@@ -42,31 +44,60 @@ void string_get_size(u64 size, const enum string_size_units units,
 		[STRING_UNITS_2] = 1024,
 	};
 	int i, j;
-	u32 remainder = 0, sf_cap;
+	u32 remainder = 0, sf_cap, exp;
 	char tmp[8];
+	const char *unit;
 
 	tmp[0] = '\0';
 	i = 0;
+	if (!size)
+	  goto out;
+
+	if (blk_size >= divisor[units]) {
+		while (blk_size >= divisor[units]) {
+			remainder = do_div(blk_size, divisor[units]);
+			i++;
+		}
+	}
+	exp = divisor[units];
+	do_div(exp, blk_size);
+	if (size >= exp) {
+		remainder = do_div(size, divisor[units]);
+		remainder *= blk_size;
+		i++;
+	} else {
+		remainder *= size;
+	}
+	size *= blk_size;
+	size += (remainder/divisor[units]);
+	remainder %= divisor[units];
+
 	if (size >= divisor[units]) {
 		while (size >= divisor[units]) {
 			remainder = do_div(size, divisor[units]);
 			i++;
 		}
+	}
 
-		sf_cap = size;
-		for (j = 0; sf_cap*10 < 1000; j++)
-			sf_cap *= 10;
+	sf_cap = size;
+	for (j = 0; sf_cap*10 < 1000; j++)
+		sf_cap *= 10;
 
-		if (j) {
-			remainder *= 1000;
-			remainder /= divisor[units];
-			snprintf(tmp, sizeof(tmp), ".%03u", remainder);
-			tmp[j+1] = '\0';
-		}
+	if (j) {
+		remainder *= 1000;
+		remainder /= divisor[units];
+		snprintf(tmp, sizeof(tmp), ".%03u", remainder);
+		tmp[j+1] = '\0';
 	}
 
+ out:
+	if (i >= ARRAY_SIZE(units_2))
+		unit = "UNK";
+	else
+		unit = units_str[units][i];
+
 	snprintf(buf, len, "%u%s %s", (u32)size,
-		 tmp, units_str[units][i]);
+		 tmp, unit);
 }
 EXPORT_SYMBOL(string_get_size);
 


