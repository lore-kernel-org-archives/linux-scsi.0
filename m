From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 5/6] block: convert bsg_device.ref_count from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 11:16:01 +0300
Message-ID: <1508487362-26663-6-git-send-email-elena.reshetova@intel.com>
References: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
List-Id: linux-scsi@vger.kernel.org

atomic_t variables are currently used to implement reference
counters with the following properties:
 - counter is initialized to 1 using atomic_set()
 - a resource is freed upon counter reaching zero
 - once counter reaches zero, its further
   increments aren't allowed
 - counter schema uses basic atomic operations
   (set, inc, inc_not_zero, dec_and_test, etc.)

Such atomic variables should be converted to a newly provided
refcount_t type and API that prevents accidental counter overflows
and underflows. This is important since overflows and underflows
can lead to use-after-free situation and be exploitable.

The variable bsg_device.ref_count is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 block/bsg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index ee1335c..6c98422 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -21,6 +21,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -38,7 +39,7 @@ struct bsg_device {
 	struct list_head busy_list;
 	struct list_head done_list;
 	struct hlist_node dev_list;
-	atomic_t ref_count;
+	refcount_t ref_count;
 	int queued_cmds;
 	int done_cmds;
 	wait_queue_head_t wq_done;
@@ -710,7 +711,7 @@ static int bsg_put_device(struct bsg_device *bd)
 
 	mutex_lock(&bsg_mutex);
 
-	do_free = atomic_dec_and_test(&bd->ref_count);
+	do_free = refcount_dec_and_test(&bd->ref_count);
 	if (!do_free) {
 		mutex_unlock(&bsg_mutex);
 		goto out;
@@ -768,7 +769,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 
 	bsg_set_block(bd, file);
 
-	atomic_set(&bd->ref_count, 1);
+	refcount_set(&bd->ref_count, 1);
 	mutex_lock(&bsg_mutex);
 	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
 
@@ -788,7 +789,7 @@ static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 
 	hlist_for_each_entry(bd, bsg_dev_idx_hash(minor), dev_list) {
 		if (bd->queue == q) {
-			atomic_inc(&bd->ref_count);
+			refcount_inc(&bd->ref_count);
 			goto found;
 		}
 	}
-- 
2.7.4
