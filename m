From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 6/6] drivers, block: convert xen_blkif.refcnt from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 11:16:02 +0300
Message-ID: <1508487362-26663-7-git-send-email-elena.reshetova@intel.com>
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

The variable xen_blkif.refcnt is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 drivers/block/xen-blkback/common.h | 7 ++++---
 drivers/block/xen-blkback/xenbus.c | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index ecb35fe..0c3320d 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -35,6 +35,7 @@
 #include <linux/wait.h>
 #include <linux/io.h>
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 #include <asm/setup.h>
 #include <asm/pgalloc.h>
 #include <asm/hypervisor.h>
@@ -319,7 +320,7 @@ struct xen_blkif {
 	struct xen_vbd		vbd;
 	/* Back pointer to the backend_info. */
 	struct backend_info	*be;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	/* for barrier (drain) requests */
 	struct completion	drain_complete;
 	atomic_t		drain;
@@ -372,10 +373,10 @@ struct pending_req {
 			 (_v)->bdev->bd_part->nr_sects : \
 			  get_capacity((_v)->bdev->bd_disk))
 
-#define xen_blkif_get(_b) (atomic_inc(&(_b)->refcnt))
+#define xen_blkif_get(_b) (refcount_inc(&(_b)->refcnt))
 #define xen_blkif_put(_b)				\
 	do {						\
-		if (atomic_dec_and_test(&(_b)->refcnt))	\
+		if (refcount_dec_and_test(&(_b)->refcnt))	\
 			schedule_work(&(_b)->free_work);\
 	} while (0)
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 21c1be1..5955b61 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -176,7 +176,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 		return ERR_PTR(-ENOMEM);
 
 	blkif->domid = domid;
-	atomic_set(&blkif->refcnt, 1);
+	refcount_set(&blkif->refcnt, 1);
 	init_completion(&blkif->drain_complete);
 	INIT_WORK(&blkif->free_work, xen_blkif_deferred_free);
 
-- 
2.7.4
