From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Fri, 29 May 2009 14:32:48 +0200
Message-ID: <4A1FD5F0.4040003@suse.de>
References: <Pine.LNX.4.44L0.0905281656590.4059-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050407030103030004010009"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905281656590.4059-100000@iolanthe.rowland.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050407030103030004010009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi Alan,

> And besides, in the patch I'm working on it isn't called from either of 
> those places -- it's called from __scsi_remove_device().  So I'll go 
> ahead and get rid of scsi_target_reap_usercontext().
> 
And just for reference, here is my patchset I've created sometime ago
which streamlines the sdev and starget lifetime. I think I've tried
to send it upstream at one point but never got far with it.
Be aware that it's relative to a rather git tree (2.6.22?) so
it might not apply properly. But it's mainly to get you an idea
of what I've done so far.

And would have continued pushing it if real life hadn't interfered ...

HTH.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------050407030103030004010009
Content-Type: text/x-patch;
 name="0001-Fix-refcounting-for-attribute_container.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Fix-refcounting-for-attribute_container.patch"

>From 404fc549f858cd0cf3a84865442fe85fedb920de Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@acerbis.suse.de>
Date: Sat, 8 Mar 2008 10:30:58 +0100
Subject: [PATCH] Fix refcounting for attribute_container

attribute_container_add_device() took an explicit reference on the
parent device, making it impossible to remove the parent by doing
a simple put. So we'd rather _not_ take a reference here as
attribute_container will be handled explicitly by calls to
attribute_container_remove_device()/_destroy_device() anyway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/base/attribute_container.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index f57652d..6c7e633 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -114,10 +114,8 @@ static void attribute_container_release(struct device *classdev)
 {
 	struct internal_container *ic 
 		= container_of(classdev, struct internal_container, classdev);
-	struct device *dev = classdev->parent;
 
 	kfree(ic);
-	put_device(dev);
 }
 
 /**
@@ -164,7 +162,11 @@ attribute_container_add_device(struct device *dev,
 
 		ic->cont = cont;
 		device_initialize(&ic->classdev);
-		ic->classdev.parent = get_device(dev);
+		/*
+		 * Don't increase refcount here, device will be
+		 * removed explicitly by a call to _destroy().
+		 */
+		ic->classdev.parent = dev;
 		ic->classdev.class = cont->class;
 		cont->class->dev_release = attribute_container_release;
 		strcpy(ic->classdev.bus_id, dev->bus_id);
-- 
1.5.3.2


--------------050407030103030004010009
Content-Type: text/x-patch;
 name="0002-Remove-reap_ref.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-Remove-reap_ref.patch"

>From 9e96c5dd094d3822093656e87b71cd433e818cd2 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@acerbis.suse.de>
Date: Sat, 8 Mar 2008 12:28:17 +0100
Subject: [PATCH] Remove reap_ref

struct scsi_target contains a 'reap_ref' counter, which is
basically a reference counter for the target.
As we now have proper reference counting we can remove this
and clear out the calling sequence for scsi_target_reap().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c   |   22 ++++++++++++++--------
 drivers/scsi/scsi_sysfs.c  |    3 ---
 include/scsi/scsi_device.h |    1 -
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d61a8e8..2feab2a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -448,7 +448,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	return starget;
 
  found:
-	found_target->reap_ref++;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
 		put_device(parent);
@@ -505,7 +504,7 @@ void scsi_target_reap(struct scsi_target *starget)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
+	if (list_empty(&starget->devices)) {
 		if (starget->state == STARGET_CREATED) {
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			starget->state = STARGET_DEL;
@@ -1516,8 +1515,13 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	if (scsi_host_scan_allowed(shost))
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	mutex_unlock(&shost->scan_mutex);
-	transport_configure_device(&starget->dev);
-	scsi_target_reap(starget);
+	/*
+	 * scsi_target_reap is called from the release function
+	 * of each sdev.
+	 */
+	if (starget->state != STARGET_DEL)
+		transport_configure_device(&starget->dev);
+
 	put_device(&starget->dev);
 
 	return sdev;
@@ -1595,10 +1599,12 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 	}
 
  out_reap:
-	/* now determine if the target has any children at all
-	 * and if not, nuke it */
-	transport_configure_device(&starget->dev);
-	scsi_target_reap(starget);
+	/*
+	 * scsi_target_reap is called from the release function
+	 * of each sdev.
+	 */
+	if (starget->state != STARGET_DEL)
+		transport_configure_device(&starget->dev);
 
 	put_device(&starget->dev);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index bd49d4e..4db0fed 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -297,7 +297,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	starget = to_scsi_target(parent);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
@@ -937,7 +936,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	struct scsi_device *sdev;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
@@ -950,7 +948,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	scsi_target_reap(starget);
 }
 
 static int __remove_child (struct device * dev, void * data)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f6a9fe0..ccc437b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -196,7 +196,6 @@ struct scsi_target {
 	struct list_head	siblings;
 	struct list_head	devices;
 	struct device		dev;
-	unsigned int		reap_ref; /* protected by the host lock */
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
-- 
1.5.3.2


--------------050407030103030004010009
Content-Type: text/x-patch;
 name="0003-Improve-error-messages-in-scsi_sysfs_add_sdev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0003-Improve-error-messages-in-scsi_sysfs_add_sdev.patch"

>From b15634110e53a8418378c952bd1b6488f2746f86 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@acerbis.suse.de>
Date: Mon, 25 Feb 2008 03:39:28 +0100
Subject: [PATCH] Improve error messages in scsi_sysfs_add_sdev()

When we fail to add a device to the driver core, only the very
helpful message 'error X' is displayed.
Print out some more meaningful messages.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4db0fed..8f674ac 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -830,12 +830,14 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		put_device(sdev->sdev_gendev.parent);
-		printk(KERN_INFO "error 1\n");
+		sdev_printk(KERN_INFO, sdev,
+			    "failed to add device: %d\n", error);
 		return error;
 	}
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
+		sdev_printk(KERN_INFO, sdev,
+			    "failed to add class device: %d\n", error);
 		goto clean_device;
 	}
 
-- 
1.5.3.2


--------------050407030103030004010009
Content-Type: text/x-patch;
 name="0004-Remove-stale-put_device-from-scsi_sysfs_add_sdev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0004-Remove-stale-put_device-from-scsi_sysfs_add_sdev.patch"

>From f1717cf66290b81f9b376ddeba65426c91fb7fe4 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@acerbis.suse.de>
Date: Sat, 8 Mar 2008 18:01:40 +0100
Subject: [PATCH] Remove stale put_device() from scsi_sysfs_add_sdev()

In one obscure error path someone decided to do a put_device()
on the sdev parent.
This doesn't make much sense as we didn't take the reference
previously. So remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8f674ac..7dc3015 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -829,7 +829,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
 		sdev_printk(KERN_INFO, sdev,
 			    "failed to add device: %d\n", error);
 		return error;
-- 
1.5.3.2


--------------050407030103030004010009
Content-Type: text/x-patch;
 name="0005-Implement-SDEV_NEW-state.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0005-Implement-SDEV_NEW-state.patch"

>From 57109790e4cb53561f36d73a8efc7b9abd2736a9 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@acerbis.suse.de>
Date: Sat, 8 Mar 2008 18:04:13 +0100
Subject: [PATCH] Implement SDEV_NEW state

When a scsi_device is allocated it's state is set to SDEV_CREATED.
However, we don't have any chance to detect if slave_alloc() has
run successfully or not.
This patch introduces a state SDEV_NEW which is used instead of
SDEV_CREATED upon initial sdev creation. After slave_alloc() has
run successfully the state is changed to SDEV_CREATED.
This allows us to detect later on if we might call slave_destroy()
or not.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    |   17 +++++++++++++----
 drivers/scsi/scsi_scan.c   |    9 ++++++++-
 drivers/scsi/scsi_sysfs.c  |    1 +
 include/scsi/scsi_device.h |    3 ++-
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..c398767 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1999,12 +1999,21 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		return 0;
 
 	switch (state) {
-	case SDEV_CREATED:
+	case SDEV_NEW:
 		/* There are no legal states that come back to
-		 * created.  This is the manually initialised start
+		 * new.  This is the manually initialised start
 		 * state */
 		goto illegal;
-			
+
+	case SDEV_CREATED:
+		switch (oldstate) {
+		case SDEV_NEW:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
 	case SDEV_RUNNING:
 		switch (oldstate) {
 		case SDEV_CREATED:
@@ -2064,7 +2073,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 
 	case SDEV_DEL:
 		switch (oldstate) {
-		case SDEV_CREATED:
+		case SDEV_NEW:
 		case SDEV_RUNNING:
 		case SDEV_OFFLINE:
 		case SDEV_CANCEL:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2feab2a..aa632f9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -253,7 +253,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->id = starget->id;
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
-	sdev->sdev_state = SDEV_CREATED;
+	sdev->sdev_state = SDEV_NEW;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
@@ -307,9 +307,16 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 			 */
 			if (ret == -ENXIO)
 				display_failure_msg = 0;
+			/*
+			 * sdev remains in SDEV_NEW as the release
+			 * function has to know whether slave_alloc()
+			 * failed or not.
+			 */
 			goto out_device_destroy;
 		}
 	}
+	/* Device is created properly */
+	scsi_device_set_state(sdev, SDEV_CREATED);
 
 	return sdev;
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7dc3015..3ec76dd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -27,6 +27,7 @@ static const struct {
 	enum scsi_device_state	value;
 	char			*name;
 } sdev_states[] = {
+	{ SDEV_NEW, "new" },
 	{ SDEV_CREATED, "created" },
 	{ SDEV_RUNNING, "running" },
 	{ SDEV_CANCEL, "cancel" },
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ccc437b..1616b26 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -28,7 +28,8 @@ struct scsi_mode_data {
  * scsi_lib:scsi_device_set_state().
  */
 enum scsi_device_state {
-	SDEV_CREATED = 1,	/* device created but not added to sysfs
+	SDEV_NEW = 1,		/* device created, slave_alloc has not run */
+	SDEV_CREATED,		/* device created but not added to sysfs
 				 * Only internal commands allowed (for inq) */
 	SDEV_RUNNING,		/* device properly configured
 				 * All commands allowed */
-- 
1.5.3.2


--------------050407030103030004010009
Content-Type: text/x-patch;
 name="0006-Rename-__scsi_remove_device-into-scsi_sysfs_remove.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0006-Rename-__scsi_remove_device-into-scsi_sysfs_remove.patc";
 filename*1="h"

>From a2d6ea3b183edc7a71f33e66fce63088c0f3e8a1 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@acerbis.suse.de>
Date: Mon, 25 Feb 2008 04:17:51 +0100
Subject: [PATCH] Rename __scsi_remove_device() into scsi_sysfs_remove_sdev()

__scsi_remove_device() is actually the counterpart to
scsi_sysfs_add_sdev(). So we'd better rename it to avoid
confusion.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_priv.h  |    2 +-
 drivers/scsi/scsi_scan.c  |    4 ++--
 drivers/scsi/scsi_sysfs.c |   10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b33e725..4ff548c 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -112,13 +112,13 @@ extern void scsi_exit_sysctl(void);
 
 /* scsi_sysfs.c */
 extern int scsi_sysfs_add_sdev(struct scsi_device *);
+extern void scsi_sysfs_remove_sdev(struct scsi_device *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
 extern void scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
-extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
 extern struct attribute_group *scsi_sysfs_shost_attr_groups[];
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index aa632f9..971ac9e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1131,7 +1131,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 			if (scsi_device_get(sdev) == 0) {
 				*sdevp = sdev;
 			} else {
-				__scsi_remove_device(sdev);
+				scsi_sysfs_remove_sdev(sdev);
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
 		}
@@ -1881,7 +1881,7 @@ void scsi_forget_host(struct Scsi_Host *shost)
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		__scsi_remove_device(sdev);
+		scsi_sysfs_remove_sdev(sdev);
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 3ec76dd..0f33b99 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -851,7 +851,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
 	if (error) {
-		__scsi_remove_device(sdev);
+		scsi_sysfs_remove_sdev(sdev);
 		goto out;
 	}
 	if (sdev->host->hostt->change_queue_type)
@@ -859,7 +859,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
 	if (error) {
-		__scsi_remove_device(sdev);
+		scsi_sysfs_remove_sdev(sdev);
 		goto out;
 	}
 
@@ -879,7 +879,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 			error = device_create_file(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
-				__scsi_remove_device(sdev);
+				scsi_sysfs_remove_sdev(sdev);
 				goto out;
 			}
 		}
@@ -899,7 +899,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	return error;
 }
 
-void __scsi_remove_device(struct scsi_device *sdev)
+void scsi_sysfs_remove_sdev(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
 
@@ -926,7 +926,7 @@ void scsi_remove_device(struct scsi_device *sdev)
 	struct Scsi_Host *shost = sdev->host;
 
 	mutex_lock(&shost->scan_mutex);
-	__scsi_remove_device(sdev);
+	scsi_sysfs_remove_sdev(sdev);
 	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
-- 
1.5.3.2


--------------050407030103030004010009
Content-Type: text/x-patch;
 name="0007-Remove-stale-reap_ref-reference.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0007-Remove-stale-reap_ref-reference.patch"

>From 96841a56d0127229a74d5555830759838ff06454 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@acerbis.suse.de>
Date: Sat, 8 Mar 2008 18:37:22 +0100
Subject: [PATCH] Remove stale reap_ref reference

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 971ac9e..6130495 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -409,7 +409,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	}
 	dev = &starget->dev;
 	device_initialize(dev);
-	starget->reap_ref = 1;
 	dev->parent = get_device(parent);
 	sprintf(dev->bus_id, "target%d:%d:%d",
 		shost->host_no, channel, id);
-- 
1.5.3.2


--------------050407030103030004010009--
