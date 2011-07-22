From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/8] ida: Simplified functions for id allocation.
Date: Fri, 22 Jul 2011 17:41:10 +0100
Message-ID: <1311352886-4047-2-git-send-email-jic23@cam.ac.uk>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie
List-Id: linux-scsi@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

The current hyper-optimized functions are overkill if you simply want
to allocate an id for a device.  Create versions which use an internal
lock.

Thanks to Tejun for feedback.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 include/linux/idr.h |    4 +++
 lib/idr.c           |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 13a801f..255491c 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -146,6 +146,10 @@ void ida_remove(struct ida *ida, int id);
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask);
+void ida_simple_remove(struct ida *ida, unsigned int id);
+
 void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
index e15502e..db040ce 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -34,8 +34,10 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/idr.h>
+#include <linux/spinlock.h>
 
 static struct kmem_cache *idr_layer_cache;
+static DEFINE_SPINLOCK(simple_ida_lock);
 
 static struct idr_layer *get_from_free_list(struct idr *idp)
 {
@@ -926,6 +928,71 @@ void ida_destroy(struct ida *ida)
 EXPORT_SYMBOL(ida_destroy);
 
 /**
+ * ida_simple_get - get a new id.
+ * @ida: the (initialized) ida.
+ * @start: the minimum id (inclusive, < 0x8000000)
+ * @end: the maximum id (exclusive, < 0x8000000 or 0)
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocates an id in the range start <= id < end, or returns -ENOSPC.
+ * On memory allocation failure, returns -ENOMEM.
+ *
+ * Use ida_simple_remove() to get rid of an id.
+ */
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask)
+{
+	int ret, id;
+	unsigned int max;
+
+	BUG_ON((int)start < 0);
+	BUG_ON((int)end < 0);
+
+	if (end == 0)
+		max = 0x80000000;
+	else {
+		BUG_ON(end < start);
+		max = end - 1;
+	}
+
+again:
+	if (!ida_pre_get(ida, gfp_mask))
+		return -ENOMEM;
+
+	spin_lock(&simple_ida_lock);
+	ret = ida_get_new_above(ida, start, &id);
+	if (!ret) {
+		if (id > max) {
+			ida_remove(ida, id);
+			ret = -ENOSPC;
+		} else {
+			ret = id;
+		}
+	}
+	spin_unlock(&simple_ida_lock);
+
+	if (unlikely(ret == -EAGAIN))
+		goto again;
+
+	return ret;
+}
+EXPORT_SYMBOL(ida_simple_get);
+
+/**
+ * ida_simple_remove - remove an allocated id.
+ * @ida: the (initialized) ida.
+ * @id: the id returned by ida_simple_get.
+ */
+void ida_simple_remove(struct ida *ida, unsigned int id)
+{
+	BUG_ON((int)id < 0);
+	spin_lock(&simple_ida_lock);
+	ida_remove(ida, id);
+	spin_unlock(&simple_ida_lock);
+}
+EXPORT_SYMBOL(ida_simple_remove);
+
+/**
  * ida_init - initialize ida handle
  * @ida:	ida handle
  *
-- 
1.7.3.4
