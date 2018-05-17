From: Anatoliy Glagolev <glagolig@gmail.com>
Subject: [PATCH] Bsg referencing parent device
Date: Wed, 16 May 2018 19:02:17 -0600
Message-ID: <20180517010214.GA18978@xldev-tmpl.dev.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com
List-Id: linux-scsi@vger.kernel.org

A follow-up on earlier discussions:
[PATCH] bsg referencing bus driver module
https://www.spinics.net/lists/linux-scsi/msg119631.html
[PATCH] Waiting for scsi_host_template release
https://www.spinics.net/lists/linux-scsi/msg119432.html

All these discussions are attempts to fix a crash after
SCSI transport driver unload if a user-mode process
holds a handle in BSG layer towards the unloaded driver
via SCSI mid-layer:

[16834.636216,07] Call Trace:
                             ...   scsi_proc_hostdir_rm
[16834.641944,07]  [<ffffffff8141723f>] scsi_host_dev_release+0x3f/0x130
[16834.647740,07]  [<ffffffff813e4f82>] device_release+0x32/0xa0
[16834.653423,07]  [<ffffffff812dc6c7>] kobject_cleanup+0x77/0x190
[16834.659002,07]  [<ffffffff812dc585>] kobject_put+0x25/0x50
[16834.664430,07]  [<ffffffff813e5277>] put_device+0x17/0x20
[16834.669740,07]  [<ffffffff812d0334>] bsg_kref_release_function+0x24/0x30
[16834.675007,07]  [<ffffffff812d14a6>] bsg_release+0x166/0x1d0
[16834.680148,07]  [<ffffffff8119ba2b>] __fput+0xcb/0x1d0
[16834.685156,07]  [<ffffffff8119bb6e>] ____fput+0xe/0x10
[16834.690017,07]  [<ffffffff81077476>] task_work_run+0x86/0xb0
[16834.694781,07]  [<ffffffff81057043>] exit_to_usermode_loop+0x6b/0x9a
[16834.699466,07]  [<ffffffff81002875>] syscall_return_slowpath+0x55/0x60
[16834.704110,07]  [<ffffffff8172d615>] int_ret_from_sys_call+0x25/0x9f

The latest input from earlier discussions was to cut off access
to the unloaded driver at bsg_unregister_queue time by calling
blk_cleanup_queue. If we do that we still have to release
the reference to the parent device (otherwise we crash with
the same stack). The next logical step is, rather than maintaining
a "part-time" reference to be dropped early, we discard
referencing completely.
Discarding the reference turns out to be the only thing needed
to fix the problem: all transport drivers already do blk_cleanup_queue
before releasing their reference to the parent device.

>From 7eaa9b43f0b99766b1d197044eb4d2e549d11a24 Mon Sep 17 00:00:00 2001
From: Anatoliy Glagolev <glagolig@gmail.com>
Date: Wed, 16 May 2018 17:03:09 -0600
Subject: [PATCH] Bsg referencing parent device
Signed-off-by: Anatoliy Glagolev <glagolig@gmail.com>

Bsg holding reference to a parent device may result in a crash
if user closes a bsg file handle after the parent device driver
has unloaded.
Holding a reference is not really needed: parent device must exist
between bsg_register_queue and bsg_unregister_queue. Before
the device goes away the caller does blk_cleanup_queue so that
all in-flight requests to the device are gone and all new requests
cannot pass beyond the queue. The queue itself is a refcounted
object and it will stay alive with a bsg file.
---
 block/bsg.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index defa06c..f9e4b91 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -650,18 +650,6 @@ static struct bsg_device *bsg_alloc_device(void)
 	return bd;
 }
 
-static void bsg_kref_release_function(struct kref *kref)
-{
-	struct bsg_class_device *bcd =
-		container_of(kref, struct bsg_class_device, ref);
-	struct device *parent = bcd->parent;
-
-	if (bcd->release)
-		bcd->release(bcd->parent);
-
-	put_device(parent);
-}
-
 static int bsg_put_device(struct bsg_device *bd)
 {
 	int ret = 0, do_free;
@@ -694,7 +682,6 @@ static int bsg_put_device(struct bsg_device *bd)
 
 	kfree(bd);
 out:
-	kref_put(&q->bsg_dev.ref, bsg_kref_release_function);
 	if (do_free)
 		blk_put_queue(q);
 	return ret;
@@ -760,8 +747,6 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 	 */
 	mutex_lock(&bsg_mutex);
 	bcd = idr_find(&bsg_minor_idr, iminor(inode));
-	if (bcd)
-		kref_get(&bcd->ref);
 	mutex_unlock(&bsg_mutex);
 
 	if (!bcd)
@@ -772,8 +757,6 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 		return bd;
 
 	bd = bsg_add_device(inode, bcd->queue, file);
-	if (IS_ERR(bd))
-		kref_put(&bcd->ref, bsg_kref_release_function);
 
 	return bd;
 }
@@ -902,6 +885,8 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 void bsg_unregister_queue(struct request_queue *q)
 {
+	struct device *parent;
+	void (*release)(struct device *dev);
 	struct bsg_class_device *bcd = &q->bsg_dev;
 
 	if (!bcd->class_dev)
@@ -913,8 +898,21 @@ void bsg_unregister_queue(struct request_queue *q)
 		sysfs_remove_link(&q->kobj, "bsg");
 	device_unregister(bcd->class_dev);
 	bcd->class_dev = NULL;
-	kref_put(&bcd->ref, bsg_kref_release_function);
+	parent = bcd->parent;
+	release = bcd->release;
+	bcd->parent = NULL;
+	bcd->release = NULL;
 	mutex_unlock(&bsg_mutex);
+
+	/*
+	 * The caller of bsg_[un]register_queue must hold a reference
+	 * to the parent device between ..register.. and ..unregister..
+	 * so we do not maintain a refcount to parent here.
+	 * Note: the caller is expected to blk_cleanup_queue(q)
+	 * before releasing the reference to the parent device.
+	 */
+	if (release)
+		release(parent);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
@@ -955,10 +953,9 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 
 	bcd->minor = ret;
 	bcd->queue = q;
-	bcd->parent = get_device(parent);
+	bcd->parent = parent;
 	bcd->release = release;
 	bcd->ops = ops;
-	kref_init(&bcd->ref);
 	dev = MKDEV(bsg_major, bcd->minor);
 	class_dev = device_create(bsg_class, parent, dev, NULL, "%s", devname);
 	if (IS_ERR(class_dev)) {
-- 
1.9.1
