From: Arjan van de Ven <arjan@infradead.org>
Subject: driver synchronization: make scsi_wait_scan more advanced
Date: Tue, 21 Apr 2009 13:42:06 -0700
Message-ID: <20090421134206.07b8ee7e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56170 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZDUUkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 16:40:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, torvalds@linux-foundation.org, greg@kroah.com

(CC'ing linux-scsi as well since this touches a file in drivers/scsi)


>From 546fdda8b4124a7473f32decf4a2981984f287db Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 21 Apr 2009 13:32:54 -0700
Subject: [PATCH] driver synchronization: make scsi_wait_scan more advanced


There is currently only one way for userspace to say "wait for my storage
device to get ready for the modules I just loaded": to load the
scsi_wait_scan module. Expectations of userspace are that once this
module is loaded, all the (storage) devices for which the drivers
were loaded before the module load are present.

Now, there are some issues with the implementation, and the async
stuff got caught in the middle of this: The existing code only
waits for the scsy async probing to finish, but it did not take
into account at all that probing might not have begun yet.
(Russell ran into this problem on his computer and the fix works for him)

This patch fixes this more thoroughly than the previous "fix", which
had some bad side effects (namely, for kernel code that wanted to wait for
the scsi scan it would also do an async sync, which would deadlock if you did
it from async context already.. there's a report about that on lkml):
The patch makes the module first wait for all device driver probes, and then it
will wait for the scsi parallel scan to finish.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/base/dd.c             |    1 +
 drivers/scsi/scsi_scan.c      |    2 --
 drivers/scsi/scsi_wait_scan.c |   11 +++++++++++
 include/linux/device.h        |    1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index f17c326..742cbe6 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -179,6 +179,7 @@ void wait_for_device_probe(void)
 	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
 	async_synchronize_full();
 }
+EXPORT_SYMBOL_GPL(wait_for_device_probe);
 
 /**
  * driver_probe_device - attempt to bind device & driver together
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a14d245..6f51ca4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -180,8 +180,6 @@ int scsi_complete_async_scans(void)
 	spin_unlock(&async_scan_lock);
 
 	kfree(data);
-	/* Synchronize async operations globally */
-	async_synchronize_full();
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_wait_scan.c b/drivers/scsi/scsi_wait_scan.c
index 2f21af2..74708fc 100644
--- a/drivers/scsi/scsi_wait_scan.c
+++ b/drivers/scsi/scsi_wait_scan.c
@@ -11,10 +11,21 @@
  */
 
 #include <linux/module.h>
+#include <linux/device.h>
 #include <scsi/scsi_scan.h>
 
 static int __init wait_scan_init(void)
 {
+	/*
+	 * First we need to wait for device probing to finish;
+	 * the drivers we just loaded might just still be probing
+	 * and might not yet have reached the scsi async scanning
+	 */
+	wait_for_device_probe();
+	/*
+	 * and then we wait for the actual asynchronous scsi scan
+	 * to finish.
+	 */
 	scsi_complete_async_scans();
 	return 0;
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 2918c0e..6a69caa 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -551,6 +551,7 @@ extern int (*platform_notify_remove)(struct device *dev);
 extern struct device *get_device(struct device *dev);
 extern void put_device(struct device *dev);
 
+extern void wait_for_device_probe(void);
 
 /* drivers/base/power/shutdown.c */
 extern void device_shutdown(void);
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
