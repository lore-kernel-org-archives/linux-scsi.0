From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 2/2] sg_io: introduce unpriv_sgio queue flag
Date: Tue, 13 Nov 2012 18:25:13 +0100
Message-ID: <1352827513-29890-3-git-send-email-pbonzini@redhat.com>
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab2KMRfO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2012 12:35:14 -0500
In-Reply-To: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>

This queue flag will let unprivileged users send any SG_IO command to the
device, without any filtering.  This makes it possible to run a program
where you want to access the full range of SCSI commands, while still
running as confined as possible.  With this patch, such a program will
not need the CAP_SYS_RAWIO capability anymore, and will also not be
able to send SCSI commands to a partition (which would affect the full
disk).

Cc: linux-scsi@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ric Wheeler <rwheeler@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v2->v3: change bitmap filter to boolean

 block/blk-sysfs.c      |   32 ++++++++++++++++++++++++++++++++
 block/scsi_ioctl.c     |    2 +-
 include/linux/blkdev.h |    3 +++
 3 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index ce62046..935d10a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -215,6 +215,31 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
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
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
 queue_show_##name(struct request_queue *q, char *page)			\
@@ -403,6 +428,12 @@ static struct queue_sysfs_entry queue_nonrot_entry = {
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
@@ -445,6 +476,7 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
 	&queue_write_same_max_entry.attr,
+	&queue_unpriv_sgio_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a737562..1a999d6 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -202,7 +202,7 @@ int blk_verify_command(struct request_queue *q,
 	struct blk_cmd_filter *filter = &blk_default_cmd_filter;
 
 	/* root can do any command. */
-	if (capable(CAP_SYS_RAWIO))
+	if (capable(CAP_SYS_RAWIO) || blk_queue_unpriv_sgio(q))
 		return 0;
 
 	/* if there's no filter set, assume we're filtering everything out */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 69a5e55..169a883 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -452,6 +452,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_UNPRIV_SGIO 19	/* SG_IO free for unprivileged users */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -526,6 +527,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
+#define blk_queue_unpriv_sgio(q) \
+	test_bit(QUEUE_FLAG_UNPRIV_SGIO, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
-- 
1.7.4.1

