From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 1/6] Add ida helper routines
Date: Sun,  6 Sep 2015 10:59:29 -0700
Message-ID: <f79198e4da3db4a3dc2b602f71dfc05c3cef956c.1441416572.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbbIFR7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Sep 2015 13:59:45 -0400
In-Reply-To: <cover.1441416571.git.lduncan@suse.com>
In-Reply-To: <cover.1441416571.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

Clients of the ida API routinely follow the
same steps to allocate and ida index, as well
as to free said index. These helper routines
should make it a little easier to use these
APIs.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 include/linux/idr.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 013fd9bc4cb6..5a9526dc6298 100644
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
@@ -183,4 +185,44 @@ static inline int ida_get_new(struct ida *ida, int *p_id)
 
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
 #endif /* __IDR_H__ */
-- 
2.1.4

