From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.11-rc6
Date: Sat, 24 Aug 2013 14:10:51 +0400
Message-ID: <1377339051.8757.18.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of small bug fixes for lpfc and zfcp and a fix for a
fairly nasty bug in sg where a process which cancels I/O completes in a
kernel thread which would then try to write back to the now gone
userspace and end up writing to a random kernel address instead.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Anton Blanchard (1):
      lpfc: Don't force CONFIG_GENERIC_CSUM on

Martin Peschke (3):
      zfcp: remove access control tables interface (keep sysfs files)
      zfcp: fix schedule-inside-lock in scsi_device list loops
      zfcp: fix lock imbalance by reworking request queue locking

Roland Dreier (1):
      sg: Fix user memory corruption when SG_IO is interrupted by a signal

And the diffstat:

 drivers/s390/scsi/zfcp_erp.c   | 29 +++++++++++++++------
 drivers/s390/scsi/zfcp_qdio.c  |  8 ++----
 drivers/s390/scsi/zfcp_sysfs.c | 14 +++++++++++
 drivers/scsi/Kconfig           |  1 -
 fs/bio.c                       | 20 +++++++++++----
 include/linux/wait.h           | 57 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 110 insertions(+), 19 deletions(-)

With full diff below.

James

---

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 1d4c8fe..c82fe65 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -102,10 +102,13 @@ static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
 		zfcp_erp_action_dismiss(&port->erp_action);
-	else
-		shost_for_each_device(sdev, port->adapter->scsi_host)
+	else {
+		spin_lock(port->adapter->scsi_host->host_lock);
+		__shost_for_each_device(sdev, port->adapter->scsi_host)
 			if (sdev_to_zfcp(sdev)->port == port)
 				zfcp_erp_action_dismiss_lun(sdev);
+		spin_unlock(port->adapter->scsi_host->host_lock);
+	}
 }
 
 static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
@@ -592,9 +595,11 @@ static void _zfcp_erp_lun_reopen_all(struct zfcp_port *port, int clear,
 {
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock(port->adapter->scsi_host->host_lock);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			_zfcp_erp_lun_reopen(sdev, clear, id, 0);
+	spin_unlock(port->adapter->scsi_host->host_lock);
 }
 
 static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
@@ -1434,8 +1439,10 @@ void zfcp_erp_set_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 		atomic_set_mask(common_mask, &port->status);
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, adapter->scsi_host)
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host)
 		atomic_set_mask(common_mask, &sdev_to_zfcp(sdev)->status);
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1469,11 +1476,13 @@ void zfcp_erp_clear_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, adapter->scsi_host) {
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host) {
 		atomic_clear_mask(common_mask, &sdev_to_zfcp(sdev)->status);
 		if (clear_counter)
 			atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 	}
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1487,16 +1496,19 @@ void zfcp_erp_set_port_status(struct zfcp_port *port, u32 mask)
 {
 	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+	unsigned long flags;
 
 	atomic_set_mask(mask, &port->status);
 
 	if (!common_mask)
 		return;
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			atomic_set_mask(common_mask,
 					&sdev_to_zfcp(sdev)->status);
+	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1511,6 +1523,7 @@ void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 	u32 clear_counter = mask & ZFCP_STATUS_COMMON_ERP_FAILED;
+	unsigned long flags;
 
 	atomic_clear_mask(mask, &port->status);
 
@@ -1520,13 +1533,15 @@ void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 	if (clear_counter)
 		atomic_set(&port->erp_counter, 0);
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port) {
 			atomic_clear_mask(common_mask,
 					  &sdev_to_zfcp(sdev)->status);
 			if (clear_counter)
 				atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 		}
+	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 665e3cf..de0598e 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -224,11 +224,9 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 
 static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
 {
-	spin_lock_irq(&qdio->req_q_lock);
 	if (atomic_read(&qdio->req_q_free) ||
 	    !(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return 1;
-	spin_unlock_irq(&qdio->req_q_lock);
 	return 0;
 }
 
@@ -246,9 +244,8 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 {
 	long ret;
 
-	spin_unlock_irq(&qdio->req_q_lock);
-	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
-			       zfcp_qdio_sbal_check(qdio), 5 * HZ);
+	ret = wait_event_interruptible_lock_irq_timeout(qdio->req_q_wq,
+		       zfcp_qdio_sbal_check(qdio), qdio->req_q_lock, 5 * HZ);
 
 	if (!(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return -EIO;
@@ -262,7 +259,6 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdsbg_1");
 	}
 
-	spin_lock_irq(&qdio->req_q_lock);
 	return -EIO;
 }
 
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 3f01bbf..8906392 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -27,6 +27,16 @@ static ssize_t zfcp_sysfs_##_feat##_##_name##_show(struct device *dev,	       \
 static ZFCP_DEV_ATTR(_feat, _name, S_IRUGO,				       \
 		     zfcp_sysfs_##_feat##_##_name##_show, NULL);
 
+#define ZFCP_DEFINE_ATTR_CONST(_feat, _name, _format, _value)		       \
+static ssize_t zfcp_sysfs_##_feat##_##_name##_show(struct device *dev,	       \
+						   struct device_attribute *at,\
+						   char *buf)		       \
+{									       \
+	return sprintf(buf, _format, _value);				       \
+}									       \
+static ZFCP_DEV_ATTR(_feat, _name, S_IRUGO,				       \
+		     zfcp_sysfs_##_feat##_##_name##_show, NULL);
+
 #define ZFCP_DEFINE_A_ATTR(_name, _format, _value)			     \
 static ssize_t zfcp_sysfs_adapter_##_name##_show(struct device *dev,	     \
 						 struct device_attribute *at,\
@@ -75,6 +85,8 @@ ZFCP_DEFINE_ATTR(zfcp_unit, unit, in_recovery, "%d\n",
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_denied, "%d\n",
 		 (zfcp_unit_sdev_status(unit) &
 		  ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
+ZFCP_DEFINE_ATTR_CONST(unit, access_shared, "%d\n", 0);
+ZFCP_DEFINE_ATTR_CONST(unit, access_readonly, "%d\n", 0);
 
 static ssize_t zfcp_sysfs_port_failed_show(struct device *dev,
 					   struct device_attribute *attr,
@@ -347,6 +359,8 @@ static struct attribute *zfcp_unit_attrs[] = {
 	&dev_attr_unit_in_recovery.attr,
 	&dev_attr_unit_status.attr,
 	&dev_attr_unit_access_denied.attr,
+	&dev_attr_unit_access_shared.attr,
+	&dev_attr_unit_access_readonly.attr,
 	NULL
 };
 static struct attribute_group zfcp_unit_attr_group = {
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 48b2918..92ff027 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1353,7 +1353,6 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	select SCSI_FC_ATTRS
-	select GENERIC_CSUM
 	select CRC_T10DIF
 	help
           This lpfc driver supports the Emulex LightPulse
diff --git a/fs/bio.c b/fs/bio.c
index 94bbc04..c5eae72 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1045,12 +1045,22 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
-	int ret = 0;
+	struct bio_vec *bvec;
+	int ret = 0, i;
 
-	if (!bio_flagged(bio, BIO_NULL_MAPPED))
-		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-				     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
-				     0, bmd->is_our_pages);
+	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
+		/*
+		 * if we're in a workqueue, the request is orphaned, so
+		 * don't copy into a random user address space, just free.
+		 */
+		if (current->mm)
+			ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
+					     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
+					     0, bmd->is_our_pages);
+		else if (bmd->is_our_pages)
+			bio_for_each_segment_all(bvec, bio, i)
+				__free_page(bvec->bv_page);
+	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
diff --git a/include/linux/wait.h b/include/linux/wait.h
index f487a47..a67fc16 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -811,6 +811,63 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
+						    lock, ret)		\
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		spin_unlock_irq(&lock);					\
+		ret = schedule_timeout(ret);				\
+		spin_lock_irq(&lock);					\
+		if (!ret)						\
+			break;						\
+	}								\
+	finish_wait(&wq, &__wait);					\
+} while (0)
+
+/**
+ * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets true or a timeout elapses.
+ *		The condition is checked under the lock. This is expected
+ *		to be called with the lock taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked spinlock_t, which will be released before schedule()
+ *	  and reacquired afterwards.
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or signal is received. The @condition is
+ * checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called while holding the lock. The lock is
+ * dropped before going to sleep and is reacquired afterwards.
+ *
+ * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
+ * was interrupted by a signal, and the remaining jiffies otherwise
+ * if the condition evaluated to true before the timeout elapsed.
+ */
+#define wait_event_interruptible_lock_irq_timeout(wq, condition, lock,	\
+						  timeout)		\
+({									\
+	int __ret = timeout;						\
+									\
+	if (!(condition))						\
+		__wait_event_interruptible_lock_irq_timeout(		\
+					wq, condition, lock, __ret);	\
+	__ret;								\
+})
+
 
 /*
  * These are the old interfaces to sleep waiting for an event.
