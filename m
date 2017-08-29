From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v4 1/3] rcu: Introduce rcu_swap_protected()
Date: Tue, 29 Aug 2017 08:50:11 -0700
Message-ID: <20170829155013.11124-2-bart.vanassche@wdc.com>
References: <20170829155013.11124-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9012 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751867AbdH2Pva (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 11:51:30 -0400
In-Reply-To: <20170829155013.11124-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane M Seymour <shane.seymour@hpe.com>

A common pattern in RCU code is to assign a new value to an RCU
pointer after having read and stored the old value. Introduce a
macro for this pattern.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Shane M Seymour <shane.seymour@hpe.com>
---
 include/linux/rcupdate.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f816fc72b51e..8e920f0ecb07 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -407,6 +407,22 @@ static inline void rcu_preempt_sleep_check(void) { }
 	_r_a_p__v;							      \
 })
 
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
+	typeof(ptr) __tmp = rcu_dereference_protected((rcu_ptr), (c));	\
+	rcu_assign_pointer((rcu_ptr), (ptr));				\
+	(ptr) = __tmp;							\
+} while (0)
+
 /**
  * rcu_access_pointer() - fetch RCU pointer with no dereferencing
  * @p: The pointer to read
-- 
2.14.1
