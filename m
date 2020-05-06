Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2B2C28CBC
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 21:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AED4207DD
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 21:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgEFVsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 17:48:07 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40905 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbgEFVsF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 May 2020 17:48:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 3C60C20418E;
        Wed,  6 May 2020 23:48:01 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7Vbg+cqBqiOu; Wed,  6 May 2020 23:47:57 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 23B20204165;
        Wed,  6 May 2020 23:47:56 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     willy@infradead.org
Subject: [RFC] scsi: xarray hctl
Date:   Wed,  6 May 2020 17:47:54 -0400
Message-Id: <20200506214754.12083-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace three linked lists with xarrays:
  - Scsi_Host::__devices  collection of scsi_device objects
  - Scsi_Host::__targets  collection of scsi_target objects
  - scsi_target::devices  collection of scsi_device objects that
    belong to this target

The collection of Scsi_Host objects remains unaltered. It uses the
idr/ida mechanism which already uses xarrays in its implementation.

This is a simple, proof-of-concept implementation. It takes no
advantage of xarray facilities such as "marks" which allow sub-
lists/arrays to exist within a larger list. This implementation
is also "over-locked". Each xarray instance has a spinlock that
can replace existing locks. For example the spinlock in
Scsi_Host::__devices could and probably should replace the
"host_lock". That would be a more invasive change, the upside
is that the "__xa_*" group of unlocked xarray functions could
be used.

xarray technical info: all three xarrays are initialized with
XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ flags. When XA_FLAGS_ALLOC is
used xarray allocates the index numbers and uses one of the 3
available marks to manage that allocation. So there are two
marks remaining and they are currently unused. The LOCK_IRQ
flags means it calls spin_lock_irq() internally on xarray
modifying operations. xarray non-modifying operations use the
rcu lock.

There are more "list_head" type doubly linked lists in the scsi
object tree that could be replaced by xarrays but this patch is
limited to just three. Others who are familiar with those
specialized usages may like to comment.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---

Why xarrays?
  - xarrays include locking: spinlocks for modifying operations
    rcu locks for non-modifying operations. And that spinlock can
    be used to replace existing locks in the code (e.g.
    host_lock). With list_head you are on your own.
  - the name xarray suggests O(1) indexing (but isn't) and feels
    like it should be faster than doubly linked lists
    (benchmarks tbd). [And xarrays are not true arrays, they
    just have a similar interface.]
  - struct list_head seems too clever. Looking at a group of
    related structures used to build an object tree, it is
    difficult to distinguish the collections from the elements
    of a collection. Just lots of:
        struct list_head <what_will_i_call_this_thing>;
  - struct list_head evenly distributes its overhead between
    the collection holder and the elements of a collection:
    2 pointers each, 16 bytes on 64 bit machines. xarray imposes
    an overhead on the collection holder but a smaller overhead
    on its elements, perhaps we can restrict it to 2 bytes:
    [0..USHRT_MAX]. Failing that, a 4 bytes overhead per element.
  - linked lists don't scale very well on multi-core machines
  - any decisions that can be made on the basis of xarray marks
    is a cache(line) win, as there is no need to pull in the
    corresponding element
  - xarray is well instrumented and will warn (once) at run
    time if it doesn't like the disposition of the locks.

Against:
  - if it ain't broke, don't fix it

Lightly tested with the scsi_debug driver.


 drivers/scsi/hosts.c       |  8 ++++++--
 drivers/scsi/scsi.c        | 36 +++++++++++++++++++++++++-----------
 drivers/scsi/scsi_lib.c    |  8 ++++----
 drivers/scsi/scsi_scan.c   | 37 +++++++++++++++++++++++++++----------
 drivers/scsi/scsi_sysfs.c  | 36 +++++++++++++++++++++++++++---------
 include/scsi/scsi_device.h | 12 +++++++-----
 include/scsi/scsi_host.h   | 11 +++++++++--
 7 files changed, 105 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7ec91c3a66ca..2bba293a497d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -345,6 +345,8 @@ static void scsi_host_dev_release(struct device *dev)
 
 	if (parent)
 		put_device(parent);
+	xa_destroy(&shost->__targets);
+	xa_destroy(&shost->__devices);
 	kfree(shost);
 }
 
@@ -382,8 +384,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->host_lock = &shost->default_lock;
 	spin_lock_init(shost->host_lock);
 	shost->shost_state = SHOST_CREATED;
-	INIT_LIST_HEAD(&shost->__devices);
-	INIT_LIST_HEAD(&shost->__targets);
+	xa_init_flags(&shost->__devices, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&shost->__targets, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
@@ -502,6 +504,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
  fail_index_remove:
 	ida_simple_remove(&host_index_ida, shost->host_no);
  fail_kfree:
+	xa_destroy(&shost->__targets);
+	xa_destroy(&shost->__devices);
 	kfree(shost);
 	return NULL;
 }
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 56c24a73e0c7..7093bd2eb5dc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -554,19 +554,31 @@ EXPORT_SYMBOL(scsi_device_put);
 struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 					   struct scsi_device *prev)
 {
-	struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
-	struct scsi_device *next = NULL;
-	unsigned long flags;
+	struct scsi_device *next = prev;
+	unsigned long flags, l_idx;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (list->next != &shost->__devices) {
-		next = list_entry(list->next, struct scsi_device, siblings);
-		/* skip devices that we can't get a reference to */
-		if (!scsi_device_get(next))
-			break;
+	if (xa_empty(&shost->__devices)) {
 		next = NULL;
-		list = list->next;
+		goto unlock;
 	}
+	do {
+		if (!next) {	/* get first element iff first iteration */
+			xa_for_each(&shost->__devices, l_idx, next)
+				break;
+		} else {
+			l_idx = next->sh_idx,
+			next = xa_find_after(&shost->__devices, &l_idx,
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
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (prev)
@@ -645,9 +657,10 @@ EXPORT_SYMBOL(__starget_for_each_device);
 struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
 						   u64 lun)
 {
+	unsigned long l_idx;
 	struct scsi_device *sdev;
 
-	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+	xa_for_each(&starget->devices, l_idx, sdev) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
 		if (sdev->lun ==lun)
@@ -703,9 +716,10 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 		uint channel, uint id, u64 lun)
 {
+	unsigned long l_idx;
 	struct scsi_device *sdev;
 
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
+	xa_for_each(&shost->__devices, l_idx, sdev) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
 		if (sdev->channel == channel && sdev->id == id &&
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47835c4b4ee0..68df68f54fc8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -372,9 +372,9 @@ static void scsi_kick_queue(struct request_queue *q)
 static void scsi_single_lun_run(struct scsi_device *current_sdev)
 {
 	struct Scsi_Host *shost = current_sdev->host;
-	struct scsi_device *sdev, *tmp;
+	struct scsi_device *sdev;
 	struct scsi_target *starget = scsi_target(current_sdev);
-	unsigned long flags;
+	unsigned long flags, l_idx;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->starget_sdev_user = NULL;
@@ -391,8 +391,8 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (starget->starget_sdev_user)
 		goto out;
-	list_for_each_entry_safe(sdev, tmp, &starget->devices,
-			same_target_siblings) {
+	/* XARRAY: was list_for_each_entry_safe(); is this safe ? */
+	xa_for_each(&starget->devices, l_idx, sdev) {
 		if (sdev == current_sdev)
 			continue;
 		if (scsi_device_get(sdev))
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..e39b03f35f5f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -234,8 +234,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->channel = starget->channel;
 	mutex_init(&sdev->state_mutex);
 	sdev->sdev_state = SDEV_CREATED;
-	INIT_LIST_HEAD(&sdev->siblings);
-	INIT_LIST_HEAD(&sdev->same_target_siblings);
+	/* XARRAY: INIT_LIST_HEAD()s here on list leaves, why ? */
+	sdev->sh_idx = -1;
+	sdev->starg_idx = -1;		/* for debugging */
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
@@ -306,6 +307,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 
 static void scsi_target_destroy(struct scsi_target *starget)
 {
+	struct scsi_target *e_starg;
 	struct device *dev = &starget->dev;
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
@@ -316,7 +318,10 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
 		shost->hostt->target_destroy(starget);
-	list_del_init(&starget->siblings);
+	/* XARRAY: was list_del_init(); why the _init ?  */
+	e_starg = xa_erase(&shost->__targets, starget->sh_idx);
+	if (e_starg != starget)
+		pr_err("%s: bad xa_erase()\n", __func__);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev);
 }
@@ -326,6 +331,7 @@ static void scsi_target_dev_release(struct device *dev)
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
 
+	xa_destroy(&starget->devices);
 	kfree(starget);
 	put_device(parent);
 }
@@ -344,12 +350,13 @@ EXPORT_SYMBOL(scsi_is_target_device);
 static struct scsi_target *__scsi_find_target(struct device *parent,
 					      int channel, uint id)
 {
+	unsigned long l_idx;
 	struct scsi_target *starget, *found_starget = NULL;
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	/*
-	 * Search for an existing target for this sdev.
+	 * Search for an existing target for this host.
 	 */
-	list_for_each_entry(starget, &shost->__targets, siblings) {
+	xa_for_each(&shost->__targets, l_idx, starget) {
 		if (starget->id == id &&
 		    starget->channel == channel) {
 			found_starget = starget;
@@ -412,6 +419,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct device *dev = NULL;
 	unsigned long flags;
+	unsigned int u_idx;
+	int res;
 	const int size = sizeof(struct scsi_target)
 		+ shost->transportt->target_size;
 	struct scsi_target *starget;
@@ -433,8 +442,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
-	INIT_LIST_HEAD(&starget->siblings);
-	INIT_LIST_HEAD(&starget->devices);
+	xa_init_flags(&starget->devices, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
+	starget->sh_idx = -1;		/* debugging */
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
@@ -445,7 +454,15 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	if (found_target)
 		goto found;
 
-	list_add_tail(&starget->siblings, &shost->__targets);
+	/* XARRAY: was list_add_tail(); may get hole in xarray or tail */
+	res = xa_alloc(&shost->__targets, &u_idx, starget, scsi_xa_limit_16b,
+		       GFP_ATOMIC);
+	if (res < 0) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		pr_err("%s: xa_alloc failure errno=%d\n", __func__, -res);
+		return NULL;
+	}
+	starget->sh_idx = u_idx;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
@@ -1860,11 +1877,11 @@ EXPORT_SYMBOL(scsi_scan_host);
 void scsi_forget_host(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
-	unsigned long flags;
+	unsigned long flags, l_idx;
 
  restart:
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
+	xa_for_each(&shost->__devices, l_idx, sdev) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..de505bff1e67 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -433,7 +433,7 @@ static void scsi_device_cls_release(struct device *class_dev)
 
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *e_sdev;
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
@@ -447,8 +447,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	parent = sdev->sdev_gendev.parent;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
+	e_sdev = xa_erase(&sdev->host->__devices, sdev->sh_idx);
+	if (e_sdev != sdev)
+		pr_err("%s: bad xa_erase(host:__devices)\n", __func__);
+	e_sdev = xa_erase(&sdev->sdev_target->devices, sdev->starg_idx);
+	if (e_sdev != sdev)
+		pr_err("%s: bad xa_erase(sdev_target->devices)\n", __func__);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
@@ -1472,12 +1476,12 @@ EXPORT_SYMBOL(scsi_remove_device);
 static void __scsi_remove_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	unsigned long flags;
 	struct scsi_device *sdev;
+	unsigned long flags, l_idx;
 
 	spin_lock_irqsave(shost->host_lock, flags);
  restart:
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
+	xa_for_each(&shost->__devices, l_idx, sdev) {
 		/*
 		 * We cannot call scsi_device_get() here, as
 		 * we might've been called from rmmod() causing
@@ -1495,6 +1499,7 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		scsi_remove_device(sdev);
 		put_device(&sdev->sdev_gendev);
 		spin_lock_irqsave(shost->host_lock, flags);
+		/* XARRAY: is this goto start of loop correct ? */
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1512,11 +1517,11 @@ void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	struct scsi_target *starget;
-	unsigned long flags;
+	unsigned long flags, l_idx;
 
 restart:
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry(starget, &shost->__targets, siblings) {
+	xa_for_each(&shost->__targets, l_idx, starget) {
 		if (starget->state == STARGET_DEL ||
 		    starget->state == STARGET_REMOVE ||
 		    starget->state == STARGET_CREATED_REMOVE)
@@ -1584,6 +1589,8 @@ static struct device_type scsi_dev_type = {
 
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
+	int res;
+	unsigned int u_idx;
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_target  *starget = sdev->sdev_target;
@@ -1614,8 +1621,19 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
-	list_add_tail(&sdev->siblings, &shost->__devices);
+	/* XARRAY: might add in hole */
+	res = xa_alloc(&starget->devices, &u_idx, sdev, scsi_xa_limit_16b,
+		       GFP_ATOMIC);
+	if (res < 0)
+		pr_err("%s: xa_alloc 1 failure errno=%d\n", __func__, -res);
+	else
+		sdev->starg_idx = u_idx;
+	res = xa_alloc(&shost->__devices, &u_idx, sdev, scsi_xa_limit_16b,
+		       GFP_ATOMIC);
+	if (res < 0)
+		pr_err("%s: xa_alloc 2 failure errno=%d\n", __func__, -res);
+	else
+		sdev->sh_idx = u_idx;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/*
 	 * device can now only be removed via __scsi_remove_device() so hold
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c3cba2aaf934..3483ca1ac89b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
+#include <linux/xarray.h>
 
 struct device;
 struct request_queue;
@@ -103,8 +104,8 @@ struct scsi_device {
 	struct request_queue *request_queue;
 
 	/* the next two are protected by the host->host_lock */
-	struct list_head    siblings;   /* list of all devices on this host */
-	struct list_head    same_target_siblings; /* just the devices sharing same target id */
+	int sh_idx;		/* index within host->__devices array */
+	int starg_idx;		/* index within sdev_target->devices array */
 
 	atomic_t device_busy;		/* commands actually active on LLDD */
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
@@ -281,16 +282,17 @@ enum scsi_target_state {
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
  * starget_sdev_user is NULL, else it points to the active sdev.
+ * Parent (a scsi_host object) is dev_to_shost(this->dev->parent).
  */
 struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
-	struct list_head	siblings;
-	struct list_head	devices;
+	int			sh_idx;	/* index within scsi_host::__targets */
 	struct device		dev;
 	struct kref		reap_ref; /* last put renders target invisible */
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
+	struct xarray devices;	/* scsi_device objects owned by this target */
 	unsigned int		create:1; /* signal that it needs to be added */
 	unsigned int		single_lun:1;	/* Indicates we should only
 						 * allow I/O to one of the luns
@@ -390,7 +392,7 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
  * shost_for_each_device instead.
  */
 #define __shost_for_each_device(sdev, shost) \
-	list_for_each_entry((sdev), &((shost)->__devices), siblings)
+	xa_for_each(&((shost)->__devices), ((shost)->__sh_fe_dev), (sdev))
 
 extern int scsi_change_queue_depth(struct scsi_device *, int);
 extern int scsi_track_queue_full(struct scsi_device *, int);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 822e8cda8d9b..c43d3d7d16ef 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -9,6 +9,7 @@
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
 #include <linux/blk-mq.h>
+#include <linux/xarray.h>
 #include <scsi/scsi.h>
 
 struct block_device;
@@ -29,6 +30,9 @@ struct scsi_transport_template;
 #define MODE_INITIATOR 0x01
 #define MODE_TARGET 0x02
 
+/* XARRAY: this limits number of devices (LUs) in host to 64K */
+#define scsi_xa_limit_16b    XA_LIMIT(0, USHRT_MAX)
+
 struct scsi_host_template {
 	struct module *module;
 	const char *name;
@@ -520,8 +524,11 @@ struct Scsi_Host {
 	 * their __ prefixed variants with the lock held. NEVER
 	 * access this list directly from a driver.
 	 */
-	struct list_head	__devices;
-	struct list_head	__targets;
+	struct xarray		__devices;	/* array of scsi_debug objs */
+	struct xarray		__targets;	/* array of scsi_target objs */
+
+	/* __sh_fe_dev is private for __shost_for_each_device() macro */
+	unsigned long		__sh_fe_dev;
 	
 	struct list_head	starved_list;
 
-- 
2.25.1

