From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 1/3] rcu: Introduce rcu_swap_protected()
Date: Mon, 28 Aug 2017 13:45:33 -0700
Message-ID: <20170828204539.29289-2-bart.vanassche@wdc.com>
References: <20170828204539.29289-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12667 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdH1Uqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Aug 2017 16:46:52 -0400
In-Reply-To: <20170828204539.29289-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane M Seymour <shane.seymour@hpe.com>

A common pattern in RCU code is to assign a new value to an RCU
pointer after having read and stored the old value. Introduce a
macro for this pattern.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Shane M Seymour <shane.seymour@hpe.com>
---
 include/linux/rcupdate.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f816fc72b51e..555815ce2e57 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -561,6 +561,26 @@ static inline void rcu_preempt_sleep_check(void) { }
  */
 #define rcu_pointer_handoff(p) (p)
 
+/**
+ * rcu_swap_protected() - swap an RCU and a regular pointer
+ * @rcu_ptr: RCU pointer
+ * @ptr: regular pointer
+ * @c: the conditions under which the dereference will take place
+ *
+ * Perform swap(@rcu_ptr, @ptr) where @rcu_ptr is an RCU-annotated pointer and
+ * @c is the argument that is passed to the rcu_dereference_protected() call
+ * used to read that pointer.
+ */
+#define rcu_swap_protected(rcu_ptr, ptr, c) do {			\
+	typeof(ptr) __tmp;						\
+									\
+	BUILD_BUG_ON(!__same_type(typeof(rcu_ptr), typeof(*(ptr)) __rcu *)); \
+	BUILD_BUG_ON(!__same_type(typeof(ptr), typeof(*(rcu_ptr)) *));	\
+	__tmp = rcu_dereference_protected((rcu_ptr), (c));		\
+	rcu_assign_pointer((rcu_ptr), (ptr));				\
+	(ptr) = __tmp;							\
+} while (0)
+
 /**
  * rcu_read_lock() - mark the beginning of an RCU read-side critical section
  *
-- 
2.14.1
