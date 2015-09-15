From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 01/17] Add ida and idr helper routines.
Date: Tue, 15 Sep 2015 09:46:01 -0700
Message-ID: <915ec9ff5e9cc1fae0b36bf7d4c4cb115439e15d.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbbIOQrp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Sep 2015 12:47:45 -0400
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>

Clients of the ida and idr index-management routines
tend to use the same calling sequences much of the time,
so this change adds helper functions for allocating and
releasing indexes of either flavor, i.e. with or
without pointer management.

Inline functions added for idr:
  idr_get_index_in_range
  idr_get_index (in range 0,0)
  idr_put_index
And for ida:
  ida_get_index
  ida_put_index

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 include/linux/idr.h | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 013fd9bc4cb6..341c4f2d9874 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -16,6 +16,8 @@
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+#include <linux/gfp.h>
 
 /*
  * We want shallower trees and thus more bits covered at each layer.  8
@@ -183,4 +185,104 @@ static inline int ida_get_new(struct ida *ida, int *p_id)
 
 void __init idr_init_cache(void);
 
+/**
+ * ida_get_index - allocate a ida index value
+ * @ida		idr handle
+ * @lock	spinlock handle protecting this index
+ * @p_id	pointer to allocated index value
+ *
+ * A helper function for safely allocating an index value (id),
+ * returning a negative errno value on failure, else 0.
+ */
+static inline int ida_get_index(struct ida *ida, spinlock_t *lock, int *p_id)
+{
+	int error = -ENOMEM;
+
+	do {
+		if (!ida_pre_get(ida, GFP_KERNEL))
+			break;
+		spin_lock(lock);
+		error = ida_get_new(ida, p_id);
+		spin_unlock(lock);
+	} while (error == -EAGAIN);
+
+	return error;
+}
+
+/**
+ * ida_put_index - free an allocated ida index value
+ * @ida		idr handle
+ * @lock	spinlock handle protecting this index
+ * @id		the value of the allocated index
+ *
+ * A helper function that goes with @ida_get_index, which safely
+ * frees a previously-allocated index value.
+ */
+static inline void ida_put_index(struct ida *ida, spinlock_t *lock, int id)
+{
+	spin_lock(lock);
+	ida_remove(ida, id);
+	spin_unlock(lock);
+}
+
+/**
+ * idr_get_index_in_range - allocate a new index, with locking
+ *		            within a range
+ * @idr:	idr handle
+ * @lock:	spin lock handle protecting the index
+ * @ptr:	pointer to associate with allocated index
+ * @start:	starting index (see idr_alloc)
+ * @end:	ending index (0 -> use default max)
+ *
+ * This is a helper routine meant to make the common
+ * calling sequence to allocate an idr index easier.
+ * It uses a spin lock, and allocates a positive index
+ * in the range of [start,end), returning a negative
+ * errno on failure, else 0.
+ */
+static inline int idr_get_index_in_range(struct idr *idr, spinlock_t *lock,
+					 void *ptr, int start, int end)
+{
+	int ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(lock);
+	ret = idr_alloc(idr, ptr, start, end, GFP_NOWAIT);
+	spin_unlock(lock);
+	idr_preload_end();
+
+	return ret;
+}
+
+/**
+ * idr_get_index - allocate new index, with locking, using the
+ *		   default range (zero to max-1)
+ * @idr:	idr handle
+ * @lock:	spin lock handle protecting the index
+ * @ptr:	pointer to associate with allocated index
+ *
+ * Simple wrapper around idr_get_index_in_range() w/ @start and
+ * @end of 0, since this is a common case
+ */
+static inline int idr_get_index(struct idr *idr, spinlock_t *lock, void *ptr)
+{
+	return idr_get_index_in_range(idr, lock, ptr, 0, 0);
+}
+
+/**
+ * idr_put_index - free an allocated idr index value
+ * @idr		idr handle
+ * @lock	spinlock handle protecting this index
+ * @id		the value of the allocated index
+ *
+ * A helper function that goes with @idr_get_index, which safely
+ * frees a previously-allocated index value.
+ */
+static inline void idr_put_index(struct idr *idr, spinlock_t *lock, int id)
+{
+	spin_lock(lock);
+	idr_remove(idr, id);
+	spin_unlock(lock);
+}
+
 #endif /* __IDR_H__ */
-- 
2.1.4

