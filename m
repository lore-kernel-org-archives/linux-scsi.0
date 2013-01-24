From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 13/13] sg_io: introduce unpriv_sgio queue flag
Date: Thu, 24 Jan 2013 16:00:49 +0100
Message-ID: <1359039649-17734-14-git-send-email-pbonzini@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

This queue flag will let unprivileged users send any SG_IO command to
the device, without any filtering.

This is useful for virtualization, where some trusted guests would like
to send commands such as persistent reservations, but still the virtual
machine monitor should run with restricted permissions.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/block/queue-sysfs.txt |    8 ++++++++
 block/blk-sysfs.c                   |   33 +++++++++++++++++++++++++++++++++
 block/scsi_ioctl.c                  |    4 +++-
 include/linux/blkdev.h              |    3 +++
 4 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
index e54ac1d..341e781 100644
--- a/Documentation/block/queue-sysfs.txt
+++ b/Documentation/block/queue-sysfs.txt
@@ -133,6 +133,14 @@ control of this block device to that new IO scheduler. Note that writing
 an IO scheduler name to this file will attempt to load that IO scheduler
 module, if it isn't already present in the system.
 
+unpriv_sgio (RW)
+----------------
+When a process runs without CAP_SYS_RAWIO, access to some SCSI commands
+with the SG_IO ioctl is restricted.  If this option is '0', the whitelist
+is applied for all file descriptors belonging to unprivileged processes.
+If this option is '1', the whitelist is only applied for file descriptors
+that are opened read-only; other file descriptors can send all SCSI commands,
+and no restrictions are applied by the kernel.
 
 
 Jens Axboe <jens.axboe@oracle.com>, February 2009
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 7881477..ab2947d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -215,6 +215,32 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t
+queue_show_unpriv_sgio(struct request_queue *q, char *page)
+{
+	int bit;
+	bit = test_bit(QUEUE_FLAG_UNPRIV_SGIO, &q->queue_flags);
+	return queue_var_show(bit, page);
+}
+static ssize_t
+queue_store_unpriv_sgio(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long val;
+	ssize_t ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = queue_var_store(&val, page, count);
+	spin_lock_irq(q->queue_lock);
+	if (val)
+		queue_flag_set(QUEUE_FLAG_UNPRIV_SGIO, q);
+	else
+		queue_flag_clear(QUEUE_FLAG_UNPRIV_SGIO, q);
+	spin_unlock_irq(q->queue_lock);
+	return ret;
+}
+
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
 queue_show_##name(struct request_queue *q, char *page)			\
@@ -403,6 +429,12 @@ static struct queue_sysfs_entry queue_nonrot_entry = {
 	.store = queue_store_nonrot,
 };
 
+static struct queue_sysfs_entry queue_unpriv_sgio_entry = {
+	.attr = {.name = "unpriv_sgio", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_show_unpriv_sgio,
+	.store = queue_store_unpriv_sgio,
+};
+
 static struct queue_sysfs_entry queue_nomerges_entry = {
 	.attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_nomerges_show,
@@ -445,6 +477,7 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
 	&queue_write_same_max_entry.attr,
+	&queue_unpriv_sgio_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 27b844c..e0d7792 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -471,7 +471,9 @@ int blk_verify_command(struct request_queue *q,
 		return 0;
 
 	/* Write-safe commands require a writable open */
-	if (has_write_perm && filter->write_ok[cmd[0]] & (1 << q->sgio_type))
+	if (has_write_perm &&
+	    (blk_queue_unpriv_sgio(q) ||
+	     (filter->write_ok[cmd[0]] & (1 << q->sgio_type))))
 		return 0;
 
 	return -EPERM;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b376d37..71312ec 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -459,6 +459,7 @@ struct request_queue {
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
 #define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
+#define QUEUE_FLAG_UNPRIV_SGIO 20	/* SG_IO free for unprivileged users */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -534,6 +535,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
+#define blk_queue_unpriv_sgio(q) \
+	test_bit(QUEUE_FLAG_UNPRIV_SGIO, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
-- 
1.7.1
