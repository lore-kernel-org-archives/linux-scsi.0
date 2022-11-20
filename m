Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B5DC43217
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Nov 2022 03:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKTDOe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Nov 2022 22:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKTDOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Nov 2022 22:14:33 -0500
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6799A26D;
        Sat, 19 Nov 2022 19:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=KMKfHSu6apMfgPIdOsoq6k6Aa8UTe85BtVoAlZrfyCo=; b=dQDm+gAL6Ya9r/NBfrRe24ehIm
        +QVWG74pU7HAq25XAVQqTOeQX0uKd10tvkGW3my5ZPHa7xvq1HlXPpYGO2RXEtWww2K7KhBWqi+wN
        lPg+iSKN5PqBetBVLGKBlPrs0dtg9jUyQoAcYh8VDYeCvMbIJdQbznxZRMPuD5XHD1StGyd9lsTsM
        dTUxoPiZUcOftCTJTFOCJbhN4ZwL1jEeeiih7hHxNTzXix+HHO0uUYJjtamYtxzH6yLwJz2nKqDi1
        TssUtkKrUg1jKAZox1VIQirYMBSnebcdLDxf8Nrv2eV182VDDHOMrfzsJJCRON4LyPSExpyvu0YZw
        iXAfjpHQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1owamn-005CZ0-1o;
        Sun, 20 Nov 2022 03:14:25 +0000
Date:   Sun, 20 Nov 2022 03:14:25 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH][RFC] fix a race between bsg_open() and bsg_unregister_queue()
Message-ID: <Y3mbkZCESLLRMQNq@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

	Consider the following scenario:

task A: open() on /dev/bsg/<something>
	calls chrdev_open()
	finds and grabs a reference to bsg_device.cdev in inode->i_cdev
	refcount on that cdev is 2 now (1 from creation + 1 we'd just grabbed)
	calls bsg_open().
	fetches to_bsg_device(inode)->queue - that would be ->queue in the
	same bsg_device instance.
	gets preempted away and loses CPU before it gets to calling blk_get_queue().

task B: calls bsg_unregister_queue() on the same queue, which calls
	cdev_device_del(), which makes cdev impossible to look up and
	drops the reference to that cdev; refcount is 1 now, so nothing gets
	freed yet.
	caller of bsg_unregister_queue() proceeds to destroy the queue and
	free it, allowing reuse of memory that used to contain it.

task A: regains CPU
	calls blk_get_queue() on something that no longer points to
	a request_queue instance.  In particular, "dying" flag is no longer
	guaranteed to be there, so we proceed to increment what we think is
	a queue refcount, corrupting whatever lives in that memory now.

Usually we'll end up with memory not reused yet, and blk_get_queue() will
fail without buggering anything up.  Not guaranteed, though...

AFAICS, the fact that request_queue freeing is RCU-delayed means that
it can be fixed by the following:
	* mark bsg_device on bsg_unregister_queue() as goner
	* have bsg_open() do rcu_read_lock(), then check that flag and do
blk_get_queue() only if the flag hadn't been set yet.  If we did not observe
the flag after rcu_read_lock(), we know that queue have been freed yet
- RCU delay couldn't have run out.

Comments?

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/block/bsg.c b/block/bsg.c
index 2ab1351eb082..643641087691 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -28,6 +28,7 @@ struct bsg_device {
 	unsigned int timeout;
 	unsigned int reserved_size;
 	bsg_sg_io_fn *sg_io_fn;
+	bool goner;
 };
 
 static inline struct bsg_device *to_bsg_device(struct inode *inode)
@@ -71,9 +72,14 @@ static int bsg_sg_io(struct bsg_device *bd, fmode_t mode, void __user *uarg)
 
 static int bsg_open(struct inode *inode, struct file *file)
 {
-	if (!blk_get_queue(to_bsg_device(inode)->queue))
-		return -ENXIO;
-	return 0;
+	struct bsg_device *bd = to_bsg_device(inode);
+	int err = 0;
+
+	rcu_read_lock();
+	if (bd->goner || !blk_get_queue(bd->queue))
+		err = -ENXIO;
+	rcu_read_unlock();
+	return err;
 }
 
 static int bsg_release(struct inode *inode, struct file *file)
@@ -175,6 +181,7 @@ static void bsg_device_release(struct device *dev)
 
 void bsg_unregister_queue(struct bsg_device *bd)
 {
+	bd->goner = true;
 	if (bd->queue->kobj.sd)
 		sysfs_remove_link(&bd->queue->kobj, "bsg");
 	cdev_device_del(&bd->cdev, &bd->device);
