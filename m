From: akpm@linux-foundation.org
Subject: [patch 17/17] use mutex instead of semaphore in Megaraid Mailbox driver
Date: Mon, 09 Jul 2007 12:00:11 -0700
Message-ID: <200707091900.l69J0CLM002562@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbXGITKn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:10:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, matthias.kaehlcke@gmail.com, Sumant.Patro@lsi.com

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The Megaraid Mailbox driver uses a semaphore as mutex.  Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: "Patro, Sumant" <Sumant.Patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/mega_common.h   |    1 +
 drivers/scsi/megaraid/megaraid_mbox.c |    6 +++---
 drivers/scsi/megaraid/megaraid_mbox.h |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/megaraid/mega_common.h~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver drivers/scsi/megaraid/mega_common.h
--- a/drivers/scsi/megaraid/mega_common.h~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver
+++ a/drivers/scsi/megaraid/mega_common.h
@@ -21,6 +21,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3880,7 +3880,7 @@ megaraid_sysfs_alloc_resources(adapter_t
 		megaraid_sysfs_free_resources(adapter);
 	}
 
-	sema_init(&raid_dev->sysfs_sem, 1);
+	mutex_init(&raid_dev->sysfs_mtx);
 
 	init_waitqueue_head(&raid_dev->sysfs_wait_q);
 
@@ -3981,7 +3981,7 @@ megaraid_sysfs_get_ldmap(adapter_t *adap
 	/*
 	 * Allow only one read at a time to go through the sysfs attributes
 	 */
-	down(&raid_dev->sysfs_sem);
+	mutex_lock(&raid_dev->sysfs_mtx);
 
 	uioc	= raid_dev->sysfs_uioc;
 	mbox64	= raid_dev->sysfs_mbox64;
@@ -4057,7 +4057,7 @@ megaraid_sysfs_get_ldmap(adapter_t *adap
 
 	del_timer_sync(timerp);
 
-	up(&raid_dev->sysfs_sem);
+	mutex_unlock(&raid_dev->sysfs_mtx);
 
 	return rval;
 }
diff -puN drivers/scsi/megaraid/megaraid_mbox.h~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver drivers/scsi/megaraid/megaraid_mbox.h
--- a/drivers/scsi/megaraid/megaraid_mbox.h~use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver
+++ a/drivers/scsi/megaraid/megaraid_mbox.h
@@ -168,7 +168,7 @@ typedef struct {
  * @hw_error			: set if FW not responding
  * @fast_load			: If set, skip physical device scanning
  * @channel_class		: channel class, RAID or SCSI
- * @sysfs_sem			: semaphore to serialize access to sysfs res.
+ * @sysfs_mtx			: mutex to serialize access to sysfs res.
  * @sysfs_uioc			: management packet to issue FW calls from sysfs
  * @sysfs_mbox64		: mailbox packet to issue FW calls from sysfs
  * @sysfs_buffer		: data buffer for FW commands issued from sysfs
@@ -208,7 +208,7 @@ typedef struct {
 	int				hw_error;
 	int				fast_load;
 	uint8_t				channel_class;
-	struct semaphore		sysfs_sem;
+	struct mutex			sysfs_mtx;
 	uioc_t				*sysfs_uioc;
 	mbox64_t			*sysfs_mbox64;
 	caddr_t				sysfs_buffer;
_
