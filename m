From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] Percpu tag allocator
Date: Sat,  8 Jun 2013 02:42:16 +0000
Message-ID: <1370659338-23841-2-git-send-email-nab@linux-iscsi.org>
References: <1370659338-23841-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1370659338-23841-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Allocates integers out of a predefined range - for use by e.g. a driver
to allocate tags for communicating with the device.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Asias He <asias@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/tags.h |   38 +++++++++++
 lib/Kconfig          |    4 +
 lib/Makefile         |    5 +-
 lib/tags.c           |  166 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 211 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/tags.h
 create mode 100644 lib/tags.c

diff --git a/include/linux/tags.h b/include/linux/tags.h
new file mode 100644
index 0000000..1b8cfca
--- /dev/null
+++ b/include/linux/tags.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright 2012 Google Inc. All Rights Reserved.
+ * Author: koverstreet@google.com (Kent Overstreet)
+ *
+ * Per cpu tag allocator.
+ */
+
+#ifndef _LINUX_TAGS_H
+#define _LINUX_TAGS_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+struct tag_cpu_freelist;
+
+struct tag_pool {
+	unsigned			watermark;
+	unsigned			nr_tags;
+
+	struct tag_cpu_freelist		*tag_cpu;
+
+	struct {
+		/* Global freelist */
+		unsigned		nr_free;
+		unsigned		*free;
+		spinlock_t		lock;
+		struct list_head	wait;
+	} ____cacheline_aligned;
+};
+
+unsigned tag_alloc(struct tag_pool *pool, bool wait);
+void tag_free(struct tag_pool *pool, unsigned tag);
+
+void tag_pool_free(struct tag_pool *pool);
+int tag_pool_init(struct tag_pool *pool, unsigned long nr_tags);
+
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index fe01d41..401bf01 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -407,4 +407,8 @@ config OID_REGISTRY
 config UCS2_STRING
         tristate
 
+config PERCPU_TAG
+	boolean
+	default y
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index e9c52e1..2669d4c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o
+	 earlycpio.o tags.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
@@ -24,7 +24,8 @@ lib-y	+= kobject.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
+	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
+	 tags.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
diff --git a/lib/tags.c b/lib/tags.c
new file mode 100644
index 0000000..47745c3
--- /dev/null
+++ b/lib/tags.c
@@ -0,0 +1,166 @@
+/*
+ * Copyright 2012 Google Inc. All Rights Reserved.
+ * Author: koverstreet@google.com (Kent Overstreet)
+ *
+ * Per cpu tag allocator.
+ */
+
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/tags.h>
+
+struct tag_cpu_freelist {
+	unsigned			nr_free;
+	unsigned			free[];
+};
+
+struct tag_waiter {
+	struct list_head		list;
+	struct task_struct		*task;
+};
+
+static inline void move_tags(unsigned *dst, unsigned *dst_nr,
+			     unsigned *src, unsigned *src_nr,
+			     unsigned nr)
+{
+	*src_nr -= nr;
+	memcpy(dst + *dst_nr, src + *src_nr, sizeof(unsigned) * nr);
+	*dst_nr += nr;
+}
+
+unsigned tag_alloc(struct tag_pool *pool, bool wait)
+{
+	struct tag_cpu_freelist *tags;
+	unsigned long flags;
+	unsigned ret;
+retry:
+	preempt_disable();
+	local_irq_save(flags);
+	tags = this_cpu_ptr(pool->tag_cpu);
+
+	while (!tags->nr_free) {
+		spin_lock(&pool->lock);
+
+		if (pool->nr_free)
+			move_tags(tags->free, &tags->nr_free,
+				  pool->free, &pool->nr_free,
+				  min(pool->nr_free, pool->watermark));
+		else if (wait) {
+			struct tag_waiter wait = { .task = current };
+
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			list_add(&wait.list, &pool->wait);
+
+			spin_unlock(&pool->lock);
+			local_irq_restore(flags);
+			preempt_enable();
+
+			schedule();
+
+			if (!list_empty_careful(&wait.list)) {
+				spin_lock_irqsave(&pool->lock, flags);
+				list_del_init(&wait.list);
+				spin_unlock_irqrestore(&pool->lock, flags);
+			}
+
+			goto retry;
+		} else
+			goto fail;
+
+		spin_unlock(&pool->lock);
+	}
+
+	ret = tags->free[--tags->nr_free];
+
+	local_irq_restore(flags);
+	preempt_enable();
+
+	return ret;
+fail:
+	local_irq_restore(flags);
+	preempt_enable();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tag_alloc);
+
+void tag_free(struct tag_pool *pool, unsigned tag)
+{
+	struct tag_cpu_freelist *tags;
+	unsigned long flags;
+
+	preempt_disable();
+	local_irq_save(flags);
+	tags = this_cpu_ptr(pool->tag_cpu);
+
+	tags->free[tags->nr_free++] = tag;
+
+	if (tags->nr_free == pool->watermark * 2) {
+		spin_lock(&pool->lock);
+
+		move_tags(pool->free, &pool->nr_free,
+			  tags->free, &tags->nr_free,
+			  pool->watermark);
+
+		while (!list_empty(&pool->wait)) {
+			struct tag_waiter *wait;
+			wait = list_first_entry(&pool->wait,
+						struct tag_waiter, list);
+			list_del_init(&wait->list);
+			wake_up_process(wait->task);
+		}
+
+		spin_unlock(&pool->lock);
+	}
+
+	local_irq_restore(flags);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(tag_free);
+
+void tag_pool_free(struct tag_pool *pool)
+{
+	free_percpu(pool->tag_cpu);
+
+	free_pages((unsigned long) pool->free,
+		   get_order(pool->nr_tags * sizeof(unsigned)));
+}
+EXPORT_SYMBOL_GPL(tag_pool_free);
+
+int tag_pool_init(struct tag_pool *pool, unsigned long nr_tags)
+{
+	unsigned i, order;
+
+	spin_lock_init(&pool->lock);
+	INIT_LIST_HEAD(&pool->wait);
+	pool->nr_tags = nr_tags;
+
+	/* Guard against overflow */
+	if (nr_tags > UINT_MAX)
+		return -ENOMEM;
+
+	order = get_order(nr_tags * sizeof(unsigned));
+	pool->free = (void *) __get_free_pages(GFP_KERNEL, order);
+	if (!pool->free)
+		return -ENOMEM;
+
+	for (i = 1; i < nr_tags; i++)
+		pool->free[pool->nr_free++] = i;
+
+	/* nr_possible_cpus would be more correct */
+	pool->watermark = nr_tags / (num_possible_cpus() * 4);
+
+	pool->watermark = min(pool->watermark, 128);
+
+	if (pool->watermark > 64)
+		pool->watermark = round_down(pool->watermark, 32);
+
+	pool->tag_cpu = __alloc_percpu(sizeof(struct tag_cpu_freelist) +
+				       pool->watermark * 2 * sizeof(unsigned),
+				       sizeof(unsigned));
+	if (!pool->tag_cpu)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tag_pool_init);
-- 
1.7.2.5
