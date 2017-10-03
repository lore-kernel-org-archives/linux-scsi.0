From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 5/8] percpu-refcount: introduce __percpu_ref_tryget_live
Date: Tue,  3 Oct 2017 22:04:03 +0800
Message-ID: <20171003140406.26060-6-ming.lei@redhat.com>
References: <20171003140406.26060-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171003140406.26060-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Block layer need to call this function after holding
rcu lock in a real hot path, so introduce this helper.

Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/percpu-refcount.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index c13dceb87b60..a0f22586a28d 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -221,6 +221,21 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 	return ret;
 }
 
+static inline bool __percpu_ref_tryget_live(struct percpu_ref *ref)
+{
+	unsigned long __percpu *percpu_count;
+	bool ret = false;
+
+	if (__ref_is_percpu(ref, &percpu_count)) {
+		this_cpu_inc(*percpu_count);
+		ret = true;
+	} else if (!(ref->percpu_count_ptr & __PERCPU_REF_DEAD)) {
+		ret = atomic_long_inc_not_zero(&ref->count);
+	}
+
+	return ret;
+}
+
 /**
  * percpu_ref_tryget_live - try to increment a live percpu refcount
  * @ref: percpu_ref to try-get
@@ -238,18 +253,10 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
  */
 static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
 {
-	unsigned long __percpu *percpu_count;
-	bool ret = false;
+	bool ret;
 
 	rcu_read_lock_sched();
-
-	if (__ref_is_percpu(ref, &percpu_count)) {
-		this_cpu_inc(*percpu_count);
-		ret = true;
-	} else if (!(ref->percpu_count_ptr & __PERCPU_REF_DEAD)) {
-		ret = atomic_long_inc_not_zero(&ref->count);
-	}
-
+	ret = __percpu_ref_tryget_live(ref);
 	rcu_read_unlock_sched();
 
 	return ret;
-- 
2.9.5
