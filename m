Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978E0C433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A88F20776
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 15:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387716AbgEXP61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 11:58:27 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43420 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387636AbgEXP60 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 May 2020 11:58:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id ABE2E204165;
        Sun, 24 May 2020 17:58:24 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y6fYri5pUa9C; Sun, 24 May 2020 17:58:22 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 2E8DF204247;
        Sun, 24 May 2020 17:58:19 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC v2 2/6] scsi: xarray, iterations on scsi_target
Date:   Sun, 24 May 2020 11:58:10 -0400
Message-Id: <20200524155814.5895-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200524155814.5895-1-dgilbert@interlog.com>
References: <20200524155814.5895-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For reasons unknown, the supplied functions for iterating through all
scsi_device objects that belonged to a scsi_target involved going
up to the scsi_host object (i.e. the target's parent) and iterating
through all scsi_device objects belonging to that scsi_host, and only
selecting those scsi_device objects that belonged to the original
scsi_target object. While correct, that is very inefficient when it
is noted that each scsi_target object has a 'devices' xarray which
contains pointers to the scsi_device object it owns.

Modify starget_for_each_device() and __starget_for_each_device()
to take this more efficient route. Add starg_for_each_device() and
__starg_for_each_device() macros in scsi_device.h that are finer
grained versions of the existing shost_for_each_device() and
__shost_for_each_device() macros.

The new __scsi_target_iterate_devices() helper function takes
the host_lock to be consistent with the existing
__scsi_iterate_devices() function's locking. At this stage the user
is _not_ being encouraged to use per scsi_target locks.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi.c        | 68 ++++++++++++++++++++++++++---------
 drivers/scsi/scsi_scan.c   |  3 +-
 include/scsi/scsi_device.h | 73 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 125 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 61aa68083f67..aa3240f7aed9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -588,9 +588,50 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL(__scsi_iterate_devices);
 
+/* helper for starg_for_each_device, see that for documentation */
+struct scsi_device *__scsi_target_iterate_devices(struct scsi_target *starg,
+						  struct scsi_device *prev)
+{
+	struct Scsi_Host *shost = starg_to_shost(starg);
+	struct scsi_device *next = prev;
+	unsigned long flags, l_idx;
+
+	if (!shost)
+		return NULL;
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (xa_empty(&starg->devices)) {
+		next = NULL;
+		goto unlock;
+	}
+	do {
+		if (!next) {	/* get first element iff first iteration */
+			l_idx = 0;
+			next = xa_find(&starg->devices, &l_idx,
+				       scsi_xa_limit_16b.max, XA_PRESENT);
+		} else {
+			l_idx = next->sh_idx,
+			next = xa_find_after(&starg->devices, &l_idx,
+					     scsi_xa_limit_16b.max,
+					     XA_PRESENT);
+		}
+		if (next) {
+			/* skip devices that we can't get a reference to */
+			if (!scsi_device_get(next))
+				break;
+		}
+	} while (next);
+unlock:
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (prev)
+		scsi_device_put(prev);
+	return next;
+}
+EXPORT_SYMBOL(__scsi_target_iterate_devices);
+
 /**
  * starget_for_each_device  -  helper to walk all devices of a target
- * @starget:	target whose devices we want to iterate over.
+ * @starg:	target whose devices we want to iterate over.
  * @data:	Opaque passed to each function call.
  * @fn:		Function to call on each device
  *
@@ -598,23 +639,20 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
  * a reference that must be released by scsi_host_put when breaking
  * out of the loop.
  */
-void starget_for_each_device(struct scsi_target *starget, void *data,
-		     void (*fn)(struct scsi_device *, void *))
+void starget_for_each_device(struct scsi_target *starg, void *data,
+			     void (*fn)(struct scsi_device *, void *))
 {
-	struct Scsi_Host *shost = starg_to_shost(starget);
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, shost) {
-		if ((sdev->channel == starget->channel) &&
-		    (sdev->id == starget->id))
-			fn(sdev, data);
-	}
+	/* XARRAY: this looks like recursion, but isn't. Rename function? */
+	sstarg_for_each_device(sdev, starg)
+		fn(sdev, data);
 }
 EXPORT_SYMBOL(starget_for_each_device);
 
 /**
  * __starget_for_each_device - helper to walk all devices of a target (UNLOCKED)
- * @starget:	target whose devices we want to iterate over.
+ * @starg:	target whose devices we want to iterate over.
  * @data:	parameter for callback @fn()
  * @fn:		callback function that is invoked for each device
  *
@@ -626,17 +664,13 @@ EXPORT_SYMBOL(starget_for_each_device);
  * they need to access the device list in irq context.  Otherwise you
  * really want to use starget_for_each_device instead.
  **/
-void __starget_for_each_device(struct scsi_target *starget, void *data,
+void __starget_for_each_device(struct scsi_target *starg, void *data,
 			       void (*fn)(struct scsi_device *, void *))
 {
-	struct Scsi_Host *shost = starg_to_shost(starget);
 	struct scsi_device *sdev;
 
-	__shost_for_each_device(sdev, shost) {
-		if ((sdev->channel == starget->channel) &&
-		    (sdev->id == starget->id))
-			fn(sdev, data);
-	}
+	__sstarg_for_each_device(sdev, starg)
+		fn(sdev, data);
 }
 EXPORT_SYMBOL(__starget_for_each_device);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b8f5850c5a04..72a0064a879a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -403,7 +403,8 @@ static void scsi_target_reap_ref_put(struct scsi_target *starget)
 
 /**
  * scsi_alloc_target - allocate a new or find an existing target
- * @parent:	parent of the target (need not be a scsi host)
+ * @parent:	may point to the parent shost, or an intermediate object
+ *		that dev_to_shost() can resolve to the parent shost
  * @channel:	target channel number (zero if no channels)
  * @id:		target id number
  *
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index dc9de4cc0e79..4219b8d1b94c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -295,6 +295,7 @@ struct scsi_target {
 				     * scsi_device.id eventually */
 	struct xarray devices;	/* scsi_device objects owned by this target */
 	struct device		dev;
+
 	unsigned int		create:1; /* signal that it needs to be added */
 	unsigned int		single_lun:1;	/* Indicates we should only
 						 * allow I/O to one of the luns
@@ -361,6 +362,7 @@ extern struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *,
 							u64);
 extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
 							  u64);
+/* XARRAY: these visitor names too close to sstarg_for_each_device macros? */
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
 extern void __starget_for_each_device(struct scsi_target *, void *,
@@ -370,6 +372,10 @@ extern void __starget_for_each_device(struct scsi_target *, void *,
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
 						  struct scsi_device *);
+/* only exposed to implement starg_for_each_device */
+extern struct scsi_device *__scsi_target_iterate_devices
+					(struct scsi_target *starg,
+					 struct scsi_device *sdev);
 
 /**
  * shost_for_each_device - iterate over all devices of a host
@@ -423,13 +429,78 @@ static inline struct scsi_device *__scsi_h2d_next_it(struct Scsi_Host *shost,
  *
  * Note 2: The iteration won't fail but dereferencing sdev might. To access
  * the xarray features (e.g. marks) associated with sdev safely use:
- * xa_for_each(&shost->__devices, l_idx, next) directly then use l_idx.
+ * xa_for_each(&shost->__devices, l_idx, sdev) directly then use l_idx.
  */
 #define __shost_for_each_device(sdev, shost) \
 	for ((sdev) = __scsi_h2d_1st_it((shost)); \
 	     (sdev); \
 	     (sdev) = __scsi_h2d_next_it((shost), (sdev)))
 
+/**
+ * sstarg_for_each_device - iterate over all devices of a target
+ * @sdev: the &struct scsi_device to use as a cursor
+ * @starg: the &struct scsi_target to iterate over
+ *
+ * Iterator that returns each device attached to @starg.  This loop
+ * takes a reference on each device and releases it at the end.  If
+ * you break out of the loop, you must call scsi_device_put(sdev).
+ *
+ * Note: the leading double "ss" is to lessen the similarity between this
+ * macro and the starget_for_each_device() function declared above.
+ */
+#define sstarg_for_each_device(sdev, starg) \
+	for ((sdev) = __scsi_target_iterate_devices((starg), NULL); \
+	     (sdev); \
+	     (sdev) = __scsi_target_iterate_devices((starg), (sdev)))
+
+/* helper for __sstarg_for_each_device */
+static inline struct scsi_device *__scsi_t2d_1st_it(struct scsi_target *starg)
+{
+	unsigned long l_idx = 0;
+
+	return xa_find(&starg->devices, &l_idx, scsi_xa_limit_16b.max,
+		       XA_PRESENT);
+}
+
+/* helper for __sstarg_for_each_device */
+static inline struct scsi_device *__scsi_t2d_next_it(struct scsi_target *starg,
+						     struct scsi_device *prev)
+{
+	unsigned long l_idx;
+
+	if (prev) {
+		l_idx = prev->starg_idx,
+		prev = xa_find_after(&starg->devices, &l_idx,
+				     scsi_xa_limit_16b.max, XA_PRESENT);
+	}
+	return prev;	/* now either _next_ or NULL */
+}
+
+/**
+ * __sstarg_for_each_device - iterate over all devices of a target (UNLOCKED)
+ * @sdev: the &struct scsi_device to use as a cursor
+ * @starg: the &struct scsi_target to iterate over
+ *
+ * Iterator that returns each device attached to @starg.  It does _not_
+ * take a reference on the scsi_device, so the whole loop must be
+ * protected by shost->host_lock.
+ *
+ * Note: The only reason to use this is because you need to access the
+ * device list in interrupt context.  Otherwise you really want to use
+ * starg_for_each_device instead.
+ *
+ * Note 2: The iteration won't fail but dereferencing sdev might. To access
+ * the xarray features (e.g. marks) associated with sdev safely use:
+ * xa_for_each(&starg->devices, l_idx, sdev) directly then use l_idx.
+ *
+ * Note 3: the leading double "ss" is to lessen the similarity between this
+ * macro and the __starget_for_each_device() function declared above.
+ */
+#define __sstarg_for_each_device(sdev, starg) \
+	for ((sdev) = __scsi_t2d_1st_it((starg)); \
+	     (sdev); \
+	     (sdev) = __scsi_t2d_next_it((starg), (sdev)))
+
 extern int scsi_change_queue_depth(struct scsi_device *, int);
 extern int scsi_track_queue_full(struct scsi_device *, int);
 
-- 
2.25.1

