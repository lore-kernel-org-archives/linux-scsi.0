From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/9] percpu-refcount: introduce percpu_ref_is_dead()
Date: Fri,  1 Sep 2017 01:27:20 +0800
Message-ID: <20170831172728.15817-2-ming.lei@redhat.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170831172728.15817-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Inside block layer, we need to support to allocate request with
RQF_PREEMPT even though queue is frozen.

So introduce this helper for checking if queue is frozen.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/percpu-refcount.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index c13dceb87b60..08549bbf4080 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -324,4 +324,21 @@ static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
 	return !atomic_long_read(&ref->count);
 }
 
+/**
+ * percpu_ref_is_dead - test whether a percpu refcount is killed
+ * @ref: percpu_ref to test
+ *
+ * Returns %true if @ref is dead
+ *
+ * This function is safe to call as long as @ref is between init and exit.
+ */
+static inline bool percpu_ref_is_dead(struct percpu_ref *ref)
+{
+	unsigned long __percpu *percpu_count;
+
+	if (__ref_is_percpu(ref, &percpu_count))
+		return false;
+	return ref->percpu_count_ptr & __PERCPU_REF_DEAD;
+}
+
 #endif
-- 
2.9.5
