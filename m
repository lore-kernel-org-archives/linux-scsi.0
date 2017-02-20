From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 5/5] block: convert bsg_device.ref_count from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 13:16:08 +0200
Message-ID: <1487589368-17666-6-git-send-email-elena.reshetova@intel.com>
References: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487589368-17666-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 block/bsg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 74835db..6d0ceb9 100644
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
@@ -711,7 +712,7 @@ static int bsg_put_device(struct bsg_device *bd)
 
 	mutex_lock(&bsg_mutex);
 
-	do_free = atomic_dec_and_test(&bd->ref_count);
+	do_free = refcount_dec_and_test(&bd->ref_count);
 	if (!do_free) {
 		mutex_unlock(&bsg_mutex);
 		goto out;
@@ -763,7 +764,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 
 	bsg_set_block(bd, file);
 
-	atomic_set(&bd->ref_count, 1);
+	refcount_set(&bd->ref_count, 1);
 	mutex_lock(&bsg_mutex);
 	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
 
@@ -783,7 +784,7 @@ static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 
 	hlist_for_each_entry(bd, bsg_dev_idx_hash(minor), dev_list) {
 		if (bd->queue == q) {
-			atomic_inc(&bd->ref_count);
+			refcount_inc(&bd->ref_count);
 			goto found;
 		}
 	}
-- 
2.7.4
