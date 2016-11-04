From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Fri, 4 Nov 2016 12:17:03 -0600
Message-ID: <d31b2a7f-d591-0c78-9ddf-b9bbee89d832@sandisk.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
 <1477706936.2850.27.camel@linux.vnet.ibm.com>
 <96320196-4074-c970-97f0-bffb74713990@sandisk.com>
 <1478267240.3287.8.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------40993D4FE954B5CFE0226D44"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0072.outbound.protection.outlook.com ([104.47.32.72]:43679
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938605AbcKDSRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Nov 2016 14:17:18 -0400
In-Reply-To: <1478267240.3287.8.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--------------40993D4FE954B5CFE0226D44
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 11/04/2016 07:47 AM, James Bottomley wrote:
> You know after
>
> if (device_remove_file_self(dev, attr))
>
> returns true that s_active is held and also that KERNFS_SUICIDAL is set
> on the node, so the non-self remove paths can simply check for this
> flag and return without descending into __kernfs_remove(), which would
> mean they never take s_active.  That means we never get the inversion.

Hello James,

The lock inversion is not triggered by the non-self remove paths but by 
the self-remove path. Anyway, can you have a look at the two attached 
patches?

Thanks,

Bart.


--------------40993D4FE954B5CFE0226D44
Content-Type: text/x-patch;
	name="0001-kernfs-Introduce-a-local-variable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-kernfs-Introduce-a-local-variable.patch"

>From dfd0bfa8b15e8d56a4f1ca3dc781439d10d0b098 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Fri, 4 Nov 2016 10:18:52 -0600
Subject: [PATCH 1/2] kernfs: Introduce a local variable

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 fs/kernfs/file.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 78219d5..da58ea4 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -186,6 +186,7 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 				       loff_t *ppos)
 {
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
+	struct kernfs_node *kn = of->kn;
 	const struct kernfs_ops *ops;
 	char *buf;
 
@@ -202,20 +203,20 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!kernfs_get_active(of->kn)) {
+	if (!kernfs_get_active(kn)) {
 		len = -ENODEV;
 		mutex_unlock(&of->mutex);
 		goto out_free;
 	}
 
-	of->event = atomic_read(&of->kn->attr.open->event);
-	ops = kernfs_ops(of->kn);
+	of->event = atomic_read(&kn->attr.open->event);
+	ops = kernfs_ops(kn);
 	if (ops->read)
 		len = ops->read(of, buf, len, *ppos);
 	else
 		len = -EINVAL;
 
-	kernfs_put_active(of->kn);
+	kernfs_put_active(kn);
 	mutex_unlock(&of->mutex);
 
 	if (len < 0)
@@ -274,6 +275,7 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
 	struct kernfs_open_file *of = kernfs_of(file);
+	struct kernfs_node *kn = of->kn;
 	const struct kernfs_ops *ops;
 	size_t len;
 	char *buf;
@@ -305,19 +307,19 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
 	 * the ops aren't called concurrently for the same open file.
 	 */
 	mutex_lock(&of->mutex);
-	if (!kernfs_get_active(of->kn)) {
+	if (!kernfs_get_active(kn)) {
 		mutex_unlock(&of->mutex);
 		len = -ENODEV;
 		goto out_free;
 	}
 
-	ops = kernfs_ops(of->kn);
+	ops = kernfs_ops(kn);
 	if (ops->write)
 		len = ops->write(of, buf, len, *ppos);
 	else
 		len = -EINVAL;
 
-	kernfs_put_active(of->kn);
+	kernfs_put_active(kn);
 	mutex_unlock(&of->mutex);
 
 	if (len > 0)
-- 
2.10.1


--------------40993D4FE954B5CFE0226D44
Content-Type: text/x-patch;
	name="0002-Avoid-that-SCSI-device-removal-through-sysfs-trigger.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0002-Avoid-that-SCSI-device-removal-through-sysfs-trigger.pa";
	filename*1="tch"

>From f092fc1d40f3746c417e979985346ba169af7a6d Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Fri, 4 Nov 2016 10:07:23 -0600
Subject: [PATCH 2/2] Avoid that SCSI device removal through sysfs triggers a
 deadlock

The SCSI core holds scan_mutex around SCSI device addition and
removal operations. sysfs serializes attribute read and write
operations against attribute removal through s_active. Avoid that
grabbing scan_mutex during self-removal of a SCSI device triggers
a deadlock by re-grabbing s_active after self-removal has finished
instead of after kernfs_remove_self() has finished.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 fs/kernfs/dir.c        | 19 +++++++++++++------
 fs/kernfs/file.c       |  7 +++++++
 include/linux/kernfs.h |  1 +
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index cf4c636..abd3481 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -426,6 +426,8 @@ void kernfs_put_active(struct kernfs_node *kn)
 	if (unlikely(!kn))
 		return;
 
+	WARN_ON_ONCE(kn->flags & KERNFS_BROKE_A_P);
+
 	if (kernfs_lockdep(kn))
 		rwsem_release(&kn->dep_map, 1, _RET_IP_);
 	v = atomic_dec_return(&kn->active);
@@ -1314,6 +1316,9 @@ void kernfs_unbreak_active_protection(struct kernfs_node *kn)
  * kernfs_remove_self - remove a kernfs_node from its own method
  * @kn: the self kernfs_node to remove
  *
+ * If kernfs_remove_self() sets KERNFS_BROKE_A_P the caller must invoke
+ * kernfs_unbreak_active_protection().
+ *
  * The caller must be running off of a kernfs operation which is invoked
  * with an active reference - e.g. one of kernfs_ops.  This can be used to
  * implement a file operation which deletes itself.
@@ -1354,6 +1359,7 @@ bool kernfs_remove_self(struct kernfs_node *kn)
 	 */
 	if (!(kn->flags & KERNFS_SUICIDAL)) {
 		kn->flags |= KERNFS_SUICIDAL;
+		kn->flags |= KERNFS_BROKE_A_P;
 		__kernfs_remove(kn);
 		kn->flags |= KERNFS_SUICIDED;
 		ret = true;
@@ -1375,13 +1381,14 @@ bool kernfs_remove_self(struct kernfs_node *kn)
 		finish_wait(waitq, &wait);
 		WARN_ON_ONCE(!RB_EMPTY_NODE(&kn->rb));
 		ret = false;
-	}
 
-	/*
-	 * This must be done while holding kernfs_mutex; otherwise, waiting
-	 * for SUICIDED && deactivated could finish prematurely.
-	 */
-	kernfs_unbreak_active_protection(kn);
+		/*
+		 * This must be done while holding kernfs_mutex; otherwise,
+		 * waiting for SUICIDED && deactivated could finish
+		 * prematurely.
+		 */
+		kernfs_unbreak_active_protection(kn);
+	}
 
 	mutex_unlock(&kernfs_mutex);
 	return ret;
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index da58ea4..be2e540 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -319,6 +319,13 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
 	else
 		len = -EINVAL;
 
+	mutex_lock(&kernfs_mutex);
+	if (kn->flags & KERNFS_BROKE_A_P) {
+		kernfs_unbreak_active_protection(kn);
+		kn->flags &= ~KERNFS_BROKE_A_P;
+	}
+	mutex_unlock(&kernfs_mutex);
+
 	kernfs_put_active(kn);
 	mutex_unlock(&of->mutex);
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 7056238..34de7f1 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -46,6 +46,7 @@ enum kernfs_node_flag {
 	KERNFS_SUICIDAL		= 0x0400,
 	KERNFS_SUICIDED		= 0x0800,
 	KERNFS_EMPTY_DIR	= 0x1000,
+	KERNFS_BROKE_A_P	= 0x2000,
 };
 
 /* @flags for kernfs_create_root() */
-- 
2.10.1


--------------40993D4FE954B5CFE0226D44--
